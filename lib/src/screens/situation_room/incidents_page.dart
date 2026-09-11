part of 'situation_room_page.dart';

class _IncidentRecord {
  const _IncidentRecord(
      this.id,
      this.title,
      this.type,
      this.severity,
      this.status,
      this.ward,
      this.unit,
      this.owner,
      this.age,
      this.sla,
      this.reports,
      this.evidence,
      this.comms,
      this.ai,
      this.color);
  final String id,
      title,
      type,
      severity,
      status,
      ward,
      unit,
      owner,
      age,
      sla,
      reports,
      evidence,
      comms,
      ai;
  final Color color;
}

class _IncidentOperationsPage extends StatefulWidget {
  const _IncidentOperationsPage({required this.onOpenIncident});
  final ValueChanged<String> onOpenIncident;
  @override
  State<_IncidentOperationsPage> createState() =>
      _IncidentOperationsPageState();
}

class _IncidentOperationsPageState extends State<_IncidentOperationsPage> {
  String _query = '';
  String _severity = 'All severities';
  String _state = 'Open states';
  String _view = 'Command board';

  static const _incidents = <_IncidentRecord>[
    _IncidentRecord(
        'INC-00518',
        'Reported disturbance at polling-unit entrance',
        'Access disruption',
        'Critical',
        'Action in progress',
        'Kwarbai \'A\'',
        'Polling Unit 014',
        'Musa Bello',
        '18m',
        '04:18',
        '3 reports • 2 verified',
        '2 photos • 1 video',
        'Incident room active',
        'Crowd pattern • unverified',
        AppColors.red),
    _IncidentRecord(
        'INC-00512',
        'Accredited observers delayed at entrance',
        'Access disruption',
        'Critical',
        'Investigating',
        'Tudun Wada',
        'Polling Unit 028',
        'Unassigned',
        '31m',
        '12:06',
        '2 reports • conflict',
        '3 photos',
        'Agent call ringing',
        'Source conflict • 74%',
        AppColors.red),
    _IncidentRecord(
        'INC-00496',
        'Communication loss with field team',
        'Communication loss',
        'High',
        'Escalated',
        'Gyallesu',
        'Polling Unit 009',
        'T. Musa',
        '44m',
        '22:41',
        '1 report • under review',
        'Upload pending',
        '3 failed attempts',
        'Network anomaly',
        AppColors.amber),
    _IncidentRecord(
        'INC-00484',
        'Polling materials count discrepancy',
        'Materials',
        'Medium',
        'Verification pending',
        'Tudun Wada',
        'Polling Unit 016',
        'N. Ibrahim',
        '1h 08m',
        '34:20',
        '4 reports • 3 align',
        '5 photos',
        'No active session',
        'Count conflict • unverified',
        AppColors.blue),
    _IncidentRecord(
        'INC-00461',
        'Temporary crowd congestion resolved',
        'Crowd management',
        'Medium',
        'Resolved',
        'Kaura',
        'Polling Unit 031',
        'S. Shuaibu',
        '2h 14m',
        'Met',
        '4 reports • verified',
        '2 videos',
        'Session ended',
        'No active signal',
        AppColors.green),
  ];

  List<_IncidentRecord> get _filtered => _incidents.where((incident) {
        final q = _query.toLowerCase();
        final stateMatch = _state == 'All states' ||
            (_state == 'Open states'
                ? incident.status != 'Resolved' && incident.status != 'Closed'
                : incident.status == _state);
        return (_severity == 'All severities' ||
                incident.severity == _severity) &&
            stateMatch &&
            (q.isEmpty ||
                '${incident.id} ${incident.title} ${incident.type} ${incident.ward} ${incident.unit} ${incident.owner}'
                    .toLowerCase()
                    .contains(q));
      }).toList();

  @override
  Widget build(BuildContext context) {
    final incidents = _filtered;
    return Column(children: [
      _IncidentCenterHeader(onCreate: _createIncident),
      const _IncidentMetrics(),
      _IncidentFilters(
          query: _query,
          severity: _severity,
          state: _state,
          view: _view,
          onQuery: (v) => setState(() => _query = v),
          onSeverity: (v) => setState(() => _severity = v!),
          onState: (v) => setState(() => _state = v!),
          onView: (v) => setState(() => _view = v)),
      Expanded(
          child: Row(children: [
        Expanded(
            child: _IncidentCommandTable(
                incidents: incidents, onOpen: widget.onOpenIncident)),
        Container(width: 1, color: AppColors.border),
        SizedBox(
            width: 315,
            child: _IncidentCommandRail(onOpen: widget.onOpenIncident)),
      ])),
    ]);
  }

  void _createIncident() => showDialog<void>(
      context: context,
      builder: (_) => AlertDialog(
            title: const Row(children: [
              Icon(Icons.add_alert_outlined, color: AppColors.red),
              SizedBox(width: 10),
              Text('Create command incident')
            ]),
            content: const SizedBox(
                width: 520,
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  InfoNotice(
                      'Creating an incident does not verify its source reports. Verification state remains visible throughout the incident lifecycle.'),
                  SizedBox(height: 14),
                  Row(children: [
                    Expanded(
                        child: TextField(
                            decoration:
                                InputDecoration(labelText: 'Incident title'))),
                    SizedBox(width: 10),
                    Expanded(
                        child: TextField(
                            decoration: InputDecoration(
                                labelText: 'Related report or SOS ID')))
                  ]),
                  SizedBox(height: 10),
                  Row(children: [
                    Expanded(
                        child: TextField(
                            decoration: InputDecoration(
                                labelText: 'Ward / polling unit'))),
                    SizedBox(width: 10),
                    Expanded(
                        child: TextField(
                            decoration:
                                InputDecoration(labelText: 'Commander')))
                  ]),
                  SizedBox(height: 10),
                  TextField(
                      minLines: 2,
                      maxLines: 4,
                      decoration: InputDecoration(
                          labelText: 'Triage note and creation reason',
                          alignLabelWithHint: true)),
                ])),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel')),
              FilledButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text(
                            'Incident created in New state • audit record added')));
                  },
                  style: FilledButton.styleFrom(backgroundColor: AppColors.red),
                  icon: const Icon(Icons.add_alert_outlined),
                  label: const Text('Create incident'))
            ],
          ));
}

class _IncidentCenterHeader extends StatelessWidget {
  const _IncidentCenterHeader({required this.onCreate});
  final VoidCallback onCreate;
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
                    colors: [AppColors.red, Color(0xFFFF8748)]),
                borderRadius: BorderRadius.circular(14),
                boxShadow: const [
                  BoxShadow(
                      color: Color(0x33D94646),
                      blurRadius: 16,
                      offset: Offset(0, 6))
                ]),
            child:
                const Icon(Icons.warning_amber_rounded, color: Colors.white)),
        const SizedBox(width: 13),
        Expanded(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Incident command',
              style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 3),
          const Text(
              'Triage, investigate, coordinate and resolve operational incidents',
              overflow: TextOverflow.ellipsis)
        ])),
        const StatusPill('4 CRITICAL',
            color: AppColors.red, icon: Icons.notifications_active_outlined),
        const SizedBox(width: 8),
        OutlinedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.history_rounded, size: 17),
            label: const Text('Replay')),
        const SizedBox(width: 8),
        FilledButton.icon(
            onPressed: onCreate,
            style: FilledButton.styleFrom(backgroundColor: AppColors.red),
            icon: const Icon(Icons.add_rounded, size: 17),
            label: const Text('Create incident')),
      ]));
}

class _IncidentMetrics extends StatelessWidget {
  const _IncidentMetrics();
  @override
  Widget build(BuildContext context) => Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
      child: const Row(children: [
        Expanded(
            child: _EvidenceMetric(Icons.warning_amber_rounded, AppColors.red,
                '23', 'Open incidents', '4 critical')),
        SizedBox(width: 10),
        Expanded(
            child: _EvidenceMetric(Icons.timer_outlined, AppColors.amber, '3',
                'SLA at risk', 'Next in 04:18')),
        SizedBox(width: 10),
        Expanded(
            child: _EvidenceMetric(Icons.person_search_outlined, AppColors.blue,
                '2', 'Unassigned', 'Needs commander')),
        SizedBox(width: 10),
        Expanded(
            child: _EvidenceMetric(Icons.fact_check_outlined, Color(0xFF7657C8),
                '6', 'Verification pending', '9 source reports')),
        SizedBox(width: 10),
        Expanded(
            child: _EvidenceMetric(Icons.task_alt_rounded, AppColors.green,
                '17', 'Resolved today', '94% within SLA')),
      ]));
}

class _IncidentFilters extends StatelessWidget {
  const _IncidentFilters(
      {required this.query,
      required this.severity,
      required this.state,
      required this.view,
      required this.onQuery,
      required this.onSeverity,
      required this.onState,
      required this.onView});
  final String query, severity, state, view;
  final ValueChanged<String> onQuery, onView;
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
            width: 300,
            height: 40,
            child: TextField(
                onChanged: onQuery,
                decoration: const InputDecoration(
                    hintText: 'Search ID, type, unit, ward or owner',
                    prefixIcon: Icon(Icons.search_rounded, size: 19),
                    contentPadding: EdgeInsets.zero))),
        const SizedBox(width: 9),
        _FilterDropdown(
            severity,
            const ['All severities', 'Critical', 'High', 'Medium', 'Low'],
            Icons.priority_high_rounded,
            onSeverity),
        const SizedBox(width: 8),
        _FilterDropdown(
            state,
            const [
              'Open states',
              'All states',
              'New',
              'Investigating',
              'Verification pending',
              'Escalated',
              'Resolved'
            ],
            Icons.account_tree_outlined,
            onState),
        const Spacer(),
        SegmentedButton<String>(
            segments: const [
              ButtonSegment(
                  value: 'Command board',
                  icon: Icon(Icons.table_rows_outlined, size: 16)),
              ButtonSegment(
                  value: 'Map', icon: Icon(Icons.map_outlined, size: 16))
            ],
            selected: {
              view
            },
            onSelectionChanged: (v) => onView(v.first),
            showSelectedIcon: false,
            style: const ButtonStyle(visualDensity: VisualDensity.compact)),
      ]));
}

class _IncidentCommandTable extends StatelessWidget {
  const _IncidentCommandTable({required this.incidents, required this.onOpen});
  final List<_IncidentRecord> incidents;
  final ValueChanged<String> onOpen;
  @override
  Widget build(BuildContext context) => Container(
      color: Colors.white,
      child: Column(children: [
        Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 14, 10),
            child: Row(children: [
              Text('${incidents.length} INCIDENTS',
                  style: const TextStyle(
                      color: AppColors.muted,
                      fontSize: 9,
                      fontWeight: FontWeight.w900,
                      letterSpacing: .7)),
              const Spacer(),
              TextButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.sort_rounded, size: 15),
                  label: const Text('Severity + SLA'))
            ])),
        const Divider(height: 1),
        Expanded(
            child: incidents.isEmpty
                ? const Center(child: Text('No incidents match these filters'))
                : ListView.separated(
                    itemCount: incidents.length,
                    separatorBuilder: (_, __) => const Divider(height: 1),
                    itemBuilder: (_, i) => _IncidentCommandRow(
                        incident: incidents[i],
                        onOpen: () => onOpen(incidents[i].id)))),
      ]));
}

class _IncidentCommandRow extends StatelessWidget {
  const _IncidentCommandRow({required this.incident, required this.onOpen});
  final _IncidentRecord incident;
  final VoidCallback onOpen;
  @override
  Widget build(BuildContext context) => InkWell(
      onTap: onOpen,
      child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 13, 12, 13),
          child: Row(children: [
            Container(
                width: 4,
                height: 64,
                decoration: BoxDecoration(
                    color: incident.color,
                    borderRadius: BorderRadius.circular(4))),
            const SizedBox(width: 11),
            Expanded(
                flex: 4,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Wrap(spacing: 6, runSpacing: 4, children: [
                        Text(incident.id,
                            style: const TextStyle(
                                color: AppColors.navy,
                                fontSize: 10,
                                fontWeight: FontWeight.w900)),
                        StatusPill(incident.severity.toUpperCase(),
                            color: incident.color),
                        StatusPill(incident.status.toUpperCase(),
                            color: incident.status == 'Resolved'
                                ? AppColors.green
                                : AppColors.blue)
                      ]),
                      const SizedBox(height: 6),
                      Text(incident.title,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              color: AppColors.navy,
                              fontSize: 11,
                              fontWeight: FontWeight.w900)),
                      const SizedBox(height: 4),
                      Text(
                          '${incident.type} • ${incident.ward} • ${incident.unit}',
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 9))
                    ])),
            Expanded(
                flex: 2,
                child: _IncidentCell(
                    'OWNER',
                    incident.owner,
                    incident.owner == 'Unassigned'
                        ? AppColors.red
                        : AppColors.navy)),
            Expanded(
                flex: 2,
                child:
                    _IncidentCell('SOURCES', incident.reports, AppColors.navy)),
            Expanded(
                flex: 2,
                child: _IncidentCell(
                    'EVIDENCE', incident.evidence, AppColors.navy)),
            SizedBox(
                width: 75,
                child: _IncidentCell('AGE', incident.age, AppColors.navy)),
            SizedBox(
                width: 70,
                child: _IncidentCell('SLA', incident.sla,
                    incident.sla == 'Met' ? AppColors.green : incident.color)),
            IconButton(
                onPressed: onOpen,
                tooltip: 'Open incident console',
                icon: const Icon(Icons.open_in_new_rounded, size: 18)),
          ])));
}

class _IncidentCell extends StatelessWidget {
  const _IncidentCell(this.label, this.value, this.color);
  final String label, value;
  final Color color;
  @override
  Widget build(BuildContext context) =>
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(label,
            style: const TextStyle(
                color: AppColors.muted,
                fontSize: 7,
                fontWeight: FontWeight.w900)),
        const SizedBox(height: 4),
        Text(value,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
                color: color,
                fontSize: 9,
                height: 1.25,
                fontWeight: FontWeight.w800))
      ]);
}

class _IncidentCommandRail extends StatelessWidget {
  const _IncidentCommandRail({required this.onOpen});
  final ValueChanged<String> onOpen;
  @override
  Widget build(BuildContext context) => Container(
      color: const Color(0xFFF8FAFC),
      child: ListView(padding: const EdgeInsets.all(15), children: [
        const Row(children: [
          Expanded(
              child: Text('COMMAND ATTENTION',
                  style: TextStyle(
                      color: AppColors.muted,
                      fontSize: 9,
                      fontWeight: FontWeight.w900,
                      letterSpacing: .7))),
          StatusPill('LIVE', color: AppColors.green, icon: Icons.circle)
        ]),
        const SizedBox(height: 10),
        _AttentionCard(
            AppColors.red,
            Icons.timer_outlined,
            'SLA expires in 04:18',
            'INC-00518 • response in progress',
            () => onOpen('INC-00518')),
        const SizedBox(height: 8),
        _AttentionCard(
            AppColors.red,
            Icons.person_off_outlined,
            'Commander unassigned',
            'INC-00512 • critical • open 31m',
            () => onOpen('INC-00512')),
        const SizedBox(height: 8),
        _AttentionCard(
            AppColors.amber,
            Icons.call_missed_outgoing_rounded,
            'Communication failed',
            'INC-00496 • retry 3 of 3',
            () => onOpen('INC-00496')),
        const Divider(height: 28),
        const Text('AI-ASSISTED SIGNALS',
            style: TextStyle(
                color: AppColors.muted,
                fontSize: 9,
                fontWeight: FontWeight.w900,
                letterSpacing: .7)),
        const SizedBox(height: 9),
        const _InsightItem(Icons.hub_outlined, AppColors.blue,
            'Related report cluster', 'INC-00518 • 3 sources • 87% similarity'),
        const _InsightItem(Icons.compare_arrows_rounded, AppColors.amber,
            'Material source conflict', 'INC-00512 • access claim differs'),
        const _InsightItem(Icons.graphic_eq_rounded, Color(0xFF7657C8),
            'Acoustic report ready', 'INC-00518 • human review required'),
        const InfoNotice(
            'AI signals are unverified recommendations. They cannot change incident severity, status or verification outcomes.'),
        const Divider(height: 28),
        const Text('LIFECYCLE',
            style: TextStyle(
                color: AppColors.muted,
                fontSize: 9,
                fontWeight: FontWeight.w900,
                letterSpacing: .7)),
        const SizedBox(height: 10),
        const _LifecycleStep('New', true),
        _LifecycleStep('Triaged', true),
        _LifecycleStep('Investigating', true),
        _LifecycleStep('Verification pending', false),
        _LifecycleStep('Action in progress', false),
        _LifecycleStep('Resolved / closed', false),
      ]));
}

class _AttentionCard extends StatelessWidget {
  const _AttentionCard(
      this.color, this.icon, this.title, this.detail, this.onTap);
  final Color color;
  final IconData icon;
  final String title, detail;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => Material(
      color: color.withValues(alpha: .07),
      borderRadius: BorderRadius.circular(11),
      child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(11),
          child: Padding(
              padding: const EdgeInsets.all(11),
              child: Row(children: [
                Icon(icon, color: color, size: 19),
                const SizedBox(width: 8),
                Expanded(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                      Text(title,
                          style: const TextStyle(
                              color: AppColors.navy,
                              fontSize: 10,
                              fontWeight: FontWeight.w900)),
                      const SizedBox(height: 2),
                      Text(detail, style: const TextStyle(fontSize: 8))
                    ])),
                const Icon(Icons.chevron_right_rounded,
                    color: AppColors.muted, size: 17)
              ]))));
}

class _LifecycleStep extends StatelessWidget {
  const _LifecycleStep(this.label, this.complete);
  final String label;
  final bool complete;
  @override
  Widget build(BuildContext context) => Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(children: [
        Icon(
            complete
                ? Icons.check_circle_rounded
                : Icons.radio_button_unchecked_rounded,
            color: complete ? AppColors.green : AppColors.muted,
            size: 15),
        const SizedBox(width: 7),
        Text(label,
            style: TextStyle(
                color: complete ? AppColors.navy : AppColors.muted,
                fontSize: 9,
                fontWeight: FontWeight.w700))
      ]));
}

class _IncidentConsole extends StatefulWidget {
  const _IncidentConsole({required this.id});
  final String id;
  @override
  State<_IncidentConsole> createState() => _IncidentConsoleState();
}

class _IncidentConsoleState extends State<_IncidentConsole> {
  String _status = 'Investigating';
  @override
  Widget build(BuildContext context) => Column(children: [
        Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
                color: AppColors.navy,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
            child: Row(children: [
              const CircleAvatar(
                  backgroundColor: AppColors.red,
                  child: Icon(Icons.warning_rounded, color: Colors.white)),
              const SizedBox(width: 12),
              Expanded(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                    Row(children: [
                      Text(widget.id,
                          style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w900,
                              fontSize: 16)),
                      const SizedBox(width: 9),
                      const StatusPill('CRITICAL', color: Color(0xFFFF7777))
                    ]),
                    const SizedBox(height: 4),
                    const Text('Reported disturbance at Polling Unit 014',
                        style: TextStyle(color: Colors.white70, fontSize: 12))
                  ])),
              const _MiniDarkValue('AGE', '11m 42s'),
              const SizedBox(width: 22),
              const _MiniDarkValue('SLA', '04:18'),
              const SizedBox(width: 12),
              IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close_rounded, color: Colors.white))
            ])),
        Expanded(
            child: Row(children: [
          Expanded(
              flex: 2,
              child: ListView(padding: const EdgeInsets.all(20), children: [
                const Text('Incident timeline',
                    style: TextStyle(
                        color: AppColors.navy,
                        fontWeight: FontWeight.w800,
                        fontSize: 16)),
                const SizedBox(height: 15),
                const _Timeline('14:31:02', 'Agent secure call active',
                    'Call linked to incident context', AppColors.blue),
                const _Timeline('14:31:06', 'Alert acknowledged',
                    'Operator: Sani Shuaibu', AppColors.amber),
                const _Timeline('14:31:10', 'Incident created',
                    'Created from Agent SOS', AppColors.red),
                const _Timeline('14:31:18', 'Live-video request sent',
                    'Awaiting explicit agent acceptance', Color(0xFF7657C8)),
                const _Timeline('14:31:26', 'Agent accepted request',
                    'Encrypted video session active', AppColors.green),
                const _Timeline('14:31:33', 'Evidence received',
                    'Segment 1 • integrity verified', AppColors.green)
              ])),
          Container(
              width: 330,
              color: const Color(0xFFF8FAFC),
              padding: const EdgeInsets.all(18),
              child: ListView(children: [
                const Text('Command actions',
                    style: TextStyle(
                        color: AppColors.navy, fontWeight: FontWeight.w800)),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                    isExpanded: true,
                    initialValue: _status,
                    decoration:
                        const InputDecoration(labelText: 'Incident state'),
                    items: [
                      'Triaged',
                      'Investigating',
                      'Verification Pending',
                      'Escalated',
                      'Action in Progress',
                      'Resolved'
                    ]
                        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),
                    onChanged: (v) => setState(() => _status = v!)),
                const SizedBox(height: 12),
                const _DetailCard('ASSIGNMENT', 'Commander', 'Musa Bello'),
                const SizedBox(height: 10),
                const _DetailCard('LOCATION', 'Kwarbai \'A\'', 'PU-014 • ±12m'),
                const SizedBox(height: 10),
                const _DetailCard('SOURCE STATUS', '2 independent reports',
                    '1 verified • 1 under review'),
                const SizedBox(height: 14),
                FilledButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.call_rounded),
                    label: const Text('Start secure call')),
                const SizedBox(height: 8),
                OutlinedButton.icon(
                    onPressed: () => _consentDialog(context),
                    icon: const Icon(Icons.videocam_outlined),
                    label: const Text('Request live video')),
                const SizedBox(height: 8),
                OutlinedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.fact_check_outlined),
                    label: const Text('Request verification'))
              ]))
        ])),
      ]);

  void _consentDialog(BuildContext context) => showDialog<void>(
      context: context,
      builder: (_) => AlertDialog(
              title: const Text('Request live video?'),
              content: const Text(
                  'The agent must explicitly accept this request. No camera or microphone will activate before consent.'),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel')),
                FilledButton(
                    onPressed: () {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text(
                              'Media request sent • expires in 60 seconds')));
                    },
                    child: const Text('Send request'))
              ]));
}

class _MiniDarkValue extends StatelessWidget {
  const _MiniDarkValue(this.label, this.value);
  final String label, value;
  @override
  Widget build(BuildContext context) =>
      Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
        Text(label,
            style: const TextStyle(
                color: Colors.white54,
                fontSize: 8,
                fontWeight: FontWeight.w800)),
        Text(value,
            style: const TextStyle(
                color: Colors.white, fontSize: 12, fontWeight: FontWeight.w800))
      ]);
}

class _Timeline extends StatelessWidget {
  const _Timeline(this.time, this.title, this.detail, this.color);
  final String time, title, detail;
  final Color color;
  @override
  Widget build(BuildContext context) => IntrinsicHeight(
          child: Row(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        SizedBox(
            width: 64,
            child: Text(time,
                style: const TextStyle(
                    color: AppColors.muted,
                    fontSize: 10,
                    fontWeight: FontWeight.w700))),
        Column(children: [
          Container(
              width: 11,
              height: 11,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
          Expanded(child: Container(width: 2, color: AppColors.border))
        ]),
        const SizedBox(width: 13),
        Expanded(
            child: Padding(
                padding: const EdgeInsets.only(bottom: 22),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title,
                          style: const TextStyle(
                              color: AppColors.navy,
                              fontWeight: FontWeight.w800,
                              fontSize: 12)),
                      const SizedBox(height: 3),
                      Text(detail, style: const TextStyle(fontSize: 10))
                    ])))
      ]));
}

class _DetailCard extends StatelessWidget {
  const _DetailCard(this.label, this.title, this.detail);
  final String label, title, detail;
  @override
  Widget build(BuildContext context) => Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: AppColors.border),
          borderRadius: BorderRadius.circular(10)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(label,
            style: const TextStyle(
                color: AppColors.muted,
                fontSize: 8,
                fontWeight: FontWeight.w800,
                letterSpacing: .7)),
        const SizedBox(height: 5),
        Text(title,
            style: const TextStyle(
                color: AppColors.navy,
                fontWeight: FontWeight.w800,
                fontSize: 12)),
        const SizedBox(height: 2),
        Text(detail, style: const TextStyle(fontSize: 10))
      ]));
}
