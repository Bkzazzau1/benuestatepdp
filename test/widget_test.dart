import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'ui_test_helpers.dart';

void main() {
  testWidgets('loads the Benue statewide executive command dashboard',
      (tester) async {
    tester.view.physicalSize = const Size(1440, 1000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await pumpLoggedInAsDirectorGeneral(tester);

    expect(find.text('POLISPHERE BENUE'), findsOneWidget);
    expect(find.textContaining('Benue Governorship Campaign'), findsWidgets);
    expect(find.text('Field assignments'), findsWidgets);
    expect(find.text('Priority alerts'), findsWidgets);
    expect(find.text('Operational tasks'), findsOneWidget);
    expect(find.text('Campaign momentum'), findsOneWidget);
    expect(find.text('AI Command Brief'), findsOneWidget);
    expect(find.text('Quick actions'), findsOneWidget);
    expect(find.textContaining('Zaria'), findsNothing);
  });

  testWidgets('opens dedicated historical election analytics', (tester) async {
    tester.view.physicalSize = const Size(1600, 1100);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await pumpLoggedInAsDirectorGeneral(tester);
    await tester.tap(find.text('Historical Elections').first);
    await tester.pumpAndSettle();

    expect(find.text('Historical Elections'), findsWidgets);
    expect(find.text('+120,595'), findsOneWidget);
    expect(find.text('−210,560'), findsOneWidget);
    expect(find.text('What the history shows'), findsOneWidget);
    expect(find.text('Data still required'), findsOneWidget);
    expect(find.textContaining('APC + PDP only'), findsWidgets);
  });

  testWidgets('opens historical election intelligence and forecast scenarios',
      (tester) async {
    tester.view.physicalSize = const Size(1440, 1000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await pumpLoggedInAsDirectorGeneral(tester);
    await tester.tap(find.text('Election Intelligence').first);
    await tester.pumpAndSettle();

    expect(find.text('2015'), findsOneWidget);
    expect(find.text('2019'), findsOneWidget);
    expect(find.text('2023'), findsOneWidget);
    expect(find.text('434,473'), findsOneWidget);

    await tester.tap(find.text('Forecast & Scenarios'));
    await tester.pumpAndSettle();
    expect(find.text('Forecast engine status'), findsOneWidget);
    expect(find.text('Scenario simulator'), findsOneWidget);
    expect(find.textContaining('No fabricated win probability'), findsOneWidget);
  });

  testWidgets('shows campaign trends with prototype data warning',
      (tester) async {
    tester.view.physicalSize = const Size(1440, 1000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await pumpLoggedInAsDirectorGeneral(tester);
    await tester.tap(find.text('Campaign Trends').first);
    await tester.pumpAndSettle();

    expect(find.text('Campaign Trends'), findsWidgets);
    expect(find.text('Momentum Index'), findsOneWidget);
    expect(find.text('Issue trend monitor'), findsOneWidget);
    expect(find.textContaining('Prototype mode'), findsOneWidget);
  });

  testWidgets('situation room is backed by shared incident records',
      (tester) async {
    tester.view.physicalSize = const Size(1440, 1000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await pumpLoggedInAsDirectorGeneral(tester);
    await tester.tap(find.text('Situation Room').first);
    await tester.pumpAndSettle();

    expect(find.text('Incident command feed'), findsOneWidget);
    expect(find.text('Field reporting feed'), findsOneWidget);
    expect(find.textContaining('INC-BEN-LGA-'), findsWidgets);
    expect(find.textContaining('RPT-BEN-LGA-'), findsWidgets);
  });

  testWidgets('opens record-driven campaign operations and media intelligence',
      (tester) async {
    tester.view.physicalSize = const Size(1600, 1100);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await pumpLoggedInAsDirectorGeneral(tester);

    await tester.tap(find.text('Campaign Operations').first);
    await tester.pumpAndSettle();
    expect(find.text('Field assignments'), findsWidgets);
    expect(find.text('Campaign activities'), findsOneWidget);
    expect(find.textContaining('ASG-BEN-LGA-'), findsWidgets);

    await tester.tap(find.text('Media Intelligence').first);
    await tester.pumpAndSettle();
    expect(find.text('Narrative verification desk'), findsOneWidget);
    expect(find.text('Individual profiling'), findsOneWidget);
  });
}
