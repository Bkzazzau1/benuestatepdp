part of 'situation_room_page.dart';

class _EvidenceRecord {
  const _EvidenceRecord({
    required this.id,
    required this.title,
    required this.type,
    required this.source,
    required this.location,
    required this.time,
    required this.status,
    required this.integrity,
    required this.color,
    required this.icon,
    required this.size,
    required this.hash,
  });
  final String id,
      title,
      type,
      source,
      location,
      time,
      status,
      integrity,
      size,
      hash;
  final Color color;
  final IconData icon;
}

class _EvidenceCenterPage extends StatefulWidget {
  const _EvidenceCenterPage();
  @override
  State<_EvidenceCenterPage> createState() => _EvidenceCenterPageState();
}

class _EvidenceCenterPageState extends State<_EvidenceCenterPage> {
  int _selected = 0;
  String _type = 'All media';
  String _status = 'All states';
  String _query = '';

  static const _records = <_EvidenceRecord>[
    _EvidenceRecord(
        id: 'EVD-2026-01842',
        title: 'Polling unit entrance video',
        type: 'Video',
        source: 'AGT-041 • Amina Yusuf',
        location: 'Kwarbai \'A\' • PU-014',
        time: 'Today • 14:31',
        status: 'Available',
        integrity: 'Verified',
        color: AppColors.green,
        icon: Icons.videocam_outlined,
        size: '84.2 MB',
        hash: 'a47d9c83…e21f'),
    _EvidenceRecord(
        id: 'EVD-2026-01841',
        title: 'Access disruption photograph',
        type: 'Photo',
        source: 'AGT-074 • Kabir Musa',
        location: 'Tudun Wada • PU-028',
        time: 'Today • 14:26',
        status: 'Under review',
        integrity: 'Verified',
        color: AppColors.amber,
        icon: Icons.image_outlined,
        size: '4.8 MB',
        hash: 'b92f11a0…8dc4'),
    _EvidenceRecord(
        id: 'EVD-2026-01839',
        title: 'Secure call audio segment',
        type: 'Audio',
        source: 'CALL-SEC-00184',
        location: 'Kwarbai \'A\'',
        time: 'Today • 14:18',
        status: 'Restricted',
        integrity: 'Verified',
        color: Color(0xFF7657C8),
        icon: Icons.graphic_eq_rounded,
        size: '12.7 MB',
        hash: '0c5e84d7…f719'),
    _EvidenceRecord(
        id: 'EVD-2026-01836',
        title: 'Observer accreditation document',
        type: 'Document',
        source: 'AGT-088 • Fatima Ali',
        location: 'Gyallesu • PU-009',
        time: 'Today • 13:52',
        status: 'Processing',
        integrity: 'Pending',
        color: AppColors.blue,
        icon: Icons.description_outlined,
        size: '1.2 MB',
        hash: 'Calculating…'),
    _EvidenceRecord(
        id: 'EVD-2026-01831',
        title: 'Crowd overview video',
        type: 'Video',
        source: 'AGT-052 • Tunde Obi',
        location: 'Kaura • PU-031',
        time: 'Today • 13:40',
        status: 'Integrity warning',
        integrity: 'Mismatch',
        color: AppColors.red,
        icon: Icons.warning_amber_rounded,
        size: '127.4 MB',
        hash: 'Expected hash differs'),
  ];

  List<_EvidenceRecord> get _filtered => _records.where((item) {
        final q = _query.toLowerCase();
        final matchesQuery = q.isEmpty ||
            '${item.id} ${item.title} ${item.source} ${item.location}'
                .toLowerCase()
                .contains(q);
        final matchesType = _type == 'All media' || item.type == _type;
        final matchesStatus = _status == 'All states' || item.status == _status;
        return matchesQuery && matchesType && matchesStatus;
      }).toList();

  @override
  Widget build(BuildContext context) {
    final results = _filtered;
    final selected = results.isEmpty
        ? null
        : results[_selected.clamp(0, results.length - 1)];
    return Column(children: [
      _EvidenceHeader(onUpload: _showUpload),
      const _EvidenceMetrics(),
      _EvidenceFilters(
        query: _query,
        type: _type,
        status: _status,
        onQuery: (value) => setState(() {
          _query = value;
          _selected = 0;
        }),
        onType: (value) => setState(() {
          _type = value!;
          _selected = 0;
        }),
        onStatus: (value) => setState(() {
          _status = value!;
          _selected = 0;
        }),
      ),
      Expanded(
          child: Row(children: [
        Expanded(
            flex: 6,
            child: _EvidenceList(
                records: results,
                selected: selected?.id,
                onSelected: (item) =>
                    setState(() => _selected = results.indexOf(item)))),
        Container(width: 1, color: AppColors.border),
        Expanded(
            flex: 4,
            child: selected == null
                ? const _EmptyEvidence()
                : _EvidenceInspector(
                    record: selected, onAudit: () => _showAudit(selected))),
      ])),
    ]);
  }

  void _showUpload() => showDialog<void>(
      context: context,
      builder: (_) => AlertDialog(
            title: const Row(children: [
              Icon(Icons.cloud_upload_outlined, color: AppColors.blue),
              SizedBox(width: 10),
              Text('Secure evidence ingest')
            ]),
            content: const SizedBox(
                width: 480,
                child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InfoNotice(
                          'Original files become immutable after successful receipt. Upload, viewing, export and policy actions are audited.'),
                      SizedBox(height: 16),
                      _UploadDropZone(),
                      SizedBox(height: 14),
                      Text('Required linkage',
                          style: TextStyle(
                              color: AppColors.navy,
                              fontWeight: FontWeight.w800,
                              fontSize: 12)),
                      SizedBox(height: 8),
                      Row(children: [
                        Expanded(
                            child: TextField(
                                decoration: InputDecoration(
                                    labelText: 'Incident or report ID'))),
                        SizedBox(width: 10),
                        Expanded(
                            child: TextField(
                                decoration: InputDecoration(
                                    labelText: 'Source / agent')))
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
                            'Evidence queued for encrypted upload and integrity verification')));
                  },
                  icon: const Icon(Icons.lock_outline_rounded),
                  label: const Text('Begin secure upload'))
            ],
          ));

  void _showAudit(_EvidenceRecord record) => showDialog<void>(
      context: context,
      builder: (_) => AlertDialog(
            title: Text('Chain of custody • ${record.id}'),
            content: const SizedBox(
                width: 520,
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  _AuditEvent('14:31:33', 'Original received',
                      'Evidence Service • request 6F1A'),
                  _AuditEvent('14:31:35', 'SHA-256 integrity verified',
                      'Automated ingest pipeline'),
                  _AuditEvent('14:32:02', 'Preview generated',
                      'Derived artifact • video-preview-v2'),
                  _AuditEvent('14:34:11', 'Viewed by verification officer',
                      'N. Ibrahim • Verification Officer'),
                  _AuditEvent('14:36:20', 'Linked to incident INC-00518',
                      'Sani Shuaibu • Room Commander'),
                ])),
            actions: [
              FilledButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Done'))
            ],
          ));
}

class _EvidenceHeader extends StatelessWidget {
  const _EvidenceHeader({required this.onUpload});
  final VoidCallback onUpload;
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
                      colors: [AppColors.blue, Color(0xFF7657C8)]),
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: const [
                    BoxShadow(
                        color: Color(0x33246BFD),
                        blurRadius: 16,
                        offset: Offset(0, 6))
                  ]),
              child:
                  const Icon(Icons.perm_media_outlined, color: Colors.white)),
          const SizedBox(width: 13),
          Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                Text('Evidence center',
                    style: Theme.of(context).textTheme.headlineMedium),
                const SizedBox(height: 3),
                const Text(
                    'Protected originals, derived artifacts and complete access history',
                    overflow: TextOverflow.ellipsis)
              ])),
          OutlinedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.policy_outlined, size: 17),
              label: const Text('Retention policy')),
          const SizedBox(width: 8),
          FilledButton.icon(
              onPressed: onUpload,
              icon: const Icon(Icons.cloud_upload_outlined, size: 18),
              label: const Text('Ingest evidence')),
        ]),
      );
}

class _EvidenceMetrics extends StatelessWidget {
  const _EvidenceMetrics();
  @override
  Widget build(BuildContext context) => Container(
        color: Colors.white,
        padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
        child: const Row(children: [
          Expanded(
              child: _EvidenceMetric(Icons.inventory_2_outlined, AppColors.blue,
                  '2,418', 'Total objects', '+36 today')),
          SizedBox(width: 10),
          Expanded(
              child: _EvidenceMetric(Icons.verified_outlined, AppColors.green,
                  '99.8%', 'Integrity verified', '2 warnings')),
          SizedBox(width: 10),
          Expanded(
              child: _EvidenceMetric(Icons.cloud_upload_outlined,
                  AppColors.amber, '7', 'Uploads active', '3 resumable')),
          SizedBox(width: 10),
          Expanded(
              child: _EvidenceMetric(
                  Icons.fact_check_outlined,
                  Color(0xFF7657C8),
                  '14',
                  'Awaiting review',
                  '4 high priority')),
          SizedBox(width: 10),
          Expanded(
              child: _EvidenceMetric(Icons.storage_outlined, AppColors.cyan,
                  '186 GB', 'Protected storage', '72% available')),
        ]),
      );
}

class _EvidenceMetric extends StatelessWidget {
  const _EvidenceMetric(
      this.icon, this.color, this.value, this.label, this.detail);
  final IconData icon;
  final Color color;
  final String value, label, detail;
  @override
  Widget build(BuildContext context) => Container(
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
          color: const Color(0xFFF8FAFC),
          border: Border.all(color: AppColors.border),
          borderRadius: BorderRadius.circular(13)),
      child: Row(children: [
        Container(
            width: 35,
            height: 35,
            decoration: BoxDecoration(
                color: color.withValues(alpha: .1),
                borderRadius: BorderRadius.circular(10)),
            child: Icon(icon, color: color, size: 18)),
        const SizedBox(width: 9),
        Expanded(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Text(value,
                style: const TextStyle(
                    color: AppColors.navy,
                    fontWeight: FontWeight.w900,
                    fontSize: 17)),
            const SizedBox(width: 6),
            Expanded(
                child: Text(detail,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: color,
                        fontWeight: FontWeight.w700,
                        fontSize: 8)))
          ]),
          Text(label,
              style: const TextStyle(
                  color: AppColors.muted,
                  fontSize: 9,
                  fontWeight: FontWeight.w700))
        ]))
      ]));
}

class _EvidenceFilters extends StatelessWidget {
  const _EvidenceFilters(
      {required this.query,
      required this.type,
      required this.status,
      required this.onQuery,
      required this.onType,
      required this.onStatus});
  final String query, type, status;
  final ValueChanged<String> onQuery;
  final ValueChanged<String?> onType, onStatus;
  @override
  Widget build(BuildContext context) => Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: const BoxDecoration(
          color: Color(0xFFF8FAFC),
          border: Border.symmetric(
              horizontal: BorderSide(color: AppColors.border))),
      child: Row(children: [
        SizedBox(
            width: 330,
            height: 40,
            child: TextField(
                onChanged: onQuery,
                decoration: const InputDecoration(
                    hintText: 'Search ID, source, incident, agent or location',
                    prefixIcon: Icon(Icons.search_rounded, size: 19),
                    contentPadding: EdgeInsets.zero))),
        const SizedBox(width: 10),
        _FilterDropdown(
            type,
            const ['All media', 'Video', 'Photo', 'Audio', 'Document'],
            Icons.filter_alt_outlined,
            onType),
        const SizedBox(width: 8),
        _FilterDropdown(
            status,
            const [
              'All states',
              'Available',
              'Under review',
              'Restricted',
              'Processing',
              'Integrity warning'
            ],
            Icons.verified_outlined,
            onStatus),
        const Spacer(),
        const StatusPill('ORIGINALS IMMUTABLE',
            color: AppColors.green, icon: Icons.lock_outline_rounded),
        const SizedBox(width: 8),
        IconButton(
            onPressed: () {},
            tooltip: 'Display options',
            icon: const Icon(Icons.view_agenda_outlined)),
      ]));
}

class _FilterDropdown extends StatelessWidget {
  const _FilterDropdown(this.value, this.values, this.icon, this.onChanged);
  final String value;
  final List<String> values;
  final IconData icon;
  final ValueChanged<String?> onChanged;
  @override
  Widget build(BuildContext context) => Container(
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: AppColors.border),
          borderRadius: BorderRadius.circular(10)),
      child: Row(children: [
        Icon(icon, size: 16, color: AppColors.muted),
        const SizedBox(width: 6),
        DropdownButton<String>(
            value: value,
            underline: const SizedBox(),
            style: const TextStyle(
                color: AppColors.navy,
                fontSize: 11,
                fontWeight: FontWeight.w700),
            items: values
                .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                .toList(),
            onChanged: onChanged)
      ]));
}

class _EvidenceList extends StatelessWidget {
  const _EvidenceList(
      {required this.records,
      required this.selected,
      required this.onSelected});
  final List<_EvidenceRecord> records;
  final String? selected;
  final ValueChanged<_EvidenceRecord> onSelected;
  @override
  Widget build(BuildContext context) => Container(
      color: Colors.white,
      child: Column(children: [
        const Padding(
            padding: EdgeInsets.fromLTRB(24, 12, 18, 10),
            child: Row(children: [
              Expanded(
                  child: Text('EVIDENCE OBJECT',
                      style: TextStyle(
                          color: AppColors.muted,
                          fontSize: 9,
                          fontWeight: FontWeight.w900,
                          letterSpacing: .7))),
              SizedBox(
                  width: 110,
                  child: Text('SOURCE',
                      style: TextStyle(
                          color: AppColors.muted,
                          fontSize: 9,
                          fontWeight: FontWeight.w900))),
              SizedBox(
                  width: 100,
                  child: Text('STATUS',
                      style: TextStyle(
                          color: AppColors.muted,
                          fontSize: 9,
                          fontWeight: FontWeight.w900)))
            ])),
        const Divider(height: 1),
        Expanded(
            child: records.isEmpty
                ? const _EmptyEvidence()
                : ListView.separated(
                    itemCount: records.length,
                    separatorBuilder: (_, __) => const Divider(height: 1),
                    itemBuilder: (_, i) {
                      final item = records[i];
                      final active = item.id == selected;
                      return InkWell(
                          onTap: () => onSelected(item),
                          child: Container(
                              color: active
                                  ? const Color(0xFFF0F5FF)
                                  : Colors.white,
                              padding:
                                  const EdgeInsets.fromLTRB(18, 13, 14, 13),
                              child: Row(children: [
                                Container(
                                    width: 46,
                                    height: 46,
                                    decoration: BoxDecoration(
                                        color: item.color.withValues(alpha: .1),
                                        borderRadius:
                                            BorderRadius.circular(12)),
                                    child: Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          Icon(item.icon,
                                              color: item.color, size: 22),
                                          if (item.type == 'Video')
                                            const Positioned(
                                                right: 4,
                                                bottom: 4,
                                                child: Icon(
                                                    Icons
                                                        .play_circle_fill_rounded,
                                                    color: AppColors.navy,
                                                    size: 12))
                                        ])),
                                const SizedBox(width: 12),
                                Expanded(
                                    child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                      Row(children: [
                                        Text(item.id,
                                            style: const TextStyle(
                                                color: AppColors.navy,
                                                fontSize: 10,
                                                fontWeight: FontWeight.w900)),
                                        const SizedBox(width: 7),
                                        Text(item.type.toUpperCase(),
                                            style: const TextStyle(
                                                color: AppColors.muted,
                                                fontSize: 8,
                                                fontWeight: FontWeight.w800))
                                      ]),
                                      const SizedBox(height: 4),
                                      Text(item.title,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                              color: AppColors.navy,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w800)),
                                      const SizedBox(height: 4),
                                      Text('${item.location}  •  ${item.time}',
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(fontSize: 9))
                                    ])),
                                SizedBox(
                                    width: 110,
                                    child: Text(item.source,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 2,
                                        style: const TextStyle(
                                            color: AppColors.navy,
                                            fontSize: 9,
                                            fontWeight: FontWeight.w700))),
                                SizedBox(
                                    width: 100,
                                    child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: FittedBox(
                                            alignment: Alignment.centerLeft,
                                            fit: BoxFit.scaleDown,
                                            child: StatusPill(
                                                item.status.toUpperCase(),
                                                color: item.color)))),
                                Icon(Icons.chevron_right_rounded,
                                    color: active
                                        ? AppColors.blue
                                        : AppColors.muted,
                                    size: 19),
                              ])));
                    })),
      ]));
}

class _EvidenceInspector extends StatelessWidget {
  const _EvidenceInspector({required this.record, required this.onAudit});
  final _EvidenceRecord record;
  final VoidCallback onAudit;
  @override
  Widget build(BuildContext context) => Container(
      color: const Color(0xFFF8FAFC),
      child: ListView(padding: const EdgeInsets.all(18), children: [
        Row(children: [
          Expanded(
              child: Text(record.id,
                  style: const TextStyle(
                      color: AppColors.muted,
                      fontSize: 10,
                      fontWeight: FontWeight.w900,
                      letterSpacing: .5))),
          IconButton(
              onPressed: () {},
              tooltip: 'More actions',
              icon: const Icon(Icons.more_horiz_rounded))
        ]),
        Container(
            height: 180,
            decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
                  AppColors.navy,
                  record.color.withValues(alpha: .75)
                ], begin: Alignment.topLeft, end: Alignment.bottomRight),
                borderRadius: BorderRadius.circular(16)),
            child: Stack(children: [
              Center(child: Icon(record.icon, color: Colors.white54, size: 58)),
              Positioned(
                  left: 13,
                  bottom: 13,
                  child: StatusPill(record.type.toUpperCase(),
                      color: Colors.white)),
              const Positioned(
                  right: 13,
                  bottom: 13,
                  child: StatusPill('PREVIEW COPY', color: Color(0xFFB9C8DA)))
            ])),
        const SizedBox(height: 15),
        Text(record.title,
            style: const TextStyle(
                color: AppColors.navy,
                fontSize: 18,
                fontWeight: FontWeight.w900)),
        const SizedBox(height: 8),
        Row(children: [
          StatusPill(record.status.toUpperCase(), color: record.color),
          const SizedBox(width: 7),
          StatusPill('INTEGRITY ${record.integrity.toUpperCase()}',
              color: record.integrity == 'Mismatch'
                  ? AppColors.red
                  : record.integrity == 'Pending'
                      ? AppColors.amber
                      : AppColors.green)
        ]),
        const SizedBox(height: 17),
        const Text('SOURCE & CAPTURE',
            style: TextStyle(
                color: AppColors.muted,
                fontSize: 9,
                fontWeight: FontWeight.w900,
                letterSpacing: .7)),
        const SizedBox(height: 8),
        _EvidenceDetail(Icons.person_outline_rounded, 'Source', record.source),
        _EvidenceDetail(Icons.location_on_outlined, 'Location',
            '${record.location} • ±12m accuracy'),
        _EvidenceDetail(Icons.schedule_rounded, 'Captured',
            '${record.time} • received +7s'),
        _EvidenceDetail(
            Icons.link_rounded, 'Linked records', 'INC-00518 • RPT-2026-00201'),
        const Divider(height: 27),
        const Text('INTEGRITY & STORAGE',
            style: TextStyle(
                color: AppColors.muted,
                fontSize: 9,
                fontWeight: FontWeight.w900,
                letterSpacing: .7)),
        const SizedBox(height: 8),
        _EvidenceDetail(Icons.fingerprint_rounded, 'SHA-256', record.hash),
        _EvidenceDetail(Icons.data_object_rounded, 'Original object',
            '${record.size} • immutable'),
        const _EvidenceDetail(Icons.auto_awesome_outlined, 'Derived artifacts',
            'Preview • thumbnail • transcript'),
        const SizedBox(height: 14),
        Row(children: [
          Expanded(
              child: OutlinedButton.icon(
                  onPressed: onAudit,
                  icon: const Icon(Icons.history_rounded, size: 17),
                  label: const Text('Audit trail'))),
          const SizedBox(width: 8),
          Expanded(
              child: FilledButton.icon(
                  onPressed: record.integrity == 'Mismatch' ? null : () {},
                  icon: const Icon(Icons.visibility_outlined, size: 17),
                  label: const Text('Open evidence')))
        ]),
        const SizedBox(height: 8),
        OutlinedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.ios_share_outlined, size: 17),
            label: const Text('Request audited export')),
      ]));
}

class _EvidenceDetail extends StatelessWidget {
  const _EvidenceDetail(this.icon, this.label, this.value);
  final IconData icon;
  final String label, value;
  @override
  Widget build(BuildContext context) => Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(children: [
        Container(
            width: 29,
            height: 29,
            decoration: BoxDecoration(
                color: AppColors.blue.withValues(alpha: .08),
                borderRadius: BorderRadius.circular(8)),
            child: Icon(icon, color: AppColors.blue, size: 15)),
        const SizedBox(width: 9),
        Expanded(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(label,
              style: const TextStyle(
                  color: AppColors.muted,
                  fontSize: 8,
                  fontWeight: FontWeight.w800)),
          const SizedBox(height: 2),
          Text(value,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                  color: AppColors.navy,
                  fontSize: 10,
                  fontWeight: FontWeight.w700))
        ]))
      ]));
}

class _EmptyEvidence extends StatelessWidget {
  const _EmptyEvidence();
  @override
  Widget build(BuildContext context) => const Center(
          child: Column(mainAxisSize: MainAxisSize.min, children: [
        Icon(Icons.manage_search_rounded, color: AppColors.blue, size: 42),
        SizedBox(height: 10),
        Text('No evidence matches these filters',
            style:
                TextStyle(color: AppColors.navy, fontWeight: FontWeight.w800)),
        SizedBox(height: 4),
        Text('Adjust the search or filter criteria.')
      ]));
}

class _UploadDropZone extends StatelessWidget {
  const _UploadDropZone();
  @override
  Widget build(BuildContext context) => Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
          color: const Color(0xFFF4F7FC),
          border: Border.all(
              color: AppColors.blue.withValues(alpha: .35), width: 1.5),
          borderRadius: BorderRadius.circular(14)),
      child: const Column(children: [
        Icon(Icons.add_to_drive_outlined, color: AppColors.blue, size: 35),
        SizedBox(height: 8),
        Text('Choose protected evidence files',
            style:
                TextStyle(color: AppColors.navy, fontWeight: FontWeight.w800)),
        SizedBox(height: 3),
        Text('Photo, video, audio or document • resumable upload',
            style: TextStyle(fontSize: 10))
      ]));
}

class _AuditEvent extends StatelessWidget {
  const _AuditEvent(this.time, this.title, this.actor);
  final String time, title, actor;
  @override
  Widget build(BuildContext context) => Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Row(children: [
        SizedBox(
            width: 62,
            child: Text(time,
                style: const TextStyle(
                    color: AppColors.muted,
                    fontSize: 10,
                    fontWeight: FontWeight.w700))),
        const Icon(Icons.check_circle_rounded,
            color: AppColors.green, size: 16),
        const SizedBox(width: 9),
        Expanded(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title,
              style: const TextStyle(
                  color: AppColors.navy,
                  fontSize: 11,
                  fontWeight: FontWeight.w800)),
          Text(actor, style: const TextStyle(fontSize: 9))
        ]))
      ]));
}
