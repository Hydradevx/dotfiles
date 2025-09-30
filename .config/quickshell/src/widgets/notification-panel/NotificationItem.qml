import QtQuick
import QtQuick.Layouts
import Quickshell.Services.Notifications
import "../../globals/state" as GlobalState

Rectangle {
    id: notificationItem
    width: parent ? parent.width : 300
    height: contentColumn.implicitHeight + 16
    radius: GlobalState.Colors.radiusMedium
    color: GlobalState.Colors.surface
    border.color: GlobalState.Colors.outline
    border.width: 1
    
    required property Notification modelData
    
    signal closed()
    signal clicked()

    ColumnLayout {
        id: contentColumn
        anchors.fill: parent
        anchors.margins: GlobalState.ThemeManager.spacingMedium
        spacing: GlobalState.ThemeManager.spacingSmall

        RowLayout {
            Layout.fillWidth: true
            spacing: GlobalState.ThemeManager.spacingSmall

            Text {
                text: notificationItem.modelData.appName || "Unknown App"
                font.family: GlobalState.ThemeManager.fontFamily
                font.pixelSize: GlobalState.ThemeManager.fontSizeSmall
                font.weight: Font.Medium
                color: GlobalState.Colors.primary
                Layout.fillWidth: true
                elide: Text.ElideRight
            }

            Text {
                text: formatTime(notificationItem.modelData.timestamp)
                font.family: GlobalState.ThemeManager.fontFamily
                font.pixelSize: GlobalState.ThemeManager.fontSizeSmall
                color: GlobalState.Colors.on_surface_variant
                opacity: 0.7
            }
        }

        Text {
            visible: notificationItem.modelData.summary
            text: notificationItem.modelData.summary || ""
            font.family: GlobalState.ThemeManager.fontFamily
            font.pixelSize: GlobalState.ThemeManager.fontSizeMedium
            font.weight: Font.Medium
            color: GlobalState.Colors.on_surface
            wrapMode: Text.WordWrap
            Layout.fillWidth: true
        }

        Text {
            visible: notificationItem.modelData.body
            text: notificationItem.modelData.body || ""
            font.family: GlobalState.ThemeManager.fontFamily
            font.pixelSize: GlobalState.ThemeManager.fontSizeSmall
            color: GlobalState.Colors.on_surface_variant
            wrapMode: Text.WordWrap
            Layout.fillWidth: true
        }

        RowLayout {
            visible: notificationItem.modelData.actions && notificationItem.modelData.actions.length > 0
            Layout.fillWidth: true
            spacing: GlobalState.ThemeManager.spacingSmall

            Repeater {
                model: notificationItem.modelData.actions || []

                Rectangle {
                    radius: GlobalState.ThemeManager.radiusSmall
                    color: GlobalState.Colors.primary_container
                    height: 24
                    Layout.fillWidth: true

                    Text {
                        anchors.centerIn: parent
                        text: modelData.name || ""
                        font.family: GlobalState.ThemeManager.fontFamily
                        font.pixelSize: GlobalState.ThemeManager.fontSizeSmall
                        color: GlobalState.Colors.on_primary_container
                    }

                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            notificationItem.modelData.invokeAction(modelData.id)
                            notificationItem.clicked()
                        }
                    }
                }
            }
        }
    }

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: notificationItem.clicked()
        
        onPressAndHold: {
            notificationItem.modelData.close()
            notificationItem.closed()
        }
    }

    function formatTime(timestamp) {
        if (!timestamp) return ""
        const date = new Date(timestamp)
        const now = new Date()
        const diffMs = now - date
        const diffMins = Math.floor(diffMs / 60000)
        
        if (diffMins < 1) return "Now"
        if (diffMins < 60) return `${diffMins}m ago`
        if (diffMins < 1440) return `${Math.floor(diffMins / 60)}h ago`
        return `${Math.floor(diffMins / 1440)}d ago`
    }
}