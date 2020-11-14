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

  Future<void> createTicketRequest(Map data) {
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

  Future<void> addCallbackDocument(String year, String monthCde, Map data) {
    return _db.collection('callbacks').document(year).collection(monthCde).document().setData(data, merge:false);
  }
}