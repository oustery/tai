import 'package:flutter/material.dart';

/// Фирменный логотип Tai — сплошной круг с иконкой искры.
///
/// Claude Dark Minimal: без градиента, без свечения, без пульсации.
/// Просто чистый брендовый круг.
class TaiLogo extends StatelessWidget {
  const TaiLogo({
    super.key,
    this.size = 40,
    this.iconSize,
  });

  final double size;
  final double? iconSize;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: scheme.primary,
        shape: BoxShape.circle,
      ),
      child: Icon(
        Icons.auto_awesome_rounded,
        size: iconSize ?? size * 0.5,
        color: scheme.onPrimary,
      ),
    );
  }
}
