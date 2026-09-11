import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:polisphere/benue/benue_app.dart';

void main() {
  setUp(() {});

  testWidgets('loads the Benue statewide command dashboard', (tester) async {
    tester.view.physicalSize = const Size(1440, 1000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const BenueCampaignApp());
    await tester.pumpAndSettle();

    expect(find.text('POLISPHERE BENUE'), findsOneWidget);
    expect(find.text('23'), findsOneWidget);
    expect(find.text('276'), findsOneWidget);
    expect(find.text('5,102'), findsWidgets);
    expect(find.textContaining('Benue State PDP Governorship Campaign'),
        findsOneWidget);
    expect(find.textContaining('Zaria'), findsNothing);
  });

  testWidgets('opens dedicated historical election analytics', (tester) async {
    tester.view.physicalSize = const Size(1600, 1100);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const BenueCampaignApp());
    await tester.pumpAndSettle();
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

    await tester.pumpWidget(const BenueCampaignApp());
    await tester.pumpAndSettle();
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

    await tester.pumpWidget(const BenueCampaignApp());
    await tester.pumpAndSettle();
    await tester.tap(find.text('Campaign Trends').first);
    await tester.pumpAndSettle();

    expect(find.text('Campaign Trends'), findsWidgets);
    expect(find.text('Momentum Index'), findsOneWidget);
    expect(find.text('Issue trend monitor'), findsOneWidget);
    expect(find.textContaining('Prototype mode'), findsOneWidget);
  });

  testWidgets('shows statewide situation room and LGA operational layer',
      (tester) async {
    tester.view.physicalSize = const Size(1440, 1000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const BenueCampaignApp());
    await tester.pumpAndSettle();
    await tester.tap(find.text('Situation Room').first);
    await tester.pumpAndSettle();

    expect(find.text('Benue operational map'), findsOneWidget);
    expect(find.text('Makurdi'), findsWidgets);
    expect(find.text('Gboko'), findsWidgets);
    expect(find.text('Otukpo'), findsWidgets);
    expect(find.text('Priority feed'), findsOneWidget);
  });

  testWidgets('opens campaign operations and media intelligence modules',
      (tester) async {
    tester.view.physicalSize = const Size(1600, 1100);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const BenueCampaignApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Campaign Operations').first);
    await tester.pumpAndSettle();
    expect(find.text('Campaign command structure'), findsOneWidget);
    expect(find.text('Candidate movement & engagement workflow'), findsOneWidget);

    await tester.tap(find.text('Media Intelligence').first);
    await tester.pumpAndSettle();
    expect(find.text('Narrative verification desk'), findsOneWidget);
    expect(find.text('Individual profiling'), findsOneWidget);
  });
}
