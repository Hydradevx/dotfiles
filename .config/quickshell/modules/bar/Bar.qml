import QtQuick
import Quickshell
import "../public" as Theme
import "../performance"

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
        anchors.left: parent.left
        anchors.verticalCenter: parent.verticalCenter
    }

    Clock {
        anchors.centerIn: parent
    }

    PerfIcon {
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