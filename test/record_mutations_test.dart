import 'package:flutter_test/flutter_test.dart';
import 'package:polisphere/benue/domain/models.dart';
import 'package:polisphere/benue/domain/records_store.dart';

void main() {
  const makurdiScope = GeographicScope(
    level: GeographyLevel.lga,
    state: 'Benue',
    lgaId: 'BEN-LGA-13',
    lga: 'Makurdi',
  );

  test('new records change the shared LGA summary and write audit events', () {
    final records = CampaignRecordsController.prototypeSeed();
    final before = records.summaryFor('BEN-LGA-13');
    final auditBefore = records.auditEvents.length;
    final reporter = records.usersFor('BEN-LGA-13').first;

    final incidentId = records.nextId('INC', lgaId: 'BEN-LGA-13');
    records.addIncident(
      CampaignIncident(
        id: incidentId,
        title: 'Test operational incident',
        category: 'Operations',
        severity: IncidentSeverity.high,
        status: IncidentStatus.reported,
        scope: makurdiScope,
        reportedAt: DateTime.utc(2026, 9, 11, 15),
        reporterId: reporter.id,
        conversationId: 'ROOM-$incidentId',
        origin: RecordOrigin.campaignEntry,
      ),
      actorId: reporter.id,
    );

    final taskId = records.nextId('TSK', lgaId: 'BEN-LGA-13');
    records.addTask(
      CampaignTask(
        id: taskId,
        title: 'Resolve test incident',
        ownerId: reporter.id,
        scope: makurdiScope,
        status: TaskStatus.open,
        priority: IncidentSeverity.high,
        createdAt: DateTime.utc(2026, 9, 11, 15, 1),
        incidentId: incidentId,
        origin: RecordOrigin.campaignEntry,
      ),
      actorId: reporter.id,
    );

    final after = records.summaryFor('BEN-LGA-13');
    expect(after.openIncidents, before.openIncidents + 1);
    expect(after.openTasks, before.openTasks + 1);
    expect(records.taskById(taskId)?.incidentId, incidentId);
    expect(records.incidentById(incidentId)?.conversationId, 'ROOM-$incidentId');
    expect(records.auditEvents.length, auditBefore + 2);
    expect(records.auditEvents.last.entityId, taskId);
    expect(records.auditEvents.last.actorId, reporter.id);

    records.dispose();
  });

  test('field person check-in and readiness updates are shared and auditable', () {
    final records = CampaignRecordsController.prototypeSeed();
    final auditBefore = records.auditEvents.length;

    final userId = records.nextId('USR', lgaId: 'BEN-LGA-13');
    final assignmentId = records.nextId('ASG', lgaId: 'BEN-LGA-13');
    records.addFieldPerson(
      user: CampaignUser(
        id: userId,
        displayName: 'Test Makurdi Field Reporter',
        role: CampaignRole.fieldReporter,
        scope: makurdiScope,
        isActive: true,
        origin: RecordOrigin.campaignEntry,
      ),
      assignment: FieldAssignment(
        id: assignmentId,
        userId: userId,
        scope: makurdiScope,
        role: CampaignRole.fieldReporter,
        status: AssignmentStatus.assigned,
        updatedAt: DateTime.utc(2026, 9, 11, 15),
        origin: RecordOrigin.campaignEntry,
      ),
      actorId: 'TEST-ADMIN',
    );

    records.setAssignmentCheckIn(
      assignmentId,
      true,
      actorId: 'TEST-ADMIN',
    );
    records.setAssignmentTraining(
      assignmentId,
      true,
      actorId: 'TEST-ADMIN',
    );
    records.setReadiness(
      scope: makurdiScope,
      agentCoveragePercent: 82,
      communicationReady: true,
      logisticsReady: true,
      note: 'Validated in mutation test',
      actorId: 'TEST-ADMIN',
    );

    final assignment = records.assignmentById(assignmentId);
    final readiness = records.readinessFor('BEN-LGA-13').single;
    expect(assignment?.checkedIn, isTrue);
    expect(assignment?.trainingComplete, isTrue);
    expect(assignment?.status, AssignmentStatus.ready);
    expect(readiness.agentCoveragePercent, 82);
    expect(readiness.status, ElectionReadinessStatus.ready);
    expect(records.auditEvents.length, auditBefore + 4);
    expect(records.auditEvents.last.action, 'readiness_updated');

    records.dispose();
  });

  test('status transitions replace the shared record without changing its ID', () {
    final records = CampaignRecordsController.prototypeSeed();
    final incident = records.incidentsFor('BEN-LGA-13').first;
    final task = records.tasksFor('BEN-LGA-13').first;
    final activity = records.activitiesFor('BEN-LGA-13').first;
    final asset = records.assetsFor('BEN-LGA-13').first;

    records.updateIncidentStatus(incident.id, IncidentStatus.closed);
    records.updateTaskStatus(task.id, TaskStatus.completed);
    records.updateActivityStatus(activity.id, ActivityStatus.completed);
    records.updateAssetStatus(asset.id, AssetStatus.maintenance);

    expect(records.incidentById(incident.id)?.status, IncidentStatus.closed);
    expect(records.taskById(task.id)?.status, TaskStatus.completed);
    expect(
      records.activitiesFor('BEN-LGA-13')
          .firstWhere((item) => item.id == activity.id)
          .status,
      ActivityStatus.completed,
    );
    expect(
      records.assetsFor('BEN-LGA-13')
          .firstWhere((item) => item.id == asset.id)
          .status,
      AssetStatus.maintenance,
    );

    records.dispose();
  });
}
