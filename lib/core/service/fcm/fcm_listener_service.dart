import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/model/base_user_model.dart';
import 'package:felloapp/core/ops/db_ops.dart';
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
import 'package:flutter/services.dart';

class FcmListener {
  final BaseUtil _baseUtil = locator<BaseUtil>();
  final DBModel _dbModel = locator<DBModel>();
  final CustomLogger? logger = locator<CustomLogger>();
  final FcmHandler _handler;
  final UserService _userService = locator<UserService>();
  final AnalyticsService _analyticsService = locator<AnalyticsService>();
  final InternalOpsService _internalOpsService = locator<InternalOpsService>();
  S locale = locator<S>();
  FirebaseMessaging? _fcm;
  bool isTambolaNotificationLoading = false;

  static Future<dynamic> backgroundMessageHandler(RemoteMessage message) async {
    return Future<void>.value();
  }

  FcmListener(this._handler);

  Future<FirebaseMessaging?> setupFcm() async {
    _fcm = FirebaseMessaging.instance;
    try {
      _fcm != null
          ? logger!.d("Fcm instance created")
          : logger!.d("Fcm instance not created");

      String? idToken = await _fcm!.getToken();
      _saveDeviceToken(idToken);

      ///update fcm user token if required
      Stream<String> fcmStream = _fcm!.onTokenRefresh;
      fcmStream.listen((token) async {
        logger!.d("OnTokenRefresh called, updated FCM token: $token");
        _saveDeviceToken(token);
      });

      unawaited(_fcm!.getInitialMessage().then((RemoteMessage? message) {
        if (message != null) {
          logger!.d("terminated onMessage received: ${message.data}");
          // _handler.handleMessage(message.data, MsgSource.Terminated);
          AppState.startupNotifMessage = message.data;
        }
      }));

      final data = PreferenceHelper.getString("fcmData");

      if (AppState.startupNotifMessage == null && data.isNotEmpty) {
        AppState.startupNotifMessage = jsonDecode(data);
        PreferenceHelper.remove("fcmData");
      }

      FirebaseMessaging.onMessage.listen((message) async {
        RemoteNotification? notification = message.notification;
        if (message.data.isNotEmpty) {
          _handler.handleMessage(message.data, MsgSource.Foreground);
        } else if (notification != null) {
          logger!.d(
              "Handle Notification: ${notification.title} ${notification.body}, ${message.data['command']}");
          _handler.handleNotification(
              notification.title, notification.body, message.data['command']);
        }
      });

      FirebaseMessaging.onMessageOpenedApp.listen((message) {
        logger!.i('A new onMessageOpenedApp event was published!');

        _handler.handleMessage(message.data, MsgSource.Background);
      });

      unawaited(_fcm!.setForegroundNotificationPresentationOptions(
          alert: true, badge: true, sound: true));
      unawaited(_fcm!.requestPermission());

      ///add subscriptions to relevant topics
      await _manageInitSubscriptions();

      ///setup android notification channels
      if (Platform.isAndroid) {
        _androidNativeSetup();
        // ApxorFlutter.setDeeplinkListener((url) {
        //   // interpret the URL and handle redirection within the application
        //   logger!.d("rerouting to Apxor" + url!);
        //   AppState.delegate!.parseRoute(Uri.parse(url));
        // });
      }
    } catch (e) {
      logger!.e(e.toString());
      _internalOpsService.logFailure(
          _userService.baseUser?.uid ?? '', FailType.FcmListenerSetupFailed, {
        "title": "FcmListener setup Failed",
        "error": e.toString(),
      });
    }

    return _fcm;
  }

  Future addSubscription(FcmTopic subId, {String suffix = ''}) async {
    await _fcm!.subscribeToTopic(
        (suffix.isEmpty) ? subId.value() : '${subId.value()}$suffix');
  }

  Future removeSubscription(FcmTopic subId, {String suffix = ''}) async {
    await _fcm!.unsubscribeFromTopic(
        (suffix.isEmpty) ? subId.value() : '${subId.value()}$suffix');
  }

  _manageInitSubscriptions() async {
    if (_baseUtil == null) return;
    if (_baseUtil.isOldCustomer()) {
      addSubscription(FcmTopic.OLDCUSTOMER);
    }

    if (_userService.baseUser != null &&
        _userService.baseUser!.isInvested != null &&
        !_userService.baseUser!.isInvested!) {
      addSubscription(FcmTopic.NEVERINVESTEDBEFORE);
    }

    if (_userService.baseUser != null &&
        !_userService.baseUser!.isAugmontOnboarded!) {
      addSubscription(FcmTopic.MISSEDCONNECTION);
    }

    if (_userService.baseUser != null &&
        _userService.baseUser!.isAugmontOnboarded! &&
        _baseUtil.userFundWallet != null &&
        _baseUtil.userFundWallet!.augGoldBalance > 300) {
      addSubscription(FcmTopic.FREQUENTFLYER)
          .then((value) => logger!.d("Added frequent flyer subscription"));
    }

    if (_baseUtil.ticketCount != null &&
        _baseUtil.ticketCount! > 0 &&
        _userService.baseUser!.userPreferences
                .getPreference(Preferences.TAMBOLANOTIFICATIONS) ==
            1) {
      addSubscription(FcmTopic.TAMBOLAPLAYER);
    }

    if (BaseUtil.packageInfo != null) {
      String cde = BaseUtil.packageInfo!.version ?? 'NA';
      cde = cde.replaceAll('.', '');
      addSubscription(FcmTopic.VERSION, suffix: cde);
    }

    addSubscription(FcmTopic.PROMOTION);
  }

  _androidNativeSetup() async {
    const MethodChannel _channel =
        MethodChannel('fello.in/dev/notifications/channel/tambola');
    Map<String, String> tambolaChannelMap = {
      "id": "TAMBOLA_PICK_NOTIF",
      "name": "Tambola Daily Picks",
      "description": "Tambola notifications",
    };

    _channel
        .invokeMethod('createNotificationChannel', tambolaChannelMap)
        .then((value) {
      logger!.d('Tambola Notification channel created successfully');
    }).catchError((e) {
      logger!.d('Tambola notification channel setup failed');
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
        PreferenceHelper.setString(PreferenceHelper.FCM_TOKEN, fcmToken!);
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
