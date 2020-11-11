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

  Future<bool> pushTicketRequest(User user, int count) async {
    try {
      String _uid = user.uid;
      var rMap = {
        'user_id': _uid,
        'manual': true,
        'count': count,
        'week_code': _getWeekCode(),
        'timestamp': FieldValue.serverTimestamp()
      };
      await _api.createTicketRequest(rMap);
      return true;
    } catch (e) {
      log.error('Failed to push new request: ' + e.toString());
      return false;
    }
  }

  Future<List<TambolaBoard>> refreshUserTickets(User user) async{
    List<TambolaBoard> requestedBoards = [];
    try{
      String _id = user.uid;
      QuerySnapshot querySnapshot = await _api.getValidUserTickets(_id, _getWeekCode());
      if(querySnapshot != null && querySnapshot.documents.length > 0) {
        querySnapshot.documents.forEach((docSnapshot) {
          if(docSnapshot.exists)
          log.debug('Received snapshot: ' + docSnapshot.data.toString());
          TambolaBoard board = TambolaBoard.fromMap(docSnapshot.data);
          if(board.isValid())requestedBoards.add(board);
        });
      }
    }catch(err) {
      log.error('Failed to fetch tambola boards');
    }
    return requestedBoards;
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

  int _getWeekCode() {
    DateTime td = DateTime.now();
    Timestamp today = Timestamp.fromDate(td);
    DateTime date = new DateTime.now();

    return date.year*100 + BaseUtil.getWeekNumber();
  }
}
