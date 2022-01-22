import 'package:shared_preferences/shared_preferences.dart';

class PreferenceHelper {
  // keys
  static const DATE_APP_OPENED = 'date_app_opened';
  static const INSTALLATION_DAY = 'installation_day';

  static SharedPreferences _prefs;

  static Future<SharedPreferences> initiate() async {
    if (_prefs == null) {
      _prefs = await SharedPreferences.getInstance();
    }
    return _prefs;
  }

  static void setString(String key, String value) {
    _prefs.setString(key, value);
  }

  static void setInt(String key, int value) {
    _prefs.setInt(key, value);
  }

  static void setDouble(String key, double value) {
    _prefs.setDouble(key, value);
  }

  static void setBool(String key, bool value) {
    _prefs.setBool(key, value);
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

  static void clear() {
    _prefs.clear();
  }
}
