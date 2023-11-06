import 'package:felloapp/main_dev.dart' as app;
import 'package:felloapp/util/custom_logger.dart';
import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import '../utils/test_constants.dart';
import '../utils/test_integration_util.dart' as util;
import '../utils/test_keys.dart';
import '../utils/test_login_user.dart' as user;

void main() {
  CustomLogger logger = CustomLogger();
  int passCount = 0;
  int failCount = 0;
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('OTP Screen', () {
    testWidgets('onboarding screen', (tester) async {
      final oldCallback = FlutterError.onError;
      FlutterError.onError = (details) {/* to handle flutter related errors */};

      await app.main();
      await tester.pumpAndSettle(const Duration(seconds: 5));
      S locale = S();

      await user.onboardingScreen(tester);

      //Check valid mobile number
      await tester.tap(TestKeys.mobileNoTextField);
      await tester.pumpAndSettle();
      await tester.enterText(
          TestKeys.mobileNoTextField, TestConstants.mobileSignInTestNumber);
      await tester.pumpAndSettle();
      await tester.tap(TestKeys.mobileNext);
      await tester.pumpAndSettle();

      try {
        //Click on RESEND OTP #1
        await util.pumpUntilFound(tester, TestKeys.otpTextField);
        expect(TestKeys.otpResend, findsOneWidget);
        await tester.tap(TestKeys.otpResend);
        await tester.pumpAndSettle();
        expect(TestKeys.otpResend, findsOneWidget);
        logger.d('Test case - Click on Resend OTP clicked 1 - Passed');
        passCount++;
      } catch (e) {
        logger.e('Test case -Click on Resend OTP clicked 1 - Failed');
        failCount++;
      }

      try {
        //Click on RESEND OTP #2
        await tester.tap(TestKeys.otpResend);
        await tester.pumpAndSettle();
        expect(TestKeys.otpResend, findsOneWidget);
        logger.d('Test case - Click on Resend OTP clicked 2 - Passed');
        passCount++;
      } catch (e) {
        logger.e('Test case -Click on Resend OTP clicked 2 - Failed');
        failCount++;
      }

      try {
        //Click on RESEND OTP #3
        await tester.tap(TestKeys.otpResend);
        await tester.pumpAndSettle();
        expect(find.text(locale.obOtpTryExceed), findsOneWidget);
        expect(find.text(locale.obDidntGetOtp), findsNothing);
        expect(find.text(locale.obOtpRequest), findsNothing);
        logger.d('Test case - Click on Resend OTP clicked 3 - Passed');
        passCount++;
      } catch (e) {
        logger.e('Test case - Click on Resend OTP clicked 3 - Failed');
        failCount++;
      }

      try {
        //Checks error response for invalid length otp
        await tester.tap(TestKeys.otpTextField);
        await tester.enterText(TestKeys.otpTextField,
            TestConstants.otpVerifyNumber.substring(0, 5));
        await tester.tap(TestKeys.mobileNext);
        expect(tester.hasRunningAnimations, isTrue);
        await tester.pumpAndSettle();
        logger.d('Test case - Invalid length OTP check - Passed');
        passCount++;
      } catch (e) {
        logger.e('Test case - invalid length OTP Check - Failed');
        failCount++;
      }

      await Future.delayed(const Duration(seconds: 5));
      FlutterError.onError = oldCallback;
      logger.i("Test case passed:- $passCount");
      logger.i("Test case failed:- $failCount");
    });
  });
}
