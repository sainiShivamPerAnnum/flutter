// ignore_for_file: directives_ordering

import 'package:felloapp/main_dev.dart' as app;
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/util/custom_logger.dart';
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
    testWidgets('block user deposit for Gold and Flo', (tester) async {
      final oldCallback = FlutterError.onError;
      FlutterError.onError = (details) {/* to handle flutter related errors */};

      await app.main();
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
        await user.loginUser(tester, TestConstants.bannedUserDepositOnly,
            TestConstants.otpVerifyNumber);
        logger.d('Test case:- Mobile and OTP screen validations - Passed');
        passCount++;
      } catch (e) {
        logger.e('Test case:- Mobile and OTP screen validations - Failed');
        failCount++;
      }

      try {
        //Flo basic 10% save blocked for users clicking from SAVE NOW button
        await util.pumpUntilFound(tester, TestKeys.saveNowButton);
        await tester.pump(const Duration(seconds: 3));
        await tester.tap(TestKeys.saveNowButton);
        await util.pumpUntilFound(tester, TestKeys.floFlexiAsset);
        await tester.tap(TestKeys.floFlexiAsset);
        expect(tester.hasRunningAnimations, isTrue);
        await Future.delayed(const Duration(seconds: 5));
        expect(TestKeys.floAmountInput, findsNothing);
        expect(TestKeys.floSaveButton, findsNothing);
        await util.pumpUntilFound(tester, TestKeys.floFlexiAsset);

        //back to home screen
        await AppState.backButtonDispatcher!.didPopRoute();
        await util.pumpUntilFound(tester, TestKeys.profileAvatar);
        logger.d('Test case:- Flo basic 10%  save blocked for user - Passed');
        passCount++;
      } catch (e) {
        logger.e('Test case:- Flo basic 10% save blocked for user - Failed');
        failCount++;
      }

      try {
        //Flo fixed 12% save blocked for users clicking from SAVE NOW button
        await util.pumpUntilFound(tester, TestKeys.saveNowButton);
        await tester.pump(const Duration(seconds: 3));
        await tester.tap(TestKeys.saveNowButton);
        await util.pumpUntilFound(tester, TestKeys.floFixedAsset);
        await tester.tap(TestKeys.floFlexiAsset);
        expect(tester.hasRunningAnimations, isTrue);
        await Future.delayed(const Duration(seconds: 5));
        expect(TestKeys.floAmountInput, findsNothing);
        expect(TestKeys.floSaveButton, findsNothing);
        await util.pumpUntilFound(tester, TestKeys.floFixedAsset);

        //back to home screen
        await AppState.backButtonDispatcher!.didPopRoute();
        await util.pumpUntilFound(tester, TestKeys.profileAvatar);
        logger.d('Test case:- Flo fixed 12%  save blocked for user - Passed');
        passCount++;
      } catch (e) {
        logger.e('Test case:- Flo fixed 12% save blocked for user - Failed');
        failCount++;
      }

      try {
        //Flo save blocked for users clicking from Flo asset
        await util.pumpUntilFound(tester, TestKeys.portfolioCard);
        await tester.pump(const Duration(seconds: 3));
        await tester.tap(TestKeys.portfolioCard);
        await tester.pump(const Duration(seconds: 3));
        await Future.delayed(const Duration(seconds: 5));
        await tester.tap(TestKeys.floPortfolioSave);
        await util.pumpUntilFound(tester, TestKeys.saveinFloButton);
        await tester.tap(TestKeys.saveinFloButton);
        await util.pumpUntilFound(tester, TestKeys.floFlexiAsset);
        await tester.tap(TestKeys.floFlexiAsset);

        expect(tester.hasRunningAnimations, isTrue);
        await Future.delayed(const Duration(seconds: 5));
        expect(TestKeys.floAmountInput, findsNothing);
        expect(TestKeys.floSaveButton, findsNothing);

        await Future.delayed(const Duration(seconds: 5));
        await util.pumpUntilFound(tester, TestKeys.floFlexiAsset);

        //back to flo save screen
        await AppState.backButtonDispatcher!.didPopRoute();
        await util.pumpUntilFound(tester, TestKeys.saveinFloButton);

        //back to portfolio screen
        await AppState.backButtonDispatcher!.didPopRoute();
        await util.pumpUntilFound(tester, TestKeys.floPortfolioSave);

        //back to home screen
        await AppState.backButtonDispatcher!.didPopRoute();
        await util.pumpUntilFound(tester, TestKeys.profileAvatar);
        logger.d('Test case:- Flo save blocked from portfolio card - Passed');
        passCount++;
      } catch (e) {
        logger.e('Test case:- Flo save blocked from portfolio card - Failed');
        failCount++;
      }

      try {
        //Gold save blocked for users clicking from Flo asset
        await util.pumpUntilFound(tester, TestKeys.portfolioCard);
        await tester.pump(const Duration(seconds: 3));
        await tester.tap(TestKeys.portfolioCard);
        await tester.pump(const Duration(seconds: 3));
        await Future.delayed(const Duration(seconds: 5));
        await tester.tap(TestKeys.goldPortfolioSave);
        await util.pumpUntilFound(tester, TestKeys.saveinGoldButton);
        await tester.tap(TestKeys.saveinGoldButton);

        expect(tester.hasRunningAnimations, isTrue);
        expect(TestKeys.save, findsNothing);
        expect(TestKeys.enterGoldBuyAmount, findsNothing);
        await Future.delayed(const Duration(seconds: 5));
        await util.pumpUntilFound(tester, TestKeys.saveinGoldButton);

        //back to portfolio screen
        await AppState.backButtonDispatcher!.didPopRoute();
        await util.pumpUntilFound(tester, TestKeys.goldPortfolioSave);

        //back to home screen
        await AppState.backButtonDispatcher!.didPopRoute();
        await util.pumpUntilFound(tester, TestKeys.profileAvatar);
        logger.d('Test case:- Gold save blocked from portfolio card - Passed');
        passCount++;
      } catch (e) {
        logger.e('Test case:- Gold save blocked from portfolio card - Failed');
        failCount++;
      }

      try {
        //Gold save blocked for users clicking from SAVE NOW button
        await util.pumpUntilFound(tester, TestKeys.saveNowButton);
        await tester.pump(const Duration(seconds: 3));
        await tester.tap(TestKeys.saveNowButton);
        await util.pumpUntilFound(tester, TestKeys.goldSavePlan);
        await tester.tap(TestKeys.goldSavePlan);
        expect(tester.hasRunningAnimations, isTrue);
        expect(TestKeys.save, findsNothing);
        expect(TestKeys.enterGoldBuyAmount, findsNothing);
        await Future.delayed(const Duration(seconds: 5));
        await util.pumpUntilFound(tester, TestKeys.goldSavePlan);

        //back to home screen
        await AppState.backButtonDispatcher!.didPopRoute();
        await util.pumpUntilFound(tester, TestKeys.profileAvatar);
        logger.d('Test case:- Gold save blocked for user - Passed');
        passCount++;
      } catch (e) {
        logger.e('Test case:- Gold save blocked for user - Failed');
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
