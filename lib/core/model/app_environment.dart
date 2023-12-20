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
        userOps: data?['userOps'] ?? 'https://api2.fello-dev.net',
        rewards: data?['rewards'] ?? 'https://api2.fello-dev.net',
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
      userOps: data?['userOps'] ?? 'api.fello-prod.net',
      rewards: data?['rewards'] ?? 'api.fello-prod.net',
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
