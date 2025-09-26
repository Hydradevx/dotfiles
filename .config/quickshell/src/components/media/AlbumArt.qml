import QtQuick
import "../../globals/state" as GlobalState

Rectangle {
    id: albumArt
    width: 80
    height: 80
    radius: 8
    border.color: GlobalState.Colors.outline
    border.width: 1
    clip: true
    
    property string imageSource: ""
    property bool isPlaying: false
    
    Image {
        id: artImage
        anchors.fill: parent
        fillMode: Image.PreserveAspectFit
        source: albumArt.imageSource
        asynchronous: true
        
        Behavior on rotation {
            NumberAnimation { duration: 500; easing.type: Easing.InOutQuad }
        }
    }
    
    onIsPlayingChanged: {
        if (albumArt.isPlaying) {
            artImage.rotation = 5
        } else {
            artImage.rotation = 0
        }
    }
}