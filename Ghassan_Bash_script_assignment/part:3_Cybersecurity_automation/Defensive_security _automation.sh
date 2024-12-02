#!/bin/bash

# Script Name: log_monitor_enhanced.sh
# Author: ghassan
# Date: 18/10/2024
# Description: This script monitors a specified log file for suspicious activity
#              by searching for keywords like "failed login", "error", or "unauthorized access".
#              If any of the keywords are detected, it sends an alert via email or logs the incident
#              to a file. The script includes error handling and user input validation.

# Email settings (customize these values)
ALERT_EMAIL="admin@example.com"  # Replace with your actual email address
EMAIL_SUBJECT="Security Alert: Suspicious Activity Detected in Log File"

# Log file to record alerts (optional)
ALERT_LOG="alerts.log"

# Keywords to monitor
keywords=("failed login" "error" "unauthorized access")

# Function to send email alert
send_email_alert() {
    local message=$1
    echo "$message" | mail -s "$EMAIL_SUBJECT" "$ALERT_EMAIL"
}

# Function to log alert to file
log_alert_to_file() {
    local message=$1
    echo "$(date): $message" >> "$ALERT_LOG"
}

# Function to validate if the log file exists and is readable
validate_log_file() {
    if [ ! -f "$1" ]; then
        echo "Error: Log file '$1' not found."
        exit 1
    elif [ ! -r "$1" ]; then
        echo "Error: Log file '$1' is not readable. Check permissions."
        exit 1
    fi
}

# Function to monitor log file for suspicious activity
monitor_log_file() {
    local log_file=$1
    echo "Monitoring log file: $log_file for suspicious activity..."
    echo "Keywords being monitored: ${keywords[*]}"

    # Start monitoring the log file with tail and search for keywords
    tail -f "$log_file" | while read -r line; do
        for keyword in "${keywords[@]}"; do
            if echo "$line" | grep -iq "$keyword"; then
                # Suspicious activity detected
                alert_message="Suspicious activity detected: '$line' (keyword: '$keyword')"

                # Send email alert and log it to a file
                send_email_alert "$alert_message"
                log_alert_to_file "$alert_message"

                # Output the alert to the terminal
                echo "$alert_message"
            fi
        done
    done
}

# Main script logic with error handling and user input validation

# Prompt the user to enter the log file to monitor
read -p "Enter the path to the log file you want to monitor (e.g., /var/log/auth.log): " log_file

# Validate the log file (check if it exists and is readable)
validate_log_file "$log_file"

# Check if the mail command is installed
if ! command -v mail &> /dev/null; then
    echo "Error: The 'mail' command is not installed. Install it using 'sudo apt install mailutils' (for Debian/Ubuntu)."
    exit 1
fi

# Check if the alert log file is writable (or create it if it doesn't exist)
if [ ! -w "$ALERT_LOG" ]; then
    echo "Creating alert log file: $ALERT_LOG"
    touch "$ALERT_LOG"
    if [ $? -ne 0 ]; then
        echo "Error: Unable to create or write to alert log file '$ALERT_LOG'. Check permissions."
        exit 1
    fi
fi

# Start monitoring the log file
monitor_log_file "$log_file"
