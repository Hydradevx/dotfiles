import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import "../public" as Theme
import Quickshell.Io

PopupWindow {
    id: quotePopup
    visible: false
    implicitWidth: 500
    implicitHeight: 180
    color: "transparent"

    anchor.window: bar
    anchor.rect.x: bar.width
    anchor.rect.y: bar.height

    property real popupScale: 0.0
    property real popupOpacity: 0.0
    property string currentQuote: "No quotes"

    onVisibleChanged: {
        if (visible) {
            showAnimation.start()
            loadRandomQuote()
        } else {
            hideAnimation.start()
        }
    }

    ParallelAnimation {
        id: showAnimation
        NumberAnimation {
            target: quotePopup
            property: "popupScale"
            from: 0.0
            to: 1.0
            duration: 300
            easing.type: Easing.OutBack
            easing.overshoot: 1.5
        }
        NumberAnimation {
            target: quotePopup
            property: "popupOpacity"
            from: 0.0
            to: 1.0
            duration: 200
        }
    }

    ParallelAnimation {
        id: hideAnimation
        NumberAnimation {
            target: quotePopup
            property: "popupScale"
            from: 1.0
            to: 0.0
            duration: 200
            easing.type: Easing.InBack
        }
        NumberAnimation {
            target: quotePopup
            property: "popupOpacity"
            from: 1.0
            to: 0.0
            duration: 150
        }
    }

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        onEntered: quotePopup.visible = true
        onExited: {
            if (!quoteIcon.isHovered) {
                quotePopup.visible = false
            }
        }
    }

    function loadRandomQuote() {
        quoteProc.running = true
    }

    Process {
        id: quoteProc
        command: ["bash", "-c", "shuf -n 1 ~/.config/quickshell/modules/quote/quotes.txt"]
        running: false
        stdout: StdioCollector {
            onStreamFinished: {
                var quote = this.text.trim()
                if (quote && quote.length > 0) {
                    quotePopup.currentQuote = quote
                } else {
                    quotePopup.currentQuote = "No quotes available"
                }
            }
        }
    }

    Rectangle {
        id: bg
        anchors.fill: parent
        color: Theme.Colors.surface
        radius: 12
        
        Rectangle {
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            height: parent.radius
            color: parent.color
        }

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 16
            anchors.topMargin: 12
            spacing: 12

            Text {
                text: "Quote"
                font.pixelSize: 18
                font.bold: true
                color: Theme.Colors.on_surface
            }

            Rectangle {
                Layout.fillWidth: true
                Layout.fillHeight: true
                radius: 8
                color: Theme.Colors.surface_variant
                border.color: Theme.Colors.outline
                border.width: 1

                ScrollView {
                    anchors.fill: parent
                    anchors.margins: 8
                    clip: true

                    Text {
                        id: quoteText
                        text: quotePopup.currentQuote
                        color: Theme.Colors.on_surface_variant
                        wrapMode: Text.WordWrap
                        font.pixelSize: 14
                        font.family: "Maple Mono NF"
                    }
                }
            }

            RowLayout {
                Layout.fillWidth: true
                spacing: 8

                Item { Layout.fillWidth: true }

                Rectangle {
                    Layout.preferredWidth: 120
                    Layout.preferredHeight: 30
                    radius: 8
                    color: newQuoteMouseArea.containsMouse ? Theme.Colors.primary : Theme.Colors.surface_variant
                    border.color: Theme.Colors.outline
                    border.width: 1

                    Text {
                        anchors.centerIn: parent
                        text: "New Quote"
                        font.family: "Maple Mono NF"
                        font.pixelSize: 11
                        color: newQuoteMouseArea.containsMouse ? Theme.Colors.on_primary : Theme.Colors.on_surface_variant
                    }

                    MouseArea {
                        id: newQuoteMouseArea
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: quotePopup.loadRandomQuote()
                    }
                }
            }
        }
    }

    Component.onCompleted: loadRandomQuote()
}