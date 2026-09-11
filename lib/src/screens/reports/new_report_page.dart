import 'package:flutter/material.dart';
import 'package:polisphere/src/theme/app_theme.dart';
import 'package:polisphere/src/widgets/common.dart';

class NewReportPage extends StatefulWidget {
  const NewReportPage({super.key});

  @override
  State<NewReportPage> createState() => _NewReportPageState();
}

class _NewReportPageState extends State<NewReportPage> {
  String _category = 'Routine status';
  String _severity = 'Informational';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('New situation report')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(18, 8, 18, 30),
        children: [
          const InfoNotice(
            'Your submission remains marked as field-reported until an '
            'authorized officer verifies it.',
          ),
          const SizedBox(height: 20),
          const FormLabel('REPORT DETAILS'),
          const SizedBox(height: 9),
          DropdownButtonFormField<String>(
            initialValue: _category,
            decoration: const InputDecoration(labelText: 'Category'),
            items: [
              'Routine status',
              'Campaign activity',
              'Community issue',
              'Logistics',
            ]
                .map((value) => DropdownMenuItem(
                      value: value,
                      child: Text(value),
                    ))
                .toList(),
            onChanged: (value) => setState(() => _category = value!),
          ),
          const SizedBox(height: 14),
          TextFormField(
            minLines: 5,
            maxLines: 8,
            decoration: const InputDecoration(
              labelText: 'What is happening?',
              alignLabelWithHint: true,
              hintText: 'Provide a factual, direct account...',
            ),
          ),
          const SizedBox(height: 20),
          const FormLabel('SEVERITY'),
          const SizedBox(height: 9),
          Wrap(
            spacing: 8,
            children: ['Informational', 'Low', 'Medium', 'High']
                .map((value) => ChoiceChip(
                      label: Text(value),
                      selected: _severity == value,
                      onSelected: (_) => setState(() => _severity = value),
                    ))
                .toList(),
          ),
          const SizedBox(height: 22),
          const FormLabel('LOCATION & EVIDENCE'),
          const SizedBox(height: 9),
          Card(
            child: Column(children: [
              const ListTile(
                leading: Icon(
                  Icons.location_on_outlined,
                  color: AppColors.green,
                ),
                title: Text(
                  'GPS captured',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                subtitle: Text('Accuracy 12 m · captured just now'),
                trailing: Icon(Icons.check_circle, color: AppColors.green),
              ),
              const Divider(height: 1),
              ListTile(
                onTap: () {},
                leading: const Icon(
                  Icons.add_a_photo_outlined,
                  color: AppColors.blue,
                ),
                title: const Text(
                  'Add evidence',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                subtitle: const Text('Photo, video, audio, or document'),
                trailing: const Icon(Icons.chevron_right_rounded),
              ),
            ]),
          ),
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: () => _submit(context),
            icon: const Icon(Icons.send_rounded),
            label: const Text('Submit report'),
          ),
          TextButton(
            onPressed: () {},
            child: const Text('Save encrypted draft'),
          ),
        ],
      ),
    );
  }

  void _submit(BuildContext context) {
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Report submitted for human verification.'),
      ),
    );
  }
}
