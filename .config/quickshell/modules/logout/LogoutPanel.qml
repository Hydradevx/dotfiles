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
            }
        }

        MouseArea {
            anchors.fill: parent
            onClicked: logoutPanel.visible = false
        }

        RowLayout {
            id: contentRow
            anchors.centerIn: parent
            spacing: 40

            Repeater {
                model: buttonModel

                delegate: Rectangle {
                    width: 100
                    height: 100
                    radius: 50
                    color: hovered ? Theme.Colors.primary : Theme.Colors.surface
                    border.color: Theme.Colors.outline

                    property bool hovered: false

                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true
                        onEntered: parent.hovered = true
                        onExited: parent.hovered = false
                        onClicked: {
                            runCommand(modelData.action)
                            logoutPanel.visible = false
                        }
                    }

                    Text {
                        anchors.centerIn: parent
                        text: modelData.icon
                        font.pixelSize: 40
                        color: parent.hovered ? Theme.Colors.on_primary : Theme.Colors.on_surface
                    }
                }
            }
        }
    }

    property var buttonModel: [
        { icon: "", action: "$HOME/.config/hypr/scripts/hyprlock.sh" }, // Lock
        { icon: "", action: "systemctl reboot" },                      // Reboot
        { icon: "", action: "systemctl poweroff" },                    // Shutdown
        { icon: "", action: "loginctl kill-session $XDG_SESSION_ID" }, // Logout
        { icon: "", action: "systemctl suspend" },                     // Suspend
        { icon: "󰒲", action: "systemctl hibernate" }                   // Hibernate
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