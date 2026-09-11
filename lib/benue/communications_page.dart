import 'package:flutter/material.dart';

import 'widgets.dart';

class CommunicationsPage extends StatefulWidget {
  const CommunicationsPage({super.key});

  @override
  State<CommunicationsPage> createState() => _CommunicationsPageState();
}

class _CommunicationsPageState extends State<CommunicationsPage> {
  int selectedConversation = 0;
  String activeFilter = 'All';
  String searchQuery = '';

  final composer = TextEditingController();
  final searchController = TextEditingController();

  final conversations = <_Conversation>[
    const _Conversation(
      title: 'Benue State Command',
      preview: 'Statewide operations coordination',
      unread: 12,
      type: _ConversationType.group,
      members: 34,
      scope: 'Statewide Operations',
    ),
    const _Conversation(
      title: 'Makurdi Operations',
      preview: 'Venue readiness updated',
      unread: 4,
      type: _ConversationType.group,
      members: 18,
      scope: 'Makurdi LGA',
    ),
    const _Conversation(
      title: 'Situation Room — INC-021',
      preview: 'Legal desk joined the incident room',
      unread: 2,
      type: _ConversationType.incident,
      members: 11,
      scope: 'Critical incident',
      linkedIncident: 'INC-021',
    ),
    const _Conversation(
      title: 'Media & Intelligence',
      preview: 'Daily brief ready for review',
      unread: 0,
      type: _ConversationType.group,
      members: 16,
      scope: 'State Media Desk',
    ),
    const _Conversation(
      title: 'Logistics Command',
      preview: 'Vehicle 07 maintenance cleared',
      unread: 0,
      type: _ConversationType.group,
      members: 22,
      scope: 'State Logistics',
    ),
    const _Conversation(
      title: 'LGA Coordinators',
      preview: 'Ward coverage request sent',
      unread: 7,
      type: _ConversationType.group,
      members: 27,
      scope: '23 LGAs',
    ),
    const _Conversation(
      title: 'Election Readiness',
      preview: 'Agent roster import pending',
      unread: 0,
      type: _ConversationType.group,
      members: 31,
      scope: 'Election Operations',
    ),
    const _Conversation(
      title: 'Operations Director',
      preview: 'Direct message',
      unread: 1,
      type: _ConversationType.direct,
      members: 2,
      scope: 'Direct message',
    ),
  ];

  final messagesByConversation = <int, List<_Message>>{
    0: [
      const _Message(
        sender: 'State Operations Desk',
        text:
            'Makurdi team, confirm venue readiness and vehicle movement before 16:00.',
        time: '14:18',
        mine: false,
        status: 'Read',
      ),
      const _Message(
        sender: 'Makurdi Coordinator',
        text:
            'Venue team is on ground. Generator and public-address system have arrived.',
        time: '14:22',
        mine: false,
        status: 'Read',
        attachmentLabel: 'Venue readiness checklist',
      ),
      const _Message(
        sender: 'You',
        text:
            'Good. Attach the readiness checklist and flag any missing item before departure.',
        time: '14:24',
        mine: true,
        status: 'Read by 8',
      ),
    ],
    1: [
      const _Message(
        sender: 'Makurdi Coordinator',
        text: 'Venue access confirmed. Security liaison has checked the entry points.',
        time: '13:40',
        mine: false,
        status: 'Read',
      ),
      const _Message(
        sender: 'You',
        text: 'Please complete the vehicle and fuel checklist before the convoy moves.',
        time: '13:44',
        mine: true,
        status: 'Delivered',
      ),
    ],
    2: [
      const _Message(
        sender: 'Situation Room Desk',
        text:
            'INC-021 opened after a logistics interruption report. Verification is in progress.',
        time: '12:06',
        mine: false,
        status: 'Read',
        incidentId: 'INC-021',
      ),
      const _Message(
        sender: 'Legal Desk',
        text:
            'Legal team joined. Preserve original photos, timestamps and reporter identity.',
        time: '12:11',
        mine: false,
        status: 'Read',
        incidentId: 'INC-021',
      ),
      const _Message(
        sender: 'You',
        text:
            'Assign operations follow-up and keep the incident room open until evidence review is complete.',
        time: '12:13',
        mine: true,
        status: 'Read by 6',
        incidentId: 'INC-021',
      ),
    ],
    3: [
      const _Message(
        sender: 'Media Desk',
        text:
            'Morning media brief is ready. Two claims remain in the verification queue.',
        time: '09:26',
        mine: false,
        status: 'Read',
        attachmentLabel: 'Morning media brief',
      ),
    ],
    4: [
      const _Message(
        sender: 'Fleet Desk',
        text: 'Vehicle 07 has been cleared after maintenance inspection.',
        time: '10:18',
        mine: false,
        status: 'Read',
      ),
    ],
    5: [
      const _Message(
        sender: 'Field Operations',
        text:
            'All LGA coordinators should update ward coverage and outstanding personnel gaps today.',
        time: '08:15',
        mine: false,
        status: 'Read',
      ),
    ],
    6: [
      const _Message(
        sender: 'Election Operations',
        text:
            'Verified polling-unit agent roster is not yet loaded. Do not display inferred coverage figures.',
        time: '11:03',
        mine: false,
        status: 'Read',
      ),
    ],
    7: [
      const _Message(
        sender: 'Operations Director',
        text: 'Please send the latest statewide operations summary when ready.',
        time: '14:02',
        mine: false,
        status: 'Read',
      ),
    ],
  };

  @override
  void dispose() {
    composer.dispose();
    searchController.dispose();
    super.dispose();
  }

  _Conversation get currentConversation => conversations[selectedConversation];
  List<_Message> get currentMessages =>
      messagesByConversation.putIfAbsent(selectedConversation, () => []);

  List<MapEntry<int, _Conversation>> get visibleConversations {
    final q = searchQuery.trim().toLowerCase();
    return conversations.asMap().entries.where((entry) {
      final item = entry.value;
      final matchesSearch = q.isEmpty ||
          item.title.toLowerCase().contains(q) ||
          item.preview.toLowerCase().contains(q) ||
          item.scope.toLowerCase().contains(q);
      final matchesFilter = switch (activeFilter) {
        'Unread' => item.unread > 0,
        'Groups' => item.type == _ConversationType.group,
        'Incidents' => item.type == _ConversationType.incident,
        'Direct' => item.type == _ConversationType.direct,
        _ => true,
      };
      return matchesSearch && matchesFilter;
    }).toList();
  }

  void _send() {
    final text = composer.text.trim();
    if (text.isEmpty) return;
    setState(() {
      currentMessages.add(_Message(
        sender: 'You',
        text: text,
        time: TimeOfDay.now().format(context),
        mine: true,
        status: 'Sent',
        incidentId: currentConversation.linkedIncident,
      ));
      composer.clear();
    });
  }

  void _selectConversation(int index) {
    setState(() {
      selectedConversation = index;
      final current = conversations[index];
      if (current.unread > 0) {
        conversations[index] = current.copyWith(unread: 0);
      }
    });
  }

  void _showSnack(String text) => ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(text), behavior: SnackBarBehavior.floating),
      );

  Future<void> _newConversation() async {
    final title = TextEditingController();
    final scope = TextEditingController();
    final created = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('New operational conversation'),
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
                  labelText: 'Operational scope',
                  hintText: 'Example: Gboko LGA',
                ),
              ),
              const SizedBox(height: 14),
              const Text(
                'Prototype only: production creation will enforce role and geography permissions.',
                style: TextStyle(color: muted),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel')),
          FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Create')),
        ],
      ),
    );
    if (created != true || title.text.trim().isEmpty) return;
    setState(() {
      conversations.add(_Conversation(
        title: title.text.trim(),
        preview: 'New operational channel',
        unread: 0,
        type: _ConversationType.group,
        members: 1,
        scope: scope.text.trim().isEmpty ? 'Campaign operations' : scope.text.trim(),
      ));
      selectedConversation = conversations.length - 1;
      messagesByConversation[selectedConversation] = [];
    });
    title.dispose();
    scope.dispose();
  }

  Future<void> _composeBroadcast() async {
    final body = TextEditingController();
    String target = 'All LGA coordinators';
    final sent = await showDialog<bool>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setLocalState) => AlertDialog(
          title: const Text('Operational broadcast'),
          content: SizedBox(
            width: 480,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
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
                    if (value != null) setLocalState(() => target = value);
                  },
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: body,
                  minLines: 3,
                  maxLines: 6,
                  decoration: const InputDecoration(
                    labelText: 'Broadcast message',
                    hintText: 'Write a concise operational notice...',
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Production broadcasts will record sender, audience, time and delivery state in the audit trail.',
                  style: TextStyle(color: muted),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancel')),
            FilledButton.icon(
              onPressed: () => Navigator.pop(context, true),
              icon: const Icon(Icons.campaign_outlined),
              label: const Text('Send broadcast'),
            ),
          ],
        ),
      ),
    );
    if (sent == true && body.text.trim().isNotEmpty) {
      _showSnack('Broadcast queued for $target');
    }
    body.dispose();
  }

  Future<void> _createTask() async {
    final task = TextEditingController();
    final owner = TextEditingController(text: 'State Operations Desk');
    final created = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Create task from conversation'),
        content: SizedBox(
          width: 450,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: task,
                decoration: const InputDecoration(
                  labelText: 'Task',
                  hintText: 'Example: Verify venue readiness checklist',
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: owner,
                decoration: const InputDecoration(labelText: 'Owner'),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  const Icon(Icons.link_rounded, size: 18, color: pdpGreen),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Linked to ${currentConversation.title}',
                      style: const TextStyle(color: muted),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel')),
          FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Create task')),
        ],
      ),
    );
    if (created == true && task.text.trim().isNotEmpty) {
      _showSnack('Task created for ${owner.text.trim()}');
    }
    task.dispose();
    owner.dispose();
  }

  Future<void> _linkIncident() async {
    final incident = TextEditingController(
        text: currentConversation.linkedIncident ?? 'INC-');
    final linked = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Link incident'),
        content: SizedBox(
          width: 420,
          child: TextField(
            controller: incident,
            decoration: const InputDecoration(
              labelText: 'Incident ID',
              hintText: 'INC-021',
            ),
          ),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel')),
          FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Link')),
        ],
      ),
    );
    if (linked == true && incident.text.trim().isNotEmpty) {
      final id = incident.text.trim().toUpperCase();
      setState(() {
        conversations[selectedConversation] =
            currentConversation.copyWith(linkedIncident: id);
      });
      _showSnack('${currentConversation.title} linked to $id');
    }
    incident.dispose();
  }

  Future<void> _shareLocation() async {
    final accepted = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Share operational location?'),
        content: const Text(
          'Location sharing must be explicit and purpose-limited. This prototype will add a location card to the conversation; production will request device permission only after confirmation.',
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel')),
          FilledButton.icon(
            onPressed: () => Navigator.pop(context, true),
            icon: const Icon(Icons.location_on_outlined),
            label: const Text('Share location'),
          ),
        ],
      ),
    );
    if (accepted != true) return;
    setState(() {
      currentMessages.add(_Message(
        sender: 'You',
        text: 'Operational location shared with authorized channel members.',
        time: TimeOfDay.now().format(context),
        mine: true,
        status: 'Sent',
        locationLabel: 'Location card • permission required in production',
        incidentId: currentConversation.linkedIncident,
      ));
    });
  }

  Future<void> _attachmentMenu() async {
    final choice = await showModalBottomSheet<String>(
      context: context,
      showDragHandle: true,
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Align(
                alignment: Alignment.centerLeft,
                child: Text('Attach to message',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
              ),
              const SizedBox(height: 10),
              _AttachmentOption(Icons.description_outlined, 'Document',
                  () => Navigator.pop(context, 'Document')),
              _AttachmentOption(Icons.photo_outlined, 'Photo / image',
                  () => Navigator.pop(context, 'Photo')),
              _AttachmentOption(Icons.mic_none_rounded, 'Audio file',
                  () => Navigator.pop(context, 'Audio')),
              _AttachmentOption(Icons.location_on_outlined, 'Location',
                  () => Navigator.pop(context, 'Location')),
            ],
          ),
        ),
      ),
    );
    if (choice == null) return;
    if (choice == 'Location') {
      await _shareLocation();
    } else {
      _showSnack('$choice attachment selected — native picker connects in production');
    }
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
                  height: 720,
                  child: Row(
                    children: [
                      SizedBox(width: 320, child: _conversationList()),
                      const SizedBox(width: 14),
                      Expanded(child: _chatPanel()),
                      const SizedBox(width: 14),
                      SizedBox(width: 300, child: _contextPanel()),
                    ],
                  ),
                )
              else ...[
                SizedBox(height: 500, child: _conversationList()),
                const SizedBox(height: 14),
                SizedBox(height: 650, child: _chatPanel()),
                const SizedBox(height: 14),
                SizedBox(height: 620, child: _contextPanel()),
              ],
            ],
          );
        },
      );

  Widget _conversationList() {
    final items = visibleConversations;
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
                  onPressed: _newConversation,
                  icon: const Icon(Icons.edit_square),
                ),
              ],
            ),
          ),
          TextField(
            controller: searchController,
            onChanged: (value) => setState(() => searchQuery = value),
            decoration: InputDecoration(
              hintText: 'Search conversations',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: searchQuery.isEmpty
                  ? null
                  : IconButton(
                      onPressed: () {
                        searchController.clear();
                        setState(() => searchQuery = '');
                      },
                      icon: const Icon(Icons.close_rounded),
                    ),
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
            children: ['All', 'Unread', 'Groups', 'Incidents', 'Direct']
                .map((label) => ChoiceChip(
                      label: Text(label),
                      selected: activeFilter == label,
                      onSelected: (_) => setState(() => activeFilter = label),
                      selectedColor: pdpGreen.withValues(alpha: .12),
                      side: BorderSide(
                          color: activeFilter == label
                              ? pdpGreen
                              : const Color(0xFFDCE5DE)),
                    ))
                .toList(),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: items.isEmpty
                ? const Center(
                    child: Text('No conversations match this filter.',
                        style: TextStyle(color: muted)))
                : ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (context, listIndex) {
                      final entry = items[listIndex];
                      final index = entry.key;
                      final item = entry.value;
                      final active = selectedConversation == index;
                      return ListTile(
                        selected: active,
                        selectedTileColor: const Color(0xFFE8F4EB),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14)),
                        onTap: () => _selectConversation(index),
                        leading: CircleAvatar(
                          backgroundColor: active
                              ? pdpGreen.withValues(alpha: .12)
                              : const Color(0xFFF0F3F0),
                          child: Icon(
                            item.type == _ConversationType.incident
                                ? Icons.warning_amber_rounded
                                : item.type == _ConversationType.direct
                                    ? Icons.person_outline_rounded
                                    : Icons.groups_2,
                            color: item.type == _ConversationType.incident
                                ? pdpRed
                                : pdpGreen,
                          ),
                        ),
                        title: Text(item.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style:
                                const TextStyle(fontWeight: FontWeight.w900)),
                        subtitle: Text(item.preview,
                            maxLines: 1, overflow: TextOverflow.ellipsis),
                        trailing: item.unread == 0
                            ? null
                            : CircleAvatar(
                                radius: 11,
                                backgroundColor: pdpGreen,
                                child: Text('${item.unread}',
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

  Widget _chatPanel() {
    final channel = currentConversation;
    return SectionCard(
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
                CircleAvatar(
                  backgroundColor: channel.type == _ConversationType.incident
                      ? const Color(0xFFFFECEE)
                      : const Color(0xFFE7F3E9),
                  child: Icon(
                    channel.type == _ConversationType.incident
                        ? Icons.warning_amber_rounded
                        : channel.type == _ConversationType.direct
                            ? Icons.person_outline_rounded
                            : Icons.groups_2,
                    color: channel.type == _ConversationType.incident
                        ? pdpRed
                        : pdpGreen,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(channel.title,
                          style: const TextStyle(
                              fontSize: 17, fontWeight: FontWeight.w900)),
                      Text('${channel.members} authorized members • ${channel.scope}',
                          style:
                              const TextStyle(color: muted, fontSize: 12)),
                    ],
                  ),
                ),
                IconButton(
                    tooltip: 'Voice call entry point',
                    onPressed: () => _showSnack(
                        'Voice calling will open an authorized secure session'),
                    icon: const Icon(Icons.call_outlined)),
                IconButton(
                    tooltip: 'Video meeting entry point',
                    onPressed: () => _showSnack(
                        'Video meeting will require explicit participant consent'),
                    icon: const Icon(Icons.videocam_outlined)),
                PopupMenuButton<String>(
                  tooltip: 'Channel options',
                  onSelected: (value) {
                    if (value == 'incident') _linkIncident();
                    if (value == 'task') _createTask();
                    if (value == 'broadcast') _composeBroadcast();
                  },
                  itemBuilder: (_) => const [
                    PopupMenuItem(
                        value: 'incident', child: Text('Link incident')),
                    PopupMenuItem(value: 'task', child: Text('Create task')),
                    PopupMenuItem(
                        value: 'broadcast', child: Text('Send broadcast')),
                  ],
                ),
              ],
            ),
          ),
          if (channel.linkedIncident != null)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 9),
              color: const Color(0xFFFFF3E8),
              child: Row(
                children: [
                  const Icon(Icons.link_rounded,
                      size: 17, color: Color(0xFF9A5A00)),
                  const SizedBox(width: 8),
                  Text('Linked incident: ${channel.linkedIncident}',
                      style: const TextStyle(
                          color: Color(0xFF7A4800),
                          fontWeight: FontWeight.w800)),
                ],
              ),
            ),
          Expanded(
            child: currentMessages.isEmpty
                ? const Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.chat_bubble_outline_rounded,
                            size: 42, color: muted),
                        SizedBox(height: 10),
                        Text('No messages yet',
                            style: TextStyle(fontWeight: FontWeight.w900)),
                        Text('Start this operational conversation.',
                            style: TextStyle(color: muted)),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(18),
                    itemCount: currentMessages.length,
                    itemBuilder: (context, index) {
                      final m = currentMessages[index];
                      return _MessageBubble(message: m);
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
                    onPressed: _attachmentMenu,
                    icon: const Icon(Icons.attach_file)),
                IconButton(
                    tooltip: 'Share location',
                    onPressed: _shareLocation,
                    icon: const Icon(Icons.location_on_outlined)),
                Expanded(
                  child: TextField(
                    controller: composer,
                    minLines: 1,
                    maxLines: 4,
                    onSubmitted: (_) => _send(),
                    decoration: InputDecoration(
                      hintText: 'Message ${channel.title}',
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
  }

  Widget _contextPanel() {
    final channel = currentConversation;
    return SectionCard(
      child: ListView(
        children: [
          const Text('Channel controls',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
          const SizedBox(height: 8),
          Text(channel.title,
              style: const TextStyle(fontWeight: FontWeight.w900)),
          Text(channel.scope, style: const TextStyle(color: muted)),
          const SizedBox(height: 12),
          _ActionTile(Icons.campaign_outlined, 'Broadcast message',
              'Send an authorized notice to selected operational groups.',
              onTap: _composeBroadcast),
          _ActionTile(Icons.warning_amber_rounded, 'Link incident',
              channel.linkedIncident == null
                  ? 'Attach this conversation to an incident or escalation record.'
                  : 'Currently linked to ${channel.linkedIncident}.',
              onTap: _linkIncident),
          _ActionTile(Icons.assignment_outlined, 'Create task',
              'Convert this conversation into an assigned operational action.',
              onTap: _createTask),
          _ActionTile(Icons.location_on_outlined, 'Share location',
              'Explicitly share operational location with authorized members.',
              onTap: _shareLocation),
          _ActionTile(Icons.folder_outlined, 'Shared files',
              'Photos, documents, audio and campaign materials in this channel.',
              onTap: () => _showSnack('Shared-files repository opens here')),
          const Divider(height: 30),
          const Text('Operational integrations',
              style: TextStyle(fontWeight: FontWeight.w900)),
          const SizedBox(height: 10),
          const _IntegrationRow(
              Icons.warning_amber_rounded, 'Situation Room incidents'),
          const _IntegrationRow(Icons.task_alt_rounded, 'Task management'),
          const _IntegrationRow(Icons.inventory_2_outlined, 'Logistics records'),
          const _IntegrationRow(Icons.feed_outlined, 'Field reports'),
          const _IntegrationRow(Icons.description_outlined, 'Documents'),
          const Divider(height: 30),
          const Text('Communication policy',
              style: TextStyle(fontWeight: FontWeight.w900)),
          const SizedBox(height: 8),
          const Text(
            'Messaging is for internal campaign operations. Access is role-based, critical actions are auditable, location sharing is explicit, and no hidden camera or microphone activation is permitted.',
            style: TextStyle(color: muted, height: 1.45),
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: const [
              StatusPill('ROLE-BASED ACCESS'),
              StatusPill('AUDITABLE', color: Color(0xFF6555B8)),
            ],
          ),
        ],
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  const _MessageBubble({required this.message});
  final _Message message;

  @override
  Widget build(BuildContext context) => Align(
        alignment: message.mine ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          constraints: const BoxConstraints(maxWidth: 520),
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(13),
          decoration: BoxDecoration(
            color: message.mine
                ? const Color(0xFFDFF2E4)
                : const Color(0xFFF2F5F2),
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(16),
              topRight: const Radius.circular(16),
              bottomLeft: Radius.circular(message.mine ? 16 : 4),
              bottomRight: Radius.circular(message.mine ? 4 : 16),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!message.mine)
                Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Text(message.sender,
                      style: const TextStyle(
                          color: pdpGreenDark,
                          fontWeight: FontWeight.w900,
                          fontSize: 12)),
                ),
              Text(message.text,
                  style: const TextStyle(color: ink, height: 1.35)),
              if (message.attachmentLabel != null) ...[
                const SizedBox(height: 9),
                _InlineCard(
                  icon: Icons.description_outlined,
                  label: message.attachmentLabel!,
                ),
              ],
              if (message.locationLabel != null) ...[
                const SizedBox(height: 9),
                _InlineCard(
                  icon: Icons.location_on_outlined,
                  label: message.locationLabel!,
                ),
              ],
              if (message.incidentId != null) ...[
                const SizedBox(height: 7),
                Text('Linked: ${message.incidentId}',
                    style: const TextStyle(
                        color: Color(0xFF9A5A00),
                        fontSize: 11,
                        fontWeight: FontWeight.w800)),
              ],
              const SizedBox(height: 6),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(message.time,
                      style: const TextStyle(color: muted, fontSize: 10)),
                  const SizedBox(width: 8),
                  Text(message.status,
                      style: const TextStyle(color: muted, fontSize: 10)),
                ],
              )
            ],
          ),
        ),
      );
}

class _InlineCard extends StatelessWidget {
  const _InlineCard({required this.icon, required this.label});
  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(9),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: .72),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: const Color(0xFFDCE5DE)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 17, color: pdpGreen),
            const SizedBox(width: 7),
            Flexible(
              child: Text(label,
                  style: const TextStyle(
                      fontWeight: FontWeight.w800, fontSize: 12)),
            ),
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
                'Prototype communication layer: direct messages, team channels, broadcasts, attachments, incident threads, tasks, delivery/read state and secure-call entry points. Production encryption and calling require audited backend/native services.',
                style: TextStyle(fontWeight: FontWeight.w600, color: ink),
              ),
            ),
          ],
        ),
      );
}

enum _ConversationType { group, incident, direct }

class _Conversation {
  const _Conversation({
    required this.title,
    required this.preview,
    required this.unread,
    required this.type,
    required this.members,
    required this.scope,
    this.linkedIncident,
  });

  final String title;
  final String preview;
  final int unread;
  final _ConversationType type;
  final int members;
  final String scope;
  final String? linkedIncident;

  _Conversation copyWith({int? unread, String? linkedIncident}) => _Conversation(
        title: title,
        preview: preview,
        unread: unread ?? this.unread,
        type: type,
        members: members,
        scope: scope,
        linkedIncident: linkedIncident ?? this.linkedIncident,
      );
}

class _Message {
  const _Message({
    required this.sender,
    required this.text,
    required this.time,
    required this.mine,
    required this.status,
    this.attachmentLabel,
    this.locationLabel,
    this.incidentId,
  });

  final String sender;
  final String text;
  final String time;
  final bool mine;
  final String status;
  final String? attachmentLabel;
  final String? locationLabel;
  final String? incidentId;
}

class _ActionTile extends StatelessWidget {
  const _ActionTile(this.icon, this.title, this.detail, {required this.onTap});
  final IconData icon;
  final String title;
  final String detail;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => ListTile(
        contentPadding: EdgeInsets.zero,
        leading: CircleAvatar(
          backgroundColor: const Color(0xFFEAF4ED),
          child: Icon(icon, color: pdpGreen),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w800)),
        subtitle: Text(detail),
        onTap: onTap,
      );
}

class _IntegrationRow extends StatelessWidget {
  const _IntegrationRow(this.icon, this.label);
  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          children: [
            Icon(icon, size: 18, color: pdpGreen),
            const SizedBox(width: 9),
            Expanded(
              child: Text(label,
                  style: const TextStyle(fontWeight: FontWeight.w700)),
            ),
          ],
        ),
      );
}

class _AttachmentOption extends StatelessWidget {
  const _AttachmentOption(this.icon, this.label, this.onTap);
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => ListTile(
        leading: CircleAvatar(
          backgroundColor: const Color(0xFFEAF4ED),
          child: Icon(icon, color: pdpGreen),
        ),
        title: Text(label, style: const TextStyle(fontWeight: FontWeight.w800)),
        onTap: onTap,
      );
}
