pragma Singleton
import QtQuick 2.15
import "."

QtObject {
    id: theme
    
    // Typography
    property string fontFamily: "Maple Mono NF"
    property int fontSizeSmall: 11
    property int fontSizeMedium: 14
    property int fontSizeLarge: 18
    
    // Spacing
    property int spacingSmall: 8
    property int spacingMedium: 12
    property int spacingLarge: 20
    
    // Radius
    property int radiusSmall: 8
    property int radiusMedium: 12
    property int radiusLarge: 16
}