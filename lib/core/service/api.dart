import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:felloapp/util/constants.dart';
import 'package:felloapp/util/logger.dart';

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
}