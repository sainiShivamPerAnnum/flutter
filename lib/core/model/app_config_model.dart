import 'package:felloapp/core/enums/app_config_keys.dart';

class AppConfig {
  String message;
  Map<AppConfigKey, Object> data = {};

  AppConfig({required this.message, required this.data});

  factory AppConfig.fromJson(Map<String, dynamic> json) {
    final data = <AppConfigKey, Object>{};
    final _message = json['message'] ?? '';
    final _data = json['data'] as Map;
    _data
        .map((key, value) => data[key.toString().appConfigKeyFromName] = value);

    return AppConfig(message: _message, data: data);
  }
}


