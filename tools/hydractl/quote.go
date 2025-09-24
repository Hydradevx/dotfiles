package main

import (
	"bufio"
	"fmt"
	"math/rand"
	"os"
	"path/filepath"
	"time"
)

func quoteCommand() {
	quotesPath := filepath.Join(os.Getenv("HOME"), ".config", "quickshell", "modules", "quote", "quotes.txt")

	file, err := os.Open(quotesPath)
	if err != nil {
		fmt.Println("No quotes available")
		return
	}
	defer file.Close()

	var quotes []string
	scanner := bufio.NewScanner(file)

	for scanner.Scan() {
		line := scanner.Text()
		if line != "" {
			quotes = append(quotes, line)
		}
	}

	if err := scanner.Err(); err != nil || len(quotes) == 0 {
		fmt.Println("No quotes available")
		return
	}

	rand.Seed(time.Now().UnixNano())
	randomQuote := quotes[rand.Intn(len(quotes))]
	fmt.Println(randomQuote)
}
