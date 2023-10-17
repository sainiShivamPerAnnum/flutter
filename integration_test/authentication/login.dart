import 'package:felloapp/main_dev.dart' as dev_app;
import 'package:felloapp/ui/keys/keys.dart';
import 'package:felloapp/ui/pages/root/root_view.dart';
import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import '../test_constants/test_constants.dart';
import '../utils/utils.dart' as utils;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Login:', () {
    testWidgets(
        'when number is valid then redirects to the otp screen and fills otp',
        (tester) async {
      final oldCallback = FlutterError.onError;
      FlutterError.onError = (details) {/* do nothing on purpose */};
      await dev_app.main();
      await tester.pumpAndSettle();
      await utils.pumpUntilFound(
        tester,
        find.byIcon(Icons.arrow_forward_ios_rounded),
      );
      final locale = S();
      final onboardingRobot = OnboardingRobot(tester);
      await onboardingRobot.completeOnBoarding();

      /// Enter empty string for valid number assertion.
      final singingRobot = SingInRobot(tester);
      await singingRobot.enterText(TestConstants.emptyString);
      await singingRobot.tapOnNext();
      expect(find.text(locale.obEnterMobile), findsOneWidget);

      /// Enter number for verification.
      await singingRobot.enterText(TestConstants.mobileNumber);
      await singingRobot.tapOnNext();
      await utils.pumpUntilFound(tester, K.otpTextFieldKey.mapToFinder);
      await Future.delayed(const Duration(seconds: 2));
      final otpRobot = OTPRobot(tester);
      await otpRobot.enterOtp(TestConstants.otpVerify);
      await singingRobot.tapOnNext();
      await utils.pumpUntilFound(tester, find.byType(Root));

      /// Tap on the user avatar and then visits profile page.
      final homeRobot = HomeViewRobot(tester);
      await tester.pump(const Duration(seconds: 3));
      await Future.delayed(const Duration(seconds: 5)); // completes the reveal.
      await homeRobot.tapOnProfileAvatar();
      await utils.pumpUntilFound(tester, K.userProfileEntryCTAKey.mapToFinder);
      expect(K.userProfileEntryCTAKey.mapToFinder, findsOneWidget);

      /// Tap on profile entry cta and wait until profile page scrollable is
      /// visible.
      final myAccountRobot = MyAccountRobot(tester);
      await myAccountRobot.tapOnProfileEntryCTA();
      await utils.pumpUntilFound(tester, K.profileScrollableKey.mapToFinder);

      /// Scroll until sign-out button is visible and then taps one the button.
      final profileRobot = ProfileRobot(tester);
      await profileRobot.scrollUntilSignOutCTAVisible();
      await utils.pumpUntilFound(tester, K.singOutButtonKey.mapToFinder);
      await profileRobot.tapOnSignOutCTA();
      await utils.pumpUntilFound(
        tester,
        K.confirmationDialogCTAKey.mapToFinder,
      );
      await profileRobot.confirmSignOut();
      await Future.delayed(const Duration(seconds: 5));
      FlutterError.onError = oldCallback;
    });
  });
}

class SingInRobot {
  final WidgetTester tester;

  const SingInRobot(
    this.tester,
  );

  Future<void> enterText(String text) async {
    final numberField = find.byType(TextFormField);
    await tester.showKeyboard(numberField);
    await tester.enterText(numberField, text);
    await tester.pumpAndSettle();
  }

  Future<void> tapOnNext([bool shouldWaitUntilSettle = false]) async {
    await tester.tap(K.loginNextCTAKey.mapToFinder);
    if (shouldWaitUntilSettle) await tester.pumpAndSettle();
  }
}

class OTPRobot {
  final WidgetTester tester;

  const OTPRobot(
    this.tester,
  );

  Future<void> enterOtp(String text,
      [bool shouldWaitUntilSettle = false]) async {
    final otpField = K.otpTextFieldKey.mapToFinder;
    await tester.showKeyboard(otpField);
    await tester.enterText(otpField, text);
    if (shouldWaitUntilSettle) await tester.pumpAndSettle();
  }
}

class OnboardingRobot {
  final WidgetTester tester;

  const OnboardingRobot(
    this.tester,
  );

  Future<void> tapOnSkip() async {
    final finder = find.byIcon(Icons.arrow_forward_ios_rounded);
    await tester.tap(finder);
    await tester.pumpAndSettle();
  }
}

extension OnboardingCompletionExtension on OnboardingRobot {
  Future<void> completeOnBoarding() async {
    for (var i = 0; i < 3; i++) {
      await tapOnSkip();
    }
  }
}

class HomeViewRobot {
  final WidgetTester tester;

  const HomeViewRobot(
    this.tester,
  );

  Future<void> tapOnProfileAvatar() async {
    final profilePicFinder = K.userAvatarKey.mapToFinder;
    await tester.tap(profilePicFinder);
  }
}

class MyAccountRobot {
  final WidgetTester tester;

  const MyAccountRobot(
    this.tester,
  );

  Future<void> tapOnProfileEntryCTA() async {
    final profileEntryCTA = K.userProfileEntryCTAKey.mapToFinder;
    await tester.tap(profileEntryCTA);
    await tester.pumpAndSettle();
  }
}

class ProfileRobot {
  final WidgetTester tester;

  const ProfileRobot(
    this.tester,
  );

  Future<void> scrollUntilSignOutCTAVisible() async {
    await tester.dragUntilVisible(
      K.singOutButtonKey.mapToFinder,
      K.profileScrollableKey.mapToFinder,
      const Offset(0, 100),
    );
    await tester.pumpAndSettle();
  }

  Future<void> tapOnSignOutCTA() async {
    await tester.tap(
      K.singOutButtonKey.mapToFinder,
    );
    await tester.pumpAndSettle();
  }

  Future<void> confirmSignOut() async {
    await tester.tap(
      K.confirmationDialogCTAKey.mapToFinder,
    );
    await tester.pumpAndSettle();
  }
}
