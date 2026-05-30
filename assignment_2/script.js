function placeWallEndingsAt (levelBeingPoint: Position, levelWidth: number, levelLength: number, placementHeight: number) {
    blocks.fill(
        LOG_SPRUCE,
        positions.add(
            levelBeingPoint,
            pos(0, placementHeight, 0)
            ),
        positions.add(
            levelBeingPoint,
            pos(levelWidth - 1, placementHeight, levelLength - 1)
            ),
        FillOperation.Replace
        )

    blocks.fill(
        AIR,
        positions.add(
            levelBeingPoint,
            pos(1, placementHeight, 1)
            ),
        positions.add(
            levelBeingPoint,
            pos(levelWidth - 2, placementHeight, levelLength - 2)
            ),
        FillOperation.Replace
        )

    for (let i = 0; i <= levelWidth - 1; i++) {
        if (i % 2 == 0) {
            blocks.place(
                LOG_SPRUCE, 
                positions.add(
                    levelBeingPoint,
                    pos(i, placementHeight + 1, 0)
            ))

            blocks.place(
                LOG_SPRUCE, 
                    positions.add(
                    positions.add(
                        levelBeingPoint,
                        pos(0, placementHeight + 1, levelLength - 1)
                        ),
                    pos(i, 0, 0)
                    )
            )
        }
    }

    for (let j = 0; j <= levelLength - 1; j++) {
        if (j % 2 == 1) {
            blocks.place(
                LOG_SPRUCE, 
                positions.add(
                    levelBeingPoint,
                    pos(0, placementHeight + 1, j)
                    ))

            blocks.place(
                LOG_SPRUCE, 
                positions.add(
                    positions.add(
                    levelBeingPoint,
                    pos(levelWidth - 1, placementHeight + 1, 0)
                    ),
                    pos(0, 0, j)
                    ))
        }
    }
}


function placeSecondLevelAt (basePoint: Position, endPoint: Position, levelHeight: number) {
    secondLevelEase = 4
    secondLevelBegin = 
        positions.add(
            basePoint,
            pos(secondLevelEase, levelHeight, secondLevelEase - 1)
            )

    secondLevelEnding = 
        positions.add(
            endPoint,
            pos(0 - secondLevelEase, levelHeight, 0 - secondLevelEase + 1)
            )

    blocks.fill(
        PLANKS_SPRUCE,
        secondLevelBegin,
        secondLevelEnding,
        FillOperation.Hollow
        )
}


function castleLevelAt (basePoint: Position, levelWidth: number, levelHeight: number, levelLength: number) {
    subLevelHeight = Math.floor(levelHeight * 0.7)
    subLevelShrink = 1
    blocks.fill(
        COBBLESTONE,
        positions.add(
        basePoint,
        pos(subLevelShrink, 0, subLevelShrink)
        ),
        positions.add(
        basePoint,
        pos(levelWidth - subLevelShrink - 1, subLevelHeight, levelLength - subLevelShrink - 1)
        ),
        FillOperation.Hollow
        )

    blocks.fill(
        STONE_BRICK_MONSTER_EGG,
        positions.add(
        basePoint,
        pos(0, subLevelHeight, 0)
        ),
        positions.add(
        basePoint,
        pos(levelWidth - 1, levelHeight - 1, levelLength - 1)
        ),
        FillOperation.Hollow
        )
    }


function placeWindows (levelBegin: Position, lvlWidth: number, lvlHeight: number, lvlLength: number) {
    let window1Pos = positions.add(
        levelBegin,
        pos(lvlWidth / 4, 2, 0)
        )
    let window2Pos = positions.add(
        levelBegin,
        pos(Math.ceil(lvlWidth * 0.75), 2, 0)
        )
    let window3Pos = positions.add(
        levelBegin,
        pos(lvlWidth / 4, 2, lvlLength - 1)
        )
    let window4Pos = positions.add(
        levelBegin,
        pos(Math.ceil(lvlWidth * 0.75), 2, lvlLength - 1)
        )

    let windows = [
    window1Pos,
    window2Pos,
    window3Pos,
    window4Pos
    ]

    for (let windowPos of windows) {
        blocks.fill(
            GLASS,
            windowPos,
            positions.add(
                windowPos,
                pos(-1, Math.floor(lvlHeight * 0.5), 0)
                ),
            FillOperation.Replace
            )
    }
}


function placeFlagAt (flagPos: Position) {
    blocks.fill(
        SPRUCE_FENCE,
        flagPos,
        positions.add(
        flagPos,
        pos(0, 6, 0)
        ),
        FillOperation.Replace
        )

    blocks.fill(
        RED_WOOL,
        positions.add(
        flagPos,
        pos(1, 6, 0)
        ),
        positions.add(
        flagPos,
        pos(3, 5, 0)
        ),
        FillOperation.Replace
        )
}



let subLevelShrink = 0
let subLevelHeight = 0
let secondLevelEase = 0
let secondLevelBegin: Position = null
let secondLevelEnding: Position = null
let startingPosition: Position = null
let length = 16
let width = 20
let height = 8


agent.teleport(pos(1, 0, 1), NORTH)
startingPosition = positions.add(
    agent.getPosition(),
    pos(1, 0, 1)
    )
let endingPosition = positions.add(
    startingPosition,
    pos(width - 1, height - 1, length - 1)
    )

castleLevelAt(startingPosition, width, height, length)
placeWallEndingsAt(startingPosition, width, length, height)
placeSecondLevelAt(startingPosition, endingPosition, height)
let secondLevelWidth = secondLevelEnding.getValue(Axis.X) - secondLevelBegin.getValue(Axis.X) + 1
let secondLevelHeight = secondLevelEnding.getValue(Axis.Y) - secondLevelBegin.getValue(Axis.Y) + 4
let secondLevelLength = secondLevelEnding.getValue(Axis.Z) - secondLevelBegin.getValue(Axis.Z) + 1
secondLevelHeight = Math.ceil(secondLevelHeight * 0.7)

placeWallEndingsAt(secondLevelBegin, secondLevelWidth, secondLevelLength, secondLevelHeight)
placeFlagAt(positions.add(
    secondLevelBegin,
    pos(secondLevelWidth / 2, secondLevelHeight, secondLevelLength / 2)
    ))
placeWindows(secondLevelBegin, secondLevelWidth, secondLevelHeight, secondLevelLength)
