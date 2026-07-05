#!/usr/bin/env bash
#
# Инициализация платформенных папок Flutter.
# Запускать один раз после клонирования репозитория:
#
#   ./setup.sh
#
set -euo pipefail

if ! command -v flutter >/dev/null 2>&1; then
  echo "❌ Flutter не найден в PATH. Установите: https://docs.flutter.dev/get-started/install"
  exit 1
fi

echo "▸ Генерируем платформенные папки (android, ios, web, ...)"
flutter create . \
  --org com.example \
  --project-name flutter_app_skeleton \
  --platforms=android,ios,web,linux,macos,windows

echo "▸ Загружаем зависимости"
flutter pub get

echo "▸ Проверяем"
flutter analyze

echo "✅ Готово. Запуск: flutter run"
