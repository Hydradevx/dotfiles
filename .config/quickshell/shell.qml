import Quickshell
import "modules/bar"
import "modules/performance"
import "modules/music"

Scope {
    Bar { id: bar }

    PerformancePopup {
        id: perfPopup
    }

    MusicPopup {
        id: musicPopup
    }
}