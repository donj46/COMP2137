#!/bin/bash
# This script updates the operating system

echo "Updating system..."
sudo apt update -y && sudo apt upgrade -y
echo "System update complete."
