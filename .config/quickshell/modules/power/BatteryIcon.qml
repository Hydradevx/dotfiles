import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import "../public" as Theme
import Quickshell.Services.UPower
import Quickshell.Io

Item {
    id: batteryIcon
    width: 28
    height: 28

    signal togglePopup(bool visible)

    property real scaleFactor: 1.0
    property bool isHovered: false
    property bool hasBattery: false

    Timer {
        interval: 2000
        running: true
        repeat: true
        onTriggered: updateBatteryInfo()
    }

    function updateBatteryInfo() {
        var dev = UPower.displayDevice
        if (!dev) {
            hasBattery = false
            icon.text = "" 
            icon.color = isHovered ? Theme.Colors.primary : Theme.Colors.on_surface
            return
        }

        hasBattery = true
        var pct = dev.percentage
        var state = dev.state

        if (state === UPowerDeviceState.Charging) icon.text = ""
        else if (pct > 80) icon.text = ""
        else if (pct > 60) icon.text = ""
        else if (pct > 40) icon.text = ""
        else if (pct > 20) icon.text = ""
        else icon.text = ""

        icon.color = isHovered ? Theme.Colors.primary : Theme.Colors.on_surface
    }

    Text {
        id: icon
        anchors.centerIn: parent
        font.pixelSize: 24
        font.family: "JetBrainsMono Nerd Font"
        text: ""
        color: isHovered ? Theme.Colors.primary : Theme.Colors.on_surface
        
        scale: batteryIcon.scaleFactor
        
        Behavior on scale {
            NumberAnimation { duration: 200; easing.type: Easing.OutBack }
        }
        Behavior on color {
            ColorAnimation { duration: 200; easing.type: Easing.InOutQuad }
        }

        MouseArea {
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            
            onEntered: {
                batteryIcon.scaleFactor = 1.2
                batteryIcon.isHovered = true
                batteryIcon.togglePopup(true)
            }
            onExited: {
                batteryIcon.scaleFactor = 1.0
                batteryIcon.isHovered = false
                batteryIcon.togglePopup(false)
            }
        }
    }

    Component.onCompleted: updateBatteryInfo()
}