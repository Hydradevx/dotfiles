import QtQuick
import QtQuick.Layouts
import "../public" as Theme

Item {
    id: gauge
    property string label: "CPU"
    property real value: 0
    property real maxValue: 100
    property color gaugeColor: Theme.Colors.primary
    property color needleColor: Theme.Colors.primary
    
    readonly property real startAngle: -135  // Start at bottom-left
    readonly property real endAngle: 135     // End at bottom-right
    readonly property real angleRange: endAngle - startAngle

    // Calculate needle angle based on value
    property real needleAngle: startAngle + (value / maxValue) * angleRange

    // Timer to redraw gauge every 10 seconds
    Timer {
        id: redrawTimer
        interval: 10000 
        running: true
        repeat: true
        onTriggered: {
            gaugeCanvas.requestPaint()
        }
    }

    ColumnLayout {
        anchors.fill: parent
        spacing: 5
        
        Text {
            text: label
            font.pixelSize: 16
            font.bold: true
            color: Theme.Colors.on_surface
            horizontalAlignment: Text.AlignHCenter
            Layout.alignment: Qt.AlignHCenter
            Layout.topMargin: 5
        }

        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.preferredHeight: parent.height * 0.8 
            
            Canvas {
                id: gaugeCanvas
                anchors.fill: parent
                antialiasing: true
                
                onPaint: {
                    var ctx = getContext("2d")
                    ctx.reset()
                    
                    var centerX = width / 2
                    var centerY = height / 2
                    var radius = Math.min(width, height) * 0.45  // Increased from 0.35 to 0.45
                    var lineWidth = 10  // Increased from 8 to 10
                    
                    ctx.beginPath()
                    ctx.arc(centerX, centerY, radius, 
                           startAngle * Math.PI / 180, 
                           endAngle * Math.PI / 180)
                    ctx.lineWidth = lineWidth
                    ctx.strokeStyle = Theme.Colors.surface_variant
                    ctx.stroke()
                    
                    // Draw gauge value arc
                    ctx.beginPath()
                    ctx.arc(centerX, centerY, radius,
                           startAngle * Math.PI / 180,
                           needleAngle * Math.PI / 180)
                    ctx.lineWidth = lineWidth
                    ctx.strokeStyle = gaugeColor
                    ctx.stroke()
                    
                    // Draw gauge ticks
                    ctx.lineWidth = 2
                    ctx.strokeStyle = Theme.Colors.on_surface_variant
                    for (var i = 0; i <= 10; i++) {
                        var angle = startAngle + (i / 10) * angleRange
                        var tickAngle = angle * Math.PI / 180
                        var innerRadius = radius - 12 
                        var outerRadius = radius + 8   
                        
                        ctx.beginPath()
                        ctx.moveTo(centerX + innerRadius * Math.cos(tickAngle),
                                  centerY + innerRadius * Math.sin(tickAngle))
                        ctx.lineTo(centerX + outerRadius * Math.cos(tickAngle),
                                  centerY + outerRadius * Math.sin(tickAngle))
                        ctx.stroke()
                    }
                    
                    var needleLength = radius - 10 
                    var needleBaseWidth = 5 
                    var needleAngleRad = needleAngle * Math.PI / 180
                    
                    ctx.save()
                    ctx.translate(centerX, centerY)
                    ctx.rotate(needleAngleRad)
                    
                    // Needle shape
                    ctx.beginPath()
                    ctx.moveTo(0, 0)
                    ctx.lineTo(needleLength, 0)
                    ctx.lineTo(0, -needleBaseWidth)
                    ctx.lineTo(0, needleBaseWidth)
                    ctx.closePath()
                    
                    ctx.fillStyle = needleColor
                    ctx.fill()
                    
                    // Needle center circle
                    ctx.beginPath()
                    ctx.arc(0, 0, 8, 0, 2 * Math.PI) 
                    ctx.fillStyle = Theme.Colors.on_surface
                    ctx.fill()
                    
                    ctx.restore()
                }
            }
        }
        
        Text {
            text: value.toFixed(1) + "%"
            font.pixelSize: 18
            font.bold: true
            color: Theme.Colors.primary
            horizontalAlignment: Text.AlignHCenter
            Layout.alignment: Qt.AlignHCenter
            Layout.bottomMargin: 5
        }
    }
    
    // Update canvas when value changes
    onValueChanged: gaugeCanvas.requestPaint()
    onMaxValueChanged: gaugeCanvas.requestPaint()
    
    // Force initial paint
    Component.onCompleted: gaugeCanvas.requestPaint()
}