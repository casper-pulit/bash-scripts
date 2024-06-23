package main

import (
	"fmt"
	"os"
	"os/exec"
	"time"

	"github.com/mitchellh/go-ps"
)

var vaultDir = "C:\\Users\\caspe\\Documents\\vault"
var obsidianPath = "C:\\Users\\caspe\\AppData\\Local\\Programs\\obsidian\\Obsidian.exe"

func beforeProgram() {
	fmt.Println("Starting Obsidian Hook")
	fmt.Println("Checking for updates on GitHub repository")
	os.Chdir(vaultDir)
	cmd := exec.Command("git", "pull")
	cmd.Stdout = os.Stdout
	cmd.Stderr = os.Stderr
	err := cmd.Run()
	if err != nil {
		fmt.Println("Error pulling from GitHub:", err)
	}
}

func afterProgram() {
	fmt.Println("Obsidian Closed")
	fmt.Println("Evaluating changes and pushing to repository.")
	endTime := time.Now().Format("2006-01-02 15:04:05")
	fmt.Println(endTime)
	exec.Command("git", "add", ".").Run()
	exec.Command("git", "status").Run()
	exec.Command("git", "commit", "-m", fmt.Sprintf("Updated at %s", endTime)).Run()
	exec.Command("git", "push").Run()
}

func runProgram() {
	beforeProgram()

	// Start the Obsidian application
	cmd := exec.Command(obsidianPath)
	err := cmd.Start()
	if err != nil {
		fmt.Println("Error starting Obsidian:", err)
		return
	}
	pid := cmd.Process.Pid

	// Wait for the Obsidian application to close
	for {
		time.Sleep(1 * time.Second)
		process, err := ps.FindProcess(pid)
		if err != nil || process == nil {
			break
		}
	}

	afterProgram()
	time.Sleep(5 * time.Second)
}

func main() {
	runProgram()
}
