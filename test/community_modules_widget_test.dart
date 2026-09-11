import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'ui_test_helpers.dart';

void main() {
  testWidgets('director general can open forum and meeting room', (tester) async {
    tester.view.physicalSize = const Size(1600, 1500);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await pumpLoggedInAsDirectorGeneral(tester);

    expect(find.text('Discussion Forum'), findsOneWidget);
    expect(find.text('Meeting Room'), findsOneWidget);

    await tester.tap(find.text('Discussion Forum'));
    await tester.pumpAndSettle();
    expect(find.text('Discussion & Debate Forum'), findsOneWidget);
    expect(find.text('Start a conversation'), findsOneWidget);
    expect(find.text('Share with the campaign community'), findsOneWidget);
    expect(find.textContaining('Prototype'), findsNothing);

    await tester.tap(find.text('Meeting Room'));
    await tester.pumpAndSettle();
    expect(find.text('Campaign Meeting Room'), findsOneWidget);
    expect(find.text('Call a meeting'), findsOneWidget);
    expect(find.text('Your coordination level'), findsOneWidget);
    expect(find.text('State Command'), findsWidgets);
    expect(find.text('My assignments'), findsOneWidget);
    expect(find.text('My location'), findsOneWidget);
    expect(find.text('Group'), findsOneWidget);
  });
}
