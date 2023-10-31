import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';

/// A mixin for disabling recording.
///
/// This mixin is designed to be used with [StatefulWidget]s. It provides
/// functionality to lock the screen to prevent recording.
///
/// To use this mixin, implement the [shouldDisableRecording] getter in your
/// StatefulWidget, specifying the conditions under which recording should be
/// disabled. The mixin will automatically handle the initialization and
/// disposal of the recording lock based on the [initState] and [dispose]
/// lifecycle methods.
mixin RecordingDisableMixin<T extends StatefulWidget> on State<T> {
  final _iosChannel = const MethodChannel('secureScreenshotChannel');

  @override
  void initState() {
    super.initState();
    _captureLock();
  }

  @override
  void dispose() {
    _removeLock();
    super.dispose();
  }

  /// To disable recording based on platform-specific methods.
  Future<void> _captureLock() async {
    if (Platform.isAndroid) {
      await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
    } else {
      await _iosChannel.invokeMethod('secureiOS');
    }
  }

  /// Removes the recording lock based on platform-specific methods.
  Future<void> _removeLock() async {
    if (Platform.isAndroid) {
      await FlutterWindowManager.clearFlags(FlutterWindowManager.FLAG_SECURE);
    } else {
      await _iosChannel.invokeMethod("unSecureiOS");
    }
  }
}
