import QtQuick
import QtQuick.Controls
import Quickshell.Io
import Quickshell.Hyprland
import Quickshell.Io
import Quickshell
import "../public" as Theme

Scope {
    id: performanceScope
    PanelWindow {
        id: perfPopup
        visible: false
        width: 480
        height: 200

        Rectangle {
    id: popup
    width: 400
    height: 200
    radius: 12
    color: Theme.Colors.surface
    border.color: Theme.Colors.outline
    border.width: 1

    Row {
        anchors.centerIn: parent
        spacing: 20

        PerfCircle {
            label: "CPU"
            command: "top -bn1 | grep 'Cpu(s)' | awk '{print $2 + $4}'"
            suffix: "%"
        }

        PerfCircle {
            label: "RAM"
            command: "free | awk '/Mem/ {printf(\"%.0f\", $3/$2 * 100)}'"
            suffix: "%"
        }

        PerfCircle {
            label: "Disk"
            command: "df -h / | awk 'NR==2 {print $5}'"
            suffix: ""
        }
    }
    }
    }

    IpcHandler {
    target: "performance"
    function toggle(): void { perfPopup.visible = !perfPopup.visible; }
    function close(): void { perfPopup.visible = false; }
    function open(): void { perfPopup.visible = true; }
}

GlobalShortcut {
    name: "performanceToggle"
    description: "Toggles Performance Monitor"
    onPressed: perfPopup.visible = !perfPopup.visible
}

GlobalShortcut {
    name: "performanceOpen"
    description: "Opens Performance Monitor"
    onPressed: perfPopup.visible = true
}

GlobalShortcut {
    name: "performanceClose"
    description: "Closes Performance Monitor"
    onPressed: perfPopup.visible = false
}
}