import Quickshell
import Quickshell.Wayland
import Quickshell.Io
import Quickshell.Hyprland
import "src/widgets/system-bar"
import "modules/performance"
import "modules/music"
import "modules/logout"
import "src/widgets/notification-panel"
import "modules/power"
import "src/widgets/app-launcher"
import "src/widgets/lock-screen"
import "modules/overview"
import "src/widgets/wallpaper-switcher"
import "modules/quote"

Scope {
    SystemBar { 
        id: bar 
    }

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

    AppLauncher {
        id: appLauncher
    }
    
	LockContext {
		id: lockContext

		onUnlocked: {
			lock.locked = false;
		}
	}

	WlSessionLock {
		id: lock

		locked: false

		WlSessionLockSurface {
			LockSurface {
				anchors.fill: parent
				context: lockContext
			}
		}
	}

    IpcHandler {
        target: "lockscreen"

        function lock() {
            lock.locked = true;
        }

        function unlock()   {
            lock.locked = false;
        }
    }

    GlobalShortcut {
        name: "lockToggle"
        description: "Toggles Lock Screen"
        onPressed: lock.locked = true;
    }

    Overview { id: overview }

    WallpaperSwitcher {
        id: wallpaperChanger
    }

    QuotePopup {
        id: qoutePopup
    }
}