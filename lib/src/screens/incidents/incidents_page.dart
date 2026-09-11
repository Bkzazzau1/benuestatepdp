import 'package:flutter/material.dart';
import 'package:polisphere/src/screens/incidents/new_incident_page.dart';
import 'package:polisphere/src/theme/app_theme.dart';
import 'package:polisphere/src/widgets/common.dart';

class IncidentsPage extends StatelessWidget {
  const IncidentsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 30),
      children: [
        Row(children: [
          Expanded(
            child: Text(
              'Incidents',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ),
          FilledButton.tonalIcon(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute<void>(
                builder: (_) => const NewIncidentPage(),
              ),
            ),
            icon: const Icon(Icons.add_rounded),
            label: const Text('Report'),
          ),
        ]),
        const SizedBox(height: 5),
        const Text('Monitor incidents linked to your assignment.'),
        const SizedBox(height: 22),
        const _IncidentCard(
          id: 'INC-2027-00418',
          title: 'Access disruption near polling unit',
          location: 'Kwarbai \'A\' · 0.4 km away',
          status: 'UNDER REVIEW',
          severity: 'HIGH',
          color: AppColors.red,
        ),
        const SizedBox(height: 12),
        const _IncidentCard(
          id: 'INC-2027-00396',
          title: 'Temporary communication loss',
          location: 'Gyallesu · Resolved yesterday',
          status: 'RESOLVED',
          severity: 'MEDIUM',
          color: AppColors.green,
        ),
      ],
    );
  }
}

class _IncidentCard extends StatelessWidget {
  const _IncidentCard({
    required this.id,
    required this.title,
    required this.location,
    required this.status,
    required this.severity,
    required this.color,
  });

  final String id;
  final String title;
  final String location;
  final String status;
  final String severity;
  final Color color;

  @override
  Widget build(BuildContext context) => Card(
        child: Padding(
          padding: const EdgeInsets.all(17),
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
              StatusPill(severity, color: color),
            ]),
            const SizedBox(height: 12),
            Text(title,
                style: const TextStyle(
                  color: AppColors.navy,
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                )),
            const SizedBox(height: 8),
            Row(children: [
              const Icon(
                Icons.location_on_outlined,
                size: 16,
                color: AppColors.muted,
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Text(location, style: const TextStyle(fontSize: 12)),
              ),
            ]),
            const SizedBox(height: 14),
            Row(children: [
              StatusPill(
                status,
                color: status == 'RESOLVED' ? AppColors.green : AppColors.amber,
              ),
              const Spacer(),
              TextButton(
                onPressed: () {},
                child: const Text('Open timeline'),
              ),
            ]),
          ]),
        ),
      );
}
