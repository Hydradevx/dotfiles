import QtQuick
import QtQuick.Layouts
import Quickshell.Io
import "../public" as Theme

Item {
    id: res
    width: 140
    height: 140

    property string command1: ""
    property string command2: ""
    property real value1: 0
    property real value2: 0
    property string label1: ""
    property string label2: ""
    property string sublabel1: ""
    property string sublabel2: ""

    readonly property real thickness: 8
    property color fg1: Theme.Colors.primary
    property color fg2: Theme.Colors.secondary
    property color bg1: Theme.Colors.surface_variant
    property color bg2: Theme.Colors.outline

    Process {
        id: proc1
        command: ["bash", "-c", res.command1]
        stdout: StdioCollector {
            id: out1
            onStreamFinished: {
                const parsed = parseFloat(text);
                if (!isNaN(parsed)) {
                    res.value1 = parsed / 100;
                    res.label1 = `${Math.round(parsed)}%`;
                    canvas.requestPaint();
                }
            }
        }
    }

    Process {
        id: proc2
        command: ["bash", "-c", res.command2]
        stdout: StdioCollector {
            id: out2
            onStreamFinished: {
                const parsed = parseFloat(text);
                if (!isNaN(parsed)) {
                    res.value2 = parsed / 100;
                    res.label2 = `${Math.round(parsed)}%`;
                    canvas.requestPaint();
                }
            }
        }
    }

    Timer {
        interval: 2000
        running: true
        repeat: true
        onTriggered: {
            if (command1 !== "") proc1.running = true;
            if (command2 !== "") proc2.running = true;
        }
    }

    Column {
        anchors.centerIn: parent
        spacing: 4
        Text { text: label1; font.pixelSize: 18; color: Theme.Colors.on_surface; horizontalAlignment: Text.AlignHCenter }
        Text { text: sublabel1; font.pixelSize: 12; color: Theme.Colors.on_surface_variant; horizontalAlignment: Text.AlignHCenter }
    }

    Column {
        anchors.horizontalCenter: parent.right
        anchors.top: parent.verticalCenter
        anchors.horizontalCenterOffset: -res.thickness / 2
        anchors.topMargin: res.thickness / 2 + 4
        Text { text: label2; font.pixelSize: 12; color: Theme.Colors.on_surface }
        Text { text: sublabel2; font.pixelSize: 10; color: Theme.Colors.on_surface_variant }
    }

    Canvas {
        id: canvas
        anchors.fill: parent
        readonly property real cx: width / 2
        readonly property real cy: height / 2
        readonly property real arc1Start: 45 * Math.PI / 180
        readonly property real arc1End: 220 * Math.PI / 180
        readonly property real arc2Start: 230 * Math.PI / 180
        readonly property real arc2End: 360 * Math.PI / 180

        onPaint: {
            const ctx = getContext("2d");
            ctx.reset();
            ctx.lineWidth = res.thickness;
            ctx.lineCap = "round";

            const radius = (Math.min(width, height) - ctx.lineWidth) / 2;

            ctx.beginPath();
            ctx.arc(cx, cy, radius, arc1Start, arc1End);
            ctx.strokeStyle = res.bg1;
            ctx.stroke();

            ctx.beginPath();
            ctx.arc(cx, cy, radius, arc1Start, (arc1End - arc1Start) * value1 + arc1Start);
            ctx.strokeStyle = res.fg1;
            ctx.stroke();

            ctx.beginPath();
            ctx.arc(cx, cy, radius, arc2Start, arc2End);
            ctx.strokeStyle = res.bg2;
            ctx.stroke();

            ctx.beginPath();
            ctx.arc(cx, cy, radius, arc2Start, (arc2End - arc2Start) * value2 + arc2Start);
            ctx.strokeStyle = res.fg2;
            ctx.stroke();
        }
    }
}