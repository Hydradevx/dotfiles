import QtQuick
import QtQuick.Layouts
import "../../globals/state" as GlobalState
import "../buttons"

ColumnLayout {
    id: profileSelector
    spacing: 8
    
    property string currentProfile: "balanced"
    
    signal profileSelected(string profile)
    
    Text {
        text: "Power Profile"
        font.pixelSize: 14
        font.bold: true
        font.family: GlobalState.ThemeManager.fontFamily
        color: GlobalState.Colors.on_surface
        Layout.alignment: Qt.AlignLeft
    }

    RowLayout {
        spacing: 8
        Layout.fillWidth: true

        ProfileButton {
            profile: "performance"
            icon: "󰓅"
            tooltip: "Performance"
            isSelected: profileSelector.currentProfile === "performance"
            onClicked: profileSelector.profileSelected("performance")
        }

        ProfileButton {
            profile: "balanced"
            icon: "󰂎"
            tooltip: "Balanced"
            isSelected: profileSelector.currentProfile === "balanced"
            onClicked: profileSelector.profileSelected("balanced")
        }

        ProfileButton {
            profile: "power-saver"
            icon: "󱧥"
            tooltip: "Power Saver"
            isSelected: profileSelector.currentProfile === "power-saver"
            onClicked: profileSelector.profileSelected("power-saver")
        }
    }
}