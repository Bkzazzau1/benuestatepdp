import 'package:flutter/material.dart';

import 'benue_app.dart';
import 'welcome_page.dart';
import 'widgets.dart';

/// Entry point for the PoliSphere prototype.
///
/// The welcome experience is intentionally separate from authentication:
/// Welcome -> role login -> role-specific command workspace.
class PoliSphereEntryApp extends StatefulWidget {
  const PoliSphereEntryApp({super.key});

  @override
  State<PoliSphereEntryApp> createState() => _PoliSphereEntryAppState();
}

class _PoliSphereEntryAppState extends State<PoliSphereEntryApp> {
  bool enteredCommandCentre = false;

  @override
  Widget build(BuildContext context) {
    if (enteredCommandCentre) {
      return const BenueCampaignApp();
    }

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'PoliSphere Benue — Welcome',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF4F6F4),
        colorScheme: ColorScheme.fromSeed(
          seedColor: pdpGreen,
          primary: pdpGreen,
          secondary: pdpRed,
          surface: Colors.white,
        ),
        fontFamily: 'Arial',
      ),
      home: CampaignWelcomePage(
        onEnter: () => setState(() => enteredCommandCentre = true),
      ),
    );
  }
}
