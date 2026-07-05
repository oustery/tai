import 'package:flutter/material.dart';

import 'package:flutter_app_skeleton/theme/app_theme.dart';

/// Фирменный «огонёк» Tai — круг с градиентом и иконкой искры.
class TaiLogo extends StatelessWidget {
  const TaiLogo({super.key, this.size = 40, this.iconSize});

  final double size;
  final double? iconSize;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: AppTheme.brandGradient(scheme),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: scheme.primary.withValues(alpha: 0.35),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Icon(
        Icons.auto_awesome_rounded,
        size: iconSize ?? size * 0.55,
        color: scheme.onPrimary,
      ),
    );
  }
}
