import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import "../public" as Theme
import Quickshell.Io  // Use Quickshell's Process

PanelWindow {
    id: musicPopup
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

        Image { id: albumArt; width: 60; height: 60; fillMode: Image.PreserveAspectFit }
        ColumnLayout {
            spacing: 2
            Text { id: trackTitle; text: "No Track"; font.pixelSize: 16; font.bold: true; color: Theme.Colors.on_surface }
            Text { id: trackArtist; text: "Unknown"; font.pixelSize: 14; color: Theme.Colors.on_surface }
        }

        RowLayout {
            spacing: 10
            Button { text: "⏮"; onClicked: prevProc.running = true }
            Button { id: playPauseBtn; text: "▶"; onClicked: playPauseProc.running = true }
            Button { text: "⏭"; onClicked: nextProc.running = true }
        }
    }

    // Status process
    Process {
        id: statusProc
        command: ["playerctl", "metadata", "--format", "{{json}}"]
        running: false
        stdout: StdioCollector {
            onStreamFinished: {
                try {
                    var json = JSON.parse(this.text)
                    trackTitle.text = json.title || "No Track"
                    trackArtist.text = json.artist || "Unknown"
                    albumArt.source = json.artUrl || ""
                    playPauseBtn.text = json.status === "Playing" ? "⏸" : "▶"
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