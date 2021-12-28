import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:felloapp/core/model/daily_pick_model.dart';
import 'package:felloapp/core/model/referral_details_model.dart';
import 'package:felloapp/core/model/tambola_board_model.dart';
import 'package:felloapp/core/model/user_transaction_model.dart';
import 'package:felloapp/util/constants.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/logger.dart';
import 'package:firebase_database/firebase_database.dart' as rdb;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:logger/logger.dart';

class Api {
  Log log = new Log("Api");

  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final rdb.FirebaseDatabase _realtimeDatabase = rdb.FirebaseDatabase.instance;

  final logger = locator<Logger>();

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

  Future<void> deleteUserClientToken(String userId) {
    ref = _db
        .collection(Constants.COLN_USERS)
        .doc(userId)
        .collection(Constants.SUBCOLN_USER_FCM);
    return ref.doc(Constants.DOC_USER_FCM_TOKEN).delete();
  }

  Future<void> addKycName(String userId, Map<String, dynamic> data) {
    final documentRef = _db.collection(Constants.COLN_USERS).doc(userId);
    return documentRef.update(data);
  }

  Future<QuerySnapshot> checkForLatestNotification(String userId) {
    Future<QuerySnapshot> snapshot;
    Query query = _db
        .collection(Constants.COLN_USERS)
        .doc(userId)
        .collection(Constants.SUBCOLN_USER_ALERTS);
    try {
      snapshot = query.orderBy('created_time', descending: true).limit(1).get();
    } catch (e) {
      logger.e(e);
    }
    return snapshot;
  }

  Future<QuerySnapshot> getUserNotifications(
      String userId, DocumentSnapshot lastDoc) async {
    Future<QuerySnapshot> snapshot;
    Query query = _db
        .collection(Constants.COLN_USERS)
        .doc(userId)
        .collection(Constants.SUBCOLN_USER_ALERTS);
    try {
      if (lastDoc != null)
        snapshot = query
            .orderBy('created_time', descending: true)
            .startAfterDocument(lastDoc)
            .limit(10)
            .get();
      else
        snapshot =
            query.orderBy('created_time', descending: true).limit(10).get();
    } catch (e) {
      logger.e(e);
    }
    return snapshot;
  }

  Future<QuerySnapshot> checkForLatestAnnouncment(String userId) {
    Future<QuerySnapshot> snapshot;
    ref = _db.collection(Constants.COLN_ANNOUNCEMENTS);
    try {
      snapshot = ref.orderBy('created_time', descending: true).limit(1).get();
    } catch (e) {
      logger.e(e);
    }
    return snapshot;
  }

  Future<QuerySnapshot> getAnnoucements() async {
    Future<QuerySnapshot> snapshot;
    ref = _db.collection(Constants.COLN_ANNOUNCEMENTS);
    try {
      snapshot = ref.orderBy('created_time').get();
    } catch (e) {
      logger.e(e);
    }
    return snapshot;
  }

  Future<DocumentSnapshot> getUserById(String id) {
    ref = _db.collection(Constants.COLN_USERS);
    return ref.doc(id).get();
  }

  Future<void> updateUserDocument(String docId, Map data) {
    ref = _db.collection(Constants.COLN_USERS);
    return ref.doc(docId).set(data, SetOptions(merge: true));
  }

  Future<void> updateUserDocumentPreferenceField(
      String docId, Map<String, dynamic> data) {
    ref = _db.collection(Constants.COLN_USERS);
    return ref.doc(docId).update(data);
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

  Future<DocumentSnapshot> getUserPrtdDocPan(String userId) {
    ref = _db
        .collection(Constants.COLN_USERS)
        .doc(userId)
        .collection(Constants.SUBCOLN_USER_PRTD);
    return ref.doc('pan').get();
  }

  Future<void> addUserPrtdDocPan(String userId, Map data) {
    ref = _db
        .collection(Constants.COLN_USERS)
        .doc(userId)
        .collection(Constants.SUBCOLN_USER_PRTD);
    return ref.doc('pan').set(data, SetOptions(merge: false));
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

  Future<QuerySnapshot> getUserPrizeTransactionDocuments(String userId) {
    final query = _db
        .collection(Constants.COLN_USERS)
        .doc(userId)
        .collection(Constants.SUBCOLN_USER_TXNS)
        .where('tType', isEqualTo: 'PRIZE');
    return query.get();
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

  //set the mentioned fields to true
  Future<bool> setReferralDocBonusField(String uid) async {
    DocumentReference _rRef = _db.collection(Constants.COLN_REFERRALS).doc(uid);
    return _db
        .runTransaction((transaction) async {
          DocumentSnapshot snapshot = await transaction.get(_rRef);
          Map<String, dynamic> snapData =
              (snapshot.exists) ? snapshot.data() : null;
          if (!snapshot.exists && snapData == null) {
            //did not sign up via referral
            throw Exception('No referral found');
          } else if (snapData[ReferralDetail.fldUsrBonusFlag] == null ||
              snapData[ReferralDetail.fldRefereeBonusFlag] == null) {
            throw Exception('Empty/invalid data');
          } else {
            bool _uFlag, _rFlag;
            try {
              _uFlag = snapData[ReferralDetail.fldUsrBonusFlag];
              _rFlag = snapData[ReferralDetail.fldRefereeBonusFlag];
            } catch (e) {
              throw Exception('Failed to create bool flags');
            }
            if (_uFlag == null || _rFlag == null) {
              throw Exception('Failed to create bool flags');
            }
            if (_uFlag == true && _rFlag == true) {
              //referral bonus already unlocked
              throw Exception('Referral bonus already unlocked');
            } else {
              Map<String, dynamic> rMap = {};
              rMap[ReferralDetail.fldUsrBonusFlag] = true;
              rMap[ReferralDetail.fldRefereeBonusFlag] = true;
              transaction.set(_rRef, rMap, SetOptions(merge: true));
              return true;
            }
          }
        })
        .then((value) => true)
        .catchError((onErr) => false);
  }

  Future<void> updateReferralDocument(String docId, Map data) {
    return _db
        .collection(Constants.COLN_REFERRALS)
        .doc(docId)
        .set(data, SetOptions(merge: true));
  }

  Future<void> addFeedbackDocument(Map data) {
    return _db.collection(Constants.COLN_FEEDBACK).add(data);
  }

  Future<void> addGameFailedReport(Map data) {
    return _db.collection('gamefailreports').add(data);
  }

  Future<void> addPriorityFailedReport(Map data) {
    return _db.collection('priorityfailreports').add(data);
  }

  Future<void> addFailedReportDocument(Map data) {
    return _db.collection(Constants.COLN_FAILREPORTS).add(data);
  }

  Future<QuerySnapshot> getWinnersByWeekCde(int weekCde) async {
    Query query = _db
        .collection(Constants.COLN_WINNERS)
        .where('week_code', isEqualTo: weekCde)
        .where('win_type', isEqualTo: 'tambola');
    final response = await query.get();
    return response;
  }

  Future updateWeeklyWinnerDocument(String docId, Map data) async {
    return _db.collection(Constants.COLN_WINNERS).doc(docId).update(data);
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

  Future<QuerySnapshot> getUserTransactionsByField({
    @required String userId,
    String type,
    String subtype,
    String status,
    DocumentSnapshot lastDocument,
    @required int limit,
  }) {
    Query query = _db
        .collection(Constants.COLN_USERS)
        .doc(userId)
        .collection(Constants.SUBCOLN_USER_TXNS);
    if (type != null)
      query = query.where(UserTransaction.fldType, isEqualTo: type);
    if (subtype != null)
      query = query.where(UserTransaction.fldSubType, isEqualTo: subtype);
    if (status != null)
      query = query.where(UserTransaction.fldTranStatus, isEqualTo: status);
    if (limit != -1 && limit > 3) query = query.limit(limit);
    query = query.orderBy(UserTransaction.fldTimestamp, descending: true);
    if (lastDocument != null) query = query.startAfterDocument(lastDocument);
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

  Future<QuerySnapshot> getReferralDocs(String id) {
    ref = _db.collection(Constants.COLN_REFERRALS);
    return ref.where('ref_by', isEqualTo: id).get();
  }

  Future<DocumentSnapshot> getUserReferDoc(String id) {
    ref = _db.collection(Constants.COLN_REFERRALS);
    return ref.doc(id).get();
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

  DocumentReference getUserTransactionDocumentKey(String userId) {
    return _db
        .collection(Constants.COLN_USERS)
        .doc(userId)
        .collection(Constants.SUBCOLN_USER_TXNS)
        .doc();
  }

  Future<QuerySnapshot> getRecentAugmontDepositTxn(
      String userId, Timestamp cmpTimestamp) {
    Query _query = _db
        .collection(Constants.COLN_USERS)
        .doc(userId)
        .collection(Constants.SUBCOLN_USER_TXNS);
    _query = _query
        .where(UserTransaction.fldSubType,
            isEqualTo: UserTransaction.TRAN_SUBTYPE_AUGMONT_GOLD)
        .where(UserTransaction.fldType,
            isEqualTo: UserTransaction.TRAN_TYPE_DEPOSIT)
        .where(UserTransaction.fldTranStatus,
            isEqualTo: UserTransaction.TRAN_STATUS_COMPLETE)
        .where(UserTransaction.fldTimestamp,
            isGreaterThanOrEqualTo: cmpTimestamp);
    // .orderBy(UserTransaction.fldTimestamp, descending: true).startAfter([cmpTimestamp]);

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

  Future<QuerySnapshot> getPromoCardCollection() {
    Query _query = _db.collection(Constants.COLN_PROMOS).orderBy('position');
    return _query.get();
  }

  Future<String> getFileFromDPBucketURL(String uid, String path) {
    return _storage.ref('dps/$uid/$path').getDownloadURL();
  }

  Future<List<String>> getWalkthroughFiles() async {
    ListResult _allVideos = await _storage.ref('walkthrough').listAll();
    List<String> _res = [];
    for (Reference ref in _allVideos.items) {
      var value = await ref.getDownloadURL();
      _res.add(value);
    }
    return _res;
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

  Future<bool> createEmailVerificationDocument(String email, String otp) async {
    // String htmlCode = OTPEmail().getEmailCode(otp);
    String htmlCode =
        await rootBundle.loadString('resources/fello-email-verification.html');
    htmlCode = htmlCode.replaceAll('\$otp', otp);
    Map<String, dynamic> data = {
      'to': [email],
      'message': {
        'text': 'This is the text body',
        'subject': '$otp - OTP for email verification',
        'html': htmlCode
      }
    };
    try {
      await _db.collection(Constants.COLN_EMAILOTPREQUESTS).add(data);
      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  Future<DocumentSnapshot> getUserFundBalance(String id) {
    ref = _db
        .collection(Constants.COLN_USERS)
        .doc(id)
        .collection(Constants.SUBCOLN_USER_WALLET);
    return ref.doc(Constants.DOC_USER_WALLET_FUND_BALANCE).get();
  }

  //FLC
  Future<DocumentSnapshot> getUserCoinWalletDocById(String id) {
    ref = _db
        .collection(Constants.COLN_USERS)
        .doc(id)
        .collection(Constants.SUBCOLN_USER_WALLET);
    return ref.doc(Constants.DOC_USER_WALLET_COIN_BALANCE).get();
  }

  //Statistics
  Future<QueryDocumentSnapshot> getStatisticsByFreqGameTypeAndCode(
      String gameType, String freq, String code) async {
    Query _query = _db
        .collection(Constants.COLN_STATISTICS)
        .where('code', isEqualTo: code)
        .where('freq', isEqualTo: freq)
        .where('gametype', isEqualTo: gameType);

    try {
      QuerySnapshot _querySnapshot = await _query.get();

      return _querySnapshot.docs.first;
    } catch (e) {
      throw e;
    }
  }

  //Winners
  Future<QueryDocumentSnapshot> getWinnersByGameTypeFreqAndCode(
      String gameType, String freq, String code) async {
    Query _query = _db
        .collection(Constants.WINNERS)
        .where('code', isEqualTo: code)
        .where('freq', isEqualTo: freq)
        .where('gametype', isEqualTo: gameType);

    try {
      QuerySnapshot _querySnapshot = await _query.get();
      return _querySnapshot.docs.first;
    } catch (e) {
      throw e;
    }
  }

  //Prizes
  Future<QueryDocumentSnapshot> getPrizesPerGamePerFreq(
      String gameCode, String freq) async {
    Query _query = _db
        .collection(Constants.COLN_PRIZES)
        .where('category', isEqualTo: gameCode)
        .where('freq', isEqualTo: freq);
    try {
      QuerySnapshot _querySnapshot = await _query.get();
      if (_querySnapshot.docs != null) {
        logger.i("No prizes for perticular category and freq");
      }
      return _querySnapshot.docs?.first;
    } catch (e) {
      throw e;
    }
  }

  Future<QueryDocumentSnapshot> fetchFaqs(String category) async {
    Query _query = _db
        .collection(Constants.COLN_FAQS)
        .where('category', isEqualTo: category);
    try {
      QuerySnapshot _querySnapshot = await _query.get();
      return _querySnapshot.docs?.first;
    } catch (e) {
      throw e;
    }
  }

  //---------------------------------------REALTIME DATABASE-------------------------------------------//

  Future<bool> checkUserNameAvailability(String username) async {
    try {
      rdb.DataSnapshot data = await _realtimeDatabase
          .reference()
          .child("usernames")
          .child(username)
          .once();
      print(data.key.toString() + "  " + data.value.toString());
      if (data.value != null) return false;
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> setUserName(String username, String userId) async {
    try {
      await _realtimeDatabase
          .reference()
          .child("usernames")
          .child(username)
          .set(userId);
      return true;
    } catch (e) {
      return false;
    }
  }
}
