import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/model/DailyPick.dart';
import 'package:felloapp/core/model/TambolaBoard.dart';
import 'package:felloapp/core/model/User.dart';
import 'package:felloapp/core/service/api.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/logger.dart';
import 'package:flutter/material.dart';

class DBModel extends ChangeNotifier {
  Api _api = locator<Api>();
  ValueChanged<List<TambolaBoard>> userTicketsUpdated;
  VoidCallback userTicketsRequested;
  final Log log = new Log("DBModel");

  Future<bool> updateClientToken(User user, String token) async {
    try {
      //String id = user.mobile;
      String id = user.uid;
      var dMap = {'token': token, 'timestamp': FieldValue.serverTimestamp()};
      await _api.updateUserClientToken(id, dMap);
      return true;
    } catch (e) {
      log.error("Failed to update User Client Token: " + e.toString());
      return false;
    }
  }

  Future<User> getUser(String id) async {
    try {
      var doc = await _api.getUserById(id);
      return User.fromMap(doc.data, id);
    } catch (e) {
      log.error("Error fetch User details: " + e.toString());
      return null;
    }
  }

  Future<bool> updateUser(User user) async {
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

  // Future<bool> setTicketGenerationInProgress(User user) async{
  //   try {
  //     Map x =  await _api.setTicketGenInProcess(user.uid);
  //     return x['flag'];
  //   }catch(e) {
  //     return false;
  //   }
  // }

  Future<bool> pushTicketRequest(User user, int count) async {
    try {
      String _uid = user.uid;
      var rMap = {
        'user_id': _uid,
        'manual': false,
        'count': count,
        'week_code': _getWeekCode(),
        'timestamp': FieldValue.serverTimestamp()
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

  bool subscribeUserTickets(User user){
    try{
      String _id = user.uid;
      Stream<QuerySnapshot> _stream = _api.getValidUserTickets(_id, _getWeekCode());
      _stream.listen((querySnapshot) {
        List<TambolaBoard> requestedBoards = [];
        querySnapshot.documents.forEach((docSnapshot) {
          if(docSnapshot.exists)
            log.debug('Received snapshot: ' + docSnapshot.data.toString());
          TambolaBoard board = TambolaBoard.fromMap(docSnapshot.data);
          if(board.isValid())requestedBoards.add(board);
        });
        log.debug('Post stream update-> sending ticket count to dashboard: ${requestedBoards.length}');
        if(userTicketsUpdated != null)userTicketsUpdated(requestedBoards);
      });
    }catch(err) {
      log.error('Failed to fetch tambola boards');
      return false;
    }
    return true;
  }

  Future<DailyPick> getWeeklyPicks() async {
    try {
      DateTime date = new DateTime.now();
      int weekCde = date.year*100 + BaseUtil.getWeekNumber();
      QuerySnapshot querySnapshot = await _api.getWeekPickByCde(weekCde);

      if(querySnapshot.documents.length != 1){
        log.error('Did not receive a single doc. Error staged');
        return null;
      }
      else{
        return DailyPick.fromMap(querySnapshot.documents[0].data);
      }
    } catch (e) {
      log.error("Error fetch Dailypick details: " + e.toString());
      return null;
    }
  }

  Future<Map<String, dynamic>> getWeeklyWinners() async {
    try {
      DateTime date = new DateTime.now();
      int weekCde = date.year*100 + BaseUtil.getWeekNumber();

      QuerySnapshot querySnapshot = await _api.getWinnersByWeekCde(weekCde);
      if(querySnapshot != null && querySnapshot.documents.length == 1){
        DocumentSnapshot snapshot = querySnapshot.documents[0];
        if(snapshot.exists && snapshot.data['winners'] != null) {
          Map<String, dynamic> rMap = snapshot.data['winners'];
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

  Future<bool> addCallbackRequest(String uid, String mobile) async{
    try{
      DateTime today = DateTime.now();
      String year = today.year.toString();
      String monthCde = getCurrentMonthCode(today.month);
      int date = today.day;
      Map<String, dynamic> data = {};
      data['date'] = date;
      data['user_id'] = uid;
      data['mobile'] = mobile;
      data['timestamp'] = FieldValue.serverTimestamp();

      await _api.addCallbackDocument(year, monthCde, data);
      return true;
    }catch (e) {
      log.error("Error adding callback doc: " + e.toString());
      return false;
    }
  }

  Future<bool> addWinClaim(String uid, Map<String, int> resMap) async{
    try{
      DateTime date = new DateTime.now();
      int weekCde = date.year*100 + BaseUtil.getWeekNumber();

      Map<String, dynamic> data = {};
      data['user_id'] = uid;
      data['week_code'] = weekCde;
      data['ticket_cat_map'] = resMap;
      data['timestamp'] = FieldValue.serverTimestamp();

      await _api.addClaimDocument(data);
      return true;
    }catch (e) {
      log.error("Error adding callback doc: " + e.toString());
      return false;
    }
  }

  Future<int> getReferCount(String uid) async {
    try {
      var docs = await _api.getReferedDocs(uid);
      if(docs != null && docs.documents != null && docs.documents.length > 0) return docs.documents.length;
    } catch (e) {
      log.error("Error fetch referrals details: " + e.toString());
    }
    return 0;
  }

  Future<bool> addFundDeposit(String uid, String amount, String rawResponse, String status) async{
    try{
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
      data['timestamp'] = FieldValue.serverTimestamp();

      await _api.addDepositDocument(year, monthCde, data);
      return true;
    }catch (e) {
      log.error("Error adding callback doc: " + e.toString());
      return false;
    }
  }

  Future<bool> addFundWithdrawal(String uid, String amount) async{
    try{
      DateTime today = DateTime.now();
      String year = today.year.toString();
      String monthCde = getCurrentMonthCode(today.month);
      int date = today.day;
      Map<String, dynamic> data = {};
      data['date'] = date;
      data['user_id'] = uid;
      data['amount'] = amount;
      data['timestamp'] = FieldValue.serverTimestamp();

      await _api.addWithdrawalDocument(year, monthCde, data);
      return true;
    }catch (e) {
      log.error("Error adding callback doc: " + e.toString());
      return false;
    }
  }

  int _getWeekCode() {
    DateTime td = DateTime.now();
    Timestamp today = Timestamp.fromDate(td);
    DateTime date = new DateTime.now();

    return date.year*100 + BaseUtil.getWeekNumber();
  }

  String getCurrentMonthCode(int month) {
    switch(month) {
      case 1: return "JAN";
      case 2: return "FEB";
      case 3: return "MAR";
      case 4: return "APR";
      case 5: return "MAY";
      case 6: return "JUN";
      case 7: return "JUL";
      case 8: return "AUG";
      case 9: return "SEP";
      case 10: return "OCT";
      case 11: return "NOV";
      case 12: return "DEC";
    }
  }

  addUserTicketListener(ValueChanged<List<TambolaBoard>> listener) {
    userTicketsUpdated = listener;
  }

  addUserTicketRequestListener(VoidCallback listener) {
    userTicketsRequested = listener;
  }
}
