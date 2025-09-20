import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland
import Quickshell.Io
import "../public" as Theme

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland
import Quickshell.Io
import "../public" as Theme

PopupWindow {
    id: logoutPanel
    visible: false
    implicitWidth: parent ? parent.width : 1920  
    implicitHeight: parent ? parent.height : 1080
    color: Theme.Colors.surface

    Rectangle {
        anchors.fill: parent
        color: Theme.Colors.surface_variant
        opacity: 0.95
    }

    ColumnLayout {
        id: contentColumn
        anchors.centerIn: parent
        spacing: 12
        width: 300

        Repeater {
            model: [
                { text: "Lock", action: "$HOME/.config/hypr/scripts/hyprlock.sh", keybind: "l" },
                { text: "Reboot", action: "systemctl reboot", keybind: "r" },
                { text: "Shutdown", action: "systemctl poweroff", keybind: "s" },
                { text: "Logout", action: "loginctl kill-session $XDG_SESSION_ID", keybind: "e" },
                { text: "Suspend", action: "systemctl suspend", keybind: "u" },
                { text: "Hibernate", action: "systemctl hibernate", keybind: "h" }
            ]

            delegate: Rectangle {
                width: parent.width
                height: 50
                radius: 8
                color: Theme.Colors.surface
                border.color: Theme.Colors.outline

                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true
                    onClicked: {
                        Qt.createQmlObject(
                            'import Quickshell.Io 1.0; Process { command: ["bash","-c","' + modelData.action + '"]; running: true }',
                            logoutPanel
                        )
                        logoutPanel.visible = false
                    }
                }

                RowLayout {
                    anchors.fill: parent
                    anchors.margins: 10
                    spacing: 12

                    Text { text: modelData.text; font.pixelSize: 16; color: Theme.Colors.on_surface }
                    Item { Layout.fillWidth: true }
                    Text { text: "(" + modelData.keybind + ")"; font.pixelSize: 14; color: Theme.Colors.on_surface_variant }
                }
            }
        }
    }

    IpcHandler {
        target: "logout"

        function toggle(): void { logoutPanel.visible = !logoutPanel.visible }
        function open(): void { logoutPanel.visible = true }
        function close(): void { logoutPanel.visible = false }
    }

    GlobalShortcut {
        name: "logoutToggle"
        description: "Toggles Logout Panel"
        onPressed: console.log("Toggling Logout Panel"), logoutPanel.visible = !logoutPanel.visible
    }

    GlobalShortcut {
        name: "logoutOpen"
        description: "Opens Logout Panel"
        onPressed: logoutPanel.visible = true
    }

    GlobalShortcut {
        name: "logoutClose"
        description: "Closes Logout Panel"
        onPressed: logoutPanel.visible = false
    }
}