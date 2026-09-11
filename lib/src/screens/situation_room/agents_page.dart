part of 'situation_room_page.dart';

class _AgentRecord {
  const _AgentRecord(
      {required this.id,
      required this.name,
      required this.initials,
      required this.unit,
      required this.ward,
      required this.role,
      required this.phone,
      required this.presence,
      required this.lastSeen,
      required this.comms,
      required this.acoustic,
      required this.acousticDetail,
      required this.device,
      required this.version,
      required this.accuracy,
      required this.group,
      required this.color});
  final String id,
      name,
      initials,
      unit,
      ward,
      role,
      phone,
      presence,
      lastSeen,
      comms,
      acoustic,
      acousticDetail,
      device,
      version,
      accuracy,
      group;
  final Color color;
}

class _AgentOperationsPage extends StatefulWidget {
  const _AgentOperationsPage({required this.readOnly});
  final bool readOnly;
  @override
  State<_AgentOperationsPage> createState() => _AgentOperationsPageState();
}

class _AgentOperationsPageState extends State<_AgentOperationsPage> {
  int _selected = 0;
  String _query = '';
  String _presence = 'All agents';
  final Set<String> _requestedReports = {};

  static const _agents = <_AgentRecord>[
    _AgentRecord(
        id: 'AGT-041',
        name: 'Amina Yusuf',
        initials: 'AY',
        unit: 'Polling Unit 014',
        ward: 'Kwarbai \'A\'',
        role: 'Lead Field Agent',
        phone: '+234 ••• ••• 041',
        presence: 'Online',
        lastSeen: 'Live now',
        comms: 'Available',
        acoustic: 'Active',
        acousticDetail: 'Authorized secure call • 06:42',
        device: 'Android • authorized',
        version: 'Field app 1.8.4',
        accuracy: '12 m • updated 20s ago',
        group: 'Kwarbai Response Team',
        color: AppColors.green),
    _AgentRecord(
        id: 'AGT-074',
        name: 'Kabir Musa',
        initials: 'KM',
        unit: 'Polling Unit 028',
        ward: 'Tudun Wada',
        role: 'Field Agent',
        phone: '+234 ••• ••• 074',
        presence: 'Online',
        lastSeen: '1m ago',
        comms: 'In call',
        acoustic: 'Available',
        acousticDetail: 'No analysis session running',
        device: 'Android • authorized',
        version: 'Field app 1.8.4',
        accuracy: '28 m • updated 2m ago',
        group: 'Tudun Wada North Team',
        color: AppColors.blue),
    _AgentRecord(
        id: 'AGT-088',
        name: 'Fatima Ali',
        initials: 'FA',
        unit: 'Polling Unit 009',
        ward: 'Gyallesu',
        role: 'Verification Liaison',
        phone: '+234 ••• ••• 088',
        presence: 'Degraded',
        lastSeen: '4m ago',
        comms: 'Weak network',
        acoustic: 'Unavailable',
        acousticDetail: 'No authorized live communication',
        device: 'Android • authorized',
        version: 'Field app 1.8.3',
        accuracy: '96 m • low accuracy',
        group: 'Gyallesu Verification Team',
        color: AppColors.amber),
    _AgentRecord(
        id: 'AGT-052',
        name: 'Tunde Obi',
        initials: 'TO',
        unit: 'Polling Unit 031',
        ward: 'Kaura',
        role: 'Field Agent',
        phone: '+234 ••• ••• 052',
        presence: 'Offline',
        lastSeen: '18m ago',
        comms: 'Unreachable',
        acoustic: 'Off',
        acousticDetail: 'Agent offline • no active session',
        device: 'Android • authorized',
        version: 'Field app 1.8.4',
        accuracy: 'Last known • 31m ago',
        group: 'Kaura East Team',
        color: AppColors.red),
    _AgentRecord(
        id: 'AGT-106',
        name: 'Ngozi Eze',
        initials: 'NE',
        unit: 'Polling Unit 022',
        ward: 'Kwarbai \'A\'',
        role: 'Evidence Officer',
        phone: '+234 ••• ••• 106',
        presence: 'Online',
        lastSeen: 'Live now',
        comms: 'Available',
        acoustic: 'Review ready',
        acousticDetail: 'AI report available from 13:48 call',
        device: 'iOS • authorized',
        version: 'Field app 1.8.4',
        accuracy: '9 m • updated 35s ago',
        group: 'Kwarbai Response Team',
        color: Color(0xFF7657C8)),
  ];

  List<_AgentRecord> get _filtered => _agents.where((agent) {
        final q = _query.toLowerCase();
        return (_presence == 'All agents' || agent.presence == _presence) &&
            (q.isEmpty ||
                '${agent.name} ${agent.id} ${agent.unit} ${agent.ward} ${agent.group}'
                    .toLowerCase()
                    .contains(q));
      }).toList();

  @override
  Widget build(BuildContext context) {
    final agents = _filtered;
    final selected =
        agents.isEmpty ? null : agents[_selected.clamp(0, agents.length - 1)];
    final readOnly = widget.readOnly;
    return Column(children: [
      _AgentHeader(readOnly: readOnly),
      const _AgentMetrics(),
      _AgentFilters(
          query: _query,
          presence: _presence,
          onQuery: (v) => setState(() {
                _query = v;
                _selected = 0;
              }),
          onPresence: (v) => setState(() {
                _presence = v!;
                _selected = 0;
              })),
      Expanded(
          child: Row(children: [
        Expanded(
            flex: 6,
            child: _AgentDirectory(
                agents: agents,
                selected: selected?.id,
                onSelected: (agent) =>
                    setState(() => _selected = agents.indexOf(agent)),
                onCall: readOnly ? null : _startCall)),
        Container(width: 1, color: AppColors.border),
        Expanded(
            flex: 4,
            child: selected == null
                ? const _EmptyAgents()
                : _AgentInspector(
                    agent: selected,
                    readOnly: readOnly,
                    reportRequested: _requestedReports.contains(selected.id),
                    onCall: () => _startCall(selected),
                    onRequestReport: () => _requestAcousticReport(selected))),
      ])),
    ]);
  }

  void _startCall(_AgentRecord agent) => showDialog<void>(
      context: context,
      builder: (_) => AlertDialog(
            title: Row(children: [
              CircleAvatar(
                  backgroundColor: agent.color.withValues(alpha: .12),
                  child: Text(agent.initials,
                      style: TextStyle(
                          color: agent.color, fontWeight: FontWeight.w900))),
              const SizedBox(width: 11),
              Expanded(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                    Text('Call ${agent.name}',
                        style: const TextStyle(fontSize: 18)),
                    Text('${agent.id} • ${agent.unit}',
                        style: const TextStyle(
                            color: AppColors.muted, fontSize: 10))
                  ]))
            ]),
            content: SizedBox(
                width: 440,
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  const Wrap(spacing: 6, runSpacing: 6, children: [
                    StatusPill('END-TO-END ENCRYPTED',
                        color: AppColors.green,
                        icon: Icons.lock_outline_rounded),
                    StatusPill('SCREEN-RECORD DETECTION',
                        color: AppColors.blue,
                        icon: Icons.visibility_outlined),
                    StatusPill('SCREENSHOT BLOCKED',
                        color: Color(0xFF7657C8),
                        icon: Icons.no_photography_outlined),
                  ]),
                  const SizedBox(height: 12),
                  const InfoNotice(
                      'Secure calls are authenticated and audited. Acoustic AI only runs if policy permits and the call participant is visibly informed. Recording detection and screenshot blocking require native platform integration before production use.'),
                  const SizedBox(height: 14),
                  _CallOption(Icons.call_rounded, AppColors.green,
                      'Secure voice', 'Encrypted audio call',
                      enabled: agent.presence != 'Offline'),
                  const SizedBox(height: 8),
                  _CallOption(Icons.videocam_outlined, AppColors.blue,
                      'Secure video', 'Requires agent acceptance',
                      enabled: agent.presence != 'Offline'),
                ])),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel')),
              FilledButton.icon(
                  onPressed: agent.presence == 'Offline'
                      ? null
                      : () {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(
                                  'Secure call request sent to ${agent.name}')));
                        },
                  icon: const Icon(Icons.call_rounded),
                  label: const Text('Request call'))
            ],
          ));

  void _requestAcousticReport(_AgentRecord agent) => showDialog<void>(
      context: context,
      builder: (_) => AlertDialog(
            title: const Row(children: [
              Icon(Icons.graphic_eq_rounded, color: Color(0xFF7657C8)),
              SizedBox(width: 10),
              Text('Request acoustic AI report')
            ]),
            content: SizedBox(
                width: 480,
                child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${agent.name} • ${agent.id} • ${agent.unit}',
                          style: const TextStyle(
                              color: AppColors.navy,
                              fontWeight: FontWeight.w800)),
                      const SizedBox(height: 12),
                      const InfoNotice(
                          'This requests analysis of an existing authorized communication session. It does not activate the agent microphone, start a recording, or create verified facts.'),
                      const SizedBox(height: 14),
                      const _AcousticCheck(
                          Icons.lock_outline_rounded,
                          'Authorized session required',
                          'Confirmed by communication-service policy'),
                      const _AcousticCheck(
                          Icons.visibility_outlined,
                          'Visible analysis state',
                          'Agent and operator can see when analysis is active'),
                      const _AcousticCheck(
                          Icons.person_search_outlined,
                          'Human review required',
                          'Signals remain unverified until reviewed'),
                    ])),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel')),
              FilledButton.icon(
                  onPressed:
                      agent.acoustic == 'Unavailable' || agent.acoustic == 'Off'
                          ? null
                          : () {
                              setState(() => _requestedReports.add(agent.id));
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                  content: Text(
                                      'Acoustic AI report requested for ${agent.id}')));
                            },
                  icon: const Icon(Icons.auto_awesome_rounded),
                  label: const Text('Request report'))
            ],
          ));
}

class _AgentHeader extends StatelessWidget {
  const _AgentHeader({required this.readOnly});
  final bool readOnly;
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
                    colors: [Color(0xFF246BFD), Color(0xFF28C2D1)]),
                borderRadius: BorderRadius.circular(14),
                boxShadow: const [
                  BoxShadow(
                      color: Color(0x33246BFD),
                      blurRadius: 16,
                      offset: Offset(0, 6))
                ]),
            child: const Icon(Icons.groups_rounded, color: Colors.white)),
        const SizedBox(width: 13),
        Expanded(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Agent operations',
              style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 3),
          const Text(
              'Live assignments, teams, communications and consent-aware AI monitoring',
              overflow: TextOverflow.ellipsis)
        ])),
        OutlinedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.map_outlined, size: 17),
            label: const Text('View on map')),
        const SizedBox(width: 8),
        FilledButton.icon(
            onPressed: readOnly ? null : () {},
            icon: const Icon(Icons.person_add_alt_1_outlined, size: 17),
            label: const Text('Assign agent')),
      ]));
}

class _AgentMetrics extends StatelessWidget {
  const _AgentMetrics();
  @override
  Widget build(BuildContext context) => Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
      child: const Row(children: [
        Expanded(
            child: _EvidenceMetric(Icons.groups_outlined, AppColors.blue, '206',
                'Assigned agents', '13 wards')),
        SizedBox(width: 10),
        Expanded(
            child: _EvidenceMetric(Icons.wifi_rounded, AppColors.green, '184',
                'Online now', '89% coverage')),
        SizedBox(width: 10),
        Expanded(
            child: _EvidenceMetric(Icons.phone_in_talk_outlined,
                Color(0xFF7657C8), '7', 'Active calls', '3 group rooms')),
        SizedBox(width: 10),
        Expanded(
            child: _EvidenceMetric(Icons.graphic_eq_rounded, AppColors.cyan,
                '3', 'Acoustic AI active', '2 reports ready')),
        SizedBox(width: 10),
        Expanded(
            child: _EvidenceMetric(
                Icons.signal_wifi_connected_no_internet_4_outlined,
                AppColors.red,
                '22',
                'Offline / degraded',
                '4 escalated')),
      ]));
}

class _AgentFilters extends StatelessWidget {
  const _AgentFilters(
      {required this.query,
      required this.presence,
      required this.onQuery,
      required this.onPresence});
  final String query, presence;
  final ValueChanged<String> onQuery;
  final ValueChanged<String?> onPresence;
  @override
  Widget build(BuildContext context) => Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: const BoxDecoration(
          color: Color(0xFFF8FAFC),
          border: Border.symmetric(
              horizontal: BorderSide(color: AppColors.border))),
      child: Row(children: [
        SizedBox(
            width: 360,
            height: 40,
            child: TextField(
                onChanged: onQuery,
                decoration: const InputDecoration(
                    hintText: 'Search agent, polling unit, ward or team',
                    prefixIcon: Icon(Icons.search_rounded, size: 19),
                    contentPadding: EdgeInsets.zero))),
        const SizedBox(width: 10),
        _FilterDropdown(
            presence,
            const ['All agents', 'Online', 'Degraded', 'Offline'],
            Icons.wifi_rounded,
            onPresence),
        const Spacer(),
        const StatusPill('SCOPE: ALL WARDS',
            color: AppColors.blue, icon: Icons.location_on_outlined),
        const SizedBox(width: 8),
        IconButton(
            onPressed: () {},
            tooltip: 'Directory settings',
            icon: const Icon(Icons.tune_rounded)),
      ]));
}

class _AgentDirectory extends StatelessWidget {
  const _AgentDirectory(
      {required this.agents,
      required this.selected,
      required this.onSelected,
      required this.onCall});
  final List<_AgentRecord> agents;
  final String? selected;
  final ValueChanged<_AgentRecord> onSelected;
  final ValueChanged<_AgentRecord>? onCall;
  @override
  Widget build(BuildContext context) => Container(
      color: Colors.white,
      child: Column(children: [
        const Padding(
            padding: EdgeInsets.fromLTRB(20, 12, 16, 10),
            child: Row(children: [
              Expanded(
                  child: Text('AGENT & ASSIGNMENT',
                      style: TextStyle(
                          color: AppColors.muted,
                          fontSize: 9,
                          fontWeight: FontWeight.w900,
                          letterSpacing: .7))),
              SizedBox(
                  width: 100,
                  child: Text('PRESENCE',
                      style: TextStyle(
                          color: AppColors.muted,
                          fontSize: 9,
                          fontWeight: FontWeight.w900))),
              SizedBox(
                  width: 105,
                  child: Text('AI / COMMS',
                      style: TextStyle(
                          color: AppColors.muted,
                          fontSize: 9,
                          fontWeight: FontWeight.w900)))
            ])),
        const Divider(height: 1),
        Expanded(
            child: agents.isEmpty
                ? const _EmptyAgents()
                : ListView.separated(
                    itemCount: agents.length,
                    separatorBuilder: (_, __) => const Divider(height: 1),
                    itemBuilder: (_, i) {
                      final agent = agents[i];
                      final active = agent.id == selected;
                      return InkWell(
                          onTap: () => onSelected(agent),
                          child: Container(
                              color: active
                                  ? const Color(0xFFF0F5FF)
                                  : Colors.white,
                              padding:
                                  const EdgeInsets.fromLTRB(18, 13, 12, 13),
                              child: Row(children: [
                                Stack(children: [
                                  CircleAvatar(
                                      radius: 23,
                                      backgroundColor:
                                          agent.color.withValues(alpha: .12),
                                      child: Text(agent.initials,
                                          style: TextStyle(
                                              color: agent.color,
                                              fontWeight: FontWeight.w900))),
                                  Positioned(
                                      right: 0,
                                      bottom: 0,
                                      child: Container(
                                          width: 12,
                                          height: 12,
                                          decoration: BoxDecoration(
                                              color: agent.color,
                                              shape: BoxShape.circle,
                                              border: Border.all(
                                                  color: Colors.white,
                                                  width: 2))))
                                ]),
                                const SizedBox(width: 11),
                                Expanded(
                                    child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                      Row(children: [
                                        Flexible(
                                            child: Text(agent.name,
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                    color: AppColors.navy,
                                                    fontSize: 12,
                                                    fontWeight:
                                                        FontWeight.w900))),
                                        const SizedBox(width: 6),
                                        Text(agent.id,
                                            style: const TextStyle(
                                                color: AppColors.muted,
                                                fontSize: 8,
                                                fontWeight: FontWeight.w800))
                                      ]),
                                      const SizedBox(height: 4),
                                      Text('${agent.unit} • ${agent.ward}',
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                              color: AppColors.navy,
                                              fontSize: 10,
                                              fontWeight: FontWeight.w700)),
                                      const SizedBox(height: 3),
                                      Text(agent.group,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(fontSize: 9))
                                    ])),
                                SizedBox(
                                    width: 100,
                                    child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                              width: 82,
                                              child: FittedBox(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  fit: BoxFit.scaleDown,
                                                  child: StatusPill(
                                                      agent.presence
                                                          .toUpperCase(),
                                                      color: agent.color))),
                                          const SizedBox(height: 4),
                                          Text(agent.lastSeen,
                                              style:
                                                  const TextStyle(fontSize: 8))
                                        ])),
                                SizedBox(
                                    width: 105,
                                    child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(children: [
                                            Icon(Icons.graphic_eq_rounded,
                                                color: _acousticColor(
                                                    agent.acoustic),
                                                size: 14),
                                            const SizedBox(width: 4),
                                            Expanded(
                                                child: Text(agent.acoustic,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                        color: _acousticColor(
                                                            agent.acoustic),
                                                        fontSize: 9,
                                                        fontWeight:
                                                            FontWeight.w800)))
                                          ]),
                                          const SizedBox(height: 5),
                                          Text(agent.comms,
                                              style:
                                                  const TextStyle(fontSize: 8))
                                        ])),
                                IconButton(
                                    onPressed: agent.presence == 'Offline' ||
                                            onCall == null
                                        ? null
                                        : () => onCall!(agent),
                                    tooltip: 'Secure call',
                                    icon: const Icon(Icons.call_outlined,
                                        size: 19)),
                                Icon(Icons.chevron_right_rounded,
                                    color: active
                                        ? AppColors.blue
                                        : AppColors.muted,
                                    size: 18),
                              ])));
                    })),
      ]));
}

Color _acousticColor(String state) => state == 'Active'
    ? AppColors.green
    : state == 'Review ready'
        ? const Color(0xFF7657C8)
        : state == 'Available'
            ? AppColors.blue
            : AppColors.muted;

class _AgentInspector extends StatelessWidget {
  const _AgentInspector(
      {required this.agent,
      required this.readOnly,
      required this.reportRequested,
      required this.onCall,
      required this.onRequestReport});
  final _AgentRecord agent;
  final bool readOnly;
  final bool reportRequested;
  final VoidCallback onCall, onRequestReport;
  @override
  Widget build(BuildContext context) => Container(
      color: const Color(0xFFF8FAFC),
      child: ListView(padding: const EdgeInsets.all(18), children: [
        Row(children: [
          Stack(children: [
            CircleAvatar(
                radius: 31,
                backgroundColor: agent.color.withValues(alpha: .13),
                child: Text(agent.initials,
                    style: TextStyle(
                        color: agent.color,
                        fontSize: 17,
                        fontWeight: FontWeight.w900))),
            Positioned(
                right: 1,
                bottom: 1,
                child: Container(
                    width: 14,
                    height: 14,
                    decoration: BoxDecoration(
                        color: agent.color,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2))))
          ]),
          const SizedBox(width: 12),
          Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                Text(agent.name,
                    style: const TextStyle(
                        color: AppColors.navy,
                        fontSize: 18,
                        fontWeight: FontWeight.w900)),
                Text('${agent.id} • ${agent.role}',
                    style: const TextStyle(fontSize: 10)),
                const SizedBox(height: 5),
                StatusPill(agent.presence.toUpperCase(), color: agent.color)
              ])),
          IconButton(
              onPressed: () {}, icon: const Icon(Icons.more_horiz_rounded))
        ]),
        const SizedBox(height: 17),
        Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
                gradient: const LinearGradient(
                    colors: [AppColors.navy, Color(0xFF244E76)]),
                borderRadius: BorderRadius.circular(14)),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text('CURRENT ASSIGNMENT',
                  style: TextStyle(
                      color: Colors.white54,
                      fontSize: 8,
                      fontWeight: FontWeight.w900,
                      letterSpacing: .8)),
              const SizedBox(height: 7),
              Text(agent.unit,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w900)),
              const SizedBox(height: 3),
              Text('${agent.ward} • ${agent.group}',
                  style: const TextStyle(color: Colors.white70, fontSize: 10))
            ])),
        const SizedBox(height: 15),
        const Text('TEAM MEMBERS',
            style: TextStyle(
                color: AppColors.muted,
                fontSize: 9,
                fontWeight: FontWeight.w900,
                letterSpacing: .7)),
        const SizedBox(height: 8),
        const _GroupMembers(),
        const Divider(height: 27),
        const Text('LIVE OPERATIONAL STATE',
            style: TextStyle(
                color: AppColors.muted,
                fontSize: 9,
                fontWeight: FontWeight.w900,
                letterSpacing: .7)),
        const SizedBox(height: 8),
        _EvidenceDetail(Icons.phone_android_rounded, 'Device session',
            '${agent.device} • ${agent.version}'),
        _EvidenceDetail(
            Icons.my_location_rounded, 'Last location', agent.accuracy),
        _EvidenceDetail(Icons.call_outlined, 'Communications', agent.comms),
        const SizedBox(height: 12),
        _AcousticPanel(
            agent: agent,
            readOnly: readOnly,
            requested: reportRequested,
            onRequest: onRequestReport),
        const SizedBox(height: 12),
        Row(children: [
          Expanded(
              child: FilledButton.icon(
                  onPressed: readOnly || agent.presence == 'Offline'
                      ? null
                      : onCall,
                  icon: const Icon(Icons.call_rounded, size: 17),
                  label: const Text('Secure call'))),
          const SizedBox(width: 8),
          Expanded(
              child: OutlinedButton.icon(
                  onPressed: readOnly ? null : () {},
                  icon: const Icon(Icons.message_outlined, size: 17),
                  label: const Text('Message')))
        ]),
        const SizedBox(height: 8),
        OutlinedButton.icon(
            onPressed:
                readOnly || agent.presence == 'Offline' ? null : () {},
            icon: const Icon(Icons.location_searching_rounded, size: 17),
            label: const Text('Request location refresh')),
      ]));
}

class _GroupMembers extends StatelessWidget {
  const _GroupMembers();
  @override
  Widget build(BuildContext context) => Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: AppColors.border),
          borderRadius: BorderRadius.circular(12)),
      child: const Row(children: [
        _MemberAvatar('KM', AppColors.blue),
        SizedBox(width: 7),
        _MemberAvatar('NE', Color(0xFF7657C8)),
        SizedBox(width: 7),
        _MemberAvatar('IB', AppColors.amber),
        SizedBox(width: 10),
        Expanded(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('3 team members',
              style: TextStyle(
                  color: AppColors.navy,
                  fontSize: 10,
                  fontWeight: FontWeight.w800)),
          Text('2 online • 1 coordinating', style: TextStyle(fontSize: 8))
        ])),
        Icon(Icons.chevron_right_rounded, color: AppColors.muted, size: 18)
      ]));
}

class _MemberAvatar extends StatelessWidget {
  const _MemberAvatar(this.initials, this.color);
  final String initials;
  final Color color;
  @override
  Widget build(BuildContext context) => CircleAvatar(
      radius: 15,
      backgroundColor: color.withValues(alpha: .12),
      child: Text(initials,
          style: TextStyle(
              color: color, fontSize: 8, fontWeight: FontWeight.w900)));
}

class _AcousticPanel extends StatelessWidget {
  const _AcousticPanel(
      {required this.agent,
      required this.readOnly,
      required this.requested,
      required this.onRequest});
  final _AgentRecord agent;
  final bool readOnly;
  final bool requested;
  final VoidCallback onRequest;
  @override
  Widget build(BuildContext context) {
    final color = _acousticColor(agent.acoustic);
    return Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
            color: color.withValues(alpha: .07),
            border: Border.all(color: color.withValues(alpha: .24)),
            borderRadius: BorderRadius.circular(13)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                    color: color.withValues(alpha: .13),
                    borderRadius: BorderRadius.circular(9)),
                child: Icon(Icons.graphic_eq_rounded, color: color, size: 18)),
            const SizedBox(width: 9),
            const Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  Text('Acoustic AI monitoring',
                      style: TextStyle(
                          color: AppColors.navy,
                          fontSize: 11,
                          fontWeight: FontWeight.w900)),
                  Text('Authorized sessions only',
                      style: TextStyle(fontSize: 8))
                ])),
            StatusPill(
                (requested ? 'REPORT REQUESTED' : agent.acoustic).toUpperCase(),
                color: color)
          ]),
          const SizedBox(height: 10),
          Text(agent.acousticDetail,
              style: const TextStyle(
                  color: AppColors.navy,
                  fontSize: 10,
                  fontWeight: FontWeight.w700)),
          const SizedBox(height: 5),
          const Text('AI signals are advisory and require human review.',
              style: TextStyle(fontSize: 8)),
          const SizedBox(height: 10),
          SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                  onPressed: readOnly ||
                          agent.acoustic == 'Unavailable' ||
                          agent.acoustic == 'Off' ||
                          requested
                      ? null
                      : onRequest,
                  icon: const Icon(Icons.auto_awesome_rounded, size: 15),
                  label: Text(agent.acoustic == 'Review ready'
                      ? 'Open acoustic AI report'
                      : requested
                          ? 'Report requested'
                          : 'Request acoustic AI report'))),
        ]));
  }
}

class _CallOption extends StatelessWidget {
  const _CallOption(this.icon, this.color, this.title, this.detail,
      {required this.enabled});
  final IconData icon;
  final Color color;
  final String title, detail;
  final bool enabled;
  @override
  Widget build(BuildContext context) => Opacity(
      opacity: enabled ? 1 : .45,
      child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
              border: Border.all(color: AppColors.border),
              borderRadius: BorderRadius.circular(11)),
          child: Row(children: [
            Icon(icon, color: color),
            const SizedBox(width: 10),
            Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  Text(title,
                      style: const TextStyle(
                          color: AppColors.navy, fontWeight: FontWeight.w800)),
                  Text(detail, style: const TextStyle(fontSize: 9))
                ])),
            Icon(
                enabled
                    ? Icons.radio_button_unchecked_rounded
                    : Icons.block_rounded,
                color: enabled ? AppColors.blue : AppColors.muted,
                size: 18)
          ])));
}

class _AcousticCheck extends StatelessWidget {
  const _AcousticCheck(this.icon, this.title, this.detail);
  final IconData icon;
  final String title, detail;
  @override
  Widget build(BuildContext context) => Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(children: [
        Container(
            width: 31,
            height: 31,
            decoration: BoxDecoration(
                color: AppColors.green.withValues(alpha: .1),
                borderRadius: BorderRadius.circular(8)),
            child: Icon(icon, color: AppColors.green, size: 16)),
        const SizedBox(width: 9),
        Expanded(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title,
              style: const TextStyle(
                  color: AppColors.navy,
                  fontSize: 10,
                  fontWeight: FontWeight.w800)),
          Text(detail, style: const TextStyle(fontSize: 8))
        ]))
      ]));
}

class _EmptyAgents extends StatelessWidget {
  const _EmptyAgents();
  @override
  Widget build(BuildContext context) => const Center(
          child: Column(mainAxisSize: MainAxisSize.min, children: [
        Icon(Icons.group_off_outlined, color: AppColors.blue, size: 42),
        SizedBox(height: 10),
        Text('No agents match these filters',
            style:
                TextStyle(color: AppColors.navy, fontWeight: FontWeight.w800))
      ]));
}
