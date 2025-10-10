import 'dart:convert';
import 'dart:developer';
import 'dart:ui';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';

@pragma('vm:entry-point')
Future<void> myBackgroundMessageHandler(RemoteMessage message) async {
  log("Background message: ${message.data}");
  final prefs = await SharedPreferences.getInstance();

  Future<bool> shouldSuppressBackgroundNotification(
    RemoteMessage message,
  ) async {
    try {
      final currentSessionId = prefs.getString('current_chat_session_id');
      final isAppInForeground = prefs.getBool('is_app_in_foreground') ?? false;
      final messageSessionId = message.data['sessionId'];
      final senderId = message.data['userId'];
      final currentUserId = prefs.getString('current_user_id');

      if (isAppInForeground && currentSessionId == messageSessionId) {
        return true;
      }
      if (senderId == currentUserId) return false;
      return false;
    } catch (e) {
      log("Error checking suppression: $e");
      return false;
    }
  }

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_fello_notif');
  const iosSettings = DarwinInitializationSettings();
  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: iosSettings,
  );
  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
  );

  // Handle chat messages
  if (message.data['type'] == 'chat_message') {
    if (await shouldSuppressBackgroundNotification(message)) {
      log('Suppressing background chat notification');
      return;
    }

    var androidDetails = AndroidNotificationDetails(
      'chat_messages',
      'Chat Messages',
      channelDescription: 'New chat messages from advisors',
      importance: Importance.high,
      priority: Priority.high,
      showWhen: true,
      color: const Color(0xFF01656B),
      icon: '@mipmap/ic_fello_notif',
      category: AndroidNotificationCategory.message,
      groupKey: 'chat_session_${message.data['sessionId']}',
      setAsGroupSummary: false,
      fullScreenIntent: true,
      styleInformation: BigTextStyleInformation(
        message.data['body'] ?? '',
        contentTitle: message.data['title'] ?? '',
        summaryText: 'New message',
      ),
      actions: [
        const AndroidNotificationAction(
          'reply',
          'Reply',
          showsUserInterface: true,
        ),
      ],
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
      categoryIdentifier: 'chat_message',
      threadIdentifier: 'chat_thread',
      interruptionLevel: InterruptionLevel.timeSensitive,
    );
    var details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    final payloadData = {
      'type': 'chat_message',
      'sessionId': message.data['sessionId'],
      'advisorId': message.data['advisorId'],
      'source': 'background',
      "deep_uri":
          '/chat?sessionId=${message.data['sessionId']}&advisorId=${message.data['advisorId']}&advisorName=${message.data['senderName']}',
    };

    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final senderId = message.data['userId'] ?? message.data['advisorId'] ?? '';
    final sessionId = message.data['sessionId'] ?? 'unknown';
    final uniqueString = '${sessionId}_${senderId}_$timestamp';
    final notificationId = uniqueString.hashCode;

    await flutterLocalNotificationsPlugin.show(
      notificationId,
      message.data['title'] ?? '',
      message.data['body'] ?? '',
      details,
      payload: jsonEncode(payloadData),
    );
    final data = message.data as Map<String, dynamic>? ?? {};
    data.addAll({
      "deep_uri":
          '/chat?sessionId=$sessionId&advisorId=${message.data['advisorId']}&advisorName=${message.data['senderName']}',
    });
    // await prefs.reload();
    // await prefs.remove("fcmData");
    // await prefs.setString('fcmData', json.encode(data));
    return Future<void>.value();
  } else {
    await prefs.reload();
    await prefs.remove("fcmData");
    await prefs.setString('fcmData', json.encode(message.data));
    return Future<void>.value();
  }
}
