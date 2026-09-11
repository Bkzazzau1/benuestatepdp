import 'package:flutter/material.dart';

import 'widgets.dart';

/// Central campaign identity used by welcome, login, shell and executive screens.
class CampaignIdentity {
  const CampaignIdentity._();

  static const campaignName = 'Benue State PDP Governorship Campaign';
  static const candidateName = 'Michael Kaase Aondoakaa';
  static const candidateTitle = 'PDP Governorship Candidate';
  static const portraitAsset = 'assets/images/candidate.jpg';
}

/// Formal campaign portrait treatment.
///
/// We deliberately avoid a circular crop so the candidate's full face, suit
/// and portrait composition remain visible in compact navigation surfaces.
class CandidatePortrait extends StatelessWidget {
  const CandidatePortrait({
    super.key,
    this.size = 72,
    this.borderWidth = 2,
    this.showStatus = false,
    this.radius,
  });

  final double size;
  final double borderWidth;
  final bool showStatus;
  final double? radius;

  @override
  Widget build(BuildContext context) {
    final corner = radius ?? size * .24;
    final innerCorner = (corner - borderWidth).clamp(4.0, corner).toDouble();
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: size,
          height: size,
          padding: EdgeInsets.all(borderWidth),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(corner),
            gradient: const LinearGradient(
              colors: [pdpGreen, pdpRed],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: .12),
                blurRadius: 18,
                offset: const Offset(0, 7),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(innerCorner),
            child: Container(
              color: const Color(0xFF343230),
              alignment: Alignment.center,
              child: Image.asset(
                CampaignIdentity.portraitAsset,
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.contain,
                alignment: Alignment.center,
                filterQuality: FilterQuality.high,
                errorBuilder: (_, __, ___) => Container(
                  color: const Color(0xFFF0F3F0),
                  alignment: Alignment.center,
                  child: Icon(
                    Icons.person_rounded,
                    size: size * .52,
                    color: muted,
                  ),
                ),
              ),
            ),
          ),
        ),
        if (showStatus)
          Positioned(
            right: -1,
            bottom: -1,
            child: Container(
              width: size * .21,
              height: size * .21,
              decoration: BoxDecoration(
                color: const Color(0xFF20B15A),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2.2),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x22000000),
                    blurRadius: 6,
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

class CandidateIdentityCard extends StatelessWidget {
  const CandidateIdentityCard({
    super.key,
    this.compact = false,
    this.dark = false,
  });

  final bool compact;
  final bool dark;

  @override
  Widget build(BuildContext context) {
    final primaryText = dark ? Colors.white : ink;
    final secondaryText = dark ? Colors.white70 : muted;
    return Row(
      children: [
        CandidatePortrait(
          size: compact ? 54 : 72,
          radius: compact ? 15 : 19,
          showStatus: true,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                CampaignIdentity.candidateName,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: primaryText,
                  fontSize: compact ? 13 : 15,
                  fontWeight: FontWeight.w900,
                  height: 1.12,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                CampaignIdentity.candidateTitle,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: secondaryText,
                  fontSize: compact ? 10 : 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
