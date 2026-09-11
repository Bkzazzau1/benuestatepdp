import 'package:flutter/material.dart';

import 'campaign_identity.dart';
import 'widgets.dart';

class CampaignWelcomePage extends StatelessWidget {
  const CampaignWelcomePage({
    super.key,
    required this.onEnter,
  });

  final VoidCallback onEnter;

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: const Color(0xFFF4F6F4),
        body: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final wide = constraints.maxWidth >= 980;
              return Stack(
                children: [
                  const Positioned.fill(child: _WelcomeBackground()),
                  if (wide)
                    _DesktopWelcome(onEnter: onEnter)
                  else
                    _MobileWelcome(onEnter: onEnter),
                ],
              );
            },
          ),
        ),
      );
}

class _DesktopWelcome extends StatelessWidget {
  const _DesktopWelcome({required this.onEnter});
  final VoidCallback onEnter;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.all(28),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(34),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(.08),
                blurRadius: 45,
                offset: const Offset(0, 18),
              ),
            ],
          ),
          clipBehavior: Clip.antiAlias,
          child: Row(
            children: [
              Expanded(
                flex: 12,
                child: _CandidateHero(),
              ),
              Expanded(
                flex: 13,
                child: _WelcomeContent(onEnter: onEnter),
              ),
            ],
          ),
        ),
      );
}

class _MobileWelcome extends StatelessWidget {
  const _MobileWelcome({required this.onEnter});
  final VoidCallback onEnter;

  @override
  Widget build(BuildContext context) => ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            height: 390,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(.09),
                  blurRadius: 28,
                  offset: const Offset(0, 12),
                ),
              ],
            ),
            clipBehavior: Clip.antiAlias,
            child: const _CandidateHero(compact: true),
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.fromLTRB(22, 26, 22, 24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(28),
              border: Border.all(color: const Color(0xFFE4EAE5)),
            ),
            child: _WelcomeContent(onEnter: onEnter, compact: true),
          ),
        ],
      );
}

class _CandidateHero extends StatelessWidget {
  const _CandidateHero({this.compact = false});
  final bool compact;

  @override
  Widget build(BuildContext context) => Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            CampaignIdentity.portraitAsset,
            fit: BoxFit.cover,
            alignment: const Alignment(0, -0.10),
            errorBuilder: (_, __, ___) => Container(
              color: const Color(0xFF173526),
              alignment: Alignment.center,
              child: const Icon(
                Icons.person_rounded,
                color: Colors.white54,
                size: 130,
              ),
            ),
          ),
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0x08000000),
                  Color(0x22000000),
                  Color(0xD9052A18),
                ],
                stops: [0, .50, 1],
              ),
            ),
          ),
          Positioned(
            left: compact ? 20 : 34,
            right: compact ? 20 : 34,
            top: compact ? 20 : 30,
            child: const Row(
              children: [
                _PdpMark(),
                Spacer(),
                _SecureBadge(),
              ],
            ),
          ),
          Positioned(
            left: compact ? 22 : 38,
            right: compact ? 22 : 38,
            bottom: compact ? 22 : 34,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'BENUE STATE',
                  style: TextStyle(
                    color: Color(0xFFA9E0BC),
                    fontSize: 12,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 2.2,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  CampaignIdentity.candidateName,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: compact ? 25 : 34,
                    fontWeight: FontWeight.w900,
                    height: 1.05,
                  ),
                ),
                const SizedBox(height: 7),
                Text(
                  CampaignIdentity.candidateTitle,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      );
}

class _WelcomeContent extends StatelessWidget {
  const _WelcomeContent({
    required this.onEnter,
    this.compact = false,
  });

  final VoidCallback onEnter;
  final bool compact;

  @override
  Widget build(BuildContext context) => Padding(
        padding: compact
            ? EdgeInsets.zero
            : const EdgeInsets.fromLTRB(58, 52, 58, 48),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _MiniBrand(),
            SizedBox(height: compact ? 28 : 38),
            const Text(
              'WELCOME TO',
              style: TextStyle(
                color: pdpGreen,
                fontSize: 13,
                fontWeight: FontWeight.w900,
                letterSpacing: 2.0,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'PoliSphere Benue',
              style: TextStyle(
                color: ink,
                fontSize: compact ? 34 : 52,
                fontWeight: FontWeight.w900,
                height: .98,
                letterSpacing: -1.2,
              ),
            ),
            const SizedBox(height: 14),
            Text(
              'Campaign Command & Situation Room',
              style: TextStyle(
                color: pdpGreenDark,
                fontSize: compact ? 17 : 21,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 18),
            Text(
              'One secure command environment for campaign leadership, field operations, intelligence, communications, logistics and election-day coordination across Benue State.',
              style: TextStyle(
                color: muted,
                fontSize: compact ? 14 : 16,
                height: 1.6,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: compact ? 24 : 30),
            const _CoverageStrip(),
            SizedBox(height: compact ? 26 : 34),
            SizedBox(
              width: compact ? double.infinity : 270,
              height: 56,
              child: FilledButton.icon(
                onPressed: onEnter,
                style: FilledButton.styleFrom(
                  backgroundColor: pdpGreen,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                ),
                icon: const Icon(Icons.arrow_forward_rounded),
                label: const Text(
                  'Enter Command Centre',
                  style: TextStyle(fontWeight: FontWeight.w900, fontSize: 15),
                ),
              ),
            ),
            const SizedBox(height: 18),
            const Row(
              children: [
                Icon(Icons.lock_outline_rounded, size: 16, color: muted),
                SizedBox(width: 7),
                Expanded(
                  child: Text(
                    'Authorized campaign personnel only • Role-based access',
                    style: TextStyle(
                      color: muted,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
}

class _CoverageStrip extends StatelessWidget {
  const _CoverageStrip();

  @override
  Widget build(BuildContext context) => Wrap(
        spacing: 10,
        runSpacing: 10,
        children: const [
          _CoverageStat(value: '23', label: 'LGAs'),
          _CoverageStat(value: '276', label: 'Wards / RAs'),
          _CoverageStat(value: '5,102', label: 'Polling Units'),
        ],
      );
}

class _CoverageStat extends StatelessWidget {
  const _CoverageStat({required this.value, required this.label});
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
        decoration: BoxDecoration(
          color: const Color(0xFFF5F8F5),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: const Color(0xFFE1E8E2)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              value,
              style: const TextStyle(
                color: ink,
                fontWeight: FontWeight.w900,
                fontSize: 17,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                color: muted,
                fontSize: 11,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      );
}

class _MiniBrand extends StatelessWidget {
  const _MiniBrand();

  @override
  Widget build(BuildContext context) => Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [pdpGreen, pdpGreenDark],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(15),
            ),
            alignment: Alignment.center,
            child: const Text(
              'PDP',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w900,
                fontSize: 13,
              ),
            ),
          ),
          const SizedBox(width: 12),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'POLISPHERE',
                style: TextStyle(
                  color: ink,
                  fontWeight: FontWeight.w900,
                  letterSpacing: .5,
                ),
              ),
              SizedBox(height: 2),
              Text(
                'Benue Governorship Command',
                style: TextStyle(color: muted, fontSize: 11),
              ),
            ],
          ),
        ],
      );
}

class _PdpMark extends StatelessWidget {
  const _PdpMark();

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(.92),
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Text(
          'PDP • BENUE',
          style: TextStyle(
            color: pdpGreenDark,
            fontWeight: FontWeight.w900,
            fontSize: 11,
            letterSpacing: .5,
          ),
        ),
      );
}

class _SecureBadge extends StatelessWidget {
  const _SecureBadge();

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(.30),
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: Colors.white24),
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.shield_outlined, size: 14, color: Colors.white),
            SizedBox(width: 6),
            Text(
              'CAMPAIGN COMMAND',
              style: TextStyle(
                color: Colors.white,
                fontSize: 9,
                fontWeight: FontWeight.w900,
                letterSpacing: .8,
              ),
            ),
          ],
        ),
      );
}

class _WelcomeBackground extends StatelessWidget {
  const _WelcomeBackground();

  @override
  Widget build(BuildContext context) => Stack(
        children: [
          Container(color: const Color(0xFFF3F6F3)),
          Positioned(
            top: -180,
            right: -130,
            child: Container(
              width: 440,
              height: 440,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: pdpGreen.withOpacity(.06),
              ),
            ),
          ),
          Positioned(
            bottom: -180,
            left: -160,
            child: Container(
              width: 430,
              height: 430,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: pdpRed.withOpacity(.04),
              ),
            ),
          ),
        ],
      );
}
