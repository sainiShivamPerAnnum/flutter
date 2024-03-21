import 'package:felloapp/ui/pages/hometabs/save/save_view.dart';
import 'package:felloapp/ui/pages/root/root_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../utils/test_integration_util.dart' as util;
import '../utils/test_keys.dart';

Future<void> loginUser(
    WidgetTester tester, String mobile, String otp) async {
  await util.pumpUntilFound(tester, TestKeys.mobileNoTextField);
  await tester.tap(TestKeys.mobileNoTextField, warnIfMissed: false);
  await util.pumpUntilFound(tester, TestKeys.mobileNoTextField);
  await tester.enterText(TestKeys.mobileNoTextField, mobile);
  await util.pumpUntilFound(tester, TestKeys.mobileNext);
  await tester.tap(TestKeys.mobileNext);
  await util.pumpUntilFound(tester, TestKeys.otpTextField);
  await tester.tap(TestKeys.otpTextField, warnIfMissed: false);
  await util.pumpUntilFound(tester, TestKeys.otpTextField);
  await tester.enterText(TestKeys.otpTextField, otp);
  await tester.pump(const Duration(seconds: 3));
  await util.pumpUntilFound(tester, TestKeys.mobileNext);
  await tester.tap(TestKeys.mobileNext);
  await util.pumpUntilFound(tester, find.byType(Save));
  await util.pumpUntilFound(tester, find.byType(Root));
}

Future<void> onboardingScreen(WidgetTester tester) async {
  //Check for onboarding screens
  // expect(find.text(locale.onboardingTitle1), findsOneWidget);
  // expect(find.text(locale.onboardingSubTitle1), findsOneWidget);
  // expect(TestKeys.onBoardingScreen, findsOneWidget);
  await tester.tap(TestKeys.onBoardingScreen);
  await tester.pumpAndSettle();

  // expect(find.text(locale.onboardingTitle2), findsOneWidget);
  // expect(find.text(locale.onboardingSubTitle2), findsOneWidget);
  // expect(TestKeys.onBoardingScreen, findsOneWidget);
  await tester.tap(TestKeys.onBoardingScreen);
  await tester.pumpAndSettle();

  // expect(TestKeys.onBoardingScreen, findsOneWidget);
  // expect(find.text(locale.onboardingTitle3), findsOneWidget);
  // expect(find.text(locale.onboardingSubTitle3), findsOneWidget);
  await tester.tap(TestKeys.onBoardingScreen);
  await tester.pumpAndSettle();
}

Future<void> signout(WidgetTester tester) async {
  //Click on Profile Avatar on save section
  await tester.pump(const Duration(seconds: 3));
  await Future.delayed(const Duration(seconds: 5));
  await tester.tap(TestKeys.profileAvatar);
  await util.pumpUntilFound(tester, TestKeys.profile);

  //Click on profile section
  await tester.tap(TestKeys.profile);
  await tester.pumpAndSettle();
  await tester.dragUntilVisible(TestKeys.signOut,
      find.byType(SingleChildScrollView), const Offset(0, 400));

  //User Signout confirmation screen - Signout
  await tester.pumpAndSettle();
  await tester.tap(TestKeys.signOut);
  await tester.pumpAndSettle();
  await tester.tap(TestKeys.confirm);
  await tester.pumpAndSettle();
}
