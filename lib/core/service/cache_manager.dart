import 'dart:convert';

import 'package:felloapp/core/enums/cache_type_enum.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CacheManager {
  static const CACHE_RATING_IS_RATED = "isUserRated";
  static const CACHE_RATING_HIT_COUNT = "rHitCount";
  static const CACHE_RATING_DIALOG_OPEN_COUNT = "RDShowCount";
  static const CACHE_LATEST_NOTIFICATION_TIME = "latestNotification";
  static const CACHE_LATEST_GOLDEN_TICKET_TIME = "latestGoldenTicket";
  static const CACHE_IS_SUBSCRIPTION_FIRST_TIME = "isSubFirstTime";

  static Future readCache(
      {@required String key, CacheType type = CacheType.string}) async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();

    var cache;
    switch (type) {
      case CacheType.int:
        cache = sharedPreferences.getInt(key);
        break;
      case CacheType.double:
        cache = sharedPreferences.getDouble(key);
        break;
      case CacheType.bool:
        cache = sharedPreferences.getBool(key);
        break;
      case CacheType.stringList:
        cache = sharedPreferences.getStringList(key);
        break;
      case CacheType.string:
        cache = sharedPreferences.getString(key);
        break;
      default:
        cache = sharedPreferences.getString(key);
    }
    return cache;
  }

  static Future<bool> isApiCacheable(String key) async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    if (sharedPreferences.containsKey(key)) {
      //cache exists
      final List<String> cache = sharedPreferences.getStringList(key);
      final String cacheExpireTimeString = cache[0];
      final DateTime cacheExpireTime = DateTime.parse(cacheExpireTimeString);

      if (DateTime.now().compareTo(cacheExpireTime) >= 0) {
        // cache expired
        await sharedPreferences.remove(key);
        return true;
      } else {
        // cache not expired
        return false;
      }
    } else {
      //key does not exists, cache can be added.
      return true;
    }
  }

  static Future<Map> getApiCache({@required String key}) async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    final List<String> cache = sharedPreferences.getStringList(key);
    final String valueString = cache[1];
    final Map value = jsonDecode(valueString);
    return value;
  }

  static Future<bool> writeApiCache({
    //apiPath as key
    @required String key,
    @required Duration ttl,
    @required Map value,
    @required CacheType type,
  }) async {
    final writeTimeStamp = DateTime.now();
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    if (type == CacheType.stringList) {
      try {
        //Add ttl to current time to calculate time to expire
        final DateTime cacheExpireTime = writeTimeStamp.add(ttl);
        final String valueString = jsonEncode(value);

        await sharedPreferences
            .setStringList(key, [cacheExpireTime.toString(), valueString]);
        return true;
      } catch (e) {
        print("Error in writing cache: $e");
        return false;
      }
    }
    return false;
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

  static Future<bool> exits(String key) async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    return sharedPreferences.containsKey(key);
  }
}
