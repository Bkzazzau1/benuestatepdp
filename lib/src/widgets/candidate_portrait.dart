import 'package:flutter/material.dart';
import 'package:polisphere/src/theme/app_theme.dart';

/// The candidate's portrait, presented as a formal seal/medallion: a thin
/// bronze ring, a beveled emerald field, and a laurel motif — not a photo
/// frame in the tech-dashboard sense.
///
/// No photo is wired in yet — until one is provided, this renders a
/// monogram placeholder. Once an image asset is added (declared under
/// `flutter/assets` in pubspec.yaml), pass it via [image], e.g.
/// `CandidatePortrait(image: AssetImage('assets/images/candidate.jpg'))`.
class CandidatePortrait extends StatelessWidget {
  const CandidatePortrait({super.key, this.size = 140, this.image});
  final double size;
  final ImageProvider? image;

  @override
  Widget build(BuildContext context) => SizedBox(
        width: size,
        height: size,
        child: Stack(alignment: Alignment.center, children: [
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                  color: AppColors.bronzeLight.withValues(alpha: .55),
                  width: size * .012),
            ),
          ),
          Container(
            width: size * .9,
            height: size * .9,
            padding: EdgeInsets.all(size * .045),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [AppColors.bronzeLight, AppColors.bronze],
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.emeraldDeep.withValues(alpha: .5),
                  blurRadius: size * .18,
                  offset: Offset(0, size * .05),
                ),
              ],
            ),
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.emerald,
                image: image == null
                    ? null
                    : DecorationImage(image: image!, fit: BoxFit.cover),
                border: Border.all(
                    color: AppColors.emeraldDeep, width: size * .012),
              ),
              alignment: Alignment.center,
              child: image != null
                  ? null
                  : Text('SID',
                      style: TextStyle(
                          fontFamily: 'Georgia', fontFamilyFallback: const ['Times New Roman', 'serif'],
                          color: AppColors.ivory,
                          fontWeight: FontWeight.w700,
                          fontSize: size * .22,
                          letterSpacing: 2)),
            ),
          ),
          Positioned(
            top: size * .02,
            child: Icon(Icons.star_rounded,
                color: AppColors.bronzeLight.withValues(alpha: .85),
                size: size * .12),
          ),
        ]),
      );
}
