import 'package:flutter/material.dart';

import 'data.dart';
import 'widgets.dart';

class CleanMediaIntelligencePage extends StatelessWidget {
  const CleanMediaIntelligencePage({super.key});

  @override
  Widget build(BuildContext context) => ListView(
        padding: const EdgeInsets.all(28),
        children: [
          const PageHeading(
            title: 'Media Intelligence',
            subtitle:
                'Track public issues, campaign narratives, media coverage and response priorities.',
            trailing: StatusPill('MEDIA DESK'),
          ),
          const SizedBox(height: 18),
          LayoutBuilder(builder: (context, c) {
            final cols = c.maxWidth > 1000 ? 4 : c.maxWidth > 620 ? 2 : 1;
            const gap = 12.0;
            final width = (c.maxWidth - gap * (cols - 1)) / cols;
            const cards = [
              MetricCard(
                label: 'Public issues',
                value: '5',
                icon: Icons.public_outlined,
              ),
              MetricCard(
                label: 'Priority narratives',
                value: '0',
                icon: Icons.campaign_outlined,
              ),
              MetricCard(
                label: 'Claims under review',
                value: '0',
                icon: Icons.fact_check_outlined,
              ),
              MetricCard(
                label: 'Campaign responses',
                value: '0',
                icon: Icons.record_voice_over_outlined,
              ),
            ];
            return Wrap(
              spacing: gap,
              runSpacing: gap,
              children:
                  cards.map((card) => SizedBox(width: width, child: card)).toList(),
            );
          }),
          const SizedBox(height: 14),
          LayoutBuilder(builder: (context, c) {
            final wide = c.maxWidth > 930;
            const topics = _SupportPanel(
              title: 'Public issue monitor',
              subtitle: 'Issues receiving attention across Benue',
              children: [
                _IssueLine('Security', 'High attention', Icons.shield_outlined),
                _IssueLine('Cost of living', 'High attention', Icons.shopping_basket_outlined),
                _IssueLine('Agriculture', 'Monitor', Icons.agriculture_outlined),
                _IssueLine('Roads & infrastructure', 'Monitor', Icons.route_outlined),
                _IssueLine('Employment', 'Monitor', Icons.work_outline_rounded),
              ],
            );
            const verification = _SupportPanel(
              title: 'Narrative verification desk',
              subtitle: 'Review public claims before campaign action',
              children: [
                _VerificationLine('New claim', 'Capture the claim, source and context.', Color(0xFFD97706)),
                _VerificationLine('Reviewing', 'Compare available evidence and context.', Color(0xFF7C3AED)),
                _VerificationLine('Confirmed / False / Misleading', 'Record the conclusion and supporting sources.', pdpGreen),
                _VerificationLine('Unclear', 'Keep uncertainty visible when evidence is incomplete.', muted),
              ],
            );
            return wide
                ? const Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Expanded(child: topics),
                    SizedBox(width: 14),
                    Expanded(child: verification),
                  ])
                : const Column(children: [
                    topics,
                    SizedBox(height: 14),
                    verification,
                  ]);
          }),
          const SizedBox(height: 14),
          const _SupportPanel(
            title: 'Response workflow',
            subtitle: 'Move from public signal to coordinated campaign response',
            children: [
              _StepLine('1', 'Listen', 'Identify the issue or narrative.'),
              _StepLine('2', 'Check', 'Review the source, evidence and context.'),
              _StepLine('3', 'Decide', 'Choose whether a campaign response is needed.'),
              _StepLine('4', 'Respond', 'Coordinate the approved message and follow-up.'),
            ],
          ),
        ],
      );
}

class CleanCommunityIssuesPage extends StatelessWidget {
  const CleanCommunityIssuesPage({super.key});

  @override
  Widget build(BuildContext context) => ListView(
        padding: const EdgeInsets.all(28),
        children: [
          const PageHeading(
            title: 'Community Issues',
            subtitle:
                'Community concerns, engagement requests, commitments and follow-up across Benue State.',
            trailing: StatusPill('ISSUE REGISTER'),
          ),
          const SizedBox(height: 18),
          const _SupportPanel(
            title: 'Issue categories',
            subtitle: 'Recurring concerns to follow by geography and responsible campaign desk',
            children: [
              _IssueLine('Security & displacement', 'Very high', Icons.shield_outlined),
              _IssueLine('Agriculture & rural livelihoods', 'High', Icons.agriculture_outlined),
              _IssueLine('Roads & transport', 'High', Icons.route_outlined),
              _IssueLine('Healthcare', 'Medium', Icons.health_and_safety_outlined),
              _IssueLine('Education', 'Medium', Icons.school_outlined),
              _IssueLine('Employment & enterprise', 'High', Icons.work_outline_rounded),
            ],
          ),
          const SizedBox(height: 14),
          LayoutBuilder(builder: (context, c) {
            final wide = c.maxWidth > 930;
            final geography = _SupportPanel(
              title: 'Geographic coverage',
              subtitle: 'Community issue tracking across all 23 LGAs',
              children: [
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: benueLgas
                      .map((lga) => StatusPill(lga, color: const Color(0xFF5E5CB2)))
                      .toList(),
                ),
              ],
            );
            const requests = _SupportPanel(
              title: 'Request & commitment workflow',
              subtitle: 'Keep community requests and campaign commitments organized',
              children: [
                _StepLine('1', 'Capture', 'Record the request, location and key details.'),
                _StepLine('2', 'Assign', 'Send it to the responsible campaign desk.'),
                _StepLine('3', 'Decide', 'Record the next action and responsible officer.'),
                _StepLine('4', 'Follow up', 'Track progress until the matter is closed.'),
              ],
            );
            return wide
                ? Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Expanded(child: geography),
                    const SizedBox(width: 14),
                    const Expanded(child: requests),
                  ])
                : Column(children: [
                    geography,
                    const SizedBox(height: 14),
                    requests,
                  ]);
          }),
        ],
      );
}

class CleanReportsDocumentsPage extends StatelessWidget {
  const CleanReportsDocumentsPage({super.key});

  @override
  Widget build(BuildContext context) => ListView(
        padding: const EdgeInsets.all(28),
        children: [
          const PageHeading(
            title: 'Reports & Documents',
            subtitle:
                'Campaign briefs, operational reports, approved documents and reference material.',
            trailing: StatusPill('DOCUMENT CENTRE'),
          ),
          const SizedBox(height: 18),
          LayoutBuilder(builder: (context, c) {
            final wide = c.maxWidth > 930;
            const reports = _SupportPanel(
              title: 'Campaign reports',
              subtitle: 'Regular reports for campaign leadership',
              children: [
                _DocumentLine('Daily Situation Report', 'Incidents, operations and field updates'),
                _DocumentLine('LGA Readiness Report', 'Teams, coverage and logistics'),
                _DocumentLine('Election Intelligence Brief', 'Election history, factors and scenarios'),
                _DocumentLine('Media Intelligence Brief', 'Public issues, narratives and verification'),
                _DocumentLine('Election-Day Situation Report', 'Agents, incidents and result-capture progress'),
              ],
            );
            const documents = _SupportPanel(
              title: 'Campaign documents',
              subtitle: 'Important material for campaign teams',
              children: [
                _DocumentLine('Campaign Strategy', 'Leadership reference'),
                _DocumentLine('Field Operations Guide', 'Coordinator and field-team guidance'),
                _DocumentLine('Election-Day Guide', 'Agent and command-room guidance'),
                _DocumentLine('Media & Communications Guide', 'Messaging and response coordination'),
                _DocumentLine('Legal & Evidence Guide', 'Incident and evidence handling'),
              ],
            );
            return wide
                ? const Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Expanded(child: reports),
                    SizedBox(width: 14),
                    Expanded(child: documents),
                  ])
                : const Column(children: [
                    reports,
                    SizedBox(height: 14),
                    documents,
                  ]);
          }),
        ],
      );
}

class _SupportPanel extends StatelessWidget {
  const _SupportPanel({
    required this.title,
    required this.subtitle,
    required this.children,
  });
  final String title;
  final String subtitle;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) => SectionCard(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title,
              style: const TextStyle(color: ink, fontSize: 17, fontWeight: FontWeight.w900)),
          const SizedBox(height: 4),
          Text(subtitle, style: const TextStyle(color: muted, fontSize: 10.5, height: 1.35)),
          const SizedBox(height: 14),
          ...children,
        ]),
      );
}

class _IssueLine extends StatelessWidget {
  const _IssueLine(this.title, this.status, this.icon);
  final String title;
  final String status;
  final IconData icon;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 11),
        child: Row(children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: const Color(0xFFEAF4ED),
              borderRadius: BorderRadius.circular(11),
            ),
            child: Icon(icon, color: pdpGreen, size: 18),
          ),
          const SizedBox(width: 10),
          Expanded(child: Text(title,
              style: const TextStyle(color: ink, fontWeight: FontWeight.w800))),
          StatusPill(status),
        ]),
      );
}

class _VerificationLine extends StatelessWidget {
  const _VerificationLine(this.title, this.detail, this.color);
  final String title;
  final String detail;
  final Color color;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
            width: 8,
            height: 8,
            margin: const EdgeInsets.only(top: 5),
            decoration: BoxDecoration(shape: BoxShape.circle, color: color),
          ),
          const SizedBox(width: 10),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title, style: const TextStyle(color: ink, fontWeight: FontWeight.w900)),
            const SizedBox(height: 3),
            Text(detail, style: const TextStyle(color: muted, fontSize: 10.5, height: 1.35)),
          ])),
        ]),
      );
}

class _StepLine extends StatelessWidget {
  const _StepLine(this.number, this.title, this.detail);
  final String number;
  final String title;
  final String detail;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          CircleAvatar(
            radius: 17,
            backgroundColor: const Color(0xFFE6F3EA),
            child: Text(number,
                style: const TextStyle(color: pdpGreen, fontWeight: FontWeight.w900)),
          ),
          const SizedBox(width: 10),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title, style: const TextStyle(color: ink, fontWeight: FontWeight.w900)),
            const SizedBox(height: 3),
            Text(detail, style: const TextStyle(color: muted, fontSize: 10.5, height: 1.35)),
          ])),
        ]),
      );
}

class _DocumentLine extends StatelessWidget {
  const _DocumentLine(this.title, this.detail);
  final String title;
  final String detail;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFFF8FAF8),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFFE5EBE6)),
          ),
          child: Row(children: [
            const Icon(Icons.description_outlined, color: pdpGreen, size: 20),
            const SizedBox(width: 10),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(title, style: const TextStyle(color: ink, fontWeight: FontWeight.w800)),
              const SizedBox(height: 2),
              Text(detail, style: const TextStyle(color: muted, fontSize: 10.5)),
            ])),
            const Icon(Icons.chevron_right_rounded, color: muted),
          ]),
        ),
      );
}
