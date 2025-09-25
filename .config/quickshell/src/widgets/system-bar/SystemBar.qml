import QtQuick
import Quickshell
import "../../globals/state" as GlobalState
import "./components"

PanelWindow {
    id: bar
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

    PowerButton {
        id: powerBtn
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
    }
}