part of 'situation_room_page.dart';

class _MapObject {
  const _MapObject(
      {required this.id,
      required this.title,
      required this.kind,
      required this.ward,
      required this.status,
      required this.detail,
      required this.freshness,
      required this.accuracy,
      required this.color,
      required this.icon,
      required this.x,
      required this.y});
  final String id, title, kind, ward, status, detail, freshness, accuracy;
  final Color color;
  final IconData icon;
  final double x, y;
}

class _LiveMapPage extends StatefulWidget {
  const _LiveMapPage({required this.onOpenIncident});
  final ValueChanged<String> onOpenIncident;
  @override
  State<_LiveMapPage> createState() => _LiveMapPageState();
}

class _LiveMapPageState extends State<_LiveMapPage> {
  String _scope = 'All wards';
  String _layer = 'All objects';
  String _freshness = 'Live + recent';
  int _selected = 0;
  bool _heatmap = false;
  bool _boundaries = true;

  static const _objects = <_MapObject>[
    _MapObject(
        id: 'INC-00518',
        title: 'Access disruption',
        kind: 'Incident',
        ward: 'Kwarbai \'A\'',
        status: 'Critical',
        detail: 'Polling Unit 014 • response in progress',
        freshness: 'Updated 20s ago',
        accuracy: 'Incident location • ±12 m',
        color: AppColors.red,
        icon: Icons.warning_rounded,
        x: .43,
        y: .36),
    _MapObject(
        id: 'AGT-041',
        title: 'Amina Yusuf',
        kind: 'Agent',
        ward: 'Kwarbai \'A\'',
        status: 'Online',
        detail: 'Lead Field Agent • PU-014',
        freshness: 'Live session • 20s ago',
        accuracy: '±12 m accuracy',
        color: AppColors.green,
        icon: Icons.person_pin_circle_rounded,
        x: .48,
        y: .43),
    _MapObject(
        id: 'PU-028',
        title: 'Polling Unit 028',
        kind: 'Polling unit',
        ward: 'Tudun Wada',
        status: 'Verification pending',
        detail: 'Agent AGT-074 • report received',
        freshness: 'Fixed registered location',
        accuracy: 'Reference coordinates',
        color: AppColors.amber,
        icon: Icons.how_to_vote_rounded,
        x: .68,
        y: .27),
    _MapObject(
        id: 'RPT-00201',
        title: 'Location discrepancy',
        kind: 'Report flag',
        ward: 'Kwarbai \'A\'',
        status: 'Review required',
        detail: '420 m from registered polling unit',
        freshness: 'Captured 15m ago',
        accuracy: '±12 m accuracy',
        color: AppColors.red,
        icon: Icons.location_off_rounded,
        x: .34,
        y: .31),
    _MapObject(
        id: 'EVD-01842',
        title: 'Entrance video',
        kind: 'Evidence',
        ward: 'Kwarbai \'A\'',
        status: 'Integrity verified',
        detail: 'Linked to INC-00518',
        freshness: 'Captured 14:31',
        accuracy: 'Capture location • ±14 m',
        color: Color(0xFF7657C8),
        icon: Icons.videocam_rounded,
        x: .51,
        y: .50),
    _MapObject(
        id: 'AGT-088',
        title: 'Fatima Ali',
        kind: 'Agent',
        ward: 'Gyallesu',
        status: 'Degraded',
        detail: 'Verification Liaison • PU-009',
        freshness: 'Last known • 4m ago',
        accuracy: '±96 m • low accuracy',
        color: AppColors.amber,
        icon: Icons.person_pin_circle_outlined,
        x: .72,
        y: .62),
    _MapObject(
        id: 'INC-00496',
        title: 'Communication loss',
        kind: 'Incident',
        ward: 'Gyallesu',
        status: 'High',
        detail: 'Polling Unit 009 • escalated',
        freshness: 'Updated 3m ago',
        accuracy: 'Polling-unit reference',
        color: AppColors.amber,
        icon: Icons.signal_wifi_connected_no_internet_4_rounded,
        x: .77,
        y: .68),
    _MapObject(
        id: 'PU-031',
        title: 'Polling Unit 031',
        kind: 'Polling unit',
        ward: 'Kaura',
        status: 'Normal',
        detail: 'Agent AGT-052 • report received',
        freshness: 'Fixed registered location',
        accuracy: 'Reference coordinates',
        color: AppColors.blue,
        icon: Icons.how_to_vote_rounded,
        x: .21,
        y: .70),
  ];

  List<_MapObject> get _visible => _objects
      .where((object) =>
          (_scope == 'All wards' || object.ward == _scope) &&
          (_layer == 'All objects' || object.kind == _layer))
      .toList();

  @override
  Widget build(BuildContext context) {
    final objects = _visible;
    final selected = objects.isEmpty
        ? null
        : objects[_selected.clamp(0, objects.length - 1)];
    return Column(children: [
      _MapHeader(
          scope: _scope,
          layer: _layer,
          freshness: _freshness,
          onScope: (v) => setState(() {
                _scope = v!;
                _selected = 0;
              }),
          onLayer: (v) => setState(() {
                _layer = v!;
                _selected = 0;
              }),
          onFreshness: (v) => setState(() => _freshness = v!)),
      const _MapMetrics(),
      Expanded(
          child: Row(children: [
        SizedBox(
            width: 340,
            child: _MapObjectRail(
                objects: objects,
                selected: selected?.id,
                onSelected: (object) =>
                    setState(() => _selected = objects.indexOf(object)))),
        Expanded(
            child: _CommandMap(
                objects: objects,
                selected: selected,
                heatmap: _heatmap,
                boundaries: _boundaries,
                onSelected: (object) =>
                    setState(() => _selected = objects.indexOf(object)),
                onHeatmap: () => setState(() => _heatmap = !_heatmap),
                onBoundaries: () =>
                    setState(() => _boundaries = !_boundaries))),
        SizedBox(
            width: 325,
            child: selected == null
                ? const _MapEmptyInspector()
                : _MapInspector(
                    object: selected, onOpenIncident: widget.onOpenIncident)),
      ])),
    ]);
  }
}

class _MapHeader extends StatelessWidget {
  const _MapHeader(
      {required this.scope,
      required this.layer,
      required this.freshness,
      required this.onScope,
      required this.onLayer,
      required this.onFreshness});
  final String scope, layer, freshness;
  final ValueChanged<String?> onScope, onLayer, onFreshness;
  @override
  Widget build(BuildContext context) => Container(
      padding: const EdgeInsets.fromLTRB(24, 18, 24, 15),
      color: Colors.white,
      child: Row(children: [
        Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
                gradient: const LinearGradient(
                    colors: [AppColors.blue, AppColors.cyan]),
                borderRadius: BorderRadius.circular(14),
                boxShadow: const [
                  BoxShadow(
                      color: Color(0x33246BFD),
                      blurRadius: 16,
                      offset: Offset(0, 6))
                ]),
            child: const Icon(Icons.map_rounded, color: Colors.white)),
        const SizedBox(width: 13),
        Expanded(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Live operational map',
              style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 3),
          const Text(
              'Authorized locations with freshness, accuracy and session context',
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
        const SizedBox(width: 7),
        _FilterDropdown(
            layer,
            const [
              'All objects',
              'Incident',
              'Agent',
              'Polling unit',
              'Evidence',
              'Report flag'
            ],
            Icons.layers_outlined,
            onLayer),
        const SizedBox(width: 7),
        _FilterDropdown(
            freshness,
            const ['Live + recent', 'Live only', 'Last hour', 'Today'],
            Icons.schedule_rounded,
            onFreshness),
      ]));
}

class _MapMetrics extends StatelessWidget {
  const _MapMetrics();
  @override
  Widget build(BuildContext context) => Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 15),
      child: const Row(children: [
        Expanded(
            child: _EvidenceMetric(Icons.map_outlined, AppColors.blue, '13',
                'Operational wards', '12 active')),
        SizedBox(width: 9),
        Expanded(
            child: _EvidenceMetric(Icons.person_pin_circle_outlined,
                AppColors.green, '184', 'Agents online', '63 live sessions')),
        SizedBox(width: 9),
        Expanded(
            child: _EvidenceMetric(Icons.warning_amber_rounded, AppColors.red,
                '23', 'Open incidents', '4 critical')),
        SizedBox(width: 9),
        Expanded(
            child: _EvidenceMetric(Icons.location_off_outlined, AppColors.amber,
                '3', 'GPS discrepancies', '1 high priority')),
        SizedBox(width: 9),
        Expanded(
            child: _EvidenceMetric(Icons.sensors_outlined, Color(0xFF7657C8),
                '96%', 'Location freshness', '7 stale markers')),
      ]));
}

class _MapObjectRail extends StatelessWidget {
  const _MapObjectRail(
      {required this.objects,
      required this.selected,
      required this.onSelected});
  final List<_MapObject> objects;
  final String? selected;
  final ValueChanged<_MapObject> onSelected;
  @override
  Widget build(BuildContext context) => Container(
      decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(
              right: BorderSide(color: AppColors.border),
              top: BorderSide(color: AppColors.border))),
      child: Column(children: [
        Padding(
            padding: const EdgeInsets.fromLTRB(14, 12, 10, 10),
            child: Row(children: [
              Text('${objects.length} VISIBLE OBJECTS',
                  style: const TextStyle(
                      color: AppColors.muted,
                      fontSize: 9,
                      fontWeight: FontWeight.w900,
                      letterSpacing: .7)),
              const Spacer(),
              IconButton(
                  onPressed: () {},
                  tooltip: 'Sort objects',
                  constraints:
                      const BoxConstraints.tightFor(width: 30, height: 30),
                  padding: EdgeInsets.zero,
                  icon: const Icon(Icons.sort_rounded, size: 17))
            ])),
        const Divider(height: 1),
        Expanded(
            child: objects.isEmpty
                ? const _MapEmptyInspector()
                : ListView.separated(
                    itemCount: objects.length,
                    separatorBuilder: (_, __) => const Divider(height: 1),
                    itemBuilder: (_, i) {
                      final object = objects[i];
                      final active = object.id == selected;
                      return InkWell(
                          onTap: () => onSelected(object),
                          child: Container(
                              color: active
                                  ? object.color.withValues(alpha: .07)
                                  : Colors.white,
                              padding: const EdgeInsets.all(13),
                              child: Row(children: [
                                Container(
                                    width: 38,
                                    height: 38,
                                    decoration: BoxDecoration(
                                        color:
                                            object.color.withValues(alpha: .11),
                                        borderRadius:
                                            BorderRadius.circular(11)),
                                    child: Icon(object.icon,
                                        color: object.color, size: 19)),
                                const SizedBox(width: 10),
                                Expanded(
                                    child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                      Row(children: [
                                        Expanded(
                                            child: Text(object.title,
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                    color: AppColors.navy,
                                                    fontSize: 11,
                                                    fontWeight:
                                                        FontWeight.w900))),
                                        FittedBox(
                                            fit: BoxFit.scaleDown,
                                            child: StatusPill(
                                                object.status.toUpperCase(),
                                                color: object.color))
                                      ]),
                                      const SizedBox(height: 4),
                                      Text('${object.id} • ${object.ward}',
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                              fontSize: 8,
                                              fontWeight: FontWeight.w700)),
                                      const SizedBox(height: 3),
                                      Row(children: [
                                        Icon(Icons.schedule_rounded,
                                            color: object.color, size: 11),
                                        const SizedBox(width: 3),
                                        Expanded(
                                            child: Text(object.freshness,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                    color: object.color,
                                                    fontSize: 8,
                                                    fontWeight:
                                                        FontWeight.w700)))
                                      ])
                                    ])),
                              ])));
                    })),
      ]));
}

class _CommandMap extends StatelessWidget {
  const _CommandMap(
      {required this.objects,
      required this.selected,
      required this.heatmap,
      required this.boundaries,
      required this.onSelected,
      required this.onHeatmap,
      required this.onBoundaries});
  final List<_MapObject> objects;
  final _MapObject? selected;
  final bool heatmap, boundaries;
  final ValueChanged<_MapObject> onSelected;
  final VoidCallback onHeatmap, onBoundaries;
  @override
  Widget build(BuildContext context) => LayoutBuilder(
      builder: (context, constraints) => Stack(children: [
            Positioned.fill(
                child: CustomPaint(
                    painter: _OperationalMapPainter(
                        heatmap: heatmap, boundaries: boundaries))),
            ...objects.map((object) => Positioned(
                left: (constraints.maxWidth * object.x - 22)
                    .clamp(8, constraints.maxWidth - 145),
                top: (constraints.maxHeight * object.y - 18)
                    .clamp(8, constraints.maxHeight - 50),
                child: _OperationalMarker(
                    object: object,
                    selected: selected?.id == object.id,
                    onTap: () => onSelected(object)))),
            Positioned(left: 14, top: 14, child: _MapLegendCard()),
            Positioned(
                right: 14,
                top: 14,
                child: Column(children: [
                  _MapTool(Icons.add_rounded, 'Zoom in', () {}),
                  const SizedBox(height: 5),
                  _MapTool(Icons.remove_rounded, 'Zoom out', () {}),
                  const SizedBox(height: 5),
                  _MapTool(Icons.my_location_rounded, 'Center map', () {}),
                  const SizedBox(height: 5),
                  _MapTool(
                      Icons.layers_outlined, 'Ward boundaries', onBoundaries,
                      active: boundaries),
                  const SizedBox(height: 5),
                  _MapTool(Icons.blur_on_rounded, 'Incident heatmap', onHeatmap,
                      active: heatmap),
                ])),
            Positioned(
                left: 14,
                bottom: 14,
                child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: .95),
                        borderRadius: BorderRadius.circular(9),
                        boxShadow: const [
                          BoxShadow(color: Color(0x18000000), blurRadius: 10)
                        ]),
                    child: const Row(children: [
                      Icon(Icons.shield_outlined,
                          color: AppColors.green, size: 15),
                      SizedBox(width: 6),
                      Text(
                          'Purpose-limited operational locations • scope enforced',
                          style: TextStyle(
                              color: AppColors.navy,
                              fontSize: 8,
                              fontWeight: FontWeight.w800))
                    ]))),
          ]));
}

class _OperationalMapPainter extends CustomPainter {
  const _OperationalMapPainter(
      {required this.heatmap, required this.boundaries});
  final bool heatmap, boundaries;
  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(
        Offset.zero & size, Paint()..color = const Color(0xFFE8EDF1));
    final green = Paint()..color = const Color(0xFFDDE9DF);
    canvas.drawRRect(
        RRect.fromRectAndRadius(
            Rect.fromLTWH(size.width * .05, size.height * .08, size.width * .24,
                size.height * .22),
            const Radius.circular(34)),
        green);
    canvas.drawRRect(
        RRect.fromRectAndRadius(
            Rect.fromLTWH(size.width * .68, size.height * .05, size.width * .26,
                size.height * .19),
            const Radius.circular(42)),
        green);
    final river = Paint()
      ..color = const Color(0xFFB8DBE7)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 20;
    canvas.drawPath(
        Path()
          ..moveTo(-10, size.height * .76)
          ..cubicTo(size.width * .22, size.height * .47, size.width * .55,
              size.height * .93, size.width + 10, size.height * .58),
        river);
    final minor = Paint()
      ..color = const Color(0xFFCCD6DE)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    final major = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 9;
    for (var i = 1; i < 8; i++) {
      final x = size.width * i / 8;
      canvas.drawPath(
          Path()
            ..moveTo(x, -10)
            ..cubicTo(x - 70, size.height * .3, x + 65, size.height * .65,
                x - 25, size.height + 10),
          i.isEven ? major : minor);
    }
    for (var i = 1; i < 6; i++) {
      final y = size.height * i / 6;
      canvas.drawPath(
          Path()
            ..moveTo(-10, y)
            ..cubicTo(size.width * .3, y + 38, size.width * .65, y - 34,
                size.width + 10, y + 7),
          i == 3 ? major : minor);
    }
    if (boundaries) {
      final border = Paint()
        ..color = const Color(0xFF8EA2B4)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.2;
      canvas.drawPath(
          Path()
            ..moveTo(size.width * .32, 0)
            ..lineTo(size.width * .37, size.height * .45)
            ..lineTo(size.width * .28, size.height)
            ..moveTo(size.width * .64, 0)
            ..lineTo(size.width * .58, size.height * .52)
            ..lineTo(size.width * .67, size.height),
          border);
    }
    if (heatmap) {
      final heat = Paint()
        ..shader =
            const RadialGradient(colors: [Color(0x66D94646), Color(0x00D94646)])
                .createShader(Rect.fromCircle(
                    center: Offset(size.width * .46, size.height * .39),
                    radius: 125));
      canvas.drawCircle(Offset(size.width * .46, size.height * .39), 125, heat);
    }
  }

  @override
  bool shouldRepaint(covariant _OperationalMapPainter oldDelegate) =>
      oldDelegate.heatmap != heatmap || oldDelegate.boundaries != boundaries;
}

class _OperationalMarker extends StatelessWidget {
  const _OperationalMarker(
      {required this.object, required this.selected, required this.onTap});
  final _MapObject object;
  final bool selected;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => Material(
      color: Colors.transparent,
      child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              padding: const EdgeInsets.fromLTRB(5, 4, 9, 4),
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                      color: selected ? object.color : Colors.white,
                      width: selected ? 2 : 1),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                        color: selected
                            ? object.color.withValues(alpha: .28)
                            : const Color(0x26000000),
                        blurRadius: selected ? 15 : 8,
                        offset: const Offset(0, 4))
                  ]),
              child: Row(mainAxisSize: MainAxisSize.min, children: [
                CircleAvatar(
                    radius: 13,
                    backgroundColor: object.color,
                    child: Icon(object.icon, color: Colors.white, size: 14)),
                const SizedBox(width: 6),
                ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 90),
                    child: Text(object.id,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            color: AppColors.navy,
                            fontSize: 8,
                            fontWeight: FontWeight.w900)))
              ]))));
}

class _MapLegendCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(
      padding: const EdgeInsets.all(11),
      decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: .96),
          borderRadius: BorderRadius.circular(10),
          boxShadow: const [
            BoxShadow(color: Color(0x18000000), blurRadius: 12)
          ]),
      child:
          const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('MAP LEGEND',
            style: TextStyle(
                color: AppColors.navy,
                fontSize: 9,
                fontWeight: FontWeight.w900,
                letterSpacing: .7)),
        SizedBox(height: 6),
        _LegendItem(AppColors.red, 'Critical / discrepancy'),
        _LegendItem(AppColors.amber, 'Pending / degraded'),
        _LegendItem(AppColors.green, 'Agent online'),
        _LegendItem(AppColors.blue, 'Polling unit'),
        _LegendItem(Color(0xFF7657C8), 'Evidence location')
      ]));
}

class _MapTool extends StatelessWidget {
  const _MapTool(this.icon, this.tooltip, this.onTap, {this.active = false});
  final IconData icon;
  final String tooltip;
  final VoidCallback onTap;
  final bool active;
  @override
  Widget build(BuildContext context) => Tooltip(
      message: tooltip,
      child: Material(
          color: active ? AppColors.navy : Colors.white,
          borderRadius: BorderRadius.circular(9),
          elevation: 2,
          child: InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(9),
              child: SizedBox(
                  width: 37,
                  height: 37,
                  child: Icon(icon,
                      size: 18,
                      color: active ? Colors.white : AppColors.navy)))));
}

class _MapInspector extends StatelessWidget {
  const _MapInspector({required this.object, required this.onOpenIncident});
  final _MapObject object;
  final ValueChanged<String> onOpenIncident;
  @override
  Widget build(BuildContext context) => Container(
      decoration: const BoxDecoration(
          color: Color(0xFFF8FAFC),
          border: Border(
              left: BorderSide(color: AppColors.border),
              top: BorderSide(color: AppColors.border))),
      child: ListView(padding: const EdgeInsets.all(16), children: [
        Row(children: [
          Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                  color: object.color.withValues(alpha: .1),
                  borderRadius: BorderRadius.circular(11)),
              child: Icon(object.icon, color: object.color, size: 20)),
          const SizedBox(width: 10),
          Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                Text(object.title,
                    style: const TextStyle(
                        color: AppColors.navy,
                        fontSize: 14,
                        fontWeight: FontWeight.w900)),
                Text('${object.id} • ${object.kind}',
                    style: const TextStyle(fontSize: 9))
              ])),
          IconButton(
              onPressed: () {}, icon: const Icon(Icons.more_horiz_rounded))
        ]),
        const SizedBox(height: 12),
        Wrap(spacing: 6, runSpacing: 6, children: [
          StatusPill(object.status.toUpperCase(), color: object.color),
          StatusPill(object.ward.toUpperCase(), color: AppColors.blue)
        ]),
        const SizedBox(height: 15),
        Container(
            padding: const EdgeInsets.all(13),
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: AppColors.border),
                borderRadius: BorderRadius.circular(12)),
            child: Column(children: [
              _EvidenceDetail(Icons.location_on_outlined, 'Operational context',
                  object.detail),
              _EvidenceDetail(
                  Icons.schedule_rounded, 'Freshness', object.freshness),
              _EvidenceDetail(
                  Icons.gps_fixed_rounded, 'Location quality', object.accuracy),
              _EvidenceDetail(
                  Icons.layers_outlined,
                  'Marker type',
                  object.kind == 'Agent' && object.freshness.startsWith('Live')
                      ? 'Active location session'
                      : object.kind == 'Polling unit'
                          ? 'Fixed registered reference'
                          : 'Object-linked location'),
            ])),
        const SizedBox(height: 13),
        if (object.kind == 'Agent') ...[
          _Panel(
              title: 'Location session',
              subtitle: 'Purpose-limited and policy controlled',
              child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(children: [
                          Icon(
                              object.freshness.startsWith('Live')
                                  ? Icons.sensors_rounded
                                  : Icons.sensors_off_outlined,
                              color: object.color,
                              size: 17),
                          const SizedBox(width: 7),
                          Expanded(
                              child: Text(
                                  object.freshness.startsWith('Live')
                                      ? 'Active operational session'
                                      : 'No active location session',
                                  style: const TextStyle(
                                      color: AppColors.navy,
                                      fontSize: 10,
                                      fontWeight: FontWeight.w900))),
                          StatusPill(
                              object.freshness.startsWith('Live')
                                  ? 'ACTIVE'
                                  : 'LAST KNOWN',
                              color: object.color)
                        ]),
                        const SizedBox(height: 8),
                        const Text(
                            'Background location cannot be enabled from this map. Agent authorization and policy controls apply.',
                            style: TextStyle(fontSize: 8, height: 1.35))
                      ]))),
          const SizedBox(height: 11)
        ],
        if (object.id == 'RPT-00201') ...[
          const InfoNotice(
              'This report is 420 m outside the configured polling-unit radius. GPS accuracy is ±12 m. Human review is required.',
              danger: true),
          const SizedBox(height: 11)
        ],
        const Text('AVAILABLE ACTIONS',
            style: TextStyle(
                color: AppColors.muted,
                fontSize: 8,
                fontWeight: FontWeight.w900,
                letterSpacing: .7)),
        const SizedBox(height: 8),
        if (object.kind == 'Incident')
          FilledButton.icon(
              onPressed: () => onOpenIncident(object.id),
              icon: const Icon(Icons.open_in_new_rounded, size: 16),
              label: const Text('Open incident console')),
        if (object.kind == 'Agent') ...[
          FilledButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.call_rounded, size: 16),
              label: const Text('Start secure call')),
          const SizedBox(height: 7),
          OutlinedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.location_searching_rounded, size: 16),
              label: const Text('Request location refresh'))
        ],
        if (object.kind == 'Polling unit')
          OutlinedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.how_to_vote_outlined, size: 16),
              label: const Text('Open polling unit')),
        if (object.kind == 'Evidence')
          OutlinedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.perm_media_outlined, size: 16),
              label: const Text('Open authorized evidence')),
        if (object.kind == 'Report flag')
          OutlinedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.fact_check_outlined, size: 16),
              label: const Text('Send to verification')),
        const SizedBox(height: 11),
        const InfoNotice(
            'Map access, object views and operator actions are scope checked and audited.'),
      ]));
}

class _MapEmptyInspector extends StatelessWidget {
  const _MapEmptyInspector();
  @override
  Widget build(BuildContext context) => const Center(
          child: Column(mainAxisSize: MainAxisSize.min, children: [
        Icon(Icons.wrong_location_outlined, color: AppColors.blue, size: 42),
        SizedBox(height: 10),
        Text('No map objects visible',
            style:
                TextStyle(color: AppColors.navy, fontWeight: FontWeight.w800)),
        SizedBox(height: 4),
        Text('Adjust ward or layer filters.', style: TextStyle(fontSize: 9))
      ]));
}
