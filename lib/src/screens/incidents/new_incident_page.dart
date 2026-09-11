import 'package:flutter/material.dart';
import 'package:polisphere/src/theme/app_theme.dart';
import 'package:polisphere/src/widgets/common.dart';

class NewIncidentPage extends StatefulWidget {
  const NewIncidentPage({super.key});

  @override
  State<NewIncidentPage> createState() => _NewIncidentPageState();
}

class _NewIncidentPageState extends State<NewIncidentPage> {
  String _severity = 'Medium';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Report incident')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(18, 8, 18, 30),
        children: [
          const InfoNotice(
            'For immediate danger, use SOS. Incident reports are reviewed '
            'by the Situation Room.',
            danger: true,
          ),
          const SizedBox(height: 18),
          DropdownButtonFormField<String>(
            initialValue: 'Operational disruption',
            decoration: const InputDecoration(labelText: 'Incident category'),
            items: [
              'Operational disruption',
              'Safety concern',
              'Communication loss',
              'Crowd escalation',
            ]
                .map((value) => DropdownMenuItem(
                      value: value,
                      child: Text(value),
                    ))
                .toList(),
            onChanged: (_) {},
          ),
          const SizedBox(height: 14),
          TextFormField(
            minLines: 5,
            maxLines: 8,
            decoration: const InputDecoration(
              labelText: 'Describe the incident',
              alignLabelWithHint: true,
            ),
          ),
          const SizedBox(height: 18),
          const FormLabel('SEVERITY'),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: ['Low', 'Medium', 'High', 'Critical']
                .map((value) => ChoiceChip(
                      label: Text(value),
                      selected: _severity == value,
                      onSelected: (_) => setState(() => _severity = value),
                    ))
                .toList(),
          ),
          const SizedBox(height: 18),
          Card(
            child: Column(children: [
              const ListTile(
                leading: Icon(
                  Icons.my_location_rounded,
                  color: AppColors.green,
                ),
                title: Text(
                  'Current GPS attached',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                subtitle: Text('Location is an indicator for verification'),
              ),
              const Divider(height: 1),
              ListTile(
                onTap: () {},
                leading: const Icon(
                  Icons.camera_alt_outlined,
                  color: AppColors.blue,
                ),
                title: const Text(
                  'Add supporting evidence',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                trailing: const Icon(Icons.chevron_right_rounded),
              ),
            ]),
          ),
          const SizedBox(height: 24),
          FilledButton.icon(
            style: FilledButton.styleFrom(backgroundColor: AppColors.red),
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.warning_amber_rounded),
            label: const Text('Submit incident'),
          ),
        ],
      ),
    );
  }
}
