import QtQuick
import "../../../globals/state" as GlobalState

Text {
    id: archLogo
    text: ""
    font.pixelSize: 30
    font.family: "JetBrainsMono Nerd Font"
    color: isActive ? GlobalState.Colors.primary : GlobalState.Colors.on_surface
    anchors.verticalCenter: parent.verticalCenter
    leftPadding: 10

    property real scaleFactor: 1.0
    property bool isActive: false

    scale: scaleFactor

    Behavior on scale {
        NumberAnimation { duration: 200; easing.type: Easing.OutBack }
    }
    Behavior on color {
        ColorAnimation { duration: 200; easing.type: Easing.InOutQuad }
    }

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor

        onClicked: {
            archLogo.isActive = !archLogo.isActive
            archLogo.scaleFactor = archLogo.isActive ? 1.2 : 1.0
            
            appLauncher.visible = !appLauncher.visible
            if (appLauncher.visible) {
                searchField.forceActiveFocus()
                searchField.text = ""
            }
            
            resetTimer.start()
        }

        onEntered: {
            if (!archLogo.isActive) {
                archLogo.scaleFactor = 1.1
            }
        }
        onExited: {
            if (!archLogo.isActive) {
                archLogo.scaleFactor = 1.0
            }
        }
    }

    Timer {
        id: resetTimer
        interval: 3000
        onTriggered: {
            archLogo.isActive = false
            archLogo.scaleFactor = 1.0
        }
    }
}