package main

import (
	"fmt"
	"os/exec"
	"strings"
)

func runShellCommand(cmdline string) string {
	cmd := exec.Command("bash", "-c", cmdline)
	out, err := cmd.Output()
	if err != nil {
		return ""
	}
	return strings.TrimSpace(string(out))
}

func PowerGet() {
	profile := runShellCommand("powerprofilesctl get")
	if profile == "" {

		profile = runShellCommand("cpupower frequency-info -p | grep -oE \"performance|powersave\" | head -1")
		if profile == "" {
			profile = "balanced"
		}
	}

	profile = strings.ToLower(profile)
	if strings.Contains(profile, "performance") {
		profile = "performance"
	} else if strings.Contains(profile, "power-saver") || strings.Contains(profile, "powersave") {
		profile = "power-saver"
	} else {
		profile = "balanced"
	}

	fmt.Print(profile)
}

func PowerSet(profile string) {
	profile = strings.ToLower(profile)

	switch profile {
	case "performance", "perf":
		runShellCommand("powerprofilesctl set performance 2>/dev/null || echo 'performance' | tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor")
	case "power-saver", "powersave", "eco":
		runShellCommand("powerprofilesctl set power-saver 2>/dev/null || echo 'powersave' | tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor")
	default: // balanced
		runShellCommand("powerprofilesctl set balanced 2>/dev/null || echo 'ondemand' | tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor")
	}
}
