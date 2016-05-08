import QtQuick 2.5

Shape {
    id: tItem
    property alias sleep:sleep
    bottomLeft.visible: false
    bottomRight.visible: false
    thirdRight.visible: false
    topRight.visible: false
    shapeColor: "#FFBF00"
    shapeHeight: topLeft.width * 3
    state: "UPRIGHT"
    shapeValue: 2
    rotation: 90

    states: [
           State { name: "UPRIGHT" },
           State { name: "UPSIDEDOWN" },
           State { name: "RIGHT" },
           State { name: "LEFT" },
           State { name: "STOP" },
           State { name: "GAMEOVER" }
       ]

    Keys.onPressed: {
        if(event.key === Qt.Key_Left)
        {
            if(state === "RIGHT" && x > 0 && grid.checkMoveLeft(Math.floor((y - referenceSquare.width) / referenceSquare.width), Math.floor((x - referenceSquare.width)/ referenceSquare.width), shapeValue) ||
                    state == "LEFT" && x > 0 && grid.checkMoveLeft(Math.floor((y + referenceSquare.width)/ referenceSquare.width), Math.floor((x - referenceSquare.width)/ referenceSquare.width), shapeValue) ||
                    state === "UPRIGHT"  && x >= topLeft.width  && grid.checkMoveLeft(Math.floor((y + referenceSquare.width) / referenceSquare.width), Math.floor(x/ referenceSquare.width), shapeValue) ||
                    state === "UPSIDEDOWN" && x > topLeft.width && grid.checkMoveLeft(Math.floor((y + referenceSquare.width) / referenceSquare.width), Math.floor((x - referenceSquare.width * 2)/ referenceSquare.width), shapeValue))
                        //x -= topLeft.width
                        x = --xCoord * topLeft.width
        }
        else if(event.key === Qt.Key_Right)
        {
            if(state === "RIGHT" && x < playArea.width - shapeWidth && grid.checkMoveRight(Math.floor((y - referenceSquare.width) / referenceSquare.width), Math.floor((x - referenceSquare.width)/ referenceSquare.width), shapeValue) ||
                    state === "LEFT" && x < playArea.width - shapeWidth && grid.checkMoveRight(Math.floor((y + referenceSquare.width)/ referenceSquare.width), Math.floor((x - referenceSquare.width)/ referenceSquare.width), shapeValue) ||
                    state === "UPRIGHT" && x < playArea.width - topLeft.width * 3 && grid.checkMoveRight(Math.floor((y + referenceSquare.width) / referenceSquare.width), Math.floor(x/ referenceSquare.width), shapeValue)||
                    state === "UPSIDEDOWN" && x <= playArea.width - topLeft.width * 3 && grid.checkMoveRight(Math.floor((y + referenceSquare.width) / referenceSquare.width), Math.floor((x - referenceSquare.width * 2)/ referenceSquare.width), shapeValue))
                        //x += topLeft.width
                        x = ++xCoord * topLeft.width
        }
        else if(event.key === Qt.Key_Up)
        {
            if(x >= 0 && x < playArea.width - topLeft.width)
            {
                if(state === "UPRIGHT")
                {
                    state = "LEFT"
                    rotation = 180
//                    y -= referenceSquare.width
                    y = --yCoord * topLeft.width
                    rotateSound.play()
                    titem.rotate()
                }
                else if(state === "LEFT" &&
                        x < playArea.width - topLeft.width * 2)
                {
                    state = "UPSIDEDOWN"
//                    x += referenceSquare.width
                    x = ++xCoord * topLeft.width
                    rotation = 270
                    rotateSound.play()
                    titem.rotate()
                }
                else if(state === "UPSIDEDOWN" && x >= 0)
                {
                    state = "RIGHT"
                    rotation = 0
//                    y += referenceSquare.width
                    y = ++yCoord * topLeft.width
                    rotateSound.play()
                    titem.rotate()
                }
                else if(state === "RIGHT" &&  x > 0)
                {
                    state = "UPRIGHT"
                    rotation = 90
//                    x -= referenceSquare.width
                    x = --xCoord * topLeft.width
                    rotateSound.play()
                    titem.rotate()
                }
            }
        }
        else if(event.key === Qt.Key_Down)
        {
            sleep.interval = _speed / 18
        }
        else if(event.key === Qt.Key_Space)
        {
            sleep.interval = _speed / 36
        }
        event.accept = true
    }
    Keys.onReleased: {
        if(event.key === Qt.Key_Down && !event.isAutoRepeat)
            sleep.interval = _speed
    }

        Timer
        {
            id:sleep
            interval: _speed
            running: true
            repeat: true
            onTriggered:
            {
                for(i  = 0; i < 32; i++)
                {
                    for (j = 0; j < 16; j++)
                    {
                        index = ((i * tilesWide) + j)

                        if (grid.updateGrid(i, j) === true)
                        {
                            squareRepeater.itemAt(index).visible = true
                            squareRepeater.itemAt(index).color = grid.getColor(i,j);
                        }
                        else
                        {
                            squareRepeater.itemAt(index).visible = false
                        }
                    }
                }

                if(state === "RIGHT" || state === "LEFT" && y < playArea.height - shapeHeight ||
                        (state === "UPRIGHT" || state === "UPSIDEDOWN" && y < playArea.height - topLeft.width * 2))
                {
//                  y += topLeft.width
                    y += referenceSquare.width
                    yCoord = Math.floor(y / referenceSquare.width)

                    if((state === "UPRIGHT" && grid.checkIfComplete(Math.floor((y + referenceSquare.width) / referenceSquare.width), Math.floor(x/ referenceSquare.width), shapeValue)) ||
                            (state === "UPSIDEDOWN" && grid.checkIfComplete(Math.floor((y + referenceSquare.width) / referenceSquare.width), Math.floor((x - referenceSquare.width * 2)/ referenceSquare.width), shapeValue)) ||
                            (state === "RIGHT" && grid.checkIfComplete(Math.floor((y - referenceSquare.width) / referenceSquare.width), Math.floor((x - referenceSquare.width)/ referenceSquare.width), shapeValue)) ||
                            (state === "LEFT" && grid.checkIfComplete(Math.floor((y + referenceSquare.width)/ referenceSquare.width), Math.floor((x - referenceSquare.width)/ referenceSquare.width), shapeValue)))
                    {
                        if(state != "GAMEOVER")
                        {
                            impactSound.play()
                            state = "STOP"
                        }

                        for(i  = 0; i < 32; i++)
                        {
                            for (j = 0; j < 16; j++)
                            {
                                if (grid.updateGrid(i, j) === true)
                                {
                                    index = ((i * tilesWide) + j)
                                    squareRepeater.itemAt(index).visible = true
                                    squareRepeater.itemAt(index).color = grid.getColor(i,j);
                                }
                                else
                                {
                                    index = ((i * tilesWide) + j)
                                    squareRepeater.itemAt(index).visible = false
                                }
                            }
                        }
                    }
                }
                else if(state === "STOP")
                {
                    running = false
                    visible = false
//                    x = referenceSquare.width * 6
//                    y = 0
                    xCoord = 6
                    yCoord = 0
                    rotation = 90
                    state = "UPRIGHT"
                    getRandomIntInclusive(0,6)
                }
            }
        }
}
