import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:polisphere/benue/benue_app.dart';

void main() {
  testWidgets('LGA selection follows the user across operational modules',
      (tester) async {
    tester.view.physicalSize = const Size(1600, 1100);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const BenueCampaignApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Benue Map').first);
    await tester.pumpAndSettle();

    expect(find.text('Benue Geographic Command'), findsOneWidget);
    await tester.tap(find.text('Demonstrate with Makurdi'));
    await tester.pumpAndSettle();
    expect(find.text('Makurdi LGA'), findsWidgets);

    await tester.tap(find.text('Field Network').first);
    await tester.pumpAndSettle();
    expect(find.text('Makurdi readiness board'), findsOneWidget);

    await tester.tap(find.text('Situation Room').first);
    await tester.pumpAndSettle();
    expect(find.text('Makurdi operational layer'), findsOneWidget);

    await tester.tap(find.text('Logistics & Tasks').first);
    await tester.pumpAndSettle();
    expect(find.text('Makurdi OPERATIONS'), findsOneWidget);

    await tester.tap(find.text('Election Day').first);
    await tester.pumpAndSettle();
    expect(find.text('Makurdi READINESS'), findsOneWidget);

    await tester.tap(find.text('Historical Elections').first);
    await tester.pumpAndSettle();
    expect(find.text('Makurdi Historical Elections'), findsOneWidget);
    expect(find.textContaining('No verified LGA figure loaded'), findsWidgets);
  });
}
