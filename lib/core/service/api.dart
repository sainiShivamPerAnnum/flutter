import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:felloapp/core/model/user_transaction_model.dart';
import 'package:felloapp/util/constants.dart';
import 'package:felloapp/util/custom_logger.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/logger.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart' as rdb;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';

class Api {
  Log log = const Log("Api");

  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final rdb.FirebaseDatabase _realtimeDatabase = rdb.FirebaseDatabase.instance;

  final db2 = rdb.FirebaseDatabase.instanceFor(
      app: Firebase.app(),
      databaseURL:
          'https://fello-dev-station.asia-southeast1.firebasedatabase.app/');

  final CustomLogger? logger = locator<CustomLogger>();

  String? path;
  late CollectionReference ref;

  Api();

  Future<void> deleteUserClientToken(String? userId) {
    ref = _db
        .collection(Constants.COLN_USERS)
        .doc(userId)
        .collection(Constants.SUBCOLN_USER_FCM);
    return ref.doc(Constants.DOC_USER_FCM_TOKEN).delete();
  }

  Future<DocumentSnapshot?> fetchScratchCardById(
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
      logger!.e(e);
    }
    return null;
  }

  Future<QuerySnapshot>? checkForLatestGTStatus(String userId) {
    Future<QuerySnapshot>? snapshot;
    Query query = _db
        .collection(Constants.COLN_USERS)
        .doc(userId)
        .collection(Constants.SUBCOLN_USER_REWARDS);
    try {
      snapshot = query.orderBy('timestamp', descending: true).limit(30).get();
    } catch (e) {
      logger!.e(e);
    }
    return snapshot;
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

  Future<QuerySnapshot> getUserPrizeTransactionDocuments(String? userId) {
    final query = _db
        .collection(Constants.COLN_USERS)
        .doc(userId)
        .collection(Constants.SUBCOLN_USER_TXNS)
        .where('tType', isEqualTo: 'PRIZE');
    return query.get();
  }

  Future<void> addFeedbackDocument(Map data) {
    return _db
        .collection(Constants.COLN_FEEDBACK)
        .add(data as Map<String, dynamic>);
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
    required String userId,
    required int limit,
    String? type,
    String? subtype,
    String? status,
    DocumentSnapshot? lastDocument,
  }) {
    Query query = _db
        .collection(Constants.COLN_USERS)
        .doc(userId)
        .collection(Constants.SUBCOLN_USER_TXNS);
    if (type != null) {
      query = query.where(UserTransaction.fldType, isEqualTo: type);
    }
    if (subtype != null) {
      query = query.where(UserTransaction.fldSubType, isEqualTo: subtype);
    }
    if (status != null) {
      query = query.where(UserTransaction.fldTranStatus, isEqualTo: status);
    }
    if (limit != -1 && limit > 3) query = query.limit(limit);
    query = query.orderBy(UserTransaction.fldTimestamp, descending: true);
    if (lastDocument != null) query = query.startAfterDocument(lastDocument);
    return query.get();
  }

  Future<String> getFileFromDPBucketURL(String? uid, String path) {
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

  Future<QueryDocumentSnapshot<Object?>?> fetchFaqs(String category) async {
    Query _query = _db
        .collection(Constants.COLN_FAQS)
        .where('category', isEqualTo: category);
    try {
      QuerySnapshot? _querySnapshot = await _query.get();
      return _querySnapshot.docs.first;
    } catch (e) {
      throw e;
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

  Stream<rdb.DatabaseEvent>? fetchRealTimePlayingStats(String gameType) {
    try {
      var data = _realtimeDatabase.ref().child("stats").child(gameType).onValue;

      return data;
    } catch (e) {
      print("Exception:${e.toString()}");
      return null;
    }
  }

  Stream<rdb.DatabaseEvent>? fetchRealTimeFinanceStats() {
    try {
      var data = db2.ref().child("finance-stats").onValue;

      return data;
    } catch (e) {
      print("Exception:${e.toString()}");
      return null;
    }
  }
}
