import 'package:flutter/material.dart';

import 'package:flutter_app_skeleton/theme/app_theme.dart';

/// Подсказки-промпты для быстрого старта диалога.
///
/// Каждая карточка появляется с каскадной задержкой (staggered animation)
/// и содержит иконку в мягком градиентном кружке для визуальной иерархии.
class SuggestionChips extends StatefulWidget {
  const SuggestionChips({super.key, required this.onTap});

  final ValueChanged<String> onTap;

  static const _suggestions = <(String, IconData)>[
    ('Объясни квантовую запутанность простыми словами', Icons.science_outlined),
    ('Напиши короткое стихотворение о космосе', Icons.auto_stories_outlined),
    ('Дай 5 идей для пет-проекта', Icons.lightbulb_outline),
    ('Покажи пример функции на Dart', Icons.code),
  ];

  @override
  State<SuggestionChips> createState() => _SuggestionChipsState();
}

class _SuggestionChipsState extends State<SuggestionChips>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (int i = 0; i < SuggestionChips._suggestions.length; i++) ...[
          _buildChip(
            text: SuggestionChips._suggestions[i].$1,
            icon: SuggestionChips._suggestions[i].$2,
            index: i,
          ),
        ],
      ],
    );
  }

  Widget _buildChip({
    required String text,
    required IconData icon,
    required int index,
  }) {
    final scheme = Theme.of(context).colorScheme;

    // Каскадная задержка: каждая карточка появляется через 150мс после предыдущей
    final delay = index * 0.15;
    final stagger = CurvedAnimation(
      parent: _controller,
      curve: Interval(delay, delay + 0.45, curve: Curves.easeOutCubic),
    );

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: FadeTransition(
        opacity: stagger,
        child: SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 0.08),
            end: Offset.zero,
          ).animate(stagger),
          child: Material(
            color: scheme.surfaceContainerHigh,
            borderRadius: BorderRadius.circular(18),
            child: InkWell(
              borderRadius: BorderRadius.circular(18),
              onTap: () => widget.onTap(text),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 6,
                  vertical: 10,
                ),
                child: Row(
                  children: [
                    // Иконка в мягком градиентном кружке
                    Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                        gradient: AppTheme.brandGradientSoft(scheme),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(icon, size: 20, color: scheme.primary),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Text(
                        text,
                        style: TextStyle(
                          color: scheme.onSurface,
                          fontSize: 14.5,
                          fontWeight: FontWeight.w500,
                          height: 1.35,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 4),
                      child: Icon(
                        Icons.arrow_forward_rounded,
                        size: 18,
                        color: scheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
