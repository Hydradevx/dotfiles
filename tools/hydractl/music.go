package main

import (
	"encoding/json"
	"fmt"
	"os"
	"os/exec"
	"strconv"
	"strings"
	"time"
)

func runPlayerctl(args ...string) (string, error) {
	cmd := exec.Command("playerctl", args...)
	out, err := cmd.Output()
	if err != nil {
		return "", err
	}
	return strings.TrimSpace(string(out)), nil
}

func ensureSpotifyRunning() {
	cmd := exec.Command("playerctl", "status")
	if err := cmd.Run(); err != nil {
		fmt.Fprintln(os.Stderr, "No music player detected, starting Spotify...")
		exec.Command("bash", "-c", "spotify &").Start()
		time.Sleep(3 * time.Second)
	}
}

func getCurrentPlayer() string {
	players, err := runPlayerctl("--list-all")
	if err != nil || players == "" {
		return ""
	}

	playerList := strings.Split(players, "\n")
	if len(playerList) == 0 {
		return ""
	}

	// Prefer spotify if available
	for _, player := range playerList {
		if strings.Contains(strings.ToLower(player), "spotify") {
			return player
		}
	}

	return playerList[0]
}

func parseTime(timeStr string) float64 {
	if strings.Contains(timeStr, ":") {
		parts := strings.Split(timeStr, ":")
		if len(parts) == 2 {
			minutes, _ := strconv.ParseFloat(parts[0], 64)
			seconds, _ := strconv.ParseFloat(parts[1], 64)
			return minutes*60 + seconds
		}
	}

	seconds, err := strconv.ParseFloat(timeStr, 64)
	if err != nil {
		return 0
	}
	return seconds
}

func MusicStatus() {
	ensureSpotifyRunning()

	player := getCurrentPlayer()
	if player == "" {
		j, _ := json.Marshal(Track{
			Title:    "No player found",
			Artist:   "Start a music player",
			AlbumArt: "",
			Playing:  false,
			Status:   "Stopped",
			Position: 0,
			Length:   0,
		})
		fmt.Println(string(j))
		return
	}

	format := "{{title}}|||{{artist}}|||{{mpris:artUrl}}|||{{status}}"
	out, err := runPlayerctl("--player", player, "metadata", "--format", format)
	if err != nil {
		j, _ := json.Marshal(Track{
			Title:    "Player error",
			Artist:   "Check music player",
			AlbumArt: "",
			Playing:  false,
			Status:   "Error",
			Position: 0,
			Length:   0,
		})
		fmt.Println(string(j))
		return
	}

	parts := strings.SplitN(out, "|||", 4)
	for len(parts) < 4 {
		parts = append(parts, "")
	}

	status := parts[3]
	playing := strings.EqualFold(status, "Playing")

	positionStr, err := runPlayerctl("--player", player, "position")
	if err != nil {
		positionStr = "0"
	}

	lengthStr, err := runPlayerctl("--player", player, "metadata", "mpris:length")
	if err != nil {
		lengthStr = "0"
	}

	lengthMicros, err := strconv.ParseFloat(lengthStr, 64)
	length := lengthMicros / 1000000.0
	if err != nil || length <= 0 {
		length = 0
	}

	position, err := strconv.ParseFloat(positionStr, 64)
	if err != nil || position < 0 {
		position = 0
	}

	if position == 0 && playing && length > 0 {
		posMetadata, err := runPlayerctl("--player", player, "metadata", "--format", "{{position(position)}}")
		if err == nil && posMetadata != "" {
			if altPos, err := strconv.ParseFloat(posMetadata, 64); err == nil && altPos > 0 {
				position = altPos
			}
		}
	}

	track := Track{
		Title:    parts[0],
		Artist:   parts[1],
		AlbumArt: parts[2],
		Playing:  playing,
		Status:   status,
		Position: position,
		Length:   length,
	}

	json.NewEncoder(os.Stdout).Encode(track)
}

func MusicControl(action string) {
	ensureSpotifyRunning()
	time.Sleep(500 * time.Millisecond)

	player := getCurrentPlayer()
	if player == "" {
		return
	}

	var err error
	switch action {
	case "play", "pause", "play-pause", "stop", "next", "previous":
		err = exec.Command("playerctl", "--player", player, action).Run()
	case "seek_forward":
		err = exec.Command("playerctl", "--player", player, "position", "10+").Run()
	case "seek_backward":
		err = exec.Command("playerctl", "--player", player, "position", "10-").Run()
	default:
		err = exec.Command("playerctl", "--player", player, action).Run()
	}

	if err != nil {
		fmt.Fprintf(os.Stderr, "Error controlling player: %v\n", err)
	}
}
