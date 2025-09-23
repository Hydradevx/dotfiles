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
		time.Sleep(2 * time.Second)
	}
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

	format := "{{title}}|||{{artist}}|||{{mpris:artUrl}}|||{{status}}"
	out, err := runPlayerctl("metadata", "--format", format)
	if err != nil {
		ensureSpotifyRunning()
		out, err = runPlayerctl("metadata", "--format", format)
		if err != nil {
			j, _ := json.Marshal(Track{
				Title:    "Start Spotify",
				Artist:   "Click play to start music",
				AlbumArt: "",
				Playing:  false,
				Status:   "",
				Position: 0,
				Length:   0,
			})
			fmt.Println(string(j))
			return
		}
	}

	parts := strings.SplitN(out, "|||", 4)
	for len(parts) < 4 {
		parts = append(parts, "")
	}
	status := parts[3]
	playing := strings.EqualFold(status, "Playing")

	positionStr, _ := runPlayerctl("position")
	lengthStr, _ := runPlayerctl("metadata", "--format", "{{mpris:length}}")

	lengthMicros, err := strconv.ParseFloat(lengthStr, 64)
	length := lengthMicros / 1000000.0
	if err != nil {
		length = 0
	}

	position := parseTime(positionStr)

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
	_ = exec.Command("playerctl", action).Run()
}
