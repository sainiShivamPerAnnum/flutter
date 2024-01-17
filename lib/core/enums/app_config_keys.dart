enum AppConfigKey {
  loginAssetUrl,
  invalidateBefore,
  showNewAutosave,
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
  changeAppIcon,
  enabled_psp_apps,
  app_share_message,
  unlock_referral_amt,
  unknown,
  powerplayConfig,
  predictScreen,
  lendbox,
  youtube_videos,
  tickets_youtube_videos,
  app_referral_message,
  enable_truecaller_login,
  payment_brief_view,
  quiz_config,
  revamped_referrals_config,
  useNewUrlUserOps,
  specialEffectsOnTxnDetailsView,
  ticketsCategories,
  goldProInterest,
  goldProInvestmentChips,
  features,
  quickActions,
  canChangePostMaturityPreference
}

extension AppConfigKeys on String {
  AppConfigKey get appConfigKeyFromName {
    switch (this) {
      case 'features':
        return AppConfigKey.features;
      case 'quickActions':
        return AppConfigKey.quickActions;
      case 'loginAssetUrl':
        return AppConfigKey.loginAssetUrl;
      case 'invalidateBefore':
        return AppConfigKey.invalidateBefore;
      case 'showNewAutosave':
        return AppConfigKey.showNewAutosave;
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
      case 'changeAppIcon':
        return AppConfigKey.changeAppIcon;
      case 'tambolaDailyPickCount':
        return AppConfigKey.tambola_daily_pick_count;

      case 'minWithdrawablePrize':
        return AppConfigKey.min_withdrawable_prize;
      case 'unlock_referral_amt':
        return AppConfigKey.unlock_referral_amt;
      case 'activePgIos':
        return AppConfigKey.active_pg_ios;
      case 'activePgAndroid':
        return AppConfigKey.active_pg_android;
      case 'enabledPspApps':
        return AppConfigKey.enabled_psp_apps;
      case 'appShareMessage':
        return AppConfigKey.appShareMessage;
      case 'minPrincipleForPrize':
        return AppConfigKey.min_principle_for_prize;
      case 'tambolaCost':
        return AppConfigKey.tambola_cost;
      case "augmont_deposit_permission":
        return AppConfigKey.augmont_deposit_permission;

      case 'game_tambola_announcement':
        return AppConfigKey.game_tambola_announcement;

      case 'powerplayConfig':
        return AppConfigKey.powerplayConfig;

      case 'predictScreen':
        return AppConfigKey.predictScreen;

      case "LENDBOXP2P":
        return AppConfigKey.lendbox;
      case 'youtubeVideos':
        return AppConfigKey.youtube_videos;
      case 'ticketsYoutubeVideos':
        return AppConfigKey.tickets_youtube_videos;
      case "appReferralMessage":
        return AppConfigKey.app_referral_message;
      case "enableTruecallerLogin":
        return AppConfigKey.enable_truecaller_login;
      case "paymentBriefView":
        return AppConfigKey.payment_brief_view;
      case "quizConfig":
        return AppConfigKey.quiz_config;
      case "revampedReferralsConfig":
        return AppConfigKey.revamped_referrals_config;
      case 'useNewUrlUserOps':
        return AppConfigKey.useNewUrlUserOps;
      case 'specialEffectsOnTxnDetailsView':
        return AppConfigKey.specialEffectsOnTxnDetailsView;
      case 'ticketsCategories':
        return AppConfigKey.ticketsCategories;
      case 'goldProInterest':
        return AppConfigKey.goldProInterest;
      case 'goldProInvestmentChips':
        return AppConfigKey.goldProInvestmentChips;
      case 'canChangePostMaturityPreference':
        return AppConfigKey.canChangePostMaturityPreference;
      default:
        return AppConfigKey.unknown;
    }
  }
}
