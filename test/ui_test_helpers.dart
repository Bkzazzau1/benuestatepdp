import 'package:flutter_test/flutter_test.dart';
import 'package:polisphere/benue/benue_app.dart';

Future<void> pumpLoggedInAsDirectorGeneral(WidgetTester tester) async {
  await tester.pumpWidget(const BenueCampaignApp());
  await tester.pumpAndSettle();
  expect(find.text('Welcome to Campaign Command'), findsOneWidget);
  final signIn = find.text('Enter as Director General');
  await tester.ensureVisible(signIn);
  await tester.pumpAndSettle();
  await tester.tap(signIn);
  await tester.pumpAndSettle();
}
