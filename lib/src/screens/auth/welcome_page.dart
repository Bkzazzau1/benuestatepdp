import 'package:flutter/material.dart';
import 'package:polisphere/src/theme/app_theme.dart';
import 'package:polisphere/src/widgets/candidate_portrait.dart';
import 'package:polisphere/src/widgets/premium_background.dart';

/// The first screen of the app: a formal, seal-like introduction to the
/// candidate before the operator chooses a role and signs in.
class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key, required this.onContinue});
  final VoidCallback onContinue;

  @override
  Widget build(BuildContext context) => Scaffold(
        body: PremiumBackground(
          child: SafeArea(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 460),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
                  child: Column(children: [
                    _FadeIn(delay: 0, child: const CandidatePortrait(size: 140)),
                    const SizedBox(height: 28),
                    _FadeIn(delay: 90, child: const _RuleLine()),
                    const SizedBox(height: 14),
                    _FadeIn(
                      delay: 130,
                      child: Text(
                        'OFFICE OF THE HONOURABLE MEMBER',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppColors.bronzeLight.withValues(alpha: .85),
                          fontSize: 10.5,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 2.6,
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),
                    _FadeIn(
                      delay: 190,
                      child: Column(children: [
                        Text('HON. SULEIMAN',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'Georgia', fontFamilyFallback: const ['Times New Roman', 'serif'],
                              color: AppColors.ivory,
                              fontSize: 30,
                              height: 1.18,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 1,
                            )),
                        const Text('IBRAHIM DABO',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'Georgia', fontFamilyFallback: ['Times New Roman', 'serif'],
                              color: AppColors.bronzeLight,
                              fontSize: 30,
                              height: 1.18,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 1,
                            )),
                      ]),
                    ),
                    const SizedBox(height: 14),
                    _FadeIn(delay: 240, child: const _RuleLine()),
                    const SizedBox(height: 16),
                    _FadeIn(
                      delay: 270,
                      child: Text(
                        'Campaign Situation Room',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppColors.ivory.withValues(alpha: .62),
                          fontSize: 14,
                          fontStyle: FontStyle.italic,
                          letterSpacing: .3,
                        ),
                      ),
                    ),
                    const SizedBox(height: 34),
                    _FadeIn(delay: 320, child: const _CertificateStrip()),
                    const SizedBox(height: 40),
                    _FadeIn(delay: 380, child: _EnterButton(onPressed: onContinue)),
                    const SizedBox(height: 22),
                    _FadeIn(
                      delay: 420,
                      child: Text(
                        'ZARIA FEDERAL CONSTITUENCY  •  KADUNA STATE',
                        style: TextStyle(
                          color: AppColors.ivory.withValues(alpha: .32),
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.4,
                        ),
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

class _RuleLine extends StatelessWidget {
  const _RuleLine();
  @override
  Widget build(BuildContext context) => SizedBox(
        width: 120,
        height: 10,
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Expanded(
              child: Divider(
                  color: AppColors.bronzeLight.withValues(alpha: .4),
                  thickness: .8)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Transform.rotate(
              angle: .78,
              child: Container(
                width: 5,
                height: 5,
                color: AppColors.bronzeLight.withValues(alpha: .8),
              ),
            ),
          ),
          Expanded(
              child: Divider(
                  color: AppColors.bronzeLight.withValues(alpha: .4),
                  thickness: .8)),
        ]),
      );
}

/// A single bordered strip (like a museum placard) listing the platform's
/// trust guarantees, rather than three separate tech-style pill chips.
class _CertificateStrip extends StatelessWidget {
  const _CertificateStrip();
  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 6),
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(color: AppColors.bronzeLight.withValues(alpha: .3)),
            bottom:
                BorderSide(color: AppColors.bronzeLight.withValues(alpha: .3)),
          ),
        ),
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: const [
          _CertificateItem(Icons.verified_user_outlined, 'ENCRYPTED'),
          _CertificateDivider(),
          _CertificateItem(Icons.fact_check_outlined, 'VERIFIED'),
          _CertificateDivider(),
          _CertificateItem(Icons.bolt_outlined, 'AUDITED'),
        ]),
      );
}

class _CertificateItem extends StatelessWidget {
  const _CertificateItem(this.icon, this.label);
  final IconData icon;
  final String label;
  @override
  Widget build(BuildContext context) => Expanded(
        child: Column(children: [
          Icon(icon, color: AppColors.bronzeLight.withValues(alpha: .8), size: 16),
          const SizedBox(height: 5),
          Text(label,
              style: TextStyle(
                  color: AppColors.ivory.withValues(alpha: .55),
                  fontSize: 9,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.2)),
        ]),
      );
}

class _CertificateDivider extends StatelessWidget {
  const _CertificateDivider();
  @override
  Widget build(BuildContext context) => Container(
        width: 1,
        height: 30,
        color: AppColors.bronzeLight.withValues(alpha: .2),
      );
}

class _EnterButton extends StatefulWidget {
  const _EnterButton({required this.onPressed});
  final VoidCallback onPressed;
  @override
  State<_EnterButton> createState() => _EnterButtonState();
}

class _EnterButtonState extends State<_EnterButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) => AnimatedScale(
        scale: _pressed ? .97 : 1,
        duration: const Duration(milliseconds: 120),
        child: SizedBox(
          width: double.infinity,
          height: 56,
          child: Material(
            color: Colors.transparent,
            child: Ink(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                    colors: [AppColors.bronzeLight, AppColors.bronze]),
                border: Border.all(
                    color: AppColors.ivory.withValues(alpha: .5), width: 1),
                boxShadow: [
                  BoxShadow(
                      color: AppColors.emeraldDeep.withValues(alpha: .5),
                      blurRadius: 18,
                      offset: const Offset(0, 8)),
                ],
              ),
              child: InkWell(
                onTap: widget.onPressed,
                onHighlightChanged: (v) => setState(() => _pressed = v),
                child: const Center(
                  child: Text('ENTER SITUATION ROOM',
                      style: TextStyle(
                          color: AppColors.emeraldDeep,
                          fontWeight: FontWeight.w800,
                          fontSize: 13,
                          letterSpacing: 2)),
                ),
              ),
            ),
          ),
        ),
      );
}

/// Simple fade + rise entrance used to stagger the Welcome screen's reveal.
class _FadeIn extends StatelessWidget {
  const _FadeIn({required this.delay, required this.child});
  final int delay;
  final Widget child;

  @override
  Widget build(BuildContext context) => TweenAnimationBuilder<double>(
        tween: Tween(begin: 0, end: 1),
        duration: Duration(milliseconds: 560 + delay),
        curve: Curves.easeOutCubic,
        builder: (context, value, child) => Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, (1 - value) * 14),
            child: child,
          ),
        ),
        child: child,
      );
}
