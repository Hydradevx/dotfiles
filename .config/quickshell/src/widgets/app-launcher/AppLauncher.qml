import Quickshell
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell.Hyprland
import "../../components/basic" as Basic
import "../globals/shortcuts" as Shortcuts
import "../globals/state" as GlobalState

PanelWindow {
    id: appLauncher
    visible: false
    implicitWidth: 1000
    implicitHeight: 700
    color: "transparent"

    Basic.ModalOverlay {
        anchors.fill: parent
        shown: appLauncher.visible
        onClicked: appLauncher.visible = false
    }

    Rectangle {
        anchors.centerIn: parent
        width: Math.min(parent.width * 0.9, 1000)
        height: Math.min(parent.height * 0.85, 700)
        radius: 24
        color: GlobalState.ThemeManager.surface
        border.color: GlobalState.ThemeManager.outline
        border.width: 1
        opacity: 0.98

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 30
            spacing: 20

            Basic.SearchBar {
                id: searchField
                Layout.fillWidth: true
                placeholderText: "Search applications..."
                onTextChanged: appGrid.searchTerm = text
            }

            AppGrid {
                id: appGrid
                Layout.fillWidth: true
                Layout.fillHeight: true
                searchTerm: searchField.text
                onAppLaunched: {
                    appLauncher.visible = false
                    searchField.text = ""
                }
            }

            Text {
                text: appGrid.appCount + " applications"
                font.family: GlobalState.ThemeManager.fontFamily
                font.pixelSize: GlobalState.ThemeManager.fontSizeSmall
                color: GlobalState.ThemeManager.on_surface_variant
                opacity: 0.7
                Layout.alignment: Qt.AlignRight
            }
        }

        Basic.CloseButton {
            anchors {
                top: parent.top
                right: parent.right
                margins: 16
            }
            onClicked: {
                appLauncher.visible = false
                searchField.text = ""
            }
        }
    }

    GlobalShortcut {
        name: "appLauncherToggle"
        description: "Toggle App Launcher"
        onPressed: {
            appLauncher.visible = !appLauncher.visible
            if (appLauncher.visible) {
                searchField.forceActiveFocus()
                searchField.text = ""
                appGrid.updateFilter()
            }
        }
    }
}