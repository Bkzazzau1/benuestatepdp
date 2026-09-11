import 'dart:math' as math;
import 'package:flutter/material.dart';

const pdpGreen = Color(0xFF0B7A3B);
const pdpGreenDark = Color(0xFF064F2A);
const pdpRed = Color(0xFFD72638);
const ink = Color(0xFF10231A);
const muted = Color(0xFF647067);
const canvas = Color(0xFFF4F7F4);

class SectionCard extends StatelessWidget {
  const SectionCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(20),
  });

  final Widget child;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) => Container(
        padding: padding,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFFE2EAE4)),
          boxShadow: const [
            BoxShadow(
              color: Color(0x0A000000),
              blurRadius: 20,
              offset: Offset(0, 8),
            ),
          ],
        ),
        child: child,
      );
}

class MetricCard extends StatelessWidget {
  const MetricCard({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
    this.detail,
    this.accent = pdpGreen,
  });

  final String label;
  final String value;
  final IconData icon;
  final String? detail;
  final Color accent;

  @override
  Widget build(BuildContext context) => SectionCard(
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: accent.withValues(alpha: .10),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: accent),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(value,
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall
                          ?.copyWith(fontWeight: FontWeight.w800, color: ink)),
                  const SizedBox(height: 2),
                  Text(label,
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(fontWeight: FontWeight.w700, color: ink)),
                  if (detail != null) ...[
                    const SizedBox(height: 4),
                    Text(detail!,
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall
                            ?.copyWith(color: muted)),
                  ]
                ],
              ),
            ),
          ],
        ),
      );
}

class StatusPill extends StatelessWidget {
  const StatusPill(this.text, {super.key, this.color = pdpGreen});
  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: color.withValues(alpha: .10),
          borderRadius: BorderRadius.circular(999),
        ),
        child: Text(text,
            style: TextStyle(
                color: color, fontSize: 12, fontWeight: FontWeight.w800)),
      );
}

class PageHeading extends StatelessWidget {
  const PageHeading({
    super.key,
    required this.title,
    required this.subtitle,
    this.trailing,
  });

  final String title;
  final String subtitle;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) => Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.w900, color: ink, height: 1.05)),
                const SizedBox(height: 8),
                Text(subtitle,
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge
                        ?.copyWith(color: muted)),
              ],
            ),
          ),
          if (trailing != null) trailing!,
        ],
      );
}

class PrototypeBanner extends StatelessWidget {
  const PrototypeBanner({super.key});

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: const Color(0xFFFFF5D9),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFFFE19B)),
        ),
        child: const Row(
          children: [
            Icon(Icons.science_outlined, size: 18, color: Color(0xFF8A5B00)),
            SizedBox(width: 8),
            Expanded(
              child: Text(
                'Prototype mode: historical totals are sourced; live campaign metrics are demonstration values until connected to verified field and polling data.',
                style: TextStyle(
                    color: Color(0xFF6D4A00), fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      );
}

class ElectionBars extends StatelessWidget {
  const ElectionBars({super.key, required this.apc, required this.pdp});
  final int apc;
  final int pdp;

  @override
  Widget build(BuildContext context) {
    final maxValue = math.max(apc, pdp).toDouble();
    Widget row(String party, int value, Color color) => Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Row(
            children: [
              SizedBox(
                  width: 42,
                  child: Text(party,
                      style: const TextStyle(fontWeight: FontWeight.w800))),
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(99),
                  child: LinearProgressIndicator(
                    value: value / maxValue,
                    minHeight: 12,
                    backgroundColor: const Color(0xFFE9EFEA),
                    valueColor: AlwaysStoppedAnimation<Color>(color),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              SizedBox(
                width: 72,
                child: Text(_format(value),
                    textAlign: TextAlign.right,
                    style: const TextStyle(fontWeight: FontWeight.w700)),
              ),
            ],
          ),
        );

    return Column(children: [
      row('APC', apc, const Color(0xFF2E62D8)),
      row('PDP', pdp, pdpGreen),
    ]);
  }
}

String _format(int value) {
  final chars = value.toString().split('').reversed.toList();
  final out = <String>[];
  for (var i = 0; i < chars.length; i++) {
    if (i > 0 && i % 3 == 0) out.add(',');
    out.add(chars[i]);
  }
  return out.reversed.join();
}

class MiniLineChart extends StatelessWidget {
  const MiniLineChart({super.key, required this.values, this.height = 180});
  final List<double> values;
  final double height;

  @override
  Widget build(BuildContext context) => SizedBox(
        height: height,
        width: double.infinity,
        child: CustomPaint(painter: _LinePainter(values)),
      );
}

class _LinePainter extends CustomPainter {
  _LinePainter(this.values);
  final List<double> values;

  @override
  void paint(Canvas canvas, Size size) {
    if (values.length < 2) return;
    final grid = Paint()
      ..color = const Color(0xFFE6ECE7)
      ..strokeWidth = 1;
    for (var i = 1; i < 4; i++) {
      final y = size.height * i / 4;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), grid);
    }
    final minV = values.reduce(math.min);
    final maxV = values.reduce(math.max);
    final span = math.max(1, maxV - minV);
    final path = Path();
    for (var i = 0; i < values.length; i++) {
      final x = size.width * i / (values.length - 1);
      final y = size.height - ((values[i] - minV) / span) * (size.height - 24) - 12;
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    canvas.drawPath(
      path,
      Paint()
        ..color = pdpGreen
        ..strokeWidth = 4
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round,
    );
  }

  @override
  bool shouldRepaint(covariant _LinePainter oldDelegate) =>
      oldDelegate.values != values;
}
