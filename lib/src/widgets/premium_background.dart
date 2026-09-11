import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:polisphere/src/theme/app_theme.dart';

/// A formal, state-seal backdrop for the entry flow (Welcome, sign-in):
/// a deep emerald vignette with a faint, slowly-turning engraved ring
/// ornament — evoking an official seal rather than a tech dashboard.
class PremiumBackground extends StatefulWidget {
  const PremiumBackground({super.key, required this.child});
  final Widget child;

  @override
  State<PremiumBackground> createState() => _PremiumBackgroundState();
}

class _PremiumBackgroundState extends State<PremiumBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 90),
  )..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => DecoratedBox(
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment(0, -.3),
            radius: 1.3,
            colors: [
              AppColors.emeraldMid,
              AppColors.emerald,
              AppColors.emeraldDeep,
            ],
            stops: [0, .55, 1],
          ),
        ),
        child: Stack(fit: StackFit.expand, children: [
          AnimatedBuilder(
            animation: _controller,
            builder: (context, _) => CustomPaint(
              painter: _SealOrnamentPainter(turns: _controller.value),
              size: Size.infinite,
            ),
          ),
          Positioned.fill(
              child: CustomPaint(painter: _VignettePainter(), size: Size.infinite)),
          widget.child,
        ]),
      );
}

/// Faint concentric rings + radiating ticks, like an engraved medallion,
/// centred slightly above middle and rotating almost imperceptibly slowly.
class _SealOrnamentPainter extends CustomPainter {
  _SealOrnamentPainter({required this.turns});
  final double turns;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height * .34);
    final maxRadius = size.longestSide * .62;
    final ring = Paint()
      ..color = AppColors.bronzeLight.withValues(alpha: .07)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    for (var r = maxRadius * .18; r < maxRadius; r += maxRadius * .11) {
      canvas.drawCircle(center, r, ring);
    }

    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(turns * 2 * math.pi);
    final tick = Paint()
      ..color = AppColors.bronzeLight.withValues(alpha: .09)
      ..strokeWidth = 1;
    const tickCount = 48;
    for (var i = 0; i < tickCount; i++) {
      final angle = (2 * math.pi / tickCount) * i;
      final inner = Offset(math.cos(angle), math.sin(angle)) * (maxRadius * .95);
      final outer = Offset(math.cos(angle), math.sin(angle)) * maxRadius;
      canvas.drawLine(inner, outer, tick);
    }
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _SealOrnamentPainter oldDelegate) =>
      oldDelegate.turns != turns;
}

/// Darkens the corners so content stays legible over the ornament.
class _VignettePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = RadialGradient(
        center: const Alignment(0, -.2),
        radius: 1.1,
        colors: [
          Colors.transparent,
          AppColors.emeraldDeep.withValues(alpha: .55),
        ],
        stops: const [.6, 1],
      ).createShader(Offset.zero & size);
    canvas.drawRect(Offset.zero & size, paint);
  }

  @override
  bool shouldRepaint(covariant _VignettePainter oldDelegate) => false;
}
