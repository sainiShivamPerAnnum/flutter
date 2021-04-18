import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/model/BaseUser.dart';
import 'package:felloapp/core/model/DailyPick.dart';
import 'package:felloapp/core/model/PrizeLeader.dart';
import 'package:felloapp/core/model/ReferralLeader.dart';
import 'package:felloapp/core/model/TambolaBoard.dart';
import 'package:felloapp/core/model/UserAugmontDetail.dart';
import 'package:felloapp/core/model/UserIciciDetail.dart';
import 'package:felloapp/core/model/UserKycDetail.dart';
import 'package:felloapp/core/model/UserTicketWallet.dart';
import 'package:felloapp/core/model/UserTransaction.dart';
import 'package:felloapp/core/model/UserFundWallet.dart';
import 'package:felloapp/core/service/api.dart';
import 'package:felloapp/util/constants.dart';
import 'package:felloapp/util/credentials_stage.dart';
import 'package:felloapp/util/fail_types.dart';
import 'package:felloapp/util/help_types.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/logger.dart';
import 'package:flutter/material.dart';
import 'package:synchronized/synchronized.dart';

class DBModel extends ChangeNotifier {
  Api _api = locator<Api>();
  ValueChanged<List<TambolaBoard>> userTicketsUpdated;
  Lock _lock = new Lock();
  final Log log = new Log("DBModel");

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

  Future<UserKycDetail> getUserKycDetails(String id) async {
    try {
      var doc = await _api.getUserKycDetailDocument(id);
      // print(UserKycDetail.fromMap(doc.data()));
      return UserKycDetail.fromMap(doc.data());
    } catch (e) {
      log.error('Failed to fetch user kyc details: $e');
      return null;
    }
  }

  Future<bool> updateUserKycDetails(
      String userId, UserKycDetail kycDetail) async {
    try {
      await _api.updateUserKycDetailDocument(userId, kycDetail.toJson());
      return true;
    } catch (e) {
      log.error("Failed to update user kyc detail object: " + e.toString());
      return false;
    }
  }

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

  Future<bool> pushTicketRequest(BaseUser user, int count) async {
    try {
      String _uid = user.uid;
      var rMap = {
        'user_id': _uid,
        'manual': false,
        'count': count,
        'week_code': _getWeekCode(),
        'timestamp': Timestamp.now()
      };
      await _api.createTicketRequest(_uid, rMap);
      return true;
    } catch (e) {
      log.error('Failed to push new request: ' + e.toString());
      return false;
    }
  }

  bool subscribeUserTickets(BaseUser user) {
    try {
      String _id = user.uid;
      Stream<QuerySnapshot> _stream =
          _api.getValidUserTickets(_id, _getWeekCode());
      _stream.listen((querySnapshot) {
        List<TambolaBoard> requestedBoards = [];
        querySnapshot.docs.forEach((docSnapshot) {
          if (docSnapshot.exists)
            log.debug('Received snapshot: ' + docSnapshot.data.toString());
          TambolaBoard board = TambolaBoard.fromMap(docSnapshot.data());
          if (board.isValid()) requestedBoards.add(board);
        });
        log.debug(
            'Post stream update-> sending ticket count to dashboard: ${requestedBoards.length}');
        if (userTicketsUpdated != null) userTicketsUpdated(requestedBoards);
      });
    } catch (err) {
      log.error('Failed to fetch tambola boards');
      return false;
    }
    return true;
  }

  Future<DailyPick> getWeeklyPicks() async {
    try {
      DateTime date = new DateTime.now();
      int weekCde = date.year * 100 + BaseUtil.getWeekNumber();
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

  Future<Map<String, dynamic>> getWeeklyWinners() async {
    try {
      // DateTime date = new DateTime.now();
      // int weekCde = date.year * 100 + BaseUtil.getWeekNumber();

      ////DUMMY
      int weekCde = 202105;
      /////
      QuerySnapshot querySnapshot = await _api.getWinnersByWeekCde(weekCde);
      if (querySnapshot != null && querySnapshot.docs.length == 1) {
        DocumentSnapshot snapshot = querySnapshot.docs[0];
        if (snapshot.exists && snapshot.data()['winners'] != null) {
          Map<String, dynamic> rMap = snapshot.data()['winners'];
          log.debug(rMap.toString());
          return rMap;
        }
      }
      return null;
    } catch (e) {
      log.error("Error fetch weekly winners details: " + e.toString());
      return null;
    }
  }

  Future<Map<String, String>> getActiveAwsIciciApiKey() async {
    String _awsKeyIndex =
        BaseUtil.remoteConfig.getString('aws_icici_key_index');
    if (_awsKeyIndex == null || _awsKeyIndex.isEmpty) _awsKeyIndex = '1';
    int keyIndex = 1;
    try {
      keyIndex = int.parse(_awsKeyIndex);
    } catch (e) {
      log.error('Aws Index key parsing failed: ' + e.toString());
      keyIndex = 1;
    }
    QuerySnapshot querySnapshot = await _api.getCredentialsByTypeAndStage(
        'aws-icici', BaseUtil.activeAwsIciciStage.value(), keyIndex);
    if (querySnapshot != null && querySnapshot.docs.length == 1) {
      DocumentSnapshot snapshot = querySnapshot.docs[0];
      if (snapshot.exists && snapshot.data()['apiKey'] != null) {
        log.debug('Found apiKey: ' + snapshot.data()['apiKey']);
        return {
          'baseuri': snapshot.data()['base_url'],
          'key': snapshot.data()['apiKey']
        };
      }
    }

    return null;
  }

  Future<Map<String, String>> getActiveAwsAugmontApiKey() async {
    String _awsKeyIndex =
        BaseUtil.remoteConfig.getString('aws_augmont_key_index');
    if (_awsKeyIndex == null || _awsKeyIndex.isEmpty) _awsKeyIndex = '1';
    int keyIndex = 1;
    try {
      keyIndex = int.parse(_awsKeyIndex);
    } catch (e) {
      log.error('Aws Index key parsing failed: ' + e.toString());
      keyIndex = 1;
    }
    QuerySnapshot querySnapshot = await _api.getCredentialsByTypeAndStage(
        'aws-augmont', BaseUtil.activeAwsAugmontStage.value(), keyIndex);
    if (querySnapshot != null && querySnapshot.docs.length == 1) {
      DocumentSnapshot snapshot = querySnapshot.docs[0];
      if (snapshot.exists && snapshot.data()['apiKey'] != null) {
        log.debug('Found apiKey: ' + snapshot.data()['apiKey']);
        return {
          'baseuri': snapshot.data()['base_url'],
          'key': snapshot.data()['apiKey']
        };
      }
    }

    return null;
  }

  Future<Map<String, String>> getActiveSignzyApiKey() async {
    int keyIndex = 1;
    QuerySnapshot querySnapshot = await _api.getCredentialsByTypeAndStage(
        'signzy', BaseUtil.activeSignzyStage.value(), keyIndex);
    if (querySnapshot != null && querySnapshot.docs.length == 1) {
      DocumentSnapshot snapshot = querySnapshot.docs[0];
      if (snapshot.exists && snapshot.data()['apiKey'] != null) {
        log.debug('Found apiKey: ' + snapshot.data()['apiKey']);
        return {
          'baseuri': snapshot.data()['base_url'],
          'key': snapshot.data()['apiKey']
        };
      }
    }
    return null;
  }

  Future<List<UserTransaction>> getFilteredUserTransactions(
      BaseUser user, String type, String subtype,
      [int limit = 30]) async {
    List<UserTransaction> requestedTxns = [];
    try {
      String _id = user.uid;
      QuerySnapshot _querySnapshot =
          await _api.getUserTransactionsByField(_id, type, subtype, limit);
      _querySnapshot.docs.forEach((txn) {
        try {
          if (txn.exists)
            requestedTxns.add(UserTransaction.fromMap(txn.data(), txn.id));
        } catch (e) {
          log.error('Failed to parse user transaction $txn');
        }
      });
      print("LENGTH----------------->" + requestedTxns.length.toString());
      return requestedTxns;
    } catch (err) {
      log.error('Failed to fetch user mini transactions');
      return requestedTxns;
    }
  }

  Future<bool> addCallbackRequest(
      String uid, String name, String mobile) async {
    try {
      DateTime today = DateTime.now();
      String year = today.year.toString();
      String monthCde = getCurrentMonthCode(today.month);
      Map<String, dynamic> data = {};
      data['user_id'] = uid;
      data['name'] = name;
      data['mobile'] = mobile;
      data['timestamp'] = Timestamp.now();

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
      String monthCde = getCurrentMonthCode(today.month);
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

  Future<bool> addWinClaim(String uid, String name, String mobile,
      int currentTickCount, Map<String, int> resMap) async {
    try {
      DateTime date = new DateTime.now();
      int weekCde = date.year * 100 + BaseUtil.getWeekNumber();

      Map<String, dynamic> data = {};
      data['user_id'] = uid;
      data['mobile'] = mobile;
      data['name'] = name;
      data['tck_count'] = currentTickCount;
      data['week_code'] = weekCde;
      data['ticket_cat_map'] = resMap;
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
      [String pollId = Constants.POLL_NEXTGAME_ID]) async {
    try {
      DocumentSnapshot snapshot = await _api.getPollDocument(pollId);
      if (snapshot.exists && snapshot.data().length > 0) {
        return snapshot.data();
      }
    } catch (e) {
      log.error("Error fetch poll details: " + e.toString());
    }
    return null;
  }

  ///response parameter should be the index of the poll option = 1,2,3,4,5
  Future<bool> addUserPollResponse(String uid, int response,
      [String pollId = Constants.POLL_NEXTGAME_ID]) async {
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
      [String pollId = Constants.POLL_NEXTGAME_ID]) async {
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

  Future<List<ReferralLeader>> getReferralLeaderboard() async {
    try {
      int weekCode = _getWeekCode();
      QuerySnapshot _querySnapshot =
          await _api.getLeaderboardDocument('referral', weekCode);
      if (_querySnapshot == null || _querySnapshot.size != 1) return [];

      DocumentSnapshot _docSnapshot = _querySnapshot.docs[0];
      if (!_docSnapshot.exists || _docSnapshot.data()['leaders'] == [])
        return null;
      Map<String, dynamic> leaderMap = _docSnapshot.data()['leaders'];
      log.debug('Referral Leader Map: $leaderMap');

      List<ReferralLeader> leaderList = [];
      leaderMap.forEach((key, value) {
        try {
          String uid = key;
          Map<String, dynamic> vals = value;
          String usrName = vals['name'];
          int usrRefCount = vals['ref_count'];
          log.debug('Leader details:: $uid, $usrName, $usrRefCount');
          leaderList.add(ReferralLeader(uid, usrName, usrRefCount));
        } catch (err) {
          log.error('Item skipped');
        }
      });

      return leaderList;
    } catch (e) {
      log.error(e);
      return [];
    }
  }

  Future<List<PrizeLeader>> getPrizeLeaderboard() async {
    try {
      int weekCode = _getWeekCode();
      QuerySnapshot _querySnapshot =
          await _api.getLeaderboardDocument('prize', weekCode);
      if (_querySnapshot == null || _querySnapshot.size != 1) return [];

      DocumentSnapshot _docSnapshot = _querySnapshot.docs[0];
      if (!_docSnapshot.exists || _docSnapshot.data()['leaders'] == [])
        return null;
      Map<String, dynamic> leaderMap = _docSnapshot.data()['leaders'];
      log.debug('Prize Leader Map: $leaderMap');

      List<PrizeLeader> leaderList = [];
      leaderMap.forEach((key, value) {
        try {
          String uid = key;
          Map<String, dynamic> vals = value;
          String usrName = vals['name'];
          var usrTotalWin = vals['win_total'];
          double uTotal;
          try {
            uTotal = usrTotalWin;
          } catch (e) {
            uTotal = usrTotalWin + .0;
          }
          log.debug('Leader details:: $uid, $usrName, $uTotal');
          leaderList.add(PrizeLeader(uid, usrName, uTotal));
        } catch (err) {
          log.error('Item skipped');
        }
      });
      return leaderList;
    } catch (e) {
      log.error(e);
      return [];
    }
  }

  Future<int> getReferCount(String uid) async {
    try {
      var docs = await _api.getReferedDocs(uid);
      if (docs != null && docs.docs != null && docs.docs.length > 0)
        return docs.docs.length;
    } catch (e) {
      log.error("Error fetch referrals details: " + e.toString());
    }
    return 0;
  }

  Future<bool> addFundDeposit(
      String uid, String amount, String rawResponse, String status) async {
    try {
      DateTime today = DateTime.now();
      String year = today.year.toString();
      String monthCde = getCurrentMonthCode(today.month);
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
      String monthCde = getCurrentMonthCode(today.month);
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
        ///eg: weekcode: 202105 -> delete all tickets older than 202103
        int weekCde = _getWeekCode();
        weekCde--;
        return await _api.deleteUserTicketsBeforeWeekCode(userId, weekCde);
      } else {
        return false;
      }
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
      dMap['user_id'] = userId;
      dMap['fail_type'] = failType.value();
      dMap['manually_resolved'] = false;
      dMap['timestamp'] = Timestamp.now();
      await _api.addFailedReportDocument(dMap);
      return true;
    } catch (e) {
      log.error(e.toString());
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

  Future<UserFundWallet> updateUserAugmontGoldBalance(
      String id,
      UserFundWallet originalWalletBalance,
      double changeAmount,
      double totalQuantity) async {
    ///make a copy of the wallet object
    UserFundWallet newWalletBalance;
    if (originalWalletBalance == null) {
      newWalletBalance = UserFundWallet.newWallet();
    } else {
      newWalletBalance =
          UserFundWallet.fromMap(originalWalletBalance.cloneMap());
    }

    ///first update augmont balance
    if (changeAmount < 0 &&
        (newWalletBalance.augGoldBalance + changeAmount) < 0) {
      log.error(
          'Augmont Balance: Attempted to subtract amount more than available balance');
      return originalWalletBalance;
    } else {
      newWalletBalance.augGoldBalance = BaseUtil.digitPrecision(
          newWalletBalance.augGoldBalance + changeAmount);
      newWalletBalance.augGoldPrinciple = BaseUtil.digitPrecision(
          newWalletBalance.augGoldPrinciple + changeAmount);
      newWalletBalance.augGoldQuantity =
          totalQuantity; //precision already added
    }
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

  Future<UserTicketWallet> getUserTicketWallet(String id) async {
    try {
      var doc = await _api.getUserTicketWalletDocById(id);
      return UserTicketWallet.fromMap(doc.data());
    } catch (e) {
      log.error("Error fetch UserTicketWallet failed: $e");
      return null;
    }
  }

  Future<UserTicketWallet> updateInitUserTicketCount(String uid,
      UserTicketWallet userTicketWallet, int count) async {
    if(userTicketWallet == null) return null;
    int currentValue = userTicketWallet.initTck??0;
    try {
      return await _lock.synchronized(() async {
        if(count < 0 && currentValue < count) {
          userTicketWallet.initTck = 0;
        }else{
          userTicketWallet.initTck = currentValue + count;
        }
        Map<String, dynamic> tMap = {
          UserTicketWallet.fldInitTckCount: userTicketWallet.initTck
        };
        bool flag = await _api.updateUserTicketWalletFields(uid, UserTicketWallet.fldInitTckCount, currentValue, tMap);
        if(!flag){
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

  Future<UserTicketWallet> updateAugmontGoldUserTicketCount(String uid,
      UserTicketWallet userTicketWallet, int count) async {
    if(userTicketWallet == null) return null;
    int currentValue = userTicketWallet.augGold99Tck??0;
    try {
      return await _lock.synchronized(() async {
        if(count < 0 && currentValue < count) {
          userTicketWallet.augGold99Tck = 0;
        }else{
          userTicketWallet.augGold99Tck = currentValue + count;
        }
        Map<String, dynamic> tMap = {
          UserTicketWallet.fldAugmontGoldTckCount: userTicketWallet.augGold99Tck
        };
        bool flag = await _api.updateUserTicketWalletFields(uid, UserTicketWallet.fldAugmontGoldTckCount, currentValue, tMap);
        if(!flag){
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

  Future<UserTicketWallet> updateICICIUserTicketCount(String uid,
      UserTicketWallet userTicketWallet, int count) async {
    if(userTicketWallet == null) return null;
    int currentValue = userTicketWallet.icici1565Tck??0;
    try {
      return await _lock.synchronized(() async {
        if(count < 0 && currentValue < count) {
          userTicketWallet.icici1565Tck = 0;
        }else{
          userTicketWallet.icici1565Tck = currentValue + count;
        }
        Map<String, dynamic> tMap = {
          UserTicketWallet.fldICICI1565TckCount: userTicketWallet.icici1565Tck
        };
        bool flag = await _api.updateUserTicketWalletFields(uid, UserTicketWallet.fldICICI1565TckCount, currentValue, tMap);
        if(!flag){
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

  int _getWeekCode() {
    DateTime td = DateTime.now();
    Timestamp today = Timestamp.fromDate(td);
    DateTime date = new DateTime.now();

    return date.year * 100 + BaseUtil.getWeekNumber();
  }

  String getCurrentMonthCode(int month) {
    switch (month) {
      case 1:
        return "JAN";
      case 2:
        return "FEB";
      case 3:
        return "MAR";
      case 4:
        return "APR";
      case 5:
        return "MAY";
      case 6:
        return "JUN";
      case 7:
        return "JUL";
      case 8:
        return "AUG";
      case 9:
        return "SEP";
      case 10:
        return "OCT";
      case 11:
        return "NOV";
      case 12:
        return "DEC";
    }
  }

  addUserTicketListener(ValueChanged<List<TambolaBoard>> listener) {
    userTicketsUpdated = listener;
  }
}
