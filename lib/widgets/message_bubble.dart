import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

import 'package:flutter_app_skeleton/models/chat_message.dart';
import 'package:flutter_app_skeleton/widgets/animated_message.dart';
import 'package:flutter_app_skeleton/widgets/tai_logo.dart';

/// Один бабл сообщения — пользователя (справа) или ИИ (слева).
///
/// Обёрнут в [AnimatedMessage] для анимации появления при первом рендере.
/// Во время стриминга анимация отключена, чтобы не вызывать джанк.
/// Ответы ИИ содержат кнопку «Копировать».
class MessageBubble extends StatelessWidget {
  const MessageBubble({super.key, required this.message});

  final ChatMessage message;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final isUser = message.isUser;

    final bubble = Padding(
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
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        MarkdownBody(
                          data: message.text,
                          styleSheet: _markdownStyle(theme),
                        ),
                        // Кнопка «Копировать» появляется после завершения стриминга
                        if (!message.isStreaming && message.text.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 6),
                            child: _CopyButton(text: message.text),
                          ),
                      ],
                    ),
            ),
          ),
        ],
      ),
    );

    // Не анимировать при стриминге — каждый токен вызывает пересборку,
    // анимация перезапускалась бы на каждом кадре, вызывая джанк.
    if (message.isStreaming) return bubble;

    return AnimatedMessage(
      isUser: isUser,
      child: bubble,
    );
  }

  MarkdownStyleSheet _markdownStyle(ThemeData theme) {
    final scheme = theme.colorScheme;
    final base = theme.textTheme;
    return MarkdownStyleSheet(
      p: base.bodyMedium?.copyWith(
        color: scheme.onSurface,
        fontSize: 15,
        height: 1.55,
      ),
      strong: base.bodyMedium?.copyWith(fontWeight: FontWeight.w700),
      h2: base.titleLarge?.copyWith(fontWeight: FontWeight.w700),
      h3: base.titleMedium?.copyWith(fontWeight: FontWeight.w600),
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

/// Кнопка «Копировать» для ответов ИИ.
///
/// При нажатии копирует текст в буфер обмена и показывает «Скопировано»
/// на 2 секунды с анимированной иконкой.
class _CopyButton extends StatefulWidget {
  const _CopyButton({required this.text});

  final String text;

  @override
  State<_CopyButton> createState() => _CopyButtonState();
}

class _CopyButtonState extends State<_CopyButton> {
  bool _copied = false;

  Future<void> _copy() async {
    await Clipboard.setData(ClipboardData(text: widget.text));
    setState(() => _copied = true);
    await Future<void>.delayed(const Duration(seconds: 2));
    if (mounted) setState(() => _copied = false);
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return InkWell(
      onTap: _copy,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              _copied ? Icons.check_rounded : Icons.copy_rounded,
              size: 14,
              color: scheme.onSurfaceVariant,
            ),
            const SizedBox(width: 4),
            Text(
              _copied ? 'Скопировано' : 'Копировать',
              style: TextStyle(
                fontSize: 12,
                color: scheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}