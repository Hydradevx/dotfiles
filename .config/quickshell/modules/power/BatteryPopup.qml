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
    implicitHeight: hasBattery ? 200 : 160
    color: "transparent"

    anchor.window: bar
    anchor.rect.x: bar.width - width - 10
    anchor.rect.y: bar.height + 4

    // Animation properties
    property real popupScale: 0.0
    property real popupOpacity: 0.0
    property bool hasBattery: false
    property string currentProfile: "balanced"

    onVisibleChanged: {
        if (visible) {
            showAnimation.start()
            updatePowerProfile()
        } else {
            hideAnimation.start()
        }
    }

    ParallelAnimation {
        id: showAnimation
        NumberAnimation {
            target: batteryPopup
            property: "popupScale"
            from: 0.0
            to: 1.0
            duration: 300
            easing.type: Easing.OutBack
            easing.overshoot: 1.5
        }
        NumberAnimation {
            target: batteryPopup
            property: "popupOpacity"
            from: 0.0
            to: 1.0
            duration: 200
        }
    }

    ParallelAnimation {
        id: hideAnimation
        NumberAnimation {
            target: batteryPopup
            property: "popupScale"
            from: 1.0
            to: 0.0
            duration: 200
            easing.type: Easing.InBack
        }
        NumberAnimation {
            target: batteryPopup
            property: "popupOpacity"
            from: 1.0
            to: 0.0
            duration: 150
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
                color: Theme.Colors.on_surface
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
                        color: Theme.Colors.surface_variant; 
                        radius: 6 
                        implicitHeight: 12
                    }
                    contentItem: Rectangle { 
                        color: Theme.Colors.primary; 
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
                        color: Theme.Colors.primary
                    }

                    Text {
                        id: batteryStatus
                        font.pixelSize: 14
                        color: Theme.Colors.on_surface_variant
                        Layout.fillWidth: true
                    }

                    Text {
                        id: batteryIcon
                        font.pixelSize: 16
                        font.family: "JetBrainsMono Nerd Font"
                        color: Theme.Colors.on_surface_variant
                    }
                }
            }

            // Desktop message (when no battery)
            Text {
                visible: !hasBattery
                text: "󰌶 Desktop Mode"
                font.pixelSize: 14
                font.family: "JetBrainsMono Nerd Font"
                color: Theme.Colors.on_surface_variant
                Layout.alignment: Qt.AlignHCenter
            }

            // Power profile controls with icons
            ColumnLayout {
                spacing: 8
                Layout.fillWidth: true

                Text {
                    text: "Power Profile"
                    font.pixelSize: 14
                    font.bold: true
                    color: Theme.Colors.on_surface
                    Layout.alignment: Qt.AlignLeft
                }

                RowLayout {
                    spacing: 8
                    Layout.fillWidth: true

                    // Performance
                    Rectangle {
                        id: performanceBtn
                        Layout.fillWidth: true
                        Layout.preferredHeight: 40
                        radius: 8
                        color: currentProfile === "performance" ? Theme.Colors.primary : Theme.Colors.surface_variant
                        border.color: currentProfile === "performance" ? Theme.Colors.primary : Theme.Colors.outline
                        border.width: 2

                        RowLayout {
                            anchors.centerIn: parent
                            spacing: 6

                            Text {
                                text: "󰓅"
                                font.pixelSize: 16
                                font.family: "JetBrainsMono Nerd Font"
                                color: currentProfile === "performance" ? Theme.Colors.on_primary : Theme.Colors.on_surface_variant
                            }
                        }

                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: setPowerProfile("performance")
                        }
                    }

                    // Balanced
                    Rectangle {
                        id: balancedBtn
                        Layout.fillWidth: true
                        Layout.preferredHeight: 40
                        radius: 8
                        color: currentProfile === "balanced" ? Theme.Colors.primary : Theme.Colors.surface_variant
                        border.color: currentProfile === "balanced" ? Theme.Colors.primary : Theme.Colors.outline
                        border.width: 2

                        RowLayout {
                            anchors.centerIn: parent
                            spacing: 6

                            Text {
                                text: "󰂎"
                                font.pixelSize: 16
                                font.family: "JetBrainsMono Nerd Font"
                                color: currentProfile === "balanced" ? Theme.Colors.on_primary : Theme.Colors.on_surface_variant
                            }
                        }

                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: setPowerProfile("balanced")
                        }
                    }

                    // Power Saver
                    Rectangle {
                        id: powerSaverBtn
                        Layout.fillWidth: true
                        Layout.preferredHeight: 40
                        radius: 8
                        color: currentProfile === "power-saver" ? Theme.Colors.primary : Theme.Colors.surface_variant
                        border.color: currentProfile === "power-saver" ? Theme.Colors.primary : Theme.Colors.outline
                        border.width: 2

                        RowLayout {
                            anchors.centerIn: parent
                            spacing: 6

                            Text {
                                text: "󱧥"
                                font.pixelSize: 16
                                font.family: "JetBrainsMono Nerd Font"
                                color: currentProfile === "power-saver" ? Theme.Colors.on_primary : Theme.Colors.on_surface_variant
                            }
                        }

                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: setPowerProfile("power-saver")
                        }
                    }
                }
            }
        }
    }

    Timer {
        interval: 2000
        running: batteryPopup.visible
        repeat: true
        onTriggered: updateBatteryInfo()
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