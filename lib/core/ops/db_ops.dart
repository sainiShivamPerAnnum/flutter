import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/model/DailyPick.dart';
import 'package:felloapp/core/model/TambolaBoard.dart';
import 'package:felloapp/core/model/BaseUser.dart';
import 'package:felloapp/core/model/UserIciciDetail.dart';
import 'package:felloapp/core/model/UserKycDetail.dart';
import 'package:felloapp/core/model/UserTransaction.dart';
import 'package:felloapp/core/service/api.dart';
import 'package:felloapp/util/credentials_stage.dart';
import 'package:felloapp/util/fail_types.dart';
import 'package:felloapp/util/help_types.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/logger.dart';
import 'package:flutter/material.dart';

class DBModel extends ChangeNotifier {
  Api _api = locator<Api>();
  ValueChanged<List<TambolaBoard>> userTicketsUpdated;
  VoidCallback userTicketsRequested;
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

  // Future<bool> setTicketGenerationInProgress(User user) async{
  //   try {
  //     Map x =  await _api.setTicketGenInProcess(user.uid);
  //     return x['flag'];
  //   }catch(e) {
  //     return false;
  //   }
  // }

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

  //
  // Future<List<TambolaBoard>> refreshUserTickets(User user) async{
  //   List<TambolaBoard> requestedBoards = [];
  //   try{
  //     String _id = user.uid;
  //     QuerySnapshot querySnapshot = await _api.getValidUserTickets(_id, _getWeekCode());
  //     if(querySnapshot != null && querySnapshot.documents.length > 0) {
  //       querySnapshot.documents.forEach((docSnapshot) {
  //         if(docSnapshot.exists)
  //         log.debug('Received snapshot: ' + docSnapshot.data.toString());
  //         TambolaBoard board = TambolaBoard.fromMap(docSnapshot.data);
  //         if(board.isValid())requestedBoards.add(board);
  //       });
  //     }
  //   }catch(err) {
  //     log.error('Failed to fetch tambola boards');
  //   }
  //   return requestedBoards;
  // }

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
      DateTime date = new DateTime.now();
      int weekCde = date.year * 100 + BaseUtil.getWeekNumber();

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

  Future<Map<String, String>> getActiveAwsApiKey() async {
    String awsKeyIndex = BaseUtil.remoteConfig.getString('aws_key_index');
    if (awsKeyIndex == null || awsKeyIndex.isEmpty) awsKeyIndex = '3';
    int keyIndex = 3;
    try {
      keyIndex = int.parse(awsKeyIndex);
    } catch (e) {
      log.error('Aws Index key parsing failed: ' + e.toString());
      keyIndex = 3;
    }
    QuerySnapshot querySnapshot = await _api.getCredentialsByTypeAndStage(
        'aws', BaseUtil.activeAwsStage.value(), keyIndex);
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

  addUserTicketRequestListener(VoidCallback listener) {
    userTicketsRequested = listener;
  }
}
