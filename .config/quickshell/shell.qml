import Quickshell
import "modules/bar"
import "modules/performance"

Scope {
    Bar { }

    PerformanceOverlay {
    id: perfOverlay
    anchors.top: bar.bottom     
}
}   