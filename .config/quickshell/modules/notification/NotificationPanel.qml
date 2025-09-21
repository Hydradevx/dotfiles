import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Services.Notifications
import Quickshell.Hyprland
import "../public" as Theme
import "Notifs.qml" as Notifs

PanelWindow {
    id: notifPanel
    anchors.top: true
    anchors.left: true
    anchors.right: true
    anchors.bottom: true
    visible: false
    color: "transparent"

    Rectangle {
        id: bg
        anchors.fill: parent
        color: Theme.Colors.surface_variant
        opacity: 0.9

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 16
            spacing: 12

            // Header row
            RowLayout {
                Layout.fillWidth: true
                spacing: 8

                Text {
                    text: "Notifications"
                    font.pixelSize: 20
                    color: Theme.Colors.on_surface
                    Layout.fillWidth: true
                }

                Rectangle {
                    radius: 6
                    color: Theme.Colors.primary
                    width: 80
                    height: 28

                    Text {
                        anchors.centerIn: parent
                        text: "Clear"
                        color: Theme.Colors.on_primary
                        font.pixelSize: 14
                    }

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            for (let i = Notifs.list.length - 1; i >= 0; i--) {
                                Notifs.list[i].close()
                            }
                        }
                    }
                }
            }

            // Notification list
            Flickable {
                Layout.fillWidth: true
                Layout.fillHeight: true
                clip: true
                contentHeight: column.implicitHeight

                Column {
                    id: column
                    width: parent.width
                    spacing: 10

                    Repeater {
                        model: Notifs.list

                        Rectangle {
                            required property Notification modelData
                            width: parent.width
                            radius: 8
                            color: Theme.Colors.surface
                            border.color: Theme.Colors.outline

                            Column {
                                anchors.fill: parent
                                anchors.margins: 8
                                spacing: 4

                                Text {
                                    text: modelData.appName
                                    font.pixelSize: 14
                                    color: Theme.Colors.primary
                                }
                                Text {
                                    text: modelData.summary
                                    font.pixelSize: 16
                                    color: Theme.Colors.on_surface
                                    wrapMode: Text.WordWrap
                                }
                                Text {
                                    text: modelData.body
                                    font.pixelSize: 14
                                    color: Theme.Colors.on_surface_variant
                                    wrapMode: Text.WordWrap
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    function toggle() { notifPanel.visible = !notifPanel.visible }

    IpcHandler {
        target: "notification"
        function toggle(): void { notifPanel.visible = !notifPanel.visible }
    }

    GlobalShortcut { 
      name: "notificationToggle" 
      description: "Toggles Notification Panel" 
      onPressed: notifPanel.visible = !notifPanel.visible 
    }
}