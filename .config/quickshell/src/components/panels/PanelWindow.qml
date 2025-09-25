import QtQuick
import Quickshell
import Quickshell.Wayland
import "../globals/state" as GlobalState

PanelWindow {
    id: panelWindow
    
    property int margin: 20
    property int panelWidth: 320
    property alias panelRadius: background.radius
    property alias panelOpacity: background.opacity
    
    visible: false
    color: "transparent"
    implicitWidth: panelWidth
    implicitHeight: screen.height - margin * 2
    anchors.right: true
    anchors.bottom: true

    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive
    exclusionMode: ExclusionMode.Ignore

    Rectangle {
        id: background
        anchors.fill: parent
        color: GlobalState.Colors.surface_variant
        radius: GlobalState.ThemeManager.radiusLarge
        opacity: 0.95
        
        Behavior on opacity { NumberAnimation { duration: 200 } }
    }
    
    function toggle() { visible = !visible }
    function show() { visible = true }
    function hide() { visible = false }
}