#!/bin/bash

# current date and time
DATE_TIME=$(date)

# username of the person running the script
USERNAME=$(whoami)

# system information
HOSTNAME=$(hostname)
OS_NAME=$(grep ^NAME= /etc/os-release | cut -d= -f2 | tr -d '"')
OS_VERSION=$(grep ^VERSION= /etc/os-release | cut -d= -f2 | tr -d '"')
UPTIME=$(uptime -p)

# hardware information
CPU=$(lscpu | grep "Model name" | sed 's/Model name:\s*//')
RAM=$(free -h | grep Mem | awk '{print $2}')
DISKS=$(lsblk -d -o NAME,SIZE,MODEL | grep -v "NAME" | awk '{print $2, $3, $4}')
VIDEO=$(lspci | grep -i vga | awk -F ': ' '{print $2}')

# network information
FQDN=$(hostname -f)
IP_ADDRESS=$(ip addr show | grep -A 2 "state UP" | grep inet | awk '{print $2}' | cut -d/ -f1)
GATEWAY_IP=$(ip route | grep default | awk '{print $3}')
DNS_SERVER=$(awk '/nameserver/ {print $2}' /etc/resolv.conf)

# system status information
USERS_LOGGED_IN=$(who | awk '{print $1}' | sort | uniq | paste -sd, -)
DISK_SPACE=$(df -h | grep '^/dev' | awk '{print $1, $4}')
PROCESS_COUNT=$(ps aux | wc -l)
LOAD_AVERAGES=$(uptime | awk -F 'load average: ' '{print $2}')
LISTENING_PORTS=$(ss -tuln | wc -l)
UFW_STATUS=$(sudo ufw status | grep -i "Status" | awk '{print $2}')

#Report generation
echo ""
cat << EOF
System Report generated by $USERNAME, $DATE_TIME

System Information
------------------
Hostname: $HOSTNAME
OS: $OS_NAME $OS_VERSION
Uptime: $UPTIME

Hardware Information
--------------------
CPU: $CPU
RAM: $RAM
Disk(s): 
$DISKS
Video: $VIDEO

Network Information
-------------------
FQDN: $FQDN
Host Address: $IP_ADDRESS
Gateway IP: $GATEWAY_IP
DNS Server: $DNS_SERVER

System Status
-------------
Users Logged In: $USERS_LOGGED_IN
Disk Space: $DISK_SPACE
Process Count: $PROCESS_COUNT
Load Averages: $LOAD_AVERAGES
Listening Network Ports: $LISTENING_PORTS
UFW Status: $UFW_STATUS
EOF
echo ""
