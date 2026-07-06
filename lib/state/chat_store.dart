import 'dart:async';

import 'package:flutter/foundation.dart';

import 'package:flutter_app_skeleton/models/chat_message.dart';
import 'package:flutter_app_skeleton/models/conversation.dart';
import 'package:flutter_app_skeleton/services/ai_service.dart';

/// Состояние чата: список диалогов, текущий диалог и процесс генерации ответа.
///
/// Использует [ChangeNotifier]: UI пересобирается через `ListenableBuilder`
/// при любом изменении (новое сообщение, токен стрима, смена диалога).
class ChatStore extends ChangeNotifier {
  ChatStore(this._ai) {
    _conversations.add(_newConversation());
  }

  final AiService _ai;
  final List<Conversation> _conversations = [];
  String? _currentId;
  StreamSubscription<String>? _sub;
  int _counter = 0;

  /// Все диалоги, отсортированные по времени последнего обновления.
  List<Conversation> get conversations =>
      List.unmodifiable(_conversations..sort(_byUpdatedDesc));

  Conversation? get current {
    final id = _currentId;
    if (id == null) return null;
    for (final c in _conversations) {
      if (c.id == id) return c;
    }
    return null;
  }

  /// `true`, пока ИИ генерирует ответ.
  bool get isGenerating => _sub != null;

  static int _byUpdatedDesc(Conversation a, Conversation b) =>
      b.updatedAt.compareTo(a.updatedAt);

  Conversation _newConversation() {
    _counter += 1;
    return Conversation(
      id: 'conv-$_counter',
      title: 'Новый чат',
      messages: const [],
    );
  }

  /// Создаёт пустой диалог и делает его активным.
  void newConversation() {
    stop();
    final c = _newConversation();
    _conversations.insert(0, c);
    _currentId = c.id;
    notifyListeners();
  }

  /// Переключается на существующий диалог.
  void select(String id) {
    if (id == _currentId) return;
    stop();
    _currentId = id;
    notifyListeners();
  }

  /// Удаляет диалог.
  void delete(String id) {
    final index = _conversations.indexWhere((c) => c.id == id);
    if (index == -1) return;
    final wasCurrent = _currentId == id;
    _conversations.removeAt(index);
    if (wasCurrent) {
      _currentId = _conversations.isEmpty ? null : _conversations.first.id;
      if (_conversations.isEmpty) _conversations.add(_newConversation());
      _currentId = _conversations.first.id;
    }
    notifyListeners();
  }

  /// Отправляет сообщение пользователя и запускает стрим ответа ИИ.
  Future<void> send(String raw) async {
    if (isGenerating) return;
    final text = raw.trim();
    if (text.isEmpty) return;

    final conv = current;
    if (conv == null) return;

    conv.messages.add(
      ChatMessage(
        id: '${conv.id}-u${conv.messages.length}',
        role: MessageRole.user,
        text: text,
        timestamp: DateTime.now(),
      ),
    );

    if (conv.title == 'Новый чат') {
      conv.title = text.length > 40 ? '${text.substring(0, 40)}…' : text;
    }
    conv.updatedAt = DateTime.now();
    notifyListeners();

    final assistant = ChatMessage(
      id: '${conv.id}-a${conv.messages.length}',
      role: MessageRole.assistant,
      text: '',
      timestamp: DateTime.now(),
      isStreaming: true,
    );
    conv.messages.add(assistant);
    notifyListeners();

    _sub = _ai
        .send(text)
        .listen(
          (chunk) {
            assistant.text += chunk;
            notifyListeners();
          },
          onDone: () {
            assistant.isStreaming = false;
            assistant.text = assistant.text.trimRight();
            conv.updatedAt = DateTime.now();
            _sub = null;
            notifyListeners();
          },
          cancelOnError: true,
        );
  }

  /// Останавливает текущую генерацию.
  void stop() {
    _sub?.cancel();
    _sub = null;
    final conv = current;
    if (conv != null) {
      for (final m in conv.messages) {
        if (m.isStreaming) {
          m.isStreaming = false;
          if (m.text.trim().isEmpty) m.text = '_Генерация остановлена._';
        }
      }
    }
    notifyListeners();
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }
}
