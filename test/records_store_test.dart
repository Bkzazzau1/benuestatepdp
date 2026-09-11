import 'package:flutter_test/flutter_test.dart';
import 'package:polisphere/benue/domain/models.dart';
import 'package:polisphere/benue/domain/records_store.dart';

void main() {
  test('prototype store seeds one linked operational record set per LGA', () {
    final records = CampaignRecordsController.prototypeSeed();

    expect(records.assignments.length, 23);
    expect(records.activities.length, 23);
    expect(records.incidents.length, 23);
    expect(records.tasks.length, 23);
    expect(records.assets.length, 23);
    expect(records.fieldReports.length, 23);
    expect(records.electionReadiness.length, 23);

    final makurdiIncidents = records.incidentsFor('BEN-LGA-13');
    final makurdiTasks = records.tasksFor('BEN-LGA-13');
    final makurdiAssignments = records.assignmentsFor('BEN-LGA-13');
    final makurdiReports = records.reportsFor('BEN-LGA-13');
    final makurdiAssets = records.assetsFor('BEN-LGA-13');
    final makurdiReadiness = records.readinessFor('BEN-LGA-13');

    expect(makurdiIncidents.single.id, 'INC-BEN-LGA-13-001');
    expect(makurdiTasks.single.id, 'TSK-BEN-LGA-13-001');
    expect(makurdiAssignments.single.id, 'ASG-BEN-LGA-13-COORD');
    expect(makurdiReports.single.id, 'RPT-BEN-LGA-13-001');
    expect(makurdiAssets.single.id, 'AST-BEN-LGA-13-VEH-01');
    expect(makurdiReadiness.single.id, 'READY-BEN-LGA-13-001');

    expect(makurdiTasks.single.incidentId, makurdiIncidents.single.id);
    expect(
      makurdiAssignments.single.userId,
      makurdiTasks.single.ownerId,
    );
    expect(
      records.userById(makurdiAssignments.single.userId)?.scope.lgaId,
      'BEN-LGA-13',
    );
    expect(makurdiIncidents.single.scope.lgaId, 'BEN-LGA-13');
    expect(makurdiTasks.single.scope.lgaId, 'BEN-LGA-13');
    expect(makurdiReports.single.scope.lgaId, 'BEN-LGA-13');
    expect(makurdiAssets.single.scope.lgaId, 'BEN-LGA-13');
    expect(makurdiReadiness.single.scope.lgaId, 'BEN-LGA-13');

    expect(makurdiIncidents.single.origin, RecordOrigin.prototypeSeed);
    expect(makurdiTasks.single.origin, RecordOrigin.prototypeSeed);

    records.dispose();
  });

  test('duplicate task IDs are rejected', () {
    final records = CampaignRecordsController.prototypeSeed();
    final existing = records.tasks.first;

    expect(
      () => records.addTask(existing),
      throwsStateError,
    );

    records.dispose();
  });
}
