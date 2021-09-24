import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/ops/db_ops.dart';
import 'package:felloapp/core/ops/http_ops.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/logger.dart';
import 'package:flutter/material.dart';

class PanService extends ChangeNotifier {
  PanService();

  BaseUtil baseProvider = locator<BaseUtil>();
  DBModel dbProvider = locator<DBModel>();
  HttpModel httpProvider = locator<HttpModel>();
  final RegExp panCheck = RegExp(r"[A-Z]{5}[0-9]{4}[A-Z]{1}");
  static const int ENC_VERSION = 2;
  Log log = new Log('PanService');

  ///Returns either 'null' or a valid PAN Number
  Future<String> getUserPan() async {
    ///assumption: if they were never onboarded to augmont, they havent added their pan
    if (!baseProvider.myUser.isAugmontOnboarded) {
      return null;
    }
    String pan_v1;

    // ///check if user added their pan in base user
    // if (baseProvider.myUser.pan != null && baseProvider.myUser.pan.isNotEmpty) {
    //   pan_v1 = baseProvider.myUser.pan;
    // }

    ///now check if pan new version available
    Map<String, dynamic> encPan =
        await dbProvider.getEncodedUserPan(baseProvider.myUser.uid);
    if (encPan == null) {
      log.debug('No vX PAN Number found on remote');
      return pan_v1;
    }

    ///decrypt pan number
    String pan =
        await httpProvider.decryptText(encPan['value'], encPan['enid']);
    if (pan != null && pan.isNotEmpty && panCheck.hasMatch(pan)) {
      log.debug('Decrypted PAN Number: $pan');
      return pan;
    } else {
      log.error('Pan could be parsed post decryption');
      return null;
    }
  }

  Future<bool> saveUserPan(String pan) async {
    if (pan == null || pan.isEmpty || !panCheck.hasMatch(pan)) {
      return false;
    }

    ///encrypt pan
    String encPan = await httpProvider.encryptText(pan, ENC_VERSION);
    if (encPan == null || encPan.isEmpty) {
      log.error('Encryption failed');
      return false;
    }

    ///save to remote
    return await dbProvider.saveEncodedUserPan(
        baseProvider.myUser.uid, encPan, ENC_VERSION);
  }
}
