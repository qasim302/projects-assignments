#!/bin/bash

# Script Name: network_scan.sh
# Author: Ghassan
# Date: 18/10/2024
# Description: This script scans a target network segment using Nmap, identifies open ports,
#              and saves the results in CSV or JSON format based on the user's choice.

# Function to scan the network and save results in CSV format
function scan_to_csv() {
    local target_range=$1
    local output_file=$2

    echo "Scanning $target_range for open ports and saving results to $output_file (CSV format)..."

    # Run Nmap scan and save results in XML format for easier parsing
    nmap -oX scan_results.xml -p- "$target_range" 2>/dev/null

    # Check if Nmap scan was successful
    if [ $? -ne 0 ]; then
        echo "Error: Nmap scan failed. Please check the network range and try again."
        exit 1
    fi

    # Extract relevant data (IP, open ports) from the XML file and save it in CSV format
    echo "IP,Port,Service" > "$output_file"
    grep -E '<address|port protocol' scan_results.xml | \
    awk 'BEGIN { ip="" } 
        /<address addr=/ { ip=$2 } 
        /<port protocol=/ { port=$2; service=$6; gsub(/addr=|["\/>]/, "", ip); gsub(/portid=|["\/>]/, "", port); gsub(/name=|["\/>]/, "", service); print ip","port","service }' >> "$output_file"

    echo "Scan complete. Results saved to $output_file."
}

# Function to scan the network and save results in JSON format
function scan_to_json() {
    local target_range=$1
    local output_file=$2

    echo "Scanning $target_range for open ports and saving results to $output_file (JSON format)..."

    # Run Nmap scan and save results in XML format for easier parsing
    nmap -oX scan_results.xml -p- "$target_range" 2>/dev/null

    # Check if Nmap scan was successful
    if [ $? -ne 0 ]; then
        echo "Error: Nmap scan failed. Please check the network range and try again."
        exit 1
    fi

    # Extract relevant data (IP, open ports) from the XML file and save it in JSON format
    echo "[" > "$output_file"
    grep -E '<address|port protocol' scan_results.xml | \
    awk 'BEGIN { ip=""; first=1 }
        /<address addr=/ { if (ip != "") print "]}, "; ip=$2; first=1; gsub(/addr=|["\/>]/, "", ip); print "{ \"IP\": \"" ip "\", \"Ports\": [" }
        /<port protocol=/ { port=$2; service=$6; gsub(/portid=|["\/>]/, "", port); gsub(/name=|["\/>]/, "", service); if (!first) print ","; first=0; print "{ \"Port\": \"" port "\", \"Service\": \"" service "\" }" }
        END { print "]}" }' >> "$output_file"
    echo "]" >> "$output_file"

    echo "Scan complete. Results saved to $output_file."
}

# Main script logic

# Welcome message and network range input
echo "Welcome to the Network Scanner!"
read -p "Enter the target network range (e.g., 192.168.1.0/24): " target_range

# Validate the network range input (basic check for proper format)
if ! [[ "$target_range" =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+/[0-9]+$ ]]; then
    echo "Error: Invalid network range format. Please use a format like 192.168.1.0/24."
    exit 1
fi

# Output format selection and validation
read -p "Choose the output format (csv or json): " format
format=$(echo "$format" | tr '[:upper:]' '[:lower:]')  # Convert input to lowercase for consistency

# Set the output file based on the chosen format
if [ "$format" == "csv" ]; then
    output_file="scan_results.csv"
    scan_to_csv "$target_range" "$output_file"
elif [ "$format" == "json" ]; then
    output_file="scan_results.json"
    scan_to_json "$target_range" "$output_file"
else
    echo "Error: Invalid format specified. Please choose either 'csv' or 'json'."
    exit 1
fi

echo "Network scan completed and saved to $output_file."
