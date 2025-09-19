import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell.Io
import Quickshell.Hyprland
import Quickshell.Widgets
import Quickshell
import "../public" as Theme

Scope {
    id: performanceScope
    
    PanelWindow {
    id: perfPopup
    visible: false
    implicitWidth: 500
    implicitHeight: 220

    RowLayout {
        anchors.fill: parent
        anchors.margins: 20
        spacing: 30

        PerfCircle {
            sublabel1: "CPU"
            sublabel2: "Usage"
            command1: "top -bn1 | grep 'Cpu(s)' | awk '{print $2 + $4}'"
        }

        PerfCircle {
            sublabel1: "RAM"
            sublabel2: "Usage"
            command1: "free | awk '/Mem/ {printf(\"%.0f\", $3/$2 * 100)}'"
        }

        PerfCircle {
            sublabel1: "Disk"
            sublabel2: "Usage"
            command1: "df -h / | awk 'NR==2 {print $5}' | tr -d '%'"
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