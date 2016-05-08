import QtQuick 2.5

Shape {
    id:mZItem
    property alias sleep:sleep
    topRight.visible: false
    bottomRight.visible: false
    thirdLeft.visible: false
    bottomLeft.visible: false
    shapeColor: "#7FFFD4"
    shapeHeight: topLeft.width * 2
    state: "WIDEST"
    shapeValue: 6
    rotation: 90

    states: [
           State { name: "WIDEST" },
           State { name: "NARROWEST" },
           State { name: "STOP" },
           State { name: "GAMEOVER" }
       ]

    Keys.onPressed: {
        if(event.key === Qt.Key_Left)
        {
            if(state === "NARROWEST" && x > 0 && grid.checkMoveLeft(Math.floor((y + referenceSquare.width) / referenceSquare.width), Math.floor((x - referenceSquare.width)/ referenceSquare.width), shapeValue) ||
                state === "WIDEST" && x >= topLeft.width && grid.checkMoveLeft(Math.floor((y + referenceSquare.width) / referenceSquare.width), Math.floor(x/ referenceSquare.width), shapeValue))
                x = --xCoord * topLeft.width
                //x -= referenceSquare.width
        }
        else if(event.key === Qt.Key_Right)
        {
            if(state === "NARROWEST" && x < (playArea.width - shapeWidth) && grid.checkMoveRight(Math.floor(y / referenceSquare.width), Math.floor((x - referenceSquare.width)/ referenceSquare.width), shapeValue) ||
                    state === "WIDEST" && x < playArea.width - topLeft.width * 3 && grid.checkMoveRight(Math.floor((y + referenceSquare.width) / referenceSquare.width), Math.floor(x/ referenceSquare.width), shapeValue))
                x = ++xCoord * topLeft.width
                //x += referenceSquare.width
        }
        else if(event.key === Qt.Key_Up)
        {
            if(x >= 0 && x < playArea.width - topLeft.width*2)
            {
                if(state === "NARROWEST")
                {
                    state = "WIDEST"
                    mZItem.rotation = 90
                    mzitem.rotate()
                    //y -= referenceSquare.width
                    y = --yCoord * topLeft.width
                    rotateSound.play()
                }
                else if(state === "WIDEST")
                {
                    state = "NARROWEST"
                    mZItem.rotation = 0
                    //y += referenceSquare.width
                    y = ++yCoord * topLeft.width
                    rotateSound.play()
                    mzitem.rotate()
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

                if(state === "NARROWEST" && y < playArea.height - shapeHeight ||
                        (state === "WIDEST" && y < playArea.height - topLeft.width * 2))
                {
                    y += referenceSquare.width
                    yCoord = Math.floor(y / referenceSquare.width)

                    if((state === "WIDEST" && grid.checkIfComplete(Math.floor((y + referenceSquare.width) / referenceSquare.width), Math.floor(x/ referenceSquare.width), shapeValue)) ||
                            (state === "NARROWEST" && grid.checkIfComplete(Math.floor(y / referenceSquare.width), Math.floor((x - referenceSquare.width)/ referenceSquare.width), shapeValue)))
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
                    state = "WIDEST"
                    getRandomIntInclusive(0,6)
                }
            }
        }
}
