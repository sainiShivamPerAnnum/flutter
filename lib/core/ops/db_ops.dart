import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:felloapp/core/base_remote_config.dart';
import 'package:felloapp/core/model/faq_model.dart';
import 'package:felloapp/core/model/golden_ticket_model.dart';
import 'package:felloapp/core/model/timestamp_model.dart';
import 'package:felloapp/core/service/api.dart';
import 'package:felloapp/util/api_response.dart';
import 'package:felloapp/util/credentials_stage.dart';
import 'package:felloapp/util/custom_logger.dart';
import 'package:felloapp/util/flavor_config.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/logger.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:synchronized/synchronized.dart';

class DBModel extends ChangeNotifier {
  Api _api = locator<Api>();
  // Lock _lock = new Lock();
  final Log log = new Log("DBModel");
  final FirebaseCrashlytics firebaseCrashlytics = FirebaseCrashlytics.instance;
  final logger = locator<CustomLogger>();

  ///////////////////////////CREDENTIALS//////////////////////////////

  Future<String> showAugmontBuyNotice() async {
    try {
      String _awsKeyIndex = BaseRemoteConfig.remoteConfig
          .getString(BaseRemoteConfig.AWS_AUGMONT_KEY_INDEX);
      if (_awsKeyIndex == null || _awsKeyIndex.isEmpty) _awsKeyIndex = '1';
      int keyIndex = 1;
      try {
        keyIndex = int.parse(_awsKeyIndex);
      } catch (e) {
        log.error('Aws Index key parsing failed: ' + e.toString());
        keyIndex = 1;
      }
      logger.i("CALLING: getCredentialsByTypeAndStage");
      QuerySnapshot querySnapshot = await _api.getCredentialsByTypeAndStage(
          'aws-augmont',
          FlavorConfig.instance.values.awsAugmontStage.value(),
          keyIndex);
      if (querySnapshot != null && querySnapshot.docs.length == 1) {
        DocumentSnapshot snapshot = querySnapshot.docs[0];
        Map<String, dynamic> _doc = snapshot.data();
        if (snapshot.exists &&
            _doc != null &&
            _doc['depNotice'] != null &&
            _doc['depNotice'].isNotEmpty) {
          return _doc['depNotice'];
        }
      }
    } catch (e) {
      logger.e(e.toString());
    }

    return null;
  }

  Future<bool> isAugmontBuyDisabled() async {
    try {
      String _awsKeyIndex = BaseRemoteConfig.remoteConfig
          .getString(BaseRemoteConfig.AWS_AUGMONT_KEY_INDEX);
      if (_awsKeyIndex == null || _awsKeyIndex.isEmpty) _awsKeyIndex = '1';
      int keyIndex = 1;
      try {
        keyIndex = int.parse(_awsKeyIndex);
      } catch (e) {
        log.error('Aws Index key parsing failed: ' + e.toString());
        keyIndex = 1;
      }
      logger.i("CALLING: getCredentialsByTypeAndStage");
      QuerySnapshot querySnapshot = await _api.getCredentialsByTypeAndStage(
          'aws-augmont',
          FlavorConfig.instance.values.awsAugmontStage.value(),
          keyIndex);
      if (querySnapshot != null && querySnapshot.docs.length == 1) {
        DocumentSnapshot snapshot = querySnapshot.docs[0];
        Map<String, dynamic> _doc = snapshot.data();
        if (snapshot.exists &&
            _doc != null &&
            _doc['isDepLocked'] != null &&
            _doc['isDepLocked']) {
          return true;
        }
      }
    } catch (e) {
      logger.e(e.toString());
    }
    return false;
  }

  Future<String> showAugmontSellNotice() async {
    try {
      String _awsKeyIndex = BaseRemoteConfig.remoteConfig
          .getString(BaseRemoteConfig.AWS_AUGMONT_KEY_INDEX);
      if (_awsKeyIndex == null || _awsKeyIndex.isEmpty) _awsKeyIndex = '1';
      int keyIndex = 1;
      try {
        keyIndex = int.parse(_awsKeyIndex);
      } catch (e) {
        log.error('Aws Index key parsing failed: ' + e.toString());
        keyIndex = 1;
      }
      logger.i("CALLING: getCredentialsByTypeAndStage");
      QuerySnapshot querySnapshot = await _api.getCredentialsByTypeAndStage(
          'aws-augmont',
          FlavorConfig.instance.values.awsAugmontStage.value(),
          keyIndex);
      if (querySnapshot != null && querySnapshot.docs.length == 1) {
        DocumentSnapshot snapshot = querySnapshot.docs[0];
        Map<String, dynamic> _doc = snapshot.data();
        if (snapshot.exists &&
            _doc != null &&
            _doc['sellNotice'] != null &&
            _doc['sellNotice'].isNotEmpty) {
          return _doc['sellNotice'];
        }
      }
    } catch (e) {
      logger.e(e.toString());
    }

    return null;
  }

  Future<bool> isAugmontSellDisabled() async {
    try {
      String _awsKeyIndex = BaseRemoteConfig.remoteConfig
          .getString(BaseRemoteConfig.AWS_AUGMONT_KEY_INDEX);
      if (_awsKeyIndex == null || _awsKeyIndex.isEmpty) _awsKeyIndex = '1';
      int keyIndex = 1;
      try {
        keyIndex = int.parse(_awsKeyIndex);
      } catch (e) {
        log.error('Aws Index key parsing failed: ' + e.toString());
        keyIndex = 1;
      }
      logger.i("CALLING: getCredentialsByTypeAndStage");
      QuerySnapshot querySnapshot = await _api.getCredentialsByTypeAndStage(
          'aws-augmont',
          FlavorConfig.instance.values.awsAugmontStage.value(),
          keyIndex);
      if (querySnapshot != null && querySnapshot.docs.length == 1) {
        DocumentSnapshot snapshot = querySnapshot.docs[0];
        Map<String, dynamic> _doc = snapshot.data();
        if (snapshot.exists &&
            _doc != null &&
            _doc['isSellLocked'] != null &&
            _doc['isSellLocked']) {
          return true;
        }
      }
    } catch (e) {
      logger.e(e.toString());
    }

    return false;
  }

  Future<String> getUserDP(String uid) async {
    try {
      logger.i("CALLING: getFileFromDPBucketURL");
      return await _api.getFileFromDPBucketURL(uid, 'image');
    } catch (e) {
      log.error('Failed to fetch dp url');
      return null;
    }
  }

//------------------------------------------------REALTIME----------------------------

  Future<bool> checkIfUsernameIsAvailable(String username) async {
    logger.i("CALLING: checkUserNameAvailability");
    return await _api.checkUserNameAvailability(username);
  }

  Future<bool> sendEmailToVerifyEmail(String email, String otp) async {
    logger.i("CALLING: createEmailVerificationDocument");
    return await _api.createEmailVerificationDocument(email, otp);
  }

  Future fetchCategorySpecificFAQ(String category) async {
    try {
      logger.i("CALLING: fetchFaqs");
      final DocumentSnapshot response = await _api.fetchFaqs(category);
      logger.d(response.data().toString());
      return ApiResponse(model: FAQModel.fromMap(response.data()), code: 200);
    } catch (e) {
      logger.e(e);
      return ApiResponse.withError(e.toString(), 400);
    }
  }
}
