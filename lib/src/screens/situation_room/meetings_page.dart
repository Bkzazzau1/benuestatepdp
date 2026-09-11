part of 'situation_room_page.dart';

class _MeetingRecord {
  _MeetingRecord({
    required this.id,
    required this.title,
    required this.group,
    required this.organizer,
    required this.scheduled,
    required this.duration,
    required this.status,
    required this.invitedMembers,
    required this.agenda,
    List<String>? keyPoints,
    this.minutes = '',
    Set<String>? present,
    this.recording = false,
  })  : keyPoints = keyPoints ?? [],
        present = present ?? {};

  final String id, title, group, organizer, scheduled, duration, status;
  final List<String> invitedMembers;
  final List<String> agenda;
  List<String> keyPoints;
  String minutes;
  Set<String> present;
  bool recording;

  Color get color => switch (status) {
        'Live' => AppColors.red,
        'Scheduled' => AppColors.blue,
        _ => AppColors.green,
      };
}

class _GroupRecord {
  const _GroupRecord({
    required this.id,
    required this.name,
    required this.ward,
    required this.createdBy,
    required this.members,
  });
  final String id, name, ward, createdBy;
  final List<String> members;
}

class _MeetingsPage extends StatefulWidget {
  const _MeetingsPage({required this.readOnly, required this.canManageGroups});
  final bool readOnly;
  final bool canManageGroups;
  @override
  State<_MeetingsPage> createState() => _MeetingsPageState();
}

class _MeetingsPageState extends State<_MeetingsPage> {
  int _tab = 0;
  int _nextMeetingNumber = 143;
  int _nextGroupNumber = 5;

  final List<_MeetingRecord> _meetings = [
    _MeetingRecord(
      id: 'MTG-0142',
      title: 'Weekly ward coordination briefing',
      group: "Kwarbai 'A' Ward Team",
      organizer: 'Sani Shuaibu',
      scheduled: 'Today • 16:00',
      duration: '45 min (planned)',
      status: 'Scheduled',
      invitedMembers: const [
        'Amina Yusuf',
        'Kabir Musa',
        'Fatima Ali',
        'Tunde Obi',
        'Ngozi Eze',
        'Chidi Nwosu',
      ],
      agenda: const [
        'Review polling-day logistics',
        'Confirm agent deployment by unit',
        'Discuss verification backlog',
      ],
    ),
    _MeetingRecord(
      id: 'MTG-0139',
      title: 'Strategy & messaging sync',
      group: 'Command Staff',
      organizer: 'Sani Shuaibu',
      scheduled: 'Live now',
      duration: '18 min elapsed',
      status: 'Live',
      recording: true,
      invitedMembers: const [
        'Sani Shuaibu',
        'Chidi Nwosu',
        'N. Ibrahim',
        'Grace Adeyemi',
        'L. Adeyemi',
        'M. Bello',
      ],
      present: {
        'Sani Shuaibu',
        'Chidi Nwosu',
        'N. Ibrahim',
        'Grace Adeyemi',
        'L. Adeyemi',
      },
      agenda: const [
        'Response to opposition messaging',
        'Weekend rally logistics',
        'Social pulse trends review',
      ],
    ),
    _MeetingRecord(
      id: 'MTG-0131',
      title: 'Tudun Wada ward town hall recap',
      group: 'Tudun Wada Response Team',
      organizer: 'Chidi Nwosu',
      scheduled: 'Yesterday • 18:00',
      duration: '52 min',
      status: 'Completed',
      recording: true,
      invitedMembers: const [
        'Kabir Musa',
        'Ngozi Eze',
        'I. Bello',
        'T. Musa',
        'J. Aliyu',
        'K. Sule',
        'R. Danladi',
        'O. Garba',
        'U. Yakubu',
      ],
      present: {
        'Kabir Musa',
        'Ngozi Eze',
        'I. Bello',
        'T. Musa',
        'J. Aliyu',
        'K. Sule',
        'R. Danladi',
        'O. Garba',
      },
      agenda: const [
        'Town hall turnout debrief',
        'Complaints raised at PU-028',
      ],
      keyPoints: [
        'Residents requested a second registration drive',
        'Agree to increase agent presence at PU-028',
      ],
      minutes:
          'Team agreed to increase agent presence at PU-028 following turnout concerns. '
          'Follow-up registration drive to be scoped with the ward coordinator by Friday.',
    ),
    _MeetingRecord(
      id: 'MTG-0126',
      title: 'Evidence & verification review',
      group: 'Verification Officers',
      organizer: 'N. Ibrahim',
      scheduled: 'Mon • 10:00',
      duration: '30 min',
      status: 'Completed',
      invitedMembers: const [
        'N. Ibrahim',
        'L. Adeyemi',
        'Fatima Ali',
        'I. Bello',
        'M. Bello',
      ],
      present: const {
        'N. Ibrahim',
        'L. Adeyemi',
        'Fatima Ali',
        'I. Bello',
        'M. Bello',
      },
      agenda: const [
        'Clear pending verification queue',
        'Evidence integrity spot-checks',
      ],
      keyPoints: ['Verification backlog cleared to 12 items'],
      minutes:
          'Backlog reduced from 23 to 12 open items. No integrity failures found in spot-checked evidence.',
    ),
  ];

  final List<_GroupRecord> _groups = [
    const _GroupRecord(
      id: 'GRP-001',
      name: "Kwarbai 'A' Ward Team",
      ward: "Kwarbai 'A'",
      createdBy: 'Chidi Nwosu',
      members: [
        'Amina Yusuf',
        'Ngozi Eze',
        'M. Bello',
        'Chidi Nwosu',
      ],
    ),
    const _GroupRecord(
      id: 'GRP-002',
      name: 'Tudun Wada Response Team',
      ward: 'Tudun Wada',
      createdBy: 'Chidi Nwosu',
      members: ['Kabir Musa', 'I. Bello', 'T. Musa', 'J. Aliyu'],
    ),
    const _GroupRecord(
      id: 'GRP-003',
      name: 'Command Staff',
      ward: 'All wards',
      createdBy: 'Sani Shuaibu',
      members: [
        'Sani Shuaibu',
        'Chidi Nwosu',
        'N. Ibrahim',
        'Grace Adeyemi',
      ],
    ),
    const _GroupRecord(
      id: 'GRP-004',
      name: 'Verification Officers',
      ward: 'All wards',
      createdBy: 'N. Ibrahim',
      members: ['N. Ibrahim', 'L. Adeyemi', 'Fatima Ali', 'I. Bello'],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final liveCount = _meetings.where((m) => m.status == 'Live').length;
    final upcomingCount =
        _meetings.where((m) => m.status == 'Scheduled').length;
    final recordedCount = _meetings.where((m) => m.recording).length;
    return Column(children: [
      _MeetingsHeader(
        readOnly: widget.readOnly,
        canManageGroups: widget.canManageGroups,
        liveCount: liveCount,
        onScheduleMeeting: _showScheduleMeeting,
        onCreateGroup: _showCreateGroup,
      ),
      _MeetingsMetrics(
          upcoming: upcomingCount,
          live: liveCount,
          recorded: recordedCount,
          groups: _groups.length),
      _SectionTabs(
          value: _tab,
          labels: const ['Meetings', 'Campaign groups'],
          onChanged: (v) => setState(() => _tab = v)),
      Expanded(
          child: _tab == 0
              ? SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(children: [
                    for (final meeting in _meetings) ...[
                      _MeetingRow(
                          meeting: meeting, onTap: () => _openMeeting(meeting)),
                      const SizedBox(height: 10),
                    ],
                  ]),
                )
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(children: [
                    for (final group in _groups) ...[
                      _GroupRow(group: group),
                      const SizedBox(height: 10),
                    ],
                  ]),
                )),
    ]);
  }

  void _openMeeting(_MeetingRecord meeting) => showDialog<void>(
      context: context,
      builder: (_) => Dialog(
            insetPadding: const EdgeInsets.all(32),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 620, maxHeight: 760),
              child: _MeetingDetailDialog(
                meeting: meeting,
                readOnly: widget.readOnly,
                onChanged: () => setState(() {}),
              ),
            ),
          ));

  void _showScheduleMeeting() {
    final titleController = TextEditingController();
    var group = _groups.first.name;
    var when = 'Tomorrow • 10:00';
    showDialog<void>(
        context: context,
        builder: (dialogContext) => StatefulBuilder(
              builder: (dialogContext, setDialogState) => AlertDialog(
                title: const Row(children: [
                  Icon(Icons.event_available_rounded, color: AppColors.blue),
                  SizedBox(width: 10),
                  Text('Schedule meeting'),
                ]),
                content: SizedBox(
                  width: 460,
                  child: Column(mainAxisSize: MainAxisSize.min, children: [
                    TextField(
                        controller: titleController,
                        decoration: const InputDecoration(
                            labelText: 'Meeting title (required)')),
                    const SizedBox(height: 11),
                    DropdownButtonFormField<String>(
                        initialValue: group,
                        items: _groups
                            .map((g) => DropdownMenuItem(
                                value: g.name, child: Text(g.name)))
                            .toList(),
                        onChanged: (v) => setDialogState(() => group = v!),
                        decoration:
                            const InputDecoration(labelText: 'Invite group')),
                    const SizedBox(height: 11),
                    DropdownButtonFormField<String>(
                        initialValue: when,
                        items: const [
                          'Today • 18:00',
                          'Tomorrow • 10:00',
                          'Tomorrow • 16:00',
                          'Friday • 09:00',
                        ]
                            .map((w) =>
                                DropdownMenuItem(value: w, child: Text(w)))
                            .toList(),
                        onChanged: (v) => setDialogState(() => when = v!),
                        decoration:
                            const InputDecoration(labelText: 'When')),
                    const SizedBox(height: 11),
                    const InfoNotice(
                        'Invited members are notified immediately. The session is end-to-end encrypted and screen-recording detection is active by default.'),
                  ]),
                ),
                actions: [
                  TextButton(
                      onPressed: () => Navigator.pop(dialogContext),
                      child: const Text('Cancel')),
                  FilledButton.icon(
                      onPressed: titleController.text.trim().isEmpty
                          ? null
                          : () {
                              final invited = _groups
                                  .firstWhere((g) => g.name == group)
                                  .members;
                              setState(() {
                                _meetings.insert(
                                    0,
                                    _MeetingRecord(
                                      id: 'MTG-0${_nextMeetingNumber++}',
                                      title: titleController.text.trim(),
                                      group: group,
                                      organizer: 'You',
                                      scheduled: when,
                                      duration: '30 min (planned)',
                                      status: 'Scheduled',
                                      invitedMembers: invited,
                                      agenda: const [],
                                    ));
                              });
                              Navigator.pop(dialogContext);
                            },
                      icon: const Icon(Icons.check_rounded),
                      label: const Text('Schedule')),
                ],
              ),
            ));
  }

  void _showCreateGroup() {
    final nameController = TextEditingController();
    var ward = ZariaConstituency.wards.first.name;
    showDialog<void>(
        context: context,
        builder: (dialogContext) => StatefulBuilder(
              builder: (dialogContext, setDialogState) => AlertDialog(
                title: const Row(children: [
                  Icon(Icons.group_add_rounded, color: AppColors.cyan),
                  SizedBox(width: 10),
                  Text('Create campaign group'),
                ]),
                content: SizedBox(
                  width: 440,
                  child: Column(mainAxisSize: MainAxisSize.min, children: [
                    TextField(
                        controller: nameController,
                        decoration: const InputDecoration(
                            labelText: 'Group name (required)')),
                    const SizedBox(height: 11),
                    DropdownButtonFormField<String>(
                        initialValue: ward,
                        items: [
                          'All wards',
                          ...ZariaConstituency.wards.map((w) => w.name),
                        ]
                            .map((w) =>
                                DropdownMenuItem(value: w, child: Text(w)))
                            .toList(),
                        onChanged: (v) => setDialogState(() => ward = v!),
                        decoration:
                            const InputDecoration(labelText: 'Scope')),
                    const SizedBox(height: 11),
                    const InfoNotice(
                        'Only ward coordinators and Situation Room command staff can create campaign groups.'),
                  ]),
                ),
                actions: [
                  TextButton(
                      onPressed: () => Navigator.pop(dialogContext),
                      child: const Text('Cancel')),
                  FilledButton.icon(
                      onPressed: nameController.text.trim().isEmpty
                          ? null
                          : () {
                              setState(() {
                                _groups.add(_GroupRecord(
                                  id: 'GRP-00${_nextGroupNumber++}',
                                  name: nameController.text.trim(),
                                  ward: ward,
                                  createdBy: 'You',
                                  members: const [],
                                ));
                              });
                              Navigator.pop(dialogContext);
                            },
                      icon: const Icon(Icons.check_rounded),
                      label: const Text('Create group')),
                ],
              ),
            ));
  }
}

class _MeetingsHeader extends StatelessWidget {
  const _MeetingsHeader({
    required this.readOnly,
    required this.canManageGroups,
    required this.liveCount,
    required this.onScheduleMeeting,
    required this.onCreateGroup,
  });
  final bool readOnly, canManageGroups;
  final int liveCount;
  final VoidCallback onScheduleMeeting, onCreateGroup;

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
            child: const Icon(Icons.groups_2_rounded, color: Colors.white)),
        const SizedBox(width: 13),
        Expanded(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Meetings & groups',
              style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 3),
          const Text(
              'Schedule briefings, track attendance, capture minutes and manage campaign groups',
              overflow: TextOverflow.ellipsis)
        ])),
        if (liveCount > 0) ...[
          StatusPill('$liveCount LIVE NOW',
              color: AppColors.red, icon: Icons.fiber_manual_record_rounded),
          const SizedBox(width: 8),
        ],
        if (canManageGroups) ...[
          OutlinedButton.icon(
              onPressed: readOnly ? null : onCreateGroup,
              icon: const Icon(Icons.group_add_rounded, size: 17),
              label: const Text('Create group')),
          const SizedBox(width: 8),
        ],
        FilledButton.icon(
            onPressed: readOnly ? null : onScheduleMeeting,
            icon: const Icon(Icons.event_available_rounded, size: 17),
            label: const Text('Schedule meeting')),
      ]));
}

class _MeetingsMetrics extends StatelessWidget {
  const _MeetingsMetrics(
      {required this.upcoming,
      required this.live,
      required this.recorded,
      required this.groups});
  final int upcoming, live, recorded, groups;
  @override
  Widget build(BuildContext context) => Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
      child: Row(children: [
        Expanded(
            child: _EvidenceMetric(Icons.event_outlined, AppColors.blue,
                '$upcoming', 'Upcoming', 'This week')),
        const SizedBox(width: 10),
        Expanded(
            child: _EvidenceMetric(Icons.podcasts_rounded, AppColors.red,
                '$live', 'Live now', 'In session')),
        const SizedBox(width: 10),
        Expanded(
            child: _EvidenceMetric(Icons.fiber_manual_record_outlined,
                Color(0xFF7657C8), '$recorded', 'Recorded sessions', 'Consent-aware')),
        const SizedBox(width: 10),
        Expanded(
            child: _EvidenceMetric(Icons.groups_outlined, AppColors.cyan,
                '$groups', 'Campaign groups', 'Ward-scoped')),
        const SizedBox(width: 10),
        const Expanded(
            child: _EvidenceMetric(Icons.how_to_reg_outlined, AppColors.green,
                '91%', 'Avg. attendance', 'Last 30 days')),
      ]));
}

class _SectionTabs extends StatelessWidget {
  const _SectionTabs(
      {required this.value, required this.labels, required this.onChanged});
  final int value;
  final List<String> labels;
  final ValueChanged<int> onChanged;
  @override
  Widget build(BuildContext context) => Container(
      height: 51,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      decoration: const BoxDecoration(
          color: Color(0xFFF8FAFC),
          border: Border.symmetric(
              horizontal: BorderSide(color: AppColors.border))),
      child: Row(
          children: labels.indexed
              .map((entry) => Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                      selected: value == entry.$1,
                      onSelected: (_) => onChanged(entry.$1),
                      label: Text(entry.$2),
                      selectedColor: AppColors.navy,
                      labelStyle: TextStyle(
                          color:
                              value == entry.$1 ? Colors.white : AppColors.navy,
                          fontSize: 11,
                          fontWeight: FontWeight.w700),
                      side: const BorderSide(color: AppColors.border),
                      backgroundColor: Colors.white)))
              .toList()));
}

class _MeetingRow extends StatelessWidget {
  const _MeetingRow({required this.meeting, required this.onTap});
  final _MeetingRecord meeting;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Card(
      child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(children: [
                Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                        color: meeting.color.withValues(alpha: .1),
                        borderRadius: BorderRadius.circular(13)),
                    child: Icon(
                        meeting.status == 'Live'
                            ? Icons.podcasts_rounded
                            : meeting.status == 'Scheduled'
                                ? Icons.event_outlined
                                : Icons.event_available_rounded,
                        color: meeting.color)),
                const SizedBox(width: 13),
                Expanded(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                      Row(children: [
                        Expanded(
                            child: Text(meeting.title,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                    color: AppColors.navy,
                                    fontWeight: FontWeight.w800,
                                    fontSize: 13))),
                        StatusPill(meeting.status.toUpperCase(),
                            color: meeting.color),
                      ]),
                      const SizedBox(height: 4),
                      Text('${meeting.group} • ${meeting.scheduled}',
                          style: const TextStyle(fontSize: 10)),
                      const SizedBox(height: 6),
                      Row(children: [
                        Icon(Icons.people_outline_rounded,
                            size: 13, color: AppColors.muted),
                        const SizedBox(width: 4),
                        Text(
                            '${meeting.present.length} of ${meeting.invitedMembers.length} present',
                            style: const TextStyle(
                                fontSize: 9, fontWeight: FontWeight.w700)),
                        if (meeting.recording) ...[
                          const SizedBox(width: 10),
                          const Icon(Icons.fiber_manual_record_rounded,
                              size: 10, color: AppColors.red),
                          const SizedBox(width: 3),
                          const Text('Recorded',
                              style: TextStyle(
                                  fontSize: 9,
                                  color: AppColors.red,
                                  fontWeight: FontWeight.w700)),
                        ],
                      ]),
                    ])),
                const SizedBox(width: 8),
                const Icon(Icons.chevron_right_rounded, color: AppColors.muted),
              ]))));
}

class _GroupRow extends StatelessWidget {
  const _GroupRow({required this.group});
  final _GroupRecord group;
  @override
  Widget build(BuildContext context) => Card(
      child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(children: [
            Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                    color: AppColors.cyan.withValues(alpha: .1),
                    borderRadius: BorderRadius.circular(13)),
                child: const Icon(Icons.groups_rounded, color: AppColors.cyan)),
            const SizedBox(width: 13),
            Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  Text(group.name,
                      style: const TextStyle(
                          color: AppColors.navy,
                          fontWeight: FontWeight.w800,
                          fontSize: 13)),
                  const SizedBox(height: 3),
                  Text('${group.ward} • Created by ${group.createdBy}',
                      style: const TextStyle(fontSize: 10)),
                ])),
            StatusPill('${group.members.length} MEMBERS',
                color: AppColors.cyan),
          ])));
}

class _MeetingDetailDialog extends StatefulWidget {
  const _MeetingDetailDialog(
      {required this.meeting, required this.readOnly, required this.onChanged});
  final _MeetingRecord meeting;
  final bool readOnly;
  final VoidCallback onChanged;

  @override
  State<_MeetingDetailDialog> createState() => _MeetingDetailDialogState();
}

class _MeetingDetailDialogState extends State<_MeetingDetailDialog> {
  late final TextEditingController _minutesController =
      TextEditingController(text: widget.meeting.minutes);
  final _keyPointController = TextEditingController();

  @override
  void dispose() {
    _minutesController.dispose();
    _keyPointController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final meeting = widget.meeting;
    return Column(children: [
      Container(
          padding: const EdgeInsets.all(18),
          decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(bottom: BorderSide(color: AppColors.border))),
          child: Row(children: [
            Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  Row(children: [
                    Text(meeting.id,
                        style: const TextStyle(
                            color: AppColors.muted,
                            fontSize: 10,
                            fontWeight: FontWeight.w800)),
                    const SizedBox(width: 8),
                    StatusPill(meeting.status.toUpperCase(),
                        color: meeting.color),
                  ]),
                  const SizedBox(height: 5),
                  Text(meeting.title,
                      style: const TextStyle(
                          color: AppColors.navy,
                          fontSize: 17,
                          fontWeight: FontWeight.w900)),
                  const SizedBox(height: 3),
                  Text('${meeting.group} • ${meeting.scheduled}',
                      style: const TextStyle(fontSize: 10)),
                ])),
            IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.close_rounded)),
          ])),
      Expanded(
          child: ListView(padding: const EdgeInsets.all(18), children: [
        const Text('SESSION SECURITY',
            style: TextStyle(
                color: AppColors.muted,
                fontSize: 9,
                fontWeight: FontWeight.w900,
                letterSpacing: .7)),
        const SizedBox(height: 8),
        const Wrap(spacing: 8, runSpacing: 8, children: [
          StatusPill('END-TO-END ENCRYPTED',
              color: AppColors.green, icon: Icons.lock_outline_rounded),
          StatusPill('SCREEN-RECORD DETECTION',
              color: AppColors.blue, icon: Icons.visibility_outlined),
          StatusPill('SCREENSHOT BLOCKED',
              color: Color(0xFF7657C8), icon: Icons.no_photography_outlined),
        ]),
        const SizedBox(height: 10),
        const InfoNotice(
            'Encryption, screen-recording detection and screenshot blocking are enforced where the operating system supports it and require native platform integration before production use.'),
        const SizedBox(height: 16),
        if (meeting.status != 'Scheduled') _buildRecordingControl(meeting),
        if (meeting.status != 'Scheduled') const SizedBox(height: 16),
        _ReviewSection(
            title: 'Attendance',
            icon: Icons.how_to_reg_outlined,
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(children: [
                Row(children: [
                  Text(
                      '${meeting.present.length} of ${meeting.invitedMembers.length} present',
                      style: const TextStyle(
                          color: AppColors.navy,
                          fontSize: 11,
                          fontWeight: FontWeight.w800)),
                ]),
                const SizedBox(height: 8),
                for (final member in meeting.invitedMembers)
                  CheckboxListTile(
                    dense: true,
                    contentPadding: EdgeInsets.zero,
                    controlAffinity: ListTileControlAffinity.leading,
                    value: meeting.present.contains(member),
                    onChanged: widget.readOnly
                        ? null
                        : (checked) => setState(() {
                              if (checked == true) {
                                meeting.present.add(member);
                              } else {
                                meeting.present.remove(member);
                              }
                              widget.onChanged();
                            }),
                    title: Text(member,
                        style: const TextStyle(
                            fontSize: 12, fontWeight: FontWeight.w700)),
                  ),
              ]),
            )),
        const SizedBox(height: 14),
        _ReviewSection(
            title: 'Agenda',
            icon: Icons.checklist_rounded,
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: meeting.agenda.isEmpty
                  ? const Text('No agenda items recorded.',
                      style: TextStyle(fontSize: 11))
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: meeting.agenda
                          .map((item) => Padding(
                                padding: const EdgeInsets.only(bottom: 6),
                                child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Icon(Icons.circle,
                                          size: 5, color: AppColors.muted),
                                      const SizedBox(width: 8),
                                      Expanded(
                                          child: Text(item,
                                              style: const TextStyle(
                                                  fontSize: 11,
                                                  height: 1.3))),
                                    ]),
                              ))
                          .toList(),
                    ),
            )),
        const SizedBox(height: 14),
        _ReviewSection(
            title: 'Key points',
            icon: Icons.push_pin_outlined,
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (meeting.keyPoints.isEmpty)
                      const Padding(
                        padding: EdgeInsets.only(bottom: 8),
                        child: Text('No key points captured yet.',
                            style: TextStyle(fontSize: 11)),
                      ),
                    for (final point in meeting.keyPoints)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 6),
                        child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(Icons.push_pin_rounded,
                                  size: 12, color: AppColors.amber),
                              const SizedBox(width: 8),
                              Expanded(
                                  child: Text(point,
                                      style: const TextStyle(
                                          fontSize: 11, height: 1.3))),
                            ]),
                      ),
                    if (!widget.readOnly) ...[
                      const SizedBox(height: 6),
                      Row(children: [
                        Expanded(
                            child: TextField(
                          controller: _keyPointController,
                          decoration: const InputDecoration(
                              isDense: true,
                              hintText: 'Add a key point',
                              contentPadding:
                                  EdgeInsets.symmetric(horizontal: 10, vertical: 10)),
                        )),
                        const SizedBox(width: 8),
                        IconButton.filled(
                          onPressed: () {
                            final text = _keyPointController.text.trim();
                            if (text.isEmpty) return;
                            setState(() {
                              meeting.keyPoints.add(text);
                              _keyPointController.clear();
                              widget.onChanged();
                            });
                          },
                          icon: const Icon(Icons.add_rounded, size: 18),
                        ),
                      ]),
                    ],
                  ]),
            )),
        const SizedBox(height: 14),
        _ReviewSection(
            title: 'Minutes',
            icon: Icons.notes_rounded,
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(children: [
                TextField(
                  controller: _minutesController,
                  readOnly: widget.readOnly,
                  minLines: 4,
                  maxLines: 8,
                  decoration: const InputDecoration(
                      hintText: 'Capture what was discussed and decided…',
                      alignLabelWithHint: true),
                ),
                if (!widget.readOnly) ...[
                  const SizedBox(height: 10),
                  Align(
                    alignment: Alignment.centerRight,
                    child: FilledButton.icon(
                      onPressed: () {
                        setState(() {
                          meeting.minutes = _minutesController.text;
                          widget.onChanged();
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Minutes saved')));
                      },
                      icon: const Icon(Icons.save_outlined, size: 16),
                      label: const Text('Save minutes'),
                    ),
                  ),
                ],
              ]),
            )),
      ])),
    ]);
  }

  Widget _buildRecordingControl(_MeetingRecord meeting) => Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
          color: (meeting.recording ? AppColors.red : AppColors.muted)
              .withValues(alpha: .07),
          border: Border.all(
              color: (meeting.recording ? AppColors.red : AppColors.muted)
                  .withValues(alpha: .24)),
          borderRadius: BorderRadius.circular(13)),
      child: Row(children: [
        Icon(
            meeting.recording
                ? Icons.fiber_manual_record_rounded
                : Icons.videocam_off_outlined,
            color: meeting.recording ? AppColors.red : AppColors.muted,
            size: 20),
        const SizedBox(width: 10),
        Expanded(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
              Text(
                  meeting.recording
                      ? (meeting.status == 'Live'
                          ? 'Recording in progress'
                          : 'Session was recorded')
                      : 'Not recorded',
                  style: const TextStyle(
                      color: AppColors.navy,
                      fontSize: 11,
                      fontWeight: FontWeight.w900)),
              const Text('All participants are shown a visible recording indicator.',
                  style: TextStyle(fontSize: 9)),
            ])),
        if (meeting.status == 'Live')
          OutlinedButton(
              onPressed: widget.readOnly
                  ? null
                  : () => setState(() {
                        meeting.recording = !meeting.recording;
                        widget.onChanged();
                      }),
              style: OutlinedButton.styleFrom(
                  foregroundColor:
                      meeting.recording ? AppColors.red : AppColors.navy),
              child: Text(meeting.recording ? 'Stop' : 'Start')),
      ]));
}
