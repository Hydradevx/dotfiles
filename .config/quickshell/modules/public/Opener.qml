pragma Singleton

import Quickshell
import Quickshell.Hyprland
import Quickshell.Io

Singleton {
    PersistentProperties {
        id: properties
        reloadableId: "persistedStates"
        property bool perfOpenerOpen: false
    }

    property alias perfOpenerOpen: properties.perfOpenerOpen
    IpcHandler {
        target: "performance"

        function toggle(): void {
            properties.perfOpenerOpen = !properties.perfOpenerOpen;
        }
        function close(): void {
            properties.perfOpenerOpen = false;
        }
        function open(): void {
            properties.perfOpenerOpen = true;
        }
    }

    GlobalShortcut {
        name: "performanceToggle"
        description: "Toggles Performance Monitor"
        onPressed: properties.perfOpenerOpen = !properties.perfOpenerOpen
    }

    GlobalShortcut {
        name: "performanceOpen"
        description: "Opens Performance Monitor"
        onPressed: properties.perfOpenerOpen = true
    }

    GlobalShortcut {
        name: "performanceClose"
        description: "Closes Performance Monitor"
        onPressed: properties.perfOpenerOpen = false
    }
}
