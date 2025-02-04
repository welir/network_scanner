#!/bin/bash

# Установка зависимостей
if [ -f /etc/debian_version ]; then
    sudo apt update
    sudo apt install -y nmap arp-scan
elif [ -f /etc/redhat-release ]; then
    sudo dnf install -y nmap arp-scan
fi

# Копирование скрипта
sudo cp src/network_scanner.sh /usr/local/bin/network-scanner
sudo chmod +x /usr/local/bin/network-scanner
