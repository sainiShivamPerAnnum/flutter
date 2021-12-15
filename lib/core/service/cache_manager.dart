import 'package:felloapp/core/enums/cache_type_enum.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CacheManager {
  static const CACHE_RATING_IS_RATED = "isUserRated";
  static const CACHE_RATING_HIT_COUNT = "rHitCount";
  static const CACHE_RATING_DIALOG_OPEN_COUNT = "RDShowCount";

  static Future readCache({@required String key}) async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    var cache = sharedPreferences.getString(key);
    return cache;
  }

  static Future writeCache({
    @required String key,
    @required var value,
    @required CacheType type,
  }) async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    if (type == CacheType.int) return sharedPreferences.setInt(key, value);

    switch (type) {
      case CacheType.int:
        await sharedPreferences.setInt(key, value);
        break;
      case CacheType.double:
        await sharedPreferences.setDouble(key, value);
        break;
      case CacheType.bool:
        await sharedPreferences.setBool(key, value);
        break;
      case CacheType.stringList:
        await sharedPreferences.setStringList(key, value);
        break;
      case CacheType.string:
        await sharedPreferences.setString(key, value);
        break;
    }
  }

  static Future deleteCache({@required String key}) async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    await sharedPreferences.remove(key);
  }

  static Future clearCacheMemory() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    await sharedPreferences.clear();
  }
}
