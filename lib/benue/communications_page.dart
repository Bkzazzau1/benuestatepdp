import 'package:flutter/material.dart';

import 'widgets.dart';

class CommunicationsPage extends StatefulWidget {
  const CommunicationsPage({super.key});

  @override
  State<CommunicationsPage> createState() => _CommunicationsPageState();
}

class _CommunicationsPageState extends State<CommunicationsPage> {
  int selectedConversation = 0;
  final composer = TextEditingController();
  final messages = <_Message>[
    const _Message(
      sender: 'State Operations Desk',
      text: 'Makurdi team, confirm venue readiness and vehicle movement before 16:00.',
      time: '14:18',
      mine: false,
      status: 'Read',
    ),
    const _Message(
      sender: 'Makurdi Coordinator',
      text: 'Venue team is on ground. Generator and public-address system have arrived.',
      time: '14:22',
      mine: false,
      status: 'Read',
    ),
    const _Message(
      sender: 'You',
      text: 'Good. Attach the readiness checklist and flag any missing item before departure.',
      time: '14:24',
      mine: true,
      status: 'Read by 8',
    ),
  ];

  @override
  void dispose() {
    composer.dispose();
    super.dispose();
  }

  void _send() {
    final text = composer.text.trim();
    if (text.isEmpty) return;
    setState(() {
      messages.add(_Message(
        sender: 'You',
        text: text,
        time: TimeOfDay.now().format(context),
        mine: true,
        status: 'Sent',
      ));
      composer.clear();
    });
  }

  @override
  Widget build(BuildContext context) => LayoutBuilder(
        builder: (context, constraints) {
          final wide = constraints.maxWidth >= 960;
          return ListView(
            padding: const EdgeInsets.all(28),
            children: [
              const PageHeading(
                title: 'Communications',
                subtitle:
                    'Secure internal messaging for campaign command, LGA teams, wards, field officers and incident rooms.',
                trailing: StatusPill('INTERNAL ONLY'),
              ),
              const SizedBox(height: 18),
              const _CommunicationsNotice(),
              const SizedBox(height: 18),
              if (wide)
                SizedBox(
                  height: 690,
                  child: Row(
                    children: [
                      SizedBox(width: 320, child: _conversationList()),
                      const SizedBox(width: 14),
                      Expanded(child: _chatPanel()),
                      const SizedBox(width: 14),
                      SizedBox(width: 285, child: _contextPanel()),
                    ],
                  ),
                )
              else ...[
                _conversationList(),
                const SizedBox(height: 14),
                SizedBox(height: 620, child: _chatPanel()),
                const SizedBox(height: 14),
                _contextPanel(),
              ],
            ],
          );
        },
      );

  Widget _conversationList() {
    const items = <_Conversation>[
      _Conversation('Benue State Command', 'Statewide Operations', '12', true),
      _Conversation('Makurdi Operations', 'Venue readiness updated', '4', true),
      _Conversation('Situation Room — INC-021', 'Legal desk joined', '2', true),
      _Conversation('Media & Intelligence', 'Daily brief ready for review', '', false),
      _Conversation('Logistics Command', 'Vehicle 07 maintenance cleared', '', false),
      _Conversation('LGA Coordinators', 'Ward coverage request sent', '7', true),
      _Conversation('Election Readiness', 'Agent roster import pending', '', false),
    ];

    return SectionCard(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                const Expanded(
                  child: Text('Chats',
                      style:
                          TextStyle(fontSize: 19, fontWeight: FontWeight.w900)),
                ),
                IconButton(
                  tooltip: 'New conversation',
                  onPressed: () {},
                  icon: const Icon(Icons.edit_square),
                ),
              ],
            ),
          ),
          TextField(
            decoration: InputDecoration(
              hintText: 'Search conversations',
              prefixIcon: const Icon(Icons.search),
              filled: true,
              fillColor: const Color(0xFFF4F7F4),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: const [
              _FilterChip('All'),
              _FilterChip('Unread'),
              _FilterChip('Groups'),
              _FilterChip('Incidents'),
            ],
          ),
          const SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                final active = selectedConversation == index;
                return ListTile(
                  selected: active,
                  selectedTileColor: const Color(0xFFE8F4EB),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                  onTap: () => setState(() => selectedConversation = index),
                  leading: CircleAvatar(
                    backgroundColor: active
                        ? pdpGreen.withOpacity(.12)
                        : const Color(0xFFF0F3F0),
                    child: Icon(
                      item.incident ? Icons.warning_amber_rounded : Icons.groups_2,
                      color: item.incident ? pdpRed : pdpGreen,
                    ),
                  ),
                  title: Text(item.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontWeight: FontWeight.w900)),
                  subtitle: Text(item.preview,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis),
                  trailing: item.unread.isEmpty
                      ? null
                      : CircleAvatar(
                          radius: 11,
                          backgroundColor: pdpGreen,
                          child: Text(item.unread,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w900)),
                        ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _chatPanel() => SectionCard(
        padding: EdgeInsets.zero,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(18, 14, 10, 14),
              decoration: const BoxDecoration(
                border: Border(bottom: BorderSide(color: Color(0xFFE7ECE8))),
              ),
              child: Row(
                children: [
                  const CircleAvatar(
                    backgroundColor: Color(0xFFE7F3E9),
                    child: Icon(Icons.groups_2, color: pdpGreen),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Benue State Command',
                            style: TextStyle(
                                fontSize: 17, fontWeight: FontWeight.w900)),
                        Text('34 authorized members • Operations channel',
                            style: TextStyle(color: muted, fontSize: 12)),
                      ],
                    ),
                  ),
                  IconButton(
                      tooltip: 'Voice call',
                      onPressed: () {},
                      icon: const Icon(Icons.call_outlined)),
                  IconButton(
                      tooltip: 'Video meeting',
                      onPressed: () {},
                      icon: const Icon(Icons.videocam_outlined)),
                  IconButton(
                      tooltip: 'Channel details',
                      onPressed: () {},
                      icon: const Icon(Icons.more_vert)),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(18),
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  final m = messages[index];
                  return Align(
                    alignment:
                        m.mine ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      constraints: const BoxConstraints(maxWidth: 520),
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(13),
                      decoration: BoxDecoration(
                        color: m.mine
                            ? const Color(0xFFDFF2E4)
                            : const Color(0xFFF2F5F2),
                        borderRadius: BorderRadius.only(
                          topLeft: const Radius.circular(16),
                          topRight: const Radius.circular(16),
                          bottomLeft:
                              Radius.circular(m.mine ? 16 : 4),
                          bottomRight:
                              Radius.circular(m.mine ? 4 : 16),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (!m.mine)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 4),
                              child: Text(m.sender,
                                  style: const TextStyle(
                                      color: pdpGreenDark,
                                      fontWeight: FontWeight.w900,
                                      fontSize: 12)),
                            ),
                          Text(m.text,
                              style:
                                  const TextStyle(color: ink, height: 1.35)),
                          const SizedBox(height: 6),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(m.time,
                                  style: const TextStyle(
                                      color: muted, fontSize: 10)),
                              const SizedBox(width: 8),
                              Text(m.status,
                                  style: const TextStyle(
                                      color: muted, fontSize: 10)),
                            ],
                          )
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: const BoxDecoration(
                border: Border(top: BorderSide(color: Color(0xFFE7ECE8))),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  IconButton(
                      tooltip: 'Attach file',
                      onPressed: () {},
                      icon: const Icon(Icons.attach_file)),
                  IconButton(
                      tooltip: 'Camera',
                      onPressed: () {},
                      icon: const Icon(Icons.camera_alt_outlined)),
                  Expanded(
                    child: TextField(
                      controller: composer,
                      minLines: 1,
                      maxLines: 4,
                      onSubmitted: (_) => _send(),
                      decoration: InputDecoration(
                        hintText: 'Message Benue State Command',
                        filled: true,
                        fillColor: const Color(0xFFF4F7F4),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton.filled(
                    style: IconButton.styleFrom(backgroundColor: pdpGreen),
                    onPressed: _send,
                    icon: const Icon(Icons.send_rounded),
                  ),
                ],
              ),
            ),
          ],
        ),
      );

  Widget _contextPanel() => SectionCard(
        child: ListView(
          children: [
            const Text('Channel controls',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
            const SizedBox(height: 12),
            const _ActionTile(Icons.campaign_outlined, 'Broadcast message',
                'Send an authorized notice to selected operational groups.'),
            const _ActionTile(Icons.warning_amber_rounded, 'Link incident',
                'Attach this conversation to an incident or escalation record.'),
            const _ActionTile(Icons.assignment_outlined, 'Create task',
                'Convert a message into an assigned operational task.'),
            const _ActionTile(Icons.location_on_outlined, 'Share location',
                'Share current operational location only with authorized members.'),
            const _ActionTile(Icons.folder_outlined, 'Shared files',
                'Photos, documents, audio and campaign materials in this channel.'),
            const Divider(height: 30),
            const Text('Communication policy',
                style: TextStyle(fontWeight: FontWeight.w900)),
            const SizedBox(height: 8),
            const Text(
              'Messaging is for internal campaign operations. Access is role-based, critical actions are auditable, and no hidden camera or microphone activation is permitted.',
              style: TextStyle(color: muted, height: 1.45),
            ),
            const SizedBox(height: 14),
            const StatusPill('ROLE-BASED ACCESS'),
          ],
        ),
      );
}

class _CommunicationsNotice extends StatelessWidget {
  const _CommunicationsNotice();

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xFFEAF4ED),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFD5E7DA)),
        ),
        child: const Row(
          children: [
            Icon(Icons.lock_outline_rounded, color: pdpGreen),
            SizedBox(width: 10),
            Expanded(
              child: Text(
                'Prototype communication layer: direct messages, team channels, broadcasts, attachments, incident threads, delivery/read state and secure-call entry points. Production encryption and calling require audited backend/native services.',
                style: TextStyle(fontWeight: FontWeight.w600, color: ink),
              ),
            ),
          ],
        ),
      );
}

class _Conversation {
  const _Conversation(this.title, this.preview, this.unread, this.incident);
  final String title;
  final String preview;
  final String unread;
  final bool incident;
}

class _Message {
  const _Message({
    required this.sender,
    required this.text,
    required this.time,
    required this.mine,
    required this.status,
  });

  final String sender;
  final String text;
  final String time;
  final bool mine;
  final String status;
}

class _FilterChip extends StatelessWidget {
  const _FilterChip(this.label);
  final String label;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: const Color(0xFFF1F5F2),
          borderRadius: BorderRadius.circular(999),
        ),
        child: Text(label,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800)),
      );
}

class _ActionTile extends StatelessWidget {
  const _ActionTile(this.icon, this.title, this.detail);
  final IconData icon;
  final String title;
  final String detail;

  @override
  Widget build(BuildContext context) => ListTile(
        contentPadding: EdgeInsets.zero,
        leading: CircleAvatar(
          backgroundColor: const Color(0xFFEAF4ED),
          child: Icon(icon, color: pdpGreen),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w800)),
        subtitle: Text(detail),
        onTap: () {},
      );
}
