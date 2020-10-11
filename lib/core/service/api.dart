import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:felloapp/util/logger.dart';

class Api {
  Log log = new Log("Api");
  final Firestore _db = Firestore.instance;
  String path;
  CollectionReference ref;

  Api();
}