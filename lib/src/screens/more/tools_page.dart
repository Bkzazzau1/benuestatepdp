import 'package:flutter/material.dart';
import 'package:polisphere/src/auth/session.dart';
import 'package:polisphere/src/theme/app_theme.dart';
import 'package:polisphere/src/widgets/common.dart';

class ToolsPage extends StatelessWidget {
  const ToolsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 30),
      children: [
        Text('Operations', style: Theme.of(context).textTheme.headlineMedium),
        const SizedBox(height: 5),
        const Text('Secure tools available for your assigned role.'),
        const SizedBox(height: 22),
        Card(
          child: Column(children: const [
            _ToolTile(
              Icons.camera_alt_outlined,
              'Evidence center',
              'Photos, video, audio, documents',
            ),
            Divider(height: 1, indent: 62),
            _ToolTile(
              Icons.lock_outline_rounded,
              'Secure communications',
              'Calls and approved media requests',
            ),
            Divider(height: 1, indent: 62),
            _ToolTile(
              Icons.school_outlined,
              'Training',
              'Field and device-security guidance',
            ),
            Divider(height: 1, indent: 62),
            _ToolTile(
              Icons.sync_rounded,
              'Offline queue',
              '0 records waiting to synchronize',
            ),
          ]),
        ),
        const SizedBox(height: 22),
        _SosCard(onTap: () => _showSos(context)),
        const SizedBox(height: 22),
        const SectionTitle('Account'),
        const SizedBox(height: 10),
        Card(
          child: Column(children: const [
            _ToolTile(
              Icons.person_outline_rounded,
              'Agent profile',
              'AGT-00482 · Verified',
            ),
            Divider(height: 1, indent: 62),
            _ToolTile(
              Icons.security_rounded,
              'Security & sessions',
              'This device is authorized',
            ),
            Divider(height: 1, indent: 62),
            _ToolTile(
              Icons.help_outline_rounded,
              'Help & support',
              'Contact your coordinator',
            ),
          ]),
        ),
        const SizedBox(height: 22),
        Card(
          child: ListTile(
            onTap: () => SessionScope.of(context).signOut(),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
            leading: const Icon(Icons.logout_rounded, color: AppColors.red),
            title: const Text('Sign out',
                style: TextStyle(
                    fontWeight: FontWeight.w700, color: AppColors.red)),
          ),
        ),
      ],
    );
  }

  void _showSos(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (context) => Padding(
        padding: const EdgeInsets.fromLTRB(24, 8, 24, 28),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          const Icon(Icons.sos_rounded, color: AppColors.red, size: 52),
          const SizedBox(height: 12),
          Text(
            'Activate emergency SOS?',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          const Text(
            'This creates a critical alert and shares your current GPS with '
            'authorized Situation Room operators.',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              style: FilledButton.styleFrom(backgroundColor: AppColors.red),
              onPressed: () => Navigator.pop(context),
              child: const Text('Hold to activate'),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ]),
      ),
    );
  }
}

class _ToolTile extends StatelessWidget {
  const _ToolTile(this.icon, this.title, this.subtitle);

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) => ListTile(
        onTap: () {},
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
        leading: Icon(icon, color: AppColors.blue),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
        subtitle: Text(subtitle, style: const TextStyle(fontSize: 12)),
        trailing: const Icon(Icons.chevron_right_rounded),
      );
}

class _SosCard extends StatelessWidget {
  const _SosCard({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Card(
        color: AppColors.red,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: const Padding(
            padding: EdgeInsets.all(18),
            child: Row(children: [
              Icon(Icons.sos_rounded, color: Colors.white, size: 34),
              SizedBox(width: 14),
              Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Emergency SOS',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                          )),
                      SizedBox(height: 3),
                      Text('Alert the Situation Room and share GPS',
                          style:
                              TextStyle(color: Colors.white70, fontSize: 12)),
                    ]),
              ),
              Icon(Icons.chevron_right_rounded, color: Colors.white),
            ]),
          ),
        ),
      );
}
