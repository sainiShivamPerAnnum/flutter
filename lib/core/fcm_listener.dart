import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/fcm_handler.dart';
import 'package:felloapp/core/ops/db_ops.dart';
import 'package:felloapp/core/ops/lcl_db_ops.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/logger.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class FcmListener extends ChangeNotifier {
  Log log = new Log("FcmListener");
  BaseUtil _baseUtil = locator<BaseUtil>();
  LocalDBModel _lModel = locator<LocalDBModel>();
  DBModel _dbModel = locator<DBModel>();
  FcmHandler _handler = locator<FcmHandler>();
  FirebaseMessaging _fcm;

  FcmListener() {}

  /// Create a [AndroidNotificationChannel] for heads up notifications
  static const AndroidNotificationChannel _androidChannel =
      AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    'This channel is used for important notifications.', // description
    importance: Importance.high,
  );

  /// Initialize the [FlutterLocalNotificationsPlugin] package.
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<FirebaseMessaging> setupFcm() async {
    _fcm = FirebaseMessaging.instance;

    _fcm.getInitialMessage().then((RemoteMessage message) {
      log.debug("onMessage recieved: " + message.toString());
      if (message != null && message.data != null) {
        _handler.handleMessage(message.data);
      }
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification notification = message.notification;
      AndroidNotification android = message.notification?.android;
      if (message.data != null && message.data.isNotEmpty) {
        _handler.handleMessage(message.data);
      }else if(notification != null) {
        _handler.handleNotification(notification.title, notification.body);
      }
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

    //_fcm.subscribeToTopic('dailypickbroadcast');
    if(_baseUtil.isOldCustomer()) {
      await _fcm.subscribeToTopic('oldcustomer');
    }

    if (_baseUtil.myUser != null && _baseUtil.myUser.mobile != null)
      await _saveDeviceToken();
    return _fcm;
  }

  Future<void> _firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    // If you're going to use other Firebase services in the background, such as Firestore,
    // make sure you call `initializeApp` before using other Firebase services.
    //await Firebase.initializeApp();
    print('Handling a background message ${message.messageId}');
  }

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
      flag = await _dbModel.updateClientToken(_baseUtil.myUser, fcmToken);
      // if (flag)
      //   await _lModel.saveUser(
      //       _baseUtil.myUser); //user cache has client token field available
    }
    return flag;
  }

  FirebaseMessaging get fcm => _fcm;

  set fcm(FirebaseMessaging value) {
    _fcm = value;
  }
}

class TestNotifications extends StatefulWidget {
  @override
  _TestNotificationsState createState() => _TestNotificationsState();
}

class _TestNotificationsState extends State<TestNotifications> {
  @override
  void initState() {
    super.initState();
    final fbm = FirebaseMessaging.instance;

    // IOS Configurations
    fbm.setForegroundNotificationPresentationOptions(
        alert: true, badge: true, sound: true);
    fbm.requestPermission();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('IOS Listener');
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');

      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification}');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
