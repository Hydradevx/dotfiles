import QtQuick
import "../../globals/state" as GlobalState

Rectangle {
    id: imageCard
    property string imageSource: ""
    property bool isSelected: false
    property real imageOpacity: 1.0
    
    radius: GlobalState.ThemeManager.radiusMedium
    color: isSelected ? GlobalState.Colors.primary_container : GlobalState.Colors.surface_variant
    border.color: isSelected ? GlobalState.Colors.primary : GlobalState.Colors.outline
    border.width: isSelected ? 2 : 1
    
    signal clicked()
    signal doubleClicked()

    Image {
        id: cardImage
        anchors.fill: parent
        anchors.margins: 2
        fillMode: Image.PreserveAspectCrop
        source: imageSource ? "file://" + imageSource : ""
        opacity: imageSource ? imageOpacity : 0.3
        asynchronous: true
        cache: false
        
        // Fallback when no image
        Rectangle {
            anchors.fill: parent
            color: GlobalState.Colors.surface
            visible: !cardImage.source || cardImage.status === Image.Error
        }
        
        Text {
            anchors.centerIn: parent
            text: "🖼️"
            font.pixelSize: 24
            visible: !cardImage.source || cardImage.status === Image.Error
            opacity: 0.5
        }
    }

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: imageCard.clicked()
        onDoubleClicked: imageCard.doubleClicked()
        
        onContainsMouseChanged: {
            imageCard.scale = containsMouse ? 1.02 : 1.0
        }
    }
    
    Behavior on scale { NumberAnimation { duration: 100 } }
    Behavior on color { ColorAnimation { duration: 150 } }
}