package main

import (
	"fmt"
	"os"
)

func main() {
	if len(os.Args) < 2 {
		fmt.Fprintln(os.Stderr, "usage: hydractl [music|perf] [status|play-pause|next|previous]")
		os.Exit(2)
	}

	switch os.Args[1] {
	case "music":
		if len(os.Args) < 3 {
			fmt.Fprintln(os.Stderr, "music commands: status, play-pause, next, previous")
			os.Exit(2)
		}
		switch os.Args[2] {
		case "status":
			MusicStatus()
		case "play-pause", "next", "previous":
			MusicControl(os.Args[2])
		default:
			fmt.Fprintf(os.Stderr, "unknown music command: %s\n", os.Args[2])
			os.Exit(2)
		}
	case "perf":
		PerfStatus()
	case "power":
		if len(os.Args) < 3 {
			fmt.Fprintln(os.Stderr, "power commands: get, set [performance|balanced|power-saver]")
			os.Exit(2)
		}
		switch os.Args[2] {
		case "get":
			PowerGet()
		case "set":
			if len(os.Args) < 4 {
				fmt.Fprintln(os.Stderr, "usage: hydractl power set [performance|balanced|power-saver]")
				os.Exit(2)
			}
			PowerSet(os.Args[3])
		default:
			fmt.Fprintf(os.Stderr, "unknown power command: %s\n", os.Args[2])
			os.Exit(2)
		}
	default:
		fmt.Fprintf(os.Stderr, "unknown command: %s\n", os.Args[1])
		os.Exit(2)
	}
}
