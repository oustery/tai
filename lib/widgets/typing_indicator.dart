import 'package:flutter/material.dart';

import 'package:flutter_app_skeleton/theme/app_theme.dart';
import 'package:flutter_app_skeleton/widgets/tai_logo.dart';

/// Три «дышащих» точки — индикатор того, что Tai печатает ответ.
///
/// Точки используют фирмовый primary-цвет для большего брендинга.
class TypingIndicator extends StatefulWidget {
  const TypingIndicator({super.key});

  @override
  State<TypingIndicator> createState() => _TypingIndicatorState();
}

class _TypingIndicatorState extends State<TypingIndicator>
    with TickerProviderStateMixin {
  late final AnimationController _controller;

  static const _dotCount = 3;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          const TaiLogo(size: 30),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
            decoration: BoxDecoration(
              color: scheme.surfaceContainerHigh,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
                bottomRight: Radius.circular(6),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(_dotCount, (i) => _dot(i, scheme)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _dot(int index, ColorScheme scheme) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        // Каждая точка «взлетает» со сдвигом по фазе.
        final t = (_controller.value + index / _dotCount) % 1.0;
        final scale = 0.6 + 0.4 * (0.5 - (t - 0.5).abs() * 2).abs();
        final opacity = 0.4 + 0.6 * (0.5 - (t - 0.5).abs() * 2).abs();
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 3),
          child: Transform.scale(
            scale: scale,
            child: Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                // Фирмовый primary-цвет вместо onSurfaceVariant
                color: scheme.primary.withValues(alpha: opacity * 0.7),
                shape: BoxShape.circle,
              ),
            ),
          ),
        );
      },
    );
  }
}
