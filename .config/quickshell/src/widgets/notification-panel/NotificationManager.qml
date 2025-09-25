import Quickshell
import Quickshell.Services.Notifications
pragma Singleton

Singleton {
    id: notificationManager
    readonly property alias list: server.trackedNotifications
    
    property int maxNotifications: 100
    property bool doNotDisturb: false

    NotificationServer {
        id: server
        onNotification: notif => {
            if (!doNotDisturb) {
                notif.tracked = true
                
                if (list.count > maxNotifications) {
                    list.get(0).close()
                }
            }
        }
    }
    
    function clearAll() {
        for (let i = list.count - 1; i >= 0; i--) {
            list.get(i).close()
        }
    }
    
    function toggleDoNotDisturb() {
        doNotDisturb = !doNotDisturb
    }
}