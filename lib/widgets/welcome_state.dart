import 'package:flutter/material.dart';

import 'package:flutter_app_skeleton/widgets/suggestion_chips.dart';
import 'package:flutter_app_skeleton/widgets/tai_logo.dart';
import 'package:flutter_app_skeleton/theme/app_theme.dart';

/// Приветственный экран для пустого диалога.
///
/// Содержит анимированный логотип с пульсацией, заголовок с градиентным
/// текстом и подсказки-промпты с каскадной анимацией появления.
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
              SizedBox(height: constraints.maxHeight * 0.06),
              // Анимированный логотип с пульсирующим свечением
              const TaiLogo(size: 88, animate: true),
              const SizedBox(height: 24),
              // Заголовок с брендовым градиентом
              ShaderMask(
                blendMode: BlendMode.srcIn,
                shaderCallback: (bounds) =>
                    AppTheme.brandGradient(scheme).createShader(bounds),
                child: Text(
                  'Привет! Я Tai',
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: Colors.white, // Цвет-заглушка: заменяется gradient shader
                  ),
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
              const SizedBox(height: 32),
              // Заголовок секции подсказок
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'С чего начнём?',
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: scheme.onSurfaceVariant,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.6,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              SuggestionChips(onTap: onSuggestion),
            ],
          ),
        );
      },
    );
  }
}