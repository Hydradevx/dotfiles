import QtQuick
import QtQuick.Controls
import Quickshell
import Quickshell.Hyprland
import "../public" as Theme

Item {
    id: root
    property int workspaceCount: 10
    property int workspaceSize: 32
    property int spacing: 6
    property int padding: 8
    
    property list<HyprlandWorkspace> workspaces: []
    property int activeWorkspaceId: 1

    implicitWidth: padding * 2 + workspaceCount * workspaceSize + (workspaceCount - 1) * spacing
    implicitHeight: workspaceSize + padding * 2

    Rectangle {
        id: barBackground
        anchors.fill: parent
        color: Theme.Colors.surface_container_low
        radius: height / 2
        border.color: Theme.Colors.outline
        border.width: 1
        opacity: 0.95

        // Workspace indicators container
        Item {
            id: container
            anchors {
                fill: parent
                leftMargin: root.padding
                rightMargin: root.padding
            }
            
            Row {
                id: workspaceRow
                anchors.centerIn: parent
                spacing: root.spacing
                
                Repeater {
                    model: root.workspaceCount

                    Item {
                        id: workspaceItem
                        width: root.workspaceSize
                        height: root.workspaceSize
                        
                        property int wsId: index + 1
                        property var ws: {
                            // Find the workspace with this ID
                            for (let i = 0; i < root.workspaces.length; i++) {
                                if (root.workspaces[i].id === wsId) {
                                    return root.workspaces[i]
                                }
                            }
                            // Fallback workspace object
                            return { 
                                id: wsId,
                                active: false,
                                toplevels: { count: 0, values: [] },
                                activate: function() { Hyprland.dispatch(`workspace ${wsId}`) }
                            }
                        }
                        property bool isActive: wsId === root.activeWorkspaceId
                        property bool hasWindows: ws.toplevels && ws.toplevels.count > 0

                        // Active workspace background
                        Rectangle {
                            id: activeBg
                            anchors.fill: parent
                            radius: width / 2
                            color: Theme.Colors.primary_container
                            opacity: workspaceItem.isActive ? 0.8 : 0
                            Behavior on opacity { NumberAnimation { duration: 200 } }
                        }

                        // Dot indicator
                        Rectangle {
                            id: dot
                            anchors.centerIn: parent
                            width: parent.width * 0.5
                            height: width
                            radius: width / 2
                            
                            color: {
                                if (workspaceItem.isActive) return Theme.Colors.on_primary_container
                                else if (workspaceItem.hasWindows) return Theme.Colors.secondary
                                else return Theme.Colors.on_surface_variant
                            }
                            
                            opacity: {
                                if (workspaceItem.isActive) return 1.0
                                else if (workspaceItem.hasWindows) return 0.8
                                else return 0.4
                            }
                            
                            scale: 1.0
                            
                            Behavior on color { ColorAnimation { duration: 200 } }
                            Behavior on opacity { NumberAnimation { duration: 200 } }
                            Behavior on scale { NumberAnimation { duration: 100 } }
                        }

                        MouseArea {
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: workspaceItem.ws.activate()
                            
                            onEntered: {
                                dot.scale = 1.4
                                dot.opacity = Math.min(dot.opacity + 0.3, 1.0)
                            }
                            onExited: {
                                dot.scale = 1.0
                                // Restore original opacity
                                if (workspaceItem.isActive) dot.opacity = 1.0
                                else if (workspaceItem.hasWindows) dot.opacity = 0.8
                                else dot.opacity = 0.4
                            }
                        }
                        
                        // Tooltip
                        ToolTip {
                            visible: parent.MouseArea.containsMouse
                            delay: 500
                            text: {
                                if (!workspaceItem.hasWindows) {
                                    return `Workspace ${workspaceItem.wsId} - Empty`
                                }
                                return `Workspace ${workspaceItem.wsId} - ${workspaceItem.ws.toplevels.count} window(s)`
                            }
                        }
                    }
                }
            }
        }
    }

    function refreshWorkspaces() {
        console.log("Refreshing workspaces...")
        const hw = Hyprland.workspaces.values
        let newWorkspaces = []
        let newActiveId = root.activeWorkspaceId
        
        // Create workspace array for all workspaces
        for (let i = 0; i < root.workspaceCount; i++) {
            const wsId = i + 1
            let ws = hw.find(w => w.id === wsId)
            
            if (!ws) {
                ws = { 
                    id: wsId, 
                    active: false, 
                    toplevels: { count: 0, values: [] }
                }
            } else {
                if (ws.active) {
                    newActiveId = wsId
                    console.log("Found active workspace:", wsId)
                }
            }
            newWorkspaces.push(ws)
        }
        
        workspaces = newWorkspaces
        activeWorkspaceId = newActiveId
        
        console.log("Workspaces refreshed. Active:", activeWorkspaceId, "Total:", workspaces.length)
    }

    Component.onCompleted: {
        console.log("Workspaces component loaded")
        refreshWorkspaces()
        
        timer.start()
    }

    Timer {
        id: timer
        interval: 500
        onTriggered: refreshWorkspaces()
    }

    Connections {
        target: Hyprland
        
        function onWorkspacesChanged() {
            console.log("Hyprland workspaces changed")
            refreshWorkspaces()
        }
        
        function onFocusedWorkspaceChanged() {
            console.log("Focused workspace changed")
            refreshWorkspaces()
        }
        
        function onWorkspaceCreated() {
            console.log("Workspace created")
            refreshWorkspaces()
        }
        
        function onWorkspaceRemoved() {
            console.log("Workspace removed")
            refreshWorkspaces()
        }
        
        function onToplevelsChanged() {
            console.log("Toplevels changed")
            refreshWorkspaces()
        }
        
        function onValuesChanged() {
            console.log("Values changed")
            refreshWorkspaces()
        }
    }
}