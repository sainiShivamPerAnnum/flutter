import 'dart:developer';

import 'package:felloapp/core/base_remote_config.dart';
import 'package:felloapp/core/enums/app_config_keys.dart';

import 'app_environment.dart';

class AppConfig {
  String message;
  Map<AppConfigKey, Object?> data = {};
  static AppConfig? _instances;

  AppConfig({required this.message, required this.data});

  factory AppConfig.instance(Map<String, dynamic> json) {
    log("APP CONFIG ${json.toString()}");
    _instances = AppConfig._fromJson(json);
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

    return AppConfig(message: message, data: mapOFData);
  }

  static T getValue<T>(AppConfigKey key) {
    assert(
        _instances != null, 'Initialize app config before calling `getValue`.');
    final val = _instances!.data[key];
    return val != null
        ? val as T
        : BaseRemoteConfig.DEFAULTS.entries
            .firstWhere((element) => element.key.appConfigKeyFromName == key,
                orElse: () => MapEntry(key.name, null))
            .value as T;
  }
}
