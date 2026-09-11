import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:polisphere/benue/app_scope.dart';
import 'package:polisphere/benue/domain/models.dart';
import 'package:polisphere/benue/domain/records_store.dart';
import 'package:polisphere/benue/role_command_views.dart';
import 'package:polisphere/benue/session.dart';

void main() {
  testWidgets('Director General receives premium statewide command centre',
      (tester) async {
    tester.view.physicalSize = const Size(1700, 1200);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final session = CampaignSessionController()
      ..signIn(
        role: CampaignRole.directorGeneral,
        operatorName: 'Director General',
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
                  role: CampaignRole.directorGeneral,
                  onOpenModule: (_) {},
                ),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Director General Command'), findsOneWidget);
    expect(find.text('Campaign readiness'), findsOneWidget);
    expect(find.text('LGA readiness board'), findsOneWidget);
    expect(find.text('DG decision desk'), findsOneWidget);

    for (final heading in [
      'Campaign activity board',
      'Execution health',
      'Executive command brief',
      'DG command shortcuts',
      'DG operating doctrine',
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
