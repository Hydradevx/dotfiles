pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import Quickshell.Wayland
import Quickshell.Widgets
import Quickshell.Hyprland
import "../public" as Theme

Scope {
  GlobalShortcut {
    name: "overview"
    onPressed: lazyloader.active = !lazyloader.active
  }

  Connections {
    target: Hyprland

    function onRawEvent() {
      Hyprland.refreshMonitors();
      Hyprland.refreshWorkspaces();
      Hyprland.refreshToplevels();
    }
  }

  LazyLoader {
    id: lazyloader
    active: false

    PanelWindow {
      id: root

      property real scaleFactor: 0.2
      property int workspaceCount: 10
      property var dragSource: null
      property var dragWindow: null

      implicitWidth: contentGrid.implicitWidth + 24
      implicitHeight: contentGrid.implicitHeight + 24
      WlrLayershell.layer: WlrLayer.Overlay

      Rectangle {
        anchors.fill: parent
        color: Theme.Colors.surface_container
        opacity: 0.98
        radius: 8
        border.color: Theme.Colors.outline
        border.width: 1
      }

      Rectangle {
        id: dragPreview
        visible: root.dragSource !== null
        width: 100
        height: 60
        color: Theme.Colors.primary_container
        radius: 4
        border.color: Theme.Colors.primary
        border.width: 2
        z: 1000

        Image {
          id: dragIcon
          width: 32
          height: 32
          fillMode: Image.PreserveAspectFit
          anchors.centerIn: parent
          source: root.dragWindow ? Quickshell.iconPath(DesktopEntries.heuristicLookup(root.dragWindow.lastIpcObject?.class)?.icon, "image-missing") : ""
        }

        Text {
          text: root.dragWindow ? (root.dragWindow.lastIpcObject?.title || "Window") : ""
          color: Theme.Colors.on_primary_container
          font.pixelSize: 10
          elide: Text.ElideRight
          maximumLineCount: 1
          anchors {
            left: parent.left
            right: parent.right
            bottom: parent.bottom
            margins: 4
          }
        }
      }

      GridLayout {
        id: contentGrid
        rows: 2
        columns: 5
        rowSpacing: 12
        columnSpacing: 12
        anchors.centerIn: parent

        Repeater {
          model: root.workspaceCount

          delegate: Rectangle {
            id: workspaceContainer

            required property int index
            property int workspaceId: index + 1
            property HyprlandWorkspace workspace: Hyprland.workspaces.values.find(w => w.id === workspaceId) ?? null
            property HyprlandMonitor monitor: Hyprland.monitors.values[0]
            property bool hasFullscreen: !!(workspace?.toplevels?.values.some(t => t.wayland?.fullscreen))
            property bool hasMaximized: !!(workspace?.toplevels?.values.some(t => t.wayland?.maximized))
            property bool isActive: workspace?.active ?? false
            property int reservedX: hasFullscreen ? 0 : monitor.lastIpcObject?.reserved?.[0] ?? 0
            property int reservedY: hasFullscreen ? 0 : monitor.lastIpcObject?.reserved?.[1] ?? 0
            property int windowCount: workspace?.toplevels?.count ?? 0
            property bool isDropTarget: false

            implicitWidth: (monitor.width - reservedX) * root.scaleFactor
            implicitHeight: (monitor.height - reservedY) * root.scaleFactor

            color: isDropTarget ? Theme.Colors.secondary_container : Theme.Colors.surface_container_high
            radius: 6
            border.width: isDropTarget ? 3 : 2
            border.color: isDropTarget ? Theme.Colors.secondary : 
                         isActive ? Theme.Colors.primary : 
                         hasMaximized ? Theme.Colors.error : "transparent"

            DropArea {
              id: dropArea
              anchors.fill: parent
              enabled: root.dragSource !== null && root.dragSource !== workspaceContainer

              onEntered: {
                workspaceContainer.isDropTarget = true
              }
              onExited: {
                workspaceContainer.isDropTarget = false
              }
              onDropped: {
                if (root.dragSource && root.dragWindow) {
                  const targetWorkspaceId = workspaceContainer.workspaceId
                  Hyprland.dispatch(`movetoworkspacesilent ${targetWorkspaceId},address:${root.dragWindow.wayland.surface.objectAddress}`)
                }
                workspaceContainer.isDropTarget = false
                root.dragSource = null
                root.dragWindow = null
              }
            }

            states: State {
              name: "hovered"
              when: mouseArea.containsMouse && root.dragSource === null
              PropertyChanges {
                target: workspaceContainer
                scale: 1.02
                border.color: isActive ? Theme.Colors.primary_container : Theme.Colors.outline
              }
            }

            transitions: Transition {
              NumberAnimation { properties: "scale, border.color"; duration: 150 }
            }

            MouseArea {
              id: mouseArea
              anchors.fill: parent
              hoverEnabled: true
              cursorShape: Qt.PointingHandCursor
              onClicked: {
                if (root.dragSource !== null) {
                  root.dragSource = null
                  root.dragWindow = null
                } else {
                  Hyprland.dispatch(`workspace ${workspaceId}`)
                }
              }
            }

            Repeater {
              model: workspaceContainer.workspace?.toplevels

              delegate: Item {
                id: toplevelContainer

                required property HyprlandToplevel modelData
                property Toplevel waylandHandle: modelData?.wayland
                property var toplevelData: modelData.lastIpcObject

                width: (toplevelData.size?.[0] || 100) * root.scaleFactor
                height: (toplevelData.size?.[1] || 100) * root.scaleFactor
                x: (toplevelData.at?.[0] - workspaceContainer.reservedX) * root.scaleFactor
                y: (toplevelData.at?.[1] - workspaceContainer.reservedY) * root.scaleFactor
                z: (waylandHandle?.fullscreen || waylandHandle?.maximized) ? 2 : toplevelData.floating ? 1 : 0

                Rectangle {
                  anchors.fill: parent
                  color: waylandHandle?.fullscreen ? Theme.Colors.primary_container : 
                         waylandHandle?.maximized ? Theme.Colors.error_container : Theme.Colors.surface_container_highest
                  radius: 3
                  border.color: waylandHandle?.active ? Theme.Colors.primary : Theme.Colors.outline
                  border.width: waylandHandle?.active ? 2 : 1
                }

                Image {
                  source: Quickshell.iconPath(DesktopEntries.heuristicLookup(toplevelData?.class)?.icon, "image-missing")
                  width: 24
                  height: 24
                  fillMode: Image.PreserveAspectFit
                  anchors.centerIn: parent
                }

                ScreencopyView {
                  id: screencopyView
                  anchors.fill: parent
                  captureSource: waylandHandle
                  live: true
                  visible: waylandHandle && status === Loader.Ready
                  opacity: 0.7
                }

                MouseArea {
                  id: windowMouseArea
                  anchors.fill: parent
                  hoverEnabled: true
                  cursorShape: containsPress ? Qt.ClosedHandCursor : Qt.PointingHandCursor
                  drag.target: dragItem
                  drag.threshold: 10

                  property point dragStartPos

                  onPressed: (mouse) => {
                    dragStartPos = Qt.point(mouse.x, mouse.y)
                  }

                  onPositionChanged: (mouse) => {
                    if (drag.active) {
                      root.dragSource = workspaceContainer
                      root.dragWindow = modelData
                      dragPreview.x = mouse.x + toplevelContainer.x + workspaceContainer.x + contentGrid.x - dragPreview.width/2
                      dragPreview.y = mouse.y + toplevelContainer.y + workspaceContainer.y + contentGrid.y - dragPreview.height/2
                    }
                  }

                  onReleased: {
                    if (root.dragSource !== null) {
                      root.dragSource = null
                      root.dragWindow = null
                    }
                  }

                  onClicked: (mouse) => {
                    if (Math.abs(mouse.x - dragStartPos.x) < 5 && Math.abs(mouse.y - dragStartPos.y) < 5) {
                      if (mouse.button === Qt.LeftButton)
                        waylandHandle.activate();
                      else if (mouse.button === Qt.RightButton)
                        waylandHandle.close();
                    }
                  }

                  onEntered: {
                    toplevelContainer.scale = 1.05
                    toplevelContainer.z = 10
                  }
                  onExited: {
                    toplevelContainer.scale = 1.0
                    toplevelContainer.z = (waylandHandle?.fullscreen || waylandHandle?.maximized) ? 2 : toplevelData.floating ? 1 : 0
                  }
                }

                Item {
                  id: dragItem
                  visible: false
                }

                scale: 1.0
                Behavior on scale { NumberAnimation { duration: 100 } }
              }
            }

            Rectangle {
              width: 24
              height: 24
              radius: 12
              color: isActive ? Theme.Colors.primary : 
                     windowCount > 0 ? Theme.Colors.secondary_container : Theme.Colors.surface_container_highest
              border.color: Theme.Colors.outline
              border.width: 1
              anchors {
                top: parent.top
                left: parent.left
                margins: 4
              }

              Text {
                text: workspaceId
                color: isActive ? Theme.Colors.on_primary : 
                       windowCount > 0 ? Theme.Colors.on_secondary_container : Theme.Colors.on_surface
                font.pixelSize: 10
                font.bold: true
                anchors.centerIn: parent
              }

              Rectangle {
                visible: windowCount > 0
                width: 14
                height: 14
                radius: 7
                color: Theme.Colors.error
                border.color: Theme.Colors.on_error
                border.width: 1
                anchors {
                  top: parent.top
                  right: parent.right
                  margins: -3
                }

                Text {
                  text: windowCount > 9 ? "9+" : windowCount
                  color: Theme.Colors.on_error
                  font.pixelSize: 7
                  font.bold: true
                  anchors.centerIn: parent
                }
              }
            }

            Text {
              visible: windowCount === 0
              text: "Empty"
              color: Theme.Colors.on_surface_variant
              font.pixelSize: 12
              font.italic: true
              anchors.centerIn: parent
            }
          }
        }
      }

      Text {
        text: root.dragSource ? "Drop window on target workspace" : "Click workspace to switch • Drag windows to move • Right-click to close"
        color: Theme.Colors.on_surface_variant
        font.pixelSize: 12
        anchors {
          bottom: parent.bottom
          horizontalCenter: parent.horizontalCenter
          bottomMargin: 8
        }
      }
    }
  }
}