import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:polisphere/benue/app_scope.dart';
import 'package:polisphere/benue/domain/models.dart';
import 'package:polisphere/benue/domain/records_store.dart';
import 'package:polisphere/benue/role_command_views.dart';
import 'package:polisphere/benue/session.dart';

void main() {
  testWidgets('Situation Room Director receives response-first command centre',
      (tester) async {
    tester.view.physicalSize = const Size(1600, 1100);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final session = CampaignSessionController()
      ..signIn(
        role: CampaignRole.situationRoomDirector,
        operatorName: 'Situation Room Director',
      );
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
                  role: CampaignRole.situationRoomDirector,
                  onOpenModule: (_) {},
                ),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Situation Room Command'), findsOneWidget);
    expect(find.text('LIVE OPERATIONS'), findsOneWidget);
    expect(find.text('REALTIME BACKEND PENDING'), findsOneWidget);
    expect(find.text('Incident command board'), findsOneWidget);
    expect(find.text('Response health'), findsOneWidget);
    expect(find.text('Open incidents'), findsWidgets);
    expect(find.text('Critical / high'), findsOneWidget);

    for (final heading in [
      'Field evidence feed',
      'Operational hotspots',
      'Response controls',
      'Situation Room response doctrine',
    ]) {
      await tester.scrollUntilVisible(
        find.text(heading),
        320,
        scrollable: find.byType(Scrollable).last,
      );
      expect(find.text(heading), findsOneWidget);
    }
  });
}
