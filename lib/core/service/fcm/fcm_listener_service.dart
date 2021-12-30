import 'dart:io';

import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/enums/cache_type_enum.dart';
import 'package:felloapp/core/model/base_user_model.dart';
import 'package:felloapp/core/ops/db_ops.dart';
import 'package:felloapp/core/service/cache_manager.dart';
import 'package:felloapp/core/service/fcm/fcm_handler_service.dart';
import 'package:felloapp/core/service/user_service.dart';
import 'package:felloapp/util/fail_types.dart';
import 'package:felloapp/util/fcm_topics.dart';
import 'package:felloapp/util/locator.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/services.dart';
import 'package:freshchat_sdk/freshchat_sdk.dart';
import 'package:felloapp/util/custom_logger.dart';

class FcmListener {
  final BaseUtil _baseUtil = locator<BaseUtil>();
  final DBModel _dbModel = locator<DBModel>();
  final CustomLogger _logger = locator<CustomLogger>();
  final FcmHandler _handler = locator<FcmHandler>();
  final UserService _userService = locator<UserService>();

  FirebaseMessaging _fcm;
  bool isTambolaNotificationLoading = false;

  static Future<dynamic> backgroundMessageHandler(RemoteMessage message) async {
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
    try {
      _fcm != null
          ? _logger.d("Fcm instance created")
          : _logger.d("Fcm instance not created");

      //SaveFCM
      String idToken = await CacheManager.readCache(key: 'token');

      idToken == null
          ? _logger.d("No FCM token in pref")
          : _logger.d("FCM token from pref: $idToken");

      if (idToken == null) {
        idToken = await _fcm.getToken();
        await CacheManager.writeCache(
            key: 'token', value: idToken, type: CacheType.string);
        _logger.d("fcm token added to pref: $idToken");
      }

      if (_userService.baseUser != null) {
        if (_userService.baseUser.client_token != idToken) {
          _saveDeviceToken(idToken);
          _logger.d("User fcm token updated in firestore");
        } else {
          _logger.d("Current device fcm and firestore fcm is same");
        }
      } else {
        _logger.d("BaseUser null in user service.");
      }

      ///update fcm user token if required
      Stream<String> fcmStream = _fcm.onTokenRefresh;
      fcmStream.listen((token) async {
        _logger.d("OnTokenRefresh called, updated FCM token: $token");
        await CacheManager.writeCache(
            key: 'token', value: token, type: CacheType.string);
        _saveDeviceToken(idToken);
        _logger.d("FCM token added to prefs.");
      });

      _fcm.getInitialMessage().then((RemoteMessage message) {
        if (message != null && message.data != null) {
          _logger.d("onMessage recieved: " + message.toString());
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
    } catch (e) {
      _logger.e(e.toString());
      if (_userService.isUserOnborded != null)
        _dbModel.logFailure(
            _userService.baseUser.uid, FailType.FcmListenerSetupFailed, {
          "title": "FcmListener setup Failed",
          "error": e.toString(),
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
          .then((value) => _logger.d("Added frequent flyer subscription"));

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
      _logger.d('Tambola Notification channel created successfully');
    }).catchError((e) {
      _logger.d('Tambola notification channel setup failed');
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
      _logger.d("Updating FCM token to local and server db");
      _baseUtil.myUser.client_token = fcmToken;
      Freshchat.setPushRegistrationToken(fcmToken);
      flag = await _dbModel.updateClientToken(_baseUtil.myUser, fcmToken);
    }
    return flag;
  }

// TAMBOLA DRAW NOTIFICATION STATUS HANDLE CODE

  // TOGGLE THE SUBSCRIPTION
  Future<bool> toggleTambolaDrawNotificationStatus(bool val) async {
    try {
      if (val) {
        await addSubscription(FcmTopic.TAMBOLAPLAYER);
        print("subscription added");
      } else {
        await removeSubscription(FcmTopic.TAMBOLAPLAYER);
        print("subscription removed");
      }
      //_baseUtil.toggleTambolaNotificationStatus(val);
      return true;
    } catch (e) {
      _logger.e(e.toString());
      if (_baseUtil.myUser.uid != null) {
        Map<String, dynamic> errorDetails = {
          'error_msg': 'Changing Tambola Notification Status failed'
        };
        _dbModel.logFailure(_baseUtil.myUser.uid,
            FailType.TambolaDrawNotificationSettingFailed, errorDetails);
      }
      BaseUtil.showNegativeAlert("Error", "Please try again");
      return false;
    }
  }
}
