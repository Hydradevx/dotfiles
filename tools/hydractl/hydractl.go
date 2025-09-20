// hydractl.go
package main

import (
	"encoding/json"
	"fmt"
	"os"
	"os/exec"
	"strings"
)

type Track struct {
	Title    string `json:"title"`
	Artist   string `json:"artist"`
	AlbumArt string `json:"albumArt"`
	Playing  bool   `json:"playing"`
	Status   string `json:"status"`
}

// helper: run playerctl with args and return trimmed stdout (no shell)
func runPlayerctl(args ...string) (string, error) {
	cmd := exec.Command("playerctl", args...)
	out, err := cmd.Output()
	if err != nil {
		return "", err
	}
	return strings.TrimSpace(string(out)), nil
}

func cmdStatus() {
	// get metadata in one shot using a format that won't be interpreted by a shell
	format := "{{title}}|||{{artist}}|||{{mpris:artUrl}}|||{{status}}"
	out, err := runPlayerctl("metadata", "--format", format)
	if err != nil {
		// on error, return empty track (still valid JSON) so QML can parse gracefully
		j, _ := json.Marshal(Track{Title: "", Artist: "", AlbumArt: "", Playing: false, Status: ""})
		fmt.Println(string(j))
		return
	}

	parts := strings.SplitN(out, "|||", 4)
	for len(parts) < 4 {
		parts = append(parts, "")
	}
	status := parts[3]
	playing := strings.EqualFold(status, "Playing")

	track := Track{
		Title:    parts[0],
		Artist:   parts[1],
		AlbumArt: parts[2],
		Playing:  playing,
		Status:   status,
	}

	enc := json.NewEncoder(os.Stdout)
	enc.Encode(track)
}

func cmdControl(action string) {
	// action is one of: play-pause, next, previous
	_ = exec.Command("playerctl", action).Run()
	// ignore error — caller will refresh status
}

func main() {
	if len(os.Args) < 2 {
		fmt.Fprintln(os.Stderr, "usage: hydractl [status|play-pause|next|previous]")
		os.Exit(2)
	}
	switch os.Args[1] {
	case "status":
		cmdStatus()
	case "play-pause", "next", "previous":
		cmdControl(os.Args[1])
	default:
		fmt.Fprintf(os.Stderr, "unknown command: %s\n", os.Args[1])
		os.Exit(2)
	}
}