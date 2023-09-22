import 'dart:developer';

import 'package:felloapp/core/base_remote_config.dart';
import 'package:felloapp/core/enums/app_config_keys.dart';
import 'package:felloapp/util/flavor_config.dart';

class AppEnvironment {
  final String userOps;
  final String rewards;
  final String stats;
  final String referral;

  final String coupons;

  const AppEnvironment._({
    required this.userOps,
    required this.rewards,
    required this.stats,
    required this.referral,
    required this.coupons,
  });

  static AppEnvironment? _instance;

  static AppEnvironment get instance {
    assert(_instance != null, '''The getter `instance` was called before 
initializing the AppEnvironment. Initialize app environment prior access it.''');
    return _instance!;
  }

  static AppEnvironment init(Map<String, dynamic>? data) {
    if (_instance != null) return _instance!;

    final isDev = FlavorConfig.isDevelopment();

    if (isDev) {
      _instance = AppEnvironment._(
        userOps: data?['userOps'] ??
            'https://6w37rw51hj.execute-api.ap-south-1.amazonaws.com/dev',
        rewards: data?['rewards'] ??
            'https://3yoxli7gxc.execute-api.ap-south-1.amazonaws.com/dev',
        stats: data?['stats'] ??
            'https://l6e3g2pr2b.execute-api.ap-south-1.amazonaws.com/dev',
        referral: data?['referral'] ??
            'https://2k3cus82jj.execute-api.ap-south-1.amazonaws.com/dev',
        coupons: data?['coupons'] ??
            'https://64w9v5hct9.execute-api.ap-south-1.amazonaws.com/dev',
      );

      return _instance!;
    }

    _instance = AppEnvironment._(
      userOps: data?['userOps'] ??
          'https://7y9layzs7j.execute-api.ap-south-1.amazonaws.com/prod',
      rewards: data?['rewards'] ??
          'https://bdqsoy9h84.execute-api.ap-south-1.amazonaws.com/prod',
      stats: data?['stats'] ??
          'https://08wplse7he.execute-api.ap-south-1.amazonaws.com/prod',
      referral: data?['referral'] ??
          'https://bt3lswjiw1.execute-api.ap-south-1.amazonaws.com/prod',
      coupons: data?['coupons'] ??
          'https://mwl33qq6sd.execute-api.ap-south-1.amazonaws.com/prod',
    );

    return _instance!;
  }
}

class AppConfig {
  String message;
  Map<AppConfigKey, Object?> data = {};
  static final Map<String, AppConfig> _instances = {};

  AppConfig({required this.message, required this.data});

  factory AppConfig.instance(Map<String, dynamic> json) {
    log("APP CONFIG ${json.toString()}");

    _instances['instance'] = AppConfig._fromJson(json);

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
    final val = _instances.values.first.data[key];
    if (val != null) {
      return val as T;
    } else {
      return BaseRemoteConfig.DEFAULTS.entries
          .firstWhere((element) => element.key.appConfigKeyFromName == key,
              orElse: () => MapEntry(key.name, null))
          .value as T;
    }
  }
}
