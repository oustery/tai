/// Роль отправителя сообщения.
enum MessageRole { user, assistant }

/// Одно сообщение в чате (от пользователя или от ИИ).
class ChatMessage {
  ChatMessage({
    required this.id,
    required this.role,
    required this.text,
    required this.timestamp,
    this.isStreaming = false,
  });

  final String id;
  final MessageRole role;

  /// Текст сообщения. Не `final`, т.к. при стриминге ответа ИИ
  /// содержимое дополняется токенами в реальном времени.
  String text;

  final DateTime timestamp;

  /// `true`, пока ИИ «печатает» ответ (стриминг ещё идёт).
  bool isStreaming;

  bool get isUser => role == MessageRole.user;
}
