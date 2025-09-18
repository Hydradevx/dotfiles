import QtQuick
import "../public" as Theme

Text {
    id: clock
    color: Theme.Colors.on_surface
    font.pixelSize: 14
    font.family: "JetBrainsMono Nerd Font"
    text: Qt.formatDateTime(new Date(), "HH:mm")

    Timer {
        interval: 1000 * 60 
        running: true
        repeat: true
        onTriggered: clock.text = Qt.formatDateTime(new Date(), "HH:mm")
    }
}