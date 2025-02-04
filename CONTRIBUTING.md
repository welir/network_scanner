# Как участвовать в разработке

1. Форкните репозиторий
2. Создайте ветку: `git checkout -b feature/NewFeature`
3. Проверьте код через `shellcheck src/network_scanner.sh`
4. Добавьте тесты для новой функциональности
5. Запушьте изменения: `git push origin feature/NewFeature`
6. Создайте Pull Request с описанием изменений

⚠️ Перед отправкой PR:
- Убедитесь, что тесты проходят
- Обновите CHANGELOG.md
- Проверьте стиль кода
