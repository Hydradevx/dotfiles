import Quickshell
import Quickshell.Services.Notifications

Singleton {
    readonly property alias list: server.trackedNotifications

    NotificationServer {
        id: server
        onNotification: notif => notif.tracked = true
    }
}