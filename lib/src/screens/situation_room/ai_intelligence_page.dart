part of 'situation_room_page.dart';

class _AiIntelligencePage extends StatelessWidget {
  const _AiIntelligencePage();

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Color(0xFF101D32),
                  Color(0xFF173B66),
                  Color(0xFF215B82)
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(22),
              boxShadow: const [
                BoxShadow(
                    color: Color(0x33101D32),
                    blurRadius: 30,
                    offset: Offset(0, 12))
              ],
            ),
            child: Row(children: [
              Container(
                width: 58,
                height: 58,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                      colors: [Color(0xFF6CE5E8), Color(0xFF6695FF)]),
                  borderRadius: BorderRadius.circular(17),
                ),
                child: const Icon(Icons.psychology_alt_rounded,
                    color: Colors.white, size: 31),
              ),
              const SizedBox(width: 17),
              const Expanded(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                    Row(children: [
                      Text('Poli AI Intelligence',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.w900)),
                      SizedBox(width: 10),
                      StatusPill('LIVE',
                          color: Color(0xFF58D6B1), icon: Icons.circle)
                    ]),
                    SizedBox(height: 6),
                    Text(
                        'Continuously organizing authorized operational signals for human review.',
                        style: TextStyle(color: Colors.white70)),
                  ])),
              const _AiHealth('24', 'signals/min'),
              const SizedBox(width: 22),
              const _AiHealth('7', 'models active'),
              const SizedBox(width: 22),
              const _AiHealth('98.2%', 'pipeline health'),
            ]),
          ),
          const SizedBox(height: 18),
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Expanded(
                flex: 7,
                child: Column(children: [
                  _Panel(
                    title: 'AI workstream',
                    subtitle:
                        'Visible processing activity • outputs remain advisory',
                    trailing: const StatusPill('HUMAN REVIEW ON',
                        color: AppColors.green,
                        icon: Icons.verified_user_outlined),
                    child: const Column(children: [
                      _AiWorkItem(
                          Icons.graphic_eq_rounded,
                          Color(0xFF7657C8),
                          'Acoustic event analysis',
                          'Analyzing 3 authorized call streams',
                          .72,
                          'Running',
                          'Model acoustic-v4.2'),
                      Divider(height: 1),
                      _AiWorkItem(
                          Icons.hub_outlined,
                          AppColors.blue,
                          'Report correlation',
                          'Comparing 18 new submissions across 4 wards',
                          .88,
                          'Clustering',
                          'Model semantic-v3.8'),
                      Divider(height: 1),
                      _AiWorkItem(
                          Icons.public_rounded,
                          AppColors.cyan,
                          'Public signal monitoring',
                          'Scanning approved public sources for emerging topics',
                          .54,
                          'Monitoring',
                          'Aggregate sources only'),
                      Divider(height: 1),
                      _AiWorkItem(
                          Icons.summarize_outlined,
                          AppColors.green,
                          'Daily brief synthesis',
                          'Drafting the 18:00 command brief',
                          .36,
                          'Drafting',
                          '12 cited records'),
                    ]),
                  ),
                  const SizedBox(height: 16),
                  const _AiFindingCard(),
                ])),
            const SizedBox(width: 16),
            Expanded(
                flex: 4,
                child: Column(children: [
                  _Panel(
                    title: 'Review queue',
                    subtitle: 'AI findings awaiting an authorized decision',
                    trailing: const _CountBadge('6'),
                    child: const Column(children: [
                      _AiReview(
                          'HIGH',
                          AppColors.red,
                          'Possible crowd escalation',
                          '3 reports • Kwarbai \'A\'',
                          '87%'),
                      Divider(height: 1),
                      _AiReview(
                          'MEDIUM',
                          AppColors.amber,
                          'Conflicting access reports',
                          '2 sources • Tudun Wada',
                          '74%'),
                      Divider(height: 1),
                      _AiReview(
                          'LOW',
                          AppColors.blue,
                          'Repeated network degradation',
                          '5 agents • Gyallesu',
                          '69%'),
                    ]),
                  ),
                  const SizedBox(height: 16),
                  _Panel(
                    title: 'Model governance',
                    subtitle: 'Traceable, reviewable and bounded',
                    child: const Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(children: [
                        _GovernanceRow(Icons.person_search_outlined,
                            'Human decision required', 'Enabled'),
                        SizedBox(height: 12),
                        _GovernanceRow(Icons.source_outlined,
                            'Source citations', 'Required'),
                        SizedBox(height: 12),
                        _GovernanceRow(Icons.history_rounded,
                            'Model/version logging', 'Active'),
                        SizedBox(height: 12),
                        _GovernanceRow(Icons.lock_outline_rounded,
                            'Sensitive profiling', 'Blocked'),
                      ]),
                    ),
                  ),
                ])),
          ]),
        ]),
      );
}

class _AiHealth extends StatelessWidget {
  const _AiHealth(this.value, this.label);
  final String value, label;
  @override
  Widget build(BuildContext context) =>
      Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
        Text(value,
            style: const TextStyle(
                color: Colors.white,
                fontSize: 21,
                fontWeight: FontWeight.w900)),
        Text(label,
            style: const TextStyle(
                color: Colors.white60,
                fontSize: 9,
                fontWeight: FontWeight.w700)),
      ]);
}

class _AiWorkItem extends StatelessWidget {
  const _AiWorkItem(this.icon, this.color, this.title, this.detail,
      this.progress, this.state, this.meta);
  final IconData icon;
  final Color color;
  final String title, detail, state, meta;
  final double progress;
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.all(15),
        child: Row(children: [
          Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                  color: color.withValues(alpha: .1),
                  borderRadius: BorderRadius.circular(12)),
              child: Icon(icon, color: color, size: 20)),
          const SizedBox(width: 12),
          Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                Row(children: [
                  Expanded(
                      child: Text(title,
                          style: const TextStyle(
                              color: AppColors.navy,
                              fontWeight: FontWeight.w800,
                              fontSize: 12))),
                  StatusPill(state.toUpperCase(), color: color)
                ]),
                const SizedBox(height: 4),
                Text(detail, style: const TextStyle(fontSize: 10)),
                const SizedBox(height: 9),
                ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: LinearProgressIndicator(
                        value: progress,
                        minHeight: 4,
                        color: color,
                        backgroundColor: color.withValues(alpha: .1))),
                const SizedBox(height: 5),
                Text(meta,
                    style: const TextStyle(
                        color: AppColors.muted,
                        fontSize: 8,
                        fontWeight: FontWeight.w700)),
              ])),
        ]),
      );
}

class _AiFindingCard extends StatelessWidget {
  const _AiFindingCard();
  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xFFF0F5FF),
          border: Border.all(color: const Color(0xFFCCDAF7)),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Row(children: [
            Icon(Icons.auto_awesome_rounded, color: AppColors.blue, size: 19),
            SizedBox(width: 8),
            Expanded(
                child: Text('Latest AI-assisted finding',
                    style: TextStyle(
                        color: AppColors.navy, fontWeight: FontWeight.w900))),
            StatusPill('UNVERIFIED', color: AppColors.amber)
          ]),
          const SizedBox(height: 13),
          const Text(
              'Three independent submissions near Polling Unit 014 describe a similar access disruption within an 11-minute window.',
              style: TextStyle(
                  color: AppColors.navy,
                  fontSize: 14,
                  height: 1.45,
                  fontWeight: FontWeight.w700)),
          const SizedBox(height: 13),
          const Wrap(spacing: 8, runSpacing: 8, children: [
            StatusPill('87% similarity', color: AppColors.blue),
            StatusPill('3 sources', color: AppColors.green),
            StatusPill('±420 m', color: Color(0xFF7657C8))
          ]),
          const SizedBox(height: 14),
          Row(children: [
            OutlinedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.source_outlined, size: 16),
                label: const Text('Inspect sources')),
            const SizedBox(width: 8),
            FilledButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.fact_check_outlined, size: 16),
                label: const Text('Send to verification'))
          ]),
        ]),
      );
}

class _AiReview extends StatelessWidget {
  const _AiReview(
      this.level, this.color, this.title, this.detail, this.confidence);
  final String level, title, detail, confidence;
  final Color color;
  @override
  Widget build(BuildContext context) => ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
        leading: Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
                color: color.withValues(alpha: .1),
                borderRadius: BorderRadius.circular(10)),
            child: Icon(Icons.auto_awesome_rounded, color: color, size: 17)),
        title: Text(title,
            style: const TextStyle(
                color: AppColors.navy,
                fontSize: 11,
                fontWeight: FontWeight.w800)),
        subtitle: Text(detail, style: const TextStyle(fontSize: 9)),
        trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(confidence,
                  style: TextStyle(color: color, fontWeight: FontWeight.w900)),
              Text(level,
                  style: const TextStyle(
                      color: AppColors.muted,
                      fontSize: 8,
                      fontWeight: FontWeight.w800))
            ]),
      );
}

class _GovernanceRow extends StatelessWidget {
  const _GovernanceRow(this.icon, this.label, this.state);
  final IconData icon;
  final String label, state;
  @override
  Widget build(BuildContext context) => Row(children: [
        Icon(icon, color: AppColors.blue, size: 18),
        const SizedBox(width: 9),
        Expanded(
            child: Text(label,
                style: const TextStyle(
                    color: AppColors.navy,
                    fontSize: 10,
                    fontWeight: FontWeight.w700))),
        Text(state,
            style: const TextStyle(
                color: AppColors.green,
                fontSize: 9,
                fontWeight: FontWeight.w900))
      ]);
}

class _ChatMessage {
  const _ChatMessage(this.text, {required this.ai, this.meta});
  final String text;
  final bool ai;
  final String? meta;
}

class _OperatorChat extends StatefulWidget {
  const _OperatorChat({required this.onClose});
  final VoidCallback onClose;
  @override
  State<_OperatorChat> createState() => _OperatorChatState();
}

class _OperatorChatState extends State<_OperatorChat> {
  final _controller = TextEditingController();
  final _messages = <_ChatMessage>[
    const _ChatMessage(
        'I can summarize incidents, compare reports, surface source conflicts, and draft command updates. My answers are advisory and cite the operational records used.',
        ai: true,
        meta: 'Poli AI • source-aware mode'),
  ];
  bool _thinking = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _send([String? prompt]) {
    final text = (prompt ?? _controller.text).trim();
    if (text.isEmpty || _thinking) return;
    setState(() {
      _messages.add(_ChatMessage(text, ai: false));
      _controller.clear();
      _thinking = true;
    });
    Future<void>.delayed(const Duration(milliseconds: 650), () {
      if (!mounted) return;
      setState(() {
        _thinking = false;
        _messages.add(const _ChatMessage(
            'Current priority: INC-00518 in Kwarbai \'A\'. Three related reports describe an access disruption; one is verified and two remain under review. I recommend opening the source comparison before escalation.',
            ai: true,
            meta: 'Based on INC-00518 + 3 linked reports • generated now'));
      });
    });
  }

  @override
  Widget build(BuildContext context) => Material(
        elevation: 24,
        color: Colors.white,
        child: Column(children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
                gradient: LinearGradient(
                    colors: [AppColors.navy, Color(0xFF244E76)])),
            child: Row(children: [
              Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                      gradient: const LinearGradient(
                          colors: [AppColors.blue, AppColors.cyan]),
                      borderRadius: BorderRadius.circular(11)),
                  child: const Icon(Icons.auto_awesome_rounded,
                      color: Colors.white, size: 20)),
              const SizedBox(width: 10),
              const Expanded(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                    Text('Poli AI Copilot',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w900)),
                    Text('Operational intelligence assistant',
                        style: TextStyle(color: Colors.white60, fontSize: 9))
                  ])),
              const StatusPill('ONLINE',
                  color: Color(0xFF58D6B1), icon: Icons.circle),
              IconButton(
                  onPressed: widget.onClose,
                  icon: const Icon(Icons.close_rounded, color: Colors.white70)),
            ]),
          ),
          Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 9),
              color: const Color(0xFFFFF8E8),
              child: const Row(children: [
                Icon(Icons.verified_user_outlined,
                    color: AppColors.amber, size: 15),
                SizedBox(width: 7),
                Expanded(
                    child: Text(
                        'AI output may be incomplete. Verify sources before operational action.',
                        style: TextStyle(
                            color: AppColors.navy,
                            fontSize: 9,
                            fontWeight: FontWeight.w700)))
              ])),
          Expanded(
              child: ListView.builder(
            padding: const EdgeInsets.all(14),
            itemCount: _messages.length + (_thinking ? 1 : 0),
            itemBuilder: (_, i) {
              if (i == _messages.length) return const _ThinkingBubble();
              final message = _messages[i];
              return Align(
                alignment:
                    message.ai ? Alignment.centerLeft : Alignment.centerRight,
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 310),
                  margin: const EdgeInsets.only(bottom: 11),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                      color:
                          message.ai ? const Color(0xFFF1F5FA) : AppColors.blue,
                      borderRadius: BorderRadius.only(
                          topLeft: const Radius.circular(15),
                          topRight: const Radius.circular(15),
                          bottomRight: Radius.circular(message.ai ? 15 : 3),
                          bottomLeft: Radius.circular(message.ai ? 3 : 15))),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (message.ai) ...[
                          const Row(children: [
                            Icon(Icons.auto_awesome_rounded,
                                color: AppColors.blue, size: 13),
                            SizedBox(width: 5),
                            Text('POLI AI',
                                style: TextStyle(
                                    color: AppColors.blue,
                                    fontSize: 8,
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: .6))
                          ]),
                          const SizedBox(height: 7)
                        ],
                        Text(message.text,
                            style: TextStyle(
                                color:
                                    message.ai ? AppColors.navy : Colors.white,
                                fontSize: 11,
                                height: 1.45)),
                        if (message.meta != null) ...[
                          const SizedBox(height: 8),
                          Text(message.meta!,
                              style: const TextStyle(
                                  color: AppColors.muted,
                                  fontSize: 8,
                                  fontWeight: FontWeight.w700))
                        ],
                      ]),
                ),
              );
            },
          )),
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(children: [
                    _PromptChip('What needs attention?',
                        () => _send('What needs attention?')),
                    _PromptChip('Summarize INC-00518',
                        () => _send('Summarize INC-00518')),
                    _PromptChip('Find conflicting reports',
                        () => _send('Find conflicting reports')),
                  ]))),
          Padding(
            padding: const EdgeInsets.all(14),
            child: TextField(
              controller: _controller,
              onSubmitted: (_) => _send(),
              decoration: InputDecoration(
                  hintText: 'Ask about incidents, reports or agents…',
                  suffixIcon: IconButton(
                      onPressed: _send,
                      icon: const Icon(Icons.arrow_upward_rounded)),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 12)),
            ),
          ),
        ]),
      );
}

class _PromptChip extends StatelessWidget {
  const _PromptChip(this.label, this.onTap);
  final String label;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => Padding(
      padding: const EdgeInsets.only(right: 6),
      child: ActionChip(
          label: Text(label, style: const TextStyle(fontSize: 9)),
          onPressed: onTap,
          side: const BorderSide(color: AppColors.border),
          backgroundColor: Colors.white));
}

class _ThinkingBubble extends StatelessWidget {
  const _ThinkingBubble();
  @override
  Widget build(BuildContext context) => const Align(
      alignment: Alignment.centerLeft,
      child: Padding(
          padding: EdgeInsets.only(bottom: 11),
          child: StatusPill('ANALYZING SOURCES…',
              color: AppColors.blue, icon: Icons.auto_awesome_rounded)));
}
