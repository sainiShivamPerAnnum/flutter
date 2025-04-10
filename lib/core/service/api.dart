import 'package:felloapp/util/custom_logger.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/logger.dart';
import 'package:firebase_storage/firebase_storage.dart';

class Api {
  Log log = const Log("Api");
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final CustomLogger? logger = locator<CustomLogger>();

  String? path;

  Api();
  Future<String> getFileFromDPBucketURL(String? uid, String path) {
    return _storage.ref('dps/$uid/$path').getDownloadURL();
  }
}
