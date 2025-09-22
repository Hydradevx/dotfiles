import QtQuick
import QtQuick.Layouts
import QtQuick.Controls.Fusion
import QtQuick.Effects
import Quickshell.Wayland
import "../public" as Theme

Rectangle {
    id: root
    required property LockContext context
    readonly property ColorGroup colors: Window.active ? palette.active : palette.inactive

    color: "transparent"

    // Wallpaper with blur
    Image {
        id: wallpaper
        anchors.fill: parent
        source: "file:///home/hydra/.config/hypr/current_wallpaper"
        fillMode: Image.PreserveAspectCrop
    }

    MultiEffect {
        anchors.fill: parent
        source: wallpaper
        blurEnabled: true
        blur: 0.5
        brightness: 0.9
    }

    // Clock + Date
    Column {
        anchors {
            horizontalCenter: parent.horizontalCenter
            top: parent.top
            topMargin: 120
        }
        spacing: 10

        Label {
            id: clock
            property var date: new Date()

            font.pixelSize: 100
            font.bold: true
            color: Theme.Colors.on_surface
            style: Text.Outline
            styleColor: Theme.Colors.outline
            horizontalAlignment: Text.AlignHCenter
            renderType: Text.NativeRendering

            Timer {
                running: true
                repeat: true
                interval: 1000
                onTriggered: clock.date = new Date();
            }

            text: {
                const hours = clock.date.getHours().toString().padStart(2, '0');
                const minutes = clock.date.getMinutes().toString().padStart(2, '0');
                return `${hours}:${minutes}`;
            }
        }

        Label {
            id: dateLabel
            text: Qt.formatDate(clock.date, "dddd, MMMM d yyyy")
            font.pixelSize: 28
            color: Theme.Colors.on_surface_variant
            horizontalAlignment: Text.AlignHCenter
            renderType: Text.NativeRendering
        }
    }

    // Unlock area
    ColumnLayout {
        anchors {
            horizontalCenter: parent.horizontalCenter
            top: parent.verticalCenter
        }
        spacing: 20

        RowLayout {
            spacing: 10

            TextField {
                id: passwordBox
                implicitWidth: 400
                padding: 12
                font.pixelSize: 20
                color: Theme.Colors.on_surface

                background: Rectangle {
                    color: Theme.Colors.surfaceVariant
                    radius: 12
                    border.color: passwordBox.focus ? Theme.Colors.primary : "transparent"
                    border.width: 2
                }

                focus: true
                enabled: !root.context.unlockInProgress
                echoMode: TextInput.Password
                inputMethodHints: Qt.ImhSensitiveData

                onTextChanged: root.context.currentText = this.text;
                onAccepted: root.context.tryUnlock();

                Connections {
                    target: root.context
                    function onCurrentTextChanged() {
                        passwordBox.text = root.context.currentText;
                    }
                }
            }

            Button {
								implicitWidth: 120
                text: "Unlock"
                padding: 12
                font.pixelSize: 18
								font.bold: true
								font.family: "Maple Mono NF"
                background: Rectangle {
                    color: Theme.Colors.primary_container
                    radius: 10
                }
                contentItem: Text {
                    text: parent.Button.text
                    font.pixelSize: 18
                    color: Theme.Colors.on_primary_container
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }

                focusPolicy: Qt.NoFocus
                enabled: !root.context.unlockInProgress && root.context.currentText !== ""
                onClicked: root.context.tryUnlock()
            }
        }

        Label {
            visible: root.context.showFailure
            text: "Incorrect password"
            color: Theme.Colors.error
            font.pixelSize: 16
        }
    }
}