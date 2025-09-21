package main

import (
	"encoding/json"
	"fmt"
	"os"
	"os/exec"
	"strings"
)

func runPlayerctl(args ...string) (string, error) {
	cmd := exec.Command("playerctl", args...)
	out, err := cmd.Output()
	if err != nil {
		return "", err
	}
	return strings.TrimSpace(string(out)), nil
}

func MusicStatus() {
	format := "{{title}}|||{{artist}}|||{{mpris:artUrl}}|||{{status}}"
	out, err := runPlayerctl("metadata", "--format", format)
	if err != nil {
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
	json.NewEncoder(os.Stdout).Encode(track)
}

func MusicControl(action string) {
	_ = exec.Command("playerctl", action).Run()
}
