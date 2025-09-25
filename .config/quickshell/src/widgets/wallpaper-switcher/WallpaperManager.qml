import QtQuick
import Quickshell
import Quickshell.Io

QtObject {
    id: wallpaperManager
    
    property string wallpapersDir: "/home/hydra/Pictures/wallpapers"
    property string symlinkPath: "~/.config/hypr/current_wallpaper"
    property var wallpapers: []
    property string currentWallpaper: ""
    property int currentIndex: -1
    property bool scanning: false
    
    signal wallpapersLoaded()
    signal scanError(string error)
    
    function scanWallpapers() {
        console.log("Scanning wallpapers in:", wallpapersDir)
        scanning = true
        wallpapers = []
        
        // Use Process directly (not ProcessFactory)
        var process = Qt.createQmlObject(`
            import Quickshell.Io
            Process {
                running: false
            }
        `, wallpaperManager)
        
        process.command = ["find", wallpapersDir, "-type", "f", "(", "-name", "*.jpg", "-o", "-name", "*.png", "-o", "-name", "*.jpeg", "-o", "-name", "*.gif", "-o", "-name", "*.webp", ")"]
        
        process.onExited = function() {
            if (process.exitCode === 0) {
                var output = process.readAllStdout().trim()
                if (output.length > 0) {
                    var files = output.split('\n').filter(line => line.length > 0)
                    console.log("Found", files.length, "wallpapers via find command")
                    
                    files.sort(function(a, b) {
                        try {
                            var statA = Quickshell.stat(a)
                            var statB = Quickshell.stat(b)
                            return statB.mtime - statA.mtime
                        } catch (e) {
                            return 0
                        }
                    })
                    
                    wallpapers = files
                    loadCurrentWallpaper()
                    scanning = false
                    wallpapersLoaded()
                } else {
                    fallbackScan()
                }
            } else {
                fallbackScan()
            }
            process.destroy()
        }
        
        process.start()
    }
    
    function fallbackScan() {
        console.log("Using fallback scan method")
        try {
            var dir = Quickshell.dir(wallpapersDir)
            if (dir.exists) {
                var files = dir.entryList(["*.jpg", "*.png", "*.jpeg", "*.gif", "*.webp"], Quickshell.Dir.Files | Quickshell.Dir.Readable)
                files = files.map(file => dir.absoluteFilePath(file))
                console.log("Found", files.length, "wallpapers via QML Dir")
                wallpapers = files
                loadCurrentWallpaper()
            } else {
                scanError("Wallpapers directory does not exist: " + wallpapersDir)
            }
        } catch (e) {
            scanError("Error scanning wallpapers: " + e)
        }
        scanning = false
        wallpapersLoaded()
    }
    
    function loadCurrentWallpaper() {
        try {
            var normalizedSymlink = symlinkPath.replace("~", Quickshell.env("HOME"))
            var stat = Quickshell.stat(normalizedSymlink)
            
            if (stat.exists) {
                var proc = Qt.createQmlObject(`
                    import Quickshell.Io
                    Process {
                        running: false
                    }
                `, wallpaperManager)
                
                proc.command = ["readlink", "-f", normalizedSymlink]
                proc.onExited = function() {
                    if (proc.exitCode === 0) {
                        currentWallpaper = proc.readAllStdout().trim()
                        currentIndex = wallpapers.indexOf(currentWallpaper)
                        if (currentIndex === -1 && wallpapers.length > 0) {
                            currentIndex = 0
                        }
                        console.log("Current wallpaper:", currentWallpaper, "Index:", currentIndex)
                    }
                    proc.destroy()
                }
                proc.start()
            } else if (wallpapers.length > 0) {
                currentIndex = 0
                currentWallpaper = wallpapers[0]
            }
        } catch (e) {
            console.error("Error loading current wallpaper:", e)
        }
    }
    
    function setWallpaper(index) {
        if (index < 0 || index >= wallpapers.length) return false
        
        currentIndex = index
        currentWallpaper = wallpapers[index]
        return true
    }
    
    function getWallpaperName(index) {
        if (index < 0 || index >= wallpapers.length) return "No wallpaper"
        var path = wallpapers[index]
        return path.split("/").pop() || "Unknown"
    }
}