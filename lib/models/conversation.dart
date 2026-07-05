import 'package:flutter_app_skeleton/models/chat_message.dart';

/// Диалог (цепочка сообщений) с ИИ.
class Conversation {
  Conversation({
    required this.id,
    required this.title,
    required this.messages,
    DateTime? updatedAt,
  }) : updatedAt = updatedAt ?? DateTime.now();

  final String id;

  /// Заголовок диалога; выводится в боковом меню.
  String title;

  final List<ChatMessage> messages;

  DateTime updatedAt;

  bool get isEmpty => messages.every((m) => !m.isUser || m.text.trim().isEmpty);
}
