import 'dart:io';

import 'package:flutter/services.dart';

class Haptic {
  static void vibrate() {
    if (Platform.isAndroid)
      HapticFeedback.vibrate();
    else
      HapticFeedback.lightImpact();
  }

  static void strongVibrate() {
    if (Platform.isAndroid)
      HapticFeedback.mediumImpact();
    else
      HapticFeedback.lightImpact();
  }
}
