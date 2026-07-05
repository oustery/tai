import 'package:flutter/material.dart';

import 'package:flutter_app_skeleton/widgets/suggestion_chips.dart';
import 'package:flutter_app_skeleton/widgets/tai_logo.dart';

/// Приветственный экран для пустого диалога.
class WelcomeState extends StatelessWidget {
  const WelcomeState({super.key, required this.onSuggestion});

  final ValueChanged<String> onSuggestion;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Center(child: TaiLogo(size: 88)),
          const SizedBox(height: 20),
          Center(
            child: Text(
              'Привет! Я Tai',
              style: TextStyle(
                color: scheme.onSurface,
                fontSize: 28,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Center(
            child: Text(
              'Твой ИИ-помощник. Спроси что угодно\nили выбери подсказку ниже.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: scheme.onSurfaceVariant,
                fontSize: 15,
                height: 1.5,
              ),
            ),
          ),
          const SizedBox(height: 28),
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Text(
              'С чего начнём?',
              style: TextStyle(
                color: scheme.onSurfaceVariant,
                fontSize: 13,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.4,
              ),
            ),
          ),
          SuggestionChips(onTap: onSuggestion),
        ],
      ),
    );
  }
}
