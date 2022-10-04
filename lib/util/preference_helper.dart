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
  static SharedPreferences _prefs;

  static Future<SharedPreferences> initiate() async {
    if (_prefs == null) {
      _prefs = await SharedPreferences.getInstance();
    }
    return _prefs;
  }

  static Future<bool> setString(String key, String value) async {
    return _prefs.setString(key, value);
  }

  static Future<bool> setInt(String key, int value) async {
    return _prefs.setInt(key, value);
  }

  static Future<bool> setDouble(String key, double value) async {
    return _prefs.setDouble(key, value);
  }

  static Future<bool> setBool(String key, bool value) async {
    return _prefs.setBool(key, value);
  }

  static String getString(String key, {String def}) {
    String val = _prefs.getString(key);
    if (val == null) {
      val = def;
    }
    return val;
  }

  static int getInt(String key, {int def}) {
    int val = _prefs.getInt(key);
    if (val == null) {
      val = def;
    }
    return val;
  }

  static double getDouble(String key, {double def}) {
    double val = _prefs.getDouble(key);
    if (val == null) {
      val = def;
    }
    return val;
  }

  static bool getBool(String key, {bool def}) {
    bool val = _prefs.getBool(key);
    if (val == null) {
      val = def;
    }
    return val;
  }

  static Future<bool> remove(String key) async {
    return _prefs.remove(key);
  }

  static bool exists(String key) {
    return _prefs.containsKey(key);
  }

  static void clear() {
    _prefs.clear();
  }

  static void reload() {
    _prefs.reload();
  }
}
