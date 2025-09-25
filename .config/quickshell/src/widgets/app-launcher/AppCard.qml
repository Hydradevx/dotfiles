import QtQuick
import "../../components/layout" as Layout
import "../../globals/state" as GlobalState

Layout.Card {
    id: appCard
    property var application
    property string appName: application ? application.name : ""
    property string appIcon: application ? application.icon : ""
    
    width: 165
    height: 145
    color: hovered ? GlobalState.ThemeManager.primary_container : GlobalState.ThemeManager.surface_variant
    
    onClicked: {
        if (application) {
            application.execute()
            appCard.appLaunched()
        }
    }
    
    signal appLaunched()

    Column {
        anchors.centerIn: parent
        spacing: GlobalState.ThemeManager.spacingMedium
        width: parent.width - 24

        Rectangle {
            width: 64
            height: 64
            radius: GlobalState.ThemeManager.radiusMedium
            color: hovered ? GlobalState.ThemeManager.primary : GlobalState.ThemeManager.surface
            anchors.horizontalCenter: parent.horizontalCenter

            Image {
                source: application ? Quickshell.iconPath(appIcon) : ""
                width: 40
                height: 40
                anchors.centerIn: parent
                fillMode: Image.PreserveAspectFit
                smooth: true
                opacity: 0.9
            }
        }

        Text {
            text: appName
            font.family: GlobalState.ThemeManager.fontFamily
            font.pixelSize: GlobalState.ThemeManager.fontSizeSmall
            font.weight: Font.Medium
            color: hovered ? GlobalState.ThemeManager.on_primary_container : GlobalState.ThemeManager.on_surface_variant
            wrapMode: Text.Wrap
            horizontalAlignment: Text.AlignHCenter
            maximumLineCount: 2
            elide: Text.ElideRight
            width: parent.width
        }
    }
}