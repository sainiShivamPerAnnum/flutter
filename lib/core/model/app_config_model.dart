import 'dart:developer';

import 'package:felloapp/core/base_remote_config.dart';
import 'package:felloapp/core/enums/app_config_keys.dart';

import 'app_environment.dart';

class AppConfig {
  String message;
  Map<AppConfigKey, Object?> data = {};
  Map<String, dynamic>? jsonData = {};

  static AppConfig? _instance;

  AppConfig._({
    required this.message,
    required this.data,
    required this.jsonData,
  });

  factory AppConfig.instance(Map<String, dynamic> json) {
    log("APP CONFIG ${json.toString()}");
    _instance = AppConfig._fromJson(json);
    final urls = json['overrideUrls'];
    AppEnvironment.init(urls);
    return AppConfig._fromJson(json);
  }

  factory AppConfig._fromJson(Map<String, dynamic>? json) {
    final mapOFData = <AppConfigKey, Object>{};
    final message = json?['message'] ?? '';
    final data = json;

    data?.forEach(
      (key, value) {
        mapOFData[key.toString().appConfigKeyFromName] =
            value ?? BaseRemoteConfig.DEFAULTS[key];
      },
    );

    return AppConfig._(
      message: message,
      data: mapOFData,
      jsonData: json,
    );
  }

  static Map<String, dynamic> get toRaw => _instance!.jsonData ?? {};

  static T getValue<T>(AppConfigKey key) {
    assert(
        _instance != null, 'Initialize app config before calling `getValue`.');
    final val = _instance!.data[key];
    return val != null
        ? val as T
        : BaseRemoteConfig.DEFAULTS.entries
            .firstWhere((element) => element.key.appConfigKeyFromName == key,
                orElse: () => MapEntry(key.name, null))
            .value as T;
  }
}
