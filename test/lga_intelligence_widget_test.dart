import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'ui_test_helpers.dart';

void main() {
  testWidgets('opens LGA Intelligence Unit with statewide summary and Makurdi profile',
      (tester) async {
    tester.view.physicalSize = const Size(1600, 1100);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await pumpLoggedInAsDirectorGeneral(tester);
    await tester.tap(find.text('Election Intelligence').first);
    await tester.pumpAndSettle();

    expect(find.text('Strategic Intelligence'), findsOneWidget);
    expect(find.text('LGA Intelligence Unit'), findsOneWidget);

    await tester.tap(find.text('LGA Intelligence Unit'));
    await tester.pumpAndSettle();

    expect(find.text('Local Government Intelligence Unit'), findsOneWidget);
    expect(find.text('One-page Benue election summary'), findsOneWidget);
    expect(find.text('23-LGA intelligence index'), findsOneWidget);
    expect(find.text('Makurdi'), findsWidgets);
    expect(find.text('TOP-TIER BATTLEGROUND'), findsOneWidget);

    await tester.scrollUntilVisible(
      find.text('Ward intelligence readiness'),
      400,
      scrollable: find.byType(Scrollable).last,
    );
    expect(find.text('Ward intelligence readiness'), findsOneWidget);
    expect(find.textContaining('No fabricated ward inference'), findsOneWidget);
  });
}
