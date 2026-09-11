import 'package:flutter/material.dart';

import 'app_scope.dart';
import 'communications_page.dart';
import 'widgets.dart';

class ScopedCommunicationsPage extends StatelessWidget {
  const ScopedCommunicationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final scope = CampaignScope.of(context);
    final lga = scope.lgaName;

    if (lga == null) return const CommunicationsPage();

    return Column(
      children: [
        Container(
          width: double.infinity,
          margin: const EdgeInsets.fromLTRB(28, 18, 28, 0),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: const Color(0xFFEAF4ED),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFFD5E7DA)),
          ),
          child: Row(
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
                    Text('$lga Communications Context',
                        style: const TextStyle(
                            color: ink, fontWeight: FontWeight.w900, fontSize: 16)),
                    const SizedBox(height: 3),
                    Text(
                      '$lga Operations, $lga coordinator conversations and incident rooms inherit the active LGA scope. State Command channels remain available for escalation.',
                      style: const TextStyle(color: muted, height: 1.35),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              StatusPill('$lga LGA'),
            ],
          ),
        ),
        const Expanded(child: CommunicationsPage()),
      ],
    );
  }
}
