#!/bin/bash

# Script Name: backup_script.sh
# Author: Ghassan
# Date: 18/10/2024
# Description: This script takes a directory as input and creates a timestamped backup of it.
#              It checks if the directory exists, creates a backup directory if necessary, handles errors, and provides user feedback.

# Function to check if a directory exists
check_directory() {
    if [ ! -d "$1" ]; then
        echo "Error: The directory '$1' does not exist. Please provide a valid directory."
        exit 1
    fi
}

# Function to create the backup directory if it doesn't exist
create_backup_dir() {
    if [ ! -d "$1" ]; then
        mkdir -p "$1"
        echo "Backup directory created at: $1"
    fi
}

# Prompt the user to enter the name of the directory for backup
echo "Please enter the full path of the directory you want to back up:"
read -r dir_to_backup

# Validate user input: check if the input is empty
if [ -z "$dir_to_backup" ]; then
    echo "Error: You must enter a directory path."
    exit 1
fi

# Check if the specified directory exists
check_directory "$dir_to_backup"

# Define the backup directory
backup_dir="$HOME/backups"

# Create the backup directory if it doesn't exist
create_backup_dir "$backup_dir"

# Get the current date and time for timestamping the backup file
timestamp=$(date +'%Y-%m-%d_%H-%M-%S')

# Create the backup file with a timestamp
backup_file="$backup_dir/backup_$(basename "$dir_to_backup")_$timestamp.tar.gz"

# Archive the directory
echo "Creating a backup of '$dir_to_backup'..."
tar -czf "$backup_file" -C "$dir_to_backup" .

# Check if the tar command was successful
if [ $? -eq 0 ]; then
    echo "Backup completed successfully! The backup file is located at: $backup_file"
else
    echo "Error: There was an issue creating the backup."
    exit 1
fi
