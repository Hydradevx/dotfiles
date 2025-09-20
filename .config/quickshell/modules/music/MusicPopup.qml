import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import "../public" as Theme
import Quickshell.Io

PopupWindow {
    id: musicPopup
    visible: false
    width: 600
    height: 180
    color: "transparent"

    anchor.window: bar
    anchor.rect.x: bar.width / 2 - width / 2
    anchor.rect.y: bar.height

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
                Layout.preferredWidth: 50
                background: Rectangle { color: Theme.Colors.primary; radius: 6 }
                contentItem: Text { text: "⏮"; anchors.centerIn: parent; color: Theme.Colors.surface; font.pixelSize: 18 }
                onClicked: prevProc.running = true
            }

            Button {
                id: playPauseBtn
                text: ""
                Layout.preferredWidth: 50
                background: Rectangle { color: Theme.Colors.primary; radius: 6 }
                contentItem: Text {
                    text: playPauseBtn.text
                    anchors.centerIn: parent
                    color: Theme.Colors.surface
                    font.pixelSize: 18
                }
                onClicked: {
                    playPauseProc.running = true
                    statusProc.running = true
                }
            }

            Button {
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
        command: ["hydractl", "music", "status"]
        running: false
        stdout: StdioCollector {
            onStreamFinished: {
                try {
                    var data = JSON.parse(this.text.trim())
                    trackTitle.text = data.title || "No Track"
                    trackArtist.text = data.artist || "Unknown"
                    albumArt.source = data.albumArt || ""

                    playPauseBtn.text = data.playing ? "⏸" : "▶"
                } catch(e) {
                    console.log("hydractl parse error", e, this.text)
                }
            }
        }
    }

    Process { id: playPauseProc; command: ["hydractl", "music", "play-pause"] }
    Process { id: nextProc; command: ["hydractl", "music", "next"] }
    Process { id: prevProc; command: ["hydractl", "music", "previous"] }

    Timer {
        interval: 2000
        running: true
        repeat: true
        onTriggered: statusProc.running = true
    }
}