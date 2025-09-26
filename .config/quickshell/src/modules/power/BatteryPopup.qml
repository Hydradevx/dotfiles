import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.UPower
import Quickshell.Io
import "../../components/panels" as Panels
import "../../globals/state" as GlobalState

Panels.PopupWindow {
    id: batteryPopup
    visible: false
    implicitWidth: 320
    implicitHeight: hasBattery ? 200 : 160

    anchor.window: bar
    anchor.rect.x: bar.width - width - 10
    anchor.rect.y: bar.height + 4

    property bool hasBattery: false
    property string currentProfile: "balanced"

    onVisibleChanged: {
        if (visible) {
            updatePowerProfile()
        }
    }

    Timer {
        interval: 2000
        running: batteryPopup.visible
        repeat: true
        onTriggered: updateBatteryInfo()
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 16
        anchors.topMargin: 12
        spacing: 12

        // Header
        Text {
            text: hasBattery ? "Battery" : "Power"
            font.pixelSize: 18
            font.bold: true
            font.family: GlobalState.ThemeManager.fontFamily
            color: GlobalState.Colors.on_surface
        }

        // Battery info (only show if battery exists)
        ColumnLayout {
            visible: hasBattery
            Layout.fillWidth: true
            spacing: 8

            ProgressBar {
                id: batteryLevel
                from: 0
                to: 100
                value: 0
                Layout.fillWidth: true
                background: Rectangle { 
                    color: GlobalState.Colors.surface_variant; 
                    radius: 6 
                    implicitHeight: 12
                }
                contentItem: Rectangle { 
                    color: GlobalState.Colors.primary; 
                    radius: 6 
                    implicitHeight: 12
                }
            }

            RowLayout {
                Layout.fillWidth: true
                spacing: 8

                Text {
                    id: batteryPercentage
                    font.pixelSize: 14
                    font.bold: true
                    font.family: GlobalState.ThemeManager.fontFamily
                    color: GlobalState.Colors.primary
                }

                Text {
                    id: batteryStatus
                    font.pixelSize: 14
                    font.family: GlobalState.ThemeManager.fontFamily
                    color: GlobalState.Colors.on_surface_variant
                    Layout.fillWidth: true
                }

                Text {
                    id: batteryIcon
                    font.pixelSize: 16
                    font.family: "JetBrainsMono Nerd Font"
                    color: GlobalState.Colors.on_surface_variant
                }
            }
        }

        // Desktop message (when no battery)
        Text {
            visible: !hasBattery
            text: "󰌶 Desktop Mode"
            font.pixelSize: 14
            font.family: "JetBrainsMono Nerd Font"
            color: GlobalState.Colors.on_surface_variant
            Layout.alignment: Qt.AlignHCenter
        }

        // Power profile controls
        Panels.PowerProfileSelector {
            currentProfile: batteryPopup.currentProfile
            onProfileSelected: function(profile) {
                setPowerProfile(profile)
            }
        }
    }

    Process {
        id: profileProcess
        command: ["hydractl", "power", "get"]
        running: false
        stdout: StdioCollector {
            onStreamFinished: {
                var profile = this.text.trim().toLowerCase()
                console.log(`Power profile read: ${profile}`)
                
                if (profile === "performance") {
                    currentProfile = "performance"
                } else if (profile === "power-saver") {
                    currentProfile = "power-saver"
                } else {
                    currentProfile = "balanced"
                }
            }
        }
    }

    function updateBatteryInfo() {
        var dev = UPower.displayDevice
        hasBattery = !!dev

        if (dev) {
            batteryLevel.value = dev.percentage
            batteryPercentage.text = dev.percentage.toFixed(0) + "%"
            
            var stateStr = dev.state === UPowerDeviceState.Charging ? "Charging" :
                          dev.state === UPowerDeviceState.FullyCharged ? "Full" : "Discharging"
            batteryStatus.text = stateStr
            
            // Update battery icon
            if (dev.state === UPowerDeviceState.Charging) {
                batteryIcon.text = ""
            } else if (dev.percentage > 80) {
                batteryIcon.text = ""
            } else if (dev.percentage > 60) {
                batteryIcon.text = ""
            } else if (dev.percentage > 40) {
                batteryIcon.text = ""
            } else if (dev.percentage > 20) {
                batteryIcon.text = ""
            } else {
                batteryIcon.text = ""
            }
        }
    }

    function updatePowerProfile() {
        profileProcess.start()
    }

    function setPowerProfile(profile) {
        Quickshell.execDetached(["hydractl", "power", "set", profile])
        currentProfile = profile
    }

    Component.onCompleted: {
        updateBatteryInfo()
        updatePowerProfile()
    }
}