import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/model/base_user_model.dart';
import 'package:felloapp/core/service/analytics/analytics_service.dart';
import 'package:felloapp/core/service/fcm/fcm_handler_service.dart';
import 'package:felloapp/core/service/notifier_services/internal_ops_service.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/util/custom_logger.dart';
import 'package:felloapp/util/fail_types.dart';
import 'package:felloapp/util/fcm_topics.dart';
import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/preference_helper.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';

@pragma('vm:entry-point')
Future<void> firebaseBackgroundMessageHandler(RemoteMessage message) async {
  log("Background message received: ${message.data}");
  // Use the static method to handle background messages
  await FcmListener.handleBackgroundMessage(message);
}

class FcmListener {
  final BaseUtil _baseUtil = locator<BaseUtil>();
  final CustomLogger? logger = locator<CustomLogger>();
  final FcmHandler _handler;
  final UserService _userService = locator<UserService>();
  final AnalyticsService _analyticsService = locator<AnalyticsService>();
  final InternalOpsService _internalOpsService = locator<InternalOpsService>();
  S locale = locator<S>();
  FirebaseMessaging? _fcm;
  bool isTambolaNotificationLoading = false;

  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();
  String? _currentChatSessionId;
  bool _isAppInForeground = true;

  final Map<String, List<int>> _sessionNotificationIds = {};
  static FlutterLocalNotificationsPlugin? _backgroundLocalNotifications;

  FcmListener(this._handler);

  static Future<void> handleBackgroundMessage(RemoteMessage message) async {
    try {
      // Initialize local notifications if not already done
      if (_backgroundLocalNotifications == null) {
        _backgroundLocalNotifications = FlutterLocalNotificationsPlugin();
        await _initializeBackgroundNotifications();
      }

      // Handle different message types
      if (message.data['type'] == 'chat_message') {
        await _handleBackgroundChatMessage(message);
      } else {
        await _storeMessageForStartup(message);
      }
    } catch (e) {
      log("Background message handler error: $e");
    }
  }

  int _generateUniqueMessageId(String? sessionId, Map<String, dynamic> data) {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final senderId = data['userId'] ?? data['advisorId'] ?? '';
    final uniqueString = '${sessionId ?? 'unknown'}_${senderId}_$timestamp';
    return uniqueString.hashCode;
  }

  static Future<void> _initializeBackgroundNotifications() async {
    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_fello_notif');
    const iosSettings = DarwinInitializationSettings();
    const settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _backgroundLocalNotifications!.initialize(settings);
  }

  static Future<void> _handleBackgroundChatMessage(
    RemoteMessage message,
  ) async {
    final data = message.data;

    // Check if we should suppress this notification
    if (await _shouldSuppressBackgroundNotification(message)) {
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
      category: AndroidNotificationCategory.message,
      groupKey: 'chat_session_${data['sessionId']}',
      setAsGroupSummary: false,
      fullScreenIntent: true,
      styleInformation: BigTextStyleInformation(
        data['body'] ?? '',
        contentTitle: data['title'] ?? '',
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
      'sessionId': data['sessionId'],
      'advisorId': data['advisorId'],
      'source': 'background',
    };

    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final senderId = data['userId'] ?? data['advisorId'] ?? '';
    final sessionId = data['sessionId'] ?? 'unknown';
    final uniqueString = '${sessionId}_${senderId}_$timestamp';
    final notificationId = uniqueString.hashCode;

    await _backgroundLocalNotifications!.show(
      notificationId,
      data['title'] ?? '',
      data['body'] ?? '',
      details,
      payload: jsonEncode(payloadData),
    );

    // Store notification ID for session management
    await _storeBackgroundNotificationId(data['sessionId'], notificationId);

    log("Background chat notification shown for session: ${data['sessionId']}");
  }

  static Future<bool> _shouldSuppressBackgroundNotification(
    RemoteMessage message,
  ) async {
    try {
      final prefs = await SharedPreferences.getInstance();
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

  static Future<void> _storeBackgroundNotificationId(
    String? sessionId,
    int notificationId,
  ) async {
    if (sessionId == null) return;

    try {
      final prefs = await SharedPreferences.getInstance();
      List<String> sessionNotifications =
          prefs.getStringList('bg_session_notifications_$sessionId') ?? [];

      sessionNotifications.add(notificationId.toString());
      await prefs.setStringList(
        'bg_session_notifications_$sessionId',
        sessionNotifications,
      );
    } catch (e) {
      log("Failed to store background notification ID: $e");
    }
  }

  static Future<void> _storeMessageForStartup(RemoteMessage message) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove("fcmData");
      await prefs.setString('fcmData', jsonEncode(message.data));
    } catch (e) {
      log("Failed to store message for startup: $e");
    }
  }

  Future<FirebaseMessaging?> setupFcm() async {
    _fcm = FirebaseMessaging.instance;
    try {
      _fcm != null
          ? logger!.d("Fcm instance created")
          : logger!.d("Fcm instance not created");

      await _initializeLocalNotifications();
      String? idToken = await _fcm!.getToken();
      await _saveDeviceToken(idToken);

      ///update fcm user token if required
      Stream<String> fcmStream = _fcm!.onTokenRefresh;
      fcmStream.listen((token) async {
        logger!.d("OnTokenRefresh called, updated FCM token: $token");
        await _saveDeviceToken(token);
      });

      unawaited(
        _fcm!.getInitialMessage().then(
          (message) {
            if (message != null) {
              logger!.d("Opened app with notification data: ${message.data}");
              if (message.data['type'] == 'chat_message') {
                final sessionId = message.data['sessionId'];
                final advisorId = message.data['advisorId'];
                final advisorName = message.data['senderName'] ?? '';
                if (sessionId != null && advisorId != null) {
                  final data = message.data as Map<String, dynamic>? ?? {};
                  data.addAll({
                    "deep_uri":
                        '/chat?sessionId=$sessionId&advisorId=$advisorId&advisorName=$advisorName',
                  });
                  _handler.handleMessage(message.data, MsgSource.Background);
                  clearNotificationsForSession(sessionId);
                }
              } else {
                AppState.startupNotifMessage = message.data;
              }
            }
          },
        ),
      );

      final data = PreferenceHelper.getString("fcmData");

      if (AppState.startupNotifMessage == null && data.isNotEmpty) {
        AppState.startupNotifMessage = jsonDecode(data);
        await PreferenceHelper.remove("fcmData");
      }

      FirebaseMessaging.onMessage.listen((message) async {
        if (message.data['type'] == 'chat_message') {
          await _handleForegroundChatMessage(message);
          return;
        } else if (message.data.isNotEmpty) {
          await _handler.handleMessage(message.data, MsgSource.Foreground);
        } else if (message.notification != null) {
          RemoteNotification? notification = message.notification;
          logger!.d(
              "Handle Notification: ${notification?.title} ${notification?.body}, ${message.data['command']}");
          await _handler.handleNotification(
            notification?.title,
            notification?.body,
            message.data['command'],
          );
        }
      });

      FirebaseMessaging.onMessageOpenedApp.listen((message) {
        logger!.i('Opened app from background state with message: $message');
        if (message.data['type'] == 'chat_message') {
          final sessionId = message.data['sessionId'];
          final advisorId = message.data['advisorId'];
          final advisorName = message.data['senderName'] ?? '';
          if (sessionId != null && advisorId != null) {
            final data = message.data as Map<String, dynamic>? ?? {};
            data.addAll({
              "deep_uri":
                  '/chat?sessionId=$sessionId&advisorId=$advisorId&advisorName=$advisorName',
            });
            _handler.handleMessage(data, MsgSource.Background);
            clearNotificationsForSession(sessionId);
          }
        } else {
          _handler.handleMessage(message.data, MsgSource.Background);
        }
      });

      unawaited(
        _fcm!.setForegroundNotificationPresentationOptions(
          alert: true,
          badge: true,
          sound: true,
        ),
      );
      unawaited(_fcm!.requestPermission());

      ///add subscriptions to relevant topics
      await _manageInitSubscriptions();

      ///setup android notification channels
      if (Platform.isAndroid) {
        await _androidNativeSetup();
      }
      WidgetsBinding.instance.addObserver(_AppLifecycleObserver(this));
      await _clearStaleBackgroundNotifications();
    } catch (e) {
      logger!.e(e.toString());
      await _internalOpsService.logFailure(
          _userService.baseUser?.uid ?? '', FailType.FcmListenerSetupFailed, {
        "title": "FcmListener setup Failed",
        "error": e.toString(),
      });
    }

    return _fcm;
  }

  Future<void> _initializeLocalNotifications() async {
    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_fello_notif');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    const settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _localNotifications.initialize(
      settings,
      onDidReceiveNotificationResponse: (response) async {
        await _handleNotificationTap(response);
      },
    );
  }

  Future<void> _handleNotificationTap(NotificationResponse response) async {
    final payloadJson = response.payload;
    if (payloadJson != null) {
      try {
        final payloadData = jsonDecode(payloadJson) as Map<String, dynamic>;
        final type = payloadData['type'] as String?;

        if (type == 'chat_message') {
          final sessionId = payloadData['sessionId'] as String?;
          final advisorId = payloadData['advisorId'] as String?;
          final advisorName = payloadData['senderName'] ?? '';
          if (sessionId != null && advisorId != null) {
            final data = payloadData as Map<String, dynamic>? ?? {};
            payloadData.addAll({
              "deep_uri":
                  '/chat?sessionId=$sessionId&advisorId=$advisorId&advisorName=$advisorName',
            });
            await _handler.handleMessage(data, MsgSource.Background);
            await clearNotificationsForSession(sessionId);
          }
        } else {
          final data = payloadData['data'] as Map<String, dynamic>? ?? {};
          await _handler.handleMessage(data, MsgSource.Background);
        }
      } catch (e) {
        logger?.e('Error parsing notification payload: $e');
      }
    }
  }

  Future<void> _handleForegroundChatMessage(RemoteMessage message) async {
    logger!.d('Received foreground chat message: ${message.data}');

    if (_shouldSuppressForegroundChatNotification(message)) {
      logger!
          .d('Suppressing foreground chat notification - user is in same chat');
      return;
    }

    await _showForegroundChatNotification(message);
  }

  bool _shouldSuppressForegroundChatNotification(RemoteMessage message) {
    final messageData = message.data;
    final sessionId = messageData['sessionId'];
    final senderId = messageData['userId'];
    final currentUserId = _userService.baseUser?.uid;
    if (_currentChatSessionId == sessionId) {
      return true;
    }
    if (senderId == currentUserId) return false;

    return false;
  }

  Future<void> _showForegroundChatNotification(RemoteMessage message) async {
    final data = message.data;
    var androidDetails = AndroidNotificationDetails(
      'chat_messages',
      'Chat Messages',
      channelDescription: 'New chat messages from advisors',
      importance: Importance.high,
      priority: Priority.high,
      showWhen: true,
      icon: '@mipmap/ic_fello_notif',
      color: const Color(0xFF01656B),
      category: AndroidNotificationCategory.message,
      groupKey: 'chat_session_${data['sessionId'] ?? ''}',
      setAsGroupSummary: false,
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
      categoryIdentifier: 'chat_message',
    );

    var details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    final payloadData = {
      'type': 'chat_message',
      'sessionId': data['sessionId'],
      'advisorId': data['advisorId'],
      'source': 'foreground',
    };

    final notificationId = _generateUniqueMessageId(data['sessionId'], data);
    final sessionId = data['sessionId'] as String?;

    await _localNotifications.show(
      notificationId,
      data['title'] ?? '',
      data['body'] ?? '',
      details,
      payload: jsonEncode(payloadData),
    );
    await _storeBackgroundNotificationId(data['sessionId'], notificationId);
    if (sessionId != null) {
      _sessionNotificationIds[sessionId] ??= [];
      _sessionNotificationIds[sessionId]!.add(notificationId);
    }
  }

  // Call this when user enters a chat screen
  Future<void> setCurrentChatSession(String? sessionId) async {
    _currentChatSessionId = sessionId;
    logger!.d('Current chat session: $_currentChatSessionId');
    // Store in SharedPreferences for background handler
    final prefs = await SharedPreferences.getInstance();
    if (sessionId != null) {
      await prefs.setString('current_chat_session_id', sessionId);
      await clearNotificationsForSession(sessionId);
    } else {
      await prefs.remove('current_chat_session_id');
    }
  }

  Future<void> clearNotificationsForSession(String sessionId) async {
    // Clear foreground notifications
    await _localNotifications.cancelAll();
    // final notificationIds = _sessionNotificationIds[sessionId];
    // if (notificationIds != null && notificationIds.isNotEmpty) {
    //   for (final notificationId in notificationIds) {
    //     await _localNotifications.cancel(notificationId);
    //   }
    //   _sessionNotificationIds.remove(sessionId);
    // }

    // // Clear background notifications
    // try {
    //   final backgroundNotifications =
    //       PreferenceHelper.getStringList('bg_session_notifications_$sessionId');
    //   log(
    //     'notifications $backgroundNotifications',
    //   );
    //   if (backgroundNotifications.isNotEmpty) {
    //     log('Clearing ${backgroundNotifications.length} background notifications for session $sessionId');
    //     for (final notificationIdString in backgroundNotifications) {
    //       final notificationId = int.tryParse(notificationIdString);
    //       if (notificationId != null) {
    //         await _localNotifications.cancel(notificationId);
    //         log('Cancelled background notification ID: $notificationId');
    //       }
    //     }
    //     await PreferenceHelper.remove('bg_session_notifications_$sessionId');
    //     log(
    //       'Removed background notification preferences for session $sessionId',
    //     );
    //   } else {
    //     log('No background notifications found for session $sessionId');
    //   }
    // } catch (e) {
    //   logger?.e('Error clearing background notifications: $e');
    // }
  }

  Future<void> _clearStaleBackgroundNotifications() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final keys = prefs.getKeys();
      final bgSessionKeys =
          keys.where((key) => key.startsWith('bg_session_notifications_'));

      for (final key in bgSessionKeys) {
        final notificationIds = prefs.getStringList(key) ?? [];
        for (final notificationIdString in notificationIds) {
          final notificationId = int.tryParse(notificationIdString);
          if (notificationId != null) {
            await _localNotifications.cancel(notificationId);
          }
        }
        await prefs.remove(key);
      }

      logger?.d('Cleared all stale background notifications on startup');
    } catch (e) {
      logger?.e('Error clearing stale background notifications: $e');
    }
  }

  Future<void> setAppForegroundState(bool isInForeground) async {
    _isAppInForeground = isInForeground;
    logger!.d('App foreground state: $_isAppInForeground');

    // Store in SharedPreferences for background handler
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('is_app_in_foreground', isInForeground);

      // Store current user ID for background suppression logic
      final currentUserId = _userService.baseUser?.uid;
      if (currentUserId != null) {
        await prefs.setString('current_user_id', currentUserId);
      }
    } catch (e) {
      logger?.e('Error storing app state: $e');
    }
  }

  Future<void> clearAllChatNotifications() async {
    await _localNotifications.cancelAll();
    _sessionNotificationIds.clear();
    try {
      final prefs = await SharedPreferences.getInstance();
      final keys = prefs.getKeys();
      final bgSessionKeys =
          keys.where((key) => key.startsWith('bg_session_notifications_'));

      for (final key in bgSessionKeys) {
        await prefs.remove(key);
      }
    } catch (e) {
      logger?.e('Error clearing all background notifications: $e');
    }
  }

  Future addSubscription(FcmTopic subId, {String suffix = ''}) async {
    await _fcm!.subscribeToTopic(
        (suffix.isEmpty) ? subId.value() : '${subId.value()}$suffix');
  }

  Future removeSubscription(FcmTopic subId, {String suffix = ''}) async {
    await _fcm!.unsubscribeFromTopic(
        (suffix.isEmpty) ? subId.value() : '${subId.value()}$suffix');
  }

  Future<void> _manageInitSubscriptions() async {
    if (_baseUtil.isOldCustomer()) {
      await addSubscription(FcmTopic.OLDCUSTOMER);
    }

    if (_userService.baseUser != null &&
        _userService.baseUser!.isInvested != null &&
        !_userService.baseUser!.isInvested!) {
      await addSubscription(FcmTopic.NEVERINVESTEDBEFORE);
    }

    if (_userService.baseUser != null &&
        !_userService.baseUser!.isAugmontOnboarded!) {
      await addSubscription(FcmTopic.MISSEDCONNECTION);
    }

    if (_userService.baseUser != null &&
        _userService.baseUser!.isAugmontOnboarded! &&
        _baseUtil.userFundWallet != null &&
        _baseUtil.userFundWallet!.augGoldBalance > 300) {
      await addSubscription(FcmTopic.FREQUENTFLYER)
          .then((value) => logger!.d("Added frequent flyer subscription"));
    }

    if (_baseUtil.ticketCount != null &&
        _baseUtil.ticketCount! > 0 &&
        _userService.baseUser!.userPreferences
                .getPreference(Preferences.TAMBOLANOTIFICATIONS) ==
            1) {
      await addSubscription(FcmTopic.TAMBOLAPLAYER);
    }

    if (BaseUtil.packageInfo != null) {
      String cde = BaseUtil.packageInfo!.version;
      cde = cde.replaceAll('.', '');
      await addSubscription(FcmTopic.VERSION, suffix: cde);
    }

    await addSubscription(FcmTopic.PROMOTION);
  }

  Future<void> _androidNativeSetup() async {
    const MethodChannel channel =
        MethodChannel('fello.in/dev/notifications/channel/tambola');
    Map<String, String> tambolaChannelMap = {
      "id": "TAMBOLA_PICK_NOTIF",
      "name": "Tambola Daily Picks",
      "description": "Tambola notifications",
    };

    await channel
        .invokeMethod('createNotificationChannel', tambolaChannelMap)
        .then((value) {
      logger!.d('Tambola Notification channel created successfully');
    }).catchError((e) {
      logger!.d('Tambola notification channel setup failed');
    });

    // Create enhanced chat notifications channel
    const MethodChannel chatChannel =
        MethodChannel('fello.in/dev/notifications/channel/chat');
    Map<String, String> chatChannelMap = {
      "id": "chat_messages",
      "name": "Chat Messages",
      "description": "New chat messages from advisors",
      "importance": "4", // IMPORTANCE_HIGH
      "priority": "1", // PRIORITY_HIGH
      "sound": "true",
      "vibration": "true",
      "lights": "true",
      "showBadge": "true",
    };

    await chatChannel
        .invokeMethod('createNotificationChannel', chatChannelMap)
        .then((value) {
      logger!.d('Chat Notification channel created successfully');
    }).catchError((e) {
      logger!.d('Chat notification channel setup failed');
    });
  }

  Future<void> _saveDeviceToken(String? fcmToken) async {
    if (_userService.baseUser != null) {
      String savedToken =
          PreferenceHelper.getString(PreferenceHelper.FCM_TOKEN);

      if (savedToken == null) logger!.d("No FCM token in pref");

      if (savedToken != fcmToken) {
        logger!.d(
            "FCM changed or app is opened for first time, so updating pref and server token");
        await PreferenceHelper.setString(PreferenceHelper.FCM_TOKEN, fcmToken!);
        await _userService.updateClientToken(fcmToken);

        try {
          _analyticsService.trackUninstall(fcmToken);
        } catch (e) {
          logger!.e('Track uninstall failed: ', e.toString());
        }
      } else {
        logger!.d("FCM is already updated");
      }

      _userService.baseUser!.client_token = fcmToken;
    }
  }

  // TOGGLE THE SUBSCRIPTION
  Future<bool> toggleTambolaDrawNotificationStatus(bool val) async {
    try {
      if (val) {
        await addSubscription(FcmTopic.TAMBOLAPLAYER);
        log("subscription added");
      } else {
        await removeSubscription(FcmTopic.TAMBOLAPLAYER);
        log("subscription removed");
      }
      return true;
    } catch (e) {
      logger!.e(e.toString());
      if (_userService.baseUser!.uid != null) {
        Map<String, dynamic> errorDetails = {
          'error_msg': 'Changing Tambola Notification Status failed',
        };
        unawaited(
          _internalOpsService.logFailure(
            _userService.baseUser!.uid,
            FailType.TambolaDrawNotificationSettingFailed,
            errorDetails,
          ),
        );
      }
      BaseUtil.showNegativeAlert(
        locale.obSomeThingWentWrong,
        locale.obPleaseTryAgain,
      );
      return false;
    }
  }

  Future<void> refreshTopics() async {
    final String lastAppOpenTimeStamp =
        PreferenceHelper.getString(PreferenceHelper.CACHE_LAST_APP_OPEN);
    if (lastAppOpenTimeStamp.isEmpty) {
      //first time open
      await _updateFcmTopics();
    } else if (DateTime.parse(lastAppOpenTimeStamp).day != DateTime.now().day) {
      //new day
      await _updateFcmTopics();
    }
    //else :same day open. return
  }

  Future<void> _updateFcmTopics() async {
    //Check for last updated segments if any
    final List<String> cachedSegments =
        PreferenceHelper.getStringList(PreferenceHelper.CACHE_SEGMENTS);
    //Get updated segments from baseuser
    final List<String> updatedSegments =
        _userService.baseUser!.segments.cast<String>();
    if (cachedSegments.isEmpty) {
      //first time, add all segments
      for (final segment in updatedSegments) {
        log("Subscribed to $segment");
        await _fcm?.subscribeToTopic(segment);
      }
    } else {
      //update segments
      //Next add new segments if there are any
      final List<String> updatedSegments =
          _userService.baseUser!.segments.cast<String>();
      for (final segment in updatedSegments) {
        if (!cachedSegments.contains(segment)) {
          log("Subscribed to $segment");
          await _fcm!.subscribeToTopic(segment);
        }
      }

      //First remove old segments if they are no more part of
      for (final segment in cachedSegments) {
        if (!updatedSegments.contains(segment)) {
          log("unsubscribed to $segment");
          await _fcm!.unsubscribeFromTopic(segment);
        }
      }
    }
    await _fcm?.subscribeToTopic("ALL");
    unawaited(
      PreferenceHelper.setString(
        PreferenceHelper.CACHE_LAST_APP_OPEN,
        DateTime.now().toIso8601String(),
      ),
    );
    unawaited(
      PreferenceHelper.setStringList(
        PreferenceHelper.CACHE_SEGMENTS,
        updatedSegments,
      ),
    );
  }
}

class _AppLifecycleObserver extends WidgetsBindingObserver {
  final FcmListener _fcmListener;

  _AppLifecycleObserver(this._fcmListener);

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        _fcmListener.setAppForegroundState(true);
        break;
      case AppLifecycleState.paused:
      case AppLifecycleState.inactive:
      case AppLifecycleState.detached:
        _fcmListener.setAppForegroundState(false);
        break;
      case AppLifecycleState.hidden:
        break;
    }
  }
}
