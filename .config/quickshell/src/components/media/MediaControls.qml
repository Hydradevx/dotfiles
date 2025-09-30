import QtQuick
import QtQuick.Layouts
import "../../globals/state" as GlobalState
import "../buttons"

RowLayout {
    id: mediaControls
    spacing: 20
    
    property bool isPlaying: false
    property bool canGoNext: true
    property bool canGoPrevious: true
    
    signal playPauseClicked()
    signal nextClicked()
    signal previousClicked()
    
    ButtonIcon {
        icon: "⏮"
        tooltip: "Previous"
        enabled: mediaControls.canGoPrevious
        onClicked: mediaControls.previousClicked()
    }
    
    ButtonIcon {
        id: playPauseBtn
        icon: mediaControls.isPlaying ? "⏸" : "▶"
        tooltip: mediaControls.isPlaying ? "Pause" : "Play"
        isPrimary: true
        onClicked: mediaControls.playPauseClicked()
    }
    
    ButtonIcon {
        icon: "⏭"
        tooltip: "Next"
        enabled: mediaControls.canGoNext
        onClicked: mediaControls.nextClicked()
    }
}