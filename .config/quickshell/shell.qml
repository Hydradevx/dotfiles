import Quickshell
import Quickshell.Wayland
import Quickshell.Io
import Quickshell.Hyprland
import "modules/bar"
import "modules/performance"
import "modules/music"
import "modules/logout"
import "modules/notification"
import "modules/power"
import "modules/app"
import "modules/lock"

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
}