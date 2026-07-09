import 'package:flutter/material.dart';

import 'package:flutter_app_skeleton/widgets/suggestion_chips.dart';
import 'package:flutter_app_skeleton/widgets/tai_logo.dart';

/// Приветственный экран для пустого диалога.
///
/// Claude Dark Minimal: центрированная компоновка, простой белый заголовок
/// без градиента, лаконичный подзаголовок и плоские подсказки.
class WelcomeState extends StatelessWidget {
  const WelcomeState({super.key, required this.onSuggestion});

  final ValueChanged<String> onSuggestion;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final theme = Theme.of(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
          child: Column(
            children: [
              SizedBox(height: constraints.maxHeight * 0.08),
              // Логотип — статичный, без свечения
              const TaiLogo(size: 72),
              const SizedBox(height: 28),
              // Заголовок — простой белый текст
              Text(
                'Привет! Я Tai',
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: scheme.onSurface,
                ),
              ),
              const SizedBox(height: 12),
              // Подзаголовок
              Text(
                'Твой ИИ-помощник. Спроси что угодно\nили выбери подсказку ниже.',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: scheme.onSurfaceVariant,
                  height: 1.6,
                ),
              ),
              const SizedBox(height: 36),
              SuggestionChips(onTap: onSuggestion),
            ],
          ),
        );
      },
    );
  }
}
