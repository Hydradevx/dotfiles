import QtQuick
import Quickshell
import "../../../components/icons" as Icons

Icons.AnimatedIcon {
    id: musicIcon
    icon: "󰎆"
    iconSize: 28
    
    signal togglePopup(bool visible)
    
    onHovered: function(hovered) {
        musicIcon.togglePopup(hovered)
    }
}