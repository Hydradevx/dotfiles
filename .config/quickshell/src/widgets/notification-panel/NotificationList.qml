import QtQuick
import QtQuick.Controls
import "../../globals/state" as GlobalState

Flickable {
    id: notificationList
    clip: true
    contentHeight: contentColumn.implicitHeight
    
    property alias model: repeater.model
    signal notificationClicked(var notification)
    signal notificationClosed(var notification)

    Column {
        id: contentColumn
        width: parent.width
        spacing: GlobalState.ThemeManager.spacingMedium

        Repeater {
            id: repeater
            model: notificationList.model

            NotificationItem {
                modelData: modelData
                onClicked: notificationList.notificationClicked(modelData)
                onClosed: notificationList.notificationClosed(modelData)
                
                // Add entrance animation
                opacity: 0
                scale: 0.9
                
                Component.onCompleted: {
                    entranceAnimation.start()
                }
                
                SequentialAnimation {
                    id: entranceAnimation
                    ParallelAnimation {
                        NumberAnimation { 
                            target: parent; property: "opacity"; to: 1; duration: 300 
                        }
                        NumberAnimation { 
                            target: parent; property: "scale"; to: 1; duration: 300 
                        }
                    }
                }
            }
        }
        
        // Empty state
        Rectangle {
            visible: repeater.count === 0
            width: parent.width
            height: 100
            color: "transparent"
            
            Column {
                anchors.centerIn: parent
                spacing: GlobalState.ThemeManager.spacingSmall
                
                Text {
                    text: "📋"
                    font.pixelSize: 32
                    anchors.horizontalCenter: parent.horizontalCenter
                }
                
                Text {
                    text: "No notifications"
                    font.family: GlobalState.ThemeManager.fontFamily
                    font.pixelSize: GlobalState.ThemeManager.fontSizeMedium
                    color: GlobalState.Colors.on_surface_variant
                    anchors.horizontalCenter: parent.horizontalCenter
                }
            }
        }
    }

    ScrollBar.vertical: ScrollBar {
        policy: ScrollBar.AsNeeded
        width: 6
        background: Rectangle { color: "transparent" }
        contentItem: Rectangle {
            radius: 3
            color: GlobalState.Colors.outline
            opacity: 0.6
        }
    }
}