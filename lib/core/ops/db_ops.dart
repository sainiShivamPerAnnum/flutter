import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info/device_info.dart';
import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/base_remote_config.dart';
import 'package:felloapp/core/model/alert_model.dart';
import 'package:felloapp/core/model/base_user_model.dart';
import 'package:felloapp/core/model/daily_pick_model.dart';
import 'package:felloapp/core/model/faq_model.dart';
import 'package:felloapp/core/model/feed_card_model.dart';
import 'package:felloapp/core/model/promo_cards_model.dart';
import 'package:felloapp/core/model/referral_details_model.dart';
import 'package:felloapp/core/model/tambola_board_model.dart';
import 'package:felloapp/core/model/tambola_winners_details.dart';
import 'package:felloapp/core/model/user_augmont_details_model.dart';
import 'package:felloapp/core/model/user_funt_wallet_model.dart';
import 'package:felloapp/core/model/user_icici_detail_model.dart';
import 'package:felloapp/core/model/user_ticket_wallet_model.dart';
import 'package:felloapp/core/model/user_transaction_model.dart';
import 'package:felloapp/core/service/api.dart';
import 'package:felloapp/core/service/cache_manager.dart';
import 'package:felloapp/util/api_response.dart';
import 'package:felloapp/util/code_from_freq.dart';
import 'package:felloapp/util/constants.dart';
import 'package:felloapp/util/credentials_stage.dart';
import 'package:felloapp/util/fail_types.dart';
import 'package:felloapp/util/flavor_config.dart';
import 'package:felloapp/util/help_types.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/logger.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:felloapp/util/custom_logger.dart';
import 'package:synchronized/synchronized.dart';

class DBModel extends ChangeNotifier {
  Api _api = locator<Api>();
  Lock _lock = new Lock();
  final Log log = new Log("DBModel");
  final logger = locator<CustomLogger>();
  FirebaseCrashlytics firebaseCrashlytics = FirebaseCrashlytics.instance;
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  bool isDeviceInfoInitiated = false;
  String phoneModel;
  String softwareVersion;

  Future<void> initDeviceInfo() async {
    try {
      if (Platform.isIOS) {
        IosDeviceInfo iosDeviceInfo;
        iosDeviceInfo = await deviceInfo.iosInfo;
        phoneModel = iosDeviceInfo.model;
        softwareVersion = iosDeviceInfo.systemVersion;
      } else if (Platform.isAndroid) {
        AndroidDeviceInfo androidDeviceInfo = await deviceInfo.androidInfo;
        phoneModel = androidDeviceInfo.model;
        softwareVersion = androidDeviceInfo.version.release;
      }
      isDeviceInfoInitiated = true;
    } catch (e) {
      log.error('Initiating Device Info failed');
    }
  }

  Future<bool> updateClientToken(BaseUser user, String token) async {
    try {
      //String id = user.mobile;
      String id = user.uid;
      var dMap = {'token': token, 'timestamp': Timestamp.now()};
      await _api.updateUserClientToken(id, dMap);
      return true;
    } catch (e) {
      log.error("Failed to update User Client Token: " + e.toString());
      return false;
    }
  }

  //////////////////BASE USER//////////////////////////
  Future<BaseUser> getUser(String id) async {
    try {
      var doc = await _api.getUserById(id);
      return BaseUser.fromMap(doc.data(), id);
    } catch (e) {
      log.error("Error fetch User details: " + e.toString());
      return null;
    }
  }

  Future<bool> updateUser(BaseUser user) async {
    try {
      //String id = user.mobile;
      String id = user.uid;
      await _api.updateUserDocument(id, user.toJson());
      return true;
    } catch (e) {
      log.error("Failed to update user object: " + e.toString());
      return false;
    }
  }

  Future<bool> updateUserPreferences(
      String uid, UserPreferences userPreferences) async {
    try {
      await _api.updateUserDocumentPreferenceField(
          uid, {BaseUser.fldUserPrefs: userPreferences.toJson()});
      return true;
    } catch (e) {
      log.error("Failed to update user preference field: $e");
      return false;
    }
  }

  Future<bool> checkIfUserHasNewNotifications(String userId) async {
    try {
      QuerySnapshot notificationSnapshot =
          await _api.checkForLatestNotification(userId);
      QuerySnapshot announcementSnapshot =
          await _api.checkForLatestAnnouncment(userId);
      AlertModel lastestNotification =
          AlertModel.fromMap(notificationSnapshot.docs.first.data());
      AlertModel lastestAnnouncement =
          AlertModel.fromMap(announcementSnapshot.docs.first.data());

      String latestNotifTime = await CacheManager.readCache(
          key: CacheManager.CACHE_LATEST_NOTIFICATION_TIME);
      if (latestNotifTime != null) {
        int latestTimeInMilliSeconds = int.tryParse(latestNotifTime);
        AlertModel latestAlert =
            lastestNotification.createdTime.millisecondsSinceEpoch >
                    lastestAnnouncement.createdTime.millisecondsSinceEpoch
                ? lastestNotification
                : lastestAnnouncement;
        if (latestAlert.createdTime.millisecondsSinceEpoch >
            latestTimeInMilliSeconds)
          return true;
        else
          return false;
      } else {
        logger.d("No past notification time found");
        return false;
      }
    } catch (e) {
      logger.e(e);
    }
    return false;
  }

  Future<Map<String, dynamic>> getUserNotifications(
      String userId, DocumentSnapshot lastDoc, bool more) async {
    List<AlertModel> alerts = [];
    List<AlertModel> announcements = [];
    List<AlertModel> notifications = [];
    DocumentSnapshot lastAlertDoc;
    logger.d("user id - $userId");

    try {
      QuerySnapshot querySnapshot =
          await _api.getUserNotifications(userId, lastDoc);
      if (querySnapshot != null) {
        lastAlertDoc = querySnapshot.docs.last;
        for (DocumentSnapshot documentSnapshot in querySnapshot.docs) {
          AlertModel alert = AlertModel.fromMap(documentSnapshot.data());
          logger.d(alert.toString());
          alerts.add(alert);
        }
      }
    } catch (e) {
      logger.e(e);
    }
    if (!more) {
      try {
        QuerySnapshot querySnapshot = await _api.getAnnoucements();
        for (DocumentSnapshot documentSnapshot in querySnapshot.docs) {
          AlertModel announcement = AlertModel.fromMap(documentSnapshot.data());
          logger.d(announcement.subtitle);
          announcements.add(announcement);
        }
      } catch (e) {
        logger.e(e);
      }
    }

    notifications.addAll(alerts);
    notifications.addAll(announcements);

    notifications
        .sort((a, b) => b.createdTime.seconds.compareTo(a.createdTime.seconds));

    return {
      'notifications': notifications,
      'lastAlertDoc': lastAlertDoc,
      'alertsLength': alerts.length
    };
  }

  /// return obj:
  /// {value: GHexqwio123==, enid:2}
  Future<Map<String, dynamic>> getEncodedUserPan(String uid) async {
    try {
      var doc = await _api.getUserPrtdDocPan(uid);
      if (doc.exists && doc.data() != null) {
        Map<String, dynamic> _snapshotData = doc.data();
        String val = _snapshotData['value'];
        int enid = _snapshotData['enid'];
        if (val == null || val.isEmpty || enid == 0)
          return null;
        else
          return {'value': val, 'enid': enid};
      }
      return null;
    } catch (e) {
      log.error(e.toString());
      return null;
    }
  }

  Future<bool> saveEncodedUserPan(String uid, String encPan, int enid) async {
    try {
      Map<String, dynamic> pObj = {
        'enid': enid,
        'value': encPan,
        'type': 'pan',
        'timestamp': Timestamp.now()
      };
      await _api.addUserPrtdDocPan(uid, pObj);
      return true;
    } catch (e) {
      log.error(e.toString());
      return false;
    }
  }

  //////////////////ICICI////////////////////////////////
  Future<UserIciciDetail> getUserIciciDetails(String id) async {
    try {
      var doc = await _api.getUserIciciDetailDocument(id);
      return UserIciciDetail.fromMap(doc.data());
    } catch (e) {
      log.error('Failed to fetch user icici details: $e');
      return null;
    }
  }

  Future<bool> updateUserIciciDetails(
      String userId, UserIciciDetail iciciDetail) async {
    try {
      await _api.updateUserIciciDetailDocument(userId, iciciDetail.toJson());
      return true;
    } catch (e) {
      log.error("Failed to update user icici detail object: " + e.toString());
      return false;
    }
  }

  ///////////////////////AUGMONT/////////////////////////////
  Future<UserAugmontDetail> getUserAugmontDetails(String id) async {
    try {
      var doc = await _api.getUserAugmontDetailDocument(id);
      return UserAugmontDetail.fromMap(doc.data());
    } catch (e) {
      log.error('Failed to fetch user Augmont details: $e');
      return null;
    }
  }

  Future<bool> updateUserAugmontDetails(
      String userId, UserAugmontDetail augDetail) async {
    try {
      await _api.updateUserAugmontDetailDocument(userId, augDetail.toJson());
      return true;
    } catch (e) {
      log.error("Failed to update user augmont detail object: " + e.toString());
      return false;
    }
  }

  /////////////////////////USER TRANSACTION/////////////////////
  //returns document key
  Future<String> addUserTransaction(String userId, UserTransaction txn) async {
    try {
      var ref = await _api.addUserTransactionDocument(userId, txn.toJson());
      return ref.id;
    } catch (e) {
      log.error("Failed to update user transaction object: " + e.toString());
      return null;
    }
  }

  Future<UserTransaction> getUserTransaction(
      String userId, String docId) async {
    try {
      var doc = await _api.getUserTransactionDocument(userId, docId);
      return UserTransaction.fromMap(doc.data(), doc.id);
    } catch (e) {
      log.error('Failed to fetch user transaction details: $e');
      return null;
    }
  }

  Future<bool> updateUserTransaction(String userId, UserTransaction txn) async {
    try {
      await _api.updateUserTransactionDocument(
          userId, txn.docKey, txn.toJson());
      return true;
    } catch (e) {
      log.error("Failed to update user transaction object: " + e.toString());
      return false;
    }
  }

  Future<Map<String, dynamic>> getFilteredUserTransactions(
      {@required BaseUser user,
      String type,
      String subtype,
      String status,
      DocumentSnapshot lastDocument,
      @required int limit}) async {
    Map<String, dynamic> resultTransactionsMap = Map<String, dynamic>();
    List<UserTransaction> requestedTxns = [];
    try {
      String _id = user.uid;
      QuerySnapshot _querySnapshot = await _api.getUserTransactionsByField(
        userId: _id,
        type: type,
        subtype: subtype,
        status: status,
        lastDocument: lastDocument,
        limit: limit,
      );
      resultTransactionsMap['lastDocument'] = _querySnapshot.docs.last;
      resultTransactionsMap['length'] = _querySnapshot.docs.length;
      _querySnapshot.docs.forEach((txn) {
        try {
          if (txn.exists)
            requestedTxns.add(UserTransaction.fromMap(txn.data(), txn.id));
        } catch (e) {
          log.error('Failed to parse user transaction $txn');
        }
      });
      logger.d("No of transactions fetched: ${requestedTxns.length}");
      resultTransactionsMap['listOfTransactions'] = requestedTxns;
      return resultTransactionsMap;
    } catch (err) {
      log.error('Failed to fetch transactions:: $err');
      resultTransactionsMap['length'] = 0;
      resultTransactionsMap['listOfTransactions'] = requestedTxns;
      resultTransactionsMap['lastDocument'] = lastDocument;
      return resultTransactionsMap;
    }
  }

  ///////////////////////TAMBOLA TICKETING/////////////////////////
  Future<List<TambolaBoard>> getWeeksTambolaTickets(String userId) async {
    try {
      QuerySnapshot _querySnapshot = await _api.getValidUserTickets(
          userId, CodeFromFreq.getYearWeekCode());
      if (_querySnapshot == null || _querySnapshot.size == 0) return null;

      List<TambolaBoard> _requestedBoards = [];
      for (QueryDocumentSnapshot _docSnapshot in _querySnapshot.docs) {
        if (!_docSnapshot.exists || _docSnapshot.data() == null) continue;
        TambolaBoard _board =
            TambolaBoard.fromMap(_docSnapshot.data(), _docSnapshot.id);
        if (_board.isValid()) _requestedBoards.add(_board);
      }
      return _requestedBoards;
    } catch (err) {
      log.error('Failed to fetch tambola boards');
      return null;
    }
  }

  Future<DailyPick> getWeeklyPicks() async {
    try {
      DateTime date = new DateTime.now();
      int weekCde = CodeFromFreq.getYearWeekCode();
      QuerySnapshot querySnapshot = await _api.getWeekPickByCde(weekCde);

      if (querySnapshot.docs.length != 1) {
        log.error('Did not receive a single doc. Error staged');
        return null;
      } else {
        return DailyPick.fromMap(querySnapshot.docs[0].data());
      }
    } catch (e) {
      log.error("Error fetch Dailypick details: " + e.toString());
      return null;
    }
  }

  Future<bool> pushUserPrizeClaimChoice(
      String uid, TambolaWinnersDetail detail, PrizeClaimChoice choice) async {
    try {
      String key = 'winners.$uid.claim_data';
      Map<String, dynamic> updateMap = {key: choice.value()};
      await _api.updateWeeklyWinnerDocument(detail.winnerDocumentId, updateMap);

      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> updateUserReferralCount(
      String userId, ReferralDetail detail) async {
    try {
      Map<String, dynamic> _map = {};
      _map[ReferralDetail.fldUserReferralCount] = detail.refCount;
      await _api.updateReferralDocument(userId, _map);
      return true;
    } catch (e) {
      log.error('Failed to update referral count');
      return false;
    }
  }

  Future<bool> unlockReferralTickets(String userId) async {
    try {
      return await _api.setReferralDocBonusField(userId);
    } catch (e) {
      log.error('Failed to unlock referral tickets');
      return false;
    }
  }

  ///////////////////////////CREDENTIALS//////////////////////////////
  Future<Map<String, String>> getActiveAwsIciciApiKey() async {
    String _awsKeyIndex = BaseRemoteConfig.remoteConfig
        .getString(BaseRemoteConfig.AWS_ICICI_KEY_INDEX);
    if (_awsKeyIndex == null || _awsKeyIndex.isEmpty) _awsKeyIndex = '1';
    int keyIndex = 1;
    try {
      keyIndex = int.parse(_awsKeyIndex);
    } catch (e) {
      log.error('Aws Index key parsing failed: ' + e.toString());
      keyIndex = 1;
    }
    QuerySnapshot querySnapshot = await _api.getCredentialsByTypeAndStage(
        'aws-icici',
        FlavorConfig.instance.values.awsIciciStage.value(),
        keyIndex);
    if (querySnapshot != null && querySnapshot.docs.length == 1) {
      DocumentSnapshot snapshot = querySnapshot.docs[0];
      Map<String, dynamic> _doc = snapshot.data();
      if (snapshot.exists && _doc != null && _doc['apiKey'] != null) {
        log.debug('Found apiKey: ' + _doc['apiKey']);
        return {'baseuri': _doc['base_url'], 'key': _doc['apiKey']};
      }
    }

    return null;
  }

  Future<Map<String, String>> getActiveAwsAugmontApiKey() async {
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
    QuerySnapshot querySnapshot = await _api.getCredentialsByTypeAndStage(
        'aws-augmont',
        FlavorConfig.instance.values.awsAugmontStage.value(),
        keyIndex);
    if (querySnapshot != null && querySnapshot.docs.length == 1) {
      DocumentSnapshot snapshot = querySnapshot.docs[0];
      Map<String, dynamic> _doc = snapshot.data();
      if (snapshot.exists && _doc != null && _doc['apiKey'] != null) {
        log.debug('Found apiKey: ' + _doc['apiKey']);
        return {'baseuri': _doc['base_url'], 'key': _doc['apiKey']};
      }
    }

    return null;
  }

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

  Future<Map<String, String>> getActiveSignzyApiKey() async {
    int keyIndex = 1;
    QuerySnapshot querySnapshot = await _api.getCredentialsByTypeAndStage(
        'signzy', FlavorConfig.instance.values.signzyStage.value(), keyIndex);
    if (querySnapshot != null && querySnapshot.docs.length == 1) {
      DocumentSnapshot snapshot = querySnapshot.docs[0];
      Map<String, dynamic> _doc = snapshot.data();
      if (snapshot.exists && _doc != null && _doc['apiKey'] != null) {
        log.debug('Found apiKey: ' + _doc['apiKey']);
        return {'baseuri': _doc['base_url'], 'key': _doc['apiKey']};
      }
    }
    return null;
  }

  Future<Map<String, String>> getActiveFreshchatKey() async {
    int keyIndex = 1;
    QuerySnapshot querySnapshot = await _api.getCredentialsByTypeAndStage(
        'freshchat',
        FlavorConfig.instance.values.freshchatStage.value(),
        keyIndex);
    if (querySnapshot != null && querySnapshot.docs.length == 1) {
      DocumentSnapshot snapshot = querySnapshot.docs[0];
      if (snapshot.exists) {
        Map<String, dynamic> fKeys = snapshot.data();
        log.debug(fKeys.toString());
        return {
          'app_id': fKeys['appId'],
          'app_key': fKeys['appKey'],
          'app_domain': fKeys['domain'],
        };
      }
    }

    return null;
  }

  Future<bool> addCallbackRequest(
      String uid, String name, String mobile, int callTime,
      [int callWindow = 2]) async {
    try {
      DateTime today = DateTime.now();
      String year = today.year.toString();
      String monthCde =
          BaseUtil.getMonthName(monthNum: today.month).toUpperCase();
      Map<String, dynamic> data = {};
      data['user_id'] = uid;
      data['name'] = name;
      data['mobile'] = mobile;
      data['timestamp'] = Timestamp.now();
      data['call_time'] = callTime;
      data['call_window'] = callWindow;

      await _api.addCallbackDocument(year, monthCde, data);
      return true;
    } catch (e) {
      log.error("Error adding callback doc: " + e.toString());
      return false;
    }
  }

  Future<bool> addHelpRequest(
      String uid, String name, String mobile, HelpType helpType) async {
    try {
      DateTime today = DateTime.now();
      String year = today.year.toString();
      String monthCde =
          BaseUtil.getMonthName(monthNum: today.month).toUpperCase();
      Map<String, dynamic> data = {};
      data['user_id'] = uid;
      data['mobile'] = mobile;
      data['name'] = name;
      data['issue_type'] = helpType.value();
      data['timestamp'] = Timestamp.now();

      await _api.addCallbackDocument(year, monthCde, data);
      return true;
    } catch (e) {
      log.error("Error adding callback doc: " + e.toString());
      return false;
    }
  }

  Future<bool> addWinClaim(
      String uid,
      String userName,
      String name,
      String mobile,
      int currentTickCount,
      bool isEligible,
      Map<String, int> resMap) async {
    try {
      int weekCde = CodeFromFreq.getYearWeekCode();

      Map<String, dynamic> data = {};
      data['user_id'] = uid;
      data['mobile'] = mobile;
      data['name'] = name;
      data['username'] = userName;
      data['tck_count'] = currentTickCount;
      data['week_code'] = weekCde;
      data['ticket_cat_map'] = resMap;
      data['is_eligible'] = isEligible;
      data['timestamp'] = Timestamp.now();

      await _api.addClaimDocument(data);
      return true;
    } catch (e) {
      log.error("Error adding callback doc: " + e.toString());
      return false;
    }
  }

  ///Sample response:
  ///{ op_1: 52
  /// op_2: 65
  /// op_3: 37
  /// op_4: 75
  /// op_5: 99}
  Future<Map<String, dynamic>> getPollCount(
      [String pollId = Constants.POLL_FOLLOWUPGAME_ID]) async {
    try {
      DocumentSnapshot snapshot = await _api.getPollDocument(pollId);
      Map<String, dynamic> _doc = snapshot.data();
      if (snapshot.exists && _doc.length > 0) {
        return snapshot.data();
      }
    } catch (e) {
      log.error("Error fetch poll details: " + e.toString());
    }
    return null;
  }

  ///response parameter should be the index of the poll option = 1,2,3,4,5
  Future<bool> addUserPollResponse(String uid, int response,
      [String pollId = Constants.POLL_FOLLOWUPGAME_ID]) async {
    bool incrementFlag = true;
    try {
      await _api.incrementPollDocument(pollId, 'op_$response');
      incrementFlag = true;
    } catch (e) {
      print("Error incremeting poll");
      log.error(e);
      incrementFlag = false;
    }
    if (incrementFlag) {
      //poll incremented, now update user subcoln response
      try {
        Map<String, dynamic> pRes = {
          'pResponse': response,
          'pUserId': uid,
          'timestamp': Timestamp.now()
        };
        await _api.addUserPollResponseDocument(uid, pollId, pRes);
        return true;
      } catch (e) {
        log.error('$e');
        return false;
      }
    } else {
      return false;
    }
  }

  ///If response = -1, user has not added a poll response yet
  ///else response is option index, 1,2,3,4,5
  Future<int> getUserPollResponse(String uid,
      [String pollId = Constants.POLL_FOLLOWUPGAME_ID]) async {
    try {
      DocumentSnapshot docSnapshot =
          await _api.getUserPollResponseDocument(uid, pollId);
      if (docSnapshot.exists) {
        Map<String, dynamic> docData = docSnapshot.data();
        if (docData != null && docData['pResponse'] != null) {
          log.debug(
              'Found existing response from user: ${docData['pResponse']}');
          return docData['pResponse'];
        }
      }
    } catch (e) {
      log.error(e);
    }
    return -1;
  }

  Future<ReferralDetail> getUserReferralInfo(String uid) async {
    try {
      DocumentSnapshot snapshot = await _api.getUserReferDoc(uid);
      // .getReferralDocs(uid);
      Map<String, dynamic> _doc = snapshot.data();
      if (snapshot.exists && _doc != null && _doc.isNotEmpty) {
        return ReferralDetail.fromMap(snapshot.data());
      }
    } catch (e) {
      log.error("Error fetch referrals details: " + e.toString());
    }
    return null;
  }

  Future<List<ReferralDetail>> getUserReferrals(String uid) async {
    try {
      QuerySnapshot querySnapshot = await _api.getReferralDocs(uid);
      List<ReferralDetail> _refDetail = [];
      if (querySnapshot.size > 0) {
        for (QueryDocumentSnapshot snapshot in querySnapshot.docs) {
          Map<String, dynamic> _doc = snapshot.data();
          if (snapshot.exists && _doc != null && _doc.isNotEmpty) {
            ReferralDetail _detail = ReferralDetail.fromMap(snapshot.data());
            _refDetail.add(_detail);
          }
        }
      }
      return _refDetail;
    } catch (e) {
      log.error("Error fetch referrals details: " + e.toString());
    }
    return null;
  }

  Future<bool> addFundDeposit(
      String uid, String amount, String rawResponse, String status) async {
    try {
      DateTime today = DateTime.now();
      String year = today.year.toString();
      String monthCde =
          BaseUtil.getMonthName(monthNum: today.month).toUpperCase();
      int date = today.day;
      Map<String, dynamic> data = {};
      data['date'] = date;
      data['user_id'] = uid;
      data['amount'] = amount;
      data['raw_response'] = rawResponse;
      data['status'] = status;
      data['timestamp'] = Timestamp.now();

      await _api.addDepositDocument(year, monthCde, data);
      return true;
    } catch (e) {
      log.error("Error adding callback doc: " + e.toString());
      return false;
    }
  }

  Future<bool> addFundWithdrawal(
      String uid, String amount, String upiAddress) async {
    try {
      DateTime today = DateTime.now();
      String year = today.year.toString();
      String monthCde =
          BaseUtil.getMonthName(monthNum: today.month).toUpperCase();
      int date = today.day;
      Map<String, dynamic> data = {};
      data['date'] = date;
      data['user_id'] = uid;
      data['amount'] = amount;
      data['rec_upi_address'] = upiAddress;
      data['timestamp'] = Timestamp.now();

      await _api.addWithdrawalDocument(year, monthCde, data);
      return true;
    } catch (e) {
      log.error("Error adding callback doc: " + e.toString());
      return false;
    }
  }

  Future<bool> deleteExpiredUserTickets(String userId) async {
    try {
      int weekNumber = BaseUtil.getWeekNumber();
      if (weekNumber > 2) {
        return await _lock.synchronized(() async {
          ///eg: weekcode: 202105 -> delete all tickets older than 202103
          int weekCde = CodeFromFreq.getYearWeekCode();
          weekCde--;
          return await _api.deleteUserTicketsBeforeWeekCode(userId, weekCde);
        });
      } else {
        return false;
      }
    } catch (e) {
      log.error('$e');
      return false;
    }
  }

  Future<bool> deleteSelectUserTickets(
      String userId, List<String> ticketRef) async {
    try {
      return await _api.deleteUserTicketDocuments(userId, ticketRef);
    } catch (e) {
      log.error('$e');
      return false;
    }
  }

  Future<String> getUserDP(String uid) async {
    try {
      return await _api.getFileFromDPBucketURL(uid, 'image');
    } catch (e) {
      log.error('Failed to fetch dp url');
      return null;
    }
  }

  Future<List<String>> getWalkthroughUrls() async {
    try {
      return await _api.getWalkthroughFiles();
    } catch (e) {
      log.error('Failed to fetch walkthrough files');
      return null;
    }
  }

  Future<bool> submitFeedback(String userId, String fdbk) async {
    try {
      Map<String, dynamic> fdbkMap = {
        'user_id': userId,
        'timestamp': Timestamp.now(),
        'fdbk': fdbk
      };
      await _api.addFeedbackDocument(fdbkMap);
      return true;
    } catch (e) {
      log.error(e.toString());
      return false;
    }
  }

  Future<bool> logFailure(
      String userId, FailType failType, Map<String, dynamic> data) async {
    try {
      Map<String, dynamic> dMap = (data == null) ? {} : data;
      if (!isDeviceInfoInitiated) {
        await initDeviceInfo();
      }
      dMap['user_id'] = userId;
      dMap['fail_type'] = failType.value();
      dMap['manually_resolved'] = false;
      dMap['app_version'] =
          '${BaseUtil.packageInfo.version}+${BaseUtil.packageInfo.buildNumber}';
      if (phoneModel != null) {
        dMap['phone_model'] = phoneModel;
      }
      if (softwareVersion != null) {
        dMap['phone_version'] = softwareVersion;
      }
      dMap['timestamp'] = Timestamp.now();
      try {
        await firebaseCrashlytics.recordError(failType.toString(),
            StackTrace.fromString(failType.value().toUpperCase()),
            reason: dMap);
      } catch (e) {
        log.error('Crashlytics record error fail : $e');
      }
      if (failType == FailType.UserAugmontSellFailed ||
          failType == FailType.UserPaymentCompleteTxnFailed) {
        await _api.addPriorityFailedReport(dMap);
      } else if (failType == FailType.TambolaTicketGenerationFailed) {
        await _api.addGameFailedReport(dMap);
      } else {
        await _api.addFailedReportDocument(dMap);
      }
      return true;
    } catch (e) {
      log.error(e.toString());
      return false;
    }
  }

  //////////////////////USER FUNDS BALANCING////////////////////////////////////////
  Future<bool> isTicketGenerationInProcess(String id) async {
    try {
      var doc = await _api.getUserFundWalletDocById(id);
      Map<String, dynamic> resMap = doc.data();
      return (resMap != null &&
          resMap['tg_in_progress'] != null &&
          resMap['tg_in_progress']);
    } catch (e) {
      log.error("Error fetch UserFundWallet failed: $e");
      return false;
    }
  }

  Future<UserFundWallet> getUserFundWallet(String id) async {
    try {
      var doc = await _api.getUserFundWalletDocById(id);
      return UserFundWallet.fromMap(doc.data());
    } catch (e) {
      log.error("Error fetch UserFundWallet failed: $e");
      return null;
    }
  }

  Future<UserFundWallet> updateUserIciciBalance(
    String id,
    UserFundWallet originalWalletBalance,
    double changeAmount,
  ) async {
    ///make a copy of the wallet object
    UserFundWallet newWalletBalance =
        UserFundWallet.fromMap(originalWalletBalance.cloneMap());

    ///first update icici balance
    if (changeAmount < 0 &&
        (newWalletBalance.iciciBalance + changeAmount) < 0) {
      log.error(
          'ICICI Balance: Attempted to subtract amount more than available balance');
      return originalWalletBalance;
    } else {
      newWalletBalance.iciciBalance =
          BaseUtil.digitPrecision(newWalletBalance.iciciBalance + changeAmount);
      newWalletBalance.iciciPrinciple = BaseUtil.digitPrecision(
          newWalletBalance.iciciPrinciple + changeAmount);
    }

    ///make the wallet transaction
    try {
      //only add the relevant fields to the map
      Map<String, dynamic> rMap = {
        UserFundWallet.fldIciciPrinciple: newWalletBalance.iciciPrinciple,
        UserFundWallet.fldIciciBalance: newWalletBalance.iciciBalance
      };
      bool _flag = await _api.updateUserFundWalletFields(
          id,
          UserFundWallet.fldIciciPrinciple,
          originalWalletBalance.iciciPrinciple,
          rMap);
      log.debug('User ICICI Balance update transaction successful: $_flag');

      //if transaction fails, return the old wallet summary
      return (_flag) ? newWalletBalance : originalWalletBalance;
    } catch (e) {
      log.error('Failed to update ICICI balance: $e');
      return originalWalletBalance;
    }
  }

  String getMerchantTxnId(String uid) {
    return _api.getUserTransactionDocumentKey(uid).id;
  }

  ///Total Gold Balance = (current total grams owned * current selling rate)
  ///Total Gold Principle = old principle + changeAmount
  ///it shouldnt matter if its a deposit or a sell, all based on selling rate
  Future<UserFundWallet> updateUserAugmontGoldBalance(
      String id,
      UserFundWallet originalWalletBalance,
      double sellingRate,
      double totalQuantity,
      double changeAmt) async {
    ///make a copy of the wallet object
    UserFundWallet newWalletBalance;
    if (originalWalletBalance == null) {
      newWalletBalance = UserFundWallet.newWallet();
    } else {
      newWalletBalance =
          UserFundWallet.fromMap(originalWalletBalance.cloneMap());
    }

    ///first update augmont balance
    newWalletBalance.augGoldBalance =
        BaseUtil.digitPrecision(totalQuantity * sellingRate);
    newWalletBalance.augGoldPrinciple =
        BaseUtil.digitPrecision(newWalletBalance.augGoldPrinciple + changeAmt);
    newWalletBalance.augGoldQuantity = totalQuantity; //precision already added

    ///make the wallet transaction
    try {
      //only add the relevant fields to the map
      Map<String, dynamic> rMap = {
        UserFundWallet.fldAugmontGoldPrinciple:
            newWalletBalance.augGoldPrinciple,
        UserFundWallet.fldAugmontGoldBalance: newWalletBalance.augGoldBalance,
        UserFundWallet.fldAugmontGoldQuantity: newWalletBalance.augGoldQuantity,
      };
      bool _flag = await _api.updateUserFundWalletFields(
          id,
          UserFundWallet.fldAugmontGoldPrinciple,
          originalWalletBalance.augGoldPrinciple,
          rMap);
      log.debug(
          'User Augmont Gold Balance update transaction successful: $_flag');

      //if transaction fails, return the old wallet summary
      return (_flag) ? newWalletBalance : originalWalletBalance;
    } catch (e) {
      log.error('Failed to update Augmont Gold balance: $e');
      return originalWalletBalance;
    }
  }

  Future<double> getNonWithdrawableAugGoldQuantity(String userId,
      [int dayOffset = Constants.AUG_GOLD_WITHDRAW_OFFSET]) async {
    try {
      DateTime _dt = DateTime.now();
      DateTime _reqDate = DateTime(_dt.year, _dt.month, _dt.day - dayOffset,
          _dt.hour, _dt.minute, _dt.second);

      QuerySnapshot querySnapshot = await _api.getRecentAugmontDepositTxn(
          userId, Timestamp.fromDate(_reqDate));
      if (querySnapshot.size == 0)
        return 0.0;
      else {
        double _netQuantity = 0.0;
        for (QueryDocumentSnapshot snapshot in querySnapshot.docs) {
          Map<String, dynamic> _doc = snapshot.data();
          if (snapshot.exists && _doc != null && _doc.isNotEmpty) {
            UserTransaction _txn =
                UserTransaction.fromMap(snapshot.data(), snapshot.id);
            if (_txn != null &&
                _txn.augmnt != null &&
                _txn.augmnt[UserTransaction.subFldAugCurrentGoldGm] != null &&
                _txn.rzp != null) {
              double _qnt = BaseUtil.toDouble(
                  _txn.augmnt[UserTransaction.subFldAugCurrentGoldGm]);
              _netQuantity += _qnt;
            }
          }
        }
        if (_netQuantity > 0.0)
          _netQuantity = BaseUtil.digitPrecision(_netQuantity, 4, false);
        return _netQuantity;
      }
    } catch (e) {
      return 0.0;
    }
  }

  ///////////////////USER TICKET BALANCING///////////////////////////////////
  Future<UserTicketWallet> getUserTicketWallet(String id) async {
    try {
      var doc = await _api.getUserTicketWalletDocById(id);
      return UserTicketWallet.fromMap(doc.data());
    } catch (e) {
      log.error("Error fetch UserTicketWallet failed: $e");
      return null;
    }
  }

  Future<UserTicketWallet> updateInitUserTicketCount(
      String uid, UserTicketWallet userTicketWallet, int count) async {
    if (userTicketWallet == null) return null;
    int currentValue = userTicketWallet.initTck ?? 0;
    try {
      return await _lock.synchronized(() async {
        if (count < 0 && currentValue < count) {
          userTicketWallet.initTck = 0;
        } else {
          userTicketWallet.initTck = currentValue + count;
        }
        Map<String, dynamic> tMap = {
          UserTicketWallet.fldInitTckCount: userTicketWallet.initTck
        };
        bool flag = await _api.updateUserTicketWalletFields(
            uid, UserTicketWallet.fldInitTckCount, currentValue, tMap);
        if (!flag) {
          //revert value back as the op failed
          userTicketWallet.initTck = currentValue;
        }
        return userTicketWallet;
      });
    } catch (e) {
      log.error('Failed to update the user ticket count');
      userTicketWallet.initTck = currentValue;
      return userTicketWallet;
    }
  }

  Future<UserTicketWallet> updateAugmontGoldUserTicketCount(
      String uid, UserTicketWallet userTicketWallet, int count) async {
    if (userTicketWallet == null) return null;
    int currentValue = userTicketWallet.augGold99Tck ?? 0;
    try {
      return await _lock.synchronized(() async {
        if (count < 0 && currentValue < count) {
          userTicketWallet.augGold99Tck = 0;
        } else {
          userTicketWallet.augGold99Tck = currentValue + count;
        }
        Map<String, dynamic> tMap = {
          UserTicketWallet.fldAugmontGoldTckCount: userTicketWallet.augGold99Tck
        };
        bool flag = await _api.updateUserTicketWalletFields(
            uid, UserTicketWallet.fldAugmontGoldTckCount, currentValue, tMap);
        if (!flag) {
          //revert value back as the op failed
          userTicketWallet.augGold99Tck = currentValue;
        }
        return userTicketWallet;
      });
    } catch (e) {
      log.error('Failed to update the user ticket count');
      userTicketWallet.augGold99Tck = currentValue;
      return userTicketWallet;
    }
  }

  Future<UserTicketWallet> updateICICIUserTicketCount(
      String uid, UserTicketWallet userTicketWallet, int count) async {
    if (userTicketWallet == null) return null;
    int currentValue = userTicketWallet.icici1565Tck ?? 0;
    try {
      return await _lock.synchronized(() async {
        if (count < 0 && currentValue < count) {
          userTicketWallet.icici1565Tck = 0;
        } else {
          userTicketWallet.icici1565Tck = currentValue + count;
        }
        Map<String, dynamic> tMap = {
          UserTicketWallet.fldICICI1565TckCount: userTicketWallet.icici1565Tck
        };
        bool flag = await _api.updateUserTicketWalletFields(
            uid, UserTicketWallet.fldICICI1565TckCount, currentValue, tMap);
        if (!flag) {
          //revert value back as the op failed
          userTicketWallet.icici1565Tck = currentValue;
        }
        return userTicketWallet;
      });
    } catch (e) {
      log.error('Failed to update the user ticket count');
      //revert value back as the op failed
      userTicketWallet.icici1565Tck = currentValue;
      return userTicketWallet;
    }
  }

  Future<List<FeedCard>> getHomeCards() async {
    List<FeedCard> _cards = [];
    try {
      QuerySnapshot querySnapshot = await _api.getHomeCardCollection();
      if (querySnapshot != null && querySnapshot.docs.length > 0) {
        for (QueryDocumentSnapshot documentSnapshot in querySnapshot.docs) {
          Map<String, dynamic> _doc = documentSnapshot.data();
          if (documentSnapshot != null &&
              documentSnapshot.exists &&
              _doc != null &&
              _doc.length > 0) {
            FeedCard _card = FeedCard.fromMap(documentSnapshot.data());

            ///only include the feedcards that are not 'hidden'
            if (_card != null && _card.isHidden != null && !_card.isHidden)
              _cards.add(_card);

            ///bump down the 'learn' card if the user is old
          }
        }
      }
    } catch (e) {
      log.error('Error Fetching Home cards: ${e.toString()}');
    }
    return _cards;
  }

  Future<List<PromoCardModel>> getPromoCards() async {
    List<PromoCardModel> _cards = [];
    try {
      QuerySnapshot querySnapshot = await _api.getPromoCardCollection();
      if (querySnapshot != null && querySnapshot.docs.length > 0) {
        for (QueryDocumentSnapshot documentSnapshot in querySnapshot.docs) {
          Map<String, dynamic> _doc = documentSnapshot.data();
          if (documentSnapshot != null &&
              documentSnapshot.exists &&
              _doc != null &&
              _doc.length > 0) {
            PromoCardModel _card =
                PromoCardModel.fromMap(documentSnapshot.data());

            if (_card != null) _cards.add(_card);
          }
        }
      }
    } catch (e) {
      log.error('Error Fetching Home cards: ${e.toString()}');
    }
    return _cards;
  }

  Future<bool> checkIfUsernameIsAvailable(String username) async {
    return await _api.checkUserNameAvailability(username);
  }

  Future<bool> setUsername(String username, String userId) async {
    return await _api.setUserName(username, userId);
  }

  Future<bool> sendEmailToVerifyEmail(String email, String otp) async {
    return await _api.createEmailVerificationDocument(email, otp);
  }

  Future fetchCategorySpecificFAQ(String category) async {
    try {
      final DocumentSnapshot response = await _api.fetchFaqs(category);
      logger.d(response.data().toString());
      return ApiResponse(model: FAQModel.fromMap(response.data()), code: 200);
    } catch (e) {
      logger.e(e);
      return ApiResponse.withError(e.toString(), 400);
    }
  }
}
