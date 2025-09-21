import QtQuick
import Quickshell
import "../public" as Theme
import "../performance"
import "../music"
import "../power"

PanelWindow {
    id: bar
    implicitHeight: 32
    screen: Quickshell.screens[0]
    color: Theme.Colors.surface

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
        id: ws
        anchors.left: archLogo.right
        anchors.leftMargin: 8       // space between logo and workspaces
        anchors.verticalCenter: parent.verticalCenter
        implicitWidth: 120
        implicitHeight: 32
    }

    Clock {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
    }

    BatteryIcon {
        id: batteryIcon
        anchors.right: musicIcon.left
        anchors.rightMargin: 12
        anchors.verticalCenter: parent.verticalCenter
        onTogglePopup: batteryPopup.visible = !batteryPopup.visible
    }

    MusicIcon {
        id: musicIcon
        anchors.right: perfIcon.left
        anchors.rightMargin: 12
        anchors.verticalCenter: parent.verticalCenter
        onTogglePopup: musicPopup.visible = !musicPopup.visible
    }


    PerfIcon {
        id: perfIcon
        anchors.right: powerBtn.left
        anchors.rightMargin: 12
        anchors.verticalCenter: parent.verticalCenter
        onTogglePopup: perfPopup.visible = !perfPopup.visible
    }

    PowerButton {
        id: powerBtn
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
    }
}