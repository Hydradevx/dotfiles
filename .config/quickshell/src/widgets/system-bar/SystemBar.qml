import QtQuick
import Quickshell
import "../../globals/state" as GlobalState
import "./icons" as BarIcons 
import "./components"

PanelWindow {
    id: systemBar
    implicitHeight: 32
    screen: Quickshell.screens[0]
    color: GlobalState.Colors.surface

    anchors {
        top: true
        left: true
        right: true
    }

    ArchLogo {
        id: archLogo
        anchors.left: parent.left
        width: 32
        height: 40
    }

    Workspaces {
        id: workspaces
        anchors.left: archLogo.right 
        anchors.leftMargin: 8       
        anchors.verticalCenter: parent.verticalCenter
        implicitHeight: 32
    }

    Clock {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
    }

    BarIcons.BatteryIcon {
        id: batteryIcon
        anchors.right: musicIcon.left
        anchors.rightMargin: 12
        anchors.verticalCenter: parent.verticalCenter
        onTogglePopup: function(visible) {
            if (batteryPopup) {
                batteryPopup.visible = visible
            }
        }
    }

    BarIcons.MusicIcon {
        id: musicIcon
        anchors.right: powerBtn.left
        anchors.rightMargin: 12
        anchors.verticalCenter: parent.verticalCenter
        onTogglePopup: function(visible) {
            if (musicPopup) {
                musicPopup.visible = visible
            }
        }
    }

    PowerButton {
        id: powerBtn
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
    }
}