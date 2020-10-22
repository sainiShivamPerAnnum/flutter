import 'package:cloud_firestore/cloud_firestore.dart';
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

  Stream<QuerySnapshot> getValidUserTickets(String user_id, Timestamp timestamp) {
    Query query = _db.collection(Constants.COLN_USERS).document(user_id).collection(Constants.SUBCOLN_USER_TICKETS);
    query = query.where(TambolaBoard.fldValidityStart, isLessThanOrEqualTo: timestamp).where(TambolaBoard.fldValidityEnd, isGreaterThanOrEqualTo: timestamp);

    return query.snapshots();
  }
}