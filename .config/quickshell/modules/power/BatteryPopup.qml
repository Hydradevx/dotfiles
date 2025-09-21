import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import "../public" as Theme
import Quickshell.Services.UPower
import Quickshell.Io

PopupWindow {
    id: batteryPopup
    visible: false
    implicitWidth: 320
    implicitHeight: 180
    color: "transparent"

    anchor.window: bar
    anchor.rect.x: bar.width - width - 10
    anchor.rect.y: bar.height + 4

    Rectangle {
        anchors.fill: parent
        color: Theme.Colors.surface
        radius: 12
        border.color: Theme.Colors.outline
        border.width: 1

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 16
            spacing: 12

            // Header
            Text {
                text: "Battery"
                font.pixelSize: 18
                font.bold: true
                color: Theme.Colors.on_surface
            }

            // Progress + percentage
            ProgressBar {
                id: batteryLevel
                from: 0
                to: 100
                value: 0
                Layout.fillWidth: true
                background: Rectangle { color: Theme.Colors.surface_variant; radius: 6 }
                contentItem: Rectangle { color: Theme.Colors.primary; radius: 6 }
            }

            Text {
                id: batteryDetails
                font.pixelSize: 14
                color: Theme.Colors.on_surface_variant
            }

            // Power profile controls
            RowLayout {
                spacing: 12
                Layout.fillWidth: true

                Button {
                    Layout.fillWidth: true
                    text: "Performance"
                    background: Rectangle { color: Theme.Colors.primary; radius: 6 }
                    contentItem: Text { text: parent.text; anchors.centerIn: parent; color: Theme.Colors.surface }
                    onClicked: Quickshell.execDetached(["upowerctl", "set-profile", "performance"])
                }

                Button {
                    Layout.fillWidth: true
                    text: "Balanced"
                    background: Rectangle { color: Theme.Colors.primary; radius: 6 }
                    contentItem: Text { text: parent.text; anchors.centerIn: parent; color: Theme.Colors.surface }
                    onClicked: Quickshell.execDetached(["upowerctl", "set-profile", "balanced"])
                }

                Button {
                    Layout.fillWidth: true
                    text: "Power Saver"
                    background: Rectangle { color: Theme.Colors.primary; radius: 6 }
                    contentItem: Text { text: parent.text; anchors.centerIn: parent; color: Theme.Colors.surface }
                    onClicked: Quickshell.execDetached(["upowerctl", "set-profile", "powersave"])
                }
            }
        }
    }

    Timer {
        interval: 2000
        running: true
        repeat: true
        onTriggered: {
            var dev = UPower.displayDevice
            if (!dev) return

            batteryLevel.value = dev.percentage
            var stateStr = dev.state === UPowerDeviceState.Charging ? "Charging" :
                           dev.state === UPowerDeviceState.FullyCharged ? "Full" : "Discharging"

            batteryDetails.text = dev.percentage.toFixed(0) + "% - " + stateStr
        }
    }
}