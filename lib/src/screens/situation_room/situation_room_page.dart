import 'package:flutter/material.dart';
import 'package:polisphere/src/auth/app_role.dart';
import 'package:polisphere/src/auth/session.dart';
import 'package:polisphere/src/data/zaria_constituency.dart';
import 'package:polisphere/src/theme/app_theme.dart';
import 'package:polisphere/src/widgets/common.dart';

part 'command_dashboard_page.dart';
part 'incidents_page.dart';
part 'live_map_page.dart';
part 'communications_page.dart';
part 'daily_brief_page.dart';
part 'social_pulse_page.dart';
part 'verification_page.dart';
part 'agents_page.dart';
part 'evidence_page.dart';
part 'alerts_page.dart';
part 'ai_intelligence_page.dart';
part 'meetings_page.dart';
part 'placeholder_console.dart';

class SituationRoomPage extends StatefulWidget {
  const SituationRoomPage({super.key});

  @override
  State<SituationRoomPage> createState() => _SituationRoomPageState();
}

class _SituationRoomPageState extends State<SituationRoomPage> {
  int _section = 0;
  String _scope = 'All wards';
  String _window = 'Live';
  bool _chatOpen = false;
  final Set<String> _acknowledged = {};

  static const _allNav = <(String, IconData)>[
    ('Command', Icons.space_dashboard_outlined),
    ('Live map', Icons.map_outlined),
    ('Incidents', Icons.warning_amber_rounded),
    ('Verification', Icons.fact_check_outlined),
    ('Agents', Icons.groups_outlined),
    ('Communications', Icons.headset_mic_outlined),
    ('Meetings', Icons.groups_2_outlined),
    ('Evidence', Icons.perm_media_outlined),
    ('Alerts', Icons.notifications_active_outlined),
    ('Social pulse', Icons.monitor_heart_outlined),
    ('Daily brief', Icons.auto_awesome_outlined),
    ('AI intelligence', Icons.psychology_alt_outlined),
  ];

  @override
  Widget build(BuildContext context) {
    final role = SessionScope.of(context).role!;
    final nav = _allNav
        .where((item) => role.situationRoomSections.contains(item.$1))
        .toList();
    _section = _section.clamp(0, nav.isEmpty ? 0 : nav.length - 1);
    final activeLabel = nav.isEmpty ? '' : nav[_section].$1;
    final activeIcon = nav.isEmpty ? Icons.block : nav[_section].$2;
    return Scaffold(
      backgroundColor: const Color(0xFFF2F5F8),
      body: Stack(children: [
        Row(children: [
          _Sidebar(
            selected: _section,
            items: nav,
            role: role,
            onSelected: (value) => setState(() => _section = value),
          ),
          Expanded(
            child: Column(children: [
              _TopBar(
                scope: _scope,
                window: _window,
                readOnly: !role.canEdit,
                onScope: (value) => setState(() => _scope = value!),
                onWindow: (value) => setState(() => _window = value!),
                onChat: () => setState(() => _chatOpen = !_chatOpen),
              ),
              Expanded(
                child: _buildSection(activeLabel, activeIcon, role),
              ),
            ]),
          ),
        ]),
        if (_chatOpen)
          Positioned(
            top: 72,
            right: 0,
            bottom: 0,
            width: 390,
            child:
                _OperatorChat(onClose: () => setState(() => _chatOpen = false)),
          ),
      ]),
    );
  }

  Widget _buildSection(String label, IconData icon, AppRole role) {
    final readOnly = !role.canEdit;
    switch (label) {
      case 'Command':
        return _CommandDashboard(
          acknowledged: _acknowledged,
          readOnly: readOnly,
          onAcknowledge: (id) => setState(() => _acknowledged.add(id)),
          onOpenIncident: _showIncident,
        );
      case 'Live map':
        return _LiveMapPage(onOpenIncident: _showIncident);
      case 'Incidents':
        return _IncidentOperationsPage(onOpenIncident: _showIncident);
      case 'Verification':
        return const _VerificationCenterPage();
      case 'Agents':
        return _AgentOperationsPage(readOnly: readOnly);
      case 'Communications':
        return const _CommunicationsCenterPage();
      case 'Meetings':
        return _MeetingsPage(
            readOnly: readOnly, canManageGroups: role.canManageGroups);
      case 'Evidence':
        return const _EvidenceCenterPage();
      case 'Alerts':
        return _AlertsPage(onOpenIncident: _showIncident);
      case 'Social pulse':
        return const _SocialPulsePage();
      case 'Daily brief':
        return const _DailyBriefPage();
      case 'AI intelligence':
        return const _AiIntelligencePage();
      default:
        return _ConsolePage(
          title: label,
          icon: icon,
          onOpenIncident: _showIncident,
        );
    }
  }

  void _showIncident(String id) {
    showDialog<void>(
      context: context,
      builder: (_) => Dialog(
        insetPadding: const EdgeInsets.all(32),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 920, maxHeight: 720),
          child: _IncidentConsole(id: id),
        ),
      ),
    );
  }
}

class _Sidebar extends StatelessWidget {
  const _Sidebar(
      {required this.selected,
      required this.items,
      required this.role,
      required this.onSelected});
  final int selected;
  final List<(String, IconData)> items;
  final AppRole role;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) => Container(
        width: 224,
        color: AppColors.navy,
        padding: const EdgeInsets.fromLTRB(16, 22, 16, 16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Row(children: [
            _Logo(),
            SizedBox(width: 11),
            Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  Text('HON. SULEIMAN IBRAHIM DABO',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                          fontSize: 12,
                          letterSpacing: 1.1)),
                  Text('SITUATION ROOM',
                      style: TextStyle(
                          color: Color(0xFF8EA0B9),
                          fontSize: 9,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1.2)),
                ])),
          ]),
          const SizedBox(height: 27),
          Expanded(
            child: ListView.separated(
              itemCount: items.length,
              separatorBuilder: (_, __) => const SizedBox(height: 3),
              itemBuilder: (_, i) => Material(
                color: i == selected
                    ? const Color(0xFF243A59)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(10),
                child: InkWell(
                  onTap: () => onSelected(i),
                  borderRadius: BorderRadius.circular(10),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 11),
                    child: Row(children: [
                      Icon(items[i].$2,
                          size: 19,
                          color: i == selected
                              ? Colors.white
                              : const Color(0xFF91A1B7)),
                      const SizedBox(width: 12),
                      Expanded(
                          child: Text(items[i].$1,
                              style: TextStyle(
                                  color: i == selected
                                      ? Colors.white
                                      : const Color(0xFFC0CAD8),
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13))),
                      if (items[i].$1 == 'Alerts') const _CountBadge('4'),
                      if (items[i].$1 == 'Verification')
                        const _CountBadge('12'),
                    ]),
                  ),
                ),
              ),
            ),
          ),
          const Divider(color: Color(0xFF30445F)),
          InkWell(
            borderRadius: BorderRadius.circular(10),
            onTap: () => _confirmSignOut(context),
            child: ListTile(
              contentPadding: EdgeInsets.zero,
              leading: CircleAvatar(
                  backgroundColor: const Color(0xFF315D91),
                  child: Text(_initials(role.demoUserName),
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w800))),
              title: Text(role.demoUserName,
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 13)),
              subtitle: Text(role.label,
                  style:
                      const TextStyle(color: Color(0xFF91A1B7), fontSize: 10)),
              trailing: const Icon(Icons.logout_rounded,
                  color: Color(0xFF91A1B7), size: 16),
            ),
          ),
        ]),
      );

  static String _initials(String name) {
    final parts = name.split(' ').where((p) => p.isNotEmpty).toList();
    if (parts.isEmpty) return '?';
    return parts.length == 1
        ? parts.first.substring(0, 1).toUpperCase()
        : (parts.first.substring(0, 1) + parts.last.substring(0, 1))
            .toUpperCase();
  }

  void _confirmSignOut(BuildContext context) => showDialog<void>(
        context: context,
        builder: (dialogContext) => AlertDialog(
          title: const Text('Sign out?'),
          content: Text('End the ${role.label} session on this device.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.pop(dialogContext);
                SessionScope.of(context).signOut();
              },
              child: const Text('Sign out'),
            ),
          ],
        ),
      );
}

class _Logo extends StatelessWidget {
  const _Logo();
  @override
  Widget build(BuildContext context) => Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
            gradient:
                const LinearGradient(colors: [AppColors.blue, AppColors.cyan]),
            borderRadius: BorderRadius.circular(11)),
        child: const Icon(Icons.hub_rounded, color: Colors.white, size: 20),
      );
}

class _CountBadge extends StatelessWidget {
  const _CountBadge(this.value);
  final String value;
  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        decoration: BoxDecoration(
            color: AppColors.red, borderRadius: BorderRadius.circular(10)),
        child: Text(value,
            style: const TextStyle(
                color: Colors.white, fontSize: 9, fontWeight: FontWeight.w800)),
      );
}

class _TopBar extends StatelessWidget {
  const _TopBar(
      {required this.scope,
      required this.window,
      required this.readOnly,
      required this.onScope,
      required this.onWindow,
      required this.onChat});
  final String scope;
  final String window;
  final bool readOnly;
  final ValueChanged<String?> onScope;
  final ValueChanged<String?> onWindow;
  final VoidCallback onChat;

  @override
  Widget build(BuildContext context) => Container(
        height: 72,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(bottom: BorderSide(color: AppColors.border))),
        child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SizedBox(
                width: MediaQuery.sizeOf(context).width - 240,
                child: Row(children: [
                  const StatusPill('LIVE OPERATIONS',
                      color: AppColors.green, icon: Icons.circle),
                  if (readOnly) ...[
                    const SizedBox(width: 8),
                    const StatusPill('VIEW-ONLY ACCESS',
                        color: AppColors.amber, icon: Icons.lock_outline_rounded),
                  ],
                  const SizedBox(width: 14),
                  const Text('04 SEP 2026  •  14:42 WAT',
                      style: TextStyle(
                          color: AppColors.muted,
                          fontSize: 0,
                          fontWeight: FontWeight.w700)),
                  const Spacer(),
                  const SizedBox.shrink(),
                  const SizedBox(width: 8),
                  _CompactDropdown(
                      value: window,
                      values: const ['Live', 'Last 6 hours', 'Today'],
                      icon: Icons.schedule_rounded,
                      onChanged: onWindow),
                  const SizedBox(width: 10),
                  FilledButton.icon(
                      onPressed: onChat,
                      style: FilledButton.styleFrom(
                          minimumSize: const Size(0, 38),
                          backgroundColor: AppColors.navy),
                      icon: const Icon(Icons.auto_awesome_rounded, size: 16),
                      label: const Text('Ask Poli AI')),
                  const SizedBox(width: 6),
                  IconButton(
                      onPressed: () {},
                      icon: const Badge(
                          label: Text('4'),
                          child: Icon(Icons.notifications_none_rounded))),
                  const VerticalDivider(indent: 18, endIndent: 18),
                  const SizedBox.shrink(),
                ]))),
      );
}

class _CompactDropdown extends StatelessWidget {
  const _CompactDropdown(
      {required this.value,
      required this.values,
      required this.icon,
      required this.onChanged});
  final String value;
  final List<String> values;
  final IconData icon;
  final ValueChanged<String?> onChanged;
  @override
  Widget build(BuildContext context) => Container(
        height: 38,
        padding: const EdgeInsets.only(left: 10),
        decoration: BoxDecoration(
            border: Border.all(color: AppColors.border),
            borderRadius: BorderRadius.circular(9)),
        child: Row(children: [
          Icon(icon, size: 16, color: AppColors.muted),
          const SizedBox(width: 6),
          DropdownButton<String>(
              value: value,
              underline: const SizedBox(),
              borderRadius: BorderRadius.circular(10),
              style: const TextStyle(
                  color: AppColors.navy,
                  fontSize: 12,
                  fontWeight: FontWeight.w600),
              items: values
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: onChanged),
        ]),
      );
}
