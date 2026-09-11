import 'package:flutter/material.dart';

import 'widgets.dart';

class CommunicationsPage extends StatefulWidget {
  const CommunicationsPage({super.key});

  @override
  State<CommunicationsPage> createState() => _CommunicationsPageState();
}

class _CommunicationsPageState extends State<CommunicationsPage> {
  int selectedConversation = 0;
  String filter = 'All';
  String search = '';
  final composer = TextEditingController();
  final searchController = TextEditingController();

  final conversations = <_Conversation>[
    const _Conversation(
      title: 'Benue State Command',
      preview: 'Statewide campaign coordination',
      scope: 'Statewide',
      members: 34,
      unread: 12,
      type: _ConversationType.group,
    ),
    const _Conversation(
      title: 'Makurdi Operations',
      preview: 'Venue readiness updated',
      scope: 'Makurdi LGA',
      members: 18,
      unread: 4,
      type: _ConversationType.group,
    ),
    const _Conversation(
      title: 'Situation Room',
      preview: 'Incident follow-up in progress',
      scope: 'Response Team',
      members: 11,
      unread: 2,
      type: _ConversationType.incident,
    ),
    const _Conversation(
      title: 'Media & Intelligence',
      preview: 'Daily brief ready for review',
      scope: 'State Media Desk',
      members: 16,
      unread: 0,
      type: _ConversationType.group,
    ),
    const _Conversation(
      title: 'Logistics Command',
      preview: 'Vehicle movement update',
      scope: 'State Logistics',
      members: 22,
      unread: 0,
      type: _ConversationType.group,
    ),
    const _Conversation(
      title: 'LGA Coordinators',
      preview: 'Ward coverage update requested',
      scope: '23 LGAs',
      members: 27,
      unread: 7,
      type: _ConversationType.group,
    ),
    const _Conversation(
      title: 'Operations Director',
      preview: 'Direct message',
      scope: 'Direct message',
      members: 2,
      unread: 1,
      type: _ConversationType.direct,
    ),
  ];

  final messages = <int, List<_Message>>{
    0: [
      const _Message(
        sender: 'State Operations Desk',
        text: 'Makurdi team, confirm venue readiness and vehicle movement before 16:00.',
        time: '14:18',
      ),
      const _Message(
        sender: 'Makurdi Coordinator',
        text: 'Venue team is on ground. Generator and public-address system have arrived.',
        time: '14:22',
        attachment: 'Venue readiness checklist',
      ),
      const _Message(
        sender: 'You',
        text: 'Good. Flag any missing item before departure.',
        time: '14:24',
        mine: true,
      ),
    ],
    1: [
      const _Message(
        sender: 'Makurdi Coordinator',
        text: 'Venue access confirmed. Security liaison has checked the entry points.',
        time: '13:40',
      ),
      const _Message(
        sender: 'You',
        text: 'Please complete the vehicle and fuel checklist before the convoy moves.',
        time: '13:44',
        mine: true,
      ),
    ],
    2: [
      const _Message(
        sender: 'Situation Room Desk',
        text: 'A logistics interruption has been reported and assigned for follow-up.',
        time: '12:06',
      ),
      const _Message(
        sender: 'Legal Desk',
        text: 'Please preserve the original photos, timestamps and reporter details.',
        time: '12:11',
      ),
    ],
    3: [
      const _Message(
        sender: 'Media Desk',
        text: 'Morning media brief is ready. Two public claims are still under review.',
        time: '09:26',
        attachment: 'Morning media brief',
      ),
    ],
    4: [
      const _Message(
        sender: 'Fleet Desk',
        text: 'Vehicle 07 has been cleared after maintenance inspection.',
        time: '10:18',
      ),
    ],
    5: [
      const _Message(
        sender: 'Field Operations',
        text: 'All LGA coordinators should update ward coverage and personnel gaps today.',
        time: '08:15',
      ),
    ],
    6: [
      const _Message(
        sender: 'Operations Director',
        text: 'Please send the latest statewide operations summary when ready.',
        time: '14:02',
      ),
    ],
  };

  @override
  void dispose() {
    composer.dispose();
    searchController.dispose();
    super.dispose();
  }

  _Conversation get current => conversations[selectedConversation];
  List<_Message> get currentMessages =>
      messages.putIfAbsent(selectedConversation, () => <_Message>[]);

  List<MapEntry<int, _Conversation>> get visibleConversations {
    final q = search.trim().toLowerCase();
    return conversations.asMap().entries.where((entry) {
      final conversation = entry.value;
      final searchMatch = q.isEmpty ||
          conversation.title.toLowerCase().contains(q) ||
          conversation.preview.toLowerCase().contains(q) ||
          conversation.scope.toLowerCase().contains(q);
      final filterMatch = switch (filter) {
        'Unread' => conversation.unread > 0,
        'Groups' => conversation.type == _ConversationType.group,
        'Incidents' => conversation.type == _ConversationType.incident,
        'Direct' => conversation.type == _ConversationType.direct,
        _ => true,
      };
      return searchMatch && filterMatch;
    }).toList();
  }

  void sendMessage() {
    final text = composer.text.trim();
    if (text.isEmpty) return;
    setState(() {
      currentMessages.add(_Message(
        sender: 'You',
        text: text,
        time: TimeOfDay.now().format(context),
        mine: true,
      ));
      composer.clear();
    });
  }

  void selectConversation(int index) {
    setState(() {
      selectedConversation = index;
      final item = conversations[index];
      if (item.unread > 0) conversations[index] = item.copyWith(unread: 0);
    });
  }

  @override
  Widget build(BuildContext context) => LayoutBuilder(
        builder: (context, constraints) {
          final wide = constraints.maxWidth >= 900;
          if (!wide) {
            return Column(
              children: [
                SizedBox(height: 320, child: _conversationList()),
                const Divider(height: 1),
                Expanded(child: _chat()),
              ],
            );
          }
          return Row(
            children: [
              SizedBox(width: 360, child: _conversationList()),
              const VerticalDivider(width: 1),
              Expanded(child: _chat()),
            ],
          );
        },
      );

  Widget _conversationList() => ColoredBox(
        color: Colors.white,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 18, 18, 12),
              child: Row(
                children: [
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Communications',
                            style: TextStyle(
                                color: ink,
                                fontSize: 22,
                                fontWeight: FontWeight.w900)),
                        SizedBox(height: 3),
                        Text('Campaign conversations and coordination',
                            style: TextStyle(color: muted, fontSize: 10.5)),
                      ],
                    ),
                  ),
                  IconButton.filledTonal(
                    tooltip: 'New conversation',
                    onPressed: _newConversation,
                    icon: const Icon(Icons.add_comment_outlined),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: TextField(
                controller: searchController,
                onChanged: (value) => setState(() => search = value),
                decoration: const InputDecoration(
                  hintText: 'Search conversations',
                  prefixIcon: Icon(Icons.search_rounded),
                  isDense: true,
                ),
              ),
            ),
            const SizedBox(height: 10),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Row(
                children: ['All', 'Unread', 'Groups', 'Incidents', 'Direct']
                    .map((item) => Padding(
                          padding: const EdgeInsets.only(right: 7),
                          child: ChoiceChip(
                            label: Text(item),
                            selected: filter == item,
                            onSelected: (_) => setState(() => filter = item),
                          ),
                        ))
                    .toList(),
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                itemCount: visibleConversations.length,
                itemBuilder: (context, index) {
                  final entry = visibleConversations[index];
                  final conversation = entry.value;
                  final active = entry.key == selectedConversation;
                  return ListTile(
                    selected: active,
                    selectedTileColor: const Color(0xFFE8F4EB),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(13)),
                    onTap: () => selectConversation(entry.key),
                    leading: CircleAvatar(
                      backgroundColor: _conversationColor(conversation.type)
                          .withValues(alpha: .10),
                      child: Icon(_conversationIcon(conversation.type),
                          color: _conversationColor(conversation.type), size: 19),
                    ),
                    title: Text(conversation.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            color: ink, fontWeight: FontWeight.w900, fontSize: 12)),
                    subtitle: Text(conversation.preview,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(color: muted, fontSize: 10)),
                    trailing: conversation.unread > 0
                        ? CircleAvatar(
                            radius: 11,
                            backgroundColor: pdpGreen,
                            child: Text('${conversation.unread}',
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 8,
                                    fontWeight: FontWeight.w900)),
                          )
                        : null,
                  );
                },
              ),
            ),
          ],
        ),
      );

  Widget _chat() => ColoredBox(
        color: const Color(0xFFF5F7F5),
        child: Column(
          children: [
            Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 13),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor:
                        _conversationColor(current.type).withValues(alpha: .10),
                    child: Icon(_conversationIcon(current.type),
                        color: _conversationColor(current.type)),
                  ),
                  const SizedBox(width: 11),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(current.title,
                            style: const TextStyle(
                                color: ink,
                                fontSize: 15,
                                fontWeight: FontWeight.w900)),
                        const SizedBox(height: 2),
                        Text('${current.scope} • ${current.members} members',
                            style: const TextStyle(color: muted, fontSize: 10.5)),
                      ],
                    ),
                  ),
                  IconButton(
                    tooltip: 'Create task',
                    onPressed: _createTask,
                    icon: const Icon(Icons.task_alt_outlined),
                  ),
                  IconButton(
                    tooltip: 'Broadcast',
                    onPressed: _broadcast,
                    icon: const Icon(Icons.campaign_outlined),
                  ),
                  const IconButton(
                    tooltip: 'More',
                    onPressed: null,
                    icon: Icon(Icons.more_horiz_rounded),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(18),
                itemCount: currentMessages.length,
                itemBuilder: (context, index) =>
                    _MessageBubble(message: currentMessages[index]),
              ),
            ),
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(12),
              child: SafeArea(
                top: false,
                child: Row(
                  children: [
                    IconButton(
                      tooltip: 'Attach',
                      onPressed: () {},
                      icon: const Icon(Icons.attach_file_rounded),
                    ),
                    Expanded(
                      child: TextField(
                        controller: composer,
                        minLines: 1,
                        maxLines: 5,
                        onSubmitted: (_) => sendMessage(),
                        decoration: const InputDecoration(
                          hintText: 'Write a message…',
                          isDense: true,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton.filled(
                      tooltip: 'Send',
                      onPressed: sendMessage,
                      icon: const Icon(Icons.send_rounded),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );

  Future<void> _newConversation() async {
    final title = TextEditingController();
    final scope = TextEditingController();
    final created = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('New conversation'),
        content: SizedBox(
          width: 430,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: title,
                decoration: const InputDecoration(
                  labelText: 'Conversation name',
                  hintText: 'Example: Gboko Operations',
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: scope,
                decoration: const InputDecoration(
                  labelText: 'Campaign area or team',
                  hintText: 'Example: Gboko LGA',
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Create'),
          ),
        ],
      ),
    );
    if (created == true && title.text.trim().isNotEmpty) {
      setState(() {
        conversations.add(_Conversation(
          title: title.text.trim(),
          preview: 'New conversation',
          scope: scope.text.trim().isEmpty ? 'Campaign team' : scope.text.trim(),
          members: 1,
          unread: 0,
          type: _ConversationType.group,
        ));
        selectedConversation = conversations.length - 1;
        messages[selectedConversation] = [];
      });
    }
    title.dispose();
    scope.dispose();
  }

  Future<void> _broadcast() async {
    final body = TextEditingController();
    String target = 'All LGA coordinators';
    final sent = await showDialog<bool>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Campaign broadcast'),
          content: SizedBox(
            width: 480,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField<String>(
                  initialValue: target,
                  decoration: const InputDecoration(labelText: 'Recipients'),
                  items: const [
                    DropdownMenuItem(
                        value: 'All LGA coordinators',
                        child: Text('All LGA coordinators')),
                    DropdownMenuItem(
                        value: 'State command', child: Text('State command')),
                    DropdownMenuItem(
                        value: 'Situation Room teams',
                        child: Text('Situation Room teams')),
                    DropdownMenuItem(
                        value: 'Logistics teams', child: Text('Logistics teams')),
                  ],
                  onChanged: (value) {
                    if (value != null) setDialogState(() => target = value);
                  },
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: body,
                  minLines: 3,
                  maxLines: 6,
                  decoration: const InputDecoration(
                    labelText: 'Message',
                    hintText: 'Write a campaign notice…',
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            FilledButton.icon(
              onPressed: () => Navigator.pop(context, true),
              icon: const Icon(Icons.campaign_outlined),
              label: const Text('Send broadcast'),
            ),
          ],
        ),
      ),
    );
    if (sent == true && body.text.trim().isNotEmpty && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Broadcast sent to $target')),
      );
    }
    body.dispose();
  }

  Future<void> _createTask() async {
    final task = TextEditingController();
    final owner = TextEditingController(text: 'State Operations Desk');
    final created = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Create task'),
        content: SizedBox(
          width: 450,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: task,
                decoration: const InputDecoration(
                  labelText: 'Task',
                  hintText: 'Example: Confirm venue readiness',
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: owner,
                decoration: const InputDecoration(labelText: 'Owner'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Create task'),
          ),
        ],
      ),
    );
    if (created == true && task.text.trim().isNotEmpty && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Task created for ${owner.text.trim()}')),
      );
    }
    task.dispose();
    owner.dispose();
  }
}

enum _ConversationType { group, incident, direct }

class _Conversation {
  const _Conversation({
    required this.title,
    required this.preview,
    required this.scope,
    required this.members,
    required this.unread,
    required this.type,
  });

  final String title;
  final String preview;
  final String scope;
  final int members;
  final int unread;
  final _ConversationType type;

  _Conversation copyWith({int? unread}) => _Conversation(
        title: title,
        preview: preview,
        scope: scope,
        members: members,
        unread: unread ?? this.unread,
        type: type,
      );
}

class _Message {
  const _Message({
    required this.sender,
    required this.text,
    required this.time,
    this.mine = false,
    this.attachment,
  });

  final String sender;
  final String text;
  final String time;
  final bool mine;
  final String? attachment;
}

class _MessageBubble extends StatelessWidget {
  const _MessageBubble({required this.message});
  final _Message message;

  @override
  Widget build(BuildContext context) => Align(
        alignment: message.mine ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          constraints: const BoxConstraints(maxWidth: 610),
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: message.mine ? const Color(0xFFE3F3E8) : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFE2E8E3)),
          ),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            if (!message.mine) ...[
              Text(message.sender,
                  style: const TextStyle(
                      color: pdpGreenDark,
                      fontSize: 10.5,
                      fontWeight: FontWeight.w900)),
              const SizedBox(height: 4),
            ],
            Text(message.text,
                style: const TextStyle(color: ink, height: 1.4, fontSize: 12)),
            if (message.attachment != null) ...[
              const SizedBox(height: 9),
              Container(
                padding: const EdgeInsets.all(9),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: .75),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(mainAxisSize: MainAxisSize.min, children: [
                  const Icon(Icons.attach_file_rounded, size: 16, color: pdpGreen),
                  const SizedBox(width: 6),
                  Text(message.attachment!,
                      style: const TextStyle(
                          color: ink, fontSize: 10.5, fontWeight: FontWeight.w700)),
                ]),
              ),
            ],
            const SizedBox(height: 5),
            Align(
              alignment: Alignment.centerRight,
              child: Text(message.time,
                  style: const TextStyle(color: muted, fontSize: 9)),
            ),
          ]),
        ),
      );
}

IconData _conversationIcon(_ConversationType type) => switch (type) {
      _ConversationType.group => Icons.groups_2_outlined,
      _ConversationType.incident => Icons.radar_rounded,
      _ConversationType.direct => Icons.person_outline_rounded,
    };

Color _conversationColor(_ConversationType type) => switch (type) {
      _ConversationType.group => pdpGreen,
      _ConversationType.incident => pdpRed,
      _ConversationType.direct => const Color(0xFF2563EB),
    };
