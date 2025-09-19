import QtQuick
import QtQuick.Controls
import Quickshell.Io
import "../public" as Theme

Item {
    id: perfCircle
    property string label: "Metric"
    property string command: ""
    property string suffix: "%"
    property real value: 0

    width: 120
    height: 120

    Canvas {
        id: arcCanvas
        anchors.fill: parent
        onPaint: {
            var ctx = getContext("2d")
            ctx.clearRect(0, 0, width, height)
            ctx.lineWidth = 8
            ctx.strokeStyle = "#d3869b" // theme accent
            ctx.beginPath()
            ctx.arc(width/2, height/2, 45, -Math.PI/2, (2*Math.PI * value/100) - Math.PI/2)
            ctx.stroke()
        }
    }

    Column {
        anchors.centerIn: parent
        spacing: 4
        Text { text: Math.round(value) + suffix; font.pixelSize: 18; color: Theme.Colors.on_surface; horizontalAlignment: Text.AlignHCenter }
        Text { text: label; font.pixelSize: 12; color: Theme.Colors.on_surface; horizontalAlignment: Text.AlignHCenter }
    }

Timer {
    interval: 2000
    running: true
    repeat: true
    onTriggered: {
        if (command !== "") {
            var proc = Qt.createQmlObject('import Quickshell.Io; Process {}', perfCircle)
            proc.command = ["bash", "-c", command]
            proc.running = true

            // Create stdout collector
            var stdoutCollector = Qt.createQmlObject('import Quickshell.Io; StdioCollector {}', perfCircle)

            // Connect to the streamFinished signal
            stdoutCollector.streamFinished.connect(function() {
                var parsed = parseFloat(stdoutCollector.text)
                if (!isNaN(parsed)) value = parsed
                arcCanvas.requestPaint()
            })

            // Assign collector to proc stdout
            proc.stdout = stdoutCollector
        }
    }
}
}