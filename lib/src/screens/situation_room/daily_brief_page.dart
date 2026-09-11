part of 'situation_room_page.dart';

class _DailyBriefPage extends StatefulWidget {
  const _DailyBriefPage();
  @override
  State<_DailyBriefPage> createState() => _DailyBriefPageState();
}

class _DailyBriefPageState extends State<_DailyBriefPage> {
  String _edition = 'Current draft';
  bool _reviewMode = true;
  bool _approved = false;

  @override
  Widget build(BuildContext context) => Column(children: [
        _DailyBriefHeader(
            edition: _edition,
            reviewMode: _reviewMode,
            approved: _approved,
            onEdition: (v) => setState(() => _edition = v!),
            onReviewMode: () => setState(() => _reviewMode = !_reviewMode),
            onApprove: _approve),
        Expanded(
            child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(children: [
                  _ExecutiveSummary(approved: _approved),
                  const SizedBox(height: 15),
                  const _BriefKpis(),
                  const SizedBox(height: 15),
                  const Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                            flex: 7,
                            child: Column(children: [
                              _PriorityBriefing(),
                              SizedBox(height: 15),
                              _OperationalTimeline(),
                              SizedBox(height: 15),
                              _WardReadiness(),
                            ])),
                        SizedBox(width: 15),
                        Expanded(
                            flex: 4,
                            child: Column(children: [
                              _BriefReviewStatus(),
                              SizedBox(height: 15),
                              _AiBriefInsights(),
                              SizedBox(height: 15),
                              _BriefSources(),
                            ])),
                      ]),
                  const SizedBox(height: 15),
                  const Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(child: _VerificationPerformance()),
                        SizedBox(width: 15),
                        Expanded(child: _SocialBrief()),
                      ]),
                  const SizedBox(height: 15),
                  _BriefFooter(approved: _approved),
                ]))),
      ]);

  void _approve() {
    final controller = TextEditingController();
    showDialog<void>(
        context: context,
        builder: (_) => AlertDialog(
              title: const Row(children: [
                Icon(Icons.approval_outlined, color: AppColors.green),
                SizedBox(width: 10),
                Text('Approve command brief')
              ]),
              content: SizedBox(
                  width: 490,
                  child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const InfoNotice(
                            'Approval freezes this edition, records the reviewer and preserves its cited source snapshot. Later changes create a new version.'),
                        const SizedBox(height: 14),
                        TextField(
                            controller: controller,
                            minLines: 2,
                            maxLines: 4,
                            decoration: const InputDecoration(
                                labelText: 'Approval note (required)',
                                alignLabelWithHint: true)),
                        const SizedBox(height: 10),
                        const Row(children: [
                          Icon(Icons.source_outlined,
                              color: AppColors.blue, size: 15),
                          SizedBox(width: 6),
                          Expanded(
                              child: Text(
                                  '36 operational records and 12 public-source records attached.',
                                  style: TextStyle(fontSize: 9)))
                        ]),
                      ])),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel')),
                FilledButton.icon(
                    onPressed: () {
                      if (controller.text.trim().isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('An approval note is required')));
                        return;
                      }
                      setState(() => _approved = true);
                      Navigator.pop(context);
                    },
                    style: FilledButton.styleFrom(
                        backgroundColor: AppColors.green),
                    icon: const Icon(Icons.verified_rounded),
                    label: const Text('Approve brief'))
              ],
            ));
  }
}

class _DailyBriefHeader extends StatelessWidget {
  const _DailyBriefHeader(
      {required this.edition,
      required this.reviewMode,
      required this.approved,
      required this.onEdition,
      required this.onReviewMode,
      required this.onApprove});
  final String edition;
  final bool reviewMode, approved;
  final ValueChanged<String?> onEdition;
  final VoidCallback onReviewMode, onApprove;
  @override
  Widget build(BuildContext context) => Container(
      padding: const EdgeInsets.fromLTRB(24, 18, 24, 16),
      decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(bottom: BorderSide(color: AppColors.border))),
      child: Row(children: [
        Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
                gradient: const LinearGradient(
                    colors: [AppColors.navy, Color(0xFF7657C8)]),
                borderRadius: BorderRadius.circular(14),
                boxShadow: const [
                  BoxShadow(
                      color: Color(0x33101D32),
                      blurRadius: 16,
                      offset: Offset(0, 6))
                ]),
            child:
                const Icon(Icons.auto_awesome_outlined, color: Colors.white)),
        const SizedBox(width: 13),
        Expanded(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Daily command brief',
              style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 3),
          const Text(
              '24-hour operational intelligence • 04 September 2026 • 18:00 edition',
              overflow: TextOverflow.ellipsis)
        ])),
        _FilterDropdown(
            edition,
            const ['Current draft', '12:00 edition', 'Previous day'],
            Icons.history_rounded,
            onEdition),
        const SizedBox(width: 8),
        OutlinedButton.icon(
            onPressed: onReviewMode,
            icon: Icon(
                reviewMode
                    ? Icons.rate_review_outlined
                    : Icons.visibility_outlined,
                size: 17),
            label: Text(reviewMode ? 'Review mode' : 'Reading mode')),
        const SizedBox(width: 8),
        FilledButton.icon(
            onPressed: approved ? null : onApprove,
            style: FilledButton.styleFrom(backgroundColor: AppColors.green),
            icon: Icon(
                approved ? Icons.verified_rounded : Icons.approval_outlined,
                size: 17),
            label: Text(approved ? 'Approved' : 'Approve brief')),
      ]));
}

class _ExecutiveSummary extends StatelessWidget {
  const _ExecutiveSummary({required this.approved});
  final bool approved;
  @override
  Widget build(BuildContext context) => Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
          gradient: const LinearGradient(
              colors: [Color(0xFF101D32), Color(0xFF1A3A5D), Color(0xFF225776)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight),
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(
                color: Color(0x33101D32), blurRadius: 24, offset: Offset(0, 10))
          ]),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          const Icon(Icons.summarize_rounded,
              color: Color(0xFF69D9E2), size: 20),
          const SizedBox(width: 8),
          const Text('EXECUTIVE SUMMARY',
              style: TextStyle(
                  color: Colors.white70,
                  fontSize: 10,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1)),
          const Spacer(),
          StatusPill(approved ? 'APPROVED' : 'AI DRAFT • REVIEW REQUIRED',
              color:
                  approved ? const Color(0xFF58D6B1) : const Color(0xFFFFC66D),
              icon: approved
                  ? Icons.verified_rounded
                  : Icons.auto_awesome_rounded)
        ]),
        const SizedBox(height: 14),
        const Text(
            'Operations remain stable across 12 of 13 active wards. Four critical incidents require command attention, led by a verified access disruption in Kwarbai \'A\'. Field connectivity is improving, while two units remain without recent agent contact.',
            style: TextStyle(
                color: Colors.white,
                fontSize: 17,
                height: 1.48,
                fontWeight: FontWeight.w700)),
        const SizedBox(height: 15),
        const Wrap(spacing: 8, runSpacing: 8, children: [
          StatusPill('4 CRITICAL INCIDENTS', color: Color(0xFFFF7777)),
          StatusPill('12 PENDING VERIFICATION', color: Color(0xFFFFC66D)),
          StatusPill('184 AGENTS ONLINE', color: Color(0xFF58D6B1)),
          StatusPill('36 CITED RECORDS', color: Color(0xFF70B5FF))
        ]),
      ]));
}

class _BriefKpis extends StatelessWidget {
  const _BriefKpis();
  @override
  Widget build(BuildContext context) => const Row(children: [
        Expanded(
            child: _EvidenceMetric(Icons.warning_amber_rounded, AppColors.red,
                '23', 'Open incidents', '4 critical')),
        SizedBox(width: 10),
        Expanded(
            child: _EvidenceMetric(Icons.fact_check_outlined, AppColors.green,
                '86', 'Reports verified', '94% within SLA')),
        SizedBox(width: 10),
        Expanded(
            child: _EvidenceMetric(Icons.perm_media_outlined, AppColors.blue,
                '142', 'Evidence received', '99.8% integrity')),
        SizedBox(width: 10),
        Expanded(
            child: _EvidenceMetric(Icons.groups_outlined, Color(0xFF7657C8),
                '89%', 'Agent availability', '22 offline/degraded')),
        SizedBox(width: 10),
        Expanded(
            child: _EvidenceMetric(Icons.headset_mic_outlined, AppColors.cyan,
                '96%', 'Comms health', '3 degraded')),
      ]);
}

class _PriorityBriefing extends StatelessWidget {
  const _PriorityBriefing();
  @override
  Widget build(BuildContext context) => _Panel(
      title: 'Command priorities',
      subtitle:
          'Issues requiring management attention in the next operating window',
      trailing: const StatusPill('4 PRIORITIES', color: AppColors.red),
      child: const Column(children: [
        _BriefPriority(
            '01',
            AppColors.red,
            'Resolve access disruption at PU-014',
            'Kwarbai \'A\' • INC-00518 • Commander: M. Bello',
            'Verified by 2 independent field sources • response in progress',
            '04:18 SLA'),
        Divider(height: 1),
        _BriefPriority(
            '02',
            AppColors.red,
            'Restore contact with Kaura East team',
            'Kaura • 2 agents unreachable',
            'Last successful sync 31 minutes ago • coordinator alerted',
            '08:42 SLA'),
        Divider(height: 1),
        _BriefPriority(
            '03',
            AppColors.amber,
            'Review conflicting material counts',
            'Tudun Wada • RPT-2026-00198',
            'Two source reports differ • photographic evidence available',
            '22:06 SLA'),
        Divider(height: 1),
        _BriefPriority(
            '04',
            AppColors.blue,
            'Complete evening ward check-ins',
            '1 of 13 wards awaiting checkpoint',
            'Automatic reminders issued • escalation at 18:15',
            '13m left'),
      ]));
}

class _BriefPriority extends StatelessWidget {
  const _BriefPriority(
      this.number, this.color, this.title, this.meta, this.detail, this.sla);
  final String number, title, meta, detail, sla;
  final Color color;
  @override
  Widget build(BuildContext context) => Padding(
      padding: const EdgeInsets.all(14),
      child: Row(children: [
        Container(
            width: 34,
            height: 34,
            alignment: Alignment.center,
            decoration: BoxDecoration(
                color: color.withValues(alpha: .1),
                borderRadius: BorderRadius.circular(10)),
            child: Text(number,
                style: TextStyle(
                    color: color, fontSize: 11, fontWeight: FontWeight.w900))),
        const SizedBox(width: 11),
        Expanded(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title,
              style: const TextStyle(
                  color: AppColors.navy,
                  fontSize: 11,
                  fontWeight: FontWeight.w900)),
          const SizedBox(height: 3),
          Text(meta, style: const TextStyle(fontSize: 9)),
          const SizedBox(height: 3),
          Text(detail,
              style: TextStyle(
                  color: color, fontSize: 9, fontWeight: FontWeight.w700))
        ])),
        StatusPill(sla, color: color),
        const SizedBox(width: 4),
        const Icon(Icons.chevron_right_rounded,
            color: AppColors.muted, size: 18)
      ]));
}

class _OperationalTimeline extends StatelessWidget {
  const _OperationalTimeline();
  @override
  Widget build(BuildContext context) => _Panel(
      title: '24-hour operational timeline',
      subtitle: 'Material events included in this edition',
      trailing: TextButton(onPressed: null, child: const Text('Open replay')),
      child: const Padding(
          padding: EdgeInsets.fromLTRB(16, 16, 16, 0),
          child: Column(children: [
            _Timeline('17:42', 'Ward checkpoint received',
                'Kwarbai \'A\' • 14 of 15 units reporting', AppColors.green),
            _Timeline(
                '16:18',
                'Incident severity reduced',
                'INC-00496 • High to Medium after verification',
                AppColors.blue),
            _Timeline('14:31', 'Critical incident created',
                'INC-00518 • Agent SOS • Kwarbai \'A\'', AppColors.red),
            _Timeline('12:06', 'Evidence integrity warning',
                'EVD-01831 isolated for review', AppColors.amber),
          ])));
}

class _WardReadiness extends StatelessWidget {
  const _WardReadiness();
  @override
  Widget build(BuildContext context) => _Panel(
      title: 'Ward readiness',
      subtitle: 'Reporting, staffing and communications by operational area',
      trailing: const StatusPill('12 OF 13 ACTIVE', color: AppColors.green),
      child: const Column(children: [
        _ReadinessRow(
            'Kwarbai \'A\'', '51 / 51 units', 1.0, '4 incidents', AppColors.green),
        Divider(height: 1),
        _ReadinessRow(
            'Kwarbai \'B\'', '63 / 65 units', .97, '1 incident', AppColors.green),
        Divider(height: 1),
        _ReadinessRow(
            'Ung. Juma', '35 / 38 units', .92, '1 incident', AppColors.blue),
        Divider(height: 1),
        _ReadinessRow('Limancin-Kona', '44 / 47 units', .94, '0 incidents',
            AppColors.green),
        Divider(height: 1),
        _ReadinessRow(
            'Kaura', '31 / 49 units', .63, '5 incidents', AppColors.red),
        Divider(height: 1),
        _ReadinessRow(
            'Tudun Wada', '62 / 71 units', .87, '6 incidents', AppColors.amber),
        Divider(height: 1),
        _ReadinessRow('Gyallesu', '34 / 41 units', .83, '3 incidents',
            AppColors.blue),
        Divider(height: 1),
        _ReadinessRow('Ung. Fatika', '37 / 38 units', .97, '1 incident',
            AppColors.green),
        Divider(height: 1),
        _ReadinessRow('Tukur Tukur', '41 / 45 units', .91, '1 incident',
            AppColors.blue),
        Divider(height: 1),
        _ReadinessRow(
            'Dambo', '34 / 35 units', .97, '0 incidents', AppColors.green),
        Divider(height: 1),
        _ReadinessRow('Wucicciri', '24 / 24 units', 1.0, '0 incidents',
            AppColors.green),
        Divider(height: 1),
        _ReadinessRow('Dutsen Abba', '33 / 38 units', .87, '1 incident',
            AppColors.blue),
        Divider(height: 1),
        _ReadinessRow(
            'Kufena', '35 / 42 units', .83, '0 incidents', AppColors.amber),
      ]));
}

class _ReadinessRow extends StatelessWidget {
  const _ReadinessRow(
      this.ward, this.units, this.progress, this.incidents, this.color);
  final String ward, units, incidents;
  final double progress;
  final Color color;
  @override
  Widget build(BuildContext context) => Padding(
      padding: const EdgeInsets.all(13),
      child: Row(children: [
        SizedBox(
            width: 120,
            child: Text(ward,
                style: const TextStyle(
                    color: AppColors.navy,
                    fontSize: 10,
                    fontWeight: FontWeight.w900))),
        SizedBox(
            width: 90, child: Text(units, style: const TextStyle(fontSize: 9))),
        Expanded(
            child: ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 6,
                    color: color,
                    backgroundColor: color.withValues(alpha: .1)))),
        const SizedBox(width: 12),
        StatusPill('${(progress * 100).round()}%', color: color),
        const SizedBox(width: 10),
        SizedBox(
            width: 65,
            child: Text(incidents,
                textAlign: TextAlign.right,
                style:
                    const TextStyle(fontSize: 9, fontWeight: FontWeight.w700)))
      ]));
}

class _BriefReviewStatus extends StatelessWidget {
  const _BriefReviewStatus();
  @override
  Widget build(BuildContext context) => _Panel(
      title: 'Review & approval',
      subtitle: 'Every section has an accountable reviewer',
      child: const Padding(
          padding: EdgeInsets.all(15),
          child: Column(children: [
            _ReviewOwner('Operational summary', 'Sani Shuaibu', 'REVIEWED',
                AppColors.green),
            _ReviewOwner('Incidents & verification', 'N. Ibrahim', 'REVIEWED',
                AppColors.green),
            _ReviewOwner('Social intelligence', 'L. Adeyemi', 'IN REVIEW',
                AppColors.amber),
            _ReviewOwner(
                'Executive approval', 'Unassigned', 'PENDING', AppColors.muted),
            SizedBox(height: 12),
            InfoNotice(
                'AI-generated sections cannot be approved until their cited records and reviewer assignments are complete.'),
          ])));
}

class _ReviewOwner extends StatelessWidget {
  const _ReviewOwner(this.section, this.owner, this.state, this.color);
  final String section, owner, state;
  final Color color;
  @override
  Widget build(BuildContext context) => Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(children: [
        CircleAvatar(
            radius: 14,
            backgroundColor: color.withValues(alpha: .1),
            child: Icon(Icons.person_outline_rounded, color: color, size: 14)),
        const SizedBox(width: 8),
        Expanded(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(section,
              style: const TextStyle(
                  color: AppColors.navy,
                  fontSize: 9,
                  fontWeight: FontWeight.w800)),
          Text(owner, style: const TextStyle(fontSize: 8))
        ])),
        StatusPill(state, color: color)
      ]));
}

class _AiBriefInsights extends StatelessWidget {
  const _AiBriefInsights();
  @override
  Widget build(BuildContext context) => _Panel(
      title: 'AI-assisted insights',
      subtitle: 'Patterns for human assessment',
      trailing: const StatusPill('ADVISORY',
          color: AppColors.blue, icon: Icons.auto_awesome_rounded),
      child: const Column(children: [
        _InsightItem(
            Icons.trending_up_rounded,
            AppColors.red,
            'Access reports increased 31%',
            'Concentrated in Kwarbai \'A\' and Tudun Wada • 8 cited reports'),
        Divider(height: 1),
        _InsightItem(
            Icons.compare_arrows_rounded,
            AppColors.amber,
            'Two material conflicts detected',
            'Counts differ across independent field sources'),
        Divider(height: 1),
        _InsightItem(
            Icons.network_check_rounded,
            AppColors.blue,
            'Connectivity risk is declining',
            'Failures down 18% since the 12:00 edition'),
      ]));
}

class _InsightItem extends StatelessWidget {
  const _InsightItem(this.icon, this.color, this.title, this.detail);
  final IconData icon;
  final Color color;
  final String title, detail;
  @override
  Widget build(BuildContext context) => Padding(
      padding: const EdgeInsets.all(12),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
            width: 31,
            height: 31,
            decoration: BoxDecoration(
                color: color.withValues(alpha: .1),
                borderRadius: BorderRadius.circular(9)),
            child: Icon(icon, color: color, size: 16)),
        const SizedBox(width: 8),
        Expanded(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title,
              style: const TextStyle(
                  color: AppColors.navy,
                  fontSize: 10,
                  fontWeight: FontWeight.w900)),
          const SizedBox(height: 3),
          Text(detail, style: const TextStyle(fontSize: 8, height: 1.35))
        ]))
      ]));
}

class _BriefSources extends StatelessWidget {
  const _BriefSources();
  @override
  Widget build(BuildContext context) => _Panel(
      title: 'Source register',
      subtitle: 'Snapshot preserved with this edition',
      trailing: TextButton(onPressed: null, child: const Text('View all 48')),
      child: const Column(children: [
        _QueueItem(Icons.description_outlined, AppColors.blue,
            'Situation reports', '24 records • 19 verified'),
        Divider(height: 1),
        _QueueItem(Icons.warning_amber_rounded, AppColors.red,
            'Incident timelines', '7 incidents • 86 events'),
        Divider(height: 1),
        _QueueItem(Icons.perm_media_outlined, AppColors.green,
            'Evidence objects', '5 referenced • integrity verified'),
        Divider(height: 1),
        _QueueItem(Icons.public_rounded, Color(0xFF7657C8),
            'Public-information sources', '12 representative records'),
      ]));
}

class _VerificationPerformance extends StatelessWidget {
  const _VerificationPerformance();
  @override
  Widget build(BuildContext context) => _Panel(
      title: 'Verification performance',
      subtitle: 'Decision quality and queue health',
      trailing: const StatusPill('94% WITHIN SLA', color: AppColors.green),
      child: const Padding(
          padding: EdgeInsets.all(16),
          child: Row(children: [
            Expanded(
                child: _CommsStat(Icons.verified_outlined, AppColors.green,
                    '86', 'Verified')),
            SizedBox(width: 9),
            Expanded(
                child: _CommsStat(Icons.chat_bubble_outline_rounded,
                    AppColors.blue, '7', 'Clarification')),
            SizedBox(width: 9),
            Expanded(
                child: _CommsStat(Icons.compare_arrows_rounded, AppColors.amber,
                    '4', 'Conflict review')),
            SizedBox(width: 9),
            Expanded(
                child: _CommsStat(
                    Icons.close_rounded, AppColors.red, '3', 'Rejected')),
          ])));
}

class _SocialBrief extends StatelessWidget {
  const _SocialBrief();
  @override
  Widget build(BuildContext context) => _Panel(
      title: 'Public-information pulse',
      subtitle: 'Aggregate trends only • no individual profiling',
      trailing: const StatusPill('HUMAN REVIEWED', color: AppColors.green),
      child: const Padding(
          padding: EdgeInsets.all(16),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(
                'Polling-unit access remains the fastest-growing public topic (+42%), followed by network connectivity (+27%). One false closure claim is spreading across four wards and remains unverified.',
                style: TextStyle(
                    color: AppColors.navy, fontSize: 10, height: 1.45)),
            SizedBox(height: 12),
            Wrap(spacing: 7, runSpacing: 7, children: [
              StatusPill('427 PUBLIC SOURCES', color: AppColors.blue),
              StatusPill('18 TOPIC CLUSTERS', color: Color(0xFF7657C8)),
              StatusPill('4 RISK ALERTS', color: AppColors.red)
            ]),
          ])));
}

class _BriefFooter extends StatelessWidget {
  const _BriefFooter({required this.approved});
  final bool approved;
  @override
  Widget build(BuildContext context) => Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: AppColors.border),
          borderRadius: BorderRadius.circular(15)),
      child: Row(children: [
        Icon(approved ? Icons.verified_user_rounded : Icons.edit_note_rounded,
            color: approved ? AppColors.green : AppColors.amber),
        const SizedBox(width: 10),
        Expanded(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(approved ? 'Approved command record' : 'Draft command record',
              style: const TextStyle(
                  color: AppColors.navy,
                  fontSize: 11,
                  fontWeight: FontWeight.w900)),
          Text(
              approved
                  ? 'This edition is immutable; further edits create a new version.'
                  : 'Generated at 17:48 • last reviewed 17:56 • approval pending',
              style: const TextStyle(fontSize: 9))
        ])),
        OutlinedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.picture_as_pdf_outlined, size: 16),
            label: const Text('Preview export')),
        const SizedBox(width: 8),
        OutlinedButton.icon(
            onPressed: approved ? () {} : null,
            icon: const Icon(Icons.share_outlined, size: 16),
            label: const Text('Controlled distribution')),
      ]));
}
