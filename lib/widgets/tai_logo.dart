import 'package:flutter/material.dart';

import 'package:flutter_app_skeleton/theme/app_theme.dart';

/// Фирменный «огонёк» Tai — круг с градиентом и иконкой искры.
///
/// Поддерживает анимированный режим ([animate]) для приветственного экрана:
/// мягкая пульсация свечения и лёгкое «дыхание» масштаба.
class TaiLogo extends StatefulWidget {
  const TaiLogo({
    super.key,
    this.size = 40,
    this.iconSize,
    this.animate = false,
  });

  final double size;
  final double? iconSize;

  /// Если `true`, логотип плавно пульсирует (свечение + масштаб).
  /// Используется на приветственном экране.
  final bool animate;

  @override
  State<TaiLogo> createState() => _TaiLogoState();
}

class _TaiLogoState extends State<TaiLogo> with SingleTickerProviderStateMixin {
  AnimationController? _controller;

  @override
  void initState() {
    super.initState();
    if (widget.animate) {
      _controller = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 2400),
      )..repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final size = widget.size;

    // Анимированные параметры пульсации
    double glowAlpha = 0.35;
    double blur = 16.0;
    double scale = 1.0;

    if (_controller != null) {
      final t = _controller!.value;
      glowAlpha = 0.20 + 0.25 * t; // 0.20 → 0.45
      blur = 22.0 + 8.0 * t; // 22 → 30
      scale = 1.0 + 0.04 * t; // 1.0 → 1.04
    }

    return Transform.scale(
      scale: scale,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          gradient: AppTheme.brandGradient(scheme),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: scheme.primary.withValues(alpha: glowAlpha),
              blurRadius: blur,
              offset: Offset(0, widget.animate ? 8 : 6),
            ),
          ],
        ),
        child: Icon(
          Icons.auto_awesome_rounded,
          size: widget.iconSize ?? size * 0.55,
          color: scheme.onPrimary,
        ),
      ),
    );
  }
}
