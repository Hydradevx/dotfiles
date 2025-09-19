import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import "../public" as Theme
import "SpotifyController.js" as SpotifyController

Item {
    id: spotifyIcon
    width: 24
    height: 24
    signal togglePopup()

    // Spotify popup
    PanelWindow {
        id: spotifyPopup
        visible: false
        implicitWidth: 600
        implicitHeight: 100
        color: "transparent"

        Rectangle {
            anchors.fill: parent
            color: Theme.Colors.surface
            border.color: Theme.Colors.outline
            border.width: 1
            radius: 12
        }

        RowLayout {
            anchors.fill: parent
            anchors.margins: 20
            spacing: 20

            // Album art
            Image {
                id: albumArt
                width: 50
                height: 50
                fillMode: Image.PreserveAspectFit
                source: SpotifyController.currentTrack?.albumArt || ""
            }

            // Track info
            ColumnLayout {
                spacing: 2
                Text {
                    id: trackTitle
                    text: SpotifyController.currentTrack?.title || "No Track"
                    font.pixelSize: 16
                    font.bold: true
                    color: Theme.Colors.on_surface
                }
                Text {
                    id: trackArtist
                    text: SpotifyController.currentTrack?.artist || "Unknown"
                    font.pixelSize: 14
                    color: Theme.Colors.on_surface
                }
            }

            // Controls
            Button { text: "⏮"; onClicked: SpotifyController.prev(); background: Rectangle { color: "transparent" } }
            Button { id: playPauseBtn; text: SpotifyController.playing ? "⏸" : "▶"; onClicked: SpotifyController.playPause(); background: Rectangle { color: "transparent" } }
            Button { text: "⏭"; onClicked: SpotifyController.next(); background: Rectangle { color: "transparent" } }
        }
    }

    // Icon
    Text {
        text: "󰎆"
        font.pixelSize: 28
        font.family: "JetBrainsMono Nerd Font"
        color: Theme.Colors.on_surface
        anchors.centerIn: parent

        MouseArea {
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onClicked: spotifyIcon.togglePopup()
        }
    }

    // Toggle visibility
    onTogglePopup: spotifyPopup.visible = !spotifyPopup.visible

    // Timer to poll track info
    Timer {
        id: pollTimer
        interval: 2000
        running: true
        repeat: true
        onTriggered: SpotifyController.pollTrackInfo()
    }

    Component.onCompleted: {
        SpotifyController.setChangeCallback(function(track) {
            trackTitle.text = track.title
            trackArtist.text = track.artist
            playPauseBtn.text = SpotifyController.playing ? "⏸" : "▶"
            albumArt.source = track.albumArt
        })
    }
}