#! /usr/bin/bash

game_state=(' ' ' ' ' ' ' ' ' ' ' ' ' ' ' ' ' ')
current_player='o'
winner='o'



function introduction()
{
    echo -e "This is a game of tic tac toe. \nThere are two players 'o' and 'x' each taking turns. \nPress q to quit\n"
}

function check_for_quit()
{

    if [[ $1 = "q" || $1 = "Q" ]]; then 
        exit 1
    fi
}

function print_game_state()
{   
    for i in {0..2}
    do
        echo " ${game_state[$((3*i + 0))]} |  ${game_state[$((3*i + 1))]} |  ${game_state[$((3*i + 2))]}"
        echo "--------------"
    done
   
}


function check_for_win()
{
    local has_won=0

        # rows
        for i in 0 3 6
        do
            for j in 0 1 2
            do
                if ! [[ "${game_state[$((i+j))]}" == "$current_player" ]]; then
                    break
                elif [ $j -eq 2 ]; then
                    has_won=1
                    return 1
                fi

            done
        done

         # columns
        for i in 0 1 2
        do
            for j in 0 3 6
            do
                if ! [[ "${game_state[$((i+j))]}" == "$current_player" ]]; then
                    break
                elif [ $j -eq 6 ]; then
                    has_won=1
                    return 1
                fi
                
            done
        done

    # diagonals
    if [[ "${game_state[0]}" == "${game_state[4]}" && "${game_state[4]}" == "${game_state[8]}" &&  "${game_state[4]}" == "$current_player" ]]; then
        return 1
    elif [[ "${game_state[2]}" == "${game_state[4]}" && "${game_state[4]}" == "${game_state[6]}" &&  "${game_state[4]}" == "$current_player" ]]; then
        return 1
    fi

 return 0
}


function player_move()
{
    
    local was_input_handled=0

    while [ $was_input_handled -eq 0 ]; do

        echo "It's player $current_player turn"
        read -p 'Insert the field number (1-9) or quit (q) : ' field_number

        check_for_quit "$field_number"

        if [[ $field_number -lt 1 ||  $field_number -gt 9 ]]; then
        echo "The entered number is out of scope. Enter a value between 1 and 9"

        else 
            local read_field_value=${game_state[$(($field_number - 1))]}
         

            if ! [[ "$read_field_value"  == ' ' ]]; then
                echo "The entered field is already taken by $read_field_value"

            else 
                game_state[$(($field_number - 1))]=$current_player
                was_input_handled=1
            fi

        fi
    done


}

function switch_current_player()
{
    if [[ "$current_player" == 'o' ]]; then
    current_player='x'
    else
    current_player='o'
    fi
}

function game_loop
{
    introduction
    local is_current_player_winner=0
    while [ 1 ]; do

 
        print_game_state
        player_move

        check_for_win
        is_current_player_winner=$?
      

        if [ $is_current_player_winner -eq 1 ]; then
        break
        fi

        switch_current_player

    done 
    print_game_state
    echo "Player $current_player won!"
}


game_loop


