#!/bin/bash

# Install Snort
sudo apt-get install snort -y

# Prompt to configure Snort
echo "Please configure Snort rules in /etc/snort/snort.conf"

# Start Snort
echo "Starting Snort..."
sudo snort -A console -c /etc/snort/snort.conf -i <interface>

echo "Snort setup completed!"
