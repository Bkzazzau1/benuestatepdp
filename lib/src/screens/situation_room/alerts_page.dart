part of 'situation_room_page.dart';

class _AlertRecord {
  const _AlertRecord(
      {required this.id,
      required this.title,
      required this.severity,
      required this.state,
      required this.source,
      required this.sourceId,
      required this.location,
      required this.created,
      required this.age,
      required this.sla,
      required this.owner,
      required this.recipients,
      required this.delivery,
      required this.detail,
      required this.color,
      required this.icon,
      this.ai = false});
  final String id,
      title,
      severity,
      state,
      source,
      sourceId,
      location,
      created,
      age,
      sla,
      owner,
      recipients,
      delivery,
      detail;
  final Color color;
  final IconData icon;
  final bool ai;
}

class _AlertsPage extends StatefulWidget {
  const _AlertsPage({required this.onOpenIncident});
  final ValueChanged<String> onOpenIncident;
  @override
  State<_AlertsPage> createState() => _AlertsPageState();
}

class _AlertsPageState extends State<_AlertsPage> {
  int _selected = 0;
  String _severity = 'All severities';
  String _state = 'Open alerts';
  String _query = '';
  final Map<String, String> _states = {};
  final Map<String, String> _owners = {};

  static const _alerts = <_AlertRecord>[
    _AlertRecord(
        id: 'ALT-0092',
        title: 'Agent SOS received',
        severity: 'Critical',
        state: 'New',
        source: 'Agent SOS',
        sourceId: 'AGT-041',
        location: 'Kwarbai \'A\' • Polling Unit 014',
        created: '14:31:02',
        age: '11m',
        sla: '04:18',
        owner: 'Unassigned',
        recipients: 'Commander • Ward coordinator • Emergency roles',
        delivery: 'Push 3/3 • SMS 2/2 • In-app 7/7',
        detail:
            'Agent activated emergency SOS during an authorized secure call. Current operational location is available with ±12 m accuracy.',
        color: AppColors.red,
        icon: Icons.sos_rounded),
    _AlertRecord(
        id: 'ALT-0089',
        title: 'Location discrepancy requires review',
        severity: 'Urgent',
        state: 'Acknowledged',
        source: 'GPS rule',
        sourceId: 'RPT-2026-00201',
        location: 'Kwarbai \'A\' • 420 m from PU-014',
        created: '14:27:12',
        age: '15m',
        sla: '12:44',
        owner: 'N. Ibrahim',
        recipients: 'Verification Officer • Ward coordinator',
        delivery: 'Push 2/2 • In-app 4/4',
        detail:
            'Report location is outside the configured polling-unit radius. Captured accuracy is ±12 m. The discrepancy requires human review.',
        color: AppColors.amber,
        icon: Icons.location_off_rounded),
    _AlertRecord(
        id: 'ALT-0084',
        title: 'Evidence upload repeatedly failed',
        severity: 'Urgent',
        state: 'Assigned',
        source: 'Evidence service',
        sourceId: 'EVD-2026-01836',
        location: 'Gyallesu • Polling Unit 009',
        created: '14:18:41',
        age: '24m',
        sla: '18:02',
        owner: 'Technical Operations',
        recipients: 'Field agent • Technical monitoring',
        delivery: 'Push 2/2 • In-app 3/3',
        detail:
            'Encrypted video upload failed after three automatic retries. The resumable session is preserved and no evidence segments were discarded.',
        color: AppColors.amber,
        icon: Icons.cloud_off_outlined),
    _AlertRecord(
        id: 'ALT-0078',
        title: 'Possible crowd escalation',
        severity: 'Urgent',
        state: 'In progress',
        source: 'Acoustic AI',
        sourceId: 'ACOUSTIC-00418',
        location: 'Tudun Wada • Polling Unit 028',
        created: '14:06:19',
        age: '36m',
        sla: '21:16',
        owner: 'Musa Bello',
        recipients: 'Incident Commander • Verification Officer',
        delivery: 'Push 2/2 • In-app 5/5',
        detail:
            'An authorized call produced an acoustic-event signal consistent with elevated crowd noise. This machine-generated alert remains unverified.',
        color: Color(0xFF7657C8),
        icon: Icons.graphic_eq_rounded,
        ai: true),
    _AlertRecord(
        id: 'ALT-0067',
        title: 'Ward checkpoint overdue',
        severity: 'Informational',
        state: 'New',
        source: 'Workflow timer',
        sourceId: 'CHECKPOINT-18',
        location: 'Kaura',
        created: '13:58:00',
        age: '44m',
        sla: '36:00',
        owner: 'Ward Coordinator',
        recipients: 'Ward coordinator',
        delivery: 'Push 1/1 • In-app 2/2',
        detail:
            'The scheduled ward checkpoint has not been received. Two assigned agents are currently offline.',
        color: AppColors.blue,
        icon: Icons.schedule_rounded),
  ];

  List<_AlertRecord> get _filtered => _alerts.where((alert) {
        final current = _states[alert.id] ?? alert.state;
        final q = _query.toLowerCase();
        final stateMatch = _state == 'All states' ||
            (_state == 'Open alerts'
                ? current != 'Resolved' && current != 'Closed'
                : current == _state);
        return (_severity == 'All severities' || alert.severity == _severity) &&
            stateMatch &&
            (q.isEmpty ||
                '${alert.id} ${alert.title} ${alert.source} ${alert.sourceId} ${alert.location}'
                    .toLowerCase()
                    .contains(q));
      }).toList();

  @override
  Widget build(BuildContext context) {
    final alerts = _filtered;
    final selected =
        alerts.isEmpty ? null : alerts[_selected.clamp(0, alerts.length - 1)];
    return Column(children: [
      const _AlertsHeader(),
      const _AlertMetrics(),
      _AlertFilters(
          query: _query,
          severity: _severity,
          state: _state,
          onQuery: (v) => setState(() {
                _query = v;
                _selected = 0;
              }),
          onSeverity: (v) => setState(() {
                _severity = v!;
                _selected = 0;
              }),
          onState: (v) => setState(() {
                _state = v!;
                _selected = 0;
              })),
      Expanded(
          child: Row(children: [
        SizedBox(
            width: 405,
            child: _AlertQueue(
                records: alerts,
                selected: selected?.id,
                states: _states,
                onSelected: (alert) =>
                    setState(() => _selected = alerts.indexOf(alert)))),
        Container(width: 1, color: AppColors.border),
        Expanded(
            child: selected == null
                ? const _EmptyAlerts()
                : _AlertInspector(
                    record: selected,
                    state: _states[selected.id] ?? selected.state,
                    owner: _owners[selected.id] ?? selected.owner,
                    onAcknowledge: () => _acknowledge(selected),
                    onAssign: () => _assign(selected),
                    onResolve: () => _resolve(selected),
                    onOpenSource: () => _openSource(selected))),
        Container(width: 1, color: AppColors.border),
        const SizedBox(width: 295, child: _AlertOperationsRail()),
      ])),
    ]);
  }

  void _acknowledge(_AlertRecord alert) {
    setState(() => _states[alert.id] = 'Acknowledged');
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Alert acknowledged • underlying source remains open')));
  }

  void _assign(_AlertRecord alert) => showDialog<void>(
      context: context,
      builder: (_) => AlertDialog(
            title: Text('Assign ${alert.id}'),
            content: SizedBox(
                width: 430,
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  DropdownButtonFormField<String>(
                      isExpanded: true,
                      initialValue: 'Musa Bello',
                      items: const [
                        DropdownMenuItem(
                            value: 'Musa Bello',
                            child: Text('Musa Bello • Incident Commander')),
                        DropdownMenuItem(
                            value: 'N. Ibrahim',
                            child: Text('N. Ibrahim • Verification Officer')),
                        DropdownMenuItem(
                            value: 'Ward Coordinator',
                            child: Text('Ward Coordinator'))
                      ],
                      onChanged: null,
                      decoration:
                          const InputDecoration(labelText: 'Authorized owner')),
                  const SizedBox(height: 11),
                  const TextField(
                      decoration: InputDecoration(
                          labelText: 'Assignment reason (required)'))
                ])),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel')),
              FilledButton(
                  onPressed: () {
                    setState(() {
                      _owners[alert.id] = 'Musa Bello';
                      _states[alert.id] = 'Assigned';
                    });
                    Navigator.pop(context);
                  },
                  child: const Text('Assign alert'))
            ],
          ));

  void _resolve(_AlertRecord alert) => showDialog<void>(
      context: context,
      builder: (_) => AlertDialog(
            title: Text('Resolve ${alert.id}?'),
            content: const SizedBox(
                width: 470,
                child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InfoNotice(
                          'Resolving this alert does not automatically resolve its linked incident, report, evidence issue or AI review.'),
                      SizedBox(height: 13),
                      TextField(
                          minLines: 3,
                          maxLines: 5,
                          decoration: InputDecoration(
                              labelText:
                                  'Resolution reason and outcome (required)',
                              alignLabelWithHint: true))
                    ])),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel')),
              FilledButton(
                  onPressed: () {
                    setState(() => _states[alert.id] = 'Resolved');
                    Navigator.pop(context);
                  },
                  style:
                      FilledButton.styleFrom(backgroundColor: AppColors.green),
                  child: const Text('Resolve alert'))
            ],
          ));

  void _openSource(_AlertRecord alert) {
    if (alert.sourceId == 'AGT-041') {
      widget.onOpenIncident('INC-00518');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Opening source ${alert.sourceId}')));
    }
  }
}

class _AlertsHeader extends StatelessWidget {
  const _AlertsHeader();
  @override
  Widget build(BuildContext context) => Container(
      padding: const EdgeInsets.fromLTRB(24, 18, 24, 15),
      color: Colors.white,
      child: Row(children: [
        Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
                gradient: const LinearGradient(
                    colors: [AppColors.red, Color(0xFFFF8748)]),
                borderRadius: BorderRadius.circular(14),
                boxShadow: const [
                  BoxShadow(
                      color: Color(0x33D94646),
                      blurRadius: 16,
                      offset: Offset(0, 6))
                ]),
            child: const Icon(Icons.notifications_active_rounded,
                color: Colors.white)),
        const SizedBox(width: 13),
        Expanded(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Alerts center',
              style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 3),
          const Text(
              'Acknowledge, assign, escalate and close operational alerts',
              overflow: TextOverflow.ellipsis)
        ])),
        const StatusPill('4 REQUIRE ACTION',
            color: AppColors.red, icon: Icons.priority_high_rounded),
        const SizedBox(width: 8),
        OutlinedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.settings_outlined, size: 17),
            label: const Text('Alert policies')),
      ]));
}

class _AlertMetrics extends StatelessWidget {
  const _AlertMetrics();
  @override
  Widget build(BuildContext context) => Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 15),
      child: const Row(children: [
        Expanded(
            child: _EvidenceMetric(Icons.notification_important_outlined,
                AppColors.red, '4', 'Unacknowledged', '2 critical')),
        SizedBox(width: 9),
        Expanded(
            child: _EvidenceMetric(Icons.timer_outlined, AppColors.amber, '3',
                'SLA at risk', 'Next in 04:18')),
        SizedBox(width: 9),
        Expanded(
            child: _EvidenceMetric(Icons.person_off_outlined, AppColors.blue,
                '2', 'Unassigned', 'Needs owner')),
        SizedBox(width: 9),
        Expanded(
            child: _EvidenceMetric(Icons.north_east_rounded, Color(0xFF7657C8),
                '5', 'Escalated today', '2 active')),
        SizedBox(width: 9),
        Expanded(
            child: _EvidenceMetric(Icons.task_alt_rounded, AppColors.green,
                '31', 'Resolved today', '92% within SLA')),
      ]));
}

class _AlertFilters extends StatelessWidget {
  const _AlertFilters(
      {required this.query,
      required this.severity,
      required this.state,
      required this.onQuery,
      required this.onSeverity,
      required this.onState});
  final String query, severity, state;
  final ValueChanged<String> onQuery;
  final ValueChanged<String?> onSeverity, onState;
  @override
  Widget build(BuildContext context) => Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 11),
      decoration: const BoxDecoration(
          color: Color(0xFFF8FAFC),
          border: Border.symmetric(
              horizontal: BorderSide(color: AppColors.border))),
      child: Row(children: [
        SizedBox(
            width: 330,
            height: 40,
            child: TextField(
                onChanged: onQuery,
                decoration: const InputDecoration(
                    hintText: 'Search alert, source, agent or location',
                    prefixIcon: Icon(Icons.search_rounded, size: 19),
                    contentPadding: EdgeInsets.zero))),
        const SizedBox(width: 9),
        _FilterDropdown(
            severity,
            const ['All severities', 'Critical', 'Urgent', 'Informational'],
            Icons.priority_high_rounded,
            onSeverity),
        const SizedBox(width: 8),
        _FilterDropdown(
            state,
            const [
              'Open alerts',
              'All states',
              'New',
              'Acknowledged',
              'Assigned',
              'In progress',
              'Resolved',
              'Closed'
            ],
            Icons.account_tree_outlined,
            onState),
        const Spacer(),
        const StatusPill('REALTIME CONNECTED',
            color: AppColors.green, icon: Icons.sensors_rounded),
      ]));
}

class _AlertQueue extends StatelessWidget {
  const _AlertQueue(
      {required this.records,
      required this.selected,
      required this.states,
      required this.onSelected});
  final List<_AlertRecord> records;
  final String? selected;
  final Map<String, String> states;
  final ValueChanged<_AlertRecord> onSelected;
  @override
  Widget build(BuildContext context) => Container(
      color: Colors.white,
      child: Column(children: [
        Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 10, 10),
            child: Row(children: [
              Text('${records.length} ACTIVE ALERTS',
                  style: const TextStyle(
                      color: AppColors.muted,
                      fontSize: 9,
                      fontWeight: FontWeight.w900,
                      letterSpacing: .7)),
              const Spacer(),
              TextButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.sort_rounded, size: 15),
                  label: const Text('Severity + age'))
            ])),
        const Divider(height: 1),
        Expanded(
            child: records.isEmpty
                ? const _EmptyAlerts()
                : ListView.separated(
                    itemCount: records.length,
                    separatorBuilder: (_, __) => const Divider(height: 1),
                    itemBuilder: (_, i) {
                      final record = records[i];
                      final active = record.id == selected;
                      final state = states[record.id] ?? record.state;
                      return InkWell(
                          onTap: () => onSelected(record),
                          child: Container(
                              color: active
                                  ? record.color.withValues(alpha: .06)
                                  : Colors.white,
                              padding: const EdgeInsets.all(14),
                              child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                        width: 38,
                                        height: 38,
                                        decoration: BoxDecoration(
                                            color: record.color
                                                .withValues(alpha: .1),
                                            borderRadius:
                                                BorderRadius.circular(11)),
                                        child: Icon(record.icon,
                                            color: record.color, size: 19)),
                                    const SizedBox(width: 10),
                                    Expanded(
                                        child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                          Row(children: [
                                            Text(record.id,
                                                style: const TextStyle(
                                                    color: AppColors.navy,
                                                    fontSize: 9,
                                                    fontWeight:
                                                        FontWeight.w900)),
                                            const SizedBox(width: 6),
                                            StatusPill(
                                                record.severity.toUpperCase(),
                                                color: record.color),
                                            const Spacer(),
                                            Text(record.age,
                                                style: const TextStyle(
                                                    fontSize: 8))
                                          ]),
                                          const SizedBox(height: 6),
                                          Text(record.title,
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                  color: AppColors.navy,
                                                  fontSize: 11,
                                                  height: 1.25,
                                                  fontWeight: FontWeight.w900)),
                                          const SizedBox(height: 5),
                                          Text(record.location,
                                              overflow: TextOverflow.ellipsis,
                                              style:
                                                  const TextStyle(fontSize: 8)),
                                          const SizedBox(height: 6),
                                          Row(children: [
                                            StatusPill(state.toUpperCase(),
                                                color: state == 'Resolved'
                                                    ? AppColors.green
                                                    : AppColors.blue),
                                            if (record.ai) ...[
                                              const SizedBox(width: 6),
                                              const StatusPill('AI SIGNAL',
                                                  color: Color(0xFF7657C8),
                                                  icon: Icons
                                                      .auto_awesome_rounded)
                                            ],
                                            const Spacer(),
                                            Text('SLA ${record.sla}',
                                                style: TextStyle(
                                                    color: record.color,
                                                    fontSize: 8,
                                                    fontWeight:
                                                        FontWeight.w900))
                                          ])
                                        ])),
                                  ])));
                    })),
      ]));
}

class _AlertInspector extends StatelessWidget {
  const _AlertInspector(
      {required this.record,
      required this.state,
      required this.owner,
      required this.onAcknowledge,
      required this.onAssign,
      required this.onResolve,
      required this.onOpenSource});
  final _AlertRecord record;
  final String state, owner;
  final VoidCallback onAcknowledge, onAssign, onResolve, onOpenSource;
  @override
  Widget build(BuildContext context) => Container(
      color: const Color(0xFFF8FAFC),
      child: Column(children: [
        Container(
            padding: const EdgeInsets.all(17),
            color: Colors.white,
            child: Row(children: [
              Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                      color: record.color.withValues(alpha: .1),
                      borderRadius: BorderRadius.circular(12)),
                  child: Icon(record.icon, color: record.color, size: 21)),
              const SizedBox(width: 10),
              Expanded(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                    Row(children: [
                      Text(record.id,
                          style: const TextStyle(
                              color: AppColors.navy,
                              fontSize: 13,
                              fontWeight: FontWeight.w900)),
                      const SizedBox(width: 7),
                      StatusPill(record.severity.toUpperCase(),
                          color: record.color),
                      if (record.ai) ...[
                        const SizedBox(width: 6),
                        const StatusPill('AI GENERATED',
                            color: Color(0xFF7657C8))
                      ]
                    ]),
                    const SizedBox(height: 4),
                    Text(record.title,
                        style: const TextStyle(
                            color: AppColors.navy,
                            fontSize: 12,
                            fontWeight: FontWeight.w800))
                  ])),
              _MiniValue('AGE', record.age),
              const SizedBox(width: 16),
              _MiniValue('SLA', record.sla)
            ])),
        Expanded(
            child: ListView(padding: const EdgeInsets.all(17), children: [
          if (record.ai) ...[
            const InfoNotice(
                'This alert was generated by an AI model and remains advisory. A human must review the source session before treating it as confirmed.'),
            const SizedBox(height: 12)
          ],
          _ReviewSection(
              title: 'Alert context',
              icon: Icons.info_outline_rounded,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(record.detail,
                        style: const TextStyle(
                            color: AppColors.navy, fontSize: 11, height: 1.45)),
                    const SizedBox(height: 12),
                    _EvidenceDetail(Icons.location_on_outlined, 'Location',
                        record.location),
                    _EvidenceDetail(Icons.source_outlined, 'Trigger source',
                        '${record.source} • ${record.sourceId}'),
                    _EvidenceDetail(Icons.schedule_rounded, 'Created',
                        '${record.created} • ${record.age} ago'),
                    _EvidenceDetail(
                        Icons.person_outline_rounded, 'Assigned owner', owner)
                  ])),
          const SizedBox(height: 12),
          _ReviewSection(
              title: 'Notification delivery',
              icon: Icons.send_outlined,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(record.recipients,
                        style: const TextStyle(
                            color: AppColors.navy,
                            fontSize: 10,
                            fontWeight: FontWeight.w800)),
                    const SizedBox(height: 8),
                    Text(record.delivery, style: const TextStyle(fontSize: 9)),
                    const SizedBox(height: 9),
                    const Wrap(spacing: 6, runSpacing: 6, children: [
                      StatusPill('PUSH DELIVERED', color: AppColors.green),
                      StatusPill('IN-APP DELIVERED', color: AppColors.green),
                      StatusPill('ESCALATION ACTIVE', color: AppColors.amber)
                    ])
                  ])),
          const SizedBox(height: 12),
          _ReviewSection(
              title: 'Alert timeline',
              icon: Icons.history_rounded,
              child: Column(children: [
                _AuditEvent(record.created, 'Alert created',
                    '${record.source} • ${record.sourceId}'),
                const _AuditEvent('14:31:04', 'Notifications dispatched',
                    'Push, SMS and in-app channels'),
                if (state != 'New')
                  _AuditEvent(
                      '14:31:06', 'Alert ${state.toLowerCase()}', owner),
              ])),
        ])),
        Container(
            padding: const EdgeInsets.all(13),
            decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(top: BorderSide(color: AppColors.border))),
            child: Wrap(
                alignment: WrapAlignment.end,
                spacing: 7,
                runSpacing: 7,
                children: [
                  OutlinedButton.icon(
                      onPressed: onOpenSource,
                      icon: const Icon(Icons.open_in_new_rounded, size: 16),
                      label: const Text('Open source')),
                  OutlinedButton.icon(
                      onPressed: onAssign,
                      icon:
                          const Icon(Icons.person_add_alt_1_outlined, size: 16),
                      label: Text(
                          owner == 'Unassigned' ? 'Assign owner' : 'Reassign')),
                  if (state == 'New')
                    FilledButton.icon(
                        onPressed: onAcknowledge,
                        icon: const Icon(Icons.done_rounded, size: 16),
                        label: const Text('Acknowledge')),
                  if (state != 'Resolved' && state != 'Closed')
                    FilledButton.icon(
                        onPressed: onResolve,
                        style: FilledButton.styleFrom(
                            backgroundColor: AppColors.green),
                        icon: const Icon(Icons.task_alt_rounded, size: 16),
                        label: const Text('Resolve alert')),
                ])),
      ]));
}

class _AlertOperationsRail extends StatelessWidget {
  const _AlertOperationsRail();
  @override
  Widget build(BuildContext context) => Container(
      color: Colors.white,
      child: ListView(padding: const EdgeInsets.all(15), children: [
        const Text('ESCALATION WATCH',
            style: TextStyle(
                color: AppColors.muted,
                fontSize: 9,
                fontWeight: FontWeight.w900,
                letterSpacing: .7)),
        const SizedBox(height: 10),
        const _AttentionCard(AppColors.red, Icons.timer_outlined,
            'Critical SLA • 04:18', 'ALT-0092 • unacknowledged', _noop),
        const SizedBox(height: 8),
        const _AttentionCard(AppColors.amber, Icons.north_east_rounded,
            'Escalation in 12:44', 'ALT-0089 • verification queue', _noop),
        const Divider(height: 27),
        const Text('ALERT PIPELINE',
            style: TextStyle(
                color: AppColors.muted,
                fontSize: 9,
                fontWeight: FontWeight.w900,
                letterSpacing: .7)),
        const SizedBox(height: 10),
        const _LifecycleStep('Event received', true),
        const _LifecycleStep('Rule / model evaluated', true),
        const _LifecycleStep('Alert created', true),
        const _LifecycleStep('Recipients notified', true),
        const _LifecycleStep('Human acknowledgement', false),
        const _LifecycleStep('Resolution and closure', false),
        const Divider(height: 27),
        const Text('SERVICE HEALTH',
            style: TextStyle(
                color: AppColors.muted,
                fontSize: 9,
                fontWeight: FontWeight.w900,
                letterSpacing: .7)),
        const SizedBox(height: 10),
        const _GovernanceRow(
            Icons.sensors_rounded, 'Realtime connection', 'Healthy'),
        const SizedBox(height: 10),
        const _GovernanceRow(
            Icons.notifications_active_outlined, 'Push delivery', '99.4%'),
        const SizedBox(height: 10),
        const _GovernanceRow(Icons.sms_outlined, 'SMS fallback', 'Available'),
        const SizedBox(height: 10),
        const _GovernanceRow(
            Icons.history_rounded, 'Missed-event replay', 'Active'),
        const SizedBox(height: 13),
        const InfoNotice(
            'Acknowledging an alert never resolves its linked incident or verifies its underlying information.'),
      ]));
}

void _noop() {}

class _EmptyAlerts extends StatelessWidget {
  const _EmptyAlerts();
  @override
  Widget build(BuildContext context) => const Center(
          child: Column(mainAxisSize: MainAxisSize.min, children: [
        Icon(Icons.notifications_off_outlined, color: AppColors.blue, size: 42),
        SizedBox(height: 10),
        Text('No alerts match these filters',
            style:
                TextStyle(color: AppColors.navy, fontWeight: FontWeight.w800))
      ]));
}
