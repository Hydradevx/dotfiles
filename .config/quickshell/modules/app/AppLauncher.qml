import Quickshell
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell.Hyprland
import "../public" as Theme

PanelWindow {
    id: appLauncher
    visible: false
    implicitWidth: 1000
    implicitHeight: 700
    color: "transparent"

    Rectangle {
        anchors.fill: parent
        color: "#000000"
        opacity: appLauncher.visible ? 0.4 : 0
        Behavior on opacity { NumberAnimation { duration: 200 } }
        
        MouseArea {
            anchors.fill: parent
            onClicked: appLauncher.visible = false
        }
    }

    Rectangle {
        anchors.centerIn: parent
        width: Math.min(parent.width * 0.9, 1000)
        height: Math.min(parent.height * 0.85, 700)
        radius: 24
        color: Theme.Colors.surface
        border.color: Theme.Colors.outline
        border.width: 1
        opacity: 0.98

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 30
            spacing: 20

            // Search bar
            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 50
                radius: 12
                color: Theme.Colors.surface_variant
                border.color: Theme.Colors.outline
                border.width: 1

                RowLayout {
                    anchors.fill: parent
                    anchors.margins: 12
                    spacing: 12

                    Text {
                        text: "🔍"
                        font.pixelSize: 18
                        Layout.alignment: Qt.AlignVCenter
                    }

                    TextField {
                        id: searchField
                        Layout.fillWidth: true
                        placeholderText: "Search applications..."
                        font.family: "Maple Mono NF"
                        font.pixelSize: 14
                        background: Rectangle { color: "transparent" }
                        onTextChanged: filterModel.updateFilter()
                    }
                }
            }

            GridView {
                id: grid
                Layout.fillWidth: true
                Layout.fillHeight: true
                cellWidth: 180
                cellHeight: 160
                model: filteredApplications
                clip: true
                cacheBuffer: 1000

                delegate: Rectangle {
                    id: card
                    width: grid.cellWidth - 15
                    height: grid.cellHeight - 15
                    radius: 16
                    color: cardMouseArea.containsMouse ? Theme.Colors.primary_container : Theme.Colors.surface_variant
                    border.color: Theme.Colors.outline
                    border.width: 1
                    
                    Behavior on color { ColorAnimation { duration: 150 } }
                    Behavior on scale { NumberAnimation { duration: 100 } }

                    scale: cardMouseArea.containsMouse ? 1.05 : 1.0

                    Column {
                        anchors.centerIn: parent
                        spacing: 12
                        width: parent.width - 24

                        Rectangle {
                            width: 64
                            height: 64
                            radius: 12
                            color: cardMouseArea.containsMouse ? Theme.Colors.primary : Theme.Colors.surface
                            anchors.horizontalCenter: parent.horizontalCenter

                            Image {
                                id: appIcon
                                source: Quickshell.iconPath(modelData.icon)
                                width: 40
                                height: 40
                                anchors.centerIn: parent
                                fillMode: Image.PreserveAspectFit
                                smooth: true
                                opacity: 0.9
                            }
                        }

                        Text {
                            id: appName
                            text: modelData.name
                            font.family: "Maple Mono NF"
                            font.pixelSize: 12
                            font.weight: Font.Medium
                            color: cardMouseArea.containsMouse ? Theme.Colors.on_primary_container : Theme.Colors.on_surface_variant
                            wrapMode: Text.Wrap
                            horizontalAlignment: Text.AlignHCenter
                            maximumLineCount: 2
                            elide: Text.ElideRight
                            width: parent.width
                        }
                    }

                    MouseArea {
                        id: cardMouseArea
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        
                        onClicked: {
                            modelData.execute()
                            appLauncher.visible = false
                            searchField.text = ""
                        }
                    }
                }

                ScrollBar.vertical: ScrollBar {
                    policy: ScrollBar.AsNeeded
                    width: 8
                    background: Rectangle { color: "transparent" }
                    contentItem: Rectangle {
                        radius: 4
                        color: Theme.Colors.outline
                        opacity: 0.6
                    }
                }
            }

            Text {
                id: appCount
                text: filteredApplications.count + " applications"
                font.family: "MapleMono NF"
                font.pixelSize: 11
                color: Theme.Colors.on_surface_variant
                opacity: 0.7
                Layout.alignment: Qt.AlignRight
            }
        }

        Rectangle {
            anchors {
                top: parent.top
                right: parent.right
                margins: 16
            }
            width: 32
            height: 32
            radius: 8
            color: closeMouseArea.containsMouse ? Theme.Colors.error_container : "transparent"
            
            Text {
                text: "×"
                font.pixelSize: 20
                font.weight: Font.Bold
                color: closeMouseArea.containsMouse ? Theme.Colors.on_error_container : Theme.Colors.on_surface_variant
                anchors.centerIn: parent
            }

            MouseArea {
                id: closeMouseArea
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: {
                    appLauncher.visible = false
                    searchField.text = ""
                }
            }
        }
    }

    ListModel {
        id: filteredApplications
    }

    function updateFilter() {
        filteredApplications.clear()
        const searchTerm = searchField.text.toLowerCase()
        
        for (const app of DesktopEntries.applications.values) {
            if (searchTerm === "" || app.name.toLowerCase().includes(searchTerm)) {
                filteredApplications.append({ modelData: app })
            }
        }
    }

    Component.onCompleted: updateFilter()

    GlobalShortcut {
        name: "appLauncherToggle"
        description: "Toggle App Launcher"
        onPressed: {
            appLauncher.visible = !appLauncher.visible
            if (appLauncher.visible) {
                searchField.forceActiveFocus()
                searchField.text = ""
            }
        }
    }
}