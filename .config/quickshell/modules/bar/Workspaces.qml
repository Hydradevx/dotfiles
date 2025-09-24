import QtQuick
import QtQuick.Controls
import Quickshell
import Quickshell.Hyprland
import "../public" as Theme

Item {
    id: root
    height: 25
    width: pills.implicitWidth + 20

    Behavior on width {
        NumberAnimation {
            duration: 200
            easing.type: Easing.OutCubic
        }
    }
    
    property bool verticalMode: false
    transform: Rotation {
        origin.x: width / 2
        origin.y: height / 2
        angle: verticalMode ? 90 : 0
    }
    
    property int minWorkspaces: 4
    property int currentWorkspace: activeWorkspaceId
    property list<HyprlandWorkspace> workspaces: []
    property int activeWorkspaceId: 1

    ListModel { id: wsModel }

    function refreshWorkspaces() {
        console.log("Refreshing workspaces...")
        const real = Hyprland.workspaces?.values || [];
        const sorted = real.slice().sort((a, b) => a.id - b.id);

        // Find the currently active workspace
        let activeWs = real.find(w => w.active);
        if (activeWs) {
            activeWorkspaceId = activeWs.id;
            console.log("Active workspace found:", activeWorkspaceId);
        }

        const maxCount = Math.max(minWorkspaces, ...sorted.map(w => w.id));
        const data = [];

        for (let i = 1; i <= maxCount; i++) {
            const ws = sorted.find(w => w.id === i);
            data.push({
                id: i,
                focused: ws ? (ws.id === activeWorkspaceId) : (i === activeWorkspaceId),
                name: ws ? ws.name : ""
            });
        }

        if (wsModel.count !== data.length) {
            wsModel.clear();
            data.forEach(item => wsModel.append(item));
        } else {
            for (let i = 0; i < data.length; i++) {
                wsModel.set(i, data[i]);
            }
        }
        
        // Update the workspaces property for compatibility
        let newWorkspaces = [];
        for (let i = 1; i <= maxCount; i++) {
            const ws = sorted.find(w => w.id === i);
            if (ws) {
                newWorkspaces.push(ws);
            } else {
                newWorkspaces.push({ 
                    id: i, 
                    active: false, 
                    toplevels: { count: 0, values: [] }
                });
            }
        }
        workspaces = newWorkspaces;
        
        console.log("Workspaces refreshed. Total:", wsModel.count, "Active:", activeWorkspaceId);
    }

    Component.onCompleted: {
        console.log("Workspaces component loaded")
        refreshWorkspaces()
    }

    Connections {
        target: Hyprland
        
        function onActiveWsIdChanged() { 
            console.log("Active workspace ID changed")
            refreshWorkspaces(); 
        }
        
        function onWorkspacesChanged() { 
            console.log("Hyprland workspaces changed")
            refreshWorkspaces(); 
        }
        
        function onFocusedWorkspaceChanged() {
            console.log("Focused workspace changed")
            refreshWorkspaces()
        }
        
        function onActiveWorkspaceChanged() {
            console.log("Active workspace changed")
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
    }

    Rectangle {
        id: bgRect
        opacity: 1
        Behavior on opacity { 
            NumberAnimation { 
                duration: 200
                easing.type: Easing.OutCubic 
            } 
        }

        anchors.fill: parent
        color: Theme.Colors.surface_container_low
        radius: 20
        border.color: Theme.Colors.outline
        border.width: 1
    }

    Row {
        id: pills
        anchors.centerIn: parent
        spacing: 10

        Repeater {
            model: wsModel

            delegate: Rectangle {
                id: pill
                width: focused ? 20 : 10
                height: 10
                radius: 20
                anchors.verticalCenter: parent.verticalCenter
                opacity: focused ? 1.0 : 0.4
                color: focused ? Theme.Colors.primary : Theme.Colors.on_surface
                               

                Behavior on width { 
                    NumberAnimation { 
                        duration: 200
                        easing.type: Easing.OutCubic 
                    } 
                }
                Behavior on opacity { 
                    NumberAnimation { 
                        duration: 200
                        easing.type: Easing.OutCubic 
                    } 
                }
                Behavior on color { 
                    ColorAnimation { 
                        duration: 200
                        easing.type: Easing.OutCubic 
                    } 
                }

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    hoverEnabled: true
                    onClicked: {
                        if (activeWorkspaceId !== id) {
                            console.log("Switching to workspace", id)
                            Hyprland.dispatch(`workspace ${id}`)
                        }
                    }
                    onEntered: {
                        pill.scale = 1.2
                    }
                    onExited: {
                        pill.scale = 1.0
                    }
                }
                
                Behavior on scale {
                    NumberAnimation { duration: 100 }
                }
            }
        }
    }
}