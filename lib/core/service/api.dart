import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:felloapp/core/model/amount_chips_model.dart';
import 'package:felloapp/core/model/daily_pick_model.dart';
import 'package:felloapp/core/model/tambola_board_model.dart';
import 'package:felloapp/core/model/user_transaction_model.dart';
import 'package:felloapp/util/constants.dart';
import 'package:felloapp/util/custom_logger.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/logger.dart';
import 'package:firebase_database/firebase_database.dart' as rdb;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

class Api {
  Log log = new Log("Api");

  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final rdb.FirebaseDatabase _realtimeDatabase = rdb.FirebaseDatabase.instance;

  final logger = locator<CustomLogger>();

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

  Future<QuerySnapshot> checkForLatestGoldenTicket(String userId) {
    Future<QuerySnapshot> snapshot;
    Query query = _db
        .collection(Constants.COLN_USERS)
        .doc(userId)
        .collection(Constants.SUBCOLN_USER_REWARDS);
    try {
      snapshot = query.orderBy('timestamp', descending: true).limit(1).get();
    } catch (e) {
      logger.e(e);
    }
    return snapshot;
  }

  Future<DocumentSnapshot> fetchGoldenTicketById(
      String userId, String gtId) async {
    DocumentReference docRef = _db
        .collection(Constants.COLN_USERS)
        .doc(userId)
        .collection(Constants.SUBCOLN_USER_REWARDS)
        .doc(gtId);
    try {
      DocumentSnapshot docSnap = await docRef.get();
      return docSnap;
    } catch (e) {
      logger.e(e);
    }
    return null;
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

  Future<QuerySnapshot> checkForLatestGTStatus(String userId) {
    Future<QuerySnapshot> snapshot;
    Query query = _db
        .collection(Constants.COLN_USERS)
        .doc(userId)
        .collection(Constants.SUBCOLN_USER_REWARDS);
    try {
      snapshot = query.orderBy('timestamp', descending: true).limit(30).get();
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
            .limit(20)
            .get();
      else
        snapshot =
            query.orderBy('created_time', descending: true).limit(20).get();
    } catch (e) {
      logger.e(e.toString());
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

  Future<void> updateUserDocumentPreferenceField(
      String docId, Map<String, dynamic> data) {
    ref = _db.collection(Constants.COLN_USERS);
    return ref.doc(docId).update(data);
  }

  Future<DocumentSnapshot> getUserPrtdDocPan(String userId) {
    ref = _db
        .collection(Constants.COLN_USERS)
        .doc(userId)
        .collection(Constants.SUBCOLN_USER_PRTD);
    return ref.doc('pan').get();
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

  Future<QuerySnapshot> getUserPrizeTransactionDocuments(String userId) {
    final query = _db
        .collection(Constants.COLN_USERS)
        .doc(userId)
        .collection(Constants.SUBCOLN_USER_TXNS)
        .where('tType', isEqualTo: 'PRIZE');
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

  Future<QuerySnapshot> getReferralDocs(String id) {
    ref = _db.collection(Constants.COLN_REFERRALS);
    return ref.where('ref_by', isEqualTo: id).get();
  }

  Future<DocumentSnapshot> getUserFundWalletDocById(String id) {
    ref = _db
        .collection(Constants.COLN_USERS)
        .doc(id)
        .collection(Constants.SUBCOLN_USER_WALLET);
    return ref.doc(Constants.DOC_USER_WALLET_FUND_BALANCE).get();
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

  Future<QuerySnapshot> getPromoCardCollection() {
    Query _query = _db.collection(Constants.COLN_PROMOS).orderBy('position');
    return _query.get();
  }

  Future<String> getFileFromDPBucketURL(String uid, String path) {
    return _storage.ref('dps/$uid/$path').getDownloadURL();
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

  Future<QuerySnapshot> fetchOngoingEvents() async {
    Query _query =
        _db.collection(Constants.COLN_APPCAMPAIGNS).orderBy('position');
    return _query.get();
  }

  Future<QuerySnapshot> fetchCoupons() async {
    Query _query = _db
        .collection(Constants.COLN_COUPONS)
        // .where('expiresOn', isGreaterThan: Timestamp.now())
        .orderBy('priority');
    return _query.get();
  }

  Future<DocumentSnapshot> fetchActiveSubscriptionDetails(String userid) async {
    DocumentReference doc = _db
        .collection(Constants.COLN_USERS)
        .doc(userid)
        .collection(Constants.SUBCOLN_USER_SUBSCRIPTION)
        .doc("detail");
    return await doc.get();
  }

  Future<QuerySnapshot> getAutosaveTransactions({
    @required String userId,
    DocumentSnapshot lastDocument,
    @required int limit,
  }) {
    Query query = _db
        .collection(Constants.COLN_USERS)
        .doc(userId)
        .collection(Constants.SUBCOLN_USER_SUB_TXN);
    if (limit != -1 && limit > 3) query = query.limit(limit);
    query = query.orderBy('createdOn', descending: true);
    if (lastDocument != null) query = query.startAfterDocument(lastDocument);
    return query.get();
  }

  Future<List<AmountChipsModel>> getAmountChips(String type) async {
    List<AmountChipsModel> amountChipList = [];
    try {
      DocumentSnapshot snapshot =
          await _db.collection(Constants.COLN_INAPPRESOURCES).doc(type).get();
      Map<String, dynamic> snapData = snapshot.data();
      snapData["userOptions"].forEach((e) {
        amountChipList.add(AmountChipsModel.fromMap(e));
      });
      amountChipList.sort((a, b) => a.order.compareTo(b.order));
      return amountChipList;
      // logger.d(data);
    } catch (e) {
      logger.e(e.toString());
    }
  }
  //---------------------------------------REALTIME DATABASE-------------------------------------------//

  Future<bool> checkUserNameAvailability(String username) async {
    try {
      final rdb.DataSnapshot data = (await _realtimeDatabase
              .ref()
              .child("usernames")
              .child(username)
              .once())
          .snapshot;

      print(data.key.toString() + "  " + data.value.toString());
      if (data.value != null) return false;
      return true;
    } catch (e) {
      return false;
    }
  }
}
