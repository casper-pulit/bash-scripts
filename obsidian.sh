#! /usr/bin/bash
vault_dir=/home/casper/Documents/vault


# Function to run before the program starts
before_program() {
    echo "Starting Obisidian Hook"
    echo "Checking for updates on github repository"
    cd $vault_dir
    git pull
}

# Function to run after the program ends
after_program() {
    end_time=$(date)
    git add $vault_dir/.
    git status
    git commit -m "Updated at $end_time"
    git push
}

# Main function to run the program and detect its termination
run_program() {
    before_program

    # Run the program in the background
    obsidian &
    local program_pid=$!

    # Wait for the program to finish
    wait $program_pid

    after_program
}

# Run the main function
run_program