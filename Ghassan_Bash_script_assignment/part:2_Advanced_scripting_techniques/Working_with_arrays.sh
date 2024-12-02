#!/bin/bash

# Script Name: ping_ips.sh
# Author: Ghassan
# Date: 19/10/2024
# Description: This script pings an array of IP addresses and logs whether each IP is reachable or unreachable.
#              The results are saved to a log file with timestamps.

# Array of IP addresses to ping
ip_addresses=("8.8.8.8" "192.168.1.1" "10.0.0.1" "8.8.4.4")

# Log file to store the results
log_file="ping_results_$(date +'%Y-%m-%d_%H-%M-%S').log"

# Function to ping an IP address and log the result
ping_ip() {
    local ip=$1

    # Ping the IP address with 1 packet and a timeout of 2 seconds
    ping -c 1 -W 2 "$ip" > /dev/null 2>&1

    # Check if the ping was successful
    if [ $? -eq 0 ]; then
        echo "$(date): $ip is reachable" | tee -a "$log_file"
    else
        echo "$(date): $ip is unreachable" | tee -a "$log_file"
    fi
}

# Function to validate if the array has IP addresses
validate_ips() {
    if [ ${#ip_addresses[@]} -eq 0 ]; then
        echo "Error: No IP addresses provided in the array."
        exit 1
    fi
}

# Function to check if the log file is writable
check_log_file() {
    touch "$log_file" 2> /dev/null
    if [ $? -ne 0 ]; then
        echo "Error: Unable to create or write to log file: $log_file"
        exit 1
    fi
}

# Main script execution

# Validate if there are any IPs to ping
validate_ips

# Check if the log file can be created or written to
check_log_file

# Starting the ping process
echo "Starting to ping IP addresses..."
echo "Ping results will be saved in: $log_file"
echo "Ping started at: $(date)" | tee -a "$log_file"

# Loop through the array of IP addresses and ping each one
for ip in "${ip_addresses[@]}"; do
    ping_ip "$ip"
done

echo "Ping process completed. Results have been logged to: $log_file"
