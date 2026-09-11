import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:polisphere/benue/benue_app.dart';

void main() {
  testWidgets('polling unit agent sees only role-appropriate modules',
      (tester) async {
    tester.view.physicalSize = const Size(1600, 1100);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const BenueCampaignApp());
    await tester.pumpAndSettle();

    expect(find.text('Welcome to Campaign Command'), findsOneWidget);
    await tester.tap(find.text('Polling Unit Agent'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Enter as Polling Unit Agent'));
    await tester.pumpAndSettle();

    expect(find.text('Command Overview'), findsOneWidget);
    expect(find.text('Communications'), findsOneWidget);
    expect(find.text('Discussion Forum'), findsOneWidget);
    expect(find.text('Meeting Room'), findsOneWidget);
    expect(find.text('Election Day'), findsOneWidget);

    expect(find.text('Data & Governance'), findsNothing);
    expect(find.text('Media Intelligence'), findsNothing);
    expect(find.text('Logistics & Tasks'), findsNothing);
    expect(find.text('Historical Elections'), findsNothing);
  });
}
