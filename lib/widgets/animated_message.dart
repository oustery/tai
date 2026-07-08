import 'package:flutter/material.dart';

/// Обёртка, добавляющая сообщению анимацию появления (fade + slide).
///
/// Пользовательские сообщения «выезжают» справа, ответы ИИ — слева.
/// Использует [TweenAnimationBuilder] — лёгковесный, без AnimationController,
/// анимация проигрывается один раз при вставке в дерево.
class AnimatedMessage extends StatelessWidget {
  const AnimatedMessage({super.key, required this.child, this.isUser = false});

  final Widget child;
  final bool isUser;

  @override
  Widget build(BuildContext context) {
    // Направление «выезда»: пользователь → справа, ИИ → слева
    final dx = isUser ? 0.06 : -0.06;

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset((1 - value) * dx * 400, (1 - value) * 12),
            child: child,
          ),
        );
      },
      child: child,
    );
  }
}
