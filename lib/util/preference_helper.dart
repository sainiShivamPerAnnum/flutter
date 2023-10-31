// ignore_for_file: constant_identifier_names, avoid_classes_with_only_static_members

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreferenceHelper {
  // keys
  static const DATE_APP_OPENED = 'date_app_opened';
  static const INSTALLATION_DAY = 'installation_day';
  static const CAMPAIGN_ID = 'campaign_id';
  static const REFERRAL_CODE = 'referral_code';
  static const REFERRAL_PROCESSED = 'referral_processed';
  static const CACHE_RATING_IS_RATED = "isUserRated";

  // static const CACHE_LAST_PLAYED_GAMES = "lastTwoGamesPlayed";
  static const CACHE_RATING_EXPIRY_TIMESTAMP = 'ratingExpireTimestamp';
  static const SHOW_TAMBOLA_PROCESSING = 'tambolaProcessingScreen';
  static const CACHE_ONBOARDING_COMPLETION = "onboardingCompletion";
  static const FCM_TOKEN = "fcm_token";
  static const CACHE_SHOW_SECURITY_MODALSHEET = "showSecurityModalSheet";
  static const CACHE_IS_USER_JOURNEY_ONBOARDED = "isUserJourneyOnboarded";
  static const CACHE_IS_AUTOSAVE_FIRST_TIME = "isOpeningAutosaveForFirstTime";
  static const CACHE_IS_DAILY_APP_BONUS_EVENT_ACTIVE =
      "isDailyAppBonusEventActive";
  static const CACHE_LAST_DAILY_APP_BONUS_REWARD_CLAIM_DAY =
      "lastDailyAppBonusRewardClaimDay";

  static const CACHE_SEGMENTS = "user_segments";
  static const CACHE_LAST_APP_OPEN = "lastAppOpen";
  static SharedPreferences? _prefs;
  static const POWERPLAY_IS_PLAYED = "powerplay_is_played";
  static const LAST_WEEK_NUMBER = 'lastWeekNumber';
  static const APP_RATING_SUBMITTED = 'app_rating_submitted';
  static const NEW_INSTALL_POPUP = "new_install_popup";
  static const GOLD_PRICE_SUBSCRIBE = "gold_price_subscribe";
  static const CACHE_REFERRAL_PERSISTENT_NOTIFACTION_ID =
      "referralPersistentNotificationId";
  static const CACHE_TICKETS_LAST_SPIN_TIMESTAMP =
      "tickets_last_spin_timestamp";
  static const CACHE_LIST_OUTDATED_FLO_ASSET = "listOutdatedFloAsset";
  static const _preferredPaymentIntents = 'preferred_payment_intents';

  static Future<SharedPreferences?> initiate() async {
    if (_prefs == null) {
      WidgetsFlutterBinding.ensureInitialized();
      _prefs = await SharedPreferences.getInstance();
    }
    return _prefs;
  }

  static Future<bool> setString(String key, String value) async {
    return _prefs!.setString(key, value);
  }

  static Future<bool> setInt(String key, int value) async {
    return _prefs!.setInt(key, value);
  }

  static Future<bool> setDouble(String key, double value) async {
    return _prefs!.setDouble(key, value);
  }

  static Future<bool> setBool(String key, bool value) async {
    return _prefs!.setBool(key, value);
  }

  static Future<bool> setStringList(String key, List<String> value) async {
    return _prefs!.setStringList(key, value);
  }

  static String getString(String key, {String def = ''}) {
    String? val = _prefs!.getString(key);
    return val ?? def;
  }

  static int getInt(String key, {int def = 0}) {
    int? val = _prefs!.getInt(key);
    return val ?? def;
  }

  static double getDouble(String key, {double def = 0.0}) {
    double? val = _prefs!.getDouble(key);
    return val ?? def;
  }

  static bool getBool(String key, {bool def = false}) {
    bool? val = _prefs!.getBool(key);
    return val ?? def;
  }

  static List<String> getStringList(String key, {List<String> def = const []}) {
    List<String>? val = _prefs!.getStringList(key);
    return val ?? def;
  }

  /// Stores the last three used payment option into local cache.
  ///
  /// If existing options are more than `3` then removes the last element out of
  /// the array and re-saves the options.
  static Future<void> insertUsedPaymentIntent(String option) async {
    final intents = getPaymentIntentsHistory();

    if (intents.length >= 3) {
      intents.removeLast();
    }

    intents.add(option);

    await _prefs!.setStringList(_preferredPaymentIntents, intents);
  }

  /// Payment options used by user in previous transactions.
  static List<String> getPaymentIntentsHistory() {
    try {
      return _prefs!.getStringList(_preferredPaymentIntents) ?? [];
    } catch (e) {
      return const [];
    }
  }

  static Future<bool> remove(String key) async {
    return _prefs!.remove(key);
  }

  static bool exists(String key) {
    return _prefs!.containsKey(key);
  }

  static void clear() {
    _prefs!.clear();
  }

  static void reload() {
    _prefs!.reload();
  }
}
