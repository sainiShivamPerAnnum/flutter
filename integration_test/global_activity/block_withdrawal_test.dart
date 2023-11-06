// ignore_for_file: directives_ordering

import 'package:felloapp/main_dev.dart' as app;
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/util/custom_logger.dart';
import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import '../utils/test_constants.dart';
import '../utils/test_keys.dart';
import '../utils/test_integration_util.dart' as util;
import '../utils/test_login_user.dart' as user;

void main() {
  CustomLogger logger = CustomLogger();
  int failCount = 0;
  int passCount = 0;
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Global activity: ', () {
    testWidgets('block user withdrawals for Gold and Flo', (tester) async {
      final oldCallback = FlutterError.onError;
      FlutterError.onError = (details) {/* to handle flutter related errors */};

      await app.main();
      S locale = S();
      await tester.pumpAndSettle();
      await util.pumpUntilFound(
          tester, find.byIcon(Icons.arrow_forward_ios_rounded),
          timeout: const Duration(seconds: 20));

      try {
        await user.onboardingScreen(tester);
        logger.d('Test case:- Onboarding screen validations - Passed');
        passCount++;
      } catch (e) {
        logger.e('Test case:- Onboarding screen validations - Failed');
        failCount++;
      }

      try {
        await user.loginUser(tester, TestConstants.bannedWithdrawalOnly,
            TestConstants.otpVerifyNumber);
        logger.d('Test case:- Mobile and OTP screen validations - Passed');
        passCount++;
      } catch (e) {
        logger.e('Test case:- Mobile and OTP screen validations - Failed');
        failCount++;
      }

      try {
        //Flo - User able to deposit successfully for withdrawal blocked user
        await util.pumpUntilFound(tester, TestKeys.saveNowButton);
        await tester.pump(const Duration(seconds: 3));
        await tester.tap(TestKeys.saveNowButton);
        await util.pumpUntilFound(tester, TestKeys.floFlexiAsset);
        await tester.tap(TestKeys.floFlexiAsset);
        await util.pumpUntilFound(tester, find.text(locale.btnApplyCoupon));
        expect(find.text(locale.btnApplyCoupon), findsOneWidget);

        //back to Save Now screen
        await AppState.backButtonDispatcher!.didPopRoute();
        await tester.pump(const Duration(seconds: 2));
        await util.pumpUntilFound(tester, TestKeys.goBackAnywayButton);

        await tester.tap(TestKeys.goBackAnywayButton);
        await tester.pump(const Duration(seconds: 3));
        await util.pumpUntilFound(tester, TestKeys.floFlexiAsset);

        //back to home screen
        await AppState.backButtonDispatcher!.didPopRoute();
        await tester.pump(const Duration(seconds: 3));
        await util.pumpUntilFound(tester, TestKeys.profileAvatar);
        logger.d('Test case:- User deposits are not blocked - Passed');
        passCount++;
      } catch (e) {
        logger.e('Test case:- User deposits are not blocked - Failed');
        failCount++;
      }

      try {
        //Flo withdrawal blocked for user
        await util.pumpUntilFound(tester, TestKeys.portfolioCard);
        await tester.pump(const Duration(seconds: 3));
        await tester.tap(TestKeys.portfolioCard);
        await tester.pump(const Duration(seconds: 3));
        await Future.delayed(const Duration(seconds: 5));
        await tester.tap(TestKeys.floPortfolioSave);
        await util.pumpUntilFound(tester, TestKeys.saveinFloButton);

        await tester.dragUntilVisible(TestKeys.floWithdraw,
            find.byType(SingleChildScrollView), const Offset(0, 400));
        await util.pumpUntilFound(tester, TestKeys.floWithdraw);
        await tester.tap(TestKeys.floWithdraw);
        await tester.pump(const Duration(seconds: 2));
        await util.pumpUntilFound(tester, find.text(locale.sellingReasons1));
        await tester.tap(find.text(locale.sellingReasons1));
        await tester.pump(const Duration(seconds: 3));
        expect(tester.hasRunningAnimations, isTrue);
        expect(TestKeys.floSaveButton,
            findsNothing); //check for withdrawal screen accessibility
        await util.pumpUntilFound(tester, TestKeys.saveinFloButton);

        //back to portfolio screen
        await AppState.backButtonDispatcher!.didPopRoute();
        await tester.pump(const Duration(seconds: 2));
        await util.pumpUntilFound(tester, TestKeys.floPortfolioSave);

        //back to home screen
        await AppState.backButtonDispatcher!.didPopRoute();
        await tester.pump(const Duration(seconds: 2));
        await util.pumpUntilFound(tester, TestKeys.profileAvatar);
        logger.d('Test case:-Flo Withdrawal blocked for user - Passed');
        passCount++;
      } catch (e) {
        logger.e('Test case:-Flo Withdrawal blocked for user - Failed');
        failCount++;
      }

      try {
        //Gold withdrawal blocked for user
        await util.pumpUntilFound(tester, TestKeys.portfolioCard);
        await tester.pump(const Duration(seconds: 3));
        await tester.tap(TestKeys.portfolioCard);
        await tester.pump(const Duration(seconds: 3));
        await Future.delayed(const Duration(seconds: 5));
        await tester.tap(TestKeys.goldPortfolioSave);
        await util.pumpUntilFound(tester, TestKeys.saveinGoldButton);

        await tester.dragUntilVisible(TestKeys.sellButton,
            find.byType(SingleChildScrollView), const Offset(0, 400));

        await util.pumpUntilFound(tester, TestKeys.sellButton);
        await tester.tap(TestKeys.sellButton);
        await util.pumpUntilFound(tester, find.text(locale.sellingReasons1));

        await tester.tap(find.text(locale.sellingReasons1));
        expect(tester.hasRunningAnimations, isTrue);
        expect(TestKeys.sellGoldButton,
            findsNothing); //check for withdrawal screen accessibility
        await util.pumpUntilFound(tester, TestKeys.saveinGoldButton);

        //back to portfolio screen
        await AppState.backButtonDispatcher!.didPopRoute();
        await tester.pump(const Duration(seconds: 2));
        await util.pumpUntilFound(tester, TestKeys.goldPortfolioSave);

        //back to home screen
        await AppState.backButtonDispatcher!.didPopRoute();
        await tester.pump(const Duration(seconds: 2));
        await util.pumpUntilFound(tester, TestKeys.profileAvatar);
        logger.d('Test case:- Gold Withdrawal blocked for user - Passed');
        passCount++;
      } catch (e) {
        logger.e('Test case:- Gold Withdrawal blocked for user - Failed');
        failCount++;
      }

      try {
        await user.signout(tester);
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
