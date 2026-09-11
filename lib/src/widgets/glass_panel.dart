import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:polisphere/src/theme/app_theme.dart';

/// A frosted, ivory-tinted panel for the dark emerald entry-flow screens —
/// like a parchment card set against a state seal, rather than a neutral
/// tech-dashboard glass card.
class GlassPanel extends StatelessWidget {
  const GlassPanel({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(20),
    this.borderRadius = 16,
    this.opacity = .05,
    this.borderOpacity = .16,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final double borderRadius;
  final double opacity;
  final double borderOpacity;

  @override
  Widget build(BuildContext context) => ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
          child: Container(
            padding: padding,
            decoration: BoxDecoration(
              color: AppColors.ivory.withValues(alpha: opacity),
              borderRadius: BorderRadius.circular(borderRadius),
              border: Border.all(
                  color: AppColors.bronzeLight.withValues(alpha: borderOpacity)),
            ),
            child: child,
          ),
        ),
      );
}
