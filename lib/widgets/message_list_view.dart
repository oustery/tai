import 'package:flutter/material.dart';

import 'package:flutter_app_skeleton/models/chat_message.dart';
import 'package:flutter_app_skeleton/widgets/message_bubble.dart';
import 'package:flutter_app_skeleton/widgets/typing_indicator.dart';

/// Прокручиваемый список сообщений текущего диалога.
///
/// [ClipRect] предотвращает выход анимаций выхода за границы списка.
class MessageListView extends StatelessWidget {
  const MessageListView({
    super.key,
    required this.messages,
    required this.controller,
  });

  final List<ChatMessage> messages;
  final ScrollController controller;

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: ListView.builder(
        controller: controller,
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
        itemCount: messages.length,
        clipBehavior: Clip.none,
        itemBuilder: (context, index) {
          final m = messages[index];
          // Пока ответ ИИ пуст и стримится — показываем анимацию печатания.
          if (!m.isUser && m.isStreaming && m.text.trim().isEmpty) {
            return const TypingIndicator();
          }
          return MessageBubble(message: m);
        },
      ),
    );
  }
}
