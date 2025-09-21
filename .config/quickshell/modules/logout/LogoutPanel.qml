import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland
import Quickshell.Io
import "../public" as Theme

PanelWindow {
    anchors.top: true
    anchors.left: true
    anchors.right: true
    anchors.bottom: true
    id: logoutPanel
    visible: false

    color: "transparent"

    Rectangle {
        id: bg
        anchors.fill: parent
        color: Theme.Colors.surface_variant
        opacity: 0.9
        focus: true

        Keys.onPressed: event => {
            if (event.key === Qt.Key_Escape) {
                logoutPanel.visible = false
            } else {
                for (let i = 0; i < buttonModel.length; i++) {
                    let btn = buttonModel[i]
                    if (event.text === btn.keybind) {
                        runCommand(btn.action)
                        logoutPanel.visible = false
                    }
                }
            }
        }

        MouseArea {
            anchors.fill: parent
            onClicked: logoutPanel.visible = false
        }

        ColumnLayout {
            id: contentColumn
            anchors.centerIn: parent
            spacing: 12
            width: 300

            Repeater {
                model: buttonModel

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
                            runCommand(modelData.action)
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
    }

    property var buttonModel: [
        { text: "Lock", action: "$HOME/.config/hypr/scripts/hyprlock.sh", keybind: "l" },
        { text: "Reboot", action: "systemctl reboot", keybind: "r" },
        { text: "Shutdown", action: "systemctl poweroff", keybind: "s" },
        { text: "Logout", action: "loginctl kill-session $XDG_SESSION_ID", keybind: "e" },
        { text: "Suspend", action: "systemctl suspend", keybind: "u" },
        { text: "Hibernate", action: "systemctl hibernate", keybind: "h" }
    ]

    function runCommand(cmd) {
        try {
            Qt.createQmlObject(
                'import Quickshell.Io; Process { command: ["bash","-c","' + cmd + '"]; running: true }',
                logoutPanel
            )
        } catch (e) {
            console.log("Failed to run:", cmd, e)
        }
    }

    IpcHandler {
        target: "logout"
        function toggle(): void { logoutPanel.visible = !logoutPanel.visible }
    }

    GlobalShortcut {
        name: "logoutToggle"
        description: "Toggles Logout Panel"
        onPressed: logoutPanel.visible = !logoutPanel.visible
    }
}