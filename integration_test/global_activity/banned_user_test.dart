// ignore_for_file: directives_ordering

import 'package:felloapp/main_dev.dart' as app;
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/pages/hometabs/save/save_view.dart';
import 'package:felloapp/ui/pages/root/root_view.dart';
import 'package:felloapp/util/custom_logger.dart';
import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import '../utils/test_constants.dart';
import '../utils/test_keys.dart';
import '../utils/test_integration_util.dart' as util;

void main() {
  CustomLogger logger = CustomLogger();
  int failCount = 0;
  int passCount = 0;
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Global activity: ', () {
    testWidgets('banned user tests', (tester) async {
      final oldCallback = FlutterError.onError;
      FlutterError.onError = (details) {/* to handle flutter related errors */};

      await app.main();
      await tester.pumpAndSettle();
      S locale = S();
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

      try {
        await util.pumpUntilFound(tester, TestKeys.mobileNoTextField);
        await tester.tap(TestKeys.mobileNoTextField, warnIfMissed: false);
        await util.pumpUntilFound(tester, TestKeys.mobileNoTextField);
        await tester.enterText(
            TestKeys.mobileNoTextField, TestConstants.bannedDepositWithdrawal);
        await util.pumpUntilFound(tester, TestKeys.mobileNext);
        await tester.tap(TestKeys.mobileNext);
        await util.pumpUntilFound(tester, TestKeys.otpTextField);
        await tester.tap(TestKeys.otpTextField, warnIfMissed: false);
        await util.pumpUntilFound(tester, TestKeys.otpTextField);
        await tester.enterText(
            TestKeys.otpTextField, TestConstants.otpVerifyNumber);
        await tester.pump(const Duration(seconds: 3));
        await util.pumpUntilFound(tester, TestKeys.mobileNext);
        await tester.tap(TestKeys.mobileNext);
        await util.pumpUntilFound(tester, find.byType(Save));
        await util.pumpUntilFound(tester, find.byType(Root));
        logger.d('Test case:- Mobile and OTP screen validations - Passed');
        passCount++;
      } catch (e) {
        logger.e('Test case:- Mobile and OTP screen validations - Failed');
        failCount++;
      }

      try {
        //banned user screen check
        await util.pumpUntilFound(tester, find.text(locale.obBlockedSubtitle1));
        await tester.pump(const Duration(seconds: 3));
        expect(find.text(locale.obBlockedTitle), findsOneWidget);
        await tester.pump(const Duration(seconds: 2));
        expect(TestKeys.blockedScreenTermsAndConditions, findsOneWidget);
        await tester.pump(const Duration(seconds: 2));

        //Need to check this

        // logger.d('${locale.obBlockedSubtitle1} ${locale.termsOfService}');
        // expect(
        //     find.text('${locale.obBlockedSubtitle1} ${locale.termsOfService}'),
        //     findsOneWidget);
        // await tester.pump(const Duration(seconds: 3));

        logger.d('Test case:- Banned user screen test - Passed');
        passCount++;
      } catch (e) {
        logger.e('Test case:- Banned user screen test - Failed');
        failCount++;
      }

      await Future.delayed(const Duration(seconds: 5));
      FlutterError.onError = oldCallback;
      logger.i("Test case passed:- $passCount");
      logger.i("Test case failed:- $failCount");
    });
  });
}
