import 'package:flutter/material.dart';

import 'app_scope.dart';
import 'domain/models.dart';
import 'domain/records_store.dart';
import 'widgets.dart';

class CommandActionsBar extends StatelessWidget {
  const CommandActionsBar({super.key, required this.onOpenMap});

  final VoidCallback onOpenMap;

  @override
  Widget build(BuildContext context) {
    final scope = CampaignScope.of(context);
    final scoped = scope.lgaId != null;

    return Material(
      color: const Color(0xFFF8FAF8),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(14, 8, 14, 9),
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: Color(0xFFE2EAE4))),
        ),
        child: Row(
          children: [
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _ActionButton(
                      icon: Icons.warning_amber_rounded,
                      label: 'New incident',
                      onPressed: () => _newIncident(context),
                    ),
                    _ActionButton(
                      icon: Icons.task_alt_outlined,
                      label: 'New task',
                      onPressed: () => _newTask(context),
                    ),
                    _ActionButton(
                      icon: Icons.feed_outlined,
                      label: 'Field report',
                      onPressed: () => _newFieldReport(context),
                    ),
                    _ActionButton(
                      icon: Icons.event_available_outlined,
                      label: 'Activity',
                      onPressed: () => _newActivity(context),
                    ),
                    _ActionButton(
                      icon: Icons.inventory_2_outlined,
                      label: 'Asset',
                      onPressed: () => _newAsset(context),
                    ),
                    _ActionButton(
                      icon: Icons.person_add_alt_1_rounded,
                      label: 'Field person',
                      onPressed: () => _newFieldPerson(context),
                    ),
                    _ActionButton(
                      icon: Icons.login_rounded,
                      label: 'Check-in',
                      onPressed: () => _checkInCentre(context),
                    ),
                    _ActionButton(
                      icon: Icons.speed_rounded,
                      label: 'Readiness',
                      onPressed: () => _readiness(context),
                    ),
                    _ActionButton(
                      icon: Icons.tune_rounded,
                      label: 'Update status',
                      onPressed: () => _statusCentre(context),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 10),
            StatusPill(
              scoped ? 'EDITING ${scope.shortLabel.toUpperCase()}' : 'SELECT LGA TO EDIT',
              color: scoped ? pdpGreen : const Color(0xFFD68A00),
            ),
          ],
        ),
      ),
    );
  }

  bool _requireLga(BuildContext context) {
    final scope = CampaignScope.of(context, listen: false);
    if (scope.lgaId != null) return true;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        content: const Text(
          'Choose an LGA in Benue Map before creating or changing operational records.',
        ),
        action: SnackBarAction(label: 'OPEN MAP', onPressed: onOpenMap),
      ),
    );
    return false;
  }

  GeographicScope _scope(BuildContext context) {
    final active = CampaignScope.of(context, listen: false);
    if (active.pollingUnitId != null) {
      return GeographicScope(
        level: GeographyLevel.pollingUnit,
        state: 'Benue',
        lgaId: active.lgaId,
        lga: active.lgaName,
        wardId: active.wardId,
        ward: active.wardName,
        pollingUnitId: active.pollingUnitId,
        pollingUnit: active.pollingUnitName,
      );
    }
    if (active.wardId != null) {
      return GeographicScope(
        level: GeographyLevel.ward,
        state: 'Benue',
        lgaId: active.lgaId,
        lga: active.lgaName,
        wardId: active.wardId,
        ward: active.wardName,
      );
    }
    return GeographicScope(
      level: GeographyLevel.lga,
      state: 'Benue',
      lgaId: active.lgaId,
      lga: active.lgaName,
    );
  }

  CampaignRecordsController _records(BuildContext context) =>
      CampaignRecords.of(context, listen: false);

  String _operatorId(BuildContext context) {
    final scope = CampaignScope.of(context, listen: false);
    final users = _records(context).usersFor(scope.lgaId);
    return users.isEmpty ? 'SYSTEM' : users.first.id;
  }

  void _done(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
    );
  }

  Future<void> _newIncident(BuildContext context) async {
    if (!_requireLga(context)) return;
    final title = TextEditingController();
    final category = TextEditingController(text: 'Operations');
    final summary = TextEditingController();
    var severity = IncidentSeverity.medium;

    final save = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setLocal) => AlertDialog(
          title: const Text('Report new incident'),
          content: SizedBox(
            width: 520,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _scopeNotice(context),
                  const SizedBox(height: 12),
                  TextField(
                    controller: title,
                    autofocus: true,
                    decoration: const InputDecoration(labelText: 'Incident title *'),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: category,
                    decoration: const InputDecoration(labelText: 'Category *'),
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<IncidentSeverity>(
                    value: severity,
                    decoration: const InputDecoration(labelText: 'Severity'),
                    items: IncidentSeverity.values
                        .map((item) => DropdownMenuItem(
                              value: item,
                              child: Text(_label(item)),
                            ))
                        .toList(),
                    onChanged: (value) {
                      if (value != null) setLocal(() => severity = value);
                    },
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: summary,
                    minLines: 3,
                    maxLines: 6,
                    decoration: const InputDecoration(labelText: 'Summary / evidence note'),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text('Cancel'),
            ),
            FilledButton.icon(
              onPressed: () => Navigator.pop(dialogContext, true),
              icon: const Icon(Icons.warning_amber_rounded),
              label: const Text('Create incident'),
            ),
          ],
        ),
      ),
    );

    if (save == true && title.text.trim().isNotEmpty && category.text.trim().isNotEmpty) {
      final records = _records(context);
      final activeScope = _scope(context);
      final id = records.nextId('INC', lgaId: activeScope.lgaId);
      records.addIncident(
        CampaignIncident(
          id: id,
          title: title.text.trim(),
          category: category.text.trim(),
          severity: severity,
          status: IncidentStatus.reported,
          scope: activeScope,
          reportedAt: DateTime.now().toUtc(),
          reporterId: _operatorId(context),
          assignedTeam: '${activeScope.lga} Operations',
          conversationId: 'ROOM-$id',
          summary: summary.text.trim().isEmpty ? null : summary.text.trim(),
          origin: RecordOrigin.campaignEntry,
        ),
        actorId: _operatorId(context),
      );
      _done(context, '$id created and linked to ${activeScope.label}.');
    }
    title.dispose();
    category.dispose();
    summary.dispose();
  }

  Future<void> _newTask(BuildContext context) async {
    if (!_requireLga(context)) return;
    final records = _records(context);
    final scopeController = CampaignScope.of(context, listen: false);
    final users = records.usersFor(scopeController.lgaId);
    final incidents = records.incidentsFor(scopeController.lgaId);
    if (users.isEmpty) {
      _done(context, 'Add a field person before assigning a task.');
      return;
    }

    final title = TextEditingController();
    var ownerId = users.first.id;
    var priority = IncidentSeverity.medium;
    String? incidentId;

    final save = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setLocal) => AlertDialog(
          title: const Text('Create operational task'),
          content: SizedBox(
            width: 520,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _scopeNotice(context),
                const SizedBox(height: 12),
                TextField(
                  controller: title,
                  autofocus: true,
                  decoration: const InputDecoration(labelText: 'Task title *'),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: ownerId,
                  decoration: const InputDecoration(labelText: 'Owner'),
                  items: users
                      .map((user) => DropdownMenuItem(
                            value: user.id,
                            child: Text(user.displayName),
                          ))
                      .toList(),
                  onChanged: (value) {
                    if (value != null) setLocal(() => ownerId = value);
                  },
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<IncidentSeverity>(
                  value: priority,
                  decoration: const InputDecoration(labelText: 'Priority'),
                  items: IncidentSeverity.values
                      .map((item) => DropdownMenuItem(
                            value: item,
                            child: Text(_label(item)),
                          ))
                      .toList(),
                  onChanged: (value) {
                    if (value != null) setLocal(() => priority = value);
                  },
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String?>(
                  value: incidentId,
                  decoration: const InputDecoration(labelText: 'Linked incident (optional)'),
                  items: [
                    const DropdownMenuItem<String?>(
                      value: null,
                      child: Text('No incident link'),
                    ),
                    ...incidents.map((incident) => DropdownMenuItem<String?>(
                          value: incident.id,
                          child: Text('${incident.id} — ${incident.title}'),
                        )),
                  ],
                  onChanged: (value) => setLocal(() => incidentId = value),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              child: const Text('Create task'),
            ),
          ],
        ),
      ),
    );

    if (save == true && title.text.trim().isNotEmpty) {
      final activeScope = _scope(context);
      final id = records.nextId('TSK', lgaId: activeScope.lgaId);
      records.addTask(
        CampaignTask(
          id: id,
          title: title.text.trim(),
          ownerId: ownerId,
          scope: activeScope,
          status: TaskStatus.open,
          priority: priority,
          createdAt: DateTime.now().toUtc(),
          dueAt: DateTime.now().toUtc().add(const Duration(days: 1)),
          incidentId: incidentId,
          origin: RecordOrigin.campaignEntry,
        ),
        actorId: _operatorId(context),
      );
      _done(context, '$id created. Command Overview and Logistics are updated.');
    }
    title.dispose();
  }

  Future<void> _newFieldReport(BuildContext context) async {
    if (!_requireLga(context)) return;
    final records = _records(context);
    final active = CampaignScope.of(context, listen: false);
    final incidents = records.incidentsFor(active.lgaId);
    final category = TextEditingController(text: 'Operations update');
    final summary = TextEditingController();
    String? incidentId;

    final save = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setLocal) => AlertDialog(
          title: const Text('Submit field report'),
          content: SizedBox(
            width: 520,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _scopeNotice(context),
                const SizedBox(height: 12),
                TextField(
                  controller: category,
                  decoration: const InputDecoration(labelText: 'Category *'),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: summary,
                  minLines: 4,
                  maxLines: 7,
                  decoration: const InputDecoration(labelText: 'Report summary *'),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String?>(
                  value: incidentId,
                  decoration: const InputDecoration(labelText: 'Link to incident (optional)'),
                  items: [
                    const DropdownMenuItem<String?>(value: null, child: Text('No incident link')),
                    ...incidents.map((incident) => DropdownMenuItem<String?>(
                          value: incident.id,
                          child: Text('${incident.id} — ${incident.title}'),
                        )),
                  ],
                  onChanged: (value) => setLocal(() => incidentId = value),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              child: const Text('Submit report'),
            ),
          ],
        ),
      ),
    );

    if (save == true && summary.text.trim().isNotEmpty && category.text.trim().isNotEmpty) {
      final activeScope = _scope(context);
      final id = records.nextId('RPT', lgaId: activeScope.lgaId);
      records.addFieldReport(
        FieldReport(
          id: id,
          category: category.text.trim(),
          summary: summary.text.trim(),
          scope: activeScope,
          reporterId: _operatorId(context),
          reportedAt: DateTime.now().toUtc(),
          status: RecordStatus.submitted,
          incidentId: incidentId,
          origin: RecordOrigin.campaignEntry,
        ),
        actorId: _operatorId(context),
      );
      _done(context, '$id submitted to ${activeScope.label}.');
    }
    category.dispose();
    summary.dispose();
  }

  Future<void> _newActivity(BuildContext context) async {
    if (!_requireLga(context)) return;
    final title = TextEditingController();
    final category = TextEditingController(text: 'Campaign engagement');
    final note = TextEditingController();

    final save = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Schedule campaign activity'),
        content: SizedBox(
          width: 520,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _scopeNotice(context),
              const SizedBox(height: 12),
              TextField(
                controller: title,
                autofocus: true,
                decoration: const InputDecoration(labelText: 'Activity title *'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: category,
                decoration: const InputDecoration(labelText: 'Category'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: note,
                minLines: 2,
                maxLines: 4,
                decoration: const InputDecoration(labelText: 'Planning note'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Schedule'),
          ),
        ],
      ),
    );

    if (save == true && title.text.trim().isNotEmpty) {
      final records = _records(context);
      final activeScope = _scope(context);
      final id = records.nextId('ACT', lgaId: activeScope.lgaId);
      records.addActivity(
        CampaignActivity(
          id: id,
          title: title.text.trim(),
          category: category.text.trim().isEmpty ? 'Campaign engagement' : category.text.trim(),
          scope: activeScope,
          ownerUnit: '${activeScope.lga} LGA Command',
          status: ActivityStatus.planned,
          startsAt: DateTime.now().toUtc().add(const Duration(hours: 1)),
          notes: note.text.trim().isEmpty ? null : note.text.trim(),
          origin: RecordOrigin.campaignEntry,
        ),
        actorId: _operatorId(context),
      );
      _done(context, '$id added to Campaign Operations.');
    }
    title.dispose();
    category.dispose();
    note.dispose();
  }

  Future<void> _newAsset(BuildContext context) async {
    if (!_requireLga(context)) return;
    final records = _records(context);
    final active = CampaignScope.of(context, listen: false);
    final users = records.usersFor(active.lgaId);
    final name = TextEditingController();
    final category = TextEditingController(text: 'Vehicle');
    final note = TextEditingController();
    String? custodianId = users.isEmpty ? null : users.first.id;

    final save = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setLocal) => AlertDialog(
          title: const Text('Register campaign asset'),
          content: SizedBox(
            width: 520,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _scopeNotice(context),
                const SizedBox(height: 12),
                TextField(
                  controller: name,
                  autofocus: true,
                  decoration: const InputDecoration(labelText: 'Asset name *'),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: category,
                  decoration: const InputDecoration(labelText: 'Category *'),
                ),
                if (users.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String?>(
                    value: custodianId,
                    decoration: const InputDecoration(labelText: 'Custodian'),
                    items: users
                        .map((user) => DropdownMenuItem<String?>(
                              value: user.id,
                              child: Text(user.displayName),
                            ))
                        .toList(),
                    onChanged: (value) => setLocal(() => custodianId = value),
                  ),
                ],
                const SizedBox(height: 12),
                TextField(
                  controller: note,
                  decoration: const InputDecoration(labelText: 'Condition / note'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              child: const Text('Register'),
            ),
          ],
        ),
      ),
    );

    if (save == true && name.text.trim().isNotEmpty && category.text.trim().isNotEmpty) {
      final activeScope = _scope(context);
      final id = records.nextId('AST', lgaId: activeScope.lgaId);
      records.addAsset(
        CampaignAsset(
          id: id,
          name: name.text.trim(),
          category: category.text.trim(),
          scope: activeScope,
          status: AssetStatus.available,
          updatedAt: DateTime.now().toUtc(),
          custodianId: custodianId,
          conditionNote: note.text.trim().isEmpty ? null : note.text.trim(),
          origin: RecordOrigin.campaignEntry,
        ),
        actorId: _operatorId(context),
      );
      _done(context, '$id registered in Logistics & Tasks.');
    }
    name.dispose();
    category.dispose();
    note.dispose();
  }

  Future<void> _newFieldPerson(BuildContext context) async {
    if (!_requireLga(context)) return;
    final active = CampaignScope.of(context, listen: false);
    final name = TextEditingController();
    var role = CampaignRole.fieldReporter;
    final roles = <CampaignRole>[
      CampaignRole.lgaCoordinator,
      CampaignRole.fieldReporter,
      if (active.wardId != null) CampaignRole.wardCoordinator,
      if (active.pollingUnitId != null) CampaignRole.pollingUnitAgent,
    ];

    final save = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setLocal) => AlertDialog(
          title: const Text('Add field person'),
          content: SizedBox(
            width: 500,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _scopeNotice(context),
                const SizedBox(height: 12),
                TextField(
                  controller: name,
                  autofocus: true,
                  decoration: const InputDecoration(labelText: 'Display name *'),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<CampaignRole>(
                  value: role,
                  decoration: const InputDecoration(labelText: 'Role'),
                  items: roles
                      .map((item) => DropdownMenuItem(
                            value: item,
                            child: Text(_label(item)),
                          ))
                      .toList(),
                  onChanged: (value) {
                    if (value != null) setLocal(() => role = value);
                  },
                ),
                const SizedBox(height: 12),
                const Text(
                  'Ward Coordinator and Polling-Unit Agent roles unlock only when a verified ward/PU is active.',
                  style: TextStyle(color: muted, height: 1.4),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              child: const Text('Add person'),
            ),
          ],
        ),
      ),
    );

    if (save == true && name.text.trim().isNotEmpty) {
      final records = _records(context);
      final activeScope = _scope(context);
      final userId = records.nextId('USR', lgaId: activeScope.lgaId);
      final assignmentId = records.nextId('ASG', lgaId: activeScope.lgaId);
      records.addFieldPerson(
        user: CampaignUser(
          id: userId,
          displayName: name.text.trim(),
          role: role,
          scope: activeScope,
          isActive: true,
          origin: RecordOrigin.campaignEntry,
        ),
        assignment: FieldAssignment(
          id: assignmentId,
          userId: userId,
          scope: activeScope,
          role: role,
          status: AssignmentStatus.assigned,
          updatedAt: DateTime.now().toUtc(),
          origin: RecordOrigin.campaignEntry,
        ),
        actorId: _operatorId(context),
      );
      _done(context, '$userId added with assignment $assignmentId.');
    }
    name.dispose();
  }

  Future<void> _checkInCentre(BuildContext context) async {
    if (!_requireLga(context)) return;
    final active = CampaignScope.of(context, listen: false);
    final records = _records(context);
    final assignments = records.assignmentsFor(active.lgaId);

    await showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text('${active.lgaName} field check-in'),
        content: SizedBox(
          width: 560,
          height: 420,
          child: assignments.isEmpty
              ? const Center(child: Text('No assignments in this LGA.'))
              : ListView.separated(
                  itemCount: assignments.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final assignment = assignments[index];
                    final user = records.userById(assignment.userId);
                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(user?.displayName ?? assignment.userId,
                          style: const TextStyle(fontWeight: FontWeight.w900)),
                      subtitle: Text('${assignment.id} • ${_label(assignment.role)}'),
                      trailing: FilledButton.tonalIcon(
                        onPressed: () {
                          records.setAssignmentCheckIn(
                            assignment.id,
                            !assignment.checkedIn,
                            actorId: _operatorId(context),
                          );
                          Navigator.pop(dialogContext);
                          _done(
                            context,
                            '${assignment.id} ${assignment.checkedIn ? 'checked out' : 'checked in'}.',
                          );
                        },
                        icon: Icon(assignment.checkedIn ? Icons.logout : Icons.login),
                        label: Text(assignment.checkedIn ? 'Check out' : 'Check in'),
                      ),
                    );
                  },
                ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Future<void> _readiness(BuildContext context) async {
    if (!_requireLga(context)) return;
    final active = CampaignScope.of(context, listen: false);
    final records = _records(context);
    final current = records.readinessFor(active.lgaId);
    var coverage = current.isEmpty ? 0.0 : current.first.agentCoveragePercent;
    var communications = current.isNotEmpty && current.first.communicationReady;
    var logistics = current.isNotEmpty && current.first.logisticsReady;
    final note = TextEditingController(text: current.isEmpty ? '' : current.first.note ?? '');

    final save = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setLocal) => AlertDialog(
          title: Text('${active.lgaName} readiness update'),
          content: SizedBox(
            width: 520,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Agent / field coverage: ${coverage.toStringAsFixed(0)}%',
                    style: const TextStyle(fontWeight: FontWeight.w900)),
                Slider(
                  value: coverage,
                  min: 0,
                  max: 100,
                  divisions: 20,
                  label: '${coverage.toStringAsFixed(0)}%',
                  onChanged: (value) => setLocal(() => coverage = value),
                ),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Communications ready'),
                  value: communications,
                  onChanged: (value) => setLocal(() => communications = value),
                ),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Logistics ready'),
                  value: logistics,
                  onChanged: (value) => setLocal(() => logistics = value),
                ),
                TextField(
                  controller: note,
                  minLines: 2,
                  maxLines: 4,
                  decoration: const InputDecoration(labelText: 'Readiness note'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              child: const Text('Update readiness'),
            ),
          ],
        ),
      ),
    );

    if (save == true) {
      records.setReadiness(
        scope: _scope(context),
        agentCoveragePercent: coverage,
        communicationReady: communications,
        logisticsReady: logistics,
        note: note.text.trim().isEmpty ? null : note.text.trim(),
        actorId: _operatorId(context),
      );
      _done(context, '${active.lgaName} readiness updated across the system.');
    }
    note.dispose();
  }

  Future<void> _statusCentre(BuildContext context) async {
    if (!_requireLga(context)) return;
    final active = CampaignScope.of(context, listen: false);
    final records = _records(context);
    var entityType = 'Incident';
    String? entityId;
    String? targetStatus;

    List<_StatusOption> options() {
      switch (entityType) {
        case 'Task':
          return records
              .tasksFor(active.lgaId)
              .map((e) => _StatusOption(e.id, e.title))
              .toList();
        case 'Activity':
          return records
              .activitiesFor(active.lgaId)
              .map((e) => _StatusOption(e.id, e.title))
              .toList();
        case 'Asset':
          return records
              .assetsFor(active.lgaId)
              .map((e) => _StatusOption(e.id, e.name))
              .toList();
        default:
          return records
              .incidentsFor(active.lgaId)
              .map((e) => _StatusOption(e.id, e.title))
              .toList();
      }
    }

    List<String> statuses() {
      switch (entityType) {
        case 'Task':
          return TaskStatus.values.map((e) => e.name).toList();
        case 'Activity':
          return ActivityStatus.values.map((e) => e.name).toList();
        case 'Asset':
          return AssetStatus.values.map((e) => e.name).toList();
        default:
          return IncidentStatus.values.map((e) => e.name).toList();
      }
    }

    final save = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setLocal) {
          final available = options();
          final statusOptions = statuses();
          return AlertDialog(
            title: const Text('Update record status'),
            content: SizedBox(
              width: 540,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _scopeNotice(context),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    value: entityType,
                    decoration: const InputDecoration(labelText: 'Record type'),
                    items: const ['Incident', 'Task', 'Activity', 'Asset']
                        .map((item) => DropdownMenuItem(value: item, child: Text(item)))
                        .toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setLocal(() {
                          entityType = value;
                          entityId = null;
                          targetStatus = null;
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    value: available.any((e) => e.id == entityId) ? entityId : null,
                    decoration: const InputDecoration(labelText: 'Record'),
                    items: available
                        .map((item) => DropdownMenuItem(
                              value: item.id,
                              child: Text('${item.id} — ${item.title}', overflow: TextOverflow.ellipsis),
                            ))
                        .toList(),
                    onChanged: (value) => setLocal(() => entityId = value),
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    value: statusOptions.contains(targetStatus) ? targetStatus : null,
                    decoration: const InputDecoration(labelText: 'New status'),
                    items: statusOptions
                        .map((item) => DropdownMenuItem(value: item, child: Text(_labelName(item))))
                        .toList(),
                    onChanged: (value) => setLocal(() => targetStatus = value),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext, false),
                child: const Text('Cancel'),
              ),
              FilledButton(
                onPressed: entityId == null || targetStatus == null
                    ? null
                    : () => Navigator.pop(dialogContext, true),
                child: const Text('Update status'),
              ),
            ],
          );
        },
      ),
    );

    if (save == true && entityId != null && targetStatus != null) {
      switch (entityType) {
        case 'Task':
          records.updateTaskStatus(
            entityId!,
            TaskStatus.values.firstWhere((e) => e.name == targetStatus),
            actorId: _operatorId(context),
          );
          break;
        case 'Activity':
          records.updateActivityStatus(
            entityId!,
            ActivityStatus.values.firstWhere((e) => e.name == targetStatus),
            actorId: _operatorId(context),
          );
          break;
        case 'Asset':
          records.updateAssetStatus(
            entityId!,
            AssetStatus.values.firstWhere((e) => e.name == targetStatus),
            actorId: _operatorId(context),
          );
          break;
        default:
          records.updateIncidentStatus(
            entityId!,
            IncidentStatus.values.firstWhere((e) => e.name == targetStatus),
            actorId: _operatorId(context),
          );
      }
      _done(context, '$entityId updated to ${_labelName(targetStatus!)}.');
    }
  }

  Widget _scopeNotice(BuildContext context) {
    final scope = CampaignScope.of(context, listen: false);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFFEAF4ED),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          const Icon(Icons.location_on_outlined, size: 18, color: pdpGreen),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'This record will be stored under ${scope.label}.',
              style: const TextStyle(fontWeight: FontWeight.w800, color: ink),
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(right: 7),
        child: OutlinedButton.icon(
          onPressed: onPressed,
          icon: Icon(icon, size: 17),
          label: Text(label),
          style: OutlinedButton.styleFrom(
            visualDensity: VisualDensity.compact,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
          ),
        ),
      );
}

class _StatusOption {
  const _StatusOption(this.id, this.title);
  final String id;
  final String title;
}

String _label(Object value) {
  final raw = value.toString().split('.').last;
  return _labelName(raw);
}

String _labelName(String raw) => raw
    .replaceAllMapped(RegExp(r'([a-z])([A-Z])'), (match) => '${match[1]} ${match[2]}')
    .replaceFirstMapped(RegExp(r'^.'), (match) => match[0]!.toUpperCase());
