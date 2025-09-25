import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Hyprland
import "../../components/panels" as Panels
import "../../globals/state" as GlobalState

Panels.PanelWindow {
    id: notifPanel
    panelWidth: 380
    margin: 20
    
    ColumnLayout {
        anchors.fill: parent
        anchors.margins: GlobalState.ThemeManager.spacingLarge
        spacing: GlobalState.ThemeManager.spacingMedium

        NotificationHeader {
            id: header
            Layout.fillWidth: true
        }

        NotificationList {
            id: notificationList
            Layout.fillWidth: true
            Layout.fillHeight: true
            model: notificationManager.list
            
            onNotificationClicked: function(notification) {
                console.log("Notification clicked:", notification.appName)
            }
            
            onNotificationClosed: function(notification) {
                console.log("Notification closed:", notification.appName)
            }
        }
    }

    IpcHandler {
        target: "notification"
        function toggle() { notifPanel.toggle() }
        function show() { notifPanel.show() }
        function hide() { notifPanel.hide() }
    }

    GlobalShortcut { 
        name: "notificationToggle" 
        description: "Toggles Notification Panel" 
        onPressed: notifPanel.toggle()
    }

    MouseArea {
        anchors.fill: parent
        enabled: notifPanel.visible
        propagateComposedEvents: true
        onPressed: {
            notifPanel.hide()
            mouse.accepted = false
        }
    }
}