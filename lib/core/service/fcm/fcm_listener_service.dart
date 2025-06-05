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

  FcmListener(this._handler);

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
                _handleChatNotificationTap(message.data);
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
        RemoteNotification? notification = message.notification;
        if (message.data['type'] == 'chat_message') {
          await _handleChatMessage(message);
          return;
        }
        if (message.data.isNotEmpty) {
          await _handler.handleMessage(message.data, MsgSource.Foreground);
        } else if (notification != null) {
          logger!.d(
              "Handle Notification: ${notification.title} ${notification.body}, ${message.data['command']}");
          await _handler.handleNotification(
              notification.title, notification.body, message.data['command']);
        }
      });

      FirebaseMessaging.onMessageOpenedApp.listen((message) {
        logger!.i('Opened app from background state with message: $message');
        if (message.data['type'] == 'chat_message') {
          _handleChatNotificationTap(message.data);
        } else {
          _handler.handleMessage(message.data, MsgSource.Background);
        }
      });

      unawaited(_fcm!.setForegroundNotificationPresentationOptions(
          alert: true, badge: true, sound: true));
      unawaited(_fcm!.requestPermission());

      ///add subscriptions to relevant topics
      await _manageInitSubscriptions();

      ///setup android notification channels
      if (Platform.isAndroid) {
        await _androidNativeSetup();
      }
      WidgetsBinding.instance.addObserver(_AppLifecycleObserver(this));
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
        AndroidInitializationSettings('@mipmap/ic_launcher');
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
      onDidReceiveNotificationResponse: (response) {
        final sessionId = response.payload;
        if (sessionId != null) {
          _navigateToChat(sessionId, '');
        }
      },
    );
  }

  Future<void> _handleChatMessage(RemoteMessage message) async {
    logger!.d('Received chat message: ${message.data}');

    // Check if we should suppress the notification
    if (_shouldSuppressChatNotification(message)) {
      logger!.d('Suppressing chat notification - user is in same chat');
      return;
    }

    // Show local notification for chat
    await _showChatNotification(message);
  }

  bool _shouldSuppressChatNotification(RemoteMessage message) {
    final messageData = message.data;
    final sessionId = messageData['sessionId'];
    final senderId = messageData['senderId'];
    final currentUserId = _userService.baseUser?.uid;

    // Don't suppress if:
    // 1. Message is from current user (they sent it from another device)
    if (senderId == currentUserId) return false;

    // Suppress if:
    // 1. App is in foreground AND user is in the same chat session
    if (_isAppInForeground && _currentChatSessionId == sessionId) return true;

    return false;
  }

  Future<void> _showChatNotification(RemoteMessage message) async {
    final notification = message.notification;
    final data = message.data;

    if (notification == null) return;

    const androidDetails = AndroidNotificationDetails(
      'chat_messages',
      'Chat Messages',
      channelDescription: 'New chat messages from advisors',
      importance: Importance.high,
      priority: Priority.high,
      showWhen: true,
      icon: '@mipmap/ic_launcher',
      color: Color(0xFF01656B),
      category: AndroidNotificationCategory.message,
      groupKey: 'chat_messages',
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
      categoryIdentifier: 'chat_message',
    );

    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _localNotifications.show(
      data['messageId'].hashCode, // Use message ID as notification ID
      notification.title,
      notification.body,
      details,
      payload: data['sessionId'], // Pass session ID as payload
    );
  }

  void _handleChatNotificationTap(Map<String, dynamic> data) {
    final sessionId = data['sessionId'];
    final advisorId = data['advisorId'];
    if (sessionId != null && advisorId != null) {
      _navigateToChat(sessionId, advisorId);
    }
  }

  void _navigateToChat(String sessionId, String advisorId) {
    AppState.delegate?.parseRoute(
      Uri.parse('/chat?sessionId=$sessionId&advisorId=$advisorId'),
    );
  }

  // Call this when user enters a chat screen
  void setCurrentChatSession(String? sessionId) {
    _currentChatSessionId = sessionId;
    logger!.d('Current chat session: $_currentChatSessionId');
  }

  // Call this when app comes to foreground/background
  void setAppForegroundState(bool isInForeground) {
    _isAppInForeground = isInForeground;
    logger!.d('App foreground state: $_isAppInForeground');
  }

  // Call this to clear chat notifications
  Future<void> clearChatNotifications() async {
    // Cancel all chat notifications (you might want to be more specific)
    await _localNotifications.cancelAll();
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

    // Create chat notifications channel
    const MethodChannel chatChannel =
        MethodChannel('fello.in/dev/notifications/channel/chat');
    Map<String, String> chatChannelMap = {
      "id": "chat_messages",
      "name": "Chat Messages",
      "description": "New chat messages from advisors",
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
      //_baseUtil.toggleTambolaNotificationStatus(val);
      return true;
    } catch (e) {
      logger!.e(e.toString());
      if (_userService.baseUser!.uid != null) {
        Map<String, dynamic> errorDetails = {
          'error_msg': 'Changing Tambola Notification Status failed'
        };
        unawaited(_internalOpsService.logFailure(_userService.baseUser!.uid,
            FailType.TambolaDrawNotificationSettingFailed, errorDetails));
      }
      BaseUtil.showNegativeAlert(
          locale.obSomeThingWentWrong, locale.obPleaseTryAgain);
      return false;
    }
  }

  Future<void> refreshTopics() async {
    /**
     * save the day as iso8601String in cache and whenever app opens,
     * check if user has opened on the same day or different day
     * if(same day) and exit the method
     * if(different day of empty) update segment and update cache too
     */
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
