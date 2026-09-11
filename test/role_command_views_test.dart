import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:polisphere/benue/app_scope.dart';
import 'package:polisphere/benue/campaign_identity.dart';
import 'package:polisphere/benue/domain/models.dart';
import 'package:polisphere/benue/domain/records_store.dart';
import 'package:polisphere/benue/role_command_views.dart';
import 'package:polisphere/benue/session.dart';

void main() {
  final expectedTitle = <CampaignRole, String>{
    CampaignRole.candidate: CampaignIdentity.candidateName,
    CampaignRole.directorGeneral: 'Director General Command',
    CampaignRole.situationRoomDirector: 'Situation Room Command',
    CampaignRole.stateAdministrator: 'State Administrator Console',
    CampaignRole.operationsOfficer: 'Operations Command',
    CampaignRole.mediaIntelligenceOfficer: 'Media & Intelligence Command',
    CampaignRole.legalOfficer: 'Legal Command',
    CampaignRole.logisticsOfficer: 'Logistics Command',
    CampaignRole.financeOfficer: 'Finance Command',
    CampaignRole.lgaCoordinator: 'LGA Coordinator Command',
    CampaignRole.wardCoordinator: 'Ward Coordinator Command',
    CampaignRole.pollingUnitAgent: 'Polling Unit Agent Console',
    CampaignRole.fieldReporter: 'Field Reporter Console',
    CampaignRole.readOnlyExecutive: 'Executive Viewer',
  };

  for (final entry in expectedTitle.entries) {
    testWidgets('${entry.key.name} receives a distinct command home', (tester) async {
      tester.view.physicalSize = const Size(1500, 1000);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      final session = CampaignSessionController()
        ..signIn(role: entry.key, operatorName: roleLabel(entry.key));
      final scope = CampaignScopeController();
      final records = CampaignRecordsController.prototypeSeed();
      addTearDown(session.dispose);
      addTearDown(scope.dispose);
      addTearDown(records.dispose);

      await tester.pumpWidget(
        CampaignSession(
          controller: session,
          child: CampaignScope(
            controller: scope,
            child: CampaignRecords(
              controller: records,
              child: MaterialApp(
                home: Scaffold(
                  body: RoleCommandRouter(
                    role: entry.key,
                    onOpenModule: (_) {},
                  ),
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text(entry.value), findsWidgets);
    });
  }

  testWidgets('LGA coordinator command changes when an LGA becomes active',
      (tester) async {
    tester.view.physicalSize = const Size(1500, 1000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final session = CampaignSessionController()
      ..signIn(
        role: CampaignRole.lgaCoordinator,
        operatorName: 'LGA Coordinator',
      );
    final scope = CampaignScopeController()
      ..selectLga(id: 'BEN-LGA-13', name: 'Makurdi');
    final records = CampaignRecordsController.prototypeSeed();
    addTearDown(session.dispose);
    addTearDown(scope.dispose);
    addTearDown(records.dispose);

    await tester.pumpWidget(
      CampaignSession(
        controller: session,
        child: CampaignScope(
          controller: scope,
          child: CampaignRecords(
            controller: records,
            child: MaterialApp(
              home: Scaffold(
                body: RoleCommandRouter(
                  role: CampaignRole.lgaCoordinator,
                  onOpenModule: (_) {},
                ),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Makurdi LGA Command'), findsOneWidget);
    expect(find.text('LGA operational queue'), findsOneWidget);
  });
}
