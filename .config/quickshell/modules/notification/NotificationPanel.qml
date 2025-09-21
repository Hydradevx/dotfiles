import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Services.Notifications
import Quickshell.Hyprland
import Quickshell.Wayland
import "../public" as Theme

PanelWindow {
    id: notifPanel
    visible: false
    color: "transparent"

    property int margin: 20
    property int widgetWidth: 320
    implicitWidth: widgetWidth
    implicitHeight: screen.height - margin * 2
    anchors.right: true
    anchors.bottom: true

    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive
    exclusionMode: ExclusionMode.Ignore

    Rectangle {
        id: bg
        anchors.fill: parent
        color: Theme.Colors.surface_variant
        radius: 16
        opacity: 0.95

        ColumnLayout {
            id: mainColumn
            anchors.fill: parent
            anchors.margins: 16
            spacing: 12

            // Header
            RowLayout {
                Layout.fillWidth: true
                spacing: 8

                Text {
                    text: "Notifications"
                    font.pixelSize: 18
                    color: Theme.Colors.on_surface
                    Layout.fillWidth: true
                }

                Rectangle {
                    radius: 8
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
                            for (let i = notifs.list.count - 1; i >= 0; i--) {
                                notifs.list.get(i).close()
                            }
                        }
                    }
                }
            }

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
                        model: notifs.list

                        Rectangle {
                            required property Notification modelData
                            width: parent.width
                            radius: 12
                            color: Theme.Colors.surface
                            border.color: Theme.Colors.outline
                            border.width: 1

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