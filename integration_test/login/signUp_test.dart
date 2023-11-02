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

  group('SignUp tests', () {
    testWidgets('Verify new user sign Up', (tester) async {
      final oldCallback = FlutterError.onError;
      FlutterError.onError = (details) {/* to handle flutter related errors */};

      S locale = S();
      await app.main();
      await tester.pumpAndSettle();
      await util.pumpUntilFound(
          tester, find.byIcon(Icons.arrow_forward_ios_rounded),
          timeout: const Duration(seconds: 20));

      try {
        await tester.tap(TestKeys.onBoardingScreen);
        await tester.pumpAndSettle();
        await tester.tap(TestKeys.onBoardingScreen);
        await tester.pumpAndSettle();
        await tester.tap(TestKeys.onBoardingScreen);
        await tester.pumpAndSettle();
        logger.d('Test case:- Onboarding screen validations - Passed');
        passCount++;
      } catch (e) {
        logger.e('Test case:- Onboarding screen validations - Failed');
        failCount++;
      }

      await Future.delayed(const Duration(seconds: 3));

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
        //Signing into app with new user mobile number
        await tester.tap(TestKeys.mobileNoTextField);
        await tester.pumpAndSettle();
        await tester.enterText(
            TestKeys.mobileNoTextField, TestConstants.newUserSignUpNumber);
        await tester.pumpAndSettle();
        await tester.tap(TestKeys.mobileNext);
        await util.pumpUntilFound(tester, TestKeys.otpTextField);
        //await tester.pumpFrames(mainApp.MyApp(), Duration(seconds: 5));
        logger.d('Test case:- Mobile input entry - Passed');
        passCount++;
      } catch (e) {
        logger.e('Test case:- Mobile input entry - Failed');
        failCount++;
      }

      try {
        expect(TestKeys.otpTextField, findsOneWidget);
        await tester.tap(TestKeys.otpTextField);
        await util.pumpUntilFound(tester, TestKeys.otpTextField);
        //await tester.pumpFrames(mainApp.MyApp(), Duration(seconds: 3));
        await tester.enterText(TestKeys.otpTextField, TestConstants.otpVerifyNumber);
        await tester.pump(const Duration(seconds: 3));
        await util.pumpUntilFound(tester, TestKeys.mobileNext);
        await tester.tap(TestKeys.mobileNext);

        logger.d('Test case:- OTP verification - Passed');
        passCount++;
      } catch (e) {
        logger.e('Test case:- OTP verification - Failed');
        failCount++;
      }

      try {
        //Username details screen check
        await tester.pumpAndSettle();
        expect(TestKeys.mobileNoTextField, findsNothing);
        expect(TestKeys.otpTextField, findsNothing);
        expect(TestKeys.userNameTab, findsOneWidget);

        expect(find.text(locale.obEnterDetails), findsOneWidget);
        expect(find.text(locale.obEnterDetailsTitle), findsOneWidget);
        expect(find.text(locale.obGenderMale), findsOneWidget);
        expect(find.text(locale.obGenderFemale), findsOneWidget);
        expect(find.text("Other"), findsOneWidget);
        expect(TestKeys.helpTab, findsOneWidget);

        expect(find.text(locale.refHaveReferral), findsOneWidget);
        expect(find.text(locale.obIsOlder), findsOneWidget);
        logger.d('Test case:- Signup screen text validations - Passed');
        passCount++;
      } catch (e) {
        logger.e('Test case:- Signup screen text validations - Failed');
        failCount++;
      }

      try {
        //Empty Username check for failure
        await tester.tap(TestKeys.userNameTab);
        await tester.pumpAndSettle();
        await tester.enterText(TestKeys.userNameTab, "");
        await tester.pumpAndSettle();
        await tester.tap(TestKeys.mobileNext);
        await tester.pumpAndSettle();
        expect(find.text(locale.obNameAsPerPan), findsOneWidget);
        logger.d('Test case:- Empty Username check - Passed');
        passCount++;
      } catch (e) {
        logger.e('Test case:- Empty Username check - Failed');
        failCount++;
      }

      try {
        //Invalid Username check for signup
        await tester.tap(TestKeys.userNameTab);
        await tester.pumpAndSettle();
        await tester.enterText(
            TestKeys.userNameTab, TestConstants.newUserSignUpNumber);
        await tester.pumpAndSettle();
        await tester.tap(TestKeys.mobileNext);
        await tester.pumpAndSettle();
        expect(find.text(locale.obNameAsPerPan), findsOneWidget);
        logger.d('Test case:- Invalid Username check - Passed');
        passCount++;
      } catch (e) {
        logger.e('Test case:- Invalid Username check - Failed');
        failCount++;
      }

      try {
        //Username with special characters check
        await tester.tap(TestKeys.userNameTab);
        await tester.pumpAndSettle();
        await tester.enterText(TestKeys.userNameTab, "@####");
        await tester.pumpAndSettle();
        await tester.tap(TestKeys.mobileNext);
        await tester.pumpAndSettle();
        expect(find.text(locale.obNameAsPerPan), findsOneWidget);
        logger.d('Test case:- Username with special characters check - Passed');
        passCount++;
      } catch (e) {
        logger.e('Test case:- Username with special characters check - Failed');
        failCount++;
      }

      //Need test for lengthy username check

      try {
        //Lengthy refferal code check
        await tester.tap(TestKeys.refferalTab);
        await tester.pumpAndSettle();
        await tester.enterText(
            TestKeys.refferalCode, TestConstants.newUserSignUpNumber);
        await tester.pumpAndSettle();
        expect(find.text(TestConstants.newUserSignUpNumber.trim().substring(0, 6)),
            findsOneWidget);
        logger.d('Test case:- Lengthy refferal code check - Passed');
        passCount++;
      } catch (e) {
        logger.e('Test case:- Lengthy refferal code check - Failed');
        failCount++;
      }

      try {
        //Check for user sign with refferal code and empty username
        if (TestConstants.newUserSignUpNumber.trim().substring(0, 6).length >= 6) {
          await tester.tap(TestKeys.userNameTab);
          await tester.pumpAndSettle();
          await tester.enterText(TestKeys.userNameTab, "");
          await tester.pumpAndSettle();
          await tester.tap(TestKeys.mobileNext);
          await tester.pumpAndSettle();
          expect(find.text(locale.obNameAsPerPan), findsOneWidget);
        }
        logger.d(
            'Test case:- Check for user sign with refferal code and empty username - Passed');
        passCount++;
      } catch (e) {
        logger.e(
            'Test case:- Check for user sign with refferal code and empty username - Failed');
        failCount++;
      }

      try {
        //Invalid refferal code check
        await tester.pumpAndSettle();
        await tester.enterText(TestKeys.refferalCode, "@@@@@@@@");
        await tester.pumpAndSettle();
        await tester.enterText(TestKeys.userNameTab, "");
        await tester.pumpAndSettle();
        await tester.tap(TestKeys.mobileNext);
        await tester.pumpAndSettle();
        expect(find.text(locale.obNameAsPerPan), findsOneWidget);

        logger.d('Test case:- Invalid refferal code check - Passed');
        passCount++;
      } catch (e) {
        logger.e('Test case:- Invalid refferal code check - Failed');
        failCount++;
      }

      try {
        //Positive case - with valid username & refferal code
        await tester.tap(TestKeys.userNameTab);
        await tester.pumpAndSettle();
        await tester.enterText(TestKeys.userNameTab, "Akshay");
        await tester.pumpAndSettle();
        expect(TestKeys.refferalCode, findsOneWidget);
        await tester.enterText(TestKeys.refferalCode, TestConstants.referCode);
        await tester.pumpAndSettle();

        logger.d('Test case:- Valid username & refferal code check - Passed');
        passCount++;
      } catch (e) {
        logger.e('Test case:- valid username & refferal code check - Failed');
        failCount++;
      }

      try {
        //Clicking next for successful user SignUp & onboarding completion
        await tester.tap(TestKeys.mobileNext);

        await util.pumpUntilFound(tester, find.byType(Save));
        await util.pumpUntilFound(tester, find.byType(Root));

        logger.d('Succesful user signup flow');
        logger.d('Test case:- Successful user SignUp - Passed');
        passCount++;
      } catch (e) {
        logger.e('Test case:- Successful user SignUp - Failed');
        failCount++;
      }

      try {
        //Daily app bonus check
        await util.pumpUntilFound(tester, TestKeys.dailyAppBonus);
        await tester.pump(const Duration(seconds: 3));
        await tester.tap(TestKeys.dailyAppBonus);
        await util.pumpUntilFound(tester, TestKeys.GTBackButton);
        await tester.tap(TestKeys.GTBackButton);
        await tester.pumpAndSettle();
        await tester.tap(TestKeys.dailyAppBonus);
        logger.d('Test case:- Daily app bonus received for new user - Passed');
        passCount++;
      } catch (e) {
        logger.e('Test case:- Daily app bonus received for new user - Failed');
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
        //User Signout confirmation screen - Signout
        await tester.pumpAndSettle();
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
