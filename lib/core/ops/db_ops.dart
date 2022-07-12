import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/base_remote_config.dart';
import 'package:felloapp/core/model/base_user_model.dart';
import 'package:felloapp/core/model/coupon_card_model.dart';
import 'package:felloapp/core/model/faq_model.dart';
import 'package:felloapp/core/model/golden_ticket_model.dart';
import 'package:felloapp/core/model/promo_cards_model.dart';
import 'package:felloapp/core/model/referral_details_model.dart';
import 'package:felloapp/core/model/subscription_models/subscription_transaction_model.dart';
import 'package:felloapp/core/model/user_augmont_details_model.dart';
import 'package:felloapp/core/model/user_funt_wallet_model.dart';
import 'package:felloapp/core/model/user_transaction_model.dart';
import 'package:felloapp/core/service/api.dart';
import 'package:felloapp/core/service/notifier_services/internal_ops_service.dart';
import 'package:felloapp/util/api_response.dart';
import 'package:felloapp/util/credentials_stage.dart';
import 'package:felloapp/util/custom_logger.dart';
import 'package:felloapp/util/fail_types.dart';
import 'package:felloapp/util/flavor_config.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/logger.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:synchronized/synchronized.dart';

class DBModel extends ChangeNotifier {
  Api _api = locator<Api>();
  Lock _lock = new Lock();
  final Log log = new Log("DBModel");
  final FirebaseCrashlytics firebaseCrashlytics = FirebaseCrashlytics.instance;
  final logger = locator<CustomLogger>();
  final _internalOpsService = locator<InternalOpsService>();

  Future<bool> updateClientToken(BaseUser user, String token) async {
    try {
      //String id = user.mobile;
      String id = user.uid;
      var dMap = {'token': token, 'timestamp': Timestamp.now()};
      logger.i("CALLING: updateUserClientToken");
      await _api.updateUserClientToken(id, dMap);
      return true;
    } catch (e) {
      log.error("Failed to update User Client Token: " + e.toString());
      return false;
    }
  }

  //////////////////BASE USER//////////////////////////
  Future<ApiResponse<BaseUser>> getUser(String id) async {
    try {
      logger.i("CALLING: getUserById");
      var doc = await _api.getUserById(id);
      BaseUser user;
      if (doc.data() == null) {
        return ApiResponse(model: null, code: 200);
      }
      try {
        user = BaseUser.fromMap(doc.data(), id);
      } catch (e) {
        _internalOpsService.logFailure(
          id,
          FailType.UserDataCorrupted,
          {'message': "User data corrupted"},
        );
        return ApiResponse.withError("User data corrupted", 400);
      }

      return ApiResponse(model: user, code: 200);
    } catch (e) {
      log.error("Error fetch User details: " + e.toString());
      return ApiResponse(model: null, code: 400);
    }
  }

  Future<bool> updateUserEmail(String uid, String email, bool emailFlag) async {
    try {
      String id = uid;
      await _api.updateUserDocumentPreferenceField(id,
          {BaseUser.fldEmail: email, BaseUser.fldIsEmailVerified: emailFlag});
      return true;
    } catch (e) {
      log.error("Failed to update user email and flag: " + e.toString());
      return false;
    }
  }

  Future<bool> updateUserProfile(
      String uid, String name, String dob, String gender) async {
    try {
      String id = uid;
      await _api.updateUserDocumentPreferenceField(id, {
        BaseUser.fldName: name,
        BaseUser.fldDob: dob,
        BaseUser.fldGender: gender
      });
      return true;
    } catch (e) {
      log.error("Failed to update user profile: " + e.toString());
      return false;
    }
  }

  Future<bool> updateUserPreferences(
      String uid, UserPreferences userPreferences) async {
    try {
      logger.i("CALLING: updateUserDocumentPreferenceField");
      await _api.updateUserDocumentPreferenceField(
          uid, {BaseUser.fldUserPrefs: userPreferences.toJson()});
      return true;
    } catch (e) {
      log.error("Failed to update user preference field: $e");
      return false;
    }
  }

  Future<bool> checkIfUserHasUnscratchedGT(String userId) async {
    try {
      QuerySnapshot gtSnapshot = await _api.checkForLatestGTStatus(userId);
      List<GoldenTicket> latestGTs = [];
      gtSnapshot.docs.forEach((element) {
        latestGTs.add(GoldenTicket.fromJson(element.data(), element.id));
      });
      logger.d("Latest Golden Ticket: ${gtSnapshot.docs.first.data()}");
      for (int i = 0; i < latestGTs.length; i++) {
        if (latestGTs[i].redeemedTimestamp == null) {
          return true;
        }
      }
      return false;
    } catch (e) {
      logger.e(e.toString());
      return false;
    }
  }

  /// return obj:
  /// {value: GHexqwio123==, enid:2}
  Future<Map<String, dynamic>> getEncodedUserPan(String uid) async {
    try {
      logger.i("CALLING: getUserPrtdDocPan");
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

  ///////////////////////AUGMONT/////////////////////////////

  Future<bool> updateAugmontBankDetails(
      String userId, String accNo, String ifsc, String bankHolderName) async {
    try {
      Map<String, dynamic> updatePayload = {};
      updatePayload[UserAugmontDetail.fldBankAccNo] = accNo;
      updatePayload[UserAugmontDetail.fldBankHolderName] = bankHolderName;
      updatePayload[UserAugmontDetail.fldIfsc] = ifsc;
      updatePayload[UserAugmontDetail.fldUpdatedTime] = Timestamp.now();
      logger.i("CALLING: updateUserAugmontDetailDocument");
      await _api.updateUserAugmontDetailDocument(userId, updatePayload);
      return true;
    } catch (e) {
      log.error("Failed to update user augmont detail object: " + e.toString());
      return false;
    }
  }

  ///////////////////////////CREDENTIALS//////////////////////////////

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
    logger.i("CALLING: getCredentialsByTypeAndStage");
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

  Future<List<ReferralDetail>> getUserReferrals(String uid) async {
    try {
      logger.i("CALLING: getReferralDocs");
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

  Future<String> getUserDP(String uid) async {
    try {
      logger.i("CALLING: getFileFromDPBucketURL");
      return await _api.getFileFromDPBucketURL(uid, 'image');
    } catch (e) {
      log.error('Failed to fetch dp url');
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
      logger.i("CALLING: addFeedbackDocument");
      await _api.addFeedbackDocument(fdbkMap);
      return true;
    } catch (e) {
      log.error(e.toString());
      return false;
    }
  }

  //////////////////////USER FUNDS BALANCING////////////////////////////////////////

  Future<UserFundWallet> getUserFundWallet(String id) async {
    try {
      logger.i("CALLING: getUserFundWalletDocById");
      var doc = await _api.getUserFundWalletDocById(id);
      return UserFundWallet.fromMap(doc.data());
    } catch (e) {
      log.error("Error fetch UserFundWallet failed: $e");
      return null;
    }
  }

  Future<List<PromoCardModel>> getPromoCards() async {
    List<PromoCardModel> _cards = [];
    List<PromoCardModel> filteredcards = [];

    try {
      logger.i("CALLING: getPromoCardCollection");
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
    for (int i = 0; i < _cards.length; i++) {
      if (_cards[i].minVersion == 0 ||
          int.tryParse(BaseUtil.packageInfo.buildNumber) >=
              _cards[i].minVersion) {
        filteredcards.add(_cards[i]);
      }
    }
    return filteredcards;
  }

  Future<List<CouponModel>> getCoupons() async {
    List<CouponModel> couponList = [];
    try {
      logger.i("CALLING: fetchCoupons");
      QuerySnapshot snapshot = await _api.fetchCoupons();
      snapshot.docs.forEach((element) {
        couponList.add(CouponModel.fromMap(element.data()));
      });
    } catch (e) {
      logger.e(e.toString());
      couponList = [];
    }

    return couponList;
  }

  Future<Map<String, dynamic>> getAutosaveTransactions(
      {@required String uid,
      @required String subId,
      DocumentSnapshot lastDocument,
      @required int limit}) async {
    Map<String, dynamic> resultAutosaveTransactionsMap = Map<String, dynamic>();
    List<AutosaveTransactionModel> requestedTxns = [];
    try {
      QuerySnapshot _querySnapshot = await _api.getAutosaveTransactions(
        userId: uid,
        lastDocument: lastDocument,
        limit: limit,
      );
      logger.d(_querySnapshot.docs.first.data());
      resultAutosaveTransactionsMap['lastDocument'] = _querySnapshot.docs.last;
      resultAutosaveTransactionsMap['length'] = _querySnapshot.docs.length;
      _querySnapshot.docs.forEach((txn) {
        try {
          if (txn.exists)
            requestedTxns.add(AutosaveTransactionModel.fromMap(txn.data()));
        } catch (e) {
          log.error('Failed to parse user transaction $txn');
        }
      });
      logger.d("No of autosave transactions fetched: ${requestedTxns.length}");
      resultAutosaveTransactionsMap['listOfTransactions'] = requestedTxns;
      return resultAutosaveTransactionsMap;
    } catch (err) {
      requestedTxns = [];
      log.error('Failed to fetch transactions:: $err');
      resultAutosaveTransactionsMap['length'] = 0;
      resultAutosaveTransactionsMap['listOfTransactions'] = requestedTxns;
      resultAutosaveTransactionsMap['lastDocument'] = lastDocument;
      return resultAutosaveTransactionsMap;
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
