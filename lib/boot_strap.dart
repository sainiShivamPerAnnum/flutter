// ignore_for_file: empty_catches

import 'dart:async';

import 'package:felloapp/core/service/fcm/background_fcm_handler.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/preference_helper.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

typedef BootstrapCallBack = Widget Function();

Future<void> bootStrap(BootstrapCallBack bootStrapCallBack) async {
  runZoned<void>(() async {
    WidgetsFlutterBinding.ensureInitialized();

    try {
      await SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp],
      );
    } catch (e) {}

    await setupLocator();

    try {
      await PreferenceHelper.initiate();
      await Firebase.initializeApp();
    } catch (e) {}

    try {
      FirebaseMessaging.onBackgroundMessage(myBackgroundMessageHandler);
    } catch (e) {}

    // For runApp and bootStrapCallBack is called inside the same zone.
    final Widget app = bootStrapCallBack();

    ///TODO(@DK070202): Remove it before release.
    await PreferenceHelper.setBool(
      PreferenceHelper.isUserOnboardingComplete,
      false,
    );

    // Run app.
    return runApp(app);
  }, zoneSpecification: ZoneSpecification(
    print: (self, parent, zone, line) {
      // This assert block will be removed in release build due to tree-shaking.
      assert(() {
        zone.parent?.print(line);
        return true;
      }());
    },
  ));
}
