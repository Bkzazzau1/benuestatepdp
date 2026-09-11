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
    final lga = scope.lgaName;
    final incidents = records.incidentsFor(scope.lgaId);
    final tasks = records.tasksFor(scope.lgaId);

    if (lga == null) {
      return Column(
        children: [
          _RecordsContextBar(
            title: 'Statewide Communications Context',
            detail:
                '${incidents.length} incident rooms and ${tasks.length} operational tasks are available in the shared statewide record model.',
            incidentId: incidents.isEmpty ? null : incidents.first.id,
            roomId: incidents.isEmpty ? null : incidents.first.conversationId,
          ),
          const Expanded(child: CommunicationsPage()),
        ],
      );
    }

    final primaryIncident = incidents.isEmpty ? null : incidents.first;
    return Column(
      children: [
        _RecordsContextBar(
          title: '$lga Communications Context',
          detail:
              '$lga conversations inherit ${scope.lgaId}. Incident rooms, tasks and reports now resolve through the same shared record IDs; State Command remains available for escalation.',
          incidentId: primaryIncident?.id,
          roomId: primaryIncident?.conversationId,
        ),
        const Expanded(child: CommunicationsPage()),
      ],
    );
  }
}

class _RecordsContextBar extends StatelessWidget {
  const _RecordsContextBar({
    required this.title,
    required this.detail,
    required this.incidentId,
    required this.roomId,
  });

  final String title;
  final String detail;
  final String? incidentId;
  final String? roomId;

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
                  if (incidentId != null) ...[
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 7,
                      runSpacing: 7,
                      children: [
                        StatusPill(incidentId!, color: pdpRed),
                        if (roomId != null)
                          StatusPill(roomId!, color: const Color(0xFF5E5CB2)),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      );
}
