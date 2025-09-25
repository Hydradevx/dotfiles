import QtQuick.Controls
import QtQuick
import "../../globals/state" as GlobalState

ScrollBar {
    policy: ScrollBar.AsNeeded
    width: 8
    
    background: Rectangle { 
        color: "transparent" 
    }
    
    contentItem: Rectangle {
        radius: 4
        color: GlobalState.ThemeManager.outline
        opacity: 0.6
    }
}