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
    implicitHeight: 240  // Increased height for speedometer needles
    color: "transparent"

    anchor.window: bar
    anchor.rect.x: bar.width
    anchor.rect.y: bar.height

    // Animation properties
    property real popupScale: 0.0
    property real popupOpacity: 0.0

    onVisibleChanged: {
        if (visible) {
            showAnimation.start()
        } else {
            hideAnimation.start()
        }
    }

    ParallelAnimation {
        id: showAnimation
        NumberAnimation {
            target: perfPopup
            property: "popupScale"
            from: 0.0
            to: 1.0
            duration: 300
            easing.type: Easing.OutBack
            easing.overshoot: 1.5
        }
        NumberAnimation {
            target: perfPopup
            property: "popupOpacity"
            from: 0.0
            to: 1.0
            duration: 200
        }
    }

    ParallelAnimation {
        id: hideAnimation
        NumberAnimation {
            target: perfPopup
            property: "popupScale"
            from: 1.0
            to: 0.0
            duration: 200
            easing.type: Easing.InBack
        }
        NumberAnimation {
            target: perfPopup
            property: "popupOpacity"
            from: 1.0
            to: 0.0
            duration: 150
        }
    }

    // Mouse area to keep popup open when hovering over it
    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        onEntered: perfPopup.visible = true
        onExited: {
            if (!perfIcon.isHovered) {
                perfPopup.visible = false
            }
        }
    }

    Rectangle {
        anchors.fill: parent
        color: Theme.Colors.surface
        radius: 12
        
        // Remove top border and apply bottom-only rounding
        Rectangle {
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            height: parent.radius
            color: parent.color
        }

        RowLayout {
            anchors.fill: parent
            anchors.margins: 20
            anchors.topMargin: 12
            spacing: 30

            SpeedometerGauge {
                id: cpuGauge
                label: "CPU"
                value: 0
                maxValue: 100
                Layout.preferredWidth: 160
                Layout.preferredHeight: 160
            }

            SpeedometerGauge {
                id: ramGauge
                label: "RAM" 
                value: 0
                maxValue: 100
                Layout.preferredWidth: 160
                Layout.preferredHeight: 160
            }

            SpeedometerGauge {
                id: diskGauge
                label: "DISK"
                value: 0
                maxValue: 100
                Layout.preferredWidth: 160
                Layout.preferredHeight: 160
            }
        }
    }

    // Performance data process
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
                    cpuGauge.value = parseFloat(data.cpu) || 0
                    ramGauge.value = parseFloat(data.ram) || 0
                    diskGauge.value = parseFloat(data.disk) || 0
                } catch(e) {
                    console.log("hydractl perf parse error", e, "RAW OUTPUT:", this.text)
                }
            }
        }
    }

    Timer {
        interval: 2000
        running: perfPopup.visible
        repeat: true
        onTriggered: perfProc.running = true
    }

    Component.onCompleted: perfProc.running = true
}