// modules/bar/Bar.qml
import "../common"
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell

Scope {
    Variants {
        model: Quickshell.screens

        PanelWindow {
            property var modelData
            screen: modelData
            height: 40
            color: Appearance.colLayer0

            RowLayout {
                anchors.left: parent.left
            }

            RowLayout {
                anchors.centerIn: parent
                ClockWidget {
                    Layout.fillHeight: true
                    color: Appearance.colOnLayer0
                }
            }

            RowLayout {
                anchors.right: parent.right
            }

            anchors {
                top: true
                left: true
                right: true
            }
        }
    }
}