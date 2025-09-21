import QtQuick
import Quickshell
import "../public" as Theme
import Quickshell.Services.UPower

Item {
    id: batteryIcon
    width: 28
    height: 28

    signal togglePopup()

    Timer {
        interval: 2000
        running: true
        repeat: true
        onTriggered: {
            var dev = UPower.displayDevice
            if (!dev) return

            var pct = dev.percentage
            var state = dev.state

            if (state === UPowerDeviceState.Charging) icon.text = ""
            else if (pct > 80) icon.text = ""
            else if (pct > 60) icon.text = ""
            else if (pct > 40) icon.text = ""
            else if (pct > 20) icon.text = ""
            else icon.text = ""

            icon.color = Theme.Colors.on_surface
        }
    }

    Text {
        id: icon
        anchors.centerIn: parent
        font.pixelSize: 24
        font.family: "JetBrainsMono Nerd Font"
        text: ""
        color: Theme.Colors.on_surface

        MouseArea {
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onClicked: batteryIcon.togglePopup()
        }
    }
}