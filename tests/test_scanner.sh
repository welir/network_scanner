#!/bin/bash

test_scan_localhost() {
    result=$(./src/network_scanner.sh -p 80,443 -o text)
    assertContains "$result" "80" 
    assertContains "$result" "443"
}

# Загрузка shunit2
source /usr/share/shunit2/shunit2
