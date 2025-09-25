import QtQuick
import QtQuick.Controls 
import QtQuick.Layouts
import "../../globals/state" as GlobalState

Rectangle {
    id: searchBar
    implicitHeight: 50
    
    property alias placeholderText: textField.placeholderText
    property alias text: textField.text
    
    radius: GlobalState.ThemeManager.radiusMedium
    color: GlobalState.ThemeManager.surface_variant
    border.color: GlobalState.ThemeManager.outline
    border.width: 1

    RowLayout {
        anchors.fill: parent
        anchors.margins: GlobalState.ThemeManager.spacingMedium
        spacing: GlobalState.ThemeManager.spacingMedium

        Text {
            text: "🔍"
            font.pixelSize: GlobalState.ThemeManager.fontSizeLarge
            Layout.alignment: Qt.AlignVCenter
        }

        TextField {
            id: textField
            Layout.fillWidth: true
            placeholderText: searchBar.placeholderText
            font.family: GlobalState.ThemeManager.fontFamily
            font.pixelSize: GlobalState.ThemeManager.fontSizeMedium
            background: Rectangle { color: "transparent" }
            onTextChanged: searchBar.textChanged(text)
        }
    }
}