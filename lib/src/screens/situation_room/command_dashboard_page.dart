part of 'situation_room_page.dart';

class _CommandDashboard extends StatelessWidget {
  const _CommandDashboard(
      {required this.acknowledged,
      required this.readOnly,
      required this.onAcknowledge,
      required this.onOpenIncident});
  final Set<String> acknowledged;
  final bool readOnly;
  final ValueChanged<String> onAcknowledge;
  final ValueChanged<String> onOpenIncident;

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
            Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  Text('Command dashboard',
                      style: Theme.of(context).textTheme.headlineMedium),
                  const SizedBox(height: 5),
                  const Text(
                      'Live operational picture across Zaria Federal Constituency, Kaduna State.'),
                ])),
            OutlinedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.history_rounded, size: 18),
                label: const Text('Historical replay')),
            const SizedBox(width: 8),
            FilledButton.icon(
                onPressed: readOnly ? null : () {},
                icon: const Icon(Icons.add_rounded, size: 18),
                label: const Text('Create incident')),
          ]),
          const SizedBox(height: 22),
          const Row(children: [
            Expanded(
                child: _MetricCard('ONLINE AGENTS', '184', 'of 206 assigned',
                    AppColors.green, Icons.groups_outlined)),
            SizedBox(width: 10),
            Expanded(
                child: _MetricCard('OPEN INCIDENTS', '23', '4 critical',
                    AppColors.red, Icons.warning_amber_rounded)),
            SizedBox(width: 10),
            Expanded(
                child: _MetricCard('PENDING REVIEW', '12', '3 high priority',
                    AppColors.amber, Icons.fact_check_outlined)),
            SizedBox(width: 10),
            Expanded(
                child: _MetricCard('ACTIVE WARDS', '12', 'of 13 reporting',
                    AppColors.blue, Icons.map_outlined)),
            SizedBox(width: 10),
            Expanded(
                child: _MetricCard('COMMS HEALTH', '96%', '3 degraded',
                    Color(0xFF7657C8), Icons.headset_mic_outlined)),
          ]),
          const SizedBox(height: 18),
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Expanded(
                flex: 7,
                child: Column(children: [
                  _OperationsMap(onOpenIncident: onOpenIncident),
                  const SizedBox(height: 16),
                  _IncidentQueue(onOpenIncident: onOpenIncident),
                ])),
            const SizedBox(width: 16),
            Expanded(
                flex: 4,
                child: Column(children: [
                  _AlertRail(
                      acknowledged: acknowledged,
                      readOnly: readOnly,
                      onAcknowledge: onAcknowledge,
                      onOpenIncident: onOpenIncident),
                  const SizedBox(height: 16),
                  const _VerificationQueue(),
                  const SizedBox(height: 16),
                  const _CommsPanel(),
                ])),
          ]),
        ]),
      );
}

class _MetricCard extends StatelessWidget {
  const _MetricCard(this.label, this.value, this.detail, this.color, this.icon);
  final String label, value, detail;
  final Color color;
  final IconData icon;
  @override
  Widget build(BuildContext context) => Card(
          child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(children: [
          Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                  color: color.withValues(alpha: .1),
                  borderRadius: BorderRadius.circular(11)),
              child: Icon(icon, color: color, size: 20)),
          const SizedBox(width: 11),
          Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                Text(label,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        color: AppColors.muted,
                        fontSize: 9,
                        fontWeight: FontWeight.w800,
                        letterSpacing: .6)),
                const SizedBox(height: 4),
                Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
                  Text(value,
                      style: const TextStyle(
                          color: AppColors.navy,
                          fontSize: 23,
                          fontWeight: FontWeight.w900)),
                  const SizedBox(width: 6),
                  Expanded(
                      child: Padding(
                          padding: const EdgeInsets.only(bottom: 3),
                          child: Text(detail,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  color: color,
                                  fontSize: 9,
                                  fontWeight: FontWeight.w700))))
                ]),
              ])),
        ]),
      ));
}

class _Panel extends StatelessWidget {
  const _Panel(
      {required this.title,
      required this.subtitle,
      required this.child,
      this.trailing});
  final String title, subtitle;
  final Widget child;
  final Widget? trailing;
  @override
  Widget build(BuildContext context) => Card(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Padding(
            padding: const EdgeInsets.fromLTRB(17, 15, 12, 13),
            child: Row(children: [
              Expanded(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                    Text(title,
                        style: const TextStyle(
                            color: AppColors.navy,
                            fontWeight: FontWeight.w800)),
                    const SizedBox(height: 2),
                    Text(subtitle, style: const TextStyle(fontSize: 10))
                  ])),
              if (trailing != null) trailing!
            ])),
        const Divider(height: 1),
        child,
      ]));
}

class _OperationsMap extends StatelessWidget {
  const _OperationsMap({required this.onOpenIncident});
  final ValueChanged<String> onOpenIncident;
  @override
  Widget build(BuildContext context) => _Panel(
        title: 'Live operational map',
        subtitle:
            'Authorized operational locations • freshness shown per marker',
        trailing: TextButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.open_in_full_rounded, size: 15),
            label: const Text('Open map')),
        child: SizedBox(
            height: 310,
            child: Stack(children: [
              Positioned.fill(child: CustomPaint(painter: _MapPainter())),
              Positioned(left: 38, top: 24, child: _MapLegend()),
              Positioned(
                  left: 285,
                  top: 105,
                  child: _MapPin(
                      color: AppColors.red,
                      label: 'INC-00518',
                      onTap: () => onOpenIncident('INC-00518'))),
              const Positioned(
                  left: 480,
                  top: 72,
                  child: _MapPin(
                      color: AppColors.amber,
                      label: 'Review',
                      icon: Icons.fact_check_outlined)),
              const Positioned(
                  left: 380,
                  top: 205,
                  child: _MapPin(
                      color: AppColors.green,
                      label: 'Agent 041',
                      icon: Icons.person_pin_circle_outlined)),
              const Positioned(
                  right: 70,
                  bottom: 48,
                  child: _MapPin(
                      color: AppColors.blue,
                      label: 'PU-014',
                      icon: Icons.how_to_vote_outlined)),
              Positioned(
                  right: 14,
                  bottom: 14,
                  child: Column(children: [
                    _MapControl(icon: Icons.add_rounded, onTap: () {}),
                    const SizedBox(height: 4),
                    _MapControl(icon: Icons.remove_rounded, onTap: () {}),
                    const SizedBox(height: 4),
                    _MapControl(icon: Icons.my_location_rounded, onTap: () {}),
                  ])),
            ])),
      );
}

class _MapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final bg = Paint()..color = const Color(0xFFE8EDF1);
    canvas.drawRect(Offset.zero & size, bg);
    final road = Paint()
      ..color = Colors.white
      ..strokeWidth = 9
      ..style = PaintingStyle.stroke;
    final minor = Paint()
      ..color = const Color(0xFFD3DCE4)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;
    final river = Paint()
      ..color = const Color(0xFFB9DDE7)
      ..strokeWidth = 18
      ..style = PaintingStyle.stroke;
    canvas.drawPath(
        Path()
          ..moveTo(0, size.height * .75)
          ..cubicTo(size.width * .25, size.height * .45, size.width * .55,
              size.height * 1.05, size.width, size.height * .58),
        river);
    for (var i = 1; i < 7; i++) {
      final x = size.width * i / 7;
      canvas.drawPath(
          Path()
            ..moveTo(x, 0)
            ..cubicTo(x - 55, size.height * .32, x + 65, size.height * .65,
                x - 20, size.height),
          i.isEven ? road : minor);
    }
    for (var i = 1; i < 5; i++) {
      final y = size.height * i / 5;
      canvas.drawPath(
          Path()
            ..moveTo(0, y)
            ..cubicTo(size.width * .3, y + 35, size.width * .65, y - 30,
                size.width, y + 8),
          i == 2 ? road : minor);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _MapLegend extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: .94),
            borderRadius: BorderRadius.circular(9),
            boxShadow: const [
              BoxShadow(color: Color(0x18000000), blurRadius: 12)
            ]),
        child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('MAP STATUS',
                  style: TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.w900,
                      letterSpacing: .7)),
              SizedBox(height: 7),
              _LegendItem(AppColors.red, 'Critical incident'),
              _LegendItem(AppColors.amber, 'Verification pending'),
              _LegendItem(AppColors.green, 'Agent online'),
              _LegendItem(AppColors.blue, 'Polling unit'),
            ]),
      );
}

class _LegendItem extends StatelessWidget {
  const _LegendItem(this.color, this.text);
  final Color color;
  final String text;
  @override
  Widget build(BuildContext context) => Padding(
      padding: const EdgeInsets.only(top: 3),
      child: Row(children: [
        Icon(Icons.circle, color: color, size: 7),
        const SizedBox(width: 6),
        Text(text, style: const TextStyle(fontSize: 9, color: AppColors.navy))
      ]));
}

class _MapPin extends StatelessWidget {
  const _MapPin(
      {required this.color,
      required this.label,
      this.icon = Icons.warning_rounded,
      this.onTap});
  final Color color;
  final String label;
  final IconData icon;
  final VoidCallback? onTap;
  @override
  Widget build(BuildContext context) => InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
          padding: const EdgeInsets.fromLTRB(7, 5, 10, 5),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: const [
                BoxShadow(color: Color(0x26000000), blurRadius: 9)
              ]),
          child: Row(children: [
            CircleAvatar(
                radius: 12,
                backgroundColor: color,
                child: Icon(icon, size: 13, color: Colors.white)),
            const SizedBox(width: 6),
            Text(label,
                style: const TextStyle(
                    color: AppColors.navy,
                    fontSize: 9,
                    fontWeight: FontWeight.w800))
          ])));
}

class _MapControl extends StatelessWidget {
  const _MapControl({required this.icon, required this.onTap});
  final IconData icon;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
          onTap: onTap,
          child: SizedBox(width: 34, height: 34, child: Icon(icon, size: 18))));
}

class _IncidentQueue extends StatelessWidget {
  const _IncidentQueue({required this.onOpenIncident});
  final ValueChanged<String> onOpenIncident;
  @override
  Widget build(BuildContext context) => _Panel(
      title: 'Priority incident queue',
      subtitle: 'Ordered by severity and response SLA',
      trailing: TextButton(onPressed: () {}, child: const Text('View all 23')),
      child: Column(children: [
        _IncidentRow(
            id: 'INC-00518',
            title: 'Reported disturbance at PU-014',
            location: 'Kwarbai \'A\'',
            owner: 'M. Bello',
            age: '11m',
            sla: '04:18',
            color: AppColors.red,
            onTap: () => onOpenIncident('INC-00518')),
        const Divider(height: 1),
        _IncidentRow(
            id: 'INC-00512',
            title: 'Access disruption near entrance',
            location: 'Tudun Wada',
            owner: 'Unassigned',
            age: '24m',
            sla: '12:06',
            color: AppColors.red,
            onTap: () => onOpenIncident('INC-00512')),
        const Divider(height: 1),
        _IncidentRow(
            id: 'INC-00496',
            title: 'Communication loss with field team',
            location: 'Gyallesu',
            owner: 'T. Musa',
            age: '37m',
            sla: '22:41',
            color: AppColors.amber,
            onTap: () => onOpenIncident('INC-00496')),
      ]));
}

class _IncidentRow extends StatelessWidget {
  const _IncidentRow(
      {required this.id,
      required this.title,
      required this.location,
      required this.owner,
      required this.age,
      required this.sla,
      required this.color,
      required this.onTap});
  final String id, title, location, owner, age, sla;
  final Color color;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => InkWell(
      onTap: onTap,
      child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(children: [
            Container(
                width: 4,
                height: 42,
                decoration: BoxDecoration(
                    color: color, borderRadius: BorderRadius.circular(4))),
            const SizedBox(width: 11),
            Expanded(
                flex: 4,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(children: [
                        Text(id,
                            style: const TextStyle(
                                fontSize: 10, fontWeight: FontWeight.w900)),
                        const SizedBox(width: 8),
                        StatusPill(color == AppColors.red ? 'CRITICAL' : 'HIGH',
                            color: color)
                      ]),
                      const SizedBox(height: 5),
                      Text(title,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              color: AppColors.navy,
                              fontWeight: FontWeight.w700,
                              fontSize: 12))
                    ])),
            Expanded(child: _MiniValue('LOCATION', location)),
            Expanded(child: _MiniValue('OWNER', owner)),
            _MiniValue('AGE', age),
            const SizedBox(width: 18),
            Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
              const Text('SLA',
                  style: TextStyle(
                      fontSize: 8,
                      color: AppColors.muted,
                      fontWeight: FontWeight.w800)),
              Text(sla,
                  style: TextStyle(
                      color: color, fontWeight: FontWeight.w900, fontSize: 13))
            ]),
            const SizedBox(width: 4),
            const Icon(Icons.chevron_right_rounded, color: AppColors.muted),
          ])));
}

class _MiniValue extends StatelessWidget {
  const _MiniValue(this.label, this.value);
  final String label, value;
  @override
  Widget build(BuildContext context) =>
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(label,
            style: const TextStyle(
                color: AppColors.muted,
                fontSize: 8,
                fontWeight: FontWeight.w800)),
        const SizedBox(height: 4),
        Text(value,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
                color: AppColors.navy,
                fontSize: 10,
                fontWeight: FontWeight.w700))
      ]);
}

class _AlertRail extends StatelessWidget {
  const _AlertRail(
      {required this.acknowledged,
      required this.readOnly,
      required this.onAcknowledge,
      required this.onOpenIncident});
  final Set<String> acknowledged;
  final bool readOnly;
  final ValueChanged<String> onAcknowledge;
  final ValueChanged<String> onOpenIncident;
  @override
  Widget build(BuildContext context) => _Panel(
      title: 'Priority alerts',
      subtitle: '4 require acknowledgement',
      trailing: IconButton(
          onPressed: () {}, icon: const Icon(Icons.tune_rounded, size: 18)),
      child: Column(children: [
        _AlertItem(
            id: 'ALT-0092',
            title: 'Agent SOS received',
            detail: 'Kwarbai \'A\' • Agent AGT-041 • 2m',
            color: AppColors.red,
            acknowledged: acknowledged.contains('ALT-0092'),
            onAck: readOnly ? null : () => onAcknowledge('ALT-0092'),
            onOpen: () => onOpenIncident('INC-00518')),
        const Divider(height: 1),
        _AlertItem(
            id: 'ALT-0089',
            title: 'Location discrepancy',
            detail: 'Tudun Wada • Report RPT-201 • 7m',
            color: AppColors.amber,
            acknowledged: acknowledged.contains('ALT-0089'),
            onAck: readOnly ? null : () => onAcknowledge('ALT-0089'),
            onOpen: () {}),
        const Divider(height: 1),
        _AlertItem(
            id: 'ALT-0084',
            title: 'Evidence upload repeatedly failed',
            detail: 'Gyallesu • Agent AGT-088 • 14m',
            color: AppColors.amber,
            acknowledged: acknowledged.contains('ALT-0084'),
            onAck: readOnly ? null : () => onAcknowledge('ALT-0084'),
            onOpen: () {}),
      ]));
}

class _AlertItem extends StatelessWidget {
  const _AlertItem(
      {required this.id,
      required this.title,
      required this.detail,
      required this.color,
      required this.acknowledged,
      required this.onAck,
      required this.onOpen});
  final String id, title, detail;
  final Color color;
  final bool acknowledged;
  final VoidCallback? onAck;
  final VoidCallback onOpen;
  @override
  Widget build(BuildContext context) => Padding(
      padding: const EdgeInsets.all(13),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
                color: color.withValues(alpha: .1),
                borderRadius: BorderRadius.circular(9)),
            child: Icon(Icons.notifications_active_outlined,
                color: color, size: 16)),
        const SizedBox(width: 10),
        Expanded(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title,
              style: const TextStyle(
                  color: AppColors.navy,
                  fontSize: 12,
                  fontWeight: FontWeight.w800)),
          const SizedBox(height: 3),
          Text(detail, style: const TextStyle(fontSize: 9)),
          const SizedBox(height: 8),
          Row(children: [
            TextButton(
                onPressed: onOpen,
                style: TextButton.styleFrom(
                    padding: EdgeInsets.zero, minimumSize: const Size(0, 28)),
                child: const Text('Open')),
            const SizedBox(width: 12),
            if (acknowledged)
              const StatusPill('ACKNOWLEDGED', color: AppColors.green)
            else
              OutlinedButton(
                  onPressed: onAck,
                  style: OutlinedButton.styleFrom(
                      minimumSize: const Size(0, 28),
                      padding: const EdgeInsets.symmetric(horizontal: 10)),
                  child:
                      const Text('Acknowledge', style: TextStyle(fontSize: 10)))
          ])
        ])),
      ]));
}

class _VerificationQueue extends StatelessWidget {
  const _VerificationQueue();
  @override
  Widget build(BuildContext context) => _Panel(
      title: 'Verification queue',
      subtitle: 'Raw submissions are not confirmed facts',
      trailing: TextButton(onPressed: () {}, child: const Text('Review')),
      child: const Column(children: [
        _QueueItem(Icons.location_off_outlined, AppColors.red,
            'Location discrepancy', 'RPT-2026-00201 • 6m'),
        Divider(height: 1),
        _QueueItem(Icons.compare_arrows_rounded, AppColors.amber,
            'Potential source conflict', '3 related reports • 12m'),
        Divider(height: 1),
        _QueueItem(Icons.cloud_upload_outlined, AppColors.blue,
            'Evidence pending upload', 'RPT-2026-00194 • 18m'),
      ]));
}

class _QueueItem extends StatelessWidget {
  const _QueueItem(this.icon, this.color, this.title, this.detail);
  final IconData icon;
  final Color color;
  final String title, detail;
  @override
  Widget build(BuildContext context) => ListTile(
      dense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 13, vertical: 3),
      leading: Icon(icon, color: color, size: 19),
      title: Text(title,
          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700)),
      subtitle: Text(detail, style: const TextStyle(fontSize: 9)),
      trailing: const Icon(Icons.chevron_right_rounded, size: 18));
}

class _CommsPanel extends StatelessWidget {
  const _CommsPanel();
  @override
  Widget build(BuildContext context) => _Panel(
      title: 'Secure communications',
      subtitle: 'Consent-aware live sessions',
      child: const Padding(
          padding: EdgeInsets.all(14),
          child: Row(children: [
            Expanded(
                child: _CommsStat(
                    Icons.call_rounded, AppColors.green, '7', 'Active calls')),
            SizedBox(width: 8),
            Expanded(
                child: _CommsStat(Icons.videocam_outlined, AppColors.blue, '3',
                    'Media requests')),
            SizedBox(width: 8),
            Expanded(
                child: _CommsStat(
                    Icons.signal_cellular_connected_no_internet_0_bar_rounded,
                    AppColors.amber,
                    '3',
                    'Degraded')),
          ])));
}

class _CommsStat extends StatelessWidget {
  const _CommsStat(this.icon, this.color, this.value, this.label);
  final IconData icon;
  final Color color;
  final String value, label;
  @override
  Widget build(BuildContext context) => Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: color.withValues(alpha: .07),
          borderRadius: BorderRadius.circular(10)),
      child: Column(children: [
        Icon(icon, size: 17, color: color),
        const SizedBox(height: 4),
        Text(value,
            style: const TextStyle(
                color: AppColors.navy,
                fontWeight: FontWeight.w900,
                fontSize: 16)),
        Text(label,
            textAlign: TextAlign.center, style: const TextStyle(fontSize: 8))
      ]));
}
