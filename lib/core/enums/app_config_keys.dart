import 'package:felloapp/core/model/app_config_model.dart';

enum AppConfigKey {
  loginAssetUrl,
  invalidateBefore,
  autosaveActive,
  referralBonus,
  referralFlcBonus,
  paytmMid,
  rzpMid,
  augmont_deposit_permission,
  aws_augmont_key_index,
  tambola_daily_pick_count,
  appShareMessage,
  min_withdrawable_prize,
  active_pg_ios,
  active_pg_android,
  tambola_cost,
  min_principle_for_prize,
  game_tambola_announcement,

  enabled_psp_apps,
  app_share_message,
  unlock_referral_amt,
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
      case 'appShareMessage':
        return AppConfigKey.appShareMessage;
      case 'min_withdrawable_prize':
        return AppConfigKey.min_withdrawable_prize;
      case 'unlock_referral_amt':
        return AppConfigKey.unlock_referral_amt;
      case 'active_pg_ios':
        return AppConfigKey.active_pg_ios;
      case 'active_pg_android':
        return AppConfigKey.active_pg_android;
      case 'enabled_psp_apps':
        return AppConfigKey.enabled_psp_apps;
      case 'app_share_message':
        return AppConfigKey.appShareMessage;
      case 'min_principle_for_prize':
        return AppConfigKey.min_principle_for_prize;
      case 'tambola_cost':
        return AppConfigKey.tambola_cost;
      case 'augmont_deposit_permission':
        return AppConfigKey.augmont_deposit_permission;
      case 'game_tambola_announcement':
        return AppConfigKey.game_tambola_announcement;
      default:
        return AppConfigKey.unknown;
    }
  }
}
