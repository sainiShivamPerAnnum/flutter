import 'dart:convert';
import 'dart:developer';

import 'package:felloapp/core/enums/app_config_keys.dart';
import 'package:felloapp/util/logger.dart';

class AppConfig {
  String message;
  Map<AppConfigKey, Object?> data = {};
  static Map<String, AppConfig> _instances = {};
  factory AppConfig.instance(Map<String, dynamic> json) =>
      _instances.putIfAbsent('instance', () => AppConfig._fromJson(json));

  AppConfig({required this.message, required this.data});

  factory AppConfig._fromJson(Map<String, dynamic> json) {
    final mapOFData = <AppConfigKey, Object>{};
    final _message = json['message'] ?? '';
    final _data = json['data'] as Map;

    _data.forEach(
      (key, value) {
        mapOFData[key.toString().appConfigKeyFromName] = value ?? null;
      },
    );

    return AppConfig(message: _message, data: mapOFData);
  }

  static T getValue<T>(AppConfigKey key) =>
      _instances.values.first.data[key] as T;
}
