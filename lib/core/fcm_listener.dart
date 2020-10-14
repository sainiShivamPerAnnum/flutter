import 'dart:io' show Platform;

import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/ops/db_ops.dart';
import 'package:felloapp/core/ops/lcl_db_ops.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/logger.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';


class FcmListener extends ChangeNotifier{
  Log log = new Log("FcmListener");
  BaseUtil _baseUtil = locator<BaseUtil>();
  LocalDBModel _lModel = locator<LocalDBModel>();
  DBModel _dbModel = locator<DBModel>();
  FcmHandler _handler = locator<FcmHandler>();
  FirebaseMessaging _fcm;
  
  FcmListener() {}
  //TODO INTERNET MESSAGE PlatformException(Error performing get, Failed to get document because the client is offline., null)
  Future<FirebaseMessaging> setupFcm() async {
    _fcm = FirebaseMessaging();
    _fcm.configure(
      onMessage: (Map<String, dynamic> message) async {
        log.debug("onMessage recieved: " + message.toString());
        if(message['data'] != null) {
          await _handler.handleMessage(message['data']);
        }
      },
      onLaunch: (Map<String, dynamic> message) async {
        log.debug("onLaunch recieved: " + message.toString());
        if(message['data'] != null) {
          await _handler.handleMessage(message['data']);
        }
      },
      onResume: (Map<String, dynamic> message) async {
        log.debug("onResume recieved: " + message.toString());
        if(message['data'] != null) {
          await _handler.handleMessage(message['data']);
        }
      },
//      onBackgroundMessage: (Map<String, dynamic> message) async {
//        log.debug("onBackgroundMessage recieved: " + message.toString());
//        if(message['data'] != null) {
//          //await _handler.handleMessage(message['data']);
//        }
//      },
    );
    //TODO to be tested
    if(Platform.isIOS) {
      _fcm.requestNotificationPermissions(
          const IosNotificationSettings(sound: true, badge: true, alert: true));
      _fcm.onIosSettingsRegistered
          .listen((IosNotificationSettings settings) {
        print("Settings registered: $settings");
      });
    }

    if(_baseUtil.myUser != null && _baseUtil.myUser.mobile != null)await _saveDeviceToken();
    return _fcm;
  }

  _saveDeviceToken() async {
    bool flag = true;
    String fcmToken = await _fcm.getToken();

    if (fcmToken != null && _baseUtil.myUser != null && _baseUtil.myUser.mobile != null
        && (_baseUtil.myUser.client_token == null || (_baseUtil.myUser.client_token != null && _baseUtil.myUser.client_token != fcmToken))) {
      log.debug("Updating FCM token to local and server db");
      _baseUtil.myUser.client_token = fcmToken;
      flag = await _dbModel.updateClientToken(_baseUtil.myUser, fcmToken);
      if(flag)await _lModel.saveUser(_baseUtil.myUser);  //user cache has client token field available
    }
    return flag;
  }

  FirebaseMessaging get fcm => _fcm;

  set fcm(FirebaseMessaging value) {
    _fcm = value;
  }

}