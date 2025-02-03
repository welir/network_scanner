#!/bin/bash

# Network Port Scanner
# Author: Denis Voronin
# Version: 1.1
# License: MIT

# Цвета для вывода
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Параметры по умолчанию
PORTS="22,80,443,3389"
SCAN_ALL_PORTS=false
OUTPUT_FORMAT="text"
OUTPUT_FILE=""

# Парсинг аргументов
while [[ "$#" -gt 0 ]]; do
    case $1 in
        -p|--ports) PORTS="$2"; shift ;;
        -a|--all-ports) SCAN_ALL_PORTS=true ;;
        -f|--format) OUTPUT_FORMAT="$2"; shift ;;
        -o|--output) OUTPUT_FILE="$2"; shift ;;
        *) echo "Неизвестный параметр: $1"; exit 1 ;;
    esac
    shift
done

# Проверка nmap
if ! command -v nmap &> /dev/null; then
    echo -e "${RED}Ошибка: nmap не установлен.${NC}"
    echo "Установите:"
    echo "  Debian/Ubuntu: sudo apt install nmap"
    echo "  Fedora/CentOS: sudo dnf install nmap"
    exit 1
fi

# Автоматическое получение IP-адресов
IP_LIST=($(arp -a | grep -Eo '([0-9]{1,3}\.){3}[0-9]{1,3}' | sort -u))

# Настройки сканирования
if [ "$SCAN_ALL_PORTS" = true ]; then
    SCAN_PARAMS="-p-"
    echo -e "${YELLOW}[!] Сканирование всех портов (1-65535)...${NC}"
else
    SCAN_PARAMS="-p $PORTS"
    echo -e "${YELLOW}[!] Сканирование портов: $PORTS...${NC}"
fi

# Функция сканирования
scan_ip() {
    local ip=$1
    local result
    
    if ping -c 1 -W 1 "$ip" &> /dev/null; then
        result=$(nmap -T4 -Pn $SCAN_PARAMS "$ip" 2>/dev/null | awk '/^PORT/{flag=1} flag && /^[0-9]/{print $1,$2,$3}')
        
        if [ -z "$result" ]; then
            echo -e "${RED}  Нет открытых портов${NC}"
        else
            echo "$result" | while read -r line; do
                port=$(echo "$line" | cut -d'/' -f1)
                state=$(echo "$line" | awk '{print $2}')
                service=$(echo "$line" | awk '{print $3}')
                echo -e "${GREEN}  Порт $port: $state ($service)${NC}"
            done
        fi
    else
        echo -e "${RED}  Устройство недоступно${NC}"
    fi
}

# Запуск сканирования
{
    echo -e "${YELLOW}[*] Начало сканирования...${NC}"
    for ip in "${IP_LIST[@]}"; do
        echo -e "\n${YELLOW}[+] Проверка $ip:${NC}"
        scan_ip "$ip"
    done
    echo -e "${YELLOW}[*] Сканирование завершено.${NC}"
} | if [ -n "$OUTPUT_FILE" ]; then
    tee "$OUTPUT_FILE"
else
    cat
fi
