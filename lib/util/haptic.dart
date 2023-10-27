import 'dart:io';

import 'package:flutter/services.dart';
import 'package:vibration/vibration.dart';

class Haptic {
  static void vibrate() {
    if (Platform.isAndroid) {
      HapticFeedback.vibrate();
    } else {
      HapticFeedback.lightImpact();
    }
  }

  static void strongVibrate() {
    if (Platform.isAndroid) {
      HapticFeedback.mediumImpact();
    } else {
      HapticFeedback.lightImpact();
    }
  }

  static void slotVibrate() {
    Vibration.vibrate(
      pattern: [
        10,
        20,
        30,
        20,
        60,
        20,
        90,
        20,
        110,
        20,
        140,
        20,
        180,
        20,
        240,
        15,
        300,
        15,
        360,
        15,
        420,
        15,
        480,
        10,
        550,
        10,
        620,
      ],
    );
  }

  static void shakeVibrate() {
    Vibration.vibrate(
        pattern: [10, 20, 80, 20, 150, 20, 200, 20, 300, 20, 400, 20]);
  }
}
