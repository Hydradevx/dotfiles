import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import "../public" as Theme
import Quickshell.Io

PopupWindow {
    id: musicPopup
    visible: false
    implicitWidth: 500
    implicitHeight: 160
    color: "transparent"

    anchor.window: bar
    anchor.rect.x: bar.width / 2 + bar.width / 2
    anchor.rect.y: bar.height

    Rectangle {
        id: bg
        anchors.fill: parent
        color: Theme.Colors.surface
        radius: 12
        border.color: Theme.Colors.outline
        border.width: 1

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 16
            spacing: 12

            RowLayout {
                spacing: 15

                // Album art
                Rectangle {
                    width: 80
                    height: 80
                    radius: 8
                    border.color: Theme.Colors.outline
                    border.width: 1
                    clip: true

                    Image {
                        id: albumArt
                        anchors.fill: parent
                        fillMode: Image.PreserveAspectFit
                        source: ""
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
                        color: Theme.Colors.on_surface_variant
                        elide: Text.ElideRight
                    }
                }
            }

            RowLayout {
                spacing: 20
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignHCenter

                // Previous
                Rectangle {
                    width: 40; height: 40; radius: 8
                    color: Theme.Colors.primary
                    border.color: Theme.Colors.outline
                    border.width: 1

                    Text {
                        anchors.centerIn: parent
                        text: "⏮"
                        font.pixelSize: 18
                        color: Theme.Colors.surface
                    }

                    MouseArea {
                        anchors.fill: parent
                        onClicked: prevProc.running = true
                    }
                }

                // Play/Pause
                Rectangle {
                    id: playPauseBtnRect
                    width: 40; height: 40; radius: 8
                    color: Theme.Colors.primary
                    border.color: Theme.Colors.outline
                    border.width: 1

                    Text {
                        id: playPauseBtn
                        anchors.centerIn: parent
                        text: "▶"
                        font.pixelSize: 18
                        color: Theme.Colors.surface
                    }

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            playPauseProc.running = true
                            statusProc.running = true
                        }
                    }
                }

                // Next
                Rectangle {
                    width: 40; height: 40; radius: 8
                    color: Theme.Colors.primary
                    border.color: Theme.Colors.outline
                    border.width: 1

                    Text {
                        anchors.centerIn: parent
                        text: "⏭"
                        font.pixelSize: 18
                        color: Theme.Colors.surface
                    }

                    MouseArea {
                        anchors.fill: parent
                        onClicked: nextProc.running = true
                    }
                }
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
                    if (this.text.trim() === "") {
                        Qt.callLater(() => statusProc.running = true)
                        return
                    }
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
        Component.onCompleted: Qt.callLater(() => running = true)
    }
}