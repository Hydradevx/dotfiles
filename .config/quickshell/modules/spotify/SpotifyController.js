// SpotifyController.js
.pragma library

var currentTrack = { title: "No track", artist: "Unknown", albumArt: "" }
var playing = false
var callback = null

function setChangeCallback(cb) {
    callback = cb
}

function updateTrack(track) {
    currentTrack = track
    if (callback) callback(track)
}

function playPause() {
    spawnCommand("dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.PlayPause")
    playing = !playing
    updateTrack(currentTrack)
}

function next() {
    spawnCommand("dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Next")
}

function prev() {
    spawnCommand("dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Previous")
}

function spawnCommand(cmd) {
    var proc = new QProcess()
    proc.start(cmd)
    proc.waitForFinished()
}

function pollTrackInfo() {
    var proc = new QProcess()
    proc.start("bash", ["-c", "playerctl metadata --format '{{ title }}|{{ artist }}|{{ mpris:artUrl }}'"])
    proc.waitForFinished()
    var output = proc.readAllStandardOutput().trim()
    if (output) {
        var parts = output.split("|")
        currentTrack.title = parts[0] || "No track"
        currentTrack.artist = parts[1] || "Unknown"
        currentTrack.albumArt = parts[2] || ""
        if (callback) callback(currentTrack)
    }
}