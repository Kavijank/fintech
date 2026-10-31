import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_application/main.dart';

Future<void> signIn(WidgetTester tester) async {
  await tester.pumpWidget(const FintrustDigitalApp());
  expect(find.text('Welcome back, Kavi'), findsOneWidget);
  await tester.enterText(
    find.byKey(const Key('login-email')),
    'kavi@example.com',
  );
  await tester.enterText(
    find.byKey(const Key('login-password')),
    'demo-password',
  );
  await tester.tap(find.text('Sign in securely'));
  await tester.pumpAndSettle();
  await tester.enterText(find.byKey(const Key('mfa-code')), '482106');
  await tester.scrollUntilVisible(
    find.text('Verify & continue'),
    250,
    scrollable: find.byType(Scrollable).first,
  );
  await tester.pumpAndSettle();
  await tester.tap(find.text('Verify & continue'));
  await tester.pumpAndSettle();
  expect(find.text('Banking dashboard'), findsOneWidget);
}

void main() {
  testWidgets('sign-in layout fits a phone screen', (tester) async {
    tester.view.physicalSize = const Size(360, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const FintrustDigitalApp());
    await tester.pumpAndSettle();
    expect(
      tester.widget<MaterialApp>(find.byType(MaterialApp)).title,
      'Fintrust Digital App',
    );
    final layoutError = tester.takeException();
    expect(layoutError, isNull, reason: '$layoutError');
  });

  testWidgets('monthly spending details open from the home dashboard', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await signIn(tester);
    expect(find.byKey(const Key('dashboard-back')), findsNothing);
    await tester.scrollUntilVisible(
      find.text('Monthly spending'),
      300,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('View insights'), findsOneWidget);
    expect(find.text('Quarter'), findsNothing);

    await tester.tap(find.text('View insights'));
    await tester.pumpAndSettle();
    expect(find.text('Spending insights'), findsOneWidget);
    expect(find.text('Quarter'), findsOneWidget);
    await tester.tap(find.byKey(const Key('dashboard-back')));
    await tester.pumpAndSettle();
    expect(find.text('View insights'), findsOneWidget);
    expect(find.text('Spending insights'), findsNothing);

    await tester.tap(find.text('Payments').last);
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('dashboard-back')), findsOneWidget);
    await tester.tap(find.byKey(const Key('dashboard-back')));
    await tester.pumpAndSettle();
    expect(find.text('View insights'), findsOneWidget);
    expect(find.text('Make a payment'), findsNothing);
  });

  testWidgets('MFA sign-in and primary tabs are connected', (tester) async {
    tester.view.physicalSize = const Size(360, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await signIn(tester);

    await tester.tap(find.text('Payments').last);
    await tester.pumpAndSettle();
    expect(find.text('Make a payment'), findsOneWidget);

    await tester.tap(find.text('Search').last);
    await tester.pumpAndSettle();
    expect(find.text('Smart search'), findsOneWidget);
    expect(find.text('Corner Coffee'), findsAtLeastNWidgets(1));
    await tester.tap(find.text('Places'));
    await tester.pumpAndSettle();
    expect(find.text('Branches & ATMs nearby'), findsOneWidget);

    await tester.tap(find.text('Finance').last);
    await tester.pumpAndSettle();
    expect(find.text('Savings & rewards'), findsOneWidget);
    await tester.tap(find.text('Budgets'));
    await tester.pumpAndSettle();
    expect(find.text('October budget'), findsOneWidget);

    await tester.tap(find.text('More').last);
    await tester.pumpAndSettle();
    expect(find.text('Notifications'), findsOneWidget);
    await tester.tap(find.text('Preferences'));
    await tester.pumpAndSettle();
    expect(find.text('Notification preferences'), findsOneWidget);
  });

  testWidgets('transfer can be reviewed and confirmed', (tester) async {
    await signIn(tester);
    await tester.tap(find.text('Payments').last);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Local bank transfer'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byKey(const Key('transfer-amount')), '120');
    await tester.scrollUntilVisible(
      find.text('Continue to schedule'),
      300,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Continue to schedule'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Send now'));
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(
      find.text('Review transfer'),
      300,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Review transfer'));
    await tester.pumpAndSettle();
    expect(find.text('LKR 120.00'), findsOneWidget);

    await tester.tap(find.text('Confirm'));
    await tester.pumpAndSettle();
    expect(find.text('Payment successful'), findsAtLeastNWidgets(1));
  });

  testWidgets('QR payment review is a separate confirmation step', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await signIn(tester);
    await tester.tap(find.text('Payments').last);
    await tester.pumpAndSettle();
    await tester.tap(find.text('QR payments'));
    await tester.pumpAndSettle();
    expect(find.text('Scan QR code'), findsOneWidget);
    await tester.tap(find.text('Continue to payment review'));
    await tester.pumpAndSettle();
    expect(find.text('Review QR payment'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.text('Confirm & pay LKR 18.50'),
      200,
      scrollable: find
          .descendant(
            of: find.byType(QrReviewScreen),
            matching: find.byType(Scrollable),
          )
          .first,
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Confirm & pay LKR 18.50'));
    await tester.pumpAndSettle();
    expect(find.text('Payment successful'), findsAtLeastNWidgets(1));
  });
}
