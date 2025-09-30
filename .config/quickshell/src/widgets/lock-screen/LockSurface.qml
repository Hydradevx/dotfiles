import QtQuick
import QtQuick.Layouts
import QtQuick.Controls.Fusion
import QtQuick.Effects
import Quickshell.Wayland
import "../../components/custom"
import "../../globals/state" as GlobalState

Rectangle {
    id: root
    required property LockContext context
    readonly property ColorGroup colors: Window.active ? palette.active : palette.inactive

    color: "transparent"

    LockWallpaper {
        id: wallpaper
        anchors.fill: parent
        blurAmount: 0.5
    }

    LockTime {
        id: time
        anchors.fill: parent
    }
    
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
                color: GlobalState.Colors.on_surface
                placeholderText: "Enter your password"

                background: Rectangle {
                    color: GlobalState.Colors.surfaceVariant
                    radius: 12
                    border.color: passwordBox.focus ? GlobalState.Colors.primary : "transparent"
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
        }

        Label {
            visible: root.context.showFailure
            text: "Incorrect password"
            color: GlobalState.Colors.error
            font.pixelSize: 16
        }
    }
}