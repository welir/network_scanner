# 🌐 Network Port Scanner + Delta Detective 
**Умный сканер локальной сети с детектором изменений портов**  
[![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)](https://opensource.org/licenses/MIT)  
_Проверяйте открытые порты и мгновенно находите изменения в сети!_
 [![Stars](https://img.shields.io/github/stars/welir/network_scanner?style=social)]([https://github.com/welir/network-scanner](https://github.com/welir/network_scanner))

Универсальный инструмент для аудита локальных сетей с AI-powered анализом угроз.

➡️ **Главные фичи**:
- Режим Стелс (Avoid IDS Detection)
- Автоматическая классификация устройств (IoT/PC/Server)
- Генератор рекомендаций по безопасности

[Демо](https://welir.github.io/network-scanner) | [Документация](docs/getting_started.md)

---

## ✨ Уникальная фишка: **Delta Detective**
Сравнивайте результаты сканирования с предыдущими отчетами и находите:  
✅ Новые открытые порты  
⛔ Исчезнувшие сервисы  
🔍 Изменения в конфигурации устройств  

## ✨ Новая фишка: **Security Alert**
- 🔥 **Яркая подсветка опасных портов** (красный/жёлтый)  
- 🛡️ **Проверка на известные CVE-уязвимости** для SSH, RDP, HTTP  
- 📛 **Предупреждения в реальном времени** о рисках безопасности  
---

## 🎨 Выделение портов
| Состояние          | Цвет          | Пример               |
|--------------------|---------------|----------------------|
| Открытый (опасный) | 🔴 Красный     | `22 (SSH)`           |
| Открытый (нейтральный)| 🟡 Жёлтый  | `80 (HTTP)`          |
| Закрытый           | ⚪ Белый       | `443 (HTTPS)`        |

## 📦 Установка
```bash
git clone https://github.com/welir/network_scanner.git
cd network_scanner
chmod +x network_scanner.sh
```

### Автоматическая установка (опционально)
```bash
sudo ./setup.sh  # Скопирует скрипт в /usr/local/bin
```

Зависимости:

```bash
sudo apt install nmap arp-scan jq# Debian/Ubuntu

sudo dnf install nmap arp-scan jq# Fedora/CentOS
```
---

🚀 Использование

# Стандартное сканирование (порты 22,80,443
`sudo ./network_scanner.sh`

# Полная проверка в стелс-режиме
`sudo ./network_scanner.sh --all-ports --stealth`

# Проверка кастомных портов
`sudo ./network_scanner.sh --ports 80,443,8080`

# Сравнение с предыдущим сканированием:
```
./network_scanner.sh --compare last_scan.json
```

Параметры:

```
  -p, --ports <список>     Сканировать конкретные порты (например, 22,80)
  -f, --full               Сканировать все 65535 портов
  -c, --compare <файл>     Сравнить с предыдущим отчетом
  -o, --output <формат>    Формат вывода (json/text) [по умолчанию: text]
  -h, --help               Показать справку
```
---

🌟 Особенности
  * Автообнаружение устройств в локальной сети через ARP
  
  * Цветной ASCII-вывод с интерактивной статистикой
  
  * Экспорт результатов в JSON/Text/CSV
  
  * Определение ОС и версий сервисов (Nmap Scripting Engine)
  
  * Дельта-анализ изменений между сканированиями
  
  * Фильтрация результатов по портам/состоянию/устройствам
---

🕵️ Пример детектора изменений
```text
[DELTA REPORT] Сравнение с scan_20231025.json

+ 192.168.1.42: 
  🆕 Порт 8080 открыт (HTTP-прокси)
  🔄 Порт 22: версия SSH изменилась (OpenSSH 8.1 → 8.4)

- 192.168.1.15: 
  ❌ Порт 3389 закрыт (был RDP)
```

Пример для Docker (если нужно изолированное окружение):
```docker
docker run --rm -it --net=host ubuntu:latest bash -c "
  apt update && apt install -y git nmap arp-scan && 
  git clone https://github.com/yourusername/network-scanner.git && 
  cd network_scanner && 
  ./network_scanner.sh
"
```

---

📂 Структура проекта
```
network-scanner/
├── .github/
│   └── workflows/
│       └── ci.yml          # GitHub Actions для тестов
├── docs/
│   ├── getting_started.md  # Руководство
│   └── faq.md              # Частые вопросы
├── examples/
│   ├── scan_report.txt     # Пример отчёта
│   └── delta_diff.json     # Пример сравнения
│── network_scanner.sh  # Основной скрипт
├── tests/
│   └── test_scanner.sh     # Юнит-тесты
├── .gitignore              # Игнорируемые файлы
├── LICENSE                 # Лицензия MIT
├── README.md               # Документация
├── CONTRIBUTING.md         # Правила контрибуции
├── CHANGELOG.md            # История изменений
├── requirements.txt        # Зависимости
└── setup.sh                # Установщик
```

📜 Лицензия
MIT License © 2023 welir
Подробнее
