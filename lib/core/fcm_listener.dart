import 'dart:io';

import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/fcm_handler.dart';
import 'package:felloapp/core/model/BaseUser.dart';
import 'package:felloapp/core/ops/db_ops.dart';
import 'package:felloapp/core/ops/lcl_db_ops.dart';
import 'package:felloapp/main.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/util/fail_types.dart';
import 'package:felloapp/util/fcm_topics.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/logger.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:freshchat_sdk/freshchat_sdk.dart';

class FcmListener extends ChangeNotifier {
  Log log = new Log("FcmListener");
  BaseUtil _baseUtil = locator<BaseUtil>();
  LocalDBModel _lModel = locator<LocalDBModel>();
  DBModel _dbModel = locator<DBModel>();
  FcmHandler _handler = locator<FcmHandler>();
  AppState _appState = locator<AppState>();
  FirebaseMessaging _fcm;
  bool _tambolaDrawNotifications = true; //TODO
  bool isTambolaNotificationLoading = false;
  // /// Create a [AndroidNotificationChannel] for heads up notifications
  // static const AndroidNotificationChannel _androidChannel =
  //     AndroidNotificationChannel(
  //   'high_importance_channel', // id
  //   'High Importance Notifications', // title
  //   'This channel is used for important notifications.', // description
  //   importance: Importance.high,
  // );

  // Initialize the [FlutterLocalNotificationsPlugin] package.
  // final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  //     FlutterLocalNotificationsPlugin();

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
      log.debug("onMessage recieved: " + message.toString());
      if (message != null && message.data != null) {
        _handler.handleMessage(message.data);
      }
    });
    // await flutterLocalNotificationsPlugin
    //     .resolvePlatformSpecificImplementation<
    //         AndroidFlutterLocalNotificationsPlugin>()
    //     ?.createNotificationChannel(_androidChannel);

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      RemoteNotification notification = message.notification;
      AndroidNotification android = message.notification?.android;
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
    if (_baseUtil.myUser != null && _baseUtil.myUser.mobile != null)
      await _saveDeviceToken();

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
          .then((value) => log.debug("Added frequent flyer subscription"));

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
      log.debug('Tambola Notification channel created successfully');
    }).catchError((e) {
      log.error('Tambola notification channel setup failed');
    });
    //
    // const AndroidNotificationChannel _androidTambolaChannel =
    //     AndroidNotificationChannel(
    //   'TAMBOLA_PICK_NOTIF_2', // id
    //   'Tambola Daily Picks', // title
    //   'Tambola notifications', // description
    //   importance: Importance.high,
    // );
    //
    // await flutterLocalNotificationsPlugin
    //     .resolvePlatformSpecificImplementation<
    //         AndroidFlutterLocalNotificationsPlugin>()
    //     ?.createNotificationChannel(_androidTambolaChannel);
  }

  // Future<void> _firebaseMessagingBackgroundHandler(
  //     RemoteMessage message) async {
  //   // If you're going to use other Firebase services in the background, such as Firestore,
  //   // make sure you call `initializeApp` before using other Firebase services.
  //   //await Firebase.initializeApp();
  //   print('Handling a background message ${message.messageId}');
  // }

  _saveDeviceToken() async {
    bool flag = true;
    String fcmToken = await _fcm.getToken();

    if (fcmToken != null &&
        _baseUtil.myUser != null &&
        _baseUtil.myUser.mobile != null &&
        (_baseUtil.myUser.client_token == null ||
            (_baseUtil.myUser.client_token != null &&
                _baseUtil.myUser.client_token != fcmToken))) {
      log.debug("Updating FCM token to local and server db");
      _baseUtil.myUser.client_token = fcmToken;
      Freshchat.setPushRegistrationToken(fcmToken);
      flag = await _dbModel.updateClientToken(_baseUtil.myUser, fcmToken);
      // if (flag)
      //   await _lModel.saveUser(
      //       _baseUtil.myUser); //user cache has client token field available
    }
    return flag;
  }

// TAMBOLA DRAW NOTIFICATION STATUS HANDLE CODE

  // SAVE STATUS TO SHARED PREFS
  saveTambolaDrawNotification(bool val) async {}

  // TOGGLE THE SUBSCRIPTION
  Future toggleTambolaDrawNotificationStatus(bool val) async {
    // isTambolaNotificationLoading = true;
    // notifyListeners();
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
      log.error(e.toString());
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
