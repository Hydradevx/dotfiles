import QtQuick
import "../../components/panels" as Panels

Panels.PanelHeader {
    id: notificationHeader
    title: "Notifications"
    showActionButton: true
    actionText: "Clear All"
    
    onActionClicked: {
        if (notificationManager) {
            notificationManager.clearAll()
        }
    }
}