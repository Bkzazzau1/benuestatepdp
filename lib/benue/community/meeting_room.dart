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
    final scope = geographicScopeFromCampaignScope(CampaignScope.of(context));
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
    );
    _selectedUserIds.removeWhere((id) => !eligible.any((user) => user.id == id));

    return ColoredBox(
      color: const Color(0xFFF3F6F3),
      child: ListView(
        padding: const EdgeInsets.fromLTRB(24, 22, 24, 38),
        children: [
          _MeetingHero(
            name: session.operatorName,
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
            final access = _MeetingAccessCard(
              role: session.role!,
              rank: rank,
              scope: scope,
            );
            if (c.maxWidth < 1050) {
              return Column(children: [
                create,
                const SizedBox(height: 14),
                access,
              ]);
            }
            return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Expanded(flex: 14, child: create),
              const SizedBox(width: 14),
              Expanded(flex: 8, child: access),
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
  }) {
    if (_audienceMode == MeetingAudienceMode.group) {
      CampaignGroup? selected;
      for (final group in groups) {
        if (group.id == _groupId) {
          selected = group;
          break;
        }
      }
      if (selected == null) return const [];
      return records.users
          .where((user) => selected!.memberIds.contains(user.id) && user.id != actorId)
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
        const SnackBar(content: Text('Add a meeting title and select participants.')),
      );
      return;
    }
    final selected = eligibleUsers
        .where((user) => _selectedUserIds.contains(user.id))
        .toList(growable: false);
    if (selected.length != _selectedUserIds.length) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please review the selected participants.')),
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
      participantIds: selected.map((e) => e.id).toList(growable: false),
      participantNames: selected.map((e) => e.displayName).toList(growable: false),
      startsAt: _startsAt,
      durationMinutes: _durationMinutes,
      groupId: _audienceMode == MeetingAudienceMode.group ? _groupId : null,
    );
    _title.clear();
    _agenda.clear();
    setState(() => _selectedUserIds.clear());
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Meeting created.')),
    );
  }
}

class _MeetingHero extends StatelessWidget {
  const _MeetingHero({
    required this.name,
    required this.role,
    required this.rank,
    required this.scope,
  });

  final String name;
  final String role;
  final String rank;
  final String scope;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(28),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28),
          gradient: const LinearGradient(
            colors: [Color(0xFF071C13), Color(0xFF0A6036), Color(0xFF0D7A45)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: const [
            BoxShadow(color: Color(0x1A064F2A), blurRadius: 30, offset: Offset(0, 12)),
          ],
        ),
        child: LayoutBuilder(builder: (context, c) {
          final compact = c.maxWidth < 820;
          final copy = Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Wrap(spacing: 8, runSpacing: 8, children: [
              _MeetingBadge(Icons.video_call_rounded, 'MEETING ROOM'),
              _MeetingBadge(Icons.groups_2_outlined, 'TEAMS & GROUPS'),
              _MeetingBadge(Icons.location_on_outlined, 'LOCATION AWARE'),
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
              'Bring the right people together for campaign coordination, reviews and urgent decisions.',
              style: TextStyle(
                  color: Colors.white70,
                  height: 1.5,
                  fontWeight: FontWeight.w600),
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
              Text(name,
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w900)),
              const SizedBox(height: 3),
              Text(role,
                  style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 10,
                      fontWeight: FontWeight.w700)),
              const SizedBox(height: 12),
              Text(rank,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w900)),
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
              style: TextStyle(color: ink, fontSize: 17, fontWeight: FontWeight.w900)),
          const SizedBox(height: 4),
          const Text('Choose the audience, time and participants.',
              style: TextStyle(color: muted, fontSize: 10.5)),
          const SizedBox(height: 16),
          TextField(
            controller: titleController,
            decoration: const InputDecoration(
              labelText: 'Meeting title',
              hintText: 'Example: LGA coordination review',
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: agendaController,
            minLines: 2,
            maxLines: 5,
            decoration: const InputDecoration(
              labelText: 'Agenda',
              hintText: 'What should the meeting cover?',
            ),
          ),
          const SizedBox(height: 14),
          const Text('Invite from',
              style: TextStyle(color: ink, fontWeight: FontWeight.w900)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: MeetingAudienceMode.values.map((mode) {
              return ChoiceChip(
                label: Text(_audienceLabel(mode)),
                selected: audienceMode == mode,
                onSelected: (_) => onAudienceModeChanged(mode),
              );
            }).toList(),
          ),
          if (audienceMode == MeetingAudienceMode.group) ...[
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              initialValue: selectedGroupId,
              decoration: const InputDecoration(labelText: 'Select group'),
              items: groups
                  .map((group) => DropdownMenuItem(
                        value: group.id,
                        child: Text(group.name),
                      ))
                  .toList(),
              onChanged: onGroupChanged,
            ),
          ],
          const SizedBox(height: 14),
          Row(children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: onPickTime,
                icon: const Icon(Icons.calendar_month_outlined),
                label: Text(_formatDateTime(startsAt)),
              ),
            ),
            const SizedBox(width: 10),
            DropdownButton<int>(
              value: durationMinutes,
              items: const [30, 45, 60, 90, 120]
                  .map((minutes) => DropdownMenuItem(
                        value: minutes,
                        child: Text('${minutes}m'),
                      ))
                  .toList(),
              onChanged: (value) {
                if (value != null) onDurationChanged(value);
              },
            ),
          ]),
          const SizedBox(height: 16),
          Row(children: [
            const Expanded(
              child: Text('Participants',
                  style: TextStyle(color: ink, fontWeight: FontWeight.w900)),
            ),
            Text('${selectedUserIds.length} selected',
                style: const TextStyle(color: muted, fontSize: 10.5)),
          ]),
          const SizedBox(height: 8),
          if (eligibleUsers.isEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFF7F9F7),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Text(
                'No members are available in this audience.',
                style: TextStyle(color: muted),
              ),
            )
          else
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: eligibleUsers.map((user) {
                final selected = selectedUserIds.contains(user.id);
                return FilterChip(
                  selected: selected,
                  avatar: CircleAvatar(
                    backgroundColor: selected ? pdpGreen : const Color(0xFFE8EEE9),
                    child: Text(
                      user.displayName.substring(0, 1).toUpperCase(),
                      style: TextStyle(
                        color: selected ? Colors.white : pdpGreen,
                        fontSize: 10,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  label: Text(user.displayName),
                  onSelected: (_) => onToggleUser(user.id),
                );
              }).toList(),
            ),
          const SizedBox(height: 18),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: onCreate,
              icon: const Icon(Icons.video_call_rounded),
              label: const Text('Create meeting'),
            ),
          ),
        ]),
      );
}

class _MeetingAccessCard extends StatelessWidget {
  const _MeetingAccessCard({
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
        const Text('Your coordination level',
            style: TextStyle(color: ink, fontSize: 17, fontWeight: FontWeight.w900)),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFFE7F4EB), Color(0xFFF7FAF7)],
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFD9E8DD)),
          ),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(coordinationRankLabel(rank),
                style: const TextStyle(
                    color: pdpGreenDark, fontSize: 18, fontWeight: FontWeight.w900)),
            const SizedBox(height: 3),
            Text(scope.label,
                style: const TextStyle(color: muted, fontSize: 10.5)),
          ]),
        ),
        const SizedBox(height: 16),
        const Text('You can coordinate',
            style: TextStyle(color: ink, fontWeight: FontWeight.w900)),
        const SizedBox(height: 8),
        if (creatable.isEmpty)
          const Text('Your assigned teams and groups.',
              style: TextStyle(color: muted, height: 1.4))
        else
          ...creatable.map((item) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(children: [
                  const Icon(Icons.check_circle_rounded, color: pdpGreen, size: 18),
                  const SizedBox(width: 8),
                  Text(coordinationRankLabel(item),
                      style: const TextStyle(color: ink, fontWeight: FontWeight.w700)),
                ]),
              )),
        const SizedBox(height: 12),
        const Divider(),
        const SizedBox(height: 8),
        const Text('Meeting audiences',
            style: TextStyle(color: ink, fontWeight: FontWeight.w900)),
        const SizedBox(height: 9),
        const _AccessLine(Icons.account_tree_outlined, 'My assignments',
            'People within your coordination line.'),
        const _AccessLine(Icons.location_on_outlined, 'My location',
            'Members within your campaign area.'),
        const _AccessLine(Icons.groups_2_outlined, 'Group',
            'Members of a campaign group you belong to.'),
      ]),
    );
  }
}

class _AccessLine extends StatelessWidget {
  const _AccessLine(this.icon, this.title, this.subtitle);
  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 11),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Icon(icon, color: pdpGreen, size: 19),
          const SizedBox(width: 9),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(title,
                  style: const TextStyle(color: ink, fontWeight: FontWeight.w800)),
              const SizedBox(height: 2),
              Text(subtitle,
                  style: const TextStyle(color: muted, fontSize: 10.5, height: 1.35)),
            ]),
          ),
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
          const Text('Meetings',
              style: TextStyle(color: ink, fontSize: 17, fontWeight: FontWeight.w900)),
          const SizedBox(height: 4),
          const Text('Scheduled and recent campaign meetings',
              style: TextStyle(color: muted, fontSize: 10.5)),
          const SizedBox(height: 14),
          if (meetings.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 28),
              child: Center(child: Text('No meetings yet.', style: TextStyle(color: muted))),
            )
          else
            ...meetings.map((meeting) {
              final organizer = meeting.organizerId == actorId;
              return Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAF8),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFE3E9E4)),
                ),
                child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: _statusColor(meeting.status).withValues(alpha: .10),
                      borderRadius: BorderRadius.circular(13),
                    ),
                    child: Icon(Icons.video_call_rounded,
                        color: _statusColor(meeting.status)),
                  ),
                  const SizedBox(width: 11),
                  Expanded(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Wrap(spacing: 7, runSpacing: 6, children: [
                        Text(meeting.title,
                            style: const TextStyle(
                                color: ink, fontWeight: FontWeight.w900)),
                        StatusPill(_statusLabel(meeting.status).toUpperCase(),
                            color: _statusColor(meeting.status)),
                      ]),
                      const SizedBox(height: 5),
                      Text(
                        '${_formatDateTime(meeting.startsAt)} • ${meeting.durationMinutes} min • ${meeting.participantNames.length} participants',
                        style: const TextStyle(color: muted, fontSize: 10.5),
                      ),
                      if (meeting.agenda.isNotEmpty) ...[
                        const SizedBox(height: 6),
                        Text(meeting.agenda,
                            style: const TextStyle(color: ink, fontSize: 11.5, height: 1.4)),
                      ],
                      const SizedBox(height: 7),
                      Text('Called by ${meeting.organizerName}',
                          style: const TextStyle(color: muted, fontSize: 10)),
                    ]),
                  ),
                  if (organizer && meeting.status == MeetingStatus.scheduled)
                    FilledButton.tonal(
                      onPressed: () => onStart(meeting.id),
                      child: const Text('Start'),
                    )
                  else if (organizer && meeting.status == MeetingStatus.live)
                    FilledButton.tonal(
                      onPressed: () => onComplete(meeting.id),
                      child: const Text('End'),
                    ),
                ]),
              );
            }),
        ]),
      );
}

String _audienceLabel(MeetingAudienceMode mode) => switch (mode) {
      MeetingAudienceMode.assignments => 'My assignments',
      MeetingAudienceMode.location => 'My location',
      MeetingAudienceMode.group => 'Group',
    };

String _statusLabel(MeetingStatus status) => switch (status) {
      MeetingStatus.scheduled => 'Scheduled',
      MeetingStatus.live => 'Live',
      MeetingStatus.completed => 'Completed',
      MeetingStatus.cancelled => 'Cancelled',
    };

Color _statusColor(MeetingStatus status) => switch (status) {
      MeetingStatus.scheduled => const Color(0xFF2563EB),
      MeetingStatus.live => pdpRed,
      MeetingStatus.completed => pdpGreen,
      MeetingStatus.cancelled => muted,
    };

String _formatDateTime(DateTime value) {
  final local = value.toLocal();
  final hour = local.hour % 12 == 0 ? 12 : local.hour % 12;
  final minute = local.minute.toString().padLeft(2, '0');
  final period = local.hour >= 12 ? 'PM' : 'AM';
  return '${_month(local.month)} ${local.day}, $hour:$minute $period';
}

String _month(int month) => const [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ][month - 1];
