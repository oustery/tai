# tai

> **Tai** — приложение для общения и взаимодействием с ИИ. Чистый современный интерфейс в стиле Material You 3 Expressive.

![platform](https://img.shields.io/badge/platform-android-3DDC84)
![flutter](https://img.shields.io/badge/flutter-3.x-02569B)
![license](https://img.shields.io/badge/license-MIT-blue)

## ✨ Возможности

- 💬 **Чат с ИИ** — потоковая генерация ответа с эффектом «печатания».
- 🗂 **Несколько диалогов** — создание, переключение и удаление чатов в боковом меню.
- 🎨 **Material You 3 Expressive** — динамическая цветовая схема (seed), большие скругления, светлые/тёмные темы.
- 📝 **Markdown** — ответы ИИ рендерятся с заголовками, списками и блоками кода.
- 💡 **Подсказки** — быстрый старт диалога одним тапом.
- 🌗 **Переключение темы** — светлая / тёмная / системная.

## 🏗 Архитектура

```
lib/
├── main.dart                      # точка входа
├── app.dart                       # MaterialApp, тема, переключатель тем
├── theme/app_theme.dart           # Material 3 Expressive тема (seed-based)
├── models/
│   ├── chat_message.dart          # модель сообщения
│   └── conversation.dart          # модель диалога
├── services/
│   └── ai_service.dart            # контракт ИИ + MockAiService (стриминг)
├── state/
│   └── chat_store.dart            # состояние чата (ChangeNotifier)
├── screens/
│   └── home_screen.dart           # главный экран
└── widgets/
    ├── tai_logo.dart              # фирменный «огонёк»
    ├── message_bubble.dart        # бабл сообщения (+ Markdown)
    ├── message_list_view.dart     # список сообщений
    ├── chat_composer.dart         # поле ввода + кнопка отправки
    ├── typing_indicator.dart      # анимация «печатает…»
    ├── suggestion_chips.dart      # подсказки-промпты
    ├── welcome_state.dart         # приветственный экран
    └── conversations_drawer.dart  # боковое меню диалогов
```

### Подключение реального ИИ

Сейчас используется `MockAiService` — он подбирает ответ по ключевым словам.
Чтобы подключить настоящую модель (OpenAI, Anthropic, Gemini, локальную LLM),
реализуй интерфейс `AiService`:

```dart
class OpenAiService implements AiService {
  @override
  Stream<String> send(String prompt) async* {
    // HTTP-запрос с потоковым парсингом SSE…
    yield token;
  }
}
```

и передай его в `TaiApp` (поля `aiService`). UI менять не нужно.

## 🚀 Быстрый старт

```bash
# 1. Установить Flutter: https://docs.flutter.dev/get-started/install
# 2. Сгенерировать платформенные папки (android/ и т.д.)
flutter create . --org com.example --project-name flutter_app_skeleton \
  --platforms=android
#   или просто: ./setup.sh

flutter pub get
flutter run
```

Сборка:

```bash
flutter build apk --debug
flutter build apk --release
flutter build appbundle --release
```

## 🤖 CI/CD (GitHub Actions)

В `.github/workflows/`:

| Воркфлоу | Триггер | Что делает |
|---|---|---|
| `build-debug.yml` | push/PR в `main` | format + analyze + test + **debug APK** |
| `build-release.yml` | тег `v*` / вручную | **release APK** + **AAB** + GitHub Release |

> Платформенные папки генерируются на раннере шагом `flutter create . --platforms=android`.

## 🔐 Безопасность

Ключи API **никогда** не должны попадать в репозиторий. Для реального ИИ
используй `--dart-define` или секреты GitHub Actions.

---

MIT License
