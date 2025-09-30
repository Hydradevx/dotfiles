import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "../../components/media" as Media
import "../../globals/state" as GlobalState

Rectangle {
    id: wallpaperGrid
    implicitHeight: 400
    radius: GlobalState.ThemeManager.radiusLarge
    color: GlobalState.Colors.surface
    border.color: GlobalState.Colors.outline
    border.width: 1
    
    property var wallpaperManager: null
    property var commandExecutor: null
    
    signal applyRequested()
    signal closeRequested()

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: GlobalState.ThemeManager.spacingMedium
        spacing: GlobalState.ThemeManager.spacingMedium

        // Header
        Text {
            text: "Select Wallpaper"
            font.family: GlobalState.ThemeManager.fontFamily
            font.pixelSize: GlobalState.ThemeManager.fontSizeLarge
            font.weight: Font.Bold
            color: GlobalState.Colors.on_surface
            Layout.alignment: Qt.AlignHCenter
        }

        // Wallpaper grid
        GridView {
            id: grid
            Layout.fillWidth: true
            Layout.fillHeight: true
            cellWidth: 120
            cellHeight: 80
            clip: true
            model: wallpaperManager ? wallpaperManager.wallpapers : []
            
            delegate: Media.ImageCard {
                width: grid.cellWidth - 10
                height: grid.cellHeight - 10
                imageSource: modelData
                isSelected: wallpaperManager ? wallpaperManager.currentIndex === index : false
                
                onClicked: {
                    if (wallpaperManager) {
                        wallpaperManager.setWallpaper(index)
                    }
                }
                
                onDoubleClicked: {
                    if (wallpaperManager) {
                        wallpaperManager.setWallpaper(index)
                        wallpaperGrid.applyRequested()
                    }
                }
            }

            ScrollBar.vertical: ScrollBar {
                policy: ScrollBar.AsNeeded
                width: 6
                background: Rectangle { color: "transparent" }
                contentItem: Rectangle {
                    radius: 3
                    color: GlobalState.Colors.outline
                    opacity: 0.6
                }
            }
        }

        // Selected wallpaper info and apply button
        RowLayout {
            Layout.fillWidth: true
            spacing: GlobalState.ThemeManager.spacingMedium

            ColumnLayout {
                Layout.fillWidth: true
                spacing: GlobalState.ThemeManager.spacingSmall

                Text {
                    text: wallpaperManager && wallpaperManager.wallpapers.length > 0 ? 
                          wallpaperManager.getWallpaperName(wallpaperManager.currentIndex) : "No wallpaper selected"
                    font.family: GlobalState.ThemeManager.fontFamily
                    font.pixelSize: GlobalState.ThemeManager.fontSizeMedium
                    color: GlobalState.Colors.on_surface
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
                    color: GlobalState.Colors.on_surface_variant
                    Layout.fillWidth: true
                }
            }

            // Apply button
            Rectangle {
                Layout.preferredWidth: 100
                Layout.preferredHeight: 35
                radius: GlobalState.ThemeManager.radiusSmall
                color: applyMouseArea.containsMouse ? GlobalState.Colors.primary : GlobalState.Colors.surface_variant
                border.color: GlobalState.Colors.outline
                border.width: 1

                Text {
                    anchors.centerIn: parent
                    text: commandExecutor && commandExecutor.executing ? "Applying..." : "Apply"
                    font.family: GlobalState.ThemeManager.fontFamily
                    font.pixelSize: GlobalState.ThemeManager.fontSizeSmall
                    color: applyMouseArea.containsMouse ? GlobalState.Colors.on_primary : GlobalState.Colors.on_surface_variant
                }

                MouseArea {
                    id: applyMouseArea
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    enabled: !commandExecutor || !commandExecutor.executing
                    onClicked: wallpaperGrid.applyRequested()
                }
            }
        }
    }
}