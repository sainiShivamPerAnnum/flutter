import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class CustomLogger {
  static Level level = Level.verbose;

  ///Encryption Utils

  static bool isEnc =
      //FlavorConfig.isProduction() ??
      false;

  final LogFilter _filter;
  final LogPrinter _printer;
  final LogOutput _output;
  bool _active = true;

  CustomLogger()
      : _filter = DevelopmentFilter(),
        _printer = PrettyPrinter(),
        _output =
            MultiOutput([ConsoleOutput(), StreamOutput(), MemoryOutput()]) {
    _filter.init();
    _filter.level = level ?? Logger.level;
    _printer.init();
    _output.init();

    try {
      // print('Logger AES initiated: ' + _initializeAESEncryptor().toString());
      debugPrint('Logger AES initiated: ');
    } catch (e) {
      debugPrint('$e');
    }
  }

  /// Log a message at level [Level.verbose].
  void v(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    log(Level.verbose, _processMessage(message), error, StackTrace.current);
  }

  /// Log a message at level [Level.debug].
  void d(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    log(Level.debug, _processMessage(message), error, StackTrace.current);
  }

  /// Log a message at level [Level.info].
  void i(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    log(Level.info, _processMessage(message), error, StackTrace.current);
  }

  /// Log a message at level [Level.warning].
  void w(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    log(Level.warning, _processMessage(message), error, StackTrace.current);
  }

  /// Log a message at level [Level.error].
  void e(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    log(Level.error, _processMessage(message), error, StackTrace.current);
  }

  /// Log a message at level [Level.wtf].
  void wtf(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    log(Level.wtf, _processMessage(message), error, StackTrace.current);
  }

  dynamic _processMessage(dynamic message) {
    try {
      if (isEnc) {
        return "";
      } else {
        return message;
      }
    } catch (e) {
      return 'REDACTED STR';
    }
  }

  String? _castString<T>(x) {
    if (x is String) {
      return x;
    } else {
      try {
        return x.toString();
      } catch (e) {
        return null;
      }
    }
  }

  /// Log a message with [level].
  void log(Level level, dynamic message,
      [dynamic error, StackTrace? stackTrace]) {
    if (!_active) {
      throw ArgumentError('Logger has already been closed.');
    } else if (error != null && error is StackTrace) {
      throw ArgumentError('Error parameter cannot take a StackTrace!');
    }
    var logEvent =
        LogEvent(level, message, error: error, stackTrace: stackTrace);
    if (_filter.shouldLog(logEvent)) {
      var output = _printer.log(logEvent);

      if (output.isNotEmpty) {
        var outputEvent = OutputEvent(logEvent, output);
        // Issues with log output should NOT influence
        // the main software behavior.
        try {
          _output.output(outputEvent);
        } catch (e, s) {
          debugPrint(e.toString());
          debugPrint(s.toString());
        }
      }
    }
  }

  /// Closes the logger and releases all resources.
  /// Once this is called, all subsequent calls to [log] will fail.
  /// This is an asynchronous operation and returns a [Future] that completes
  /// once all resources have been released.
  /// This method is idempotent.
  /// Calling it multiple times will not result in an error.
  /// However, only the first call will trigger the actual closing of resources.
  /// The returned [Future] will complete with a value of `null`.
  /// If an error occurs during closing, the [Future] will complete with an
  /// error.
  /// The [Future] will complete with an error if it is called after the logger
  /// has already been closed.
  /// The [Future] will complete with an error if it is called before the
  /// logger has been initialized.
  /// Where to use this method.
  /// This method should be called when the application is shutting down.
  /// for example, in the `onStop` method of an Android `Activity`.
  /// for flutter app, where to call this method.
  /// This method should be called in the `onPause` method of the `State` object
  /// of the `StatefulWidget` that represents the root of the application.
  /// For example, in the `onPause` method of the `State` object of the
  /// `StatefulWidget` that is passed to the `runApp` method.
  /// This method should NOT be called in the `dispose` method of the `State`
  /// object of the `StatefulWidget` that represents the root of the
  /// application.
  /// For example, in the `dispose` method of the `State` object of the
  /// `StatefulWidget` that is passed to the `runApp` method.
  /// This is because the `dispose` method of the `State` object of the
  /// `StatefulWidget` that represents the root of the application is not
  /// guaranteed to be called.
  /// For example, if the application is terminated by the user, then the
  /// `dispose` method of the `State` object of the `StatefulWidget` that
  /// represents the root of the application will not be called.
  /// my root widget is a `MaterialApp`, which is a HookWidget.
  /// what to do now. Don't want to create another statefull for this.
  /// where is the pause state in hookWidget.
  /// https://stackoverflow.com/questions/63492211/how-to-detect-app-is-in-background-in-flutter
  ///
  ///
  Future<void> close() async {
    if (_active) {
      _active = false;
      await _output.destroy();
      await _printer.destroy();
      await _filter.destroy();
    }
  }
}
