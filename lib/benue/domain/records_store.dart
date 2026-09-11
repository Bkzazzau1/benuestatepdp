import 'package:flutter/widgets.dart';

import 'geography_catalog.dart';
import 'models.dart';

/// Shared in-memory records controller used by the Flutter prototype.
///
/// This is deliberately shaped like a backend repository: every entity has a
/// stable ID, geographic scope and provenance. Replacing this controller with
/// Django/DRF repositories later should not require changing the product model.
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
        notes: 'Prototype seeded activity. Replace with verified campaign calendar.',
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
        summary: 'Prototype seeded incident for cross-module record integration.',
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
        status: i % 6 == 0 ? AssetStatus.maintenance : AssetStatus.assigned,
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
        summary: '${lga.name} command submitted a prototype operational update.',
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

  bool _matchesLga(GeographicScope scope, String? lgaId) =>
      lgaId == null || scope.lgaId == lgaId;

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

  List<ElectionReadinessRecord> readinessFor(String? lgaId) => _electionReadiness
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
    final checkedIn = scopedAssignments.where((record) => record.checkedIn).length;
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

  void addTask(CampaignTask task, {String actorId = 'SYSTEM'}) {
    if (_tasks.any((item) => item.id == task.id)) {
      throw StateError('Duplicate task id: ${task.id}');
    }
    _tasks.add(task);
    _audit(
      actorId: actorId,
      action: 'task_created',
      entityType: 'CampaignTask',
      entityId: task.id,
      detail: 'Scope: ${task.scope.label}; incident: ${task.incidentId ?? 'none'}',
    );
    notifyListeners();
  }

  void addIncident(CampaignIncident incident, {String actorId = 'SYSTEM'}) {
    if (_incidents.any((item) => item.id == incident.id)) {
      throw StateError('Duplicate incident id: ${incident.id}');
    }
    _incidents.add(incident);
    _audit(
      actorId: actorId,
      action: 'incident_created',
      entityType: 'CampaignIncident',
      entityId: incident.id,
      detail: 'Scope: ${incident.scope.label}; severity: ${incident.severity.name}',
    );
    notifyListeners();
  }

  void addFieldReport(FieldReport report, {String actorId = 'SYSTEM'}) {
    if (_fieldReports.any((item) => item.id == report.id)) {
      throw StateError('Duplicate field-report id: ${report.id}');
    }
    _fieldReports.add(report);
    _audit(
      actorId: actorId,
      action: 'field_report_created',
      entityType: 'FieldReport',
      entityId: report.id,
      detail: 'Scope: ${report.scope.label}; incident: ${report.incidentId ?? 'none'}',
    );
    notifyListeners();
  }

  void addActivity(CampaignActivity activity, {String actorId = 'SYSTEM'}) {
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

  void addAsset(CampaignAsset asset, {String actorId = 'SYSTEM'}) {
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
