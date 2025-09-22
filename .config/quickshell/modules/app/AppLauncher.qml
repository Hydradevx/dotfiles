import Quickshell
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell.Hyprland
import "../public" as Theme

PopupWindow {
    id: appLauncher
    visible: false
    implicitWidth: 800
    implicitHeight: 500
    color: "transparent"

    anchor.window: bar
    anchor.rect.x: bar.width / 2 - width / 2
    anchor.rect.y: screen.height / 2 + bar.height / 2 - height / 2

    Rectangle {
        anchors.fill: parent
        radius: 12
        color: Theme.Colors.surface
        border.color: Theme.Colors.outline
        border.width: 1
        opacity: 0.95

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 16
            spacing: 12
        }
    }

    GlobalShortcut {
        name: "appLauncherToggle"
        description: "Toggle App Launcher"
        onPressed: appLauncher.visible = !appLauncher.visible
    }
}