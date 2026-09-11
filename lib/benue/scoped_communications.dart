import 'package:flutter/material.dart';

import 'app_scope.dart';
import 'communications_page.dart';
import 'domain/records_store.dart';
import 'widgets.dart';

class ScopedCommunicationsPage extends StatelessWidget {
  const ScopedCommunicationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final scope = CampaignScope.of(context);
    final records = CampaignRecords.of(context);
    final incidents = records.incidentsFor(scope.lgaId);
    final tasks = records.tasksFor(scope.lgaId);
    final lga = scope.lgaName;

    return Column(
      children: [
        _CommunicationsContextBar(
          title: lga == null
              ? 'Statewide Communications'
              : '$lga Campaign Communications',
          detail: lga == null
              ? '${incidents.length} active incident conversations and ${tasks.length} campaign tasks are in the statewide command view.'
              : 'Campaign conversations, coordination and escalation for $lga LGA.',
          incidents: incidents.length,
          tasks: tasks.length,
        ),
        const Expanded(child: CommunicationsPage()),
      ],
    );
  }
}

class _CommunicationsContextBar extends StatelessWidget {
  const _CommunicationsContextBar({
    required this.title,
    required this.detail,
    required this.incidents,
    required this.tasks,
  });

  final String title;
  final String detail;
  final int incidents;
  final int tasks;

  @override
  Widget build(BuildContext context) => Container(
        width: double.infinity,
        margin: const EdgeInsets.fromLTRB(28, 18, 28, 0),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xFFEAF4ED),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFD5E7DA)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.chat_bubble_outline_rounded, color: pdpGreen),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(
                          color: ink,
                          fontWeight: FontWeight.w900,
                          fontSize: 16)),
                  const SizedBox(height: 3),
                  Text(detail,
                      style: const TextStyle(color: muted, height: 1.35)),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 7,
                    runSpacing: 7,
                    children: [
                      StatusPill('$incidents INCIDENTS', color: pdpRed),
                      StatusPill('$tasks TASKS', color: const Color(0xFF5E5CB2)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      );
}
