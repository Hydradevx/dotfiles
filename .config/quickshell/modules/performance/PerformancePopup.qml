import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import "../public" as Theme

PanelWindow {
    id: perfPopup
    visible: false
    implicitWidth: 500
    implicitHeight: 220

    Rectangle {
        anchors.fill: parent
        color: Theme.Colors.surface
        border.color: Theme.Colors.outline
        border.width: 1
        radius: 12

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
}