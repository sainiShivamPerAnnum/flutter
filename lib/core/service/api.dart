import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:felloapp/core/model/DailyPick.dart';
import 'package:felloapp/core/model/TambolaBoard.dart';
import 'package:felloapp/util/constants.dart';
import 'package:felloapp/util/logger.dart';
import 'package:flutter/cupertino.dart';

class Api {
  Log log = new Log("Api");
  final Firestore _db = Firestore.instance;
  String path;
  CollectionReference ref;

  Api();

  Future<void> updateUserClientToken(String userId, Map data) {
    ref = _db.collection(Constants.COLN_USERS).document(userId).collection(Constants.SUBCOLN_USER_FCM);
    return ref.document(Constants.DOC_USER_FCM_TOKEN).setData(data);
  }

  Future<DocumentSnapshot> getUserById(String id) {
    ref = _db.collection(Constants.COLN_USERS);
    return ref.document(id).get();
  }

  Future<void> updateUserDocument(String docId, Map data) {
    ref = _db.collection(Constants.COLN_USERS);
    return ref.document(docId).setData(data, merge: true);
  }

  // Future<Map<String, dynamic>> setTicketGenInProcess(String userId) {
  //   return _db.runTransaction((transaction){
  //     Map<String, dynamic> tMap = {};
  //     var _ref = _db.collection(Constants.COLN_USERS).document(userId);
  //     return transaction.get(_ref).then((value) {
  //       var doc = value;
  //       if(doc != null && doc.exists) {
  //         Map dt = doc.data;
  //         if(dt['tg_in_progress'] != null && dt['tg_in_progress']){
  //           tMap['flag'] = false;
  //           return Promise.resolve(true);
  //           return tMap;
  //         }
  //         else {
  //           Map<String, dynamic> dx = {};
  //           dx['tg_in_progress'] = true;
  //           transaction.update(_ref, dx).then((valuex) {
  //             tMap['flag'] = true;
  //             return tMap;
  //           });
  //         }
  //       }
  //     });
  //   });
  // }

  Future<void> createTicketRequest(String userId, Map data) {
    return _db.collection(Constants.COLN_TICKETREQUEST).document().setData(data, merge: false);
  }

  Stream<QuerySnapshot> getValidUserTickets(String user_id, int weekCode) {
    Query query = _db.collection(Constants.COLN_USERS).document(user_id).collection(Constants.SUBCOLN_USER_TICKETS);
    query = query.where(TambolaBoard.fldWeekCode, isEqualTo: weekCode);

    return query.snapshots();
    //return query.getDocuments();
  }

  Future<QuerySnapshot> getWeekPickByCde(int weekCde) {
    Query query = _db.collection(Constants.COLN_DAILYPICKS).where(DailyPick.fldWeekCode, isEqualTo: weekCde);

    return query.getDocuments();
  }

  Future<void> addFeedbackDocument(Map data) {
    return _db.collection(Constants.COLN_FEEDBACK).add(data);
  }

  Future<QuerySnapshot> getWinnersByWeekCde(int weekCde) {
    Query query = _db.collection(Constants.COLN_WINNERS).where('week_code', isEqualTo: weekCde);

    return query.getDocuments();
  }

  Future<void> addCallbackDocument(String year, String monthCde, Map data) {
    return _db.collection('callbacks').document(year).collection(monthCde).document().setData(data, merge:false);
  }

  Future<void> addDepositDocument(String year, String monthCde, Map data) {
    return _db.collection('deposits').document(year).collection(monthCde).document().setData(data, merge:false);
  }

  Future<void> addWithdrawalDocument(String year, String monthCde, Map data) {
    return _db.collection('withdrawals').document(year).collection(monthCde).document().setData(data, merge:false);
  }

  Future<void> addClaimDocument(Map data) {
    return _db.collection('claims').document().setData(data, merge: false);
  }

  Future<QuerySnapshot> getReferedDocs(String id) {
    ref = _db.collection(Constants.COLN_REFERRALS);
    return ref.where('ref_by', isEqualTo: id).getDocuments();
  }
}