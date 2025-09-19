pragma Singleton
import Quickshell.Io
import QtQuick
import Quickshell

Singleton {
    id: root

    FileView {
        id: file
        // try to use environment variables if possible to make sure that your code runs on other people computers
        path: `${Quickshell.env("HOME")}/.local/state/quickshell/user/generated/colors.json`
        watchChanges: true
        onFileChanged: reload()
        onAdapterUpdated: writeAdapter()

        JsonAdapter {
            id: adapter

            property string background
            property string error
            property string error_container
            property string inverse_on_surface
            property string inverse_primary
            property string inverse_surface
            property string on_background
            property string on_error
            property string on_error_container
            property string on_primary
            property string on_primary_container
            property string on_primary_fixed
            property string on_primary_fixed_variant
            property string on_secondary
            property string on_secondary_container
            property string on_secondary_fixed
            property string on_secondary_fixed_variant
            property string on_surface
            property string on_surface_variant
            property string on_tertiary
            property string on_tertiary_container
            property string on_tertiary_fixed
            property string on_tertiary_fixed_variant
            property string outline
            property string outline_variant
            property string primary
            property string primary_container
            property string primary_fixed
            property string primary_fixed_dim
            property string scrim
            property string secondary
            property string secondary_container
            property string secondary_fixed
            property string secondary_fixed_dim
            property string shadow
            property string surface
            property string surface_bright
            property string surface_container
            property string surface_container_high
            property string surface_container_highest
            property string surface_container_low
            property string surface_container_lowest
            property string surface_dim
            property string surface_tint
            property string surface_variant
            property string tertiary
            property string tertiary_container
            property string tertiary_fixed
            property string tertiary_fixed_dim
        }
    }

    property alias background: adapter.background
    property alias error: adapter.error
    property alias error_container: adapter.error_container
    property alias inverse_on_surface: adapter.inverse_on_surface
    property alias inverse_primary: adapter.inverse_primary
    property alias inverse_surface: adapter.inverse_surface
    property alias on_background: adapter.on_background
    property alias on_error: adapter.on_error
    property alias on_error_container: adapter.on_error_container
    property alias on_primary: adapter.on_primary
    property alias on_primary_container: adapter.on_primary_container
    property alias on_primary_fixed: adapter.on_primary_fixed
    property alias on_primary_fixed_variant: adapter.on_primary_fixed_variant
    property alias on_secondary: adapter.on_secondary
    property alias on_secondary_container: adapter.on_secondary_container
    property alias on_secondary_fixed: adapter.on_secondary_fixed
    property alias on_secondary_fixed_variant: adapter.on_secondary_fixed_variant
    property alias on_surface: adapter.on_surface
    property alias on_surface_variant: adapter.on_surface_variant
    property alias on_tertiary: adapter.on_tertiary
    property alias on_tertiary_container: adapter.on_tertiary_container
    property alias on_tertiary_fixed: adapter.on_tertiary_fixed
    property alias on_tertiary_fixed_variant: adapter.on_tertiary_fixed_variant
    property alias outline: adapter.outline
    property alias outline_variant: adapter.outline_variant
    property alias primary: adapter.primary
    property alias primary_container: adapter.primary_container
    property alias primary_fixed: adapter.primary_fixed
    property alias primary_fixed_dim: adapter.primary_fixed_dim
    property alias scrim: adapter.scrim
    property alias secondary: adapter.secondary
    property alias secondary_container: adapter.secondary_container
    property alias secondary_fixed: adapter.secondary_fixed
    property alias secondary_fixed_dim: adapter.secondary_fixed_dim
    property alias shadow: adapter.shadow
    property alias surface: adapter.surface
    property alias surface_bright: adapter.surface_bright
    property alias surface_container: adapter.surface_container
    property alias surface_container_high: adapter.surface_container_high
    property alias surface_container_highest: adapter.surface_container_highest
    property alias surface_container_low: adapter.surface_container_low
    property alias surface_container_lowest: adapter.surface_container_lowest
    property alias surface_dim: adapter.surface_dim
    property alias surface_tint: adapter.surface_tint
    property alias surface_variant: adapter.surface_variant
    property alias tertiary: adapter.tertiary
    property alias tertiary_container: adapter.tertiary_container
    property alias tertiary_fixed: adapter.tertiary_fixed
    property alias tertiary_fixed_dim: adapter.tertiary_fixed_dim
}
