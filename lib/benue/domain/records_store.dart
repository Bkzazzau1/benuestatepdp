import 'package:flutter/widgets.dart';

import 'geography_catalog.dart';
import 'models.dart';

/// Shared in-memory records controller used by the Flutter prototype.
///
/// Every operational entity has a stable ID, geographic scope, provenance and
/// audit trail. The public API intentionally resembles a backend repository so
/// it can later be replaced by Django/DRF services without redesigning the UI.
class CampaignRecordsController extends ChangeNotifier {
  CampaignRecordsController._({
    required List<CampaignUser> users,
    required List<FieldAssignment> assignments,
    required List<CampaignActivity> activities,
    required List<CampaignIncident> incidents,
    required List<CampaignTask> tasks,
    required List<CampaignAsset> assets,
    required List<FieldReport> fieldReports,
    required List<ElectionReadinessRecord> electionReadiness,
    required List<AuditEvent> auditEvents,
  })  : _users = users,
        _assignments = assignments,
        _activities = activities,
        _incidents = incidents,
        _tasks = tasks,
        _assets = assets,
        _fieldReports = fieldReports,
        _electionReadiness = electionReadiness,
        _auditEvents = auditEvents;

  factory CampaignRecordsController.prototypeSeed() {
    final users = <CampaignUser>[];
    final assignments = <FieldAssignment>[];
    final activities = <CampaignActivity>[];
    final incidents = <CampaignIncident>[];
    final tasks = <CampaignTask>[];
    final assets = <CampaignAsset>[];
    final reports = <FieldReport>[];
    final readiness = <ElectionReadinessRecord>[];
    final audit = <AuditEvent>[];

    final baseTime = DateTime.utc(2026, 9, 11, 9);

    for (var i = 0; i < BenueBaseGeography.lgas.length; i++) {
      final lga = BenueBaseGeography.lgas[i];
      final scope = lga.scope;
      final coordinatorId = 'USR-${lga.id}-COORD';
      final assignmentId = 'ASG-${lga.id}-COORD';
      final incidentId = 'INC-${lga.id}-001';
      final readinessPercent = 35 + ((i * 13) % 61);
      final incidentSeverity = switch (i % 5) {
        0 => IncidentSeverity.critical,
        1 => IncidentSeverity.high,
        2 => IncidentSeverity.medium,
        3 => IncidentSeverity.low,
        _ => IncidentSeverity.info,
      };

      users.add(CampaignUser(
        id: coordinatorId,
        displayName: '${lga.name} Coordinator Seat',
        role: CampaignRole.lgaCoordinator,
        scope: scope,
        isActive: true,
        origin: RecordOrigin.prototypeSeed,
      ));

      assignments.add(FieldAssignment(
        id: assignmentId,
        userId: coordinatorId,
        scope: scope,
        role: CampaignRole.lgaCoordinator,
        status: readinessPercent >= 70
            ? AssignmentStatus.ready
            : AssignmentStatus.training,
        trainingComplete: readinessPercent >= 55,
        checkedIn: i % 4 != 0,
        updatedAt: baseTime.add(Duration(minutes: i * 7)),
        origin: RecordOrigin.prototypeSeed,
      ));

      activities.add(CampaignActivity(
        id: 'ACT-${lga.id}-001',
        title: '${lga.name} coordination review',
        category: 'Operations',
        scope: scope,
        ownerUnit: '${lga.name} LGA Command',
        status: i % 3 == 0 ? ActivityStatus.active : ActivityStatus.planned,
        startsAt: baseTime.add(Duration(days: i % 7, hours: 2)),
        notes:
            'Prototype seeded activity. Replace with verified campaign calendar.',
        origin: RecordOrigin.prototypeSeed,
      ));

      incidents.add(CampaignIncident(
        id: incidentId,
        title: switch (i % 4) {
          0 => 'Logistics interruption requires review',
          1 => 'Field report awaiting verification',
          2 => 'Coordinator check-in overdue',
          _ => 'Operational follow-up required',
        },
        category: switch (i % 4) {
          0 => 'Logistics',
          1 => 'Field report',
          2 => 'Personnel',
          _ => 'Operations',
        },
        severity: incidentSeverity,
        status: i % 3 == 0
            ? IncidentStatus.investigating
            : IncidentStatus.assigned,
        scope: scope,
        reportedAt: baseTime.add(Duration(minutes: i * 11)),
        reporterId: coordinatorId,
        assignedTeam: '${lga.name} Operations',
        conversationId: 'ROOM-$incidentId',
        summary:
            'Prototype seeded incident for cross-module record integration.',
        origin: RecordOrigin.prototypeSeed,
      ));

      tasks.add(CampaignTask(
        id: 'TSK-${lga.id}-001',
        title: switch (i % 3) {
          0 => 'Verify logistics readiness',
          1 => 'Confirm coordinator coverage',
          _ => 'Review field reporting gaps',
        },
        ownerId: coordinatorId,
        scope: scope,
        status: i % 4 == 0 ? TaskStatus.inProgress : TaskStatus.open,
        priority: incidentSeverity,
        createdAt: baseTime.add(Duration(minutes: i * 5)),
        dueAt: baseTime.add(Duration(days: 1 + (i % 3))),
        incidentId: incidentId,
        origin: RecordOrigin.prototypeSeed,
      ));

      assets.add(CampaignAsset(
        id: 'AST-${lga.id}-VEH-01',
        name: '${lga.name} Operations Vehicle 01',
        category: 'Vehicle',
        scope: scope,
        status:
            i % 6 == 0 ? AssetStatus.maintenance : AssetStatus.assigned,
        updatedAt: baseTime.add(Duration(minutes: i * 9)),
        custodianId: coordinatorId,
        conditionNote: i % 6 == 0
            ? 'Prototype maintenance flag'
            : 'Prototype assigned asset',
        origin: RecordOrigin.prototypeSeed,
      ));

      reports.add(FieldReport(
        id: 'RPT-${lga.id}-001',
        category: 'Operations update',
        summary:
            '${lga.name} command submitted a prototype operational update.',
        scope: scope,
        reporterId: coordinatorId,
        reportedAt: baseTime.add(Duration(hours: 1, minutes: i * 3)),
        status: i % 5 == 0 ? RecordStatus.submitted : RecordStatus.verified,
        incidentId: i % 3 == 0 ? incidentId : null,
        origin: RecordOrigin.prototypeSeed,
      ));

      readiness.add(ElectionReadinessRecord(
        id: 'READY-${lga.id}-001',
        scope: scope,
        status: readinessPercent >= 75
            ? ElectionReadinessStatus.ready
            : readinessPercent >= 50
                ? ElectionReadinessStatus.incomplete
                : ElectionReadinessStatus.attentionRequired,
        agentCoveragePercent: readinessPercent.toDouble(),
        communicationReady: readinessPercent >= 60,
        logisticsReady: readinessPercent >= 65,
        updatedAt: baseTime.add(Duration(minutes: i * 4)),
        note:
            'Prototype seeded readiness; production must derive this from verified ward/PU assignments and logistics.',
        origin: RecordOrigin.prototypeSeed,
      ));
    }

    audit.add(AuditEvent(
      id: 'AUD-SYSTEM-0001',
      actorId: 'SYSTEM',
      action: 'prototype_seed_loaded',
      entityType: 'CampaignRecords',
      entityId: 'BENUE-PROTOTYPE-SEED',
      timestamp: baseTime,
      detail:
          'Loaded provenance-labelled prototype operational records for 23 LGAs.',
    ));

    return CampaignRecordsController._(
      users: users,
      assignments: assignments,
      activities: activities,
      incidents: incidents,
      tasks: tasks,
      assets: assets,
      fieldReports: reports,
      electionReadiness: readiness,
      auditEvents: audit,
    );
  }

  final List<CampaignUser> _users;
  final List<FieldAssignment> _assignments;
  final List<CampaignActivity> _activities;
  final List<CampaignIncident> _incidents;
  final List<CampaignTask> _tasks;
  final List<CampaignAsset> _assets;
  final List<FieldReport> _fieldReports;
  final List<ElectionReadinessRecord> _electionReadiness;
  final List<AuditEvent> _auditEvents;

  int _auditSequence = 1;
  final Map<String, int> _idSequences = <String, int>{};

  List<CampaignUser> get users => List.unmodifiable(_users);
  List<FieldAssignment> get assignments => List.unmodifiable(_assignments);
  List<CampaignActivity> get activities => List.unmodifiable(_activities);
  List<CampaignIncident> get incidents => List.unmodifiable(_incidents);
  List<CampaignTask> get tasks => List.unmodifiable(_tasks);
  List<CampaignAsset> get assets => List.unmodifiable(_assets);
  List<FieldReport> get fieldReports => List.unmodifiable(_fieldReports);
  List<ElectionReadinessRecord> get electionReadiness =>
      List.unmodifiable(_electionReadiness);
  List<AuditEvent> get auditEvents => List.unmodifiable(_auditEvents);

  String nextId(String prefix, {String? lgaId}) {
    final geography = lgaId ?? 'BEN-STATE';
    final key = '$prefix:$geography';
    final next = (_idSequences[key] ?? 0) + 1;
    _idSequences[key] = next;
    return '$prefix-$geography-${next.toString().padLeft(4, '0')}';
  }

  bool _matchesLga(GeographicScope scope, String? lgaId) =>
      lgaId == null || scope.lgaId == lgaId;

  bool _sameScope(GeographicScope a, GeographicScope b) =>
      a.level == b.level &&
      a.state == b.state &&
      a.lgaId == b.lgaId &&
      a.wardId == b.wardId &&
      a.pollingUnitId == b.pollingUnitId;

  List<CampaignUser> usersFor(String? lgaId) => _users
      .where((record) => _matchesLga(record.scope, lgaId))
      .toList(growable: false);

  List<FieldAssignment> assignmentsFor(String? lgaId) => _assignments
      .where((record) => _matchesLga(record.scope, lgaId))
      .toList(growable: false);

  List<CampaignActivity> activitiesFor(String? lgaId) => _activities
      .where((record) => _matchesLga(record.scope, lgaId))
      .toList(growable: false);

  List<CampaignIncident> incidentsFor(String? lgaId) => _incidents
      .where((record) => _matchesLga(record.scope, lgaId))
      .toList(growable: false);

  List<CampaignTask> tasksFor(String? lgaId) => _tasks
      .where((record) => _matchesLga(record.scope, lgaId))
      .toList(growable: false);

  List<CampaignAsset> assetsFor(String? lgaId) => _assets
      .where((record) => _matchesLga(record.scope, lgaId))
      .toList(growable: false);

  List<FieldReport> reportsFor(String? lgaId) => _fieldReports
      .where((record) => _matchesLga(record.scope, lgaId))
      .toList(growable: false);

  List<ElectionReadinessRecord> readinessFor(String? lgaId) =>
      _electionReadiness
          .where((record) => _matchesLga(record.scope, lgaId))
          .toList(growable: false);

  CampaignRecordsSummary summaryFor(String? lgaId) {
    final scopedAssignments = assignmentsFor(lgaId);
    final scopedIncidents = incidentsFor(lgaId);
    final scopedTasks = tasksFor(lgaId);
    final scopedAssets = assetsFor(lgaId);
    final scopedReports = reportsFor(lgaId);
    final scopedReadiness = readinessFor(lgaId);

    final openIncidents = scopedIncidents
        .where((record) => record.status != IncidentStatus.closed)
        .length;
    final openTasks = scopedTasks
        .where((record) =>
            record.status != TaskStatus.completed &&
            record.status != TaskStatus.cancelled)
        .length;
    final checkedIn =
        scopedAssignments.where((record) => record.checkedIn).length;
    final assetsReady = scopedAssets
        .where((record) =>
            record.status == AssetStatus.available ||
            record.status == AssetStatus.assigned ||
            record.status == AssetStatus.inUse)
        .length;
    final averageReadiness = scopedReadiness.isEmpty
        ? 0.0
        : scopedReadiness
                .map((record) => record.agentCoveragePercent)
                .reduce((a, b) => a + b) /
            scopedReadiness.length;

    return CampaignRecordsSummary(
      assignments: scopedAssignments.length,
      checkedInAssignments: checkedIn,
      openIncidents: openIncidents,
      openTasks: openTasks,
      assets: scopedAssets.length,
      readyAssets: assetsReady,
      fieldReports: scopedReports.length,
      averageReadiness: averageReadiness,
    );
  }

  CampaignIncident? incidentById(String id) {
    for (final incident in _incidents) {
      if (incident.id == id) return incident;
    }
    return null;
  }

  CampaignTask? taskById(String id) {
    for (final task in _tasks) {
      if (task.id == id) return task;
    }
    return null;
  }

  CampaignUser? userById(String id) {
    for (final user in _users) {
      if (user.id == id) return user;
    }
    return null;
  }

  FieldAssignment? assignmentById(String id) {
    for (final assignment in _assignments) {
      if (assignment.id == id) return assignment;
    }
    return null;
  }

  void _audit({
    required String actorId,
    required String action,
    required String entityType,
    required String entityId,
    String? detail,
  }) {
    _auditSequence += 1;
    _auditEvents.add(AuditEvent(
      id: 'AUD-${_auditSequence.toString().padLeft(6, '0')}',
      actorId: actorId,
      action: action,
      entityType: entityType,
      entityId: entityId,
      timestamp: DateTime.now().toUtc(),
      detail: detail,
    ));
  }

  void addTask(CampaignTask task, {String actorId = 'UI-OPERATOR'}) {
    if (_tasks.any((item) => item.id == task.id)) {
      throw StateError('Duplicate task id: ${task.id}');
    }
    _tasks.add(task);
    _audit(
      actorId: actorId,
      action: 'task_created',
      entityType: 'CampaignTask',
      entityId: task.id,
      detail:
          'Scope: ${task.scope.label}; incident: ${task.incidentId ?? 'none'}',
    );
    notifyListeners();
  }

  void addIncident(CampaignIncident incident,
      {String actorId = 'UI-OPERATOR'}) {
    if (_incidents.any((item) => item.id == incident.id)) {
      throw StateError('Duplicate incident id: ${incident.id}');
    }
    _incidents.add(incident);
    _audit(
      actorId: actorId,
      action: 'incident_created',
      entityType: 'CampaignIncident',
      entityId: incident.id,
      detail:
          'Scope: ${incident.scope.label}; severity: ${incident.severity.name}',
    );
    notifyListeners();
  }

  void addFieldReport(FieldReport report,
      {String actorId = 'UI-OPERATOR'}) {
    if (_fieldReports.any((item) => item.id == report.id)) {
      throw StateError('Duplicate field-report id: ${report.id}');
    }
    _fieldReports.add(report);
    _audit(
      actorId: actorId,
      action: 'field_report_created',
      entityType: 'FieldReport',
      entityId: report.id,
      detail:
          'Scope: ${report.scope.label}; incident: ${report.incidentId ?? 'none'}',
    );
    notifyListeners();
  }

  void addActivity(CampaignActivity activity,
      {String actorId = 'UI-OPERATOR'}) {
    if (_activities.any((item) => item.id == activity.id)) {
      throw StateError('Duplicate activity id: ${activity.id}');
    }
    _activities.add(activity);
    _audit(
      actorId: actorId,
      action: 'activity_created',
      entityType: 'CampaignActivity',
      entityId: activity.id,
      detail: 'Scope: ${activity.scope.label}',
    );
    notifyListeners();
  }

  void addAsset(CampaignAsset asset, {String actorId = 'UI-OPERATOR'}) {
    if (_assets.any((item) => item.id == asset.id)) {
      throw StateError('Duplicate asset id: ${asset.id}');
    }
    _assets.add(asset);
    _audit(
      actorId: actorId,
      action: 'asset_created',
      entityType: 'CampaignAsset',
      entityId: asset.id,
      detail: 'Scope: ${asset.scope.label}',
    );
    notifyListeners();
  }

  void addFieldPerson({
    required CampaignUser user,
    required FieldAssignment assignment,
    String actorId = 'UI-OPERATOR',
  }) {
    if (_users.any((item) => item.id == user.id)) {
      throw StateError('Duplicate user id: ${user.id}');
    }
    if (_assignments.any((item) => item.id == assignment.id)) {
      throw StateError('Duplicate assignment id: ${assignment.id}');
    }
    if (assignment.userId != user.id) {
      throw StateError('Assignment userId must match the created user.');
    }
    if (!_sameScope(user.scope, assignment.scope)) {
      throw StateError('User and assignment must share the same geography.');
    }
    _users.add(user);
    _assignments.add(assignment);
    _audit(
      actorId: actorId,
      action: 'field_person_created',
      entityType: 'CampaignUser',
      entityId: user.id,
      detail:
          'Assignment: ${assignment.id}; role: ${user.role.name}; scope: ${user.scope.label}',
    );
    notifyListeners();
  }

  void setAssignmentCheckIn(
    String assignmentId,
    bool checkedIn, {
    String actorId = 'UI-OPERATOR',
  }) {
    final index = _assignments.indexWhere((item) => item.id == assignmentId);
    if (index < 0) throw StateError('Unknown assignment id: $assignmentId');
    final current = _assignments[index];
    _assignments[index] = FieldAssignment(
      id: current.id,
      userId: current.userId,
      scope: current.scope,
      role: current.role,
      status: current.status,
      updatedAt: DateTime.now().toUtc(),
      trainingComplete: current.trainingComplete,
      checkedIn: checkedIn,
      origin: RecordOrigin.campaignEntry,
    );
    _audit(
      actorId: actorId,
      action: checkedIn ? 'assignment_checked_in' : 'assignment_checked_out',
      entityType: 'FieldAssignment',
      entityId: assignmentId,
      detail: 'Scope: ${current.scope.label}',
    );
    notifyListeners();
  }

  void setAssignmentTraining(
    String assignmentId,
    bool complete, {
    String actorId = 'UI-OPERATOR',
  }) {
    final index = _assignments.indexWhere((item) => item.id == assignmentId);
    if (index < 0) throw StateError('Unknown assignment id: $assignmentId');
    final current = _assignments[index];
    _assignments[index] = FieldAssignment(
      id: current.id,
      userId: current.userId,
      scope: current.scope,
      role: current.role,
      status: complete ? AssignmentStatus.ready : AssignmentStatus.training,
      updatedAt: DateTime.now().toUtc(),
      trainingComplete: complete,
      checkedIn: current.checkedIn,
      origin: RecordOrigin.campaignEntry,
    );
    _audit(
      actorId: actorId,
      action: 'assignment_training_updated',
      entityType: 'FieldAssignment',
      entityId: assignmentId,
      detail: 'trainingComplete=$complete',
    );
    notifyListeners();
  }

  void setReadiness({
    required GeographicScope scope,
    required double agentCoveragePercent,
    required bool communicationReady,
    required bool logisticsReady,
    String? note,
    String actorId = 'UI-OPERATOR',
  }) {
    final safeCoverage = agentCoveragePercent.clamp(0, 100).toDouble();
    final status = safeCoverage >= 75 && communicationReady && logisticsReady
        ? ElectionReadinessStatus.ready
        : safeCoverage < 40
            ? ElectionReadinessStatus.attentionRequired
            : ElectionReadinessStatus.incomplete;
    final index = _electionReadiness.indexWhere(
      (item) => _sameScope(item.scope, scope),
    );
    final record = ElectionReadinessRecord(
      id: index >= 0
          ? _electionReadiness[index].id
          : nextId('READY', lgaId: scope.lgaId),
      scope: scope,
      status: status,
      agentCoveragePercent: safeCoverage,
      communicationReady: communicationReady,
      logisticsReady: logisticsReady,
      updatedAt: DateTime.now().toUtc(),
      note: note,
      origin: RecordOrigin.campaignEntry,
    );
    if (index >= 0) {
      _electionReadiness[index] = record;
    } else {
      _electionReadiness.add(record);
    }
    _audit(
      actorId: actorId,
      action: 'readiness_updated',
      entityType: 'ElectionReadinessRecord',
      entityId: record.id,
      detail:
          'coverage=${safeCoverage.toStringAsFixed(0)}; communications=$communicationReady; logistics=$logisticsReady',
    );
    notifyListeners();
  }

  void updateIncidentStatus(
    String incidentId,
    IncidentStatus status, {
    String actorId = 'UI-OPERATOR',
  }) {
    final index = _incidents.indexWhere((item) => item.id == incidentId);
    if (index < 0) throw StateError('Unknown incident id: $incidentId');
    final current = _incidents[index];
    _incidents[index] = CampaignIncident(
      id: current.id,
      title: current.title,
      category: current.category,
      severity: current.severity,
      status: status,
      scope: current.scope,
      reportedAt: current.reportedAt,
      reporterId: current.reporterId,
      assignedTeam: current.assignedTeam,
      conversationId: current.conversationId,
      summary: current.summary,
      origin: RecordOrigin.campaignEntry,
    );
    _audit(
      actorId: actorId,
      action: 'incident_status_updated',
      entityType: 'CampaignIncident',
      entityId: incidentId,
      detail: 'status=${status.name}',
    );
    notifyListeners();
  }

  void updateTaskStatus(
    String taskId,
    TaskStatus status, {
    String actorId = 'UI-OPERATOR',
  }) {
    final index = _tasks.indexWhere((item) => item.id == taskId);
    if (index < 0) throw StateError('Unknown task id: $taskId');
    final current = _tasks[index];
    _tasks[index] = CampaignTask(
      id: current.id,
      title: current.title,
      ownerId: current.ownerId,
      scope: current.scope,
      status: status,
      priority: current.priority,
      createdAt: current.createdAt,
      dueAt: current.dueAt,
      sourceConversationId: current.sourceConversationId,
      sourceMessageId: current.sourceMessageId,
      incidentId: current.incidentId,
      origin: RecordOrigin.campaignEntry,
    );
    _audit(
      actorId: actorId,
      action: 'task_status_updated',
      entityType: 'CampaignTask',
      entityId: taskId,
      detail: 'status=${status.name}',
    );
    notifyListeners();
  }

  void updateActivityStatus(
    String activityId,
    ActivityStatus status, {
    String actorId = 'UI-OPERATOR',
  }) {
    final index = _activities.indexWhere((item) => item.id == activityId);
    if (index < 0) throw StateError('Unknown activity id: $activityId');
    final current = _activities[index];
    _activities[index] = CampaignActivity(
      id: current.id,
      title: current.title,
      category: current.category,
      scope: current.scope,
      ownerUnit: current.ownerUnit,
      status: status,
      startsAt: current.startsAt,
      endsAt: current.endsAt,
      notes: current.notes,
      origin: RecordOrigin.campaignEntry,
    );
    _audit(
      actorId: actorId,
      action: 'activity_status_updated',
      entityType: 'CampaignActivity',
      entityId: activityId,
      detail: 'status=${status.name}',
    );
    notifyListeners();
  }

  void updateAssetStatus(
    String assetId,
    AssetStatus status, {
    String actorId = 'UI-OPERATOR',
  }) {
    final index = _assets.indexWhere((item) => item.id == assetId);
    if (index < 0) throw StateError('Unknown asset id: $assetId');
    final current = _assets[index];
    _assets[index] = CampaignAsset(
      id: current.id,
      name: current.name,
      category: current.category,
      scope: current.scope,
      status: status,
      updatedAt: DateTime.now().toUtc(),
      custodianId: current.custodianId,
      conditionNote: current.conditionNote,
      origin: RecordOrigin.campaignEntry,
    );
    _audit(
      actorId: actorId,
      action: 'asset_status_updated',
      entityType: 'CampaignAsset',
      entityId: assetId,
      detail: 'status=${status.name}',
    );
    notifyListeners();
  }
}

class CampaignRecordsSummary {
  const CampaignRecordsSummary({
    required this.assignments,
    required this.checkedInAssignments,
    required this.openIncidents,
    required this.openTasks,
    required this.assets,
    required this.readyAssets,
    required this.fieldReports,
    required this.averageReadiness,
  });

  final int assignments;
  final int checkedInAssignments;
  final int openIncidents;
  final int openTasks;
  final int assets;
  final int readyAssets;
  final int fieldReports;
  final double averageReadiness;
}

class CampaignRecords extends InheritedNotifier<CampaignRecordsController> {
  const CampaignRecords({
    super.key,
    required CampaignRecordsController controller,
    required super.child,
  }) : super(notifier: controller);

  static CampaignRecordsController of(BuildContext context,
      {bool listen = true}) {
    if (listen) {
      final inherited =
          context.dependOnInheritedWidgetOfExactType<CampaignRecords>();
      assert(inherited != null, 'CampaignRecords is missing above this context.');
      return inherited!.notifier!;
    }
    final element =
        context.getElementForInheritedWidgetOfExactType<CampaignRecords>();
    final inherited = element?.widget as CampaignRecords?;
    assert(inherited != null, 'CampaignRecords is missing above this context.');
    return inherited!.notifier!;
  }
}
