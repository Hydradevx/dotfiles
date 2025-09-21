import Quickshell
import Quickshell.Hyprland
import "modules/bar"
import "modules/performance"
import "modules/music"
import "modules/logout"
import "modules/notification"
import "modules/power"

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

    NotificationPanel {
        id: notifPanel
    }

    BatteryPopup {
        id: batteryPopup
    }
}