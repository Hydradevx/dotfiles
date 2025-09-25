import QtQuick
import Quickshell
import Quickshell.Io

QtObject {
    id: commandExecutor
    
    property bool executing: false
    
    signal commandStarted(string command)
    signal commandFinished(string command, int exitCode)
    signal allCommandsFinished()
    
    function applyWallpaper(wallpaperPath) {
        if (executing) {
            console.warn("Already executing commands")
            return
        }
        
        console.log("Applying wallpaper:", wallpaperPath)
        executing = true
        
        var commands = [
            ["bash", "-c", "pgrep -x swww-daemon > /dev/null || swww-daemon"],
            ["swww", "img", wallpaperPath, "--transition-type", "any"],
            ["matugen", "image", wallpaperPath],
            ["bash", "-c", `mkdir -p ~/.config/hypr && ln -sf "${wallpaperPath}" "${symlinkPath.replace('~', '$HOME')}"`],
            ["bash", "-c", "command -v swaync >/dev/null 2>&1 && swaync-client -rs"],
            ["notify-send", "Wallpaper changed", wallpaperPath.split("/").pop()]
        ]
        
        executeCommandSequence(commands, 0)
    }
    
    function executeCommandSequence(commands, index) {
        if (index >= commands.length) {
            executing = false
            allCommandsFinished()
            return
        }
        
        var cmd = commands[index]
        commandStarted(cmd.join(" "))
        
        var process = Qt.createQmlObject(`
            import Quickshell.Io
            Process {
                running: false
            }
        `, commandExecutor)
        
        process.command = cmd
        
        process.onExited = function() {
            commandFinished(cmd.join(" "), process.exitCode)
            process.destroy()
            
            // Continue with next command after a short delay
            Quickshell.singleShot(100, function() {
                executeCommandSequence(commands, index + 1)
            })
        }
        
        process.start()
    }
}