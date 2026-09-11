part of 'situation_room_page.dart';

class _VerificationRecord {
  const _VerificationRecord(
      {required this.id,
      required this.title,
      required this.agent,
      required this.unit,
      required this.ward,
      required this.time,
      required this.severity,
      required this.queue,
      required this.status,
      required this.location,
      required this.accuracy,
      required this.distance,
      required this.related,
      required this.evidence,
      required this.color});
  final String id,
      title,
      agent,
      unit,
      ward,
      time,
      severity,
      queue,
      status,
      location,
      accuracy,
      distance,
      related,
      evidence;
  final Color color;
}

class _VerificationCenterPage extends StatefulWidget {
  const _VerificationCenterPage();
  @override
  State<_VerificationCenterPage> createState() =>
      _VerificationCenterPageState();
}

class _VerificationCenterPageState extends State<_VerificationCenterPage> {
  int _selected = 0;
  String _queue = 'All queues';
  String _query = '';
  final Map<String, String> _decisions = {};

  static const _records = <_VerificationRecord>[
    _VerificationRecord(
        id: 'RPT-2026-00201',
        title: 'Access disruption at polling-unit entrance',
        agent: 'Amina Yusuf • AGT-041',
        unit: 'Polling Unit 014',
        ward: 'Kwarbai \'A\'',
        time: '14:27 • 15m ago',
        severity: 'High',
        queue: 'Location discrepancy',
        status: 'Under review',
        location: '9.0458, 7.4981',
        accuracy: '±12 m',
        distance: '420 m from registered unit',
        related: '3 potentially related reports',
        evidence: '2 photos • 1 video',
        color: AppColors.red),
    _VerificationRecord(
        id: 'RPT-2026-00198',
        title: 'Polling materials arrived incomplete',
        agent: 'Kabir Musa • AGT-074',
        unit: 'Polling Unit 028',
        ward: 'Tudun Wada',
        time: '14:19 • 23m ago',
        severity: 'High',
        queue: 'Potential conflict',
        status: 'Under review',
        location: '9.0712, 7.4660',
        accuracy: '±18 m',
        distance: 'Within expected radius',
        related: '2 reports contain conflicting counts',
        evidence: '3 photos',
        color: AppColors.amber),
    _VerificationRecord(
        id: 'RPT-2026-00194',
        title: 'Routine unit opening status',
        agent: 'Fatima Ali • AGT-088',
        unit: 'Polling Unit 009',
        ward: 'Gyallesu',
        time: '14:11 • 31m ago',
        severity: 'Medium',
        queue: 'Evidence pending',
        status: 'Awaiting evidence',
        location: '9.0580, 7.4892',
        accuracy: '±96 m • low accuracy',
        distance: 'Within expected radius',
        related: 'No related reports found',
        evidence: 'Video upload 68%',
        color: AppColors.blue),
    _VerificationRecord(
        id: 'RPT-2026-00187',
        title: 'Temporary crowd congestion',
        agent: 'Ngozi Eze • AGT-106',
        unit: 'Polling Unit 022',
        ward: 'Kwarbai \'A\'',
        time: '13:56 • 46m ago',
        severity: 'Medium',
        queue: 'Corroboration available',
        status: 'Ready for decision',
        location: '9.0389, 7.5014',
        accuracy: '±9 m',
        distance: 'Within expected radius',
        related: '4 independent reports align',
        evidence: '4 photos • 2 videos',
        color: AppColors.green),
  ];

  List<_VerificationRecord> get _filtered => _records.where((record) {
        final q = _query.toLowerCase();
        return (_queue == 'All queues' || record.queue == _queue) &&
            (q.isEmpty ||
                '${record.id} ${record.title} ${record.agent} ${record.unit} ${record.ward}'
                    .toLowerCase()
                    .contains(q));
      }).toList();

  @override
  Widget build(BuildContext context) {
    final records = _filtered;
    final selected = records.isEmpty
        ? null
        : records[_selected.clamp(0, records.length - 1)];
    return Column(children: [
      const _VerificationHeader(),
      const _VerificationMetrics(),
      _VerificationFilters(
          query: _query,
          queue: _queue,
          onQuery: (v) => setState(() {
                _query = v;
                _selected = 0;
              }),
          onQueue: (v) => setState(() {
                _queue = v!;
                _selected = 0;
              })),
      Expanded(
          child: Row(children: [
        SizedBox(
            width: 390,
            child: _VerificationQueueList(
                records: records,
                selected: selected?.id,
                decisions: _decisions,
                onSelected: (record) =>
                    setState(() => _selected = records.indexOf(record)))),
        Container(width: 1, color: AppColors.border),
        Expanded(
            child: selected == null
                ? const _EmptyVerification()
                : _VerificationReview(
                    record: selected,
                    decision: _decisions[selected.id],
                    onAction: (action) => _openDecision(selected, action))),
      ])),
    ]);
  }

  void _openDecision(_VerificationRecord record, String action) {
    final controller = TextEditingController();
    final color = action == 'Verify'
        ? AppColors.green
        : action == 'Reject'
            ? AppColors.red
            : action == 'Escalate'
                ? AppColors.amber
                : AppColors.blue;
    showDialog<void>(
        context: context,
        builder: (_) => AlertDialog(
              title: Row(children: [
                Icon(
                    action == 'Verify'
                        ? Icons.verified_outlined
                        : action == 'Reject'
                            ? Icons.cancel_outlined
                            : action == 'Escalate'
                                ? Icons.north_east_rounded
                                : Icons.chat_bubble_outline_rounded,
                    color: color),
                const SizedBox(width: 10),
                Text('$action ${record.id}')
              ]),
              content: SizedBox(
                  width: 500,
                  child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        InfoNotice(
                            action == 'Verify'
                                ? 'Verification confirms this submission for operational use. The original report and evidence remain unchanged.'
                                : action == 'Reject'
                                    ? 'Rejection preserves the original submission and records your reason in the audit trail.'
                                    : action == 'Escalate'
                                        ? 'Escalation creates an incident-command review without declaring this report verified.'
                                        : 'The reporting agent will receive this question. The report remains unverified while awaiting a response.',
                            danger: action == 'Reject'),
                        const SizedBox(height: 15),
                        TextField(
                            controller: controller,
                            minLines: 3,
                            maxLines: 5,
                            decoration: InputDecoration(
                                labelText: action == 'Clarify'
                                    ? 'Question for agent (required)'
                                    : 'Decision reason (required)',
                                alignLabelWithHint: true)),
                        const SizedBox(height: 10),
                        const Row(children: [
                          Icon(Icons.history_rounded,
                              color: AppColors.muted, size: 15),
                          SizedBox(width: 6),
                          Expanded(
                              child: Text(
                                  'Actor, role, timestamp, reason and before/after state will be audited.',
                                  style: TextStyle(fontSize: 9)))
                        ]),
                      ])),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel')),
                FilledButton(
                    onPressed: () {
                      if (controller.text.trim().isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('A reason is required')));
                        return;
                      }
                      setState(() => _decisions[record.id] = action == 'Clarify'
                          ? 'Clarification required'
                          : action == 'Verify'
                              ? 'Verified'
                              : action == 'Reject'
                                  ? 'Rejected'
                                  : 'Escalated');
                      Navigator.pop(context);
                    },
                    style: FilledButton.styleFrom(backgroundColor: color),
                    child: Text(action))
              ],
            ));
  }
}

class _VerificationHeader extends StatelessWidget {
  const _VerificationHeader();
  @override
  Widget build(BuildContext context) => Container(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 16),
      color: Colors.white,
      child: Row(children: [
        Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
                gradient: const LinearGradient(
                    colors: [Color(0xFF7657C8), AppColors.blue]),
                borderRadius: BorderRadius.circular(14),
                boxShadow: const [
                  BoxShadow(
                      color: Color(0x337657C8),
                      blurRadius: 16,
                      offset: Offset(0, 6))
                ]),
            child: const Icon(Icons.fact_check_rounded, color: Colors.white)),
        const SizedBox(width: 13),
        Expanded(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Verification center',
              style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 3),
          const Text(
              'Review sources, corroboration, location and evidence before deciding',
              overflow: TextOverflow.ellipsis)
        ])),
        const StatusPill('SUBMITTED ≠ VERIFIED',
            color: AppColors.amber, icon: Icons.gpp_maybe_outlined),
        const SizedBox(width: 8),
        OutlinedButton.icon(
            onPressed: null,
            icon: Icon(Icons.keyboard_command_key_rounded, size: 17),
            label: Text('Review shortcuts')),
      ]));
}

class _VerificationMetrics extends StatelessWidget {
  const _VerificationMetrics();
  @override
  Widget build(BuildContext context) => Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
      child: const Row(children: [
        Expanded(
            child: _EvidenceMetric(Icons.inbox_outlined, AppColors.blue, '12',
                'New submissions', '3 high priority')),
        SizedBox(width: 10),
        Expanded(
            child: _EvidenceMetric(
                Icons.compare_arrows_rounded,
                AppColors.amber,
                '4',
                'Potential conflicts',
                'Needs comparison')),
        SizedBox(width: 10),
        Expanded(
            child: _EvidenceMetric(Icons.location_off_outlined, AppColors.red,
                '3', 'GPS discrepancies', '1 outside 400 m')),
        SizedBox(width: 10),
        Expanded(
            child: _EvidenceMetric(Icons.link_rounded, AppColors.green, '8',
                'Corroboration ready', '21 linked sources')),
        SizedBox(width: 10),
        Expanded(
            child: _EvidenceMetric(Icons.timer_outlined, Color(0xFF7657C8),
                '08:14', 'Median review time', 'Within SLA')),
      ]));
}

class _VerificationFilters extends StatelessWidget {
  const _VerificationFilters(
      {required this.query,
      required this.queue,
      required this.onQuery,
      required this.onQueue});
  final String query, queue;
  final ValueChanged<String> onQuery;
  final ValueChanged<String?> onQueue;
  @override
  Widget build(BuildContext context) => Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: const BoxDecoration(
          color: Color(0xFFF8FAFC),
          border: Border.symmetric(
              horizontal: BorderSide(color: AppColors.border))),
      child: Row(children: [
        SizedBox(
            width: 340,
            height: 40,
            child: TextField(
                onChanged: onQuery,
                decoration: const InputDecoration(
                    hintText: 'Search report, agent, unit or ward',
                    prefixIcon: Icon(Icons.search_rounded, size: 19),
                    contentPadding: EdgeInsets.zero))),
        const SizedBox(width: 10),
        _FilterDropdown(
            queue,
            const [
              'All queues',
              'Location discrepancy',
              'Potential conflict',
              'Evidence pending',
              'Corroboration available'
            ],
            Icons.filter_list_rounded,
            onQueue),
        const Spacer(),
        const StatusPill('HUMAN REVIEW ACTIVE',
            color: AppColors.green, icon: Icons.person_search_outlined),
      ]));
}

class _VerificationQueueList extends StatelessWidget {
  const _VerificationQueueList(
      {required this.records,
      required this.selected,
      required this.decisions,
      required this.onSelected});
  final List<_VerificationRecord> records;
  final String? selected;
  final Map<String, String> decisions;
  final ValueChanged<_VerificationRecord> onSelected;
  @override
  Widget build(BuildContext context) => Container(
      color: Colors.white,
      child: Column(children: [
        Padding(
            padding: const EdgeInsets.fromLTRB(17, 13, 12, 11),
            child: Row(children: [
              Text('${records.length} REPORTS',
                  style: const TextStyle(
                      color: AppColors.muted,
                      fontSize: 9,
                      fontWeight: FontWeight.w900,
                      letterSpacing: .7)),
              const Spacer(),
              TextButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.sort_rounded, size: 15),
                  label: const Text('Priority'))
            ])),
        const Divider(height: 1),
        Expanded(
            child: records.isEmpty
                ? const _EmptyVerification()
                : ListView.separated(
                    itemCount: records.length,
                    separatorBuilder: (_, __) => const Divider(height: 1),
                    itemBuilder: (_, i) {
                      final record = records[i];
                      final active = record.id == selected;
                      final decision = decisions[record.id];
                      return InkWell(
                          onTap: () => onSelected(record),
                          child: Container(
                              color: active
                                  ? const Color(0xFFF3F1FF)
                                  : Colors.white,
                              padding: const EdgeInsets.all(15),
                              child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                        width: 4,
                                        height: 54,
                                        decoration: BoxDecoration(
                                            color: decision == 'Verified'
                                                ? AppColors.green
                                                : record.color,
                                            borderRadius:
                                                BorderRadius.circular(4))),
                                    const SizedBox(width: 11),
                                    Expanded(
                                        child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                          Row(children: [
                                            Text(record.id,
                                                style: const TextStyle(
                                                    color: AppColors.navy,
                                                    fontSize: 10,
                                                    fontWeight:
                                                        FontWeight.w900)),
                                            const Spacer(),
                                            StatusPill(
                                                (decision ?? record.severity)
                                                    .toUpperCase(),
                                                color: decision == 'Verified'
                                                    ? AppColors.green
                                                    : record.color)
                                          ]),
                                          const SizedBox(height: 6),
                                          Text(record.title,
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                  color: AppColors.navy,
                                                  fontSize: 11,
                                                  height: 1.25,
                                                  fontWeight: FontWeight.w800)),
                                          const SizedBox(height: 6),
                                          Row(children: [
                                            Icon(_queueIcon(record.queue),
                                                color: record.color, size: 13),
                                            const SizedBox(width: 4),
                                            Expanded(
                                                child: Text(record.queue,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                        color: record.color,
                                                        fontSize: 9,
                                                        fontWeight:
                                                            FontWeight.w800))),
                                            Text(record.time,
                                                style: const TextStyle(
                                                    fontSize: 8))
                                          ])
                                        ])),
                                  ])));
                    })),
      ]));
}

IconData _queueIcon(String queue) => queue == 'Location discrepancy'
    ? Icons.location_off_outlined
    : queue == 'Potential conflict'
        ? Icons.compare_arrows_rounded
        : queue == 'Evidence pending'
            ? Icons.cloud_upload_outlined
            : Icons.link_rounded;

class _VerificationReview extends StatelessWidget {
  const _VerificationReview(
      {required this.record, required this.decision, required this.onAction});
  final _VerificationRecord record;
  final String? decision;
  final ValueChanged<String> onAction;
  @override
  Widget build(BuildContext context) => Container(
      color: const Color(0xFFF8FAFC),
      child: Column(children: [
        Container(
            padding: const EdgeInsets.all(17),
            color: Colors.white,
            child: Row(children: [
              Expanded(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                    Row(children: [
                      Text(record.id,
                          style: const TextStyle(
                              color: AppColors.navy,
                              fontSize: 15,
                              fontWeight: FontWeight.w900)),
                      const SizedBox(width: 8),
                      StatusPill((decision ?? record.status).toUpperCase(),
                          color: decision == 'Verified'
                              ? AppColors.green
                              : record.color)
                    ]),
                    const SizedBox(height: 5),
                    Text(record.title,
                        style: const TextStyle(
                            color: AppColors.navy,
                            fontSize: 13,
                            fontWeight: FontWeight.w700))
                  ])),
              const _MiniValue('RECEIVED', '15m ago'),
              const SizedBox(width: 18),
              const _MiniValue('SLA', '14:18')
            ])),
        Expanded(
            child: ListView(padding: const EdgeInsets.all(18), children: [
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Expanded(
                child: _ReviewSection(
                    title: 'Original submission',
                    icon: Icons.description_outlined,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(record.agent,
                              style: const TextStyle(
                                  color: AppColors.navy,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w800)),
                          const SizedBox(height: 4),
                          Text('${record.unit} • ${record.ward}',
                              style: const TextStyle(fontSize: 9)),
                          const Divider(height: 20),
                          const Text(
                              '“Access to the main entrance became restricted at approximately 14:20. Several accredited observers are waiting outside.”',
                              style: TextStyle(
                                  color: AppColors.navy,
                                  fontSize: 11,
                                  height: 1.45)),
                          const SizedBox(height: 10),
                          Wrap(spacing: 6, runSpacing: 6, children: [
                            StatusPill(record.severity.toUpperCase(),
                                color: record.color),
                            const StatusPill('AGENT SUBMISSION',
                                color: AppColors.blue)
                          ])
                        ]))),
            const SizedBox(width: 12),
            Expanded(
                child: _ReviewSection(
                    title: 'Location context',
                    icon: Icons.map_outlined,
                    child: Column(children: [
                      Container(
                          height: 105,
                          decoration: BoxDecoration(
                              color: const Color(0xFFE7EDF2),
                              borderRadius: BorderRadius.circular(10)),
                          child: Stack(children: [
                            const Positioned.fill(
                                child: CustomPaint(painter: _MiniMapPainter())),
                            Positioned(
                                left: 78,
                                top: 38,
                                child: Icon(Icons.location_on_rounded,
                                    color: record.color, size: 28)),
                            const Positioned(
                                right: 55,
                                bottom: 24,
                                child: Icon(Icons.how_to_vote_rounded,
                                    color: AppColors.blue, size: 22))
                          ])),
                      const SizedBox(height: 9),
                      _CompareRow('Captured', record.location, record.accuracy),
                      _CompareRow(
                          'Discrepancy',
                          record.distance,
                          record.distance.startsWith('Within')
                              ? 'OK'
                              : 'REVIEW')
                    ]))),
          ]),
          const SizedBox(height: 12),
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Expanded(
                child: _ReviewSection(
                    title: 'Corroboration & conflicts',
                    icon: Icons.hub_outlined,
                    child: Column(children: [
                      _SourceCompare(
                          'RPT-2026-00199',
                          'Kabir Musa • independent source',
                          'Reports restricted access at the same entrance',
                          'ALIGNS',
                          AppColors.green),
                      const Divider(height: 16),
                      _SourceCompare(
                          'RPT-2026-00204',
                          'Ngozi Eze • independent source',
                          'Reports access is delayed, not fully restricted',
                          'DIFFERS',
                          AppColors.amber),
                      const SizedBox(height: 9),
                      InfoNotice(record.related),
                    ]))),
            const SizedBox(width: 12),
            Expanded(
                child: _ReviewSection(
                    title: 'Evidence & AI assistance',
                    icon: Icons.perm_media_outlined,
                    child: Column(children: [
                      _ReviewAsset(Icons.image_outlined, 'IMG-01841',
                          'Integrity verified', AppColors.green),
                      const SizedBox(height: 7),
                      _ReviewAsset(Icons.videocam_outlined, 'VID-01842',
                          'Preview available', AppColors.blue),
                      const SizedBox(height: 10),
                      Container(
                          padding: const EdgeInsets.all(11),
                          decoration: BoxDecoration(
                              color: const Color(0xFFF0F5FF),
                              borderRadius: BorderRadius.circular(10)),
                          child: const Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(Icons.auto_awesome_rounded,
                                    color: AppColors.blue, size: 16),
                                SizedBox(width: 8),
                                Expanded(
                                    child: Text(
                                        'AI found 87% semantic similarity across 3 reports. This is advisory and does not determine truth.',
                                        style: TextStyle(
                                            color: AppColors.navy,
                                            fontSize: 9,
                                            height: 1.35))),
                                StatusPill('UNVERIFIED', color: AppColors.amber)
                              ])),
                    ]))),
          ]),
          const SizedBox(height: 12),
          _ReviewSection(
              title: 'Verification history',
              icon: Icons.history_rounded,
              child: const Row(children: [
                Expanded(
                    child: _AuditEvent('14:27:08', 'Submission received',
                        'AGT-041 • idempotency key accepted')),
                Expanded(
                    child: _AuditEvent('14:27:12', 'Automated checks completed',
                        'Integrity passed • GPS discrepancy flagged'))
              ])),
        ])),
        Container(
            padding: const EdgeInsets.all(14),
            decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(top: BorderSide(color: AppColors.border))),
            child: Wrap(
                alignment: WrapAlignment.end,
                spacing: 8,
                runSpacing: 8,
                children: [
                  OutlinedButton.icon(
                      onPressed: () => onAction('Clarify'),
                      icon: const Icon(Icons.chat_bubble_outline_rounded,
                          size: 16),
                      label: const Text('Request clarification')),
                  OutlinedButton.icon(
                      onPressed: () => onAction('Escalate'),
                      icon: const Icon(Icons.north_east_rounded, size: 16),
                      label: const Text('Escalate')),
                  OutlinedButton.icon(
                      onPressed: () => onAction('Reject'),
                      style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.red),
                      icon: const Icon(Icons.close_rounded, size: 16),
                      label: const Text('Reject')),
                  FilledButton.icon(
                      onPressed: () => onAction('Verify'),
                      style: FilledButton.styleFrom(
                          backgroundColor: AppColors.green),
                      icon: const Icon(Icons.verified_rounded, size: 16),
                      label: const Text('Verify report')),
                ])),
      ]));
}

class _ReviewSection extends StatelessWidget {
  const _ReviewSection(
      {required this.title, required this.icon, required this.child});
  final String title;
  final IconData icon;
  final Widget child;
  @override
  Widget build(BuildContext context) => Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: AppColors.border),
          borderRadius: BorderRadius.circular(14)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Icon(icon, color: AppColors.blue, size: 17),
          const SizedBox(width: 7),
          Text(title,
              style: const TextStyle(
                  color: AppColors.navy,
                  fontSize: 11,
                  fontWeight: FontWeight.w900))
        ]),
        const Divider(height: 20),
        child
      ]));
}

class _CompareRow extends StatelessWidget {
  const _CompareRow(this.label, this.value, this.tag);
  final String label, value, tag;
  @override
  Widget build(BuildContext context) => Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(children: [
        SizedBox(
            width: 70,
            child: Text(label,
                style: const TextStyle(
                    color: AppColors.muted,
                    fontSize: 8,
                    fontWeight: FontWeight.w800))),
        Expanded(
            child: Text(value,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                    color: AppColors.navy,
                    fontSize: 9,
                    fontWeight: FontWeight.w700))),
        Text(tag,
            style: TextStyle(
                color: tag == 'REVIEW' ? AppColors.red : AppColors.green,
                fontSize: 8,
                fontWeight: FontWeight.w900))
      ]));
}

class _SourceCompare extends StatelessWidget {
  const _SourceCompare(
      this.id, this.source, this.claim, this.state, this.color);
  final String id, source, claim, state;
  final Color color;
  @override
  Widget build(BuildContext context) =>
      Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
            width: 31,
            height: 31,
            decoration: BoxDecoration(
                color: color.withValues(alpha: .1),
                borderRadius: BorderRadius.circular(8)),
            child: Icon(Icons.person_outline_rounded, color: color, size: 16)),
        const SizedBox(width: 8),
        Expanded(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Text(id,
                style: const TextStyle(
                    color: AppColors.navy,
                    fontSize: 9,
                    fontWeight: FontWeight.w900)),
            const Spacer(),
            StatusPill(state, color: color)
          ]),
          Text(source, style: const TextStyle(fontSize: 8)),
          const SizedBox(height: 3),
          Text(claim,
              style: const TextStyle(
                  color: AppColors.navy, fontSize: 9, height: 1.3))
        ]))
      ]);
}

class _ReviewAsset extends StatelessWidget {
  const _ReviewAsset(this.icon, this.id, this.state, this.color);
  final IconData icon;
  final String id, state;
  final Color color;
  @override
  Widget build(BuildContext context) => Container(
      padding: const EdgeInsets.all(9),
      decoration: BoxDecoration(
          color: const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(9)),
      child: Row(children: [
        Icon(icon, color: color, size: 18),
        const SizedBox(width: 8),
        Expanded(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(id,
              style: const TextStyle(
                  color: AppColors.navy,
                  fontSize: 9,
                  fontWeight: FontWeight.w900)),
          Text(state, style: const TextStyle(fontSize: 8))
        ])),
        const Icon(Icons.open_in_new_rounded, color: AppColors.muted, size: 15)
      ]));
}

class _MiniMapPainter extends CustomPainter {
  const _MiniMapPainter();
  @override
  void paint(Canvas canvas, Size size) {
    final road = Paint()
      ..color = Colors.white
      ..strokeWidth = 7
      ..style = PaintingStyle.stroke;
    final minor = Paint()
      ..color = const Color(0xFFCBD6DF)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;
    canvas.drawPath(
        Path()
          ..moveTo(0, size.height * .3)
          ..quadraticBezierTo(
              size.width * .5, size.height * .8, size.width, size.height * .35),
        road);
    canvas.drawPath(
        Path()
          ..moveTo(size.width * .25, 0)
          ..quadraticBezierTo(size.width * .6, size.height * .45,
              size.width * .75, size.height),
        minor);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _EmptyVerification extends StatelessWidget {
  const _EmptyVerification();
  @override
  Widget build(BuildContext context) => const Center(
          child: Column(mainAxisSize: MainAxisSize.min, children: [
        Icon(Icons.fact_check_outlined, color: AppColors.blue, size: 42),
        SizedBox(height: 10),
        Text('No reports match these filters',
            style:
                TextStyle(color: AppColors.navy, fontWeight: FontWeight.w800))
      ]));
}
