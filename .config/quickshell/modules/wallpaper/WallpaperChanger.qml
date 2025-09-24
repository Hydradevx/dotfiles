import Quickshell
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell.Hyprland
import Quickshell.Io
import "../public" as Theme

PanelWindow {
    id: wallpaperChanger
    visible: false
    width: 800
    height: 200
    color: "transparent"
    anchors.bottom: parent.bottom
    
    property string wallpapersDir: "/home/hydra/Pictures/wallpapers"
    property string symlinkPath: "~/.config/hypr/current_wallpaper"
    property var currentWallpaper: ""
    property var wallpapers: []
    property int currentIndex: 0

    Process {
        id: shellProcess
        running: false
    }

    Process {
        id: scanProcess
        running: false
        command: ["find", wallpapersDir, "-type", "f", "(", "-name", "*.jpg", "-o", "-name", "*.png", "-o", "-name", "*.jpeg", "-o", "-name", "*.gif", ")"]
        
        stdout: StdioCollector {
            onStreamFinished: {
                var output = text.trim()
                if (output.length > 0) {
                    var files = output.split('\n').filter(line => line.length > 0)
                    files.sort(function(a, b) {
                        var statA = Quickshell.stat(a)
                        var statB = Quickshell.stat(b)
                        return statB.mtime - statA.mtime
                    })
                    wallpapers = files
                    loadCurrentWallpaper()
                    if (wallpapers.length > 0) {
                        currentIndex = wallpapers.indexOf(currentWallpaper)
                        if (currentIndex === -1) currentIndex = 0
                    }
                }
            }
        }
        
        onExited: {
            if (exitCode !== 0) {
                loadWallpapersFallback()
            }
        }
    }

    Rectangle {
        anchors.fill: parent
        color: "#000000"
        opacity: wallpaperChanger.visible ? 0.4 : 0
        
        MouseArea {
            anchors.fill: parent
            onClicked: wallpaperChanger.visible = false
        }
    }

    Rectangle {
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        width: Math.min(parent.width * 0.9, 800)
        height: 150
        radius: 16
        color: Theme.Colors.surface
        border.color: Theme.Colors.outline
        border.width: 1
        opacity: 0.98

        RowLayout {
            anchors.fill: parent
            anchors.margins: 15
            spacing: 10

            Rectangle {
                Layout.preferredWidth: 100
                Layout.preferredHeight: 80
                radius: 8
                color: Theme.Colors.surface_variant
                border.color: Theme.Colors.outline
                border.width: 1

                Image {
                    id: prevImage
                    anchors.fill: parent
                    anchors.margins: 2
                    fillMode: Image.PreserveAspectCrop
                    source: wallpapers.length > 0 && currentIndex > 0 ? "file://" + wallpapers[currentIndex - 1] : ""
                    opacity: source ? 1 : 0.3
                }

                Text {
                    anchors.centerIn: parent
                    text: "←"
                    font.pixelSize: 20
                    color: Theme.Colors.on_surface
                    visible: !prevImage.source
                }
            }

            Rectangle {
                Layout.preferredWidth: 150
                Layout.preferredHeight: 100
                radius: 12
                color: Theme.Colors.primary_container
                border.color: Theme.Colors.primary
                border.width: 3

                Image {
                    id: currentImage
                    anchors.fill: parent
                    anchors.margins: 2
                    fillMode: Image.PreserveAspectCrop
                    source: wallpapers.length > 0 ? "file://" + wallpapers[currentIndex] : ""
                    opacity: source ? 1 : 0.3
                }

                Text {
                    anchors.centerIn: parent
                    text: "No wallpaper"
                    font.family: "Maple Mono NF"
                    font.pixelSize: 10
                    color: Theme.Colors.on_surface_variant
                    visible: !currentImage.source
                }
            }

            Rectangle {
                Layout.preferredWidth: 100
                Layout.preferredHeight: 80
                radius: 8
                color: Theme.Colors.surface_variant
                border.color: Theme.Colors.outline
                border.width: 1

                Image {
                    id: nextImage
                    anchors.fill: parent
                    anchors.margins: 2
                    fillMode: Image.PreserveAspectCrop
                    source: wallpapers.length > 0 && currentIndex < wallpapers.length - 1 ? "file://" + wallpapers[currentIndex + 1] : ""
                    opacity: source ? 1 : 0.3
                }

                Text {
                    anchors.centerIn: parent
                    text: "→"
                    font.pixelSize: 20
                    color: Theme.Colors.on_surface
                    visible: !nextImage.source
                }
            }

            ColumnLayout {
                Layout.fillWidth: true
                Layout.fillHeight: true
                spacing: 5

                Text {
                    text: wallpapers.length > 0 ? wallpapers[currentIndex].split("/").pop() : "No wallpaper selected"
                    font.family: "Maple Mono NF"
                    font.pixelSize: 14
                    font.weight: Font.Bold
                    color: Theme.Colors.on_surface
                    elide: Text.ElideMiddle
                    Layout.fillWidth: true
                }

                Text {
                    text: wallpapers.length > 0 ? (currentIndex + 1) + " / " + wallpapers.length : "0 wallpapers"
                    font.family: "Maple Mono NF"
                    font.pixelSize: 11
                    color: Theme.Colors.on_surface_variant
                    Layout.fillWidth: true
                }

                Rectangle {
                    Layout.preferredWidth: 120
                    Layout.preferredHeight: 30
                    radius: 8
                    color: applyMouseArea.containsMouse ? Theme.Colors.primary : Theme.Colors.surface_variant
                    border.color: Theme.Colors.outline
                    border.width: 1

                    Text {
                        anchors.centerIn: parent
                        text: "Apply (Enter)"
                        font.family: "Maple Mono NF"
                        font.pixelSize: 11
                        color: applyMouseArea.containsMouse ? Theme.Colors.on_primary : Theme.Colors.on_surface_variant
                    }

                    MouseArea {
                        id: applyMouseArea
                        anchors.fill: parent
                        hoverEnabled: true
                        onClicked: applyCurrentWallpaper()
                    }
                }
            }
        }

        Rectangle {
            anchors {
                top: parent.top
                right: parent.right
                margins: 8
            }
            width: 24
            height: 24
            radius: 6
            color: closeMouseArea.containsMouse ? Theme.Colors.error_container : "transparent"
            
            Text {
                text: "×"
                font.pixelSize: 16
                font.weight: Font.Bold
                color: closeMouseArea.containsMouse ? Theme.Colors.on_error_container : Theme.Colors.on_surface_variant
                anchors.centerIn: parent
            }

            MouseArea {
                id: closeMouseArea
                anchors.fill: parent
                hoverEnabled: true
                onClicked: wallpaperChanger.visible = false
            }
        }
    }

    function loadWallpapers() {
        wallpapers = []
        scanProcess.start()
    }

    function applyCurrentWallpaper() {
        if (wallpapers.length === 0) return
        
        var wallpaperPath = wallpapers[currentIndex]
        console.log("Applying wallpaper:", wallpaperPath)
        
        executeCommandSequence([
            ["bash", "-c", "pgrep -x swww-daemon > /dev/null || swww-daemon"],
            ["swww", "img", wallpaperPath, "--transition-type", "any"],
            ["matugen", "image", wallpaperPath],
            ["bash", "-c", `mkdir -p ~/.config/hypr && ln -sf "${wallpaperPath}" "${symlinkPath.replace('~', '$HOME')}"`],
            ["bash", "-c", "command -v swaync >/dev/null 2>&1 && swaync-client -rs"],
            ["notify-send", "Wallpaper changed to " + wallpaperPath.split("/").pop()]
        ], 0)
        
        currentWallpaper = wallpaperPath
    }

    function executeCommandSequence(commands, index) {
        if (index >= commands.length) return
        
        var cmd = commands[index]
        shellProcess.command = cmd
        shellProcess.start()
        
        Quickshell.singleShot(300, function() {
            executeCommandSequence(commands, index + 1)
        })
    }

    function loadCurrentWallpaper() {
        var normalizedSymlink = symlinkPath.replace("~", Quickshell.env("HOME"))
        var stat = Quickshell.stat(normalizedSymlink)
        if (stat.exists) {
            var proc = Quickshell.Io.ProcessFactory.create()
            proc.command = ["readlink", "-f", normalizedSymlink]
            proc.onExited = function() {
                if (proc.exitCode === 0) {
                    currentWallpaper = proc.readAllStdout().trim()
                    if (wallpapers.length > 0) {
                        currentIndex = wallpapers.indexOf(currentWallpaper)
                        if (currentIndex === -1) currentIndex = 0
                    }
                }
            }
            proc.start()
        }
    }

    function loadWallpapersFallback() {
        var dir = Quickshell.dir(wallpapersDir)
        var files = dir.entryList(["*.jpg", "*.png", "*.jpeg", "*.gif"], Quickshell.Dir.Files)
        files = files.map(file => dir.absoluteFilePath(file))
        wallpapers = files
        if (wallpapers.length > 0) {
            loadCurrentWallpaper()
            currentIndex = wallpapers.indexOf(currentWallpaper)
            if (currentIndex === -1) currentIndex = 0
        }
    }

    Component.onCompleted: {
        loadWallpapers()
    }

    GlobalShortcut {
        name: "wallpaperChangerToggle"
        onPressed: wallpaperChanger.visible = !wallpaperChanger.visible
    }

    Keys.onPressed: {
        if (!visible) return
        
        if (event.key === Qt.Key_Left) {
            if (currentIndex > 0) currentIndex--
            event.accepted = true
        } else if (event.key === Qt.Key_Right) {
            if (currentIndex < wallpapers.length - 1) currentIndex++
            event.accepted = true
        } else if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
            applyCurrentWallpaper()
            event.accepted = true
        } else if (event.key === Qt.Key_Escape) {
            visible = false
            event.accepted = true
        }
    }

    onVisibleChanged: {
        if (visible) {
            loadWallpapers()
            forceActiveFocus()
        }
    }

    onCurrentIndexChanged: {
        if (wallpapers.length > 0) {
            currentWallpaper = wallpapers[currentIndex]
        }
    }
}