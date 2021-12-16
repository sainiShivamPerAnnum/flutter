import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:encrypt/encrypt.dart';
import 'package:felloapp/core/ops/db_ops.dart';
import 'package:felloapp/core/service/user_service.dart';
import 'package:felloapp/util/fail_types.dart';
import 'package:felloapp/util/locator.dart';
import 'package:flutter/services.dart';
import 'package:logger/logger.dart';
import 'package:pointycastle/asymmetric/api.dart';
import 'package:archive/archive.dart';

///
/// ** [FOR TESTING: CHECKOUT THE RSAFINAL WIDGET IN transactions_view.dart file] **
///
/// init(): initializes rsa and aes encrypter
///
/// RSA(Rivest, Shamir, Adleman) uses:
/// *public key
/// *RSAEncoding PKCS1(Public Key Cryptography Standards)
///
/// AES(Advanced Encryption Standard) uses:
/// *randomized(32) key converted to utf8 encoded aesKey
/// *randomized(16) iv
/// *AESMode.cbc
/// *PKCS7
///
/// Returning map contains:
/// *iv: randomIv
/// *encK: rsa encrypted aes key in base64 format
/// *encrypted: aes encrypted data in base16 format
///
///

class RSAEncryption {
  final _userService = locator<UserService>();
  final _dbModel = locator<DBModel>();
  final _logger = locator<Logger>();
  Encrypter rsaEncrypter, aesEncrypter;
  final _chars = 'abcdef1234567890';
  Random _rnd = Random();
  String randomIv, randomAesKey;
  IV iv;
  Key aesKey;

  Future<bool> init() async {
    bool rsaStatus = await initializeRSAEncrypter();
    bool aesStatus = initializeAESEncrypter();
    if (rsaStatus && aesStatus) return true;
    return false;
  }

  Future<bool> initializeRSAEncrypter() async {
    try {
      final publicKey =
          await parseWithRootBundle<RSAPublicKey>("resources/public.key");
      rsaEncrypter = Encrypter(RSA(
        publicKey: publicKey,
      ));
      return true;
    } catch (e) {
      _logger.e(e.toString());
      if (_userService.isUserOnborded)
        _dbModel.logFailure(
            _userService.baseUser.uid, FailType.RSAEncryterInitFailed, {
          "message": "RSA Encrypter generation Failed",
          "error": e.toString()
        });
      return false;
    }
  }

  bool initializeAESEncrypter() {
    try {
      randomAesKey = getRandomString(32);
      aesKey = Key.fromUtf8(randomAesKey);
      randomIv = getRandomString(16);
      iv = IV.fromUtf8(randomIv);
      aesEncrypter =
          Encrypter(AES(aesKey, mode: AESMode.cbc, padding: "PKCS7"));
      return true;
    } catch (e) {
      _logger.e(e.toString());
      if (_userService.isUserOnborded)
        _dbModel.logFailure(
            _userService.baseUser.uid, FailType.AESEncryptionInitFailed, {
          "message": "AES Encrypter generation Failed",
          "error": e.toString()
        });
      return false;
    }
  }

  String rsaEncrypt() {
    _logger.d("KEY: $randomAesKey");
    final encryptedKey = rsaEncrypter.encrypt(aesKey.base64);
    return encryptedKey.base64;
  }

  String aesEncypt(Map<String, dynamic> data) {
    final plainText = json.encode(data).toString();
    final encryptedData = aesEncrypter.encrypt(plainText, iv: iv);
    return encryptedData.base16;
  }

  Map<String, dynamic> encrypt(Map<String, dynamic> data) {
    final encrypted = aesEncypt(data);
    final encK = rsaEncrypt();
    final iv = getIv();
    return {"iv": iv, "encK": encK, "encrypted": encrypted};
  }

  // Helper Methods

  Future<T> parseWithRootBundle<T extends RSAAsymmetricKey>(
      String filename) async {
    final key = await rootBundle.loadString(filename);
    final parser = RSAKeyParser();
    return parser.parse(key) as T;
  }

  String getRandomString(int length) => String.fromCharCodes(
        Iterable.generate(
          length,
          (_) => _chars.codeUnitAt(
            _rnd.nextInt(_chars.length),
          ),
        ),
      );

  String getIv() {
    return randomIv;
  }

  // Helper Methods - END

  // String decrypt(String data) {
  //   final decryptedData = rsaEncrypter.decrypt64(data);
  //   return decryptedData;
  // }
}

// class SymmetricEncryption {
//   final _chars = 'abcdef1234567890';
//   Random _rnd = Random();

//   String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
//       length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));
//   main(String ot) {
//     final plainText = json.encode(ot);
//     final key = Key.fromUtf8('my 32 length key............wide');
//     final iv = IV.fromLength(16);

//     final encrypter = Encrypter(AES(key));

//     final encrypted = encrypter.encrypt(plainText, iv: iv);
//     final decrypted = encrypter.decrypt(encrypted, iv: iv);

//     print(decrypted); // Lorem ipsum dolor sit amet, consectetur adipiscing elit
//     print(encrypted.base64);
//     print(encrypted.base64.length);
//   }
// }
