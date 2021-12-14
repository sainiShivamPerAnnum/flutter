import 'dart:convert';

import 'package:encrypt/encrypt.dart';
import 'package:felloapp/core/ops/db_ops.dart';
import 'package:felloapp/core/service/user_service.dart';
import 'package:felloapp/util/fail_types.dart';
import 'package:felloapp/util/locator.dart';
import 'package:flutter/services.dart';
import 'package:logger/logger.dart';
import 'package:pointycastle/asymmetric/api.dart';

class RSAEncryption {
  final _userService = locator<UserService>();
  final _dbModel = locator<DBModel>();
  final _logger = locator<Logger>();
  Encrypter encrypter;
  init() async {
    try {
      final publicKey =
          await parseWithRootBundle<RSAPublicKey>("resources/public.key");
      encrypter = Encrypter(RSA(
        publicKey: publicKey,
      ));
    } catch (e) {
      _logger.e(e.toString());
      if (_userService.isUserOnborded)
        _dbModel.logFailure(
            _userService.baseUser.uid, FailType.RSAEncryterInitFailed, {
          "message": "RSA Encrypter generation Failed",
          "error": e.toString()
        });
    }
  }

  Future<T> parseWithRootBundle<T extends RSAAsymmetricKey>(
      String filename) async {
    final key = await rootBundle.loadString(filename);
    final parser = RSAKeyParser();
    return parser.parse(key) as T;
  }

  String encypt(Map<String, dynamic> data) {
    final jsonEncodedData = json.encode(data);
    final encryptedData = encrypter.encrypt(jsonEncodedData);
    return encryptedData.base64;
  }
}
