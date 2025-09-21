import Quickshell
import Quickshell.Services.Notifications
pragma Singleton

Singleton {
    id: notifs
    readonly property alias list: server.trackedNotifications

    NotificationServer {
        id: server
        onNotification: notif => notif.tracked = true
    }
}