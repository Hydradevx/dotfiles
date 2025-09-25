import QtQuick
import "../../globals/state" as GlobalState

Rectangle {
    id: navigator
    implicitWidth: 100
    implicitHeight: 80
    radius: GlobalState.ThemeManager.radiusSmall
    color: GlobalState.Colors.surface_variant
    border.color: GlobalState.Colors.outline
    border.width: 1
    
    property string imageSource: ""
    property string direction: "left" 
    property bool enabled: true
    
    signal clicked()

    Image {
        anchors.fill: parent
        anchors.margins: 2
        fillMode: Image.PreserveAspectCrop
        source: imageSource ? "file://" + imageSource : ""
        opacity: imageSource && enabled ? 1 : 0.3
        asynchronous: true
        cache: false
    }

    Text {
        anchors.centerIn: parent
        text: direction === "left" ? "←" : "→"
        font.pixelSize: 20
        color: GlobalState.Colors.on_surface
        visible: !imageSource || !enabled
    }

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: enabled ? Qt.PointingHandCursor : Qt.ArrowCursor
        enabled: navigator.enabled
        onClicked: navigator.clicked()
    }
}