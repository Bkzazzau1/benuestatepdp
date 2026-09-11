part of 'situation_room_page.dart';

class _CommSession {
  const _CommSession(this.id, this.title, this.participants, this.context,
      this.duration, this.quality, this.type, this.recording, this.color);
  final String id,
      title,
      participants,
      context,
      duration,
      quality,
      type,
      recording;
  final Color color;
}

class _CommunicationsCenterPage extends StatefulWidget {
  const _CommunicationsCenterPage();
  @override
  State<_CommunicationsCenterPage> createState() =>
      _CommunicationsCenterPageState();
}

class _CommunicationsCenterPageState extends State<_CommunicationsCenterPage> {
  int _selected = 0;
  String _view = 'Active sessions';
  bool _muted = false;
  bool _held = false;

  static const _sessions = <_CommSession>[
    _CommSession(
        'CALL-VID-00184',
        'Kwarbai incident room',
        'Amina Yusuf + 3 participants',
        'INC-00518 • Kwarbai \'A\'',
        '06:42',
        'Excellent',
        'Video',
        'Not recorded',
        AppColors.green),
    _CommSession(
        'CALL-SEC-00179',
        'Ward coordinator check-in',
        'Kabir Musa + 1 participant',
        'Tudun Wada • PU-028',
        '12:18',
        'Good',
        'Voice',
        'Recording on',
        AppColors.blue),
    _CommSession(
        'CALL-GRP-00172',
        'Central verification room',
        '6 participants',
        'INC-00496 • Gyallesu',
        '24:05',
        'Degraded',
        'Conference',
        'Not recorded',
        AppColors.amber),
  ];

  @override
  Widget build(BuildContext context) {
    final session = _sessions[_selected];
    return Column(children: [
      _CommunicationsHeader(onStartCall: _showStartCall),
      const _CommunicationsMetrics(),
      _CommunicationsTabs(
          value: _view, onChanged: (v) => setState(() => _view = v)),
      Expanded(
          child: Row(children: [
        SizedBox(
            width: 390,
            child: _SessionDirectory(
                sessions: _sessions,
                selected: session.id,
                onSelected: (s) => setState(() {
                      _selected = _sessions.indexOf(s);
                      _muted = false;
                      _held = false;
                    }))),
        Container(width: 1, color: AppColors.border),
        Expanded(
            child: _ActiveSessionPanel(
                session: session,
                muted: _muted,
                held: _held,
                onMute: () => setState(() => _muted = !_muted),
                onHold: () => setState(() => _held = !_held),
                onMediaRequest: () => _showMediaRequest(session),
                onEnd: () => _confirmEnd(session))),
        Container(width: 1, color: AppColors.border),
        const SizedBox(width: 310, child: _CommsSideRail()),
      ])),
    ]);
  }

  void _showStartCall() => showDialog<void>(
      context: context,
      builder: (_) => AlertDialog(
            title: const Row(children: [
              Icon(Icons.add_call, color: AppColors.blue),
              SizedBox(width: 10),
              Text('Start secure communication')
            ]),
            content: const SizedBox(
                width: 500,
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  TextField(
                      decoration: InputDecoration(
                          labelText: 'Agent, team, incident or polling unit',
                          prefixIcon: Icon(Icons.search_rounded))),
                  SizedBox(height: 12),
                  Wrap(spacing: 6, runSpacing: 6, children: [
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
                  SizedBox(height: 12),
                  _CallOption(Icons.call_rounded, AppColors.green,
                      'Secure voice call', 'Authenticated encrypted audio',
                      enabled: true),
                  SizedBox(height: 8),
                  _CallOption(
                      Icons.videocam_outlined,
                      AppColors.blue,
                      'Secure video request',
                      'Target participant must explicitly accept',
                      enabled: true),
                  SizedBox(height: 8),
                  _CallOption(
                      Icons.groups_outlined,
                      Color(0xFF7657C8),
                      'Incident conference room',
                      'Role-controlled multi-party session',
                      enabled: true),
                  SizedBox(height: 12),
                  InfoNotice(
                      'Screen-recording detection and screenshot blocking are enforced where the device operating system supports it and require native platform integration before production use.'),
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
                            'Secure call request created • state: Requested')));
                  },
                  icon: const Icon(Icons.call_rounded),
                  label: const Text('Create request'))
            ],
          ));

  void _showMediaRequest(_CommSession session) => showDialog<void>(
      context: context,
      builder: (_) => AlertDialog(
            title: const Row(children: [
              Icon(Icons.video_call_outlined, color: Color(0xFF7657C8)),
              SizedBox(width: 10),
              Text('Request live media')
            ]),
            content: SizedBox(
                width: 500,
                child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(session.context,
                          style: const TextStyle(
                              color: AppColors.navy,
                              fontWeight: FontWeight.w800)),
                      const SizedBox(height: 12),
                      const InfoNotice(
                          'The target agent must explicitly accept. An unanswered, declined or expired request never activates the camera or microphone.'),
                      const SizedBox(height: 13),
                      DropdownButtonFormField<String>(
                          initialValue: 'Live video + audio',
                          items: [
                            DropdownMenuItem(
                                value: 'Live video + audio',
                                child: Text('Live video + audio')),
                            DropdownMenuItem(
                                value: 'Photo', child: Text('Photo')),
                            DropdownMenuItem(
                                value: 'Recorded video',
                                child: Text('Recorded video')),
                            DropdownMenuItem(
                                value: 'Audio clip', child: Text('Audio clip'))
                          ],
                          onChanged: null,
                          decoration: InputDecoration(labelText: 'Media type')),
                      const SizedBox(height: 11),
                      const TextField(
                          minLines: 2,
                          maxLines: 3,
                          decoration: InputDecoration(
                              labelText: 'Operational reason (required)',
                              alignLabelWithHint: true)),
                      const SizedBox(height: 10),
                      const Row(children: [
                        Icon(Icons.timer_outlined,
                            color: AppColors.muted, size: 15),
                        SizedBox(width: 6),
                        Text('Request expires automatically after 60 seconds.',
                            style: TextStyle(fontSize: 9))
                      ]),
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
                            'Media request sent • awaiting explicit agent acceptance')));
                  },
                  icon: const Icon(Icons.send_rounded),
                  label: const Text('Send request'))
            ],
          ));

  void _confirmEnd(_CommSession session) => showDialog<void>(
      context: context,
      builder: (_) => AlertDialog(
              title: const Text('End secure session?'),
              content: Text(
                  '${session.id} will move to Ended and all participants will disconnect. Session metadata and quality telemetry remain in the audit record.'),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Keep active')),
                FilledButton(
                    onPressed: () {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('${session.id} ended')));
                    },
                    style:
                        FilledButton.styleFrom(backgroundColor: AppColors.red),
                    child: const Text('End session'))
              ]));
}

class _CommunicationsHeader extends StatelessWidget {
  const _CommunicationsHeader({required this.onStartCall});
  final VoidCallback onStartCall;
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
            child: const Icon(Icons.headset_mic_rounded, color: Colors.white)),
        const SizedBox(width: 13),
        Expanded(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Secure communications',
              style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 3),
          const Text(
              'Authenticated calls, incident rooms and consent-controlled media requests',
              overflow: TextOverflow.ellipsis)
        ])),
        const StatusPill('ENCRYPTED',
            color: AppColors.green, icon: Icons.lock_outline_rounded),
        const SizedBox(width: 8),
        FilledButton.icon(
            onPressed: onStartCall,
            icon: const Icon(Icons.add_call, size: 17),
            label: const Text('Start secure call')),
      ]));
}

class _CommunicationsMetrics extends StatelessWidget {
  const _CommunicationsMetrics();
  @override
  Widget build(BuildContext context) => Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
      child: const Row(children: [
        Expanded(
            child: _EvidenceMetric(Icons.phone_in_talk_outlined,
                AppColors.green, '7', 'Active sessions', '18 participants')),
        SizedBox(width: 10),
        Expanded(
            child: _EvidenceMetric(Icons.ring_volume_outlined, AppColors.blue,
                '4', 'Call queue', '1 ringing')),
        SizedBox(width: 10),
        Expanded(
            child: _EvidenceMetric(Icons.video_call_outlined, Color(0xFF7657C8),
                '3', 'Media requests', '2 awaiting consent')),
        SizedBox(width: 10),
        Expanded(
            child: _EvidenceMetric(Icons.network_check_rounded, AppColors.amber,
                '96%', 'Connection health', '3 degraded')),
        SizedBox(width: 10),
        Expanded(
            child: _EvidenceMetric(Icons.groups_outlined, AppColors.cyan, '3',
                'Incident rooms', 'All authorized')),
      ]));
}

class _CommunicationsTabs extends StatelessWidget {
  const _CommunicationsTabs({required this.value, required this.onChanged});
  final String value;
  final ValueChanged<String> onChanged;
  @override
  Widget build(BuildContext context) => Container(
      height: 51,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      decoration: const BoxDecoration(
          color: Color(0xFFF8FAFC),
          border: Border.symmetric(
              horizontal: BorderSide(color: AppColors.border))),
      child: Row(
          children: [
        'Active sessions',
        'Call queue',
        'Media requests',
        'Incident rooms',
        'Call history'
      ]
              .map((tab) => Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                      selected: value == tab,
                      onSelected: (_) => onChanged(tab),
                      label: Text(tab),
                      selectedColor: AppColors.navy,
                      labelStyle: TextStyle(
                          color: value == tab ? Colors.white : AppColors.navy,
                          fontSize: 10,
                          fontWeight: FontWeight.w700),
                      side: const BorderSide(color: AppColors.border),
                      backgroundColor: Colors.white)))
              .toList()));
}

class _SessionDirectory extends StatelessWidget {
  const _SessionDirectory(
      {required this.sessions,
      required this.selected,
      required this.onSelected});
  final List<_CommSession> sessions;
  final String selected;
  final ValueChanged<_CommSession> onSelected;
  @override
  Widget build(BuildContext context) => Container(
      color: Colors.white,
      child: Column(children: [
        const Padding(
            padding: EdgeInsets.fromLTRB(16, 13, 12, 11),
            child: Row(children: [
              Text('LIVE SESSIONS',
                  style: TextStyle(
                      color: AppColors.muted,
                      fontSize: 9,
                      fontWeight: FontWeight.w900,
                      letterSpacing: .7)),
              Spacer(),
              StatusPill('7 ACTIVE', color: AppColors.green)
            ])),
        const Divider(height: 1),
        Expanded(
            child: ListView.separated(
                itemCount: sessions.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (_, i) {
                  final session = sessions[i];
                  final active = session.id == selected;
                  return InkWell(
                      onTap: () => onSelected(session),
                      child: Container(
                          color:
                              active ? const Color(0xFFF3F1FF) : Colors.white,
                          padding: const EdgeInsets.all(14),
                          child: Row(children: [
                            Stack(children: [
                              CircleAvatar(
                                  radius: 22,
                                  backgroundColor:
                                      session.color.withValues(alpha: .1),
                                  child: Icon(
                                      session.type == 'Video'
                                          ? Icons.videocam_rounded
                                          : session.type == 'Conference'
                                              ? Icons.groups_rounded
                                              : Icons.call_rounded,
                                      color: session.color,
                                      size: 19)),
                              Positioned(
                                  right: 0,
                                  bottom: 0,
                                  child: Container(
                                      width: 11,
                                      height: 11,
                                      decoration: BoxDecoration(
                                          color: session.color,
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                              color: Colors.white, width: 2))))
                            ]),
                            const SizedBox(width: 10),
                            Expanded(
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                  Row(children: [
                                    Expanded(
                                        child: Text(session.title,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                                color: AppColors.navy,
                                                fontSize: 11,
                                                fontWeight: FontWeight.w900))),
                                    Text(session.duration,
                                        style: TextStyle(
                                            color: session.color,
                                            fontSize: 10,
                                            fontWeight: FontWeight.w900))
                                  ]),
                                  const SizedBox(height: 4),
                                  Text(session.participants,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(fontSize: 9)),
                                  const SizedBox(height: 3),
                                  Text(session.context,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                          color: AppColors.navy,
                                          fontSize: 8,
                                          fontWeight: FontWeight.w700)),
                                  const SizedBox(height: 6),
                                  Row(children: [
                                    StatusPill(session.type.toUpperCase(),
                                        color: session.color),
                                    const SizedBox(width: 6),
                                    Icon(Icons.network_check_rounded,
                                        color: session.color, size: 13),
                                    const SizedBox(width: 3),
                                    Text(session.quality,
                                        style: TextStyle(
                                            color: session.color,
                                            fontSize: 8,
                                            fontWeight: FontWeight.w800))
                                  ])
                                ]))
                          ])));
                })),
      ]));
}

class _ActiveSessionPanel extends StatelessWidget {
  const _ActiveSessionPanel(
      {required this.session,
      required this.muted,
      required this.held,
      required this.onMute,
      required this.onHold,
      required this.onMediaRequest,
      required this.onEnd});
  final _CommSession session;
  final bool muted, held;
  final VoidCallback onMute, onHold, onMediaRequest, onEnd;
  @override
  Widget build(BuildContext context) => Container(
      color: const Color(0xFFF8FAFC),
      child: Column(children: [
        Container(
            padding: const EdgeInsets.all(17),
            decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(bottom: BorderSide(color: AppColors.border))),
            child: Row(children: [
              Expanded(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                    Row(children: [
                      Text(session.id,
                          style: const TextStyle(
                              color: AppColors.navy,
                              fontSize: 14,
                              fontWeight: FontWeight.w900)),
                      const SizedBox(width: 8),
                      const StatusPill('ACTIVE',
                          color: AppColors.green, icon: Icons.circle)
                    ]),
                    const SizedBox(height: 4),
                    Text(session.context, style: const TextStyle(fontSize: 10))
                  ])),
              _MiniValue('DURATION', session.duration),
              const SizedBox(width: 18),
              _MiniValue('QUALITY', session.quality)
            ])),
        Expanded(
            child: ListView(padding: const EdgeInsets.all(18), children: [
          Container(
              height: 200,
              decoration: BoxDecoration(
                  gradient: const LinearGradient(
                      colors: [AppColors.navy, Color(0xFF234C70)]),
                  borderRadius: BorderRadius.circular(17)),
              child: Stack(children: [
                const Center(
                    child: Column(mainAxisSize: MainAxisSize.min, children: [
                  CircleAvatar(
                      radius: 35,
                      backgroundColor: Color(0xFF315D91),
                      child: Text('AY',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w900))),
                  SizedBox(height: 9),
                  Text('Amina Yusuf',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w900)),
                  Text('AGT-041 • Polling Unit 014',
                      style: TextStyle(color: Colors.white60, fontSize: 9))
                ])),
                Positioned(
                    top: 12,
                    left: 12,
                    child: StatusPill(session.type.toUpperCase(),
                        color: const Color(0xFF70B5FF),
                        icon: Icons.lock_outline_rounded)),
                Positioned(
                    top: 12,
                    right: 12,
                    child: StatusPill(session.recording.toUpperCase(),
                        color: session.recording == 'Recording on'
                            ? AppColors.red
                            : const Color(0xFFB9C8DA),
                        icon: session.recording == 'Recording on'
                            ? Icons.fiber_manual_record_rounded
                            : Icons.videocam_off_outlined)),
                if (held)
                  const Center(
                      child: StatusPill('SESSION ON HOLD',
                          color: Color(0xFFFFC66D), icon: Icons.pause_rounded)),
                const Positioned(
                    bottom: 12,
                    left: 12,
                    child: StatusPill('SCREENSHOT BLOCKED',
                        color: Color(0xFF7657C8),
                        icon: Icons.no_photography_outlined)),
                const Positioned(
                    bottom: 12,
                    right: 12,
                    child: StatusPill('REC. DETECTION ON',
                        color: Color(0xFF70B5FF),
                        icon: Icons.visibility_outlined)),
              ])),
          const SizedBox(height: 14),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            _CallControl(muted ? Icons.mic_off_rounded : Icons.mic_rounded,
                muted ? 'Unmute' : 'Mute', muted, onMute),
            const SizedBox(width: 12),
            _CallControl(held ? Icons.play_arrow_rounded : Icons.pause_rounded,
                held ? 'Resume' : 'Hold', held, onHold),
            const SizedBox(width: 12),
            _CallControl(Icons.video_call_outlined, 'Request media', false,
                onMediaRequest),
            const SizedBox(width: 12),
            _CallControl(Icons.call_end_rounded, 'End', true, onEnd,
                danger: true),
          ]),
          const SizedBox(height: 16),
          _Panel(
              title: 'Participants',
              subtitle: 'Identity and scope checked at join time',
              trailing: TextButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.person_add_alt_1_outlined, size: 15),
                  label: const Text('Invite')),
              child: const Column(children: [
                _Participant('AY', 'Amina Yusuf', 'AGT-041 • Field agent',
                    'Speaking', AppColors.green),
                Divider(height: 1),
                _Participant('SS', 'Sani Shuaibu', 'Situation Room Commander',
                    'Listening', AppColors.blue),
                Divider(height: 1),
                _Participant('MB', 'Musa Bello', 'Incident Commander',
                    'Listening', Color(0xFF7657C8)),
              ])),
          const SizedBox(height: 14),
          _Panel(
              title: 'Connection telemetry',
              subtitle: 'Live troubleshooting metrics',
              child: const Padding(
                  padding: EdgeInsets.all(14),
                  child: Row(children: [
                    Expanded(
                        child: _Telemetry('LATENCY', '82 ms', AppColors.green)),
                    Expanded(
                        child: _Telemetry('JITTER', '14 ms', AppColors.green)),
                    Expanded(
                        child:
                            _Telemetry('PACKET LOSS', '0.8%', AppColors.green)),
                    Expanded(
                        child:
                            _Telemetry('BITRATE', '1.8 Mbps', AppColors.blue)),
                  ]))),
        ])),
      ]));
}

class _CallControl extends StatelessWidget {
  const _CallControl(this.icon, this.label, this.active, this.onTap,
      {this.danger = false});
  final IconData icon;
  final String label;
  final bool active, danger;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    final color = danger
        ? AppColors.red
        : active
            ? AppColors.navy
            : AppColors.blue;
    return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Column(children: [
          Container(
              width: 43,
              height: 43,
              decoration: BoxDecoration(
                  color: color.withValues(alpha: danger || active ? 1 : .1),
                  borderRadius: BorderRadius.circular(12)),
              child: Icon(icon,
                  color: danger || active ? Colors.white : color, size: 20)),
          const SizedBox(height: 5),
          Text(label,
              style: const TextStyle(
                  color: AppColors.navy,
                  fontSize: 8,
                  fontWeight: FontWeight.w700))
        ]));
  }
}

class _Participant extends StatelessWidget {
  const _Participant(
      this.initials, this.name, this.role, this.state, this.color);
  final String initials, name, role, state;
  final Color color;
  @override
  Widget build(BuildContext context) => ListTile(
      dense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 13, vertical: 2),
      leading: CircleAvatar(
          radius: 16,
          backgroundColor: color.withValues(alpha: .1),
          child: Text(initials,
              style: TextStyle(
                  color: color, fontSize: 8, fontWeight: FontWeight.w900))),
      title: Text(name,
          style: const TextStyle(
              color: AppColors.navy,
              fontSize: 10,
              fontWeight: FontWeight.w800)),
      subtitle: Text(role, style: const TextStyle(fontSize: 8)),
      trailing: StatusPill(state.toUpperCase(), color: color));
}

class _Telemetry extends StatelessWidget {
  const _Telemetry(this.label, this.value, this.color);
  final String label, value;
  final Color color;
  @override
  Widget build(BuildContext context) => Column(children: [
        Text(value,
            style: TextStyle(
                color: color, fontSize: 15, fontWeight: FontWeight.w900)),
        const SizedBox(height: 3),
        Text(label,
            style: const TextStyle(
                color: AppColors.muted,
                fontSize: 7,
                fontWeight: FontWeight.w900))
      ]);
}

class _CommsSideRail extends StatelessWidget {
  const _CommsSideRail();
  @override
  Widget build(BuildContext context) => Container(
      color: Colors.white,
      child: ListView(padding: const EdgeInsets.all(15), children: [
        const Text('CALL QUEUE',
            style: TextStyle(
                color: AppColors.muted,
                fontSize: 9,
                fontWeight: FontWeight.w900,
                letterSpacing: .7)),
        const SizedBox(height: 9),
        const _QueueCall(Icons.ring_volume_rounded, AppColors.blue,
            'AGT-106 • Ngozi Eze', 'Ringing • 00:18'),
        const SizedBox(height: 7),
        const _QueueCall(Icons.call_missed_outgoing_rounded, AppColors.red,
            'AGT-052 • Tunde Obi', 'Failed • retry 2 of 3'),
        const Divider(height: 28),
        const Row(children: [
          Expanded(
              child: Text('MEDIA REQUESTS',
                  style: TextStyle(
                      color: AppColors.muted,
                      fontSize: 9,
                      fontWeight: FontWeight.w900,
                      letterSpacing: .7))),
          StatusPill('3', color: Color(0xFF7657C8))
        ]),
        const SizedBox(height: 9),
        const _MediaRequest('MR-004812', 'Amina Yusuf', 'Live video + audio',
            'ACCEPTED', AppColors.green),
        const SizedBox(height: 7),
        const _MediaRequest(
            'MR-004819', 'Kabir Musa', 'Photo', 'REQUESTED', AppColors.blue),
        const SizedBox(height: 7),
        const _MediaRequest('MR-004821', 'Fatima Ali', 'Audio clip',
            'EXPIRES 00:34', AppColors.amber),
        const Divider(height: 28),
        const Text('SESSION POLICY',
            style: TextStyle(
                color: AppColors.muted,
                fontSize: 9,
                fontWeight: FontWeight.w900,
                letterSpacing: .7)),
        const SizedBox(height: 10),
        const _GovernanceRow(
            Icons.lock_outline_rounded, 'Encrypted transport', 'Active'),
        const SizedBox(height: 10),
        const _GovernanceRow(
            Icons.pan_tool_alt_outlined, 'Explicit media consent', 'Required'),
        const SizedBox(height: 10),
        const _GovernanceRow(Icons.fiber_manual_record_outlined,
            'Recording indicator', 'Visible'),
        const SizedBox(height: 10),
        const _GovernanceRow(Icons.visibility_outlined,
            'Screen-recording detection', 'Active'),
        const SizedBox(height: 10),
        const _GovernanceRow(Icons.no_photography_outlined,
            'Screenshot blocking', 'OS-dependent'),
        const SizedBox(height: 10),
        const _GovernanceRow(
            Icons.history_rounded, 'State transitions', 'Audited'),
      ]));
}

class _QueueCall extends StatelessWidget {
  const _QueueCall(this.icon, this.color, this.title, this.detail);
  final IconData icon;
  final Color color;
  final String title, detail;
  @override
  Widget build(BuildContext context) => Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: color.withValues(alpha: .06),
          borderRadius: BorderRadius.circular(10)),
      child: Row(children: [
        Icon(icon, color: color, size: 18),
        const SizedBox(width: 8),
        Expanded(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title,
              style: const TextStyle(
                  color: AppColors.navy,
                  fontSize: 9,
                  fontWeight: FontWeight.w800)),
          Text(detail,
              style: TextStyle(
                  color: color, fontSize: 8, fontWeight: FontWeight.w700))
        ])),
        IconButton(
            onPressed: () {},
            constraints: const BoxConstraints.tightFor(width: 28, height: 28),
            padding: EdgeInsets.zero,
            icon: const Icon(Icons.call_rounded, size: 15))
      ]));
}

class _MediaRequest extends StatelessWidget {
  const _MediaRequest(this.id, this.agent, this.type, this.state, this.color);
  final String id, agent, type, state;
  final Color color;
  @override
  Widget build(BuildContext context) => Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          border: Border.all(color: AppColors.border),
          borderRadius: BorderRadius.circular(10)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Text(id,
              style: const TextStyle(
                  color: AppColors.navy,
                  fontSize: 8,
                  fontWeight: FontWeight.w900)),
          const Spacer(),
          StatusPill(state, color: color)
        ]),
        const SizedBox(height: 5),
        Text(agent,
            style: const TextStyle(
                color: AppColors.navy,
                fontSize: 9,
                fontWeight: FontWeight.w800)),
        Text(type, style: const TextStyle(fontSize: 8))
      ]));
}
