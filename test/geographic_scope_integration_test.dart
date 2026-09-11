import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'ui_test_helpers.dart';

void main() {
  testWidgets('Makurdi selection carries the same campaign scope across modules',
      (tester) async {
    tester.view.physicalSize = const Size(1600, 1100);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await pumpLoggedInAsDirectorGeneral(tester);

    await tester.tap(find.text('Benue Map').first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Makurdi').first);
    await tester.pumpAndSettle();
    expect(find.text('Makurdi LGA Command'), findsOneWidget);

    await tester.tap(find.text('Field Network').first);
    await tester.pumpAndSettle();
    expect(find.text('Field Network'), findsWidgets);
    expect(find.textContaining('Makurdi LGA'), findsWidgets);

    await tester.tap(find.text('Situation Room').first);
    await tester.pumpAndSettle();
    expect(find.text('Situation Room'), findsWidgets);
    expect(find.textContaining('Makurdi LGA'), findsWidgets);

    await tester.tap(find.text('Logistics & Tasks').first);
    await tester.pumpAndSettle();
    expect(find.text('Makurdi Operations Vehicle 01'), findsOneWidget);
    expect(find.text('Task board'), findsOneWidget);

    await tester.tap(find.text('Election Day').first);
    await tester.pumpAndSettle();
    expect(find.text('Election Day'), findsWidgets);
    expect(find.text('Readiness by area'), findsOneWidget);
    expect(find.text('Makurdi'), findsWidgets);

    await tester.tap(find.text('Communications').first);
    await tester.pumpAndSettle();
    expect(find.text('Makurdi Campaign Communications'), findsOneWidget);
    expect(find.text('Makurdi Operations'), findsWidgets);

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
