import QtQuick
import "../common"

Text {
    text: DateTime.time
    color: Appearance.onSurface
    font.pixelSize: 14
    verticalAlignment: Text.AlignVCenter
}