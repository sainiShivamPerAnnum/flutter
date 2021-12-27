import 'dart:convert';
import 'dart:math';

import 'package:encrypt/encrypt.dart';
import 'package:felloapp/core/ops/db_ops.dart';
import 'package:felloapp/core/service/user_service.dart';
import 'package:felloapp/util/fail_types.dart';
import 'package:felloapp/util/locator.dart';
import 'package:flutter/services.dart';
import 'package:logger/logger.dart';
import 'package:pointycastle/asymmetric/api.dart';

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
  static const String _chars = 'abcdef1234567890';
  static const String ENCRYPT_VERSION = 'v1';
  static const String PUBLIC_KEY_FILE_PATH = 'resources/public.key';
  Random _rnd = Random();
  String randomIv, randomAesKey;
  IV iv;
  Key aesKey;

  ///initialises a fresh AES key and IV on init
  Future<bool> init() async {
    bool rsaStatus = await _initializeRSAEncryptor();
    bool aesStatus = _initializeAESEncryptor();
    if (rsaStatus && aesStatus) return true;
    return false;
  }

  Map<String, dynamic> encryptRequestBody(Map<String, dynamic> data) {
    try {
      final encrypted = _aesEncypt(data);
      final encK = _rsaEncrypt();
      final iv = _getIv();
      return {
        "encv": ENCRYPT_VERSION,
        "iv": iv,
        "key": encK,
        "data": encrypted
      };
    } catch (e) {
      _logger.e('Encryption Failed: $e');
      return data;
    }
  }

  Future<bool> _initializeRSAEncryptor() async {
    try {
      final publicKey =
          await _parseWithRootBundle<RSAPublicKey>(PUBLIC_KEY_FILE_PATH);
      rsaEncrypter = Encrypter(RSA(
        publicKey: publicKey,
      ));
      return true;
    } catch (e) {
      _logger.e(e.toString());
      if (_userService.isUserOnborded)
        _dbModel.logFailure(
            _userService.baseUser.uid, FailType.RSAEncryterInitFailed, {
          "err_message":
              "RSA Encrypter generation Failed while parsing local file",
        });
      return false;
    }
  }

  bool _initializeAESEncryptor() {
    try {
      randomAesKey = _getRandomString(32);
      aesKey = Key.fromUtf8(randomAesKey);

      randomIv = _getRandomString(16);
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
        });
      return false;
    }
  }

  String _rsaEncrypt() {
    _logger.d("KEY: $randomAesKey");
    final encryptedKey = rsaEncrypter.encrypt(aesKey.base64);
    return encryptedKey.base64;
  }

  String _aesEncypt(Map<String, dynamic> data) {
    final plainText = json.encode(data).toString();
    final encryptedData = aesEncrypter.encrypt(plainText, iv: iv);
    return encryptedData.base16;
  }

  // Helper Methods
  Future<T> _parseWithRootBundle<T extends RSAAsymmetricKey>(
      String filename) async {
    try {
      final key = await rootBundle.loadString(filename);
      final parser = RSAKeyParser();
      return parser.parse(key) as T;
    } catch (e) {
      _logger.e(e.toString());
    }
  }

  String _getRandomString(int length) => String.fromCharCodes(
        Iterable.generate(
          length,
          (_) => _chars.codeUnitAt(
            _rnd.nextInt(_chars.length),
          ),
        ),
      );

  String _getIv() {
    return randomIv;
  }
}
