import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Hyprland

Scope {
    id: performanceScope

    Item {
        id: perfOverlay
        visible: false
        width: parent.width
        height: 200

        Rectangle {
            anchors.fill: parent
            color: "#1e1e2e"
            border.color: "#89b4fa"
            border.width: 2
            radius: 10

            Column {
                anchors.centerIn: parent
                spacing: 8

                Text { text: "CPU: 12%"; color: "#a6e3a1" }
                Text { text: "RAM: 2.4 GB"; color: "#f9e2af" }
                Text { text: "Net: 20 Mbps"; color: "#89dceb" }
            }
        }
    }

    IpcHandler {
        target: "performance"

        function toggle(): void { perfOverlay.visible = !perfOverlay.visible }
        function close(): void { perfOverlay.visible = false }
        function open(): void { perfOverlay.visible = true }
    }

    GlobalShortcut {
        name: "performanceToggle"
        description: "Toggles Performance Monitor"
        onPressed: perfOverlay.visible = !perfOverlay.visible
    }

    GlobalShortcut {
        name: "performanceOpen"
        description: "Opens Performance Monitor"
        onPressed: perfOverlay.visible = true
    }

    GlobalShortcut {
        name: "performanceClose"
        description: "Closes Performance Monitor"
        onPressed: perfOverlay.visible = false
    }
}