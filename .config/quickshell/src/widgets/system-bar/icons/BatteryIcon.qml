import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.UPower
import Quickshell.Io
import "../../../components/icons" as Icons

Icons.StatusIcon {
    id: batteryIcon
    icon: ""
    iconSize: 24
    updateInterval: 2000
    
    signal togglePopup(bool visible)
    
    onHovered: function(hovered) {
        batteryIcon.togglePopup(hovered)
    }
    
    statusUpdateFunction: updateBatteryInfo
    
    function updateBatteryInfo() {
        var dev = UPower.displayDevice
        if (!dev) {
            batteryIcon.icon = "" 
            return
        }

        var pct = dev.percentage
        var state = dev.state

        if (state === UPowerDeviceState.Charging) batteryIcon.icon = ""
        else if (pct > 80) batteryIcon.icon = ""
        else if (pct > 60) batteryIcon.icon = ""
        else if (pct > 40) batteryIcon.icon = ""
        else if (pct > 20) batteryIcon.icon = ""
        else batteryIcon.icon = ""
    }
    
    Component.onCompleted: updateBatteryInfo()
}