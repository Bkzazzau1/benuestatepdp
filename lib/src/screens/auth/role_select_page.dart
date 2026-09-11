import 'package:flutter/material.dart';
import 'package:polisphere/src/auth/app_role.dart';
import 'package:polisphere/src/auth/session.dart';
import 'package:polisphere/src/theme/app_theme.dart';
import 'package:polisphere/src/widgets/candidate_portrait.dart';
import 'package:polisphere/src/widgets/glass_panel.dart';
import 'package:polisphere/src/widgets/premium_background.dart';

/// Sign-in: picks which role's view of the platform to open. Stands in for
/// real authentication, which requires an audited backend.
class RoleSelectPage extends StatelessWidget {
  const RoleSelectPage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        body: PremiumBackground(
          child: SafeArea(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 720),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(28),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(children: [
                        const CandidatePortrait(size: 54),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('HON. SULEIMAN IBRAHIM DABO',
                                  style: TextStyle(
                                      fontFamily: 'Georgia', fontFamilyFallback: const ['Times New Roman', 'serif'],
                                      color: AppColors.ivory,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 14,
                                      letterSpacing: .6)),
                              const SizedBox(height: 4),
                              Row(children: [
                                Icon(Icons.shield_outlined,
                                    color: AppColors.bronzeLight
                                        .withValues(alpha: .8),
                                    size: 12),
                                const SizedBox(width: 6),
                                Text('SECURE ACCESS',
                                    style: TextStyle(
                                        color: AppColors.ivory
                                            .withValues(alpha: .45),
                                        fontSize: 10,
                                        fontWeight: FontWeight.w700,
                                        letterSpacing: 1.6)),
                              ]),
                            ],
                          ),
                        ),
                      ]),
                      const SizedBox(height: 30),
                      Divider(
                          color: AppColors.bronzeLight.withValues(alpha: .25)),
                      const SizedBox(height: 26),
                      Text('Continue as',
                          style: TextStyle(
                              fontFamily: 'Georgia', fontFamilyFallback: const ['Times New Roman', 'serif'],
                              color: AppColors.ivory,
                              fontSize: 28,
                              fontWeight: FontWeight.w700)),
                      const SizedBox(height: 6),
                      Text(
                          'Choose the role for this session. This selects what you can see and do.',
                          style: TextStyle(
                              color: AppColors.ivory.withValues(alpha: .5),
                              fontSize: 13)),
                      const SizedBox(height: 22),
                      ...AppRole.values.indexed.map(
                        (entry) => Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: _RoleRow(
                            role: entry.$2,
                            delay: entry.$1 * 50,
                            onTap: () => SessionScope.of(context).signIn(entry.$2),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );
}

class _RoleRow extends StatefulWidget {
  const _RoleRow({required this.role, required this.delay, required this.onTap});
  final AppRole role;
  final int delay;
  final VoidCallback onTap;

  @override
  State<_RoleRow> createState() => _RoleRowState();
}

class _RoleRowState extends State<_RoleRow> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final color = widget.role.accentColor;
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: Duration(milliseconds: 340 + widget.delay),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) => Opacity(
        opacity: value,
        child:
            Transform.translate(offset: Offset(0, (1 - value) * 8), child: child),
      ),
      child: MouseRegion(
        onEnter: (_) => setState(() => _hover = true),
        onExit: (_) => setState(() => _hover = false),
        child: GlassPanel(
          padding: EdgeInsets.zero,
          opacity: _hover ? .09 : .045,
          borderOpacity: _hover ? .35 : .16,
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: widget.onTap,
              child: IntrinsicHeight(
                child: Row(children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 160),
                    width: 4,
                    color: _hover ? color : color.withValues(alpha: .45),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 15),
                      child: Row(children: [
                        Container(
                          width: 42,
                          height: 42,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                                color: color.withValues(alpha: .55), width: 1),
                          ),
                          child: Icon(widget.role.icon, color: color, size: 19),
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(widget.role.label,
                                  style: TextStyle(
                                      fontFamily: 'Georgia', fontFamilyFallback: const ['Times New Roman', 'serif'],
                                      color: AppColors.ivory,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 15)),
                              const SizedBox(height: 3),
                              Text(widget.role.description,
                                  style: TextStyle(
                                      color:
                                          AppColors.ivory.withValues(alpha: .5),
                                      fontSize: 12,
                                      height: 1.3)),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        AnimatedOpacity(
                          duration: const Duration(milliseconds: 160),
                          opacity: _hover ? 1 : .4,
                          child: Text('→',
                              style: TextStyle(
                                  color: color,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700)),
                        ),
                      ]),
                    ),
                  ),
                ]),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
