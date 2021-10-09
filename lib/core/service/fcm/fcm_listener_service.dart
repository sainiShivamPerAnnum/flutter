import 'dart:io';
import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/model/base_user_model.dart';
import 'package:felloapp/core/ops/db_ops.dart';
import 'package:felloapp/core/service/fcm/fcm_handler_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/util/fail_types.dart';
import 'package:felloapp/util/fcm_topics.dart';
import 'package:felloapp/util/locator.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:freshchat_sdk/freshchat_sdk.dart';
import 'package:logger/logger.dart';

class FcmListener extends ChangeNotifier {
  final BaseUtil _baseUtil = locator<BaseUtil>();
  final DBModel _dbModel = locator<DBModel>();
  final Logger logger = locator<Logger>();
  final FcmHandler _handler = locator<FcmHandler>();

  FirebaseMessaging _fcm;
  bool isTambolaNotificationLoading = false;

  static Future<dynamic> backgroundMessageHandler(RemoteMessage message) async {
    print('background notif');

    Freshchat.isFreshchatNotification(message.data).then((flag) {
      if (flag) {
        _handleFreshchatNotif(message.data);
      } else {
        //TODO Background message that is not Freshchat
      }
    });
    return Future<void>.value();
  }

  static _handleFreshchatNotif(Map<String, dynamic> freshChatData) {
    print('background freshchat notif $freshChatData');
    Freshchat.setNotificationConfig(
        largeIcon: "ic_chat_support", smallIcon: "ic_fello_notif");
    Freshchat.handlePushNotification(freshChatData);
  }

  Future<FirebaseMessaging> setupFcm() async {
    _fcm = FirebaseMessaging.instance;
    _fcm.getInitialMessage().then((RemoteMessage message) {
      logger.d("onMessage recieved: " + message.toString());
      if (message != null && message.data != null) {
        _handler.handleMessage(message.data);
      }
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      RemoteNotification notification = message.notification;
      Freshchat.isFreshchatNotification(message.data).then((flag) {
        if (flag) {
          _handleFreshchatNotif(message.data);
        } else if (message.data != null && message.data.isNotEmpty) {
          _handler.handleMessage(message.data);
        } else if (notification != null) {
          _handler.handleNotification(notification.title, notification.body);
        }
      });
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('A new onMessageOpenedApp event was published!');
      if (message.data != null) {
        _handler.handleMessage(message.data);
      }
    });

    _fcm.setForegroundNotificationPresentationOptions(
        alert: true, badge: true, sound: true);
    _fcm.requestPermission();

    ///add subscriptions to relevant topics
    await _manageInitSubscriptions();

    ///setup android notification channels
    if (Platform.isAndroid) {
      _androidNativeSetup();
    }

    ///update fcm user token if required
    if (_baseUtil.myUser != null && _baseUtil.myUser.mobile != null) {
      Stream<String> fcmStream = _fcm.onTokenRefresh;
      fcmStream.listen((token) async {
        logger.d("Updating fcm token");
        await _saveDeviceToken(token);
      });
    }

    return _fcm;
  }

  Future addSubscription(FcmTopic subId, {String suffix = ''}) async {
    await _fcm.subscribeToTopic(
        (suffix.isEmpty) ? subId.value() : '${subId.value()}$suffix');
  }

  Future removeSubscription(FcmTopic subId, {String suffix = ''}) async {
    await _fcm.unsubscribeFromTopic(
        (suffix.isEmpty) ? subId.value() : '${subId.value()}$suffix');
  }

  _manageInitSubscriptions() async {
    if (_baseUtil == null) return;
    if (_baseUtil.isOldCustomer()) {
      addSubscription(FcmTopic.OLDCUSTOMER);
    }

    if (_baseUtil.myUser != null &&
        _baseUtil.myUser.isInvested != null &&
        !_baseUtil.myUser.isInvested) {
      addSubscription(FcmTopic.NEVERINVESTEDBEFORE);
    }

    if (_baseUtil.myUser != null && !_baseUtil.myUser.isAugmontOnboarded)
      addSubscription(FcmTopic.MISSEDCONNECTION);

    if (_baseUtil.myUser != null &&
        _baseUtil.myUser.isAugmontOnboarded &&
        _baseUtil.userFundWallet != null &&
        _baseUtil.userFundWallet.augGoldBalance != null &&
        _baseUtil.userFundWallet.augGoldBalance > 300)
      addSubscription(FcmTopic.FREQUENTFLYER)
          .then((value) => logger.d("Added frequent flyer subscription"));

    if (_baseUtil.userTicketWallet != null &&
        _baseUtil.userTicketWallet.getActiveTickets() > 0 &&
        _baseUtil.myUser.userPreferences
                .getPreference(Preferences.TAMBOLANOTIFICATIONS) ==
            1) {
      // if (_tambolaDrawNotifications) {
      addSubscription(FcmTopic.TAMBOLAPLAYER);
    }

    if (BaseUtil.packageInfo != null) {
      String cde = BaseUtil.packageInfo.version ?? 'NA';
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
      logger.d('Tambola Notification channel created successfully');
    }).catchError((e) {
      logger.d('Tambola notification channel setup failed');
    });
  }

  _saveDeviceToken(String fcmToken) async {
    bool flag = true;
    if (fcmToken != null &&
        _baseUtil.myUser != null &&
        _baseUtil.myUser.mobile != null &&
        (_baseUtil.myUser.client_token == null ||
            (_baseUtil.myUser.client_token != null &&
                _baseUtil.myUser.client_token != fcmToken))) {
      logger.d("Updating FCM token to local and server db");
      _baseUtil.myUser.client_token = fcmToken;
      Freshchat.setPushRegistrationToken(fcmToken);
      flag = await _dbModel.updateClientToken(_baseUtil.myUser, fcmToken);
    }
    return flag;
  }

// TAMBOLA DRAW NOTIFICATION STATUS HANDLE CODE

  // TOGGLE THE SUBSCRIPTION
  Future toggleTambolaDrawNotificationStatus(bool val) async {
    print("Draw notification val : $val");
    try {
      if (val) {
        await addSubscription(FcmTopic.TAMBOLAPLAYER);
        print("subscription added");
      } else {
        await removeSubscription(FcmTopic.TAMBOLAPLAYER);
        print("subscription removed");
      }
      _baseUtil.toggleTambolaNotificationStatus(val);
    } catch (e) {
      logger.e(e.toString());
      if (_baseUtil.myUser.uid != null) {
        Map<String, dynamic> errorDetails = {
          'error_msg': 'Changing Tambola Notification Status failed'
        };
        _dbModel.logFailure(_baseUtil.myUser.uid,
            FailType.TambolaDrawNotificationSettingFailed, errorDetails);
      }
      _baseUtil.showNegativeAlert("Error", "Please try again",
          AppState.delegate.navigatorKey.currentContext);
    }
  }
}
