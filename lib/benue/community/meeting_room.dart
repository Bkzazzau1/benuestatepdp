import 'package:flutter/material.dart';

import '../app_scope.dart';
import '../domain/models.dart';
import '../domain/records_store.dart';
import '../session.dart';
import '../widgets.dart';
import 'community_access.dart';
import 'community_store.dart';
import 'role_hierarchy.dart';

class MeetingRoomPage extends StatefulWidget {
  const MeetingRoomPage({super.key});

  @override
  State<MeetingRoomPage> createState() => _MeetingRoomPageState();
}

class _MeetingRoomPageState extends State<MeetingRoomPage> {
  final _title = TextEditingController();
  final _agenda = TextEditingController();
  MeetingAudienceMode _audienceMode = MeetingAudienceMode.location;
  String? _groupId;
  final Set<String> _selectedUserIds = {};
  DateTime _startsAt = DateTime.now().add(const Duration(hours: 1));
  int _durationMinutes = 45;

  @override
  void dispose() {
    _title.dispose();
    _agenda.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final community = CampaignCommunity.of(context);
    final records = CampaignRecords.of(context);
    final session = CampaignSession.of(context);
    final campaignScope = CampaignScope.of(context);
    final scope = geographicScopeFromCampaignScope(campaignScope);
    final actorId = communityActorId(session.role!, scope);
    final rank = coordinationRankForRole(session.role!);
    final groups = community.groups
        .where((group) => group.memberIds.contains(actorId))
        .toList(growable: false);

    if (_groupId != null && !groups.any((group) => group.id == _groupId)) {
      _groupId = null;
    }

    final eligible = _eligibleUsers(
      records: records,
      role: session.role!,
      actorScope: scope,
      actorId: actorId,
      groups: groups,
      community: community,
    );
    _selectedUserIds.removeWhere((id) => !eligible.any((user) => user.id == id));

    return ColoredBox(
      color: const Color(0xFFF2F5F3),
      child: ListView(
        padding: const EdgeInsets.fromLTRB(24, 22, 24, 38),
        children: [
          _MeetingHero(
            operatorName: session.operatorName,
            role: roleLabel(session.role!),
            rank: coordinationRankLabel(rank),
            scope: scope.label,
          ),
          const SizedBox(height: 16),
          LayoutBuilder(builder: (context, c) {
            final create = _CreateMeetingPanel(
              titleController: _title,
              agendaController: _agenda,
              audienceMode: _audienceMode,
              groups: groups,
              selectedGroupId: _groupId,
              eligibleUsers: eligible,
              selectedUserIds: _selectedUserIds,
              startsAt: _startsAt,
              durationMinutes: _durationMinutes,
              onAudienceModeChanged: (value) => setState(() {
                _audienceMode = value;
                _selectedUserIds.clear();
              }),
              onGroupChanged: (value) => setState(() {
                _groupId = value;
                _selectedUserIds.clear();
              }),
              onToggleUser: (id) => setState(() {
                if (!_selectedUserIds.add(id)) _selectedUserIds.remove(id);
              }),
              onPickTime: _pickDateTime,
              onDurationChanged: (value) =>
                  setState(() => _durationMinutes = value),
              onCreate: () => _createMeeting(
                community: community,
                session: session,
                scope: scope,
                actorId: actorId,
                eligibleUsers: eligible,
              ),
            );
            final rankPanel = _RankAndDelegationPanel(
              role: session.role!,
              rank: rank,
              scope: scope,
            );
            if (c.maxWidth < 1050) {
              return Column(children: [
                create,
                const SizedBox(height: 14),
                rankPanel,
              ]);
            }
            return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Expanded(flex: 14, child: create),
              const SizedBox(width: 14),
              Expanded(flex: 8, child: rankPanel),
            ]);
          }),
          const SizedBox(height: 16),
          _MeetingList(
            meetings: community.meetings,
            actorId: actorId,
            onStart: (id) => community.setMeetingStatus(id, MeetingStatus.live),
            onComplete: (id) =>
                community.setMeetingStatus(id, MeetingStatus.completed),
          ),
          const SizedBox(height: 16),
          const _MeetingPolicyCard(),
        ],
      ),
    );
  }

  List<CampaignUser> _eligibleUsers({
    required CampaignRecordsController records,
    required CampaignRole role,
    required GeographicScope actorScope,
    required String actorId,
    required List<CampaignGroup> groups,
    required CampaignCommunityController community,
  }) {
    if (_audienceMode == MeetingAudienceMode.group) {
      final group = groups.where((g) => g.id == _groupId).firstOrNull;
      if (group == null) return const [];
      return records.users
          .where((user) => group.memberIds.contains(user.id) && user.id != actorId)
          .toList(growable: false);
    }

    final locationEligible = records.users.where((user) {
      if (user.id == actorId || !user.isActive) return false;
      return canInviteByLocation(
        actorRole: role,
        actorScope: actorScope,
        candidate: user.scope,
      );
    });

    if (_audienceMode == MeetingAudienceMode.location) {
      return locationEligible.toList(growable: false);
    }

    return locationEligible
        .where((user) => isDirectCoordinationReport(
              actorRole: role,
              candidateRole: user.role,
            ))
        .toList(growable: false);
  }

  Future<void> _pickDateTime() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _startsAt,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (!mounted || date == null) return;
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_startsAt),
    );
    if (!mounted || time == null) return;
    setState(() {
      _startsAt = DateTime(date.year, date.month, date.day, time.hour, time.minute);
    });
  }

  void _createMeeting({
    required CampaignCommunityController community,
    required CampaignSessionController session,
    required GeographicScope scope,
    required String actorId,
    required List<CampaignUser> eligibleUsers,
  }) {
    if (_title.text.trim().isEmpty || _selectedUserIds.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Add a meeting title and at least one eligible participant.')),
      );
      return;
    }
    final selected = eligibleUsers
        .where((user) => _selectedUserIds.contains(user.id))
        .toList(growable: false);
    if (selected.length != _selectedUserIds.length) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('One or more selected participants are outside your permitted audience.')),
      );
      return;
    }
    community.createMeeting(
      title: _title.text,
      agenda: _agenda.text,
      organizerId: actorId,
      organizerName: session.operatorName,
      organizerRole: session.role!,
      organizerScope: scope,
      audienceMode: _audienceMode,
      participantIds: selected.map((u) => u.id).toList(growable: false),
      participantNames:
          selected.map((u) => u.displayName).toList(growable: false),
      startsAt: _startsAt,
      durationMinutes: _durationMinutes,
      groupId: _audienceMode == MeetingAudienceMode.group ? _groupId : null,
    );
    _title.clear();
    _agenda.clear();
    setState(() {
      _selectedUserIds.clear();
      _startsAt = DateTime.now().add(const Duration(hours: 1));
    });
  }
}

extension _FirstOrNull<T> on Iterable<T> {
  T? get firstOrNull {
    final iterator = this.iterator;
    return iterator.moveNext() ? iterator.current : null;
  }
}

class _MeetingHero extends StatelessWidget {
  const _MeetingHero({
    required this.operatorName,
    required this.role,
    required this.rank,
    required this.scope,
  });

  final String operatorName;
  final String role;
  final String rank;
  final String scope;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(26),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28),
          gradient: const LinearGradient(
            colors: [Color(0xFF081B24), Color(0xFF0D4D5B), Color(0xFF0E7490)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: LayoutBuilder(builder: (context, c) {
          final compact = c.maxWidth < 830;
          final copy = Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Wrap(spacing: 8, runSpacing: 8, children: [
              _MeetingBadge(Icons.video_call_rounded, 'MEETING ROOM'),
              _MeetingBadge(Icons.rule_folder_outlined, 'SCOPE-CONTROLLED'),
              _MeetingBadge(Icons.groups_2_outlined, 'GROUP-AWARE'),
            ]),
            const SizedBox(height: 18),
            Text('Campaign Meeting Room',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: compact ? 30 : 40,
                  height: 1,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -.8,
                )),
            const SizedBox(height: 9),
            const Text(
              'Any authenticated account may convene a meeting, but participant selection is limited to the organizer’s assignment chain, permitted location or an explicit group.',
              style: TextStyle(
                  color: Colors.white70, height: 1.5, fontWeight: FontWeight.w600),
            ),
          ]);
          final identity = Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: .09),
              borderRadius: BorderRadius.circular(19),
              border: Border.all(color: Colors.white.withValues(alpha: .13)),
            ),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(operatorName,
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900)),
              const SizedBox(height: 3),
              Text(role,
                  style: const TextStyle(color: Colors.white60, fontSize: 10)),
              const SizedBox(height: 12),
              Text(rank,
                  style: const TextStyle(
                      color: Colors.white, fontSize: 16, fontWeight: FontWeight.w900)),
              const SizedBox(height: 2),
              Text(scope,
                  style: const TextStyle(color: Colors.white60, fontSize: 10)),
            ]),
          );
          if (compact) {
            return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              copy,
              const SizedBox(height: 18),
              identity,
            ]);
          }
          return Row(children: [
            Expanded(flex: 13, child: copy),
            const SizedBox(width: 24),
            identity,
          ]);
        }),
      );
}

class _MeetingBadge extends StatelessWidget {
  const _MeetingBadge(this.icon, this.label);
  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: .08),
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: Colors.white.withValues(alpha: .12)),
        ),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Icon(icon, size: 13, color: Colors.white70),
          const SizedBox(width: 6),
          Text(label,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 9,
                  fontWeight: FontWeight.w900,
                  letterSpacing: .4)),
        ]),
      );
}

class _CreateMeetingPanel extends StatelessWidget {
  const _CreateMeetingPanel({
    required this.titleController,
    required this.agendaController,
    required this.audienceMode,
    required this.groups,
    required this.selectedGroupId,
    required this.eligibleUsers,
    required this.selectedUserIds,
    required this.startsAt,
    required this.durationMinutes,
    required this.onAudienceModeChanged,
    required this.onGroupChanged,
    required this.onToggleUser,
    required this.onPickTime,
    required this.onDurationChanged,
    required this.onCreate,
  });

  final TextEditingController titleController;
  final TextEditingController agendaController;
  final MeetingAudienceMode audienceMode;
  final List<CampaignGroup> groups;
  final String? selectedGroupId;
  final List<CampaignUser> eligibleUsers;
  final Set<String> selectedUserIds;
  final DateTime startsAt;
  final int durationMinutes;
  final ValueChanged<MeetingAudienceMode> onAudienceModeChanged;
  final ValueChanged<String?> onGroupChanged;
  final ValueChanged<String> onToggleUser;
  final VoidCallback onPickTime;
  final ValueChanged<int> onDurationChanged;
  final VoidCallback onCreate;

  @override
  Widget build(BuildContext context) => SectionCard(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('Call a meeting',
              style: TextStyle(color: ink, fontSize: 18, fontWeight: FontWeight.w900)),
          const SizedBox(height: 4),
          const Text(
            'Participant choices are generated from your permitted audience. There is no unrestricted user search.',
            style: TextStyle(color: muted, fontSize: 10.5, height: 1.4),
          ),
          const SizedBox(height: 15),
          TextField(
            controller: titleController,
            decoration: const InputDecoration(labelText: 'Meeting title'),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: agendaController,
            minLines: 2,
            maxLines: 5,
            decoration: const InputDecoration(labelText: 'Agenda / purpose'),
          ),
          const SizedBox(height: 14),
          const Text('Audience rule',
              style: TextStyle(color: ink, fontWeight: FontWeight.w900)),
          const SizedBox(height: 8),
          Wrap(spacing: 8, runSpacing: 8, children: [
            _AudienceChip(
              label: 'My assignments',
              icon: Icons.account_tree_outlined,
              selected: audienceMode == MeetingAudienceMode.assignments,
              onTap: () => onAudienceModeChanged(MeetingAudienceMode.assignments),
            ),
            _AudienceChip(
              label: 'My location',
              icon: Icons.location_on_outlined,
              selected: audienceMode == MeetingAudienceMode.location,
              onTap: () => onAudienceModeChanged(MeetingAudienceMode.location),
            ),
            _AudienceChip(
              label: 'Group',
              icon: Icons.groups_2_outlined,
              selected: audienceMode == MeetingAudienceMode.group,
              onTap: () => onAudienceModeChanged(MeetingAudienceMode.group),
            ),
          ]),
          if (audienceMode == MeetingAudienceMode.group) ...[
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: selectedGroupId,
              decoration: const InputDecoration(labelText: 'My campaign group'),
              items: groups
                  .map((group) => DropdownMenuItem(
                        value: group.id,
                        child: Text(group.name),
                      ))
                  .toList(),
              onChanged: onGroupChanged,
            ),
            if (groups.isEmpty) ...[
              const SizedBox(height: 8),
              const Text(
                'No explicit campaign group is assigned to this account yet.',
                style: TextStyle(color: muted, fontSize: 10),
              ),
            ],
          ],
          const SizedBox(height: 14),
          Row(children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: onPickTime,
                icon: const Icon(Icons.event_rounded),
                label: Text(_formatDateTime(startsAt)),
              ),
            ),
            const SizedBox(width: 10),
            SizedBox(
              width: 160,
              child: DropdownButtonFormField<int>(
                value: durationMinutes,
                decoration: const InputDecoration(labelText: 'Duration'),
                items: const [30, 45, 60, 90, 120]
                    .map((minutes) => DropdownMenuItem(
                          value: minutes,
                          child: Text('$minutes min'),
                        ))
                    .toList(),
                onChanged: (value) {
                  if (value != null) onDurationChanged(value);
                },
              ),
            ),
          ]),
          const SizedBox(height: 14),
          Row(children: [
            const Expanded(
              child: Text('Eligible participants',
                  style: TextStyle(color: ink, fontWeight: FontWeight.w900)),
            ),
            StatusPill('${eligibleUsers.length} ELIGIBLE', color: const Color(0xFF0E7490)),
          ]),
          const SizedBox(height: 8),
          if (eligibleUsers.isEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFFF7F9F8),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFE4EAE5)),
              ),
              child: const Text(
                'No account is eligible under this audience rule. Choose another permitted audience or wait for verified lower-level assignments to be created.',
                style: TextStyle(color: muted, fontSize: 10.5, height: 1.4),
              ),
            )
          else
            ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 260),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: eligibleUsers.length,
                itemBuilder: (context, index) {
                  final user = eligibleUsers[index];
                  return CheckboxListTile(
                    dense: true,
                    contentPadding: EdgeInsets.zero,
                    value: selectedUserIds.contains(user.id),
                    onChanged: (_) => onToggleUser(user.id),
                    title: Text(user.displayName,
                        style: const TextStyle(
                            color: ink, fontSize: 11, fontWeight: FontWeight.w800)),
                    subtitle: Text(
                      '${coordinationRankLabel(coordinationRankForRole(user.role))} • ${user.scope.label}',
                      style: const TextStyle(color: muted, fontSize: 9.5),
                    ),
                  );
                },
              ),
            ),
          const SizedBox(height: 14),
          FilledButton.icon(
            onPressed: onCreate,
            icon: const Icon(Icons.video_call_rounded),
            label: Text('Create meeting (${selectedUserIds.length})'),
          ),
          const SizedBox(height: 8),
          const Text(
            'The prototype schedules and controls the room/audience. Live audio/video transport (WebRTC/SFU) will be connected in the backend phase.',
            style: TextStyle(color: muted, fontSize: 9.5),
          ),
        ]),
      );
}

class _AudienceChip extends StatelessWidget {
  const _AudienceChip({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });
  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => ChoiceChip(
        avatar: Icon(icon, size: 16),
        label: Text(label),
        selected: selected,
        onSelected: (_) => onTap(),
      );
}

class _RankAndDelegationPanel extends StatelessWidget {
  const _RankAndDelegationPanel({
    required this.role,
    required this.rank,
    required this.scope,
  });

  final CampaignRole role;
  final CoordinationRank rank;
  final GeographicScope scope;

  @override
  Widget build(BuildContext context) {
    final creatable = creatableCoordinatorRanks(role);
    return SectionCard(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('Coordination rank & delegation',
            style: TextStyle(color: ink, fontSize: 17, fontWeight: FontWeight.w900)),
        const SizedBox(height: 4),
        const Text(
          'Rank controls coordinator creation and the normal geographic meeting boundary.',
          style: TextStyle(color: muted, fontSize: 10.5, height: 1.4),
        ),
        const SizedBox(height: 15),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: const Color(0xFFEAF4F7),
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: const Color(0xFFD4E8ED)),
          ),
          child: Row(children: [
            const CircleAvatar(
              backgroundColor: Color(0xFFDCECF1),
              child: Icon(Icons.military_tech_outlined, color: Color(0xFF0E7490)),
            ),
            const SizedBox(width: 11),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(coordinationRankLabel(rank),
                  style: const TextStyle(
                      color: ink, fontSize: 15, fontWeight: FontWeight.w900)),
              const SizedBox(height: 2),
              Text(scope.label,
                  style: const TextStyle(color: muted, fontSize: 10)),
            ])),
          ]),
        ),
        const SizedBox(height: 15),
        const Text('May create / manage',
            style: TextStyle(color: ink, fontWeight: FontWeight.w900)),
        const SizedBox(height: 8),
        if (creatable.isEmpty)
          const Text('No coordinator-creation authority.',
              style: TextStyle(color: muted, fontSize: 10.5))
        else
          ...creatable.map((target) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(children: [
                  const Icon(Icons.verified_rounded, color: pdpGreen, size: 17),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(coordinationRankLabel(target),
                        style: const TextStyle(
                            color: ink, fontSize: 10.5, fontWeight: FontWeight.w800)),
                  ),
                ]),
              )),
        const Divider(height: 24),
        const _RankRow('State Command', 'Can create State + LGA coordinators'),
        const _RankRow('State Coordinator', 'Can manage/create LGA coordinators'),
        const _RankRow('LGA Coordinator', 'Can manage/create Ward coordinators in own LGA'),
        const _RankRow('Ward Coordinator', 'Can manage/create PU teams in own ward'),
        const _RankRow('Polling Unit Team', 'No coordinator creation authority'),
      ]),
    );
  }
}

class _RankRow extends StatelessWidget {
  const _RankRow(this.rank, this.rule);
  final String rank;
  final String rule;
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 9),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(rank,
              style: const TextStyle(
                  color: ink, fontSize: 10.5, fontWeight: FontWeight.w900)),
          const SizedBox(height: 2),
          Text(rule, style: const TextStyle(color: muted, fontSize: 9.5)),
        ]),
      );
}

class _MeetingList extends StatelessWidget {
  const _MeetingList({
    required this.meetings,
    required this.actorId,
    required this.onStart,
    required this.onComplete,
  });

  final List<CampaignMeeting> meetings;
  final String actorId;
  final ValueChanged<String> onStart;
  final ValueChanged<String> onComplete;

  @override
  Widget build(BuildContext context) => SectionCard(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('Meeting rooms',
              style: TextStyle(color: ink, fontSize: 18, fontWeight: FontWeight.w900)),
          const SizedBox(height: 4),
          const Text('Scheduled and active campaign meetings visible in this prototype session.',
              style: TextStyle(color: muted, fontSize: 10.5)),
          const SizedBox(height: 14),
          if (meetings.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 24),
              child: Center(child: Text('No meetings scheduled.', style: TextStyle(color: muted))),
            )
          else
            ...meetings.map((meeting) => _MeetingCard(
                  meeting: meeting,
                  canControl: meeting.organizerId == actorId,
                  onStart: () => onStart(meeting.id),
                  onComplete: () => onComplete(meeting.id),
                )),
        ]),
      );
}

class _MeetingCard extends StatelessWidget {
  const _MeetingCard({
    required this.meeting,
    required this.canControl,
    required this.onStart,
    required this.onComplete,
  });
  final CampaignMeeting meeting;
  final bool canControl;
  final VoidCallback onStart;
  final VoidCallback onComplete;

  @override
  Widget build(BuildContext context) {
    final statusColor = switch (meeting.status) {
      MeetingStatus.live => pdpRed,
      MeetingStatus.scheduled => const Color(0xFF0E7490),
      MeetingStatus.completed => pdpGreen,
      MeetingStatus.cancelled => muted,
    };
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAF9),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE4EAE5)),
      ),
      child: LayoutBuilder(builder: (context, c) {
        final details = Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Wrap(spacing: 8, runSpacing: 6, children: [
            Text(meeting.title,
                style: const TextStyle(color: ink, fontSize: 13, fontWeight: FontWeight.w900)),
            StatusPill(meeting.status.name.toUpperCase(), color: statusColor),
            if (meeting.prototypeSeed)
              const StatusPill('PROTOTYPE', color: Color(0xFF8A5B00)),
          ]),
          const SizedBox(height: 5),
          Text(
            '${meeting.organizerName} • ${meeting.organizerScope.label} • ${_audienceLabel(meeting.audienceMode)}',
            style: const TextStyle(color: muted, fontSize: 9.5),
          ),
          if (meeting.agenda.isNotEmpty) ...[
            const SizedBox(height: 7),
            Text(meeting.agenda,
                style: const TextStyle(color: ink, fontSize: 10.5, height: 1.4)),
          ],
          const SizedBox(height: 7),
          Text(
            '${_formatDateTime(meeting.startsAt)} • ${meeting.durationMinutes} min • ${meeting.participantIds.length} participants',
            style: const TextStyle(color: muted, fontSize: 9.5, fontWeight: FontWeight.w700),
          ),
        ]);
        final controls = Wrap(spacing: 8, runSpacing: 8, children: [
          if (meeting.status == MeetingStatus.live)
            FilledButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.call_rounded),
              label: const Text('Join room'),
            )
          else
            OutlinedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.event_available_outlined),
              label: const Text('View'),
            ),
          if (canControl && meeting.status == MeetingStatus.scheduled)
            FilledButton.icon(
              onPressed: onStart,
              icon: const Icon(Icons.video_call_rounded),
              label: const Text('Start'),
            ),
          if (canControl && meeting.status == MeetingStatus.live)
            OutlinedButton.icon(
              onPressed: onComplete,
              icon: const Icon(Icons.stop_circle_outlined),
              label: const Text('End'),
            ),
        ]);
        if (c.maxWidth < 760) {
          return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            details,
            const SizedBox(height: 12),
            controls,
          ]);
        }
        return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Expanded(child: details),
          const SizedBox(width: 14),
          controls,
        ]);
      }),
    );
  }
}

class _MeetingPolicyCard extends StatelessWidget {
  const _MeetingPolicyCard();

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFEAF4F7),
          borderRadius: BorderRadius.circular(17),
          border: Border.all(color: const Color(0xFFD4E8ED)),
        ),
        child: const Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Icon(Icons.shield_outlined, color: Color(0xFF0E7490)),
          SizedBox(width: 11),
          Expanded(
            child: Text(
              'Meeting access rule: normal invitations follow the organizer’s assigned geography and delegation chain. Explicit group membership may cross locations. The backend must re-check these rules server-side; Flutter filtering alone is not authorization.',
              style: TextStyle(color: muted, fontSize: 10.5, height: 1.45),
            ),
          ),
        ]),
      );
}

String _formatDateTime(DateTime value) {
  final local = value.toLocal();
  final hour = local.hour == 0
      ? 12
      : local.hour > 12
          ? local.hour - 12
          : local.hour;
  final minute = local.minute.toString().padLeft(2, '0');
  final ampm = local.hour >= 12 ? 'PM' : 'AM';
  return '${local.day}/${local.month}/${local.year} • $hour:$minute $ampm';
}

String _audienceLabel(MeetingAudienceMode mode) => switch (mode) {
      MeetingAudienceMode.assignments => 'Assigned team',
      MeetingAudienceMode.location => 'Location',
      MeetingAudienceMode.group => 'Group',
    };
