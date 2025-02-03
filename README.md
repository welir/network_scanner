# 🌐 Network Port Scanner + Delta Detective 
**Умный сканер локальной сети с детектором изменений портов**  
[![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)](https://opensource.org/licenses/MIT)  
_Проверяйте открытые порты и мгновенно находите изменения в сети!_

---

## ✨ Уникальная фишка: **Delta Detective**
Сравнивайте результаты сканирования с предыдущими отчетами и находите:  
✅ Новые открытые порты  
⛔ Исчезнувшие сервисы  
🔍 Изменения в конфигурации устройств  

---

## 📦 Установка
```bash
git clone https://github.com/yourusername/network-scanner.git
cd network-scanner
chmod +x scanner.sh
```
Зависимости:

```bash
sudo apt install nmap arp-scan # Debian/Ubuntu
sudo dnf install nmap arp-scan # Fedora/CentOS
```

🚀 Использование
Базовое сканирование (порты 22,80,443):

```bash
./scanner.sh
```
Полное сканирование (все порты 1-65535):
```bash
./scanner.sh --full
```

Сравнение с предыдущим сканированием:
```
./scanner.sh --compare last_scan.json
```

Параметры:

```
  -p, --ports <список>     Сканировать конкретные порты (например, 22,80)
  -f, --full               Сканировать все 65535 портов
  -c, --compare <файл>     Сравнить с предыдущим отчетом
  -o, --output <формат>    Формат вывода (json/text) [по умолчанию: text]
  -h, --help               Показать справку
```

🌟 Особенности
  * Автообнаружение устройств в локальной сети через ARP
  
  * Цветной ASCII-вывод с интерактивной статистикой
  
  * Экспорт результатов в JSON/Text/CSV
  
  * Определение ОС и версий сервисов (Nmap Scripting Engine)
  
  * Дельта-анализ изменений между сканированиями
  
  * Фильтрация результатов по портам/состоянию/устройствам

🕵️ Пример детектора изменений
```text
[DELTA REPORT] Сравнение с scan_20231025.json

+ 192.168.1.42: 
  🆕 Порт 8080 открыт (HTTP-прокси)
  🔄 Порт 22: версия SSH изменилась (OpenSSH 8.1 → 8.4)

- 192.168.1.15: 
  ❌ Порт 3389 закрыт (был RDP)
```
📂 Структура проекта
```
network-scanner/
├── scanner.sh          # Основной скрипт
├── reports/            # Архив отчетов
├── comparer.py         # Модуль сравнения
├── LICENSE
└── README.md
```

📜 Лицензия
MIT License © 2023 welir
Подробнее
