import QtQuick
import "../public" as Theme

Row {
    id: clock
    spacing: 6
    anchors.centerIn: parent
    anchors.verticalCenter: parent.verticalCenter

    Text {
        id: timeText
        color: Theme.Colors.on_surface
        font.pixelSize: 14
        font.family: "JetBrainsMono Nerd Font"
        text: Qt.formatDateTime(new Date(), "HH:mm")

        Timer {
            interval: 60000
            running: true
            repeat: true
            onTriggered: timeText.text = Qt.formatDateTime(new Date(), "HH:mm")
        }
    }

    Text {
        id: dateText
        color: Theme.Colors.on_surface_variant
        font.pixelSize: 14
        font.family: "JetBrainsMono Nerd Font"
        text: Qt.formatDateTime(new Date(), "ddd, dd MMM")

        Timer {
            interval: 60000
            running: true
            repeat: true
            onTriggered: dateText.text = Qt.formatDateTime(new Date(), "ddd, dd MMM")
        }
    }
}