import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared_preferences_android/shared_preferences_android.dart';
import 'package:shared_preferences_ios/shared_preferences_ios.dart';

class BackgroundFcmHandler {
  static Future<dynamic> myBackgroundMessageHandler(
      RemoteMessage message) async {
    if (Platform.isAndroid) SharedPreferencesAndroid.registerWith();
    if (Platform.isIOS) SharedPreferencesIOS.registerWith();
    log("Background message: ${message.data}");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.reload();
    prefs.setString('fcmData', json.encode(message.data));
    return Future<void>.value();
  }
}
