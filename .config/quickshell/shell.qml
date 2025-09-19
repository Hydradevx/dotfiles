import Quickshell
import "modules/bar"
import "modules/performance"

// I changed a little bit shell.qml if you want to keep it clean just put the Variants on another file.
Scope {
    // please refer to the wiki for this:
    Variants {
        model: Quickshell.screens
        delegate: PanelWindow {
            id: rootPanel
            required property ShellScreen modelData
            // if you don't set this to transparent you wont be able to see your screen
            color: "transparent"
            exclusionMode: ExclusionMode.Ignore

            anchors {
                top: true
                bottom: true
                right: true
                left: true
            }

            mask: Region {
                x: 0
                y: bar.height
                width: rootPanel.width
                height: rootPanel.height
                intersection: Intersection.Xor
                // remove this if you don't mind not clicking on PerformanceOverlay
                regions: Region {
                    x: perfOverlay.x
                    y: perfOverlay.y
                    width: perfOverlay.width
                    height: perfOverlay.height
                    intersection: Intersection.Subtract
                }
            }
            Bar {
                id: bar
            }
            PerformanceOverlay {
                id: perfOverlay
            }
        }
    }
}