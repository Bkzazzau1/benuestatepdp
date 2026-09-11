import 'package:flutter/material.dart';
import 'package:polisphere/src/screens/incidents/new_incident_page.dart';
import 'package:polisphere/src/screens/reports/new_report_page.dart';
import 'package:polisphere/src/theme/app_theme.dart';
import 'package:polisphere/src/widgets/candidate_portrait.dart';
import 'package:polisphere/src/widgets/common.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(18, 14, 18, 100),
      children: [
        const _BrandBar(),
        const SizedBox(height: 25),
        const Text('Good morning,', style: TextStyle(color: AppColors.muted)),
        const SizedBox(height: 3),
        Text('Amina Yusuf', style: Theme.of(context).textTheme.headlineMedium),
        const SizedBox(height: 18),
        const _AssignmentCard(),
        const SizedBox(height: 25),
        const SectionTitle('Quick actions'),
        const SizedBox(height: 12),
        const _QuickActions(),
        const SizedBox(height: 22),
        const _SyncCard(),
        const SizedBox(height: 25),
        const SectionTitle('Recent activity', action: 'View all'),
        const SizedBox(height: 10),
        const _RecentActivity(),
      ],
    );
  }
}

class _BrandBar extends StatelessWidget {
  const _BrandBar();

  @override
  Widget build(BuildContext context) => Row(children: [
        const CandidatePortrait(size: 42),
        const SizedBox(width: 12),
        const Expanded(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('HON. SULEIMAN IBRAHIM DABO',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontFamily: 'Georgia', fontFamilyFallback: ['Times New Roman', 'serif'],
                  color: AppColors.emerald,
                  fontWeight: FontWeight.w700,
                  letterSpacing: .6,
                )),
            Text('FIELD OPERATIONS',
                style: TextStyle(
                  color: AppColors.muted,
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.1,
                )),
          ]),
        ),
        const StatusPill(
          'ONLINE',
          color: AppColors.green,
          icon: Icons.cloud_done_outlined,
        ),
        IconButton(
          onPressed: () {},
          icon: const Badge(
            label: Text('3'),
            child: Icon(Icons.notifications_none_rounded, color: AppColors.emerald),
          ),
        ),
      ]);
}

class _AssignmentCard extends StatelessWidget {
  const _AssignmentCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.emerald, AppColors.emeraldDeep],
        ),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.bronzeLight.withValues(alpha: .3)),
        boxShadow: [
          BoxShadow(
            color: AppColors.emeraldDeep.withValues(alpha: .35),
            blurRadius: 22,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Text('CURRENT ASSIGNMENT',
              style: TextStyle(
                color: AppColors.ivory.withValues(alpha: .55),
                fontSize: 11,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.1,
              )),
          const Spacer(),
          const StatusPill('ACTIVE', color: AppColors.bronzeLight),
        ]),
        const SizedBox(height: 18),
        const Text('Polling Unit 014',
            style: TextStyle(
              fontFamily: 'Georgia', fontFamilyFallback: ['Times New Roman', 'serif'],
              color: AppColors.ivory,
              fontSize: 23,
              fontWeight: FontWeight.w700,
            )),
        const SizedBox(height: 5),
        Text(
          "Kwarbai 'A' · Zaria LGA",
          style: TextStyle(color: AppColors.ivory.withValues(alpha: .68)),
        ),
        const SizedBox(height: 18),
        Row(children: [
          const Icon(
            Icons.location_on_outlined,
            color: AppColors.bronzeLight,
            size: 19,
          ),
          const SizedBox(width: 7),
          Expanded(
            child: Text(
              'Location verified · 12 m accuracy',
              style: TextStyle(
                  color: AppColors.ivory.withValues(alpha: .68), fontSize: 12),
            ),
          ),
          TextButton(
            onPressed: () {},
            style: TextButton.styleFrom(foregroundColor: AppColors.bronzeLight),
            child: const Text('View map'),
          ),
        ]),
      ]),
    );
  }
}

class _QuickActions extends StatelessWidget {
  const _QuickActions();

  @override
  Widget build(BuildContext context) {
    final actions = <(String, IconData, Color, VoidCallback)>[
      (
        'Submit report',
        Icons.assignment_add,
        AppColors.emerald,
        () => Navigator.push(
              context,
              MaterialPageRoute<void>(builder: (_) => const NewReportPage()),
            ),
      ),
      (
        'Report incident',
        Icons.warning_amber_rounded,
        AppColors.copper,
        () => Navigator.push(
              context,
              MaterialPageRoute<void>(builder: (_) => const NewIncidentPage()),
            ),
      ),
      ('Capture evidence', Icons.camera_alt_outlined, AppColors.sage, () {}),
      (
        'Secure call',
        Icons.lock_outline_rounded,
        AppColors.maroon,
        () {},
      ),
    ];
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: actions.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisExtent: 104,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemBuilder: (_, index) {
        final action = actions[index];
        return Card(
          child: InkWell(
            onTap: action.$4,
            borderRadius: BorderRadius.circular(20),
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: action.$3.withValues(alpha: .1),
                      borderRadius: BorderRadius.circular(11),
                    ),
                    child: Icon(action.$2, color: action.$3, size: 20),
                  ),
                  Text(action.$1,
                      style: const TextStyle(
                        color: AppColors.navy,
                        fontWeight: FontWeight.w700,
                      )),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _SyncCard extends StatelessWidget {
  const _SyncCard();

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: AppColors.emerald.withValues(alpha: .06),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.emerald.withValues(alpha: .14)),
        ),
        child: const Row(children: [
          Icon(Icons.sync_rounded, color: AppColors.emerald),
          SizedBox(width: 12),
          Expanded(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('All records synchronized',
                  style: TextStyle(
                    color: AppColors.navy,
                    fontWeight: FontWeight.w700,
                  )),
              SizedBox(height: 2),
              Text('Last sync 2 minutes ago', style: TextStyle(fontSize: 12)),
            ]),
          ),
          StatusPill('0 QUEUED', color: AppColors.emerald),
        ]),
      );
}

class _RecentActivity extends StatelessWidget {
  const _RecentActivity();

  @override
  Widget build(BuildContext context) => Card(
        child: Column(children: const [
          _ActivityTile(
            icon: Icons.check_circle_outline_rounded,
            color: AppColors.green,
            title: 'Situation report verified',
            detail: 'RPT-2027-00182 · 24 minutes ago',
            status: 'VERIFIED',
          ),
          Divider(height: 1, indent: 64),
          _ActivityTile(
            icon: Icons.schedule_rounded,
            color: AppColors.amber,
            title: 'Ward check-in due',
            detail: 'Complete before 12:00 PM',
            status: 'DUE SOON',
          ),
        ]),
      );
}

class _ActivityTile extends StatelessWidget {
  const _ActivityTile({
    required this.icon,
    required this.color,
    required this.title,
    required this.detail,
    required this.status,
  });

  final IconData icon;
  final Color color;
  final String title;
  final String detail;
  final String status;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.all(15),
        child: Row(children: [
          CircleAvatar(
            backgroundColor: color.withValues(alpha: .1),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(title,
                  style: const TextStyle(
                    color: AppColors.navy,
                    fontWeight: FontWeight.w700,
                  )),
              const SizedBox(height: 3),
              Text(detail, style: const TextStyle(fontSize: 12)),
            ]),
          ),
          StatusPill(status, color: color),
        ]),
      );
}
