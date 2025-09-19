import Quickshell
import "modules/bar"
import "modules/performance"

Scope {
    Bar { id: bar }

    PerformanceOverlay {
        id: perfOverlay
    }
}