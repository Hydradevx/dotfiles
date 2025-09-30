import QtQuick
import QtQuick.Effects
import QtQuick.Layouts
import QtQuick.Controls.Fusion
import "../../globals/state" as GlobalState

Item {
  id: time
  Column {
        anchors {
            horizontalCenter: parent.horizontalCenter
            top: parent.top
            topMargin: 120
        }
        spacing: 10

        Label {
            id: clock
            property var date: new Date()

            font.pixelSize: 100
            font.bold: true
            color: GlobalState.Colors.on_surface
            style: Text.Outline
            styleColor: GlobalState.Colors.outline
            horizontalAlignment: Text.AlignHCenter
            renderType: Text.NativeRendering

            Timer {
                running: true
                repeat: true
                interval: 1000
                onTriggered: clock.date = new Date();
            }

            text: {
                const hours = clock.date.getHours().toString().padStart(2, '0');
                const minutes = clock.date.getMinutes().toString().padStart(2, '0');
                return `${hours}:${minutes}`;
            }
        }

        Label {
            id: dateLabel
            text: Qt.formatDate(clock.date, "dddd, MMMM d yyyy")
            font.pixelSize: 28
            color: GlobalState.Colors.on_surface_variant
            horizontalAlignment: Text.AlignHCenter
            renderType: Text.NativeRendering
        }
  }
}