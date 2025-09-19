import Quickshell
import "modules/bar"
import "modules/performance"
import "modules/spotify"

Scope {
    Bar { id: bar }

    PerformancePopup {
        id: perfPopup
    }

    Spotify {
        id: spotify
    }

}