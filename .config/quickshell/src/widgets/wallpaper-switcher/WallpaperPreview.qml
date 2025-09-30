import QtQuick
import QtQuick.Layouts
import "../../components/media" as Media
import "../../globals/state" as GlobalState

Rectangle {
    id: preview
    implicitHeight: 150
    radius: GlobalState.ThemeManager.radiusLarge
    color: GlobalState.ThemeManager.surface
    border.color: GlobalState.ThemeManager.primary
    border.width: 3
    
    property var wallpaperManager: null
    property var commandExecutor: null
    
    signal applyRequested()
    signal closeRequested()

    RowLayout {
        anchors.fill: parent
        anchors.margins: GlobalState.ThemeManager.spacingMedium
        spacing: GlobalState.ThemeManager.spacingMedium

        // Previous wallpaper
        Media.ImageNavigator {
            direction: "left"
            imageSource: wallpaperManager && wallpaperManager.currentIndex > 0 ? 
                        wallpaperManager.wallpapers[wallpaperManager.currentIndex - 1] : ""
            enabled: wallpaperManager && wallpaperManager.currentIndex > 0
            onClicked: {
                if (wallpaperManager) wallpaperManager.previousWallpaper()
            }
        }

        // Current wallpaper preview
        Media.ImageCard {
            Layout.preferredWidth: 150
            Layout.preferredHeight: 100
            imageSource: wallpaperManager ? wallpaperManager.currentWallpaper : ""
            isSelected: true
            
            onDoubleClicked: preview.applyRequested()
        }

        // Next wallpaper
        Media.ImageNavigator {
            direction: "right"
            imageSource: wallpaperManager && wallpaperManager.currentIndex < wallpaperManager.wallpapers.length - 1 ? 
                        wallpaperManager.wallpapers[wallpaperManager.currentIndex + 1] : ""
            enabled: wallpaperManager && wallpaperManager.currentIndex < wallpaperManager.wallpapers.length - 1
            onClicked: {
                if (wallpaperManager) wallpaperManager.nextWallpaper()
            }
        }

        // Info and controls
        ColumnLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: GlobalState.ThemeManager.spacingSmall

            Text {
                text: wallpaperManager && wallpaperManager.wallpapers.length > 0 ? 
                      wallpaperManager.getWallpaperName(wallpaperManager.currentIndex) : "No wallpaper selected"
                font.family: GlobalState.ThemeManager.fontFamily
                font.pixelSize: GlobalState.ThemeManager.fontSizeMedium
                font.weight: Font.Bold
                color: GlobalState.ThemeManager.on_surface
                elide: Text.ElideMiddle
                Layout.fillWidth: true
            }

            Text {
                text: wallpaperManager ? 
                      (wallpaperManager.wallpapers.length > 0 ? 
                       (wallpaperManager.currentIndex + 1) + " / " + wallpaperManager.wallpapers.length : 
                       "0 wallpapers") : "Scanning..."
                font.family: GlobalState.ThemeManager.fontFamily
                font.pixelSize: GlobalState.ThemeManager.fontSizeSmall
                color: GlobalState.ThemeManager.on_surface_variant
                Layout.fillWidth: true
            }

            // Apply button
            Rectangle {
                Layout.preferredWidth: 120
                Layout.preferredHeight: 30
                radius: GlobalState.ThemeManager.radiusSmall
                color: applyMouseArea.containsMouse ? GlobalState.ThemeManager.primary : GlobalState.ThemeManager.surface_variant
                border.color: GlobalState.ThemeManager.outline
                border.width: 1

                Text {
                    anchors.centerIn: parent
                    text: commandExecutor && commandExecutor.executing ? "Applying..." : "Apply (Enter)"
                    font.family: GlobalState.ThemeManager.fontFamily
                    font.pixelSize: GlobalState.ThemeManager.fontSizeSmall
                    color: applyMouseArea.containsMouse ? GlobalState.ThemeManager.on_primary : GlobalState.ThemeManager.on_surface_variant
                }

                MouseArea {
                    id: applyMouseArea
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    enabled: !commandExecutor || !commandExecutor.executing
                    onClicked: preview.applyRequested()
                }
            }
        }
    }
}