import 'package:flutter/services.dart';

class RootCheckService {
  final methodChannel = const MethodChannel('root_check');

  @override
  Future<bool> isDeviceRooted() async {
    return await methodChannel.invokeMethod('isDeviceRooted');
  }
}
