# tai

> Каркас Flutter-приложения с настроенными GitHub Actions (debug/release сборки).


Минимальный каркас Flutter-приложения с настроенными GitHub Actions для сборки **debug** и **release** версий под Android.

## Структура проекта

```
flutter_app_skeleton/
├── .github/
│   └── workflows/
│       ├── build-debug.yml      # Сборка debug APK (+ проверка кода/тесты)
│       └── build-release.yml    # Сборка release APK и AAB (+ GitHub Release)
├── lib/
│   └── main.dart                # Пустое приложение (костяк)
├── analysis_options.yaml        # Правила линтера
├── pubspec.yaml                 # Зависимости и метаданные
└── README.md
```

> ⚠️ В репозитории намеренно **отсутствуют** платформенные папки (`android/`, `ios/`, `web/`, `linux/`, `macos/`, `windows/`, `test/`). Они генерируются автоматически на шаге инициализации ниже (см. `.gitignore` — они не теряются, просто не хранятся здесь вручную).

## Быстрый старт

### 1. Установите Flutter
Инструкция: https://docs.flutter.dev/get-started/install

### 2. Инициализируйте платформенные папки

```bash
cd flutter_app_skeleton
flutter create . --org com.example --project-name flutter_app_skeleton
flutter pub get
```

Команда `flutter create .` создаст недостающие платформенные папки, не трогая ваши `pubspec.yaml`, `main.dart` и воркфлоусы.

### 3. Запуск локально

```bash
flutter run              # debug-режим на подключённом устройстве/эмуляторе
flutter build apk --debug
flutter build apk --release
flutter build appbundle --release
```

## CI/CD (GitHub Actions)

Воркфлоусы находятся в `.github/workflows/`.

### `build-debug.yml`
- **Триггеры:** push/PR в `main` или `develop`, ручной запуск.
- **Шаги:** установка Java 17 + Flutter (stable), `pub get`, проверка форматирования (`dart format`), `flutter analyze`, тесты, сборка debug APK.
- **Артефакт:** `app-debug-apk` (хранение 14 дней).

### `build-release.yml`
- **Триггеры:** push тега `v*` (например `v0.1.0`), ручной запуск.
- **Шаги:** сборка release APK + App Bundle (AAB для Google Play).
- **Артефакты:** `app-release-apk`, `app-release-aab` (хранение 30 дней).
- **GitHub Release:** автоматически создаётся при пуше тега `v*` с приложенными APK и AAB.

### Запуск release-сборки вручную

```bash
git tag v0.1.0
git push origin v0.1.0
```

или через вкладку **Actions → Build Release → Run workflow** в репозитории.

## Требования к окружению CI
- Java 17 (Temurin)
- Flutter stable (>= 3.22)
- Runner: `ubuntu-latest`

---

Чистый стартовый шаблон — добавляйте фичи, виджеты и зависимости по мере развития проекта.
