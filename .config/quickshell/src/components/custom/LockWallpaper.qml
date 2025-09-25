import QtQuick
import QtQuick.Effects
import "../../globals/state" as GlobalState

Item {
    id: wallpaper
    
    property string wallpaperPath: "file:///home/hydra/.config/hypr/current_wallpaper"
    property real blurAmount: 1
    
    anchors.fill: parent

    Image {
        id: wallpaperImage
        anchors.fill: parent
        source: wallpaper.wallpaperPath
        fillMode: Image.PreserveAspectCrop

        layer.enabled: true
        layer.effect: MultiEffect {
            anchors.fill: parent
            source: wallpaperImage
            blurEnabled: true
            blur: wallpaper.blurAmount
        }
    }
}