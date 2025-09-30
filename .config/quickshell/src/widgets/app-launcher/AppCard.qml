import QtQuick
import Quickshell
import "../../components/layout" as Layout
import "../../globals/state" as GlobalState

Layout.Card {
    id: appCard
    property var application
    property string appName: application ? application.name : "Unknown"
    property string appIcon: application ? application.icon : ""
    
    width: 165
    height: 145
    color: hovered ? GlobalState.Colors.primary_container : GlobalState.Colors.surface_variant
    
    onClicked: {
        console.log("Launching app:", appName)
        if (application && application.execute) {
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
            color: hovered ? GlobalState.Colors.primary : GlobalState.Colors.surface
            anchors.horizontalCenter: parent.horizontalCenter

            Image {
                source: application && appIcon ? Quickshell.iconPath(appIcon) : ""
                width: 40
                height: 40
                anchors.centerIn: parent
                fillMode: Image.PreserveAspectFit
                smooth: true
                opacity: source.toString() !== "" ? 0.9 : 0.3
            }
        }

        Text {
            text: appName
            font.family: GlobalState.ThemeManager.fontFamily
            font.pixelSize: GlobalState.ThemeManager.fontSizeSmall
            font.weight: Font.Medium
            color: hovered ? GlobalState.Colors.on_primary_container : GlobalState.Colors.on_surface_variant
            wrapMode: Text.Wrap
            horizontalAlignment: Text.AlignHCenter
            maximumLineCount: 2
            elide: Text.ElideRight
            width: parent.width
        }
    }
}