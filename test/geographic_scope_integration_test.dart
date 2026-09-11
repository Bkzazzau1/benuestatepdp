import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'ui_test_helpers.dart';

void main() {
  testWidgets('Makurdi selection resolves the same shared records across modules',
      (tester) async {
    tester.view.physicalSize = const Size(1600, 1100);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await pumpLoggedInAsDirectorGeneral(tester);

    await tester.tap(find.text('Benue Map').first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Demonstrate with Makurdi'));
    await tester.pumpAndSettle();
    expect(find.text('Makurdi LGA'), findsWidgets);

    await tester.tap(find.text('Field Network').first);
    await tester.pumpAndSettle();
    expect(find.text('ASG-BEN-LGA-13-COORD'), findsOneWidget);

    await tester.tap(find.text('Situation Room').first);
    await tester.pumpAndSettle();
    expect(find.text('INC-BEN-LGA-13-001'), findsOneWidget);

    await tester.tap(find.text('Logistics & Tasks').first);
    await tester.pumpAndSettle();
    expect(find.text('TSK-BEN-LGA-13-001'), findsOneWidget);
    expect(find.text('AST-BEN-LGA-13-VEH-01'), findsOneWidget);

    await tester.tap(find.text('Election Day').first);
    await tester.pumpAndSettle();
    expect(find.text('READY-BEN-LGA-13-001'), findsOneWidget);

    await tester.tap(find.text('Communications').first);
    await tester.pumpAndSettle();
    expect(find.text('INC-BEN-LGA-13-001'), findsOneWidget);
    expect(find.text('ROOM-INC-BEN-LGA-13-001'), findsOneWidget);

    await tester.tap(find.text('Historical Elections').first);
    await tester.pumpAndSettle();

    expect(find.text('Makurdi LGA'), findsWidgets);
    expect(find.textContaining('2015 • 2019 • 2023 sourced comparison'), findsOneWidget);
    expect(find.text('2019 governorship'), findsOneWidget);
    expect(find.text('2023 governorship'), findsOneWidget);
    expect(find.text('36,517'), findsOneWidget);
    expect(find.text('29,414'), findsOneWidget);
    expect(find.text('56,432'), findsOneWidget);
    expect(find.text('12,329'), findsOneWidget);
    expect(find.textContaining('No sourced LGA row'), findsOneWidget);
  });
}
