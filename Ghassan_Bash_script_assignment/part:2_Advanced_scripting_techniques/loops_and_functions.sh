#!/bin/bash

# Script Name: services_monitor.sh
# Author: Ghassan
# Date: 19/10/2024
# Description: This script checks if certain services (Apache, MySQL, SSH) are running.
#              If a service is not active, it attempts to restart the service and logs the actions
#              into a log file for monitoring purposes.

# List of services to monitor
services=("apache2" "mysql" "ssh")

# Log file to store the service status and actions
log_file="/var/log/services_monitor.log"

# Function to check the status of a service and restart it if it's not active
check_and_restart_service() {
    local service=$1

    # Check if the service is active
    service_status=$(systemctl is-active "$service")

    if [ "$service_status" != "active" ]; then
        echo "$(date): $service is not running. Attempting to restart..." | tee -a "$log_file"
        
        # Try to restart the service
        systemctl restart "$service"

        # Check if the restart was successful
        if [ $? -eq 0 ]; then
            echo "$(date): Successfully restarted $service." | tee -a "$log_file"
        else
            echo "$(date): Failed to restart $service." | tee -a "$log_file"
        fi
    else
        echo "$(date): $service is running normally." | tee -a "$log_file"
    fi
}

# Check if the script has permission to write to the log file
if [ ! -w "$log_file" ]; then
    echo "Error: Cannot write to log file $log_file. Please check permissions."
    exit 1
fi

# Main loop to iterate over the list of services and check their statuses
for service in "${services[@]}"; do
    check_and_restart_service "$service"
done

echo "Service monitoring completed. Logs saved in $log_file."
