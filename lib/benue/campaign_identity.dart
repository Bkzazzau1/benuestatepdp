import 'package:flutter/material.dart';

import 'widgets.dart';

/// Central campaign identity used by login, shell and executive screens.
///
/// Replace [candidateName] with the exact candidate name once it is confirmed.
class CampaignIdentity {
  const CampaignIdentity._();

  static const campaignName = 'Benue State PDP Governorship Campaign';
  static const candidateName = 'PDP Governorship Candidate';
  static const candidateTitle = 'Governorship Candidate';
  static const portraitAsset = 'assets/images/candidate.jpg';
}

class CandidatePortrait extends StatelessWidget {
  const CandidatePortrait({
    super.key,
    this.size = 72,
    this.borderWidth = 3,
    this.showStatus = false,
  });

  final double size;
  final double borderWidth;
  final bool showStatus;

  @override
  Widget build(BuildContext context) => Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: size,
            height: size,
            padding: EdgeInsets.all(borderWidth),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                colors: [pdpGreen, pdpRed],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(.12),
                  blurRadius: 18,
                  offset: const Offset(0, 7),
                ),
              ],
            ),
            child: ClipOval(
              child: Image.asset(
                CampaignIdentity.portraitAsset,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  color: const Color(0xFFF0F3F0),
                  alignment: Alignment.center,
                  child: Icon(Icons.person_rounded,
                      size: size * .52, color: muted),
                ),
              ),
            ),
          ),
          if (showStatus)
            Positioned(
              right: 1,
              bottom: 3,
              child: Container(
                width: size * .20,
                height: size * .20,
                decoration: BoxDecoration(
                  color: const Color(0xFF20B15A),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
              ),
            ),
        ],
      );
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
        CandidatePortrait(size: compact ? 48 : 64, showStatus: true),
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
                  height: 1.1,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                CampaignIdentity.candidateTitle,
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
