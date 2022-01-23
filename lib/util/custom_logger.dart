import 'dart:math';

import 'package:encrypt/encrypt.dart';
import 'package:felloapp/util/flavor_config.dart';
import 'package:logger/logger.dart';

class CustomLogger {
  static Level level = Level.verbose;

  ///Encryption Utils
  Encrypter aesEncrypter;
  Random _rnd = Random();
  String randomIv, randomAesKey;
  IV iv;
  Key aesKey;
  static const String _chars = 'abcdef1234567890';
  static bool isEnc = FlavorConfig.isProduction() ?? false;

  final LogFilter _filter;
  final LogPrinter _printer;
  final LogOutput _output;
  bool _active = true;

  CustomLogger()
      : _filter = DevelopmentFilter(),
        _printer = PrettyPrinter(),
        _output = ConsoleOutput() {
    _filter.init();
    _filter.level = level ?? Logger.level;
    _printer.init();
    _output.init();

    try {
      // print('Logger AES initiated: ' + _initializeAESEncryptor().toString());
      print('Logger AES initiated: ');
    } catch (e) {
      print('$e');
    }
  }

  /// Log a message at level [Level.verbose].
  void v(dynamic message, [dynamic error, StackTrace stackTrace]) {
    log(Level.verbose, _processMessage(message), error, StackTrace.current);
  }

  /// Log a message at level [Level.debug].
  void d(dynamic message, [dynamic error, StackTrace stackTrace]) {
    log(Level.debug, _processMessage(message), error, StackTrace.current);
  }

  /// Log a message at level [Level.info].
  void i(dynamic message, [dynamic error, StackTrace stackTrace]) {
    log(Level.info, _processMessage(message), error, StackTrace.current);
  }

  /// Log a message at level [Level.warning].
  void w(dynamic message, [dynamic error, StackTrace stackTrace]) {
    log(Level.warning, _processMessage(message), error, StackTrace.current);
  }

  /// Log a message at level [Level.error].
  void e(dynamic message, [dynamic error, StackTrace stackTrace]) {
    log(Level.error, _processMessage(message), error, StackTrace.current);
  }

  /// Log a message at level [Level.wtf].
  void wtf(dynamic message, [dynamic error, StackTrace stackTrace]) {
    log(Level.wtf, _processMessage(message), error, StackTrace.current);
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
      print('$e');
      return false;
    }
  }

  String _aesEncyptStr(String plainText) {
    final encryptedData = aesEncrypter.encrypt(plainText, iv: iv);
    return encryptedData.base16;
  }

  String _getRandomString(int length) => String.fromCharCodes(
        Iterable.generate(
          length,
          (_) => _chars.codeUnitAt(
            _rnd.nextInt(_chars.length),
          ),
        ),
      );

  dynamic _processMessage(dynamic message) {
    try {
      if (isEnc) {
        return "";
        // if (aesEncrypter == null) return 'REDACTED OBJ';
        //
        // String _msg = _castString<String>(message);
        // if (_msg == null)
        //   return 'REDACTED OBJ';
        // else
        //   return _aesEncyptStr(_msg);
      } else {
        return message;
      }
    } catch (e) {
      return 'REDACTED STR';
    }
  }

  String _castString<T>(x) {
    if (x is String)
      return x;
    else {
      try {
        return x.toString();
      } catch (e) {
        return null;
      }
    }
  }

  /// Log a message with [level].
  void log(Level level, dynamic message,
      [dynamic error, StackTrace stackTrace]) {
    if (!_active) {
      throw ArgumentError('Logger has already been closed.');
    } else if (error != null && error is StackTrace) {
      throw ArgumentError('Error parameter cannot take a StackTrace!');
    } else if (level == Level.nothing) {
      throw ArgumentError('Log events cannot have Level.nothing');
    }
    var logEvent = LogEvent(level, message, error, stackTrace);
    if (_filter.shouldLog(logEvent)) {
      var output = _printer.log(logEvent);

      if (output.isNotEmpty) {
        var outputEvent = OutputEvent(level, output);
        // Issues with log output should NOT influence
        // the main software behavior.
        try {
          _output.output(outputEvent);
        } catch (e, s) {
          print(e);
          print(s);
        }
      }
    }
  }

  /// Closes the logger and releases all resources.
  void close() {
    _active = false;
    _filter.destroy();
    _printer.destroy();
    _output.destroy();
  }
}
