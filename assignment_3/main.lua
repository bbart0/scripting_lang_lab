
local ROWS = 10
local COLUMNS = 20
local SINGLE_CELL_WIDTH = 30
local PIECE_COLOR = 0.8
local BACKGROUND_COLOR = 0.05
local LINES_COLOR = 0.15

local board_state = {}
local current_active_piece

local game_over = false
local fall_delay = 0.5
local fallTimer = 0


local PIECES = {
    { 
        {1,1,1,1} 
    },
    { 
        {1,1},
        {1,1} 
    },
    { 
        {0,1,0},
        {1,1,1} 
    },
    { 
        {1,0},
        {1,0},
        {1,1} 
    },
    { 
        {0,1},
        {0,1},
        {1,1} 
    },
    
    { 
        {1,1,0},
        {0,1,1} 
    },
    
    { 
        {0,1,1},
        {1,1,0} 
    }
    
}




function init_board()
    board_state = {}

    for y = 1, COLUMNS
    do
        board_state[y] = {}

        for x = 1, ROWS 
        do
            board_state[y][x] = false
        end
    end
end


function copy_piece(shape)

    local result = {}
    for y = 1, #shape 
    do
        result[y] = {}

        for x = 1, #shape[y] 
        do
            result[y][x] = shape[y][x]
        end
    end
    return result
end


function rotate(shape)

    local height, width = #shape, #shape[1]
    local rotated_shape = {};

    for x = 1, width 
    do
        rotated_shape[x] = {}

        for y = 1, height 
        do
            rotated_shape[x][y] = shape[height - y + 1][x]
        end
    end

    return rotated_shape
end


function random_piece()
 
    local piece = PIECES[love.math.random(#PIECES)]

    return {
        x = math.floor(ROWS / 2),
        y = 1,
        shape = copy_piece(piece)
    }
end


function check_for_collision(x_position_to_check, y_position_to_check, shape)
    for y = 1, #shape do
        for x = 1, #shape[y] do
            
            if shape[y][x] == 1 then
                local x_coord_on_board = x_position_to_check + x - 1
                local y_coord_on_board = y_position_to_check + y - 1

                if x_coord_on_board < 1 or x_coord_on_board > ROWS or y_coord_on_board > COLUMNS then
                    return true
                end

                if y_coord_on_board >= 1 and board_state[y_coord_on_board][x_coord_on_board] then
                    return true
                end
            end

        end
    end

    return false
end


function write_active_piece_to_board()
    for y = 1, #current_active_piece.shape 
    do
        for x = 1, #current_active_piece.shape[y] 
        do
            
            if current_active_piece.shape[y][x] == 1 then

                local x_coord_on_board = current_active_piece.x + x - 1
                local y_coord_on_board = current_active_piece.y + y - 1

                if y_coord_on_board >= 1 then
                    board_state[y_coord_on_board][x_coord_on_board] = true
                end
            end

        end
    end
end


function move_down()
    if not check_for_collision(current_active_piece.x, current_active_piece.y + 1, current_active_piece.shape) then
        current_active_piece.y = current_active_piece.y + 1
    else
        write_active_piece_to_board()
        clear_lines()
        spawn_piece()
    end
end

function clear_lines()
    local removed_lines = 0

    for y = COLUMNS, 1, -1 
    do
        local is_full = true

        for x = 1, ROWS do
            if not board_state[y][x] then
                is_full = false
                break
            end
        end

        if is_full then
            table.remove(board_state, y)

            local new_row = {}
            for x = 1, ROWS do
                new_row[x] = false
            end

            table.insert(board_state, 1, new_row)

            removed_lines = removed_lines + 1
            y = y + 1
        end
    end

    if removed_lines > 0 then
        fall_delay = math.max(0.1, fall_delay - removed_lines * 0.02)
    end
end


function draw_single_cell(x, y)
    love.graphics.setColor(PIECE_COLOR, PIECE_COLOR, PIECE_COLOR)

    love.graphics.rectangle(
        "fill",
        (x - 1) * SINGLE_CELL_WIDTH,
        (y - 1) * SINGLE_CELL_WIDTH,
        SINGLE_CELL_WIDTH - 1,
        SINGLE_CELL_WIDTH - 1
    )
end

function spawn_piece()
    current_active_piece = random_piece()

    if check_for_collision(current_active_piece.x, current_active_piece.y, current_active_piece.shape) then
        game_over = true
    end
end


function restart()

    game_over = false
    fall_delay = 0.5
    fallTimer = 0

    init_board()
    spawn_piece()
end

function love.load()
    love.window.setTitle("Tetris")
    love.window.setMode(ROWS*SINGLE_CELL_WIDTH + 200, COLUMNS*SINGLE_CELL_WIDTH)

    math.randomseed(os.time())

    restart()
end



function love.update(dt)
    if game_over then
        return
    end

    fallTimer = fallTimer + dt

    if fallTimer >= fall_delay then
        fallTimer = 0
        move_down()
    end
end

function love.keypressed(key)
    if game_over then
        if key == "escape" then
            restart()
        end
        return
    end

    if key == "left" then
        if not check_for_collision(current_active_piece.x - 1, current_active_piece.y, current_active_piece.shape) then
            current_active_piece.x = current_active_piece.x - 1
        end

    elseif key == "right" then
        if not check_for_collision(current_active_piece.x + 1, current_active_piece.y, current_active_piece.shape) then
            current_active_piece.x = current_active_piece.x + 1
        end

    elseif key == "down" then
        move_down()

    elseif key == "z" then
        local rotated = rotate(current_active_piece.shape)

        if not check_for_collision(current_active_piece.x, current_active_piece.y, rotated) then
            current_active_piece.shape = rotated
        end

    elseif key == "space" then
        while not check_for_collision(current_active_piece.x, current_active_piece.y + 1, current_active_piece.shape) do
            current_active_piece.y = current_active_piece.y + 1
        end

        move_down()
    end
end


function love.draw()
    love.graphics.setBackgroundColor(BACKGROUND_COLOR,BACKGROUND_COLOR, BACKGROUND_COLOR)


    for y = 1, COLUMNS
        do
            for x = 1, ROWS 
            do
                if board_state[y][x] then
                    draw_single_cell(x, y)
                else
                    love.graphics.setColor(LINES_COLOR,LINES_COLOR, LINES_COLOR)
                    love.graphics.rectangle("line", (x - 1) * SINGLE_CELL_WIDTH, (y - 1) * SINGLE_CELL_WIDTH, SINGLE_CELL_WIDTH, SINGLE_CELL_WIDTH)
                end
            end
        end


    if current_active_piece then
        for y = 1, #current_active_piece.shape do
            for x = 1, #current_active_piece.shape[y] do
                if current_active_piece.shape[y][x] == 1 then
                    draw_single_cell(
                        current_active_piece.x + x - 1,
                        current_active_piece.y + y - 1
                    )
                end
            end
        end
    end


    love.graphics.setColor(1,1,1)

    local ui_offset = ROWS * SINGLE_CELL_WIDTH + 25

    love.graphics.print("Controls:", ui_offset, 120)
    love.graphics.print("Move - left and right arrow", ui_offset, 150)
    love.graphics.print("Rotate - Z", ui_offset, 180)
    love.graphics.print("Drop - down arrow", ui_offset, 210)
    love.graphics.print("Immediate drop - space", ui_offset, 240)

    if game_over then
        love.graphics.print("GAME OVER", ui_offset, 320)
        love.graphics.print("Press escape to restart", ui_offset, 350)
    end
end