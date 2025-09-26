import QtQuick
import Quickshell
import "../../globals/state" as GlobalState

PopupWindow {
    id: popupBase
    color: "transparent"
    
    property real popupScale: 0.0
    property real popupOpacity: 0.0
    property alias backgroundColor: bg.color
    property alias backgroundRadius: bg.radius
    
    onVisibleChanged: {
        if (visible) {
            showAnimation.start()
        } else {
            hideAnimation.start()
        }
    }
    
    ParallelAnimation {
        id: showAnimation
        NumberAnimation {
            target: popupBase
            property: "popupScale"
            from: 0.0
            to: 1.0
            duration: 300
            easing.type: Easing.OutBack
            easing.overshoot: 1.5
        }
        NumberAnimation {
            target: popupBase
            property: "popupOpacity"
            from: 0.0
            to: 1.0
            duration: 200
        }
    }
    
    ParallelAnimation {
        id: hideAnimation
        NumberAnimation {
            target: popupBase
            property: "popupScale"
            from: 1.0
            to: 0.0
            duration: 200
            easing.type: Easing.InBack
        }
        NumberAnimation {
            target: popupBase
            property: "popupOpacity"
            from: 1.0
            to: 0.0
            duration: 150
        }
    }
    
    Rectangle {
        id: bg
        anchors.fill: parent
        color: GlobalState.Colors.surface
        radius: 12
        scale: popupBase.popupScale
        opacity: popupBase.popupOpacity
        
        Rectangle {
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            height: parent.radius
            color: parent.color
        }
    }
}