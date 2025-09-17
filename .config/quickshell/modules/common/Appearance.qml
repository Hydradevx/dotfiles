import QtQuick
import Quickshell
import Quickshell.Io

pragma Singleton

Singleton {
    property JsonLoader scheme: JsonLoader {
        source: "file://" + Quickshell.runtime.userStateDir + "/generated/colors.json"
    }

    // Example mapped properties
    property color background: scheme.data.background || "#1e1e2e"
    property color onBackground: scheme.data.on_background || "#cdd6f4"
    property color primary: scheme.data.primary || "#89b4fa"
    property color onPrimary: scheme.data.on_primary || "#1e1e2e"
    property color surface: scheme.data.surface || "#313244"
    property color onSurface: scheme.data.on_surface || "#cdd6f4"
}