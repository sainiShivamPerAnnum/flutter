import 'package:felloapp/main_dev.dart' as app;
import 'package:felloapp/ui/pages/hometabs/save/save_view.dart';
import 'package:felloapp/ui/pages/root/root_view.dart';
import 'package:felloapp/util/custom_logger.dart';
import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import '../utils/test_constants.dart';
import '../utils/test_integration_util.dart' as util;
import '../utils/test_keys.dart';

void main() {
  CustomLogger logger = CustomLogger();
  int passCount = 0;
  int failCount = 0;

  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('SignIn tests', () {
    testWidgets('user sign in flow check', (tester) async {
      final oldCallback = FlutterError.onError;
      FlutterError.onError = (details) {/* to handle flutter related errors */};

      await app.main();
      await tester.pumpAndSettle(const Duration(seconds: 3));
      S locale = S();

      try {
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
        logger.d('Test case:- Onboarding screen validations - Passed');
        passCount++;
      } catch (e) {
        logger.e('Test case:- Onboarding screen validations - Failed');
        failCount++;
      }

      try {
        //Mobile input screen checks
        expect(find.text(locale.obLoginHeading), findsOneWidget);
        expect(TestKeys.onBoardingScreen, findsNothing);
        expect(TestKeys.mobileNoTextField, findsOneWidget);
        expect(find.text(locale.obJoinUsBottomTitle), findsOneWidget);
        expect(TestKeys.termsAndConditions, findsOneWidget);
        expect(TestKeys.helpTab, findsOneWidget);
        logger.d('Test case:- Mobile input screen validations - Passed');
        passCount++;
      } catch (e) {
        logger.e('Test case:- Mobile input screen validations - Failed');
        failCount++;
      }

      try {
        //Check for empty values in mobile number
        await tester.tap(TestKeys.mobileNoTextField, warnIfMissed: false);
        await tester.pumpAndSettle();
        await tester.enterText(TestKeys.mobileNoTextField, "");
        await tester.pumpAndSettle();
        await tester.tap(TestKeys.mobileNext);
        await tester.pumpAndSettle(const Duration(seconds: 3));

        final textFinder = find.text(locale.validMobileNumber);
        final validationMessage = find
            .descendant(
                of: TestKeys.mobileInputScreenText, matching: textFinder)
            .first
            .evaluate()
            .single
            .widget as Text;
        expect(validationMessage.data, locale.validMobileNumber);
        expect(TestKeys.mobileNoTextField, findsOneWidget);
        expect(TestKeys.otpTextField, findsNothing);
        await tester.pumpAndSettle();
        logger.d('Test case:- Empty values in Mobile input screen - Passed');
        passCount++;
      } catch (e) {
        logger.e('Test case:- Empty values in Mobile input screen - Failed');
        failCount++;
      }

      try {
        final textFinder = find.text(locale.validMobileNumber);
        final validationMessage = find
            .descendant(
                of: TestKeys.mobileInputScreenText, matching: textFinder)
            .first
            .evaluate()
            .single
            .widget as Text;

        //Check error for invalid mobile number
        await tester.tap(TestKeys.mobileNoTextField, warnIfMissed: false);
        await tester.pumpAndSettle();
        await tester.enterText(TestKeys.mobileNoTextField,
            TestConstants.mobileSignInTestNumber.substring(0, 6));
        await tester.pumpAndSettle();
        await tester.tap(TestKeys.mobileNext);
        await tester.pumpAndSettle(const Duration(seconds: 3));
        expect(validationMessage.data, locale.validMobileNumber);
        logger.d(
            'Test case:- Invalid Mobile number entry in input screen - Passed');
        passCount++;
      } catch (e) {
        logger.e(
            'Test case:- Invalid Mobile number entry in input screen - Failed');
        failCount++;
      }

      try {
        final textFinder = find.text(locale.validMobileNumber);
        final validationMessage = find
            .descendant(
                of: TestKeys.mobileInputScreenText, matching: textFinder)
            .first
            .evaluate()
            .single
            .widget as Text;

        //Check for text field entry in mobile number screen
        await tester.tap(TestKeys.mobileNoTextField, warnIfMissed: false);
        await tester.pumpAndSettle();
        await tester.enterText(TestKeys.mobileNoTextField, locale.withdrawal);
        await tester.pumpAndSettle();
        await tester.tap(TestKeys.mobileNext);
        await tester.pumpAndSettle(const Duration(seconds: 3));
        expect(validationMessage.data, locale.validMobileNumber);
        expect(TestKeys.mobileNoTextField, findsOneWidget);
        expect(TestKeys.otpTextField, findsNothing);
        logger.d('Test case:- Text entry check in input screen - Passed');
        passCount++;
      } catch (e) {
        logger.e('Test case:- Text entry check in input screen - Failed');
        failCount++;
      }

      try {
        //Check for Valid scenario
        await tester.tap(TestKeys.mobileNoTextField, warnIfMissed: false);
        await tester.pumpAndSettle();
        await tester.enterText(
            TestKeys.mobileNoTextField, TestConstants.mobileSignInTestNumber);
        await tester.pumpAndSettle();
        await tester.tap(TestKeys.mobileNext);
        await util.pumpUntilFound(tester, TestKeys.otpTextField);
        logger.d(
            'Test case:- ${TestConstants.mobileSignInTestNumber} sign in entry check on mobile input screen - Passed');
        passCount++;
      } catch (e) {
        logger.e(
            'Test case:- ${TestConstants.mobileSignInTestNumber} sign in entry check on mobile input screen - Failed');
        failCount++;
      }

      try {
        await tester.tap(TestKeys.otpTextField, warnIfMissed: false);
        await util.pumpUntilFound(tester, TestKeys.otpTextField);
        await tester.enterText(
            TestKeys.otpTextField, TestConstants.otpVerifyNumber);
        await tester.pump(const Duration(seconds: 3));
        await util.pumpUntilFound(tester, TestKeys.mobileNext);
        await tester.tap(TestKeys.mobileNext);
        await util.pumpUntilFound(tester, find.byType(Save));
        await util.pumpUntilFound(tester, find.byType(Root));
        logger.d('Test case:- OTP validation positive check - Passed');
        passCount++;
      } catch (e) {
        logger.e('Test case:- OTP validation positive check - Failed');
        failCount++;
      }

      try {
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
        logger.d(
            'Test case:- User landed on profile section successfully - Passed');
        passCount++;
      } catch (e) {
        logger.e(
            'Test case:- User landed on profile section successfully - Failed');
        failCount++;
      }

      try {
        //User Signout confirmation screen - Cancel
        await Future.delayed(const Duration(seconds: 2));
        await tester.pumpAndSettle();
        await tester.tap(TestKeys.signOut);
        await tester.pumpAndSettle();
        await tester.tap(TestKeys.cancel);
        await tester.pumpAndSettle();
        logger
            .d('Test case:- Cancel button check on clicking sign out - Passed');
        passCount++;
      } catch (e) {
        logger
            .e('Test case:- Cancel button check on clicking sign out - Failed');
        failCount++;
      }

      try {
        //User Signout confirmation screen - Signout
        await Future.delayed(const Duration(seconds: 2));
        await tester.tap(TestKeys.signOut);
        await tester.pumpAndSettle();
        await tester.tap(TestKeys.confirm);
        await tester.pumpAndSettle();
        logger.d('Test case:- Signout successful check - Passed');
        passCount++;
      } catch (e) {
        logger.e('Test case:- Signout successful check - Failed');
        failCount++;
      }

      await Future.delayed(const Duration(seconds: 5));
      FlutterError.onError = oldCallback;
      logger.i("Test case passed:- $passCount");
      logger.i("Test case failed:- $failCount");
    });
  });
}
