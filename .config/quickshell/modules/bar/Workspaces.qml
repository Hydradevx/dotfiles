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
    property int iconSize: 20
    
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

        // Active workspace indicator
        Rectangle {
            id: activeIndicator
            width: root.workspaceSize
            height: root.workspaceSize
            radius: width / 2
            color: Theme.Colors.primary_container
            border.color: Theme.Colors.primary
            border.width: 2
            
            x: {
                if (root.workspaces.length === 0) return 0
                const index = root.workspaces.findIndex(ws => ws.id === root.activeWorkspaceId)
                return root.padding + index * (root.workspaceSize + root.spacing)
            }
            y: root.padding
            
            Behavior on x { 
                NumberAnimation { 
                    duration: 300; 
                    easing.type: Easing.OutCubic 
                } 
            }
        }

        // Workspace buttons container
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

                    Rectangle {
                        id: workspaceButton
                        width: root.workspaceSize
                        height: root.workspaceSize
                        radius: width / 2
                        color: "transparent"
                        
                        property var ws: index < root.workspaces.length ? root.workspaces[index] : { 
                            id: index + 1,
                            active: false, 
                            toplevels: { count: 0, values: [] },
                            activate: function() { Hyprland.dispatch(`workspace ${index + 1}`) }
                        }
                        
                        // Background for occupied workspaces
                        Rectangle {
                            anchors.fill: parent
                            radius: parent.radius
                            color: Theme.Colors.secondary_container
                            opacity: ws.toplevels && ws.toplevels.count > 0 ? 0.3 : 0
                            Behavior on opacity { NumberAnimation { duration: 200 } }
                        }

                        // Content (icon or number)
                        Item {
                            anchors.centerIn: parent
                            width: Math.min(parent.width - 4, root.iconSize)
                            height: Math.min(parent.height - 4, root.iconSize)
                            
                            // App icon for occupied workspaces
                            Image {
                                id: appIcon
                                anchors.fill: parent
                                visible: ws.toplevels && ws.toplevels.count > 0
                                source: {
                                    if (visible && ws.toplevels.values && ws.toplevels.values.length > 0) {
                                        const window = ws.toplevels.values[0]
                                        if (window && window.appId) {
                                            return Quickshell.iconPath(window.appId)
                                        }
                                    }
                                    return ""
                                }
                                fillMode: Image.PreserveAspectFit
                                smooth: true
                                mipmap: true
                                
                                // Fallback if icon fails to load
                                onStatusChanged: {
                                    if (status === Image.Error) {
                                        console.log("Icon not found for:", ws.toplevels.values[0]?.appId)
                                    }
                                }
                            }
                            
                            // Workspace number (shown when no icon or empty)
                            Text {
                                id: numberText
                                anchors.centerIn: parent
                                text: index + 1
                                font.family: "MapleMono NF"
                                font.pixelSize: root.workspaceSize * 0.45
                                font.weight: Font.Medium
                                color: {
                                    if (ws.active) return Theme.Colors.on_primary_container
                                    if (ws.toplevels && ws.toplevels.count > 0) return Theme.Colors.on_secondary_container
                                    return Theme.Colors.on_surface_variant
                                }
                                visible: !appIcon.visible || appIcon.status === Image.Error
                            }
                        }

                        MouseArea {
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: ws.activate()
                            
                            onEntered: {
                                workspaceButton.scale = 1.15
                            }
                            onExited: {
                                workspaceButton.scale = 1.0
                            }
                        }
                        
                        scale: 1.0
                        Behavior on scale { NumberAnimation { duration: 100 } }

                        // Tooltip
                        ToolTip {
                            visible: parent.MouseArea.containsMouse
                            delay: 500
                            text: {
                                const wsId = index + 1
                                if (!ws.toplevels || ws.toplevels.count === 0) {
                                    return `Workspace ${wsId} - Empty`
                                }
                                
                                const appNames = []
                                if (ws.toplevels.values) {
                                    for (let i = 0; i < ws.toplevels.values.length; i++) {
                                        const window = ws.toplevels.values[i]
                                        if (window && window.appId) {
                                            appNames.push(window.appId.split('.').pop() || window.appId)
                                        }
                                    }
                                }
                                
                                return `Workspace ${wsId} - ${appNames.join(', ') || 'Windows open'}`
                            }
                        }
                    }
                }
            }
        }
    }

    function refreshWorkspaces() {
        Hyprland.refreshWorkspaces()
        const hw = Hyprland.workspaces.values
        workspaces = []
        
        // Create workspace array for all 10 workspaces
        for (let i = 0; i < root.workspaceCount; i++) {
            const wsId = i + 1
            let ws = hw.find(w => w.id === wsId)
            if (!ws) {
                ws = { 
                    id: wsId, 
                    active: false, 
                    toplevels: { count: 0, values: [] }, 
                    activate: function() { Hyprland.dispatch(`workspace ${wsId}`) } 
                }
            } else {
                // Update active workspace
                if (ws.active) {
                    root.activeWorkspaceId = wsId
                }
            }
            workspaces.push(ws)
        }
        
        console.log("Refreshed workspaces:", workspaces.length, "Active:", root.activeWorkspaceId)
    }

    Component.onCompleted: {
        console.log("Workspaces component loaded")
        refreshWorkspaces()
    }

    Connections {
        target: Hyprland
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
        function onValuesChanged() { 
            console.log("Values changed")
            refreshWorkspaces() 
        }
        function onToplevelsChanged() { 
            console.log("Toplevels changed")
            refreshWorkspaces() 
        }
    }
}