import QtQuick
import "../public" as Theme
import Quickshell.Io

Text {
    id: powerBtn
    text: ""
    font.pixelSize: 24
    font.family: "JetBrainsMono Nerd Font"
    color: Theme.Colors.on_surface
    anchors.verticalCenter: parent.verticalCenter
    rightPadding: 10

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor

        onClicked: {
            // yo this is unreleated but I'm  pretty sure you're not supposed to do this:https://doc.qt.io/qt-6/qml-qtqml-qt.html#createQmlObject-method:~:text=Warning%3A%20This,by%20string%20manipulation.
            var proc = Qt.createQmlObject('import Quickshell.Io; Process {}', powerBtn);
            proc.command = ["wlogout"];
            proc.running = true;
        }
    }
}
