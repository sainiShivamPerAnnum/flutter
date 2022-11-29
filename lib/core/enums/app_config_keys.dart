import 'package:felloapp/core/model/app_config_model.dart';

enum AppConfigKey {
  loginAssetUrl,
  invalidateBefore,
  autosaveActive,
  referralBonus,
  referralFlcBonus,
  paytmMid,
  rzpMid,
  aws_augmont_key_index,
  tambola_daily_pick_count,
  unknown,
}

extension AppConfigKeys on String {
  AppConfigKey get appConfigKeyFromName {
    switch (this) {
      case 'loginAssetUrl':
        return AppConfigKey.loginAssetUrl;
      case 'invalidateBefore':
        return AppConfigKey.invalidateBefore;
      case 'autosaveActive':
        return AppConfigKey.autosaveActive;
      case 'referralBonus':
        return AppConfigKey.referralBonus;
      case 'referralFlcBonus':
        return AppConfigKey.referralFlcBonus;
      case 'paytmMid':
        return AppConfigKey.paytmMid;
      case 'rzpMid':
        return AppConfigKey.rzpMid;
      case 'aws_augmont_key_index':
        return AppConfigKey.aws_augmont_key_index;
      case 'tambola_daily_pick_count':
        return AppConfigKey.tambola_daily_pick_count;

      default:
        return AppConfigKey.unknown;
    }
  }
}
