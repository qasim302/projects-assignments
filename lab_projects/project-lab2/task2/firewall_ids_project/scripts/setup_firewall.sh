#!/bin/bash

# Setup firewall rules using iptables

# Allow loopback traffic
sudo iptables -A INPUT -i lo -j ACCEPT

# Allow HTTP and HTTPS
sudo iptables -A INPUT -p tcp --dport 80 -j ACCEPT
sudo iptables -A INPUT -p tcp --dport 443 -j ACCEPT

# Allow SSH access from specific IP
sudo iptables -A INPUT -s <source_ip> -p tcp --dport 22 -j ACCEPT

# Set default policy to DROP
sudo iptables -P INPUT DROP

# Save rules
sudo /sbin/iptables-save > /etc/iptables/rules.v4

echo "Firewall setup completed!"
