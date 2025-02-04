#!/bin/bash

testLocalhostScan() {
    result=$(./network_scanner.sh -p 80 -o text)
    assertContains "$result" "80/tcp"
}
# Загрузка shunit2
source /usr/share/shunit2/shunit2
