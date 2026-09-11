import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:polisphere/src/app.dart';

void main() {
  testWidgets('shows the field operations dashboard', (tester) async {
    await tester.pumpWidget(const PoliSphereApp());
    expect(find.text('POLISPHERE'), findsOneWidget);
    expect(find.text('Amina Yusuf'), findsOneWidget);
    expect(find.text('CURRENT ASSIGNMENT'), findsOneWidget);
  });

  testWidgets('opens the situation report form', (tester) async {
    await tester.pumpWidget(const PoliSphereApp());
    await tester.tap(find.text('New report'));
    await tester.pumpAndSettle();
    expect(find.text('New situation report'), findsOneWidget);
    await tester.drag(find.byType(Scrollable).last, const Offset(0, -800));
    await tester.pumpAndSettle();
    expect(find.text('Submit report'), findsOneWidget);
  });

  testWidgets('shows the desktop situation room', (tester) async {
    tester.view.physicalSize = const Size(1440, 1000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const PoliSphereApp());
    await tester.pumpAndSettle();

    expect(find.text('SITUATION ROOM'), findsOneWidget);
    expect(find.text('Command dashboard'), findsOneWidget);
    expect(find.text('Priority incident queue'), findsOneWidget);
    expect(
        find.text('Raw submissions are not confirmed facts'), findsOneWidget);
  });

  testWidgets('acknowledges an alert without resolving it', (tester) async {
    tester.view.physicalSize = const Size(1440, 1000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const PoliSphereApp());
    await tester.pumpAndSettle();
    await tester.tap(find.text('Acknowledge').first);
    await tester.pump();

    expect(find.text('ACKNOWLEDGED'), findsOneWidget);
    expect(find.text('Agent SOS received'), findsOneWidget);
  });

  testWidgets('opens the AI copilot and returns a source-aware answer',
      (tester) async {
    tester.view.physicalSize = const Size(1440, 1000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const PoliSphereApp());
    await tester.pumpAndSettle();
    await tester.tap(find.text('Ask Poli AI'));
    await tester.pump();

    expect(find.text('Poli AI Copilot'), findsOneWidget);
    await tester.tap(find.text('What needs attention?'));
    await tester.pump(const Duration(milliseconds: 700));

    expect(find.textContaining('Current priority: INC-00518'), findsOneWidget);
    expect(find.textContaining('3 linked reports'), findsOneWidget);
  });

  testWidgets('shows transparent AI work and governance controls',
      (tester) async {
    tester.view.physicalSize = const Size(1440, 1000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const PoliSphereApp());
    await tester.pumpAndSettle();
    await tester.tap(find.text('AI intelligence'));
    await tester.pumpAndSettle();

    expect(find.text('Poli AI Intelligence'), findsOneWidget);
    expect(find.text('AI workstream'), findsOneWidget);
    expect(find.text('Human decision required'), findsOneWidget);
  });

  testWidgets('filters evidence and exposes chain of custody', (tester) async {
    tester.view.physicalSize = const Size(1440, 1000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const PoliSphereApp());
    await tester.pumpAndSettle();
    await tester.tap(find.text('Evidence'));
    await tester.pumpAndSettle();

    expect(find.text('Evidence center'), findsOneWidget);
    expect(find.text('ORIGINALS IMMUTABLE'), findsOneWidget);
    expect(find.text('EVD-2026-01842'), findsWidgets);

    await tester.drag(find.byType(ListView).last, const Offset(0, -600));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Audit trail'));
    await tester.pumpAndSettle();
    expect(find.textContaining('Chain of custody'), findsOneWidget);
    expect(find.text('SHA-256 integrity verified'), findsOneWidget);
    await tester.tap(find.text('Done'));
    await tester.pumpAndSettle();

    await tester.enterText(
        find.byType(TextField).first, 'accreditation document');
    await tester.pump();
    expect(find.text('EVD-2026-01836'), findsWidgets);
    expect(find.text('EVD-2026-01841'), findsNothing);
  });

  testWidgets('shows agent assignments, teams and acoustic AI state',
      (tester) async {
    tester.view.physicalSize = const Size(1440, 1000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const PoliSphereApp());
    await tester.pumpAndSettle();
    await tester.tap(find.text('Agents'));
    await tester.pumpAndSettle();

    expect(find.text('Agent operations'), findsOneWidget);
    expect(find.text('Amina Yusuf'), findsWidgets);
    expect(find.text('Polling Unit 014'), findsWidgets);
    expect(find.text('Garki Response Team'), findsWidgets);
    expect(find.text('Acoustic AI monitoring'), findsOneWidget);

    await tester.drag(find.byType(ListView).last, const Offset(0, -450));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Request acoustic AI report'));
    await tester.pumpAndSettle();
    expect(find.text('Authorized session required'), findsOneWidget);
  });

  testWidgets('requires a reason and records verification decisions',
      (tester) async {
    tester.view.physicalSize = const Size(1440, 1000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const PoliSphereApp());
    await tester.pumpAndSettle();
    await tester.tap(find.text('Verification'));
    await tester.pumpAndSettle();

    expect(find.text('Verification center'), findsOneWidget);
    expect(find.text('SUBMITTED ≠ VERIFIED'), findsOneWidget);
    expect(find.text('Original submission'), findsOneWidget);
    expect(find.text('Corroboration & conflicts'), findsOneWidget);

    await tester.ensureVisible(find.text('Verify report'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Verify report'));
    await tester.pumpAndSettle();
    expect(find.text('Decision reason (required)'), findsOneWidget);
    await tester.enterText(
        find.byType(TextField).last, 'Confirmed by independent source review');
    await tester.tap(find.text('Verify').last);
    await tester.pumpAndSettle();

    expect(find.text('VERIFIED'), findsWidgets);
  });

  testWidgets('shows aggregate source-aware social intelligence',
      (tester) async {
    tester.view.physicalSize = const Size(1440, 1100);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const PoliSphereApp());
    await tester.pumpAndSettle();
    await tester.tap(find.text('Social pulse'));
    await tester.pumpAndSettle();

    expect(find.text('Social Pulse'), findsOneWidget);
    expect(find.text('Emerging public topics'), findsOneWidget);
    expect(find.text('Polling-unit access'), findsWidgets);
    expect(find.text('AI GENERATED'), findsOneWidget);
    expect(find.text('HUMAN REVIEW PENDING'), findsOneWidget);
    expect(find.text('Public-source feed'), findsOneWidget);
    expect(find.textContaining('no individual profiles'), findsOneWidget);
  });

  testWidgets('shows and approves a source-backed daily brief', (tester) async {
    tester.view.physicalSize = const Size(1440, 1100);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const PoliSphereApp());
    await tester.pumpAndSettle();
    await tester.tap(find.text('Daily brief'));
    await tester.pumpAndSettle();

    expect(find.text('Daily command brief'), findsOneWidget);
    expect(find.text('EXECUTIVE SUMMARY'), findsOneWidget);
    expect(find.text('AI DRAFT • REVIEW REQUIRED'), findsOneWidget);
    expect(find.text('Command priorities'), findsOneWidget);
    expect(find.text('Source register'), findsOneWidget);

    await tester.tap(find.text('Approve brief').first);
    await tester.pumpAndSettle();
    expect(find.text('Approval note (required)'), findsOneWidget);
    await tester.enterText(find.byType(TextField).last,
        'Reviewed against all cited operational records');
    await tester.tap(find.text('Approve brief').last);
    await tester.pumpAndSettle();

    expect(find.text('APPROVED'), findsOneWidget);
  });

  testWidgets('shows secure sessions and consent-controlled media requests',
      (tester) async {
    tester.view.physicalSize = const Size(1600, 1100);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const PoliSphereApp());
    await tester.pumpAndSettle();
    await tester.tap(find.text('Communications'));
    await tester.pumpAndSettle();

    expect(find.text('Secure communications'), findsOneWidget);
    expect(find.text('Garki incident room'), findsOneWidget);
    expect(find.text('Connection telemetry'), findsOneWidget);
    expect(find.text('Explicit media consent'), findsOneWidget);

    await tester.tap(find.text('Request media'));
    await tester.pumpAndSettle();
    expect(find.text('Request live media'), findsOneWidget);
    expect(find.textContaining('never activates the camera'), findsOneWidget);
    expect(find.text('Operational reason (required)'), findsOneWidget);
  });

  testWidgets('shows incident command context and opens the timeline console',
      (tester) async {
    tester.view.physicalSize = const Size(1600, 1100);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const PoliSphereApp());
    await tester.pumpAndSettle();
    await tester.tap(find.text('Incidents'));
    await tester.pumpAndSettle();

    expect(find.text('Incident command'), findsOneWidget);
    expect(find.text('Reported disturbance at polling-unit entrance'),
        findsOneWidget);
    expect(find.text('AI-ASSISTED SIGNALS'), findsOneWidget);
    expect(find.text('SLA expires in 04:18'), findsOneWidget);

    await tester
        .tap(find.text('Reported disturbance at polling-unit entrance'));
    await tester.pumpAndSettle();
    expect(find.text('Incident timeline'), findsOneWidget);
    expect(find.text('Command actions'), findsOneWidget);
    expect(find.text('Request live video'), findsOneWidget);
  });

  testWidgets('shows professional map context and location-session controls',
      (tester) async {
    tester.view.physicalSize = const Size(1600, 1100);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const PoliSphereApp());
    await tester.pumpAndSettle();
    await tester.tap(find.text('Live map'));
    await tester.pumpAndSettle();

    expect(find.text('Live operational map'), findsOneWidget);
    expect(find.text('MAP LEGEND'), findsOneWidget);
    expect(find.text('Purpose-limited operational locations • scope enforced'),
        findsOneWidget);
    expect(find.text('Open incident console'), findsOneWidget);

    await tester.tap(find.text('Amina Yusuf').first);
    await tester.pumpAndSettle();
    expect(find.text('Location session'), findsOneWidget);
    expect(find.text('Active operational session'), findsOneWidget);
    expect(find.text('Request location refresh'), findsOneWidget);
    expect(find.text('±12 m accuracy'), findsWidgets);
  });
}
