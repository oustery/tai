import 'package:flutter/material.dart';

/// Подсказки-промпты для быстрого старта диалога.
class SuggestionChips extends StatelessWidget {
  const SuggestionChips({super.key, required this.onTap});

  final ValueChanged<String> onTap;

  static const _suggestions = <(String, IconData)>[
    ('Объясни квантовую запутанность простыми словами', Icons.science_outlined),
    ('Напиши короткое стихотворение о космосе', Icons.auto_stories_outlined),
    ('Дай 5 идей для пет-проекта', Icons.lightbulb_outline),
    ('Покажи пример функции на Dart', Icons.code),
  ];

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final (text, icon) in _suggestions) ...[
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Material(
              color: scheme.surfaceContainerHigh,
              borderRadius: BorderRadius.circular(16),
              child: InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () => onTap(text),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  child: Row(
                    children: [
                      Icon(icon, size: 20, color: scheme.primary),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          text,
                          style: TextStyle(
                            color: scheme.onSurface,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Icon(Icons.arrow_forward_rounded,
                          size: 18, color: scheme.onSurfaceVariant),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }
}
