import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import "../public" as Theme
import Quickshell.Io

PanelWindow {
    id: musicPopup
    visible: false
    implicitWidth: 600
    implicitHeight: 180
    color: "transparent"

    Rectangle {
        anchors.fill: parent
        color: Theme.Colors.surface
        border.color: Theme.Colors.outline
        border.width: 1
        radius: 12
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 15
        spacing: 12

        RowLayout {
            spacing: 15

            Rectangle {
                width: 80
                height: 80
                radius: 6
                border.color: Theme.Colors.outline
                border.width: 1
                clip: true

                Image {
                    id: albumArt
                    anchors.fill: parent
                    source: ""
                    fillMode: Image.PreserveAspectFit
                }
            }

            ColumnLayout {
                spacing: 4
                Layout.alignment: Qt.AlignVCenter

                Text {
                    id: trackTitle
                    text: "No Track"
                    font.pixelSize: 16
                    font.bold: true
                    color: Theme.Colors.on_surface
                    elide: Text.ElideRight
                }

                Text {
                    id: trackArtist
                    text: "Unknown"
                    font.pixelSize: 14
                    color: Theme.Colors.on_surface
                    elide: Text.ElideRight
                }
            }
        }

        RowLayout {
            spacing: 20
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignHCenter

            Button {
                font.pixelSize: 18
                Layout.preferredWidth: 50
                background: Rectangle { color: Theme.Colors.primary; radius: 6 }
                contentItem: Text { text: "⏮"; anchors.centerIn: parent; color: Theme.Colors.surface; font.pixelSize: 18 }
                onClicked: prevProc.running = true
            }

            Button {
                id: playPauseBtn
                text: "▶"
                font.pixelSize: 14
                Layout.preferredWidth: 50
                background: Rectangle { color: Theme.Colors.primary; radius: 6 }
                contentItem: Text { text: playPauseBtn.text; anchors.centerIn: parent; color: Theme.Colors.surface; font.pixelSize: 18 }
                onClicked: playPauseProc.running = true
            }

            Button {
                font.pixelSize: 18
                Layout.preferredWidth: 50
                background: Rectangle { color: Theme.Colors.primary; radius: 6 }
                contentItem: Text { text: "⏭"; anchors.centerIn: parent; color: Theme.Colors.surface; font.pixelSize: 18 }
                onClicked: nextProc.running = true
            }
        }
    }

    // Status process
    Process {
        id: statusProc
        command: ["playerctl", "metadata", "--format", "{{title}}|||{{artist}}|||{{mpris:artUrl}}|||{{status}}"]
        running: false
        stdout: StdioCollector {
            onStreamFinished: {
                try {
                    var parts = this.text.split("|||")
                    trackTitle.text = parts[0] || "No Track"
                    trackArtist.text = parts[1] || "Unknown"
                    albumArt.source = parts[2] || ""
                    playPauseBtn.text = (parts[3] === "Playing") ? "⏸" : "▶"
                } catch(e) {
                    console.log("playerctl parse error", e)
                }
            }
        }
    }

    // Control processes
    Process { id: playPauseProc; command: ["playerctl", "play-pause"] }
    Process { id: nextProc; command: ["playerctl", "next"] }
    Process { id: prevProc; command: ["playerctl", "previous"] }

    Timer {
        interval: 2000
        running: true
        repeat: true
        onTriggered: statusProc.running = true
    }
}