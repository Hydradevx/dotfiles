import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import "../../components/panels" as Panels
import "../../components/media" as Media
import "../../globals/state" as GlobalState

Panels.PopupWindow {
    id: musicPopup
    visible: false
    implicitWidth: 500
    implicitHeight: 180
    
    anchor.window: bar
    anchor.rect.x: bar.width
    anchor.rect.y: bar.height

    property real progressValue: 0
    property string durationText: "0:00 / 0:00"

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        onEntered: musicPopup.visible = true
        onExited: {
            // Keep visible if music icon is hovered (handled externally)
        }
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 16
        anchors.topMargin: 12 
        spacing: 12

        RowLayout {
            spacing: 15
            Layout.fillWidth: true

            Media.AlbumArt {
                id: albumArt
                imageSource: ""
            }

            ColumnLayout {
                spacing: 4
                Layout.alignment: Qt.AlignVCenter
                Layout.fillWidth: true

                Text {
                    id: trackTitle
                    text: "No Track"
                    font.pixelSize: 16
                    font.bold: true
                    font.family: GlobalState.ThemeManager.fontFamily
                    color: GlobalState.Colors.on_surface
                    elide: Text.ElideRight
                    Layout.fillWidth: true
                }

                Text {
                    id: trackArtist
                    text: "Unknown"
                    font.pixelSize: 14
                    font.family: GlobalState.ThemeManager.fontFamily
                    color: GlobalState.Colors.on_surface_variant
                    elide: Text.ElideRight
                    Layout.fillWidth: true
                }

                Text {
                    id: progressText
                    text: durationText
                    font.pixelSize: 12
                    font.family: GlobalState.ThemeManager.fontFamily
                    color: GlobalState.Colors.on_surface_variant
                    Layout.fillWidth: true
                }
            }
        }  
        
        Media.ProgressBar {
            id: progressBar
            Layout.fillWidth: true
            progress: musicPopup.progressValue
            
            onSeekRequested: function(position) {
                seekProc.running = true
            }
        }

        Media.MediaControls {
            id: mediaControls
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignHCenter
            
            onPlayPauseClicked: playPauseProc.running = true
            onNextClicked: nextProc.running = true
            onPreviousClicked: prevProc.running = true
        }
    }

    Process {
        id: statusProc
        command: ["hydractl", "music", "status"]
        running: false
        stdout: StdioCollector {
            onStreamFinished: {
                try {
                    if (this.text.trim() === "") {
                        Qt.callLater(() => {
                            spotifyStarter.running = true
                            statusProc.running = true
                        })
                        return
                    }
                    var data = JSON.parse(this.text.trim())
                    trackTitle.text = data.title || "No Track"
                    trackArtist.text = data.artist || "Unknown"
                    albumArt.imageSource = data.albumArt || ""
                    mediaControls.isPlaying = data.playing
                    albumArt.isPlaying = data.playing

                    var progress = data.position / Math.max(data.length, 1)
                    progressValue = Math.min(Math.max(progress, 0), 1)

                    var currentTime = formatTime(data.position || 0)
                    var totalTime = formatTime(data.length || 0)
                    durationText = currentTime + " / " + totalTime
                    
                } catch(e) {
                    console.log("hydractl parse error", e, this.text)
                }
            }
        }
    }

    function formatTime(seconds) {
        var mins = Math.floor(seconds / 60)
        var secs = Math.floor(seconds % 60)
        return mins + ":" + (secs < 10 ? "0" + secs : secs)
    }

    Process {
        id: spotifyStarter
        command: ["bash", "-c", "playerctl status || spotify &"]
        running: false
    }

    Process { id: playPauseProc; command: ["hydractl", "music", "play-pause"] }
    Process { id: nextProc; command: ["hydractl", "music", "next"] }
    Process { id: prevProc; command: ["hydractl", "music", "previous"] }
    Process { id: seekProc; command: ["bash", "-c", "playerctl position `playerctl metadata --format '{{duration}}'`"] }

    Timer {
        interval: 1000  
        running: musicPopup.visible
        repeat: true
        onTriggered: statusProc.running = true
    }

    Component.onCompleted: {
        spotifyStarter.running = true
        statusProc.running = true
    }
}