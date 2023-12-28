import 'dart:convert';
import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shared_preferences/shared_preferences.dart';

@pragma('vm:entry-point')
Future<void> myBackgroundMessageHandler(RemoteMessage message) async {
  log("Background message: ${message.data}");
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.reload();
  await prefs.remove("fcmData");
  await prefs.setString('fcmData', json.encode(message.data));
  return Future<void>.value();
}
