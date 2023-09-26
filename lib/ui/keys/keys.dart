import 'package:flutter/foundation.dart';

/// Shorthand for accessing keys.
typedef K = Keys;

class Keys {
  const Keys._();

  // Mobile next cta.
  static const loginNextCTAKey = ValueKey(
    'LoginCTA',
  );

  // OTP text field.
  static const otpTextFieldKey = ValueKey(
    'otpTextField',
  );

  // User avatar inside app bar.
  static const userAvatarKey = ValueKey(
    'userAvatarKey',
  );

  // User profile tile inside my account section.
  static const userProfileEntryCTAKey = ValueKey(
    'userProfileEntryCTA',
  );

  // Scrollable inside the profile page.
  static const profileScrollableKey = ValueKey(
    'profileScrollableKey',
  );

  // SignOut button at user profile page.
  static const singOutButtonKey = Key(
    'singOutButton',
  );

  // Logout confirmation cta.
  static const confirmationDialogCTAKey = Key(
    'confirmationCTAKey',
  );
}
