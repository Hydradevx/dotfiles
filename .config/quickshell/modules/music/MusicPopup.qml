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
    implicitHeight: 180  
    color: "transparent"

    anchor.window: bar
    anchor.rect.x:  bar.width
    anchor.rect.y: bar.height 

    // Animation properties
    property real popupScale: 0.0
    property real popupOpacity: 0.0
    property real progressValue: 0
    property string durationText: "0:00 / 0:00"

    onVisibleChanged: {
        if (visible) {
            showAnimation.start()
        } else {
            hideAnimation.start()
        }
    }

    ParallelAnimation {
        id: showAnimation
        NumberAnimation {
            target: musicPopup
            property: "popupScale"
            from: 0.0
            to: 1.0
            duration: 300
            easing.type: Easing.OutBack
            easing.overshoot: 1.5
        }
        NumberAnimation {
            target: musicPopup
            property: "popupOpacity"
            from: 0.0
            to: 1.0
            duration: 200
        }
    }

    ParallelAnimation {
        id: hideAnimation
        NumberAnimation {
            target: musicPopup
            property: "popupScale"
            from: 1.0
            to: 0.0
            duration: 200
            easing.type: Easing.InBack
        }
        NumberAnimation {
            target: musicPopup
            property: "popupOpacity"
            from: 1.0
            to: 0.0
            duration: 150
        }
    }

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        onEntered: musicPopup.visible = true
        onExited: {
            if (!musicIcon.isHovered) {
                musicPopup.visible = false
            }
        }
    }

    Rectangle {
        id: bg
        anchors.fill: parent
        color: Theme.Colors.surface
        radius: 12
        
        Rectangle {
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            height: parent.radius
            color: parent.color
        }

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 16
            anchors.topMargin: 12 
            spacing: 12

            RowLayout {
                spacing: 15
                Layout.fillWidth: true

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
                        
                        Behavior on rotation {
                            NumberAnimation { duration: 500; easing.type: Easing.InOutQuad }
                        }
                    }
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
                        color: Theme.Colors.on_surface
                        elide: Text.ElideRight
                        Layout.fillWidth: true
                    }

                    Text {
                        id: trackArtist
                        text: "Unknown"
                        font.pixelSize: 14
                        color: Theme.Colors.on_surface_variant
                        elide: Text.ElideRight
                        Layout.fillWidth: true
                    }

                    Text {
                        id: progressText
                        text: durationText
                        font.pixelSize: 12
                        color: Theme.Colors.on_surface_variant
                        Layout.fillWidth: true
                    }
                }
            }  
            
            Rectangle {
                id: progressBarBg
                Layout.fillWidth: true
                height: 4
                radius: 2
                color: Theme.Colors.outline

                Rectangle {
                    id: progressBarFill
                    width: parent.width * progressValue
                    height: parent.height
                    radius: 2
                    color: Theme.Colors.primary
                    
                    Behavior on width {
                        NumberAnimation { duration: 200; easing.type: Easing.OutCubic }
                    }
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        var seekPos = mouseX / parent.width
                        seekProc.running = true
                    }
                }
            }

            RowLayout {
                spacing: 20
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignHCenter

                Rectangle {
                    width: 40; height: 40; radius: 8
                    color: mouseAreaPrev.containsMouse ? Theme.Colors.primary_container : Theme.Colors.primary
                    border.color: Theme.Colors.outline
                    border.width: 1

                    Text {
                        anchors.centerIn: parent
                        text: "⏮"
                        font.pixelSize: 18
                        color: Theme.Colors.surface
                    }

                    MouseArea {
                        id: mouseAreaPrev
                        anchors.fill: parent
                        hoverEnabled: true
                        onClicked: prevProc.running = true
                    }
                }

                Rectangle {
                    id: playPauseBtnRect
                    width: 40; height: 40; radius: 8
                    color: mouseAreaPlayPause.containsMouse ? Theme.Colors.primary_container : Theme.Colors.primary
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
                        id: mouseAreaPlayPause
                        anchors.fill: parent
                        hoverEnabled: true
                        onClicked: {
                            playPauseProc.running = true
                            statusProc.running = true
                        }
                    }
                }

                Rectangle {
                    width: 40; height: 40; radius: 8
                    color: mouseAreaNext.containsMouse ? Theme.Colors.primary_container : Theme.Colors.primary
                    border.color: Theme.Colors.outline
                    border.width: 1

                    Text {
                        anchors.centerIn: parent
                        text: "⏭"
                        font.pixelSize: 18
                        color: Theme.Colors.surface
                    }

                    MouseArea {
                        id: mouseAreaNext
                        anchors.fill: parent
                        hoverEnabled: true
                        onClicked: nextProc.running = true
                    }
                }
            }
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
                    albumArt.source = data.albumArt || ""
                    playPauseBtn.text = data.playing ? "⏸" : "▶"

                    var progress = data.position / Math.max(data.length, 1)
                    progressValue = Math.min(Math.max(progress, 0), 1)

                    var currentTime = formatTime(data.position || 0)
                    var totalTime = formatTime(data.length || 0)
                    durationText = currentTime + " / " + totalTime
                    
                    if (data.playing) {
                        albumArt.rotation = 5
                    } else {
                        albumArt.rotation = 0
                    }
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