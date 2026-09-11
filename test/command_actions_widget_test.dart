import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'ui_test_helpers.dart';

void main() {
  testWidgets('creating an LGA incident immediately appears in Situation Room',
      (tester) async {
    tester.view.physicalSize = const Size(1700, 1100);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await pumpLoggedInAsDirectorGeneral(tester);

    await tester.tap(find.text('Benue Map').first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Makurdi').first);
    await tester.pumpAndSettle();

    expect(find.textContaining('EDITING MAKURDI'), findsOneWidget);

    await tester.tap(find.text('New incident'));
    await tester.pumpAndSettle();

    final titleField = find.byWidgetPredicate(
      (widget) =>
          widget is TextField &&
          widget.decoration?.labelText == 'Incident title *',
    );
    expect(titleField, findsOneWidget);
    await tester.enterText(titleField, 'New Makurdi test incident');

    await tester.tap(find.text('Create incident'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Situation Room').first);
    await tester.pumpAndSettle();

    expect(find.text('New Makurdi test incident'), findsOneWidget);
    expect(find.textContaining('Makurdi LGA'), findsWidgets);
  });
}
