import 'package:flutter/material.dart';

import 'data.dart';
import 'widgets.dart';

class CampaignOperationsPage extends StatelessWidget {
  const CampaignOperationsPage({super.key});

  @override
  Widget build(BuildContext context) => ListView(
        padding: const EdgeInsets.all(28),
        children: [
          const PageHeading(
            title: 'Campaign Operations',
            subtitle:
                'State campaign structure, coordinators, activities, candidate movement, volunteers and execution tracking.',
            trailing: StatusPill('STATE CAMPAIGN'),
          ),
          const SizedBox(height: 18),
          const PrototypeBanner(),
          const SizedBox(height: 18),
          LayoutBuilder(builder: (context, c) {
            final cols = c.maxWidth > 1000 ? 4 : c.maxWidth > 620 ? 2 : 1;
            const gap = 12.0;
            final width = (c.maxWidth - gap * (cols - 1)) / cols;
            const cards = [
              MetricCard(
                  label: 'LGA coordination target',
                  value: '23',
                  icon: Icons.account_tree_outlined),
              MetricCard(
                  label: 'Ward coordination target',
                  value: '276',
                  icon: Icons.grid_view_rounded),
              MetricCard(
                  label: 'Polling-unit coverage target',
                  value: '5,102',
                  icon: Icons.how_to_vote_outlined),
              MetricCard(
                  label: 'Operational mode',
                  value: 'Setup',
                  icon: Icons.settings_suggest_outlined,
                  detail: 'Awaiting verified campaign roster'),
            ];
            return Wrap(
              spacing: gap,
              runSpacing: gap,
              children:
                  cards.map((e) => SizedBox(width: width, child: e)).toList(),
            );
          }),
          const SizedBox(height: 14),
          LayoutBuilder(builder: (context, c) {
            final wide = c.maxWidth > 930;
            final structure = SectionCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  _BlockTitle('Campaign command structure',
                      'Roles are configured by level, geography and permission.'),
                  SizedBox(height: 14),
                  _HierarchyRow('State Campaign Council',
                      'Candidate • DG • Situation Room • Operations • Legal • Media • Logistics'),
                  _HierarchyRow('LGA Coordinators',
                      '23 geographic commands with state-level escalation'),
                  _HierarchyRow('Ward Coordinators',
                      '276 ward-level coordination and reporting nodes'),
                  _HierarchyRow('Polling-Unit Agents',
                      'Election-day assignment and reporting layer'),
                  _HierarchyRow('Volunteers & Field Teams',
                      'Purpose-limited access to assigned campaign tasks'),
                ],
              ),
            );
            final activity = SectionCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  _BlockTitle('Activity command board',
                      'Prototype schedule until verified campaign calendar is connected.'),
                  SizedBox(height: 10),
                  _ActivityRow('Today', 'State operations review', 'HQ', 'Planning'),
                  _ActivityRow('Tomorrow', 'LGA coordination audit', 'Statewide', 'Operations'),
                  _ActivityRow('This week', 'Ward structure verification', '23 LGAs', 'Field'),
                  _ActivityRow('This week', 'Media response review', 'HQ', 'Communications'),
                ],
              ),
            );
            return wide
                ? Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Expanded(child: structure),
                    const SizedBox(width: 14),
                    Expanded(child: activity),
                  ])
                : Column(children: [
                    structure,
                    const SizedBox(height: 14),
                    activity,
                  ]);
          }),
          const SizedBox(height: 14),
          SectionCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                _BlockTitle('Candidate movement & engagement workflow',
                    'Plan, execute and close every candidate or surrogate engagement with evidence and follow-up.'),
                SizedBox(height: 14),
                _Workflow('1', 'Plan',
                    'Location, purpose, stakeholder group, logistics, media and security requirements.'),
                _Workflow('2', 'Authorize',
                    'Campaign leadership confirms owner, resources and communication plan.'),
                _Workflow('3', 'Execute',
                    'Field team checks in, records completion and submits structured updates.'),
                _Workflow('4', 'Close & follow up',
                    'Capture commitments, issues raised, media outputs and responsible follow-up team.'),
              ],
            ),
          ),
        ],
      );
}

class MediaIntelligencePage extends StatelessWidget {
  const MediaIntelligencePage({super.key});

  @override
  Widget build(BuildContext context) => ListView(
        padding: const EdgeInsets.all(28),
        children: [
          const PageHeading(
            title: 'Media Intelligence',
            subtitle:
                'Public-media monitoring, narrative verification, issue trends and response coordination using aggregate signals only.',
            trailing: StatusPill('PUBLIC SIGNALS'),
          ),
          const SizedBox(height: 18),
          const PrototypeBanner(),
          const SizedBox(height: 18),
          LayoutBuilder(builder: (context, c) {
            final cols = c.maxWidth > 1000 ? 4 : c.maxWidth > 620 ? 2 : 1;
            const gap = 12.0;
            final width = (c.maxWidth - gap * (cols - 1)) / cols;
            const cards = [
              MetricCard(
                  label: 'Public-source feeds',
                  value: 'Setup',
                  icon: Icons.public_outlined),
              MetricCard(
                  label: 'Verification queue',
                  value: '0',
                  icon: Icons.fact_check_outlined),
              MetricCard(
                  label: 'Critical narratives',
                  value: '0',
                  icon: Icons.crisis_alert_outlined),
              MetricCard(
                  label: 'Individual profiling',
                  value: 'Off',
                  icon: Icons.privacy_tip_outlined),
            ];
            return Wrap(
              spacing: gap,
              runSpacing: gap,
              children:
                  cards.map((e) => SizedBox(width: width, child: e)).toList(),
            );
          }),
          const SizedBox(height: 14),
          LayoutBuilder(builder: (context, c) {
            final wide = c.maxWidth > 930;
            final topics = SectionCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  _BlockTitle('Public issue monitor',
                      'Illustrative categories; production values require source-backed aggregation.'),
                  SizedBox(height: 14),
                  _SignalRow('Security', 'High salience', 'Evidence feed required'),
                  _SignalRow('Cost of living', 'High salience', 'Evidence feed required'),
                  _SignalRow('Agriculture', 'Monitor', 'Evidence feed required'),
                  _SignalRow('Roads & infrastructure', 'Monitor', 'Evidence feed required'),
                  _SignalRow('Employment', 'Monitor', 'Evidence feed required'),
                ],
              ),
            );
            final verification = SectionCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  _BlockTitle('Narrative verification desk',
                      'No public claim is promoted internally as fact before evidence review.'),
                  SizedBox(height: 12),
                  _VerificationState('Unverified',
                      'New claim received; source and context not yet established.',
                      Color(0xFFD68A00)),
                  _VerificationState('Investigating',
                      'Analyst checks primary sources and conflicting evidence.',
                      Color(0xFF6A5ACD)),
                  _VerificationState('Verified / False / Misleading',
                      'Human-reviewed conclusion stored with cited evidence.', pdpGreen),
                  _VerificationState('Insufficient evidence',
                      'No definitive conclusion; uncertainty remains visible.', muted),
                ],
              ),
            );
            return wide
                ? Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Expanded(child: topics),
                    const SizedBox(width: 14),
                    Expanded(child: verification),
                  ])
                : Column(children: [
                    topics,
                    const SizedBox(height: 14),
                    verification,
                  ]);
          }),
        ],
      );
}

class CommunityIssuesPage extends StatelessWidget {
  const CommunityIssuesPage({super.key});

  @override
  Widget build(BuildContext context) => ListView(
        padding: const EdgeInsets.all(28),
        children: [
          const PageHeading(
            title: 'Community Issues',
            subtitle:
                'Aggregate community concerns, engagement requests, commitments and follow-up across Benue State.',
            trailing: StatusPill('ISSUE REGISTER'),
          ),
          const SizedBox(height: 18),
          const PrototypeBanner(),
          const SizedBox(height: 18),
          SectionCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                _BlockTitle('Issue categories',
                    'Track recurring concerns by geography and source without profiling individual voters.'),
                SizedBox(height: 14),
                _IssueRow('Security & displacement', 'Statewide', 'Very high'),
                _IssueRow('Agriculture & rural livelihoods', 'Statewide', 'High'),
                _IssueRow('Roads & transport', 'LGA / ward', 'High'),
                _IssueRow('Healthcare', 'LGA / ward', 'Medium'),
                _IssueRow('Education', 'LGA / ward', 'Medium'),
                _IssueRow('Employment & enterprise', 'Statewide', 'High'),
              ],
            ),
          ),
          const SizedBox(height: 14),
          LayoutBuilder(builder: (context, c) {
            final wide = c.maxWidth > 930;
            final geography = SectionCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const _BlockTitle('Geographic coverage',
                      'Every LGA has an issue register and follow-up owner.'),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: benueLgas
                        .map((lga) => StatusPill(lga, color: const Color(0xFF5E5CB2)))
                        .toList(),
                  ),
                ],
              ),
            );
            final requests = SectionCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  _BlockTitle('Request & commitment workflow',
                      'Keep campaign requests and promises traceable.'),
                  SizedBox(height: 12),
                  _Workflow('1', 'Capture', 'Record request, source, geography and evidence.'),
                  _Workflow('2', 'Classify', 'Assign category, urgency and responsible campaign desk.'),
                  _Workflow('3', 'Decide', 'Authorized officer records decision and next action.'),
                  _Workflow('4', 'Follow up', 'Close only after outcome and supporting note are recorded.'),
                ],
              ),
            );
            return wide
                ? Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Expanded(child: geography),
                    const SizedBox(width: 14),
                    Expanded(child: requests),
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

class LogisticsTasksPage extends StatelessWidget {
  const LogisticsTasksPage({super.key});

  @override
  Widget build(BuildContext context) => ListView(
        padding: const EdgeInsets.all(28),
        children: [
          const PageHeading(
            title: 'Logistics & Tasks',
            subtitle:
                'Assets, campaign materials, transport, assignments, deadlines and escalation in one operational board.',
            trailing: StatusPill('OPERATIONS'),
          ),
          const SizedBox(height: 18),
          const PrototypeBanner(),
          const SizedBox(height: 18),
          LayoutBuilder(builder: (context, c) {
            final cols = c.maxWidth > 1000 ? 4 : c.maxWidth > 620 ? 2 : 1;
            const gap = 12.0;
            final width = (c.maxWidth - gap * (cols - 1)) / cols;
            const cards = [
              MetricCard(label: 'Open tasks', value: '0', icon: Icons.task_alt_outlined),
              MetricCard(label: 'Overdue tasks', value: '0', icon: Icons.timer_off_outlined),
              MetricCard(label: 'Registered assets', value: '0', icon: Icons.inventory_2_outlined),
              MetricCard(label: 'Distribution gaps', value: '0', icon: Icons.local_shipping_outlined),
            ];
            return Wrap(
              spacing: gap,
              runSpacing: gap,
              children:
                  cards.map((e) => SizedBox(width: width, child: e)).toList(),
            );
          }),
          const SizedBox(height: 14),
          LayoutBuilder(builder: (context, c) {
            final wide = c.maxWidth > 930;
            final assets = SectionCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  _BlockTitle('Asset registry',
                      'Track custodian, assignment, availability and condition.'),
                  SizedBox(height: 12),
                  _AssetRow('Vehicles', 'Transport & field mobility'),
                  _AssetRow('PA systems & generators', 'Campaign events'),
                  _AssetRow('Phones & laptops', 'Field and situation-room operations'),
                  _AssetRow('Campaign materials', 'State → LGA → ward distribution'),
                  _AssetRow('Election-day kits', 'Restricted readiness inventory'),
                ],
              ),
            );
            final tasks = SectionCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  _BlockTitle('Task workflow',
                      'Every instruction has an owner, deadline, geography and evidence of completion.'),
                  SizedBox(height: 12),
                  _TaskRow('Verify venue', 'Operations', 'Planned'),
                  _TaskRow('Confirm ward roster', 'Field Network', 'Planned'),
                  _TaskRow('Review logistics requirement', 'Logistics', 'Planned'),
                  _TaskRow('Prepare daily command brief', 'Situation Room', 'Planned'),
                ],
              ),
            );
            return wide
                ? Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Expanded(child: assets),
                    const SizedBox(width: 14),
                    Expanded(child: tasks),
                  ])
                : Column(children: [
                    assets,
                    const SizedBox(height: 14),
                    tasks,
                  ]);
          }),
        ],
      );
}

class ReportsDocumentsPage extends StatelessWidget {
  const ReportsDocumentsPage({super.key});

  @override
  Widget build(BuildContext context) => ListView(
        padding: const EdgeInsets.all(28),
        children: [
          const PageHeading(
            title: 'Reports & Documents',
            subtitle:
                'Command briefs, campaign reports, approved documents, evidence-backed exports and version-controlled reference material.',
            trailing: StatusPill('DOCUMENT CENTRE'),
          ),
          const SizedBox(height: 18),
          LayoutBuilder(builder: (context, c) {
            final wide = c.maxWidth > 930;
            final reports = SectionCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  _BlockTitle('Standard reports',
                      'Authorized users can generate these from verified operational data.'),
                  SizedBox(height: 12),
                  _DocumentRow('Daily Situation Report', 'Operations + incidents + field updates'),
                  _DocumentRow('LGA Readiness Report', 'Structure + agents + logistics'),
                  _DocumentRow('Election Intelligence Brief', 'History + factors + trend + uncertainty'),
                  _DocumentRow('Media Intelligence Brief', 'Public-source issues + verification'),
                  _DocumentRow('Election-Day Situation Report', 'Agents + incidents + unofficial capture status'),
                ],
              ),
            );
            final documents = SectionCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  _BlockTitle('Campaign document centre',
                      'Versioned material with role-based access.'),
                  SizedBox(height: 12),
                  _DocumentRow('Manifesto & policy documents', 'Approved campaign reference'),
                  _DocumentRow('Talking points', 'Version-controlled communications material'),
                  _DocumentRow('Press releases', 'Approved public statements'),
                  _DocumentRow('Training manuals', 'Field and election-agent guidance'),
                  _DocumentRow('Legal & compliance reference', 'Restricted authorized access'),
                ],
              ),
            );
            return wide
                ? Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Expanded(child: reports),
                    const SizedBox(width: 14),
                    Expanded(child: documents),
                  ])
                : Column(children: [
                    reports,
                    const SizedBox(height: 14),
                    documents,
                  ]);
          }),
          const SizedBox(height: 14),
          const SectionCard(
            child: _BlockTitle('Export rule',
                'Production exports must include generation time, source coverage, data-confidence notes and document version metadata.'),
          ),
        ],
      );
}

class _BlockTitle extends StatelessWidget {
  const _BlockTitle(this.title, this.subtitle);
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(fontWeight: FontWeight.w900, color: ink)),
          const SizedBox(height: 4),
          Text(subtitle,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: muted)),
        ],
      );
}

class _HierarchyRow extends StatelessWidget {
  const _HierarchyRow(this.title, this.detail);
  final String title;
  final String detail;

  @override
  Widget build(BuildContext context) => ListTile(
        contentPadding: EdgeInsets.zero,
        leading: const CircleAvatar(
          backgroundColor: Color(0xFFEAF5EE),
          child: Icon(Icons.account_tree_outlined, color: pdpGreen),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w900)),
        subtitle: Text(detail),
      );
}

class _ActivityRow extends StatelessWidget {
  const _ActivityRow(this.when, this.title, this.location, this.type);
  final String when;
  final String title;
  final String location;
  final String type;

  @override
  Widget build(BuildContext context) => ListTile(
        contentPadding: EdgeInsets.zero,
        leading: const Icon(Icons.event_note_outlined, color: pdpGreen),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w800)),
        subtitle: Text('$when • $location'),
        trailing: StatusPill(type, color: const Color(0xFF5E5CB2)),
      );
}

class _Workflow extends StatelessWidget {
  const _Workflow(this.number, this.title, this.detail);
  final String number;
  final String title;
  final String detail;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 14),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          CircleAvatar(
            backgroundColor: pdpGreen,
            foregroundColor: Colors.white,
            child: Text(number,
                style: const TextStyle(fontWeight: FontWeight.w900)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontWeight: FontWeight.w900, fontSize: 16)),
                const SizedBox(height: 3),
                Text(detail, style: const TextStyle(color: muted)),
              ],
            ),
          ),
        ]),
      );
}

class _SignalRow extends StatelessWidget {
  const _SignalRow(this.topic, this.status, this.sourceState);
  final String topic;
  final String status;
  final String sourceState;

  @override
  Widget build(BuildContext context) => ListTile(
        contentPadding: EdgeInsets.zero,
        leading: const Icon(Icons.insights_outlined, color: pdpGreen),
        title: Text(topic, style: const TextStyle(fontWeight: FontWeight.w800)),
        subtitle: Text(sourceState),
        trailing: StatusPill(status, color: const Color(0xFFD68A00)),
      );
}

class _VerificationState extends StatelessWidget {
  const _VerificationState(this.title, this.detail, this.color);
  final String title;
  final String detail;
  final Color color;

  @override
  Widget build(BuildContext context) => ListTile(
        contentPadding: EdgeInsets.zero,
        leading: Icon(Icons.circle, size: 13, color: color),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w900)),
        subtitle: Text(detail),
      );
}

class _IssueRow extends StatelessWidget {
  const _IssueRow(this.issue, this.scope, this.priority);
  final String issue;
  final String scope;
  final String priority;

  @override
  Widget build(BuildContext context) => ListTile(
        contentPadding: EdgeInsets.zero,
        leading: const CircleAvatar(
          backgroundColor: Color(0xFFEAF5EE),
          child: Icon(Icons.forum_outlined, color: pdpGreen),
        ),
        title: Text(issue, style: const TextStyle(fontWeight: FontWeight.w800)),
        subtitle: Text(scope),
        trailing: StatusPill(priority, color: const Color(0xFFD68A00)),
      );
}

class _AssetRow extends StatelessWidget {
  const _AssetRow(this.asset, this.use);
  final String asset;
  final String use;

  @override
  Widget build(BuildContext context) => ListTile(
        contentPadding: EdgeInsets.zero,
        leading: const Icon(Icons.inventory_2_outlined, color: pdpGreen),
        title: Text(asset, style: const TextStyle(fontWeight: FontWeight.w800)),
        subtitle: Text(use),
        trailing: const StatusPill('Registry'),
      );
}

class _TaskRow extends StatelessWidget {
  const _TaskRow(this.title, this.owner, this.status);
  final String title;
  final String owner;
  final String status;

  @override
  Widget build(BuildContext context) => ListTile(
        contentPadding: EdgeInsets.zero,
        leading: const Icon(Icons.task_alt_outlined, color: pdpGreen),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w800)),
        subtitle: Text(owner),
        trailing: StatusPill(status, color: const Color(0xFF5E5CB2)),
      );
}

class _DocumentRow extends StatelessWidget {
  const _DocumentRow(this.title, this.detail);
  final String title;
  final String detail;

  @override
  Widget build(BuildContext context) => ListTile(
        contentPadding: EdgeInsets.zero,
        leading: const Icon(Icons.description_outlined, color: pdpGreen),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w800)),
        subtitle: Text(detail),
        trailing: const Icon(Icons.chevron_right_rounded, color: muted),
      );
}
