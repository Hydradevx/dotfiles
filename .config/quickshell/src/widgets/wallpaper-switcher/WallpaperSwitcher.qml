import Quickshell
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell.Hyprland
import "../../components/basic" as Basic
import "../../globals/state" as GlobalState

PanelWindow {
    id: wallpaperSwitcher
    visible: false
    width: 600
    height: 500
    color: "transparent"

    // Managers
    WallpaperManager { id: wallpaperManager }
    WallpaperCommands { id: commandExecutor }

    Basic.ModalOverlay {
        anchors.fill: parent
        shown: wallpaperSwitcher.visible
        onClicked: wallpaperSwitcher.visible = false
    }

    WallpaperGrid {
        id: wallpaperGrid
        anchors.centerIn: parent
        width: Math.min(parent.width * 0.9, 600)
        height: Math.min(parent.height * 0.9, 500)
        wallpaperManager: wallpaperManager
        commandExecutor: commandExecutor
        
        onApplyRequested: {
            if (wallpaperManager.currentWallpaper) {
                commandExecutor.applyWallpaper(wallpaperManager.currentWallpaper)
            }
        }
    }

    Basic.CloseButton {
        anchors {
            top: wallpaperGrid.top
            right: wallpaperGrid.right
            margins: 8
        }
        onClicked: wallpaperSwitcher.visible = false
    }

    // Keyboard navigation
    Keys.onPressed: {
        if (!visible) return
        
        if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
            if (wallpaperManager.currentWallpaper) {
                commandExecutor.applyWallpaper(wallpaperManager.currentWallpaper)
            }
            event.accepted = true
        } else if (event.key === Qt.Key_Escape) {
            visible = false
            event.accepted = true
        }
    }

    onVisibleChanged: {
        if (visible) {
            console.log("Wallpaper switcher shown - scanning wallpapers")
            wallpaperManager.scanWallpapers()
            forceActiveFocus()
        }
    }

    Connections {
        target: wallpaperManager
        function onScanError(error) {
            console.error("Wallpaper scan error:", error)
        }
    }

    Connections {
        target: commandExecutor
        function onAllCommandsFinished() {
            console.log("Wallpaper applied successfully")
            wallpaperSwitcher.visible = false
        }
    }

    GlobalShortcut {
        name: "wallpaperChangerToggle"
        onPressed: wallpaperSwitcher.visible = !wallpaperSwitcher.visible
    }
}