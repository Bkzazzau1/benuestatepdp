import 'package:flutter/material.dart';
import 'package:polisphere/src/theme/app_theme.dart';
import 'package:polisphere/src/widgets/common.dart';

class ReportsPage extends StatelessWidget {
  const ReportsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 30),
      children: [
        Text('My reports', style: Theme.of(context).textTheme.headlineMedium),
        const SizedBox(height: 5),
        const Text('Track every submission and verification decision.'),
        const SizedBox(height: 20),
        const SearchBar(
          hintText: 'Search report ID or category',
          leading: Icon(Icons.search_rounded),
          elevation: WidgetStatePropertyAll(0),
          side: WidgetStatePropertyAll(
            BorderSide(color: AppColors.border),
          ),
        ),
        const SizedBox(height: 18),
        const _ReportCard(
          id: 'RPT-2027-00182',
          title: 'Routine polling-unit status',
          detail: 'Today · 9:42 AM',
          status: 'VERIFIED',
          color: AppColors.green,
          icon: Icons.description_outlined,
        ),
        const SizedBox(height: 12),
        const _ReportCard(
          id: 'RPT-2027-00179',
          title: 'Community activity update',
          detail: 'Yesterday · 4:18 PM',
          status: 'UNDER REVIEW',
          color: AppColors.amber,
          icon: Icons.description_outlined,
        ),
        const SizedBox(height: 12),
        const _ReportCard(
          id: 'LOCAL-DRAFT-03',
          title: 'Evening situation report',
          detail: 'Saved on this device',
          status: 'DRAFT',
          color: AppColors.muted,
          icon: Icons.edit_note_rounded,
        ),
      ],
    );
  }
}

class _ReportCard extends StatelessWidget {
  const _ReportCard({
    required this.id,
    required this.title,
    required this.detail,
    required this.status,
    required this.color,
    required this.icon,
  });

  final String id;
  final String title;
  final String detail;
  final String status;
  final Color color;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(17),
        child: Row(children: [
          Container(
            width: 45,
            height: 45,
            decoration: BoxDecoration(
              color: color.withValues(alpha: .1),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: color),
          ),
          const SizedBox(width: 13),
          Expanded(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Expanded(
                  child: Text(id,
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                      )),
                ),
                StatusPill(status, color: color),
              ]),
              const SizedBox(height: 7),
              Text(title,
                  style: const TextStyle(
                    color: AppColors.navy,
                    fontWeight: FontWeight.w700,
                  )),
              const SizedBox(height: 4),
              Text(detail, style: const TextStyle(fontSize: 12)),
            ]),
          ),
        ]),
      ),
    );
  }
}
