pragma Singleton
import QtQuick 2.15
import "."

QtObject {
    id: theme
    
    // Reference to Colors singleton
    property var colors: Colors
    
    // Color properties 
    property color background: colors.background
    property color error: colors.error
    property color error_container: colors.error_container
    property color inverse_on_surface: colors.inverse_on_surface
    property color inverse_primary: colors.inverse_primary
    property color inverse_surface: colors.inverse_surface
    property color on_background: colors.on_background
    property color on_error: colors.on_error
    property color on_error_container: colors.on_error_container
    property color on_primary: colors.on_primary
    property color on_primary_container: colors.on_primary_container
    property color on_primary_fixed: colors.on_primary_fixed
    property color on_primary_fixed_variant: colors.on_primary_fixed_variant
    property color on_secondary: colors.on_secondary
    property color on_secondary_container: colors.on_secondary_container
    property color on_secondary_fixed: colors.on_secondary_fixed
    property color on_secondary_fixed_variant: colors.on_secondary_fixed_variant
    property color on_surface: colors.on_surface
    property color on_surface_variant: colors.on_surface_variant
    property color on_tertiary: colors.on_tertiary
    property color on_tertiary_container: colors.on_tertiary_container
    property color on_tertiary_fixed: colors.on_tertiary_fixed
    property color on_tertiary_fixed_variant: colors.on_tertiary_fixed_variant
    property color outline: colors.outline
    property color outline_variant: colors.outline_variant
    property color primary: colors.primary
    property color primary_container: colors.primary_container
    property color primary_fixed: colors.primary_fixed
    property color primary_fixed_dim: colors.primary_fixed_dim
    property color scrim: colors.scrim
    property color secondary: colors.secondary
    property color secondary_container: colors.secondary_container
    property color secondary_fixed: colors.secondary_fixed
    property color secondary_fixed_dim: colors.secondary_fixed_dim
    property color shadow: colors.shadow
    property color surface: colors.surface
    property color surface_bright: colors.surface_bright
    property color surface_container: colors.surface_container
    property color surface_container_high: colors.surface_container_high
    property color surface_container_highest: colors.surface_container_highest
    property color surface_container_low: colors.surface_container_low
    property color surface_container_lowest: colors.surface_container_lowest
    property color surface_dim: colors.surface_dim
    property color surface_tint: colors.surface_tint
    property color surface_variant: colors.surface_variant
    property color tertiary: colors.tertiary
    property color tertiary_container: colors.tertiary_container
    property color tertiary_fixed: colors.tertiary_fixed
    property color tertiary_fixed_dim: colors.tertiary_fixed_dim
    
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