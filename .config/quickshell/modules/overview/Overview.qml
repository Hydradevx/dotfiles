pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import Quickshell.Widgets
import Quickshell.Hyprland

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

      implicitWidth: contentGrid.implicitWidth + 24
      implicitHeight: contentGrid.implicitHeight + 24
      WlrLayershell.layer: WlrLayer.Overlay

      Rectangle {
        anchors.fill: parent
        color: "grey"
      }

      GridLayout {
        id: contentGrid
        rows: 2
        columns: 4
        rowSpacing: 12
        columnSpacing: 12
        anchors.centerIn: parent

        Repeater {
          model: 8

          delegate: Rectangle {
            id: workspaceContainer

            required property int index
            property HyprlandWorkspace workspace: Hyprland.workspaces.values.find(w => w.id === index + 1) ?? null
            property HyprlandMonitor monitor: Hyprland.monitors.values[0]    // i have one monitor
            property bool hasFullscreen: !!(workspace?.toplevels?.values.some(t => t.wayland?.fullscreen))
            property bool hasMaximized: !!(workspace?.toplevels?.values.some(t => t.wayland?.maximized))
            property int reservedX: hasFullscreen ? 0 : monitor.lastIpcObject?.reserved?.[0]
            property int reservedY: hasFullscreen ? 0 : monitor.lastIpcObject?.reserved?.[1]

            implicitWidth: (monitor.width - reservedX) * root.scaleFactor
            implicitHeight: (monitor.height - reservedY) * root.scaleFactor

            color: "lightgrey"
            border.width: 2
            border.color: hasMaximized ? "red" : color

            MouseArea {
              anchors.fill: parent
              onClicked: Hyprland.dispatch(`workspace ${workspaceContainer.index + 1}`)
            }

            Repeater {
              model: workspaceContainer.workspace?.toplevels

              delegate: ScreencopyView {
                id: toplevel

                required property HyprlandToplevel modelData
                property Toplevel waylandHandle: modelData?.wayland
                property var toplevelData: modelData.lastIpcObject

                captureSource: waylandHandle
                live: true

                width: sourceSize.width * root.scaleFactor
                height: sourceSize.height * root.scaleFactor

                x: (toplevelData.at?.[0] - workspaceContainer.reservedX) * root.scaleFactor
                y: (toplevelData.at?.[1] - workspaceContainer.reservedY) * root.scaleFactor
                z: (waylandHandle.fullscreen || waylandHandle.maximized) ? 2 : toplevelData.floating

                IconImage {
                  source: Quickshell.iconPath(DesktopEntries.heuristicLookup(toplevel.toplevelData?.class)?.icon, "image-missing")
                  implicitSize: 48
                  anchors.centerIn: parent
                }

                MouseArea {
                  acceptedButtons: Qt.LeftButton | Qt.RightButton
                  anchors.fill: parent

                  onClicked: mouse => {
                    if (mouse.button === Qt.LeftButton)
                      toplevel.waylandHandle.activate();
                    else if (mouse.button === Qt.RightButton)
                      toplevel.waylandHandle.close();
                  }
                }
              }
            }

            Text {
              text: workspaceContainer.index + 1
              color: "red"
              x: 8
              anchors.bottom: parent.bottom
            }
          }
        }
      }
    }
  }
}