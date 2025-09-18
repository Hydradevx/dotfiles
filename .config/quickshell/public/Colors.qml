import QtQuick 2.15
import QtQuick.Json 1.0

QtObject {
    id: appearance

    JsonAdapter {
        id: colors
        source: Qt.resolvedUrl("colors.json")
    }

    property color background: colors.object.background
    property color error: colors.object.error
    property color error_container: colors.object.error_container
    property color inverse_on_surface: colors.object.inverse_on_surface
    property color inverse_primary: colors.object.inverse_primary
    property color inverse_surface: colors.object.inverse_surface
    property color on_background: colors.object.on_background
    property color on_error: colors.object.on_error
    property color on_error_container: colors.object.on_error_container
    property color on_primary: colors.object.on_primary
    property color on_primary_container: colors.object.on_primary_container
    property color on_primary_fixed: colors.object.on_primary_fixed
    property color on_primary_fixed_variant: colors.object.on_primary_fixed_variant
    property color on_secondary: colors.object.on_secondary
    property color on_secondary_container: colors.object.on_secondary_container
    property color on_secondary_fixed: colors.object.on_secondary_fixed
    property color on_secondary_fixed_variant: colors.object.on_secondary_fixed_variant
    property color on_surface: colors.object.on_surface
    property color on_surface_variant: colors.object.on_surface_variant
    property color on_tertiary: colors.object.on_tertiary
    property color on_tertiary_container: colors.object.on_tertiary_container
    property color on_tertiary_fixed: colors.object.on_tertiary_fixed
    property color on_tertiary_fixed_variant: colors.object.on_tertiary_fixed_variant
    property color outline: colors.object.outline
    property color outline_variant: colors.object.outline_variant
    property color primary: colors.object.primary
    property color primary_container: colors.object.primary_container
    property color primary_fixed: colors.object.primary_fixed
    property color primary_fixed_dim: colors.object.primary_fixed_dim
    property color scrim: colors.object.scrim
    property color secondary: colors.object.secondary
    property color secondary_container: colors.object.secondary_container
    property color secondary_fixed: colors.object.secondary_fixed
    property color secondary_fixed_dim: colors.object.secondary_fixed_dim
    property color shadow: colors.object.shadow
    property color surface: colors.object.surface
    property color surface_bright: colors.object.surface_bright
    property color surface_container: colors.object.surface_container
    property color surface_container_high: colors.object.surface_container_high
    property color surface_container_highest: colors.object.surface_container_highest
    property color surface_container_low: colors.object.surface_container_low
    property color surface_container_lowest: colors.object.surface_container_lowest
    property color surface_dim: colors.object.surface_dim
    property color surface_tint: colors.object.surface_tint
    property color surface_variant: colors.object.surface_variant
    property color tertiary: colors.object.tertiary
    property color tertiary_container: colors.object.tertiary_container
    property color tertiary_fixed: colors.object.tertiary_fixed
    property color tertiary_fixed_dim: colors.object.tertiary_fixed_dim
}