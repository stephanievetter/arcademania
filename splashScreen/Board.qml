import QtQuick 2.4
import QTGraphicalEffects 1.0
//import "/Users/Isaac/cst_238/arcademania/splashScreen/ComponentGenerator.js" as MyScript

    Rectangle {
    id: playArea
    property alias squareRepeater:squareRepeater
    //property alias drawnSquare:drawnSquare
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.bottom: parent.bottom
    anchors.bottomMargin: parent.height * .025
    height: referenceSquare.height * tilesHigh
    width: referenceSquare.width * tilesWide
    //Component.onCompleted: console.log (height)
    border.color: "#002355"
    border.width: 3
    property int index: 0
    property int i: 0
    property int j: 0
    onWidthChanged:
    {
        exampleShape.x = exampleShape.col * (width / tilesWide)
    }

    onHeightChanged:
    {
        exampleShape.y = exampleShape.row * (height / tilesHigh)

    }

    RadialGradient{
        anchors.fill: playArea
        gradient: Gradient{
            GradientStop{ position: 0.0; color: "#002355"}
            GradientStop{ position: 0.5; color: "#03142b"}
        }
    }

    Square{
        id:referenceSquare
        color:"transparent"
        border.color: "transparent"
    }

    LineItem {
        id: exampleShape
    }

    Repeater {
        id: squareRepeater
        model: 512
        Square{
         id: drawnSquare
         y: Math.floor(index/16) * referenceSquare.height
         x: (index - (Math.floor(index/16) * 16)) * referenceSquare.width
         color: "transparent"
        }
    }

    Canvas {
        id: root
        // canvas size
        anchors.fill: parent
        anchors.centerIn: parent
        // handler to override for drawing
        onPaint: {
            // get context to draw with
            var ctx = getContext("2d")
            // setup the stroke
            ctx.strokeStyle = "Black"

            //create vertical grid lines
            for(index = 1; index <= tilesWide; index++)
            {
                ctx.beginPath()
                // top start point
                ctx.moveTo(playArea.width / tilesWide * index,0)
                // bottom end point
                ctx.lineTo(playArea.width / tilesWide * index,playArea.height)
                // stop at end point
                ctx.closePath()
                // paint line
                ctx.stroke()
            }
            for(index = 1; index <= tilesHigh; index++)
            {
                ctx.beginPath()
                // top start point
                ctx.moveTo(0, playArea.height / tilesHigh * index)
                // bottom end point
                ctx.lineTo(playArea.width, playArea.height / tilesHigh * index)
                // stop at end point
                ctx.closePath()
                // paint line
                ctx.stroke()
            }
        }
    }
}
