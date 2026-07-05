import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

import 'package:flutter_app_skeleton/models/chat_message.dart';
import 'package:flutter_app_skeleton/widgets/tai_logo.dart';

/// Один бабл сообщения — пользователя (справа) или ИИ (слева).
class MessageBubble extends StatelessWidget {
  const MessageBubble({super.key, required this.message});

  final ChatMessage message;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final isUser = message.isUser;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment:
            isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isUser) ...[
            const TaiLogo(size: 30),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.sizeOf(context).width * 0.78,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: isUser
                    ? scheme.primaryContainer
                    : scheme.surfaceContainerHigh,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(20),
                  topRight: const Radius.circular(20),
                  bottomLeft: Radius.circular(isUser ? 20 : 6),
                  bottomRight: Radius.circular(isUser ? 6 : 20),
                ),
              ),
              child: isUser
                  ? Text(
                      message.text,
                      style: TextStyle(
                        color: scheme.onPrimaryContainer,
                        fontSize: 15,
                        height: 1.45,
                      ),
                    )
                  : MarkdownBody(
                      data: message.text,
                      styleSheet: _markdownStyle(theme),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  MarkdownStyleSheet _markdownStyle(ThemeData theme) {
    final scheme = theme.colorScheme;
    final base = theme.textTheme;
    return MarkdownStyleSheet(
      p: base.bodyMedium?.copyWith(
        color: scheme.onSurface,
        fontSize: 15,
        height: 1.5,
      ),
      strong: base.bodyMedium?.copyWith(fontWeight: FontWeight.w700),
      h2: base.titleLarge?.copyWith(fontWeight: FontWeight.w700),
      listBullet: base.bodyMedium?.copyWith(color: scheme.onSurfaceVariant),
      code: base.bodyMedium?.copyWith(
        fontFamily: 'monospace',
        fontSize: 13.5,
        backgroundColor: scheme.surfaceContainerHighest,
      ),
      codeblockDecoration: BoxDecoration(
        color: scheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(14),
      ),
      blockquoteDecoration: BoxDecoration(
        color: scheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }
}
