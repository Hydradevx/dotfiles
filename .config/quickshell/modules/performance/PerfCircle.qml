import QtQuick
import QtQuick.Layouts
import Quickshell.Io
import "../public" as Theme

Item {
    id: res

    property string label1: ""
    property string label2: ""
    property string sublabel1: ""
    property string sublabel2: ""
    property string command1: ""
    property string command2: ""

    property real value1: 0
    property real value2: 0

    width: 140
    height: 140

    readonly property real thickness: 8
    property color fg1: Theme.Colors.primary
    property color fg2: Theme.Colors.secondary
    property color bg1: Theme.Colors.surface_variant
    property color bg2: Theme.Colors.outline

    Column {
        anchors.centerIn: parent
        spacing: 4

        Text {
            text: label1
            font.pixelSize: 18
            color: Theme.Colors.on_surface
            horizontalAlignment: Text.AlignHCenter
        }
        Text {
            text: sublabel1
            font.pixelSize: 12
            color: Theme.Colors.on_surface_variant
            horizontalAlignment: Text.AlignHCenter
        }
    }

    Column {
        anchors.horizontalCenter: parent.right
        anchors.top: parent.verticalCenter
        anchors.horizontalCenterOffset: -res.thickness / 2
        anchors.topMargin: res.thickness / 2 + 4

        Text {
            text: label2
            font.pixelSize: 12
            color: Theme.Colors.on_surface
        }
        Text {
            text: sublabel2
            font.pixelSize: 10
            color: Theme.Colors.on_surface_variant
        }
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
            const a1s = arc1Start, a1e = arc1End;
            const a2s = arc2Start, a2e = arc2End;

            // Arc 1 (bg + fg)
            ctx.beginPath();
            ctx.arc(cx, cy, radius, a1s, a1e);
            ctx.strokeStyle = res.bg1;
            ctx.stroke();

            ctx.beginPath();
            ctx.arc(cx, cy, radius, a1s, (a1e - a1s) * value1 + a1s);
            ctx.strokeStyle = res.fg1;
            ctx.stroke();

            // Arc 2 (bg + fg)
            ctx.beginPath();
            ctx.arc(cx, cy, radius, a2s, a2e);
            ctx.strokeStyle = res.bg2;
            ctx.stroke();

            ctx.beginPath();
            ctx.arc(cx, cy, radius, a2s, (a2e - a2s) * value2 + a2s);
            ctx.strokeStyle = res.fg2;
            ctx.stroke();
        }
    }

    // Refresh with system commands
    Timer {
        interval: 2000
        running: true
        repeat: true
        onTriggered: {
            function run(cmd, callback) {
                const proc = Qt.createQmlObject('import Quickshell.Io; Process {}', res);
                proc.command = ["bash", "-c", cmd];
                const collector = Qt.createQmlObject('import Quickshell.Io; StdioCollector {}', res);
                collector.streamFinished.connect(() => callback(collector.text));
                proc.stdout = collector;
                proc.running = true;
            }

            if (command1 !== "") {
                run(command1, function(out) {
                    const parsed = parseFloat(out);
                    if (!isNaN(parsed)) value1 = parsed / 100; // scale 0–1
                    label1 = `${Math.round(parsed)}%`;
                });
            }

            if (command2 !== "") {
                run(command2, function(out) {
                    const parsed = parseFloat(out);
                    if (!isNaN(parsed)) value2 = parsed / 100;
                    label2 = `${Math.round(parsed)}%`;
                });
            }

            canvas.requestPaint();
        }
    }
}