import QtQuick
import Quickshell
import Quickshell.Io

pragma Singleton

Singleton {
    // Load the generated JSON file from matugen
    FileView {
        id: colorFile
        path: Quickshell.runtime.userStateDir + "/generated/colors.json"
        watchChanges: true
        onFileChanged: reload()

        JsonAdapter {
            id: scheme

            // Define properties that match keys in the JSON
            property string background: "#1e1e2e"
            property string on_background: "#cdd6f4"
            property string primary: "#89b4fa"
            property string secondary: "#f5c2e7"
            property string surface: "#313244"
            property string surface_variant: "#45475a"
            property string outline: "#585b70"
            property string error: "#f38ba8"
            property string on_error: "#1e1e2e"
            property string tertiary: "#94e2d5"
            property string scrim: "#000000"
            // …add all other keys you want from your Matugen template
        }
    }

    // Expose the scheme so you can call Appearance.primary, etc.
    property alias colors: scheme
}
