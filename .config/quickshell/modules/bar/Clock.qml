import QtQuick
import "../public" as Theme

Text {
    id: clock
    color: Theme.Colors.on_surface
    font.pixelSize: 14
    text: Qt.formatDateTime(new Date(), "HH:mm:ss")

    Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: clock.text = Qt.formatDateTime(new Date(), "HH:mm:ss")
    }
}