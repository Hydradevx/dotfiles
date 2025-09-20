import QtQuick
import QtQuick.Controls
import Quickshell
import Quickshell.Hyprland
import "../public" as Theme

Item {
    id: root
    property int workspaceCount: 5
    property int workspaceSize: 14
    property int spacing: 8        // space between circles
    property int padding: 6         // rectangle padding
    property list<HyprlandWorkspace> workspaces: []

    implicitWidth: padding*2 + workspaceCount * workspaceSize + (workspaceCount-1)*spacing
    implicitHeight: workspaceSize + padding*2

    
    Rectangle {
    id: barBackground
    anchors.fill: parent
    color: Theme.Colors.surface
    radius: height / 2
    border.color: Theme.Colors.outline
    border.width: 1

    Row {
        id: rowWorkspaces
        anchors.centerIn: parent
        spacing: root.spacing   
        width: root.workspaceCount * root.workspaceSize + (root.workspaceCount - 1) * root.spacing
        height: root.workspaceSize

        Repeater {
            model: root.workspaceCount

            Rectangle {
                width: root.workspaceSize
                height: root.workspaceSize
                radius: width / 2
                property var wsObj: index < root.workspaces.length ? root.workspaces[index] : { active: false, toplevels: { count: 0 }, activate: function(){} }

                color: wsObj.active ? Theme.Colors.primary
                       : wsObj.toplevels.count > 0 ? Theme.Colors.secondaryContainer
                       : Theme.Colors.surface

                border.color: Theme.Colors.on_surface
                border.width: 1

                Behavior on color { ColorAnimation { duration: 120 } }

                MouseArea {
                    anchors.fill: parent
                    onClicked: { wsObj.activate() }
                }
            }
        }
    }
}


    function refreshWorkspaces() {
        Hyprland.refreshWorkspaces()
        var hw = Hyprland.workspaces.values
        workspaces = []

        for (var i=0; i<workspaceCount; i++) {
            var ws = hw.find(w => w.id === i+1)
            if (!ws) ws = { id: i+1, active: false, toplevels: { count: 0 }, activate: function(){ Hyprland.dispatch(`workspace ${i+1}`) } }
            workspaces.push(ws)
        }
    }

    Component.onCompleted: refreshWorkspaces()

    Connections {
        target: Hyprland
        function onFocusedWorkspaceChanged() { refreshWorkspaces() }
        function onWorkspaceCreated() { refreshWorkspaces() }
        function onWorkspaceRemoved() { refreshWorkspaces() }
        function onValuesChanged() { refreshWorkspaces() }
    }
}