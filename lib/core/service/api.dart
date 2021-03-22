import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:felloapp/core/model/DailyPick.dart';
import 'package:felloapp/core/model/TambolaBoard.dart';
import 'package:felloapp/core/model/UserTransaction.dart';
import 'package:felloapp/util/constants.dart';
import 'package:felloapp/util/logger.dart';
import 'package:firebase_storage/firebase_storage.dart';

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

  Future<void> createTicketRequest(String userId, Map data) {
    return _db
        .collection(Constants.COLN_TICKETREQUEST)
        .doc()
        .set(data, SetOptions(merge: false));
  }

  Stream<QuerySnapshot> getValidUserTickets(String user_id, int weekCode) {
    Query query = _db
        .collection(Constants.COLN_USERS)
        .doc(user_id)
        .collection(Constants.SUBCOLN_USER_TICKETS);
    query = query.where(TambolaBoard.fldWeekCode, isEqualTo: weekCode);

    return query.snapshots();
    //return query.getDocuments();
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

  Future<void> addUserPollResponseDocument(
      String id, String pollId, Map data) {
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

  Future<QuerySnapshot> getLeaderboardDocument(String category, int weekCde) {
    Query _query = _db
        .collection(Constants.COLN_LEADERBOARD)
        .where('category', isEqualTo: category)
        .where('week_code', isEqualTo: weekCde);
    return _query.get();
  }

  Future<String> getFileFromDPBucketURL(String uid, String path) {
    return _storage.ref('dps/$uid/$path').getDownloadURL();
  }
}
