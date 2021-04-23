import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:felloapp/core/model/DailyPick.dart';
import 'package:felloapp/core/model/TambolaBoard.dart';
import 'package:felloapp/core/model/UserTransaction.dart';
import 'package:felloapp/util/constants.dart';
import 'package:felloapp/util/logger.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class Api {
  Log log = new Log("Api");
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  String path;
  CollectionReference ref;

  Api();

  Future<void> updateUserClientToken(String userId, Map data) {
    ref = _db
        .collection(Constants.COLN_USERS)
        .doc(userId)
        .collection(Constants.SUBCOLN_USER_FCM);
    return ref.doc(Constants.DOC_USER_FCM_TOKEN).set(data);
  }

  Future<DocumentSnapshot> getUserById(String id) {
    ref = _db.collection(Constants.COLN_USERS);
    return ref.doc(id).get();
  }

  Future<void> updateUserDocument(String docId, Map data) {
    ref = _db.collection(Constants.COLN_USERS);
    return ref.doc(docId).set(data, SetOptions(merge: true));
  }

  Future<DocumentSnapshot> getUserIciciDetailDocument(String userId) {
    ref = _db
        .collection(Constants.COLN_USERS)
        .doc(userId)
        .collection(Constants.SUBCOLN_USER_ICICI_DETAILS);
    return ref.doc(Constants.DOC_USER_ICICI_DETAIL).get();
  }

  Future<void> updateUserIciciDetailDocument(String userId, Map data) {
    ref = _db
        .collection(Constants.COLN_USERS)
        .doc(userId)
        .collection(Constants.SUBCOLN_USER_ICICI_DETAILS);
    return ref
        .doc(Constants.DOC_USER_ICICI_DETAIL)
        .set(data, SetOptions(merge: true));
  }

  Future<DocumentSnapshot> getUserAugmontDetailDocument(String userId) {
    ref = _db
        .collection(Constants.COLN_USERS)
        .doc(userId)
        .collection(Constants.SUBCOLN_USER_AUGMONT_DETAILS);
    return ref.doc(Constants.DOC_USER_AUGMONT_DETAIL).get();
  }

  Future<void> updateUserAugmontDetailDocument(String userId, Map data) {
    ref = _db
        .collection(Constants.COLN_USERS)
        .doc(userId)
        .collection(Constants.SUBCOLN_USER_AUGMONT_DETAILS);
    return ref
        .doc(Constants.DOC_USER_AUGMONT_DETAIL)
        .set(data, SetOptions(merge: true));
  }

  Future<DocumentSnapshot> getUserKycDetailDocument(String userId) {
    ref = _db
        .collection(Constants.COLN_USERS)
        .doc(userId)
        .collection(Constants.SUBCOLN_USER_KYC_DETAILS);
    return ref.doc(Constants.DOC_USER_KYC_DETAIL).get();
  }

  Future<void> updateUserKycDetailDocument(String userId, Map data) {
    ref = _db
        .collection(Constants.COLN_USERS)
        .doc(userId)
        .collection(Constants.SUBCOLN_USER_KYC_DETAILS);
    return ref
        .doc(Constants.DOC_USER_KYC_DETAIL)
        .set(data, SetOptions(merge: true));
  }

  Future<DocumentReference> addUserTransactionDocument(
      String userId, Map data) {
    ref = _db
        .collection(Constants.COLN_USERS)
        .doc(userId)
        .collection(Constants.SUBCOLN_USER_TXNS);
    return ref.add(data);
  }

  Future<DocumentSnapshot> getUserTransactionDocument(
      String userId, String txnId) {
    ref = _db
        .collection(Constants.COLN_USERS)
        .doc(userId)
        .collection(Constants.SUBCOLN_USER_TXNS);
    return ref.doc(txnId).get();
  }

  Future<void> updateUserTransactionDocument(
      String userId, String txnId, Map data) {
    ref = _db
        .collection(Constants.COLN_USERS)
        .doc(userId)
        .collection(Constants.SUBCOLN_USER_TXNS);
    return ref.doc(txnId).set(data, SetOptions(merge: true));
  }

  Future<DocumentReference> createTicketRequest(String userId, Map data) {
    return _db.collection(Constants.COLN_TICKETREQUEST).add(data);
  }

  Stream<DocumentSnapshot> getticketRequestDocumentEvent(String docId) {
    return _db.collection(Constants.COLN_TICKETREQUEST).doc(docId).snapshots();
  }

  Future<QuerySnapshot> getValidUserTickets(String user_id, int weekCode) {
    Query query = _db
        .collection(Constants.COLN_USERS)
        .doc(user_id)
        .collection(Constants.SUBCOLN_USER_TICKETS);
    query = query.where(TambolaBoard.fldWeekCode, isEqualTo: weekCode);

    //return query.snapshots();
    return query.get();
  }

  Future<QuerySnapshot> getWeekPickByCde(int weekCde) {
    Query query = _db
        .collection(Constants.COLN_DAILYPICKS)
        .where(DailyPick.fldWeekCode, isEqualTo: weekCde);

    return query.get();
  }

  Future<void> addFeedbackDocument(Map data) {
    return _db.collection(Constants.COLN_FEEDBACK).add(data);
  }

  Future<void> addFailedReportDocument(Map data) {
    return _db.collection(Constants.COLN_FAILREPORTS).add(data);
  }

  Future<QuerySnapshot> getWinnersByWeekCde(int weekCde) async {
    Query query = _db
        .collection(Constants.COLN_WINNERS)
        .where('week_code', isEqualTo: weekCde);
    final response = await query.get();
    return response;
  }

  Future<QuerySnapshot> getCredentialsByTypeAndStage(
      String type, String stage, int index) {
    Query query = _db
        .collection(Constants.COLN_CREDENTIALS)
        .where('type', isEqualTo: type)
        .where('stage', isEqualTo: stage)
        .where('index', isEqualTo: index);

    return query.get();
  }

  Future<QuerySnapshot> getUserTransactionsByField(
      String user_id, String type, String subtype, int limit) {
    Query query = _db
        .collection(Constants.COLN_USERS)
        .doc(user_id)
        .collection(Constants.SUBCOLN_USER_TXNS);
    if (type != null)
      query = query.where(UserTransaction.fldType, isEqualTo: type);
    if (subtype != null)
      query = query.where(UserTransaction.fldSubType, isEqualTo: subtype);
    if (limit != -1 && limit > 10) query = query.limit(limit);
    query = query.orderBy(UserTransaction.fldTimestamp, descending: true);

    return query.get();
  }

  Future<void> addCallbackDocument(String year, String monthCde, Map data) {
    return _db
        .collection('callbacks')
        .doc(year)
        .collection(monthCde)
        .doc()
        .set(data, SetOptions(merge: false));
  }

  Future<void> addDepositDocument(String year, String monthCde, Map data) {
    return _db
        .collection('deposits')
        .doc(year)
        .collection(monthCde)
        .doc()
        .set(data, SetOptions(merge: false));
  }

  Future<void> addWithdrawalDocument(String year, String monthCde, Map data) {
    return _db
        .collection('withdrawals')
        .doc(year)
        .collection(monthCde)
        .doc()
        .set(data, SetOptions(merge: false));
  }

  Future<void> addClaimDocument(Map data) {
    return _db.collection('claims').doc().set(data, SetOptions(merge: false));
  }

  Future<QuerySnapshot> getReferedDocs(String id) {
    ref = _db.collection(Constants.COLN_REFERRALS);
    return ref.where('ref_by', isEqualTo: id).get();
  }

  Future<DocumentSnapshot> getPollDocument(String id) {
    ref = _db.collection(Constants.COLN_POLLS);
    return ref.doc(id).get();
  }

  Future<dynamic> incrementPollDocument(String id, String field) {
    ref = _db.collection(Constants.COLN_POLLS);
    Map<String, dynamic> upObj = {};
    upObj[field] = FieldValue.increment(1);

    return ref.doc(id).update(upObj);
  }

  Future<void> addUserPollResponseDocument(String id, String pollId, Map data) {
    ref = _db
        .collection(Constants.COLN_USERS)
        .doc(id)
        .collection(Constants.SUBCOLN_USER_POLL_RESPONSES);
    return ref.doc(pollId).set(data, SetOptions(merge: false));
  }

  Future<DocumentSnapshot> getUserPollResponseDocument(
      String id, String pollId) {
    ref = _db
        .collection(Constants.COLN_USERS)
        .doc(id)
        .collection(Constants.SUBCOLN_USER_POLL_RESPONSES);
    return ref.doc(pollId).get();
  }

  Future<DocumentSnapshot> getUserFundWalletDocById(String id) {
    ref = _db
        .collection(Constants.COLN_USERS)
        .doc(id)
        .collection(Constants.SUBCOLN_USER_WALLET);
    return ref.doc(Constants.DOC_USER_WALLET_FUND_BALANCE).get();
  }

  Future<bool> updateUserFundWalletFields(
      String userId, String verifyFld, double verifyValue, Map data) {
    DocumentReference _docRef = _db
        .collection(Constants.COLN_USERS)
        .doc(userId)
        .collection(Constants.SUBCOLN_USER_WALLET)
        .doc(Constants.DOC_USER_WALLET_FUND_BALANCE);
    return _db
        .runTransaction((transaction) async {
          DocumentSnapshot snapshot = await transaction.get(_docRef);
          if (!snapshot.exists) {
            //wallet didnt exist?
            transaction.set(_docRef, data, SetOptions(merge: true));
          } else {
            Map<String, dynamic> _map = snapshot.data();
            if (_map[verifyFld] == null) {
              ///field doesnt exist. add the field
              transaction.set(_docRef, data, SetOptions(merge: true));
            } else if (_map[verifyFld] != null &&
                _map[verifyFld] == verifyValue) {
              ///field exists and the condition is satisfied
              transaction.set(_docRef, data, SetOptions(merge: true));
            } else {
              ///field exists but there is a data discrepancy
              throw Exception('Condition not satisfied');
            }
          }
        })
        .then((value) => true)
        .catchError((onErr) => false);
  }

  Future<QuerySnapshot> getRecentAugmontDepositTxn(
      String userId, Timestamp cmpTimestamp) {
    Query _query = _db
        .collection(Constants.COLN_USERS)
        .doc(userId)
        .collection(Constants.SUBCOLN_USER_TXNS);
    _query.where(UserTransaction.fldSubType,
        isEqualTo: UserTransaction.TRAN_SUBTYPE_AUGMONT_GOLD)
        .where(UserTransaction.fldTimestamp,
            isGreaterThanOrEqualTo: cmpTimestamp);

    return _query.get();
  }

  Future<DocumentSnapshot> getUserTicketWalletDocById(String id) {
    ref = _db
        .collection(Constants.COLN_USERS)
        .doc(id)
        .collection(Constants.SUBCOLN_USER_WALLET);
    return ref.doc(Constants.DOC_USER_WALLET_TICKET_BALANCE).get();
  }

  Future<bool> updateUserTicketWalletFields(
      String userId, String verifyFld, int verifyValue, Map data) {
    DocumentReference _docRef = _db
        .collection(Constants.COLN_USERS)
        .doc(userId)
        .collection(Constants.SUBCOLN_USER_WALLET)
        .doc(Constants.DOC_USER_WALLET_TICKET_BALANCE);
    return _db
        .runTransaction((transaction) async {
          DocumentSnapshot snapshot = await transaction.get(_docRef);
          if (!snapshot.exists) {
            //wallet didnt exist?
            transaction.set(_docRef, data, SetOptions(merge: true));
          } else {
            Map<String, dynamic> _map = snapshot.data();
            if (_map[verifyFld] == null) {
              ///field doesnt exist. add the field
              transaction.set(_docRef, data, SetOptions(merge: true));
            } else if (_map[verifyFld] != null &&
                _map[verifyFld] == verifyValue) {
              ///field exists and the condition is satisfied
              transaction.set(_docRef, data, SetOptions(merge: true));
            } else {
              ///field exists but there is a data discrepancy
              throw Exception('Condition not satisfied');
            }
          }
        })
        .then((value) => true)
        .catchError((onErr) => false);
  }

  //sets the 'gGEN_COUNT_LEFT' field in the user ticket wallet object
  Future<bool> setUserTicketWalletGenerationField(
      String userId, String actionFld, int count) {
    DocumentReference _docRef = _db
        .collection(Constants.COLN_USERS)
        .doc(userId)
        .collection(Constants.SUBCOLN_USER_WALLET)
        .doc(Constants.DOC_USER_WALLET_TICKET_BALANCE);
    return _db
        .runTransaction((transaction) async {
          DocumentSnapshot snapshot = await transaction.get(_docRef);
          if (!snapshot.exists) {
            return false;
          } else {
            Map<String, dynamic> _map = snapshot.data();
            if (_map[actionFld] != null && _map[actionFld] > 0) {
              ///generation field already presesnt
              throw Exception('Field already present');
            } else {
              transaction.update(_docRef, {'$actionFld': count});
            }
          }
        })
        .then((value) => true)
        .catchError((onErr) => false);
  }

  Future<QuerySnapshot> getLeaderboardDocument(String category, int weekCde) {
    Query _query = _db
        .collection(Constants.COLN_LEADERBOARD)
        .where('category', isEqualTo: category)
        .where('week_code', isEqualTo: weekCde);
    return _query.get();
  }

  Future<QuerySnapshot> getHomeCardCollection() {
    Query _query = _db.collection(Constants.COLN_HOMECARDS).orderBy('id');
    return _query.get();
  }

  Future<String> getFileFromDPBucketURL(String uid, String path) {
    return _storage.ref('dps/$uid/$path').getDownloadURL();
  }

  Future<bool> deleteUserTicketsBeforeWeekCode(String uid, int weekCde) async {
    bool flag = true;
    Query _query = _db
        .collection(Constants.COLN_USERS)
        .doc(uid)
        .collection(Constants.SUBCOLN_USER_TICKETS)
        .where('week_code', isLessThan: weekCde);
    List<DocumentReference> _docReferences = [];
    try {
      QuerySnapshot _querySnapshot = await _query.get();
      _querySnapshot.docs.forEach((dDoc) {
        if (dDoc.exists) _docReferences.add(dDoc.reference);
      });
    } catch (e) {
      log.error('Failed to retrieve ticket documents: $e');
      flag = false;
    }

    if (_docReferences.length > 0) {
      try {
        var opBatch = _db.batch();
        for (var ref in _docReferences) {
          opBatch.delete(ref);
        }
        log.debug(
            'Deleting ${_docReferences.length.toString()} ticket documents');

        await opBatch.commit();
      } catch (e) {
        log.error('DB Batch operation failed: $e');
        flag = false;
      }
    }
    return flag;
  }

  Future<bool> deleteUserTicketDocuments(
      String uid, List<String> references) async {
    if (references.length > 0) {
      CollectionReference colnReference = _db
          .collection(Constants.COLN_USERS)
          .doc(uid)
          .collection(Constants.SUBCOLN_USER_TICKETS);
      try {
        var opBatch = _db.batch();
        for (String ref in references) {
          opBatch.delete(colnReference.doc(ref));
        }
        log.debug('Deleting ${references.length.toString()} ticket documents');

        await opBatch.commit();
        return true;
      } catch (e) {
        log.error('DB Batch operation failed: $e');
        return false;
      }
    } else {
      return false;
    }
  }
}
