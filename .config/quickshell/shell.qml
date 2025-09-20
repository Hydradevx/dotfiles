import Quickshell
import Quickshell.Hyprland
import "modules/bar"
import "modules/performance"
import "modules/music"
import "modules/logout"

Scope {
    Bar { id: bar }

    PerformancePopup {
        id: perfPopup
    }

    MusicPopup {
        id: musicPopup
    }

    LogoutPanel {
        id: logoutPanel
    }
}