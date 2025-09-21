import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import "../public" as Theme

PopupWindow {
    id: perfPopup
    visible: false
    implicitWidth: 600
    implicitHeight: 220
    color: "transparent"

    anchor.window: bar
    anchor.rect.x: bar.width / 2 - width / 2
    anchor.rect.y: bar.height

    Rectangle {
        anchors.fill: parent
        color: Theme.Colors.surface
        border.color: Theme.Colors.outline
        border.width: 1
        radius: 12
    }

    RowLayout {
        anchors.fill: parent
        anchors.margins: 20
        spacing: 30

        PerfCircle {
            id: cpuCircle
            sublabel1: "CPU"
            sublabel2: "Usage"
        }

        PerfCircle {
            id: ramCircle
            sublabel1: "RAM"
            sublabel2: "Usage"
        }

        PerfCircle {
            id: diskCircle
            sublabel1: "Disk"
            sublabel2: "Usage"
        }
    }

    // One single process for all metrics
    Process {
        id: perfProc
        command: ["hydractl", "perf"]
        running: false
        stdout: StdioCollector {
            onStreamFinished: {
                if (this.text.trim() === "") {
                    Qt.callLater(() => perfProc.running = true)
                    return
                }
                try {
                    var data = JSON.parse(this.text.trim())
                    cpuCircle.mainLabel = data.cpu + "%"
                    ramCircle.mainLabel = data.ram + "%"
                    diskCircle.mainLabel = data.disk + "%"
                } catch(e) {
                    console.log("hydractl perf parse error", e, "RAW OUTPUT:", this.text)
                }
            }
        }
    }

    Timer {
        interval: 2000
        running: true
        repeat: true
        onTriggered: perfProc.running = true
        Component.onCompleted: Qt.callLater(() => running = true)
    }
}