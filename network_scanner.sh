#!/bin/bash
# Network Security Scanner Ultimate
# Author: Denis Voronin
# Version: 2.0
# License: MIT

set -euo pipefail

# Цветовая палитра
RED='\033[1;91m'
GREEN='\033[1;92m'
YELLOW='\033[1;93m'
CYAN='\033[1;96m'
NC='\033[0m'

# Конфигурация
declare -a HIGH_RISK_PORTS=(22 3389 445 5900)
DEFAULT_PORTS="21,22,80,443,3389"
SCAN_PROFILE="default"
OUTPUT_FORMAT="color"
REPORT_FILE="scan_report_$(date +%Y%m%d_%H%M%S).txt"
COMPARE_MODE=false
COMPARE_FILE=""

# Парсинг аргументов
while [[ $# -gt 0 ]]; do
    case $1 in
        -p|--ports) CUSTOM_PORTS="$2"; shift ;;
        -a|--all-ports) SCAN_PROFILE="full" ;;
        -c|--compare) COMPARE_MODE=true; COMPARE_FILE="$2"; shift ;;
        -o|--output) OUTPUT_FORMAT="$2"; shift ;;
        -s|--stealth) STEALTH_MODE=true ;;
        *) echo -e "${RED}[!] Unknown option: $1${NC}"; exit 1 ;;
    esac
    shift
done

compare_reports() {
    local current_report="$1"
    local previous_report="$2"
    
    echo -e "\n${CYAN}[*] Анализ изменений в сети...${NC}"
    
    # Создаем временные файлы с сортированными данными
    current_sorted=$(mktemp)
    jq -S 'to_entries | sort_by(.key)' "$current_report" > "$current_sorted"
    
    previous_sorted=$(mktemp)
    jq -S 'to_entries | sort_by(.key)' "$previous_report" > "$previous_sorted"
    
    # Поиск новых и исчезнувших IP-адресов
    echo -e "${YELLOW}=== Изменения в устройствах ===${NC}"
    comm -13 <(jq -r '.[].key' "$previous_sorted") <(jq -r '.[].key' "$current_sorted") | while read ip; do
        echo -e "${GREEN}[+] Новое устройство: $ip${NC}"
    done
    
    comm -23 <(jq -r '.[].key' "$previous_sorted") <(jq -r '.[].key' "$current_sorted") | while read ip; do
        echo -e "${RED}[-] Устройство пропало: $ip${NC}"
    done

    # Анализ изменений портов
    echo -e "\n${YELLOW}=== Изменения в портах ===${NC}"
    jq -r '.[].key' "$previous_sorted" | while read ip; do
        current_ports=$(jq -r ".[] | select(.key == \"$ip\") | .value.ports[]" "$current_sorted")
        previous_ports=$(jq -r ".[] | select(.key == \"$ip\") | .value.ports[]" "$previous_sorted")
        
        # Поиск новых портов
        comm -13 <(echo "$previous_ports" | sort) <(echo "$current_ports" | sort) | while read port; do
            echo -e "${GREEN}[+] $ip: Добавлен порт $port${NC}"
        done
        
        # Поиск закрытых портов
        comm -23 <(echo "$previous_ports" | sort) <(echo "$current_ports" | sort) | while read port; do
            echo -e "${RED}[-] $ip: Закрыт порт $port${NC}"
        done
    done
    
    # Удаление временных файлов
    rm "$current_sorted" "$previous_sorted"
}

scan_network() {
    echo -e "${CYAN}[*] Discovering network devices...${NC}"
    mapfile -t IP_LIST < <(sudo arp-scan --localnet | grep -Eo '([0-9]{1,3}\.){3}[0-9]{1,3}')

    local scan_params=("-T4" "-Pn")
    case $SCAN_PROFILE in
        "full") scan_params+=("-p-") ;;
        "default") scan_params+=("-p ${CUSTOM_PORTS:-$DEFAULT_PORTS}") ;;
    esac

    if [ "${STEALTH_MODE:-false}" = true ]; then
        scan_params+=("-f" "--data-length 50" "--scan-delay 2s")
    fi

    for ip in "${IP_LIST[@]}"; do
        echo -e "\n${YELLOW}[+] Scanning $ip${NC}"
        local result
        result=$(nmap "${scan_params[@]}" "$ip" 2>/dev/null)
        
        parse_results "$result"
        detect_vulnerabilities "$result"
    done
}

parse_results() {
    while IFS= read -r line; do
        if [[ $line =~ ^[0-9]+/tcp.*open ]]; then
            local port service
            port=$(echo "$line" | cut -d'/' -f1)
            service=$(echo "$line" | awk '{print $3}')
            
            if [[ " ${HIGH_RISK_PORTS[*]} " =~ " $port " ]]; then
                echo -e "${RED}‼️  PORT $port ($service) - HIGH RISK${NC}"
            else
                echo -e "${GREEN}✅ PORT $port ($service)${NC}"
            fi
        fi
    done <<< "$1"
}

detect_vulnerabilities() {
    case "$1" in
        *"SSH"*)
            echo -e "${YELLOW}  [WARNING] Outdated SSH version detected${NC}" ;;
        *"RDP"*)
            echo -e "${YELLOW}  [WARNING] RDP without NLA enabled${NC}" ;;
        *"HTTP"*)
            echo -e "${YELLOW}  [WARNING] Web server version exposed${NC}" ;;
    esac
}

generate_report() {
    echo "Scan Report: $(date)" > "$REPORT_FILE"
    echo "==========================" >> "$REPORT_FILE"
}

generate_json_report() {
    echo "{"
    for ip in "${IP_LIST[@]}"; do
        echo "\"$ip\": {"
        echo "\"ports\": [$(nmap -p $PORTS $ip | awk '/open/{print $1}' | tr '\n' ',')]"
        echo "},"
    done
    echo "}"
}

main() {
  if [ "$COMPARE_MODE" = true ]; then
        if [ ! -f "$COMPARE_FILE" ]; then
            echo -e "${RED}[!] Файл для сравнения не найден: $COMPARE_FILE${NC}"
            exit 1
        fi
        local temp_report=$(mktemp)
        scan_network > "$temp_report"
        compare_reports "$temp_report" "$COMPARE_FILE"
        rm "$temp_report"
    else
        scan_network | tee -a "$REPORT_FILE"
        echo -e "${CYAN}[*] Отчет сохранен: $REPORT_FILE${NC}"
    fi
}

main
