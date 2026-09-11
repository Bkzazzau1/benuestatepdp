part of 'situation_room_page.dart';

class _ConsolePage extends StatelessWidget {
  const _ConsolePage(
      {required this.title, required this.icon, required this.onOpenIncident});
  final String title;
  final IconData icon;
  final ValueChanged<String> onOpenIncident;
  @override
  Widget build(BuildContext context) => Padding(
      padding: const EdgeInsets.all(24),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Container(
              width: 45,
              height: 45,
              decoration: BoxDecoration(
                  color: AppColors.blue.withValues(alpha: .1),
                  borderRadius: BorderRadius.circular(13)),
              child: Icon(icon, color: AppColors.blue)),
          const SizedBox(width: 13),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title, style: Theme.of(context).textTheme.headlineMedium),
            const Text('Live, scope-aware operational workspace')
          ]),
          const Spacer(),
          OutlinedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.file_download_outlined),
              label: const Text('Export')),
          const SizedBox(width: 8),
          FilledButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.add_rounded),
              label: Text(title == 'Communications'
                  ? 'Start secure call'
                  : 'New action'))
        ]),
        const SizedBox(height: 22),
        Expanded(
            child: Row(children: [
          Expanded(
              flex: 3,
              child: _Panel(
                  title: '$title workspace',
                  subtitle: 'Showing authorized records in All wards',
                  child: ListView.separated(
                      itemCount: 8,
                      separatorBuilder: (_, __) => const Divider(height: 1),
                      itemBuilder: (_, i) => ListTile(
                          onTap: () => title == 'Incidents'
                              ? onOpenIncident('INC-00${518 - i}')
                              : null,
                          leading: CircleAvatar(
                              backgroundColor:
                                  (i < 2 ? AppColors.red : AppColors.blue)
                                      .withValues(alpha: .1),
                              child: Icon(icon,
                                  size: 18,
                                  color:
                                      i < 2 ? AppColors.red : AppColors.blue)),
                          title: Text(
                              '${title.toUpperCase()}-${(i + 1).toString().padLeft(3, '0')}',
                              style: const TextStyle(
                                  fontSize: 11, fontWeight: FontWeight.w800)),
                          subtitle: Text(
                              i.isEven
                                  ? 'Kwarbai \'A\' • updated ${i + 2}m ago'
                                  : 'Gyallesu • updated ${i + 5}m ago',
                              style: const TextStyle(fontSize: 10)),
                          trailing:
                              Row(mainAxisSize: MainAxisSize.min, children: [
                            StatusPill(
                                i < 2 ? 'REQUIRES ACTION' : 'UNDER REVIEW',
                                color: i < 2 ? AppColors.red : AppColors.amber),
                            const SizedBox(width: 8),
                            const Icon(Icons.chevron_right_rounded)
                          ]))))),
          const SizedBox(width: 16),
          const Expanded(
              child: _Panel(
                  title: 'Operational context',
                  subtitle: 'Select an item to inspect its source trail',
                  child: Padding(
                      padding: EdgeInsets.all(28),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.manage_search_rounded,
                                color: AppColors.blue, size: 44),
                            SizedBox(height: 13),
                            Text('Source traceability',
                                style: TextStyle(
                                    color: AppColors.navy,
                                    fontWeight: FontWeight.w800)),
                            SizedBox(height: 6),
                            Text(
                                'Each item preserves source, time, location context, verification state and audit history.',
                                textAlign: TextAlign.center)
                          ]))))
        ])),
      ]));
}
