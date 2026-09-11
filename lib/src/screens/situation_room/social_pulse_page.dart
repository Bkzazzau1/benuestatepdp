part of 'situation_room_page.dart';

class _SocialTopic {
  const _SocialTopic(this.name, this.volume, this.change, this.sources,
      this.risk, this.color, this.icon);
  final String name, volume, change, sources, risk;
  final Color color;
  final IconData icon;
}

class _SocialPulsePage extends StatefulWidget {
  const _SocialPulsePage();
  @override
  State<_SocialPulsePage> createState() => _SocialPulsePageState();
}

class _SocialPulsePageState extends State<_SocialPulsePage> {
  int _selected = 0;
  String _range = 'Last 6 hours';
  String _scope = 'All wards';
  bool _reviewedOnly = false;

  static const _topics = <_SocialTopic>[
    _SocialTopic(
        'Polling-unit access',
        '1,284 mentions',
        '+42%',
        '186 public sources',
        'Elevated',
        AppColors.red,
        Icons.door_front_door_outlined),
    _SocialTopic(
        'Materials availability',
        '846 mentions',
        '+18%',
        '121 public sources',
        'Watch',
        AppColors.amber,
        Icons.inventory_2_outlined),
    _SocialTopic('Queue wait times', '692 mentions', '+11%',
        '94 public sources', 'Normal', AppColors.blue, Icons.groups_2_outlined),
    _SocialTopic(
        'Network connectivity',
        '411 mentions',
        '+27%',
        '67 public sources',
        'Watch',
        Color(0xFF7657C8),
        Icons.signal_wifi_statusbar_connected_no_internet_4_rounded),
    _SocialTopic(
        'Accessibility support',
        '238 mentions',
        '+6%',
        '39 public sources',
        'Normal',
        AppColors.green,
        Icons.accessible_forward_outlined),
  ];

  @override
  Widget build(BuildContext context) {
    final topic = _topics[_selected];
    return Column(children: [
      _SocialHeader(
          range: _range,
          scope: _scope,
          onRange: (v) => setState(() => _range = v!),
          onScope: (v) => setState(() => _scope = v!)),
      const _SocialMetrics(),
      Expanded(
          child: SingleChildScrollView(
              padding: const EdgeInsets.all(18),
              child: Column(children: [
                Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Expanded(
                      flex: 7,
                      child: Column(children: [
                        _TrendOverview(
                            topics: _topics,
                            selected: _selected,
                            onSelected: (i) => setState(() => _selected = i)),
                        const SizedBox(height: 14),
                        _TopicDetail(topic: topic),
                      ])),
                  const SizedBox(width: 14),
                  Expanded(
                      flex: 4,
                      child: Column(children: [
                        _InformationRisk(
                            reviewedOnly: _reviewedOnly,
                            onChanged: (v) =>
                                setState(() => _reviewedOnly = v)),
                        const SizedBox(height: 14),
                        const _PublicSourceFeed(),
                      ])),
                ]),
                const SizedBox(height: 14),
                const Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: _AiClusteringPanel()),
                      SizedBox(width: 14),
                      Expanded(child: _BriefComposer()),
                    ]),
              ]))),
    ]);
  }
}

class _SocialHeader extends StatelessWidget {
  const _SocialHeader(
      {required this.range,
      required this.scope,
      required this.onRange,
      required this.onScope});
  final String range, scope;
  final ValueChanged<String?> onRange, onScope;
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
                    colors: [Color(0xFF7657C8), AppColors.cyan]),
                borderRadius: BorderRadius.circular(14),
                boxShadow: const [
                  BoxShadow(
                      color: Color(0x337657C8),
                      blurRadius: 16,
                      offset: Offset(0, 6))
                ]),
            child:
                const Icon(Icons.monitor_heart_rounded, color: Colors.white)),
        const SizedBox(width: 13),
        Expanded(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Social Pulse',
              style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 3),
          const Text(
              'Aggregate public-information trends, emerging issues and source-aware AI analysis',
              overflow: TextOverflow.ellipsis)
        ])),
        _FilterDropdown(
            scope,
            [
              'All wards',
              ...ZariaConstituency.wards.map((w) => w.name),
            ],
            Icons.location_on_outlined,
            onScope),
        const SizedBox(width: 8),
        _FilterDropdown(
            range,
            const ['Last hour', 'Last 6 hours', 'Today', 'Last 7 days'],
            Icons.schedule_rounded,
            onRange),
      ]));
}

class _SocialMetrics extends StatelessWidget {
  const _SocialMetrics();
  @override
  Widget build(BuildContext context) => Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
      child: const Row(children: [
        Expanded(
            child: _EvidenceMetric(Icons.forum_outlined, AppColors.blue,
                '4,862', 'Public mentions', '+21% vs prior')),
        SizedBox(width: 10),
        Expanded(
            child: _EvidenceMetric(Icons.hub_outlined, Color(0xFF7657C8), '18',
                'Topic clusters', '5 emerging')),
        SizedBox(width: 10),
        Expanded(
            child: _EvidenceMetric(Icons.source_outlined, AppColors.green,
                '427', 'Public sources', '93% traceable')),
        SizedBox(width: 10),
        Expanded(
            child: _EvidenceMetric(Icons.gpp_maybe_outlined, AppColors.red, '4',
                'Information risks', '2 need review')),
        SizedBox(width: 10),
        Expanded(
            child: _EvidenceMetric(Icons.auto_awesome_outlined, AppColors.cyan,
                '12m', 'AI refresh', 'Models healthy')),
      ]));
}

class _TrendOverview extends StatelessWidget {
  const _TrendOverview(
      {required this.topics, required this.selected, required this.onSelected});
  final List<_SocialTopic> topics;
  final int selected;
  final ValueChanged<int> onSelected;
  @override
  Widget build(BuildContext context) => _Panel(
      title: 'Emerging public topics',
      subtitle: 'Aggregate volume and velocity • no individual profiles',
      trailing: TextButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.tune_rounded, size: 15),
          label: const Text('Configure')),
      child: Column(children: [
        Container(
            height: 160,
            padding: const EdgeInsets.fromLTRB(18, 20, 18, 12),
            color: const Color(0xFFFAFBFD),
            child: CustomPaint(
                painter: _TrendPainter(), child: const SizedBox.expand())),
        const Divider(height: 1),
        ...List.generate(topics.length, (i) {
          final topic = topics[i];
          final active = i == selected;
          return InkWell(
              onTap: () => onSelected(i),
              child: Container(
                  color: active
                      ? topic.color.withValues(alpha: .06)
                      : Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 11),
                  child: Row(children: [
                    Container(
                        width: 34,
                        height: 34,
                        decoration: BoxDecoration(
                            color: topic.color.withValues(alpha: .1),
                            borderRadius: BorderRadius.circular(10)),
                        child: Icon(topic.icon, color: topic.color, size: 17)),
                    const SizedBox(width: 10),
                    Expanded(
                        child: Text(topic.name,
                            style: const TextStyle(
                                color: AppColors.navy,
                                fontSize: 11,
                                fontWeight: FontWeight.w800))),
                    SizedBox(
                        width: 105,
                        child: Text(topic.volume,
                            style: const TextStyle(
                                color: AppColors.navy,
                                fontSize: 9,
                                fontWeight: FontWeight.w700))),
                    SizedBox(
                        width: 58,
                        child: Text(topic.change,
                            style: TextStyle(
                                color: topic.color,
                                fontSize: 10,
                                fontWeight: FontWeight.w900))),
                    SizedBox(
                        width: 120,
                        child: Text(topic.sources,
                            style: const TextStyle(fontSize: 9))),
                    StatusPill(topic.risk.toUpperCase(), color: topic.color),
                    const SizedBox(width: 5),
                    Icon(Icons.chevron_right_rounded,
                        color: active ? topic.color : AppColors.muted,
                        size: 18),
                  ])));
        }),
      ]));
}

class _TrendPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final grid = Paint()
      ..color = const Color(0xFFE7EBF0)
      ..strokeWidth = 1;
    for (var i = 1; i < 5; i++) {
      final y = size.height * i / 5;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), grid);
    }
    final colors = [AppColors.red, AppColors.amber, AppColors.blue];
    final values = [
      [.8, .67, .71, .52, .46, .35, .28],
      [.9, .82, .78, .74, .66, .61, .55],
      [.72, .69, .64, .62, .58, .53, .49]
    ];
    for (var s = 0; s < values.length; s++) {
      final paint = Paint()
        ..color = colors[s]
        ..strokeWidth = 2.5
        ..style = PaintingStyle.stroke;
      final path = Path();
      for (var i = 0; i < values[s].length; i++) {
        final p = Offset(size.width * i / (values[s].length - 1),
            size.height * values[s][i]);
        i == 0 ? path.moveTo(p.dx, p.dy) : path.lineTo(p.dx, p.dy);
      }
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _TopicDetail extends StatelessWidget {
  const _TopicDetail({required this.topic});
  final _SocialTopic topic;
  @override
  Widget build(BuildContext context) => _Panel(
      title: topic.name,
      subtitle: 'Selected aggregate topic • updated 2 minutes ago',
      trailing: StatusPill(topic.risk.toUpperCase(), color: topic.color),
      child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  const Text('AI-ASSISTED SUMMARY',
                      style: TextStyle(
                          color: AppColors.muted,
                          fontSize: 8,
                          fontWeight: FontWeight.w900,
                          letterSpacing: .7)),
                  const SizedBox(height: 7),
                  const Text(
                      'Public discussion is increasing around delayed or restricted access at several polling-unit entrances. Most posts describe queue control and accreditation checks; a smaller cluster alleges complete closure and requires verification.',
                      style: TextStyle(
                          color: AppColors.navy, fontSize: 11, height: 1.5)),
                  const SizedBox(height: 10),
                  const Row(children: [
                    StatusPill('AI GENERATED',
                        color: AppColors.blue,
                        icon: Icons.auto_awesome_rounded),
                    SizedBox(width: 7),
                    StatusPill('HUMAN REVIEW PENDING', color: AppColors.amber)
                  ])
                ])),
            const SizedBox(width: 18),
            SizedBox(
                width: 245,
                child: Column(children: [
                  const _CompareRow('Source mix',
                      'News • public posts • civic groups', 'AGGREGATE'),
                  const _CompareRow(
                      'Geography', '6 wards above baseline', 'WARD LEVEL'),
                  const _CompareRow(
                      'Confidence', 'Cluster coherence 84%', 'ADVISORY'),
                  const SizedBox(height: 8),
                  SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.source_outlined, size: 16),
                          label: const Text('Inspect public sources')))
                ])),
          ])));
}

class _InformationRisk extends StatelessWidget {
  const _InformationRisk({required this.reviewedOnly, required this.onChanged});
  final bool reviewedOnly;
  final ValueChanged<bool> onChanged;
  @override
  Widget build(BuildContext context) => _Panel(
      title: 'Information-risk alerts',
      subtitle: 'Potentially misleading or rapidly spreading claims',
      trailing: Switch(value: reviewedOnly, onChanged: onChanged),
      child: const Column(children: [
        _RiskItem(
            AppColors.red,
            'HIGH',
            'False closure claim spreading',
            '83 public posts • 4 wards • 9m',
            'Unverified claim conflicts with 3 field reports'),
        Divider(height: 1),
        _RiskItem(
            AppColors.amber,
            'MEDIUM',
            'Outdated queue image recirculating',
            '41 public posts • Kwarbai \'A\' • 18m',
            'Image first appeared 3 hours earlier'),
        Divider(height: 1),
        _RiskItem(
            AppColors.blue,
            'WATCH',
            'Connectivity complaint cluster',
            '29 public posts • Gyallesu • 24m',
            'May align with active network incident'),
      ]));
}

class _RiskItem extends StatelessWidget {
  const _RiskItem(this.color, this.level, this.title, this.detail, this.reason);
  final Color color;
  final String level, title, detail, reason;
  @override
  Widget build(BuildContext context) => Padding(
      padding: const EdgeInsets.all(13),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          StatusPill(level, color: color),
          const SizedBox(width: 7),
          Expanded(
              child: Text(title,
                  style: const TextStyle(
                      color: AppColors.navy,
                      fontSize: 11,
                      fontWeight: FontWeight.w900))),
          const Icon(Icons.chevron_right_rounded,
              color: AppColors.muted, size: 17)
        ]),
        const SizedBox(height: 6),
        Text(detail, style: const TextStyle(fontSize: 8)),
        const SizedBox(height: 4),
        Text(reason,
            style: TextStyle(
                color: color, fontSize: 9, fontWeight: FontWeight.w700))
      ]));
}

class _PublicSourceFeed extends StatelessWidget {
  const _PublicSourceFeed();
  @override
  Widget build(BuildContext context) => _Panel(
      title: 'Public-source feed',
      subtitle: 'Every signal retains its public source',
      trailing: TextButton(onPressed: () {}, child: const Text('View all')),
      child: const Column(children: [
        _SourceItem(
            Icons.newspaper_rounded,
            AppColors.blue,
            'FCT Civic Monitor',
            'Queue management improves at several central units',
            'News • 4m • source verified'),
        Divider(height: 1),
        _SourceItem(
            Icons.public_rounded,
            Color(0xFF7657C8),
            'Public discussion cluster',
            'Repeated mentions of delayed accreditation checks',
            '37 public posts • 8m'),
        Divider(height: 1),
        _SourceItem(
            Icons.campaign_outlined,
            AppColors.amber,
            'Community observer bulletin',
            'Connectivity delays affecting status updates',
            'Public bulletin • 14m'),
      ]));
}

class _SourceItem extends StatelessWidget {
  const _SourceItem(this.icon, this.color, this.source, this.title, this.meta);
  final IconData icon;
  final Color color;
  final String source, title, meta;
  @override
  Widget build(BuildContext context) => ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 13, vertical: 5),
      leading: Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
              color: color.withValues(alpha: .1),
              borderRadius: BorderRadius.circular(9)),
          child: Icon(icon, color: color, size: 17)),
      title: Text(source,
          style: const TextStyle(
              color: AppColors.navy,
              fontSize: 10,
              fontWeight: FontWeight.w900)),
      subtitle: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const SizedBox(height: 3),
        Text(title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: AppColors.navy, fontSize: 9)),
        const SizedBox(height: 3),
        Text(meta, style: const TextStyle(fontSize: 8))
      ]),
      trailing: const Icon(Icons.open_in_new_rounded,
          color: AppColors.muted, size: 15));
}

class _AiClusteringPanel extends StatelessWidget {
  const _AiClusteringPanel();
  @override
  Widget build(BuildContext context) => _Panel(
      title: 'AI clustering activity',
      subtitle: 'Transparent machine-assisted processing',
      trailing: const StatusPill('MODEL v3.8',
          color: AppColors.blue, icon: Icons.memory_rounded),
      child: const Padding(
          padding: EdgeInsets.all(15),
          child: Column(children: [
            _AiWorkItem(
                Icons.hub_outlined,
                AppColors.blue,
                'Semantic topic clustering',
                'Grouping 312 new public records into issue themes',
                .78,
                'Running',
                'Aggregate public sources only'),
            Divider(height: 1),
            _AiWorkItem(
                Icons.copy_all_outlined,
                Color(0xFF7657C8),
                'Duplicate narrative detection',
                'Comparing image hashes and repeated text patterns',
                .61,
                'Analyzing',
                'No identity inference'),
          ])));
}

class _BriefComposer extends StatelessWidget {
  const _BriefComposer();
  @override
  Widget build(BuildContext context) => _Panel(
      title: 'Social intelligence brief',
      subtitle: 'AI-assisted draft requiring officer approval',
      trailing: const StatusPill('DRAFT', color: AppColors.amber),
      child: Padding(
          padding: const EdgeInsets.all(16),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('Next brief • 18:00 command update',
                style: TextStyle(
                    color: AppColors.navy,
                    fontSize: 13,
                    fontWeight: FontWeight.w900)),
            const SizedBox(height: 7),
            const Text(
                '5 emerging topics, 4 information-risk alerts and 12 representative public sources are ready for review.',
                style: TextStyle(fontSize: 10, height: 1.4)),
            const SizedBox(height: 13),
            const Row(children: [
              Expanded(child: _MiniValue('SOURCE RECORDS', '427')),
              Expanded(child: _MiniValue('REVIEWED', '68%')),
              Expanded(child: _MiniValue('EDITOR', 'Unassigned'))
            ]),
            const SizedBox(height: 13),
            Row(children: [
              Expanded(
                  child: OutlinedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.visibility_outlined, size: 16),
                      label: const Text('Preview draft'))),
              const SizedBox(width: 8),
              Expanded(
                  child: FilledButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.edit_note_rounded, size: 16),
                      label: const Text('Open for review')))
            ]),
          ])));
}
