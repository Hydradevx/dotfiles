import QtQuick
import QtQuick.Layouts
import "../../globals/state" as GlobalState

Rectangle {
    id: header
    implicitHeight: 40
    color: "transparent"
    
    property string title: "Panel"
    property bool showActionButton: false
    property string actionText: "Action"
    
    signal actionClicked()
    
    RowLayout {
        anchors.fill: parent
        spacing: GlobalState.ThemeManager.spacingMedium

        Text {
            text: header.title
            font.family: GlobalState.ThemeManager.fontFamily
            font.pixelSize: GlobalState.ThemeManager.fontSizeLarge
            font.weight: Font.Medium
            color: GlobalState.Colors.on_surface
            Layout.fillWidth: true
        }

        Rectangle {
            visible: header.showActionButton
            radius: GlobalState.ThemeManager.radiusSmall
            color: GlobalState.Colors.primary
            width: 80
            height: 28

            Text {
                anchors.centerIn: parent
                text: header.actionText
                color: GlobalState.Colors.on_primary
                font.family: GlobalState.ThemeManager.fontFamily
                font.pixelSize: GlobalState.ThemeManager.fontSizeSmall
            }

            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: header.actionClicked()
            }
        }
    }
}