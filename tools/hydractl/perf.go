package main

import (
	"fmt"
)

func PerfStatus() {
	cpu := runShellCommand(`top -bn1 | grep 'Cpu(s)' | awk '{print $2+$4}'`)
	ram := runShellCommand(`free | awk '/Mem/ {printf("%.0f", $3/$2*100)}'`)
	disk := runShellCommand(`df -h / | awk 'NR==2 {print $5}' | tr -d '%'`)

	jsonStr := `{"cpu":"` + cpu + `","ram":"` + ram + `","disk":"` + disk + `"}`
	fmt.Print(jsonStr)
}
