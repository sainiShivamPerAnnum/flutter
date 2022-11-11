import 'dart:convert';

import 'package:felloapp/util/custom_logger.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:felloapp/util/locator.dart';

class ApiCacheManager {
  final _logger = locator<CustomLogger>();
  SharedPreferences sharedPreferences;

  Future<bool> _isApiCached(String key) async {
    if (sharedPreferences == null) {
      _logger.i("Creating instance isCacheable for $key");
      sharedPreferences = await SharedPreferences.getInstance();
    }

    try {
      _logger.d("isCacheable key: $key");
      bool cacheExists = sharedPreferences.containsKey(key);
      if (cacheExists) {
        _logger.d("isCacheable exists");
        //cache exists
        final List<String> cache = sharedPreferences.getStringList(key);
        final String cacheExpireTimeString = cache[0];
        final DateTime cacheExpireTime = DateTime.parse(cacheExpireTimeString);
        _logger.d(
            "isCacheable : ${cacheExpireTime.compareTo(DateTime.now()) <= 0} $key");
        if (cacheExpireTime.compareTo(DateTime.now()) <= 0) {
          // cache expired
          await sharedPreferences.remove(key);
          _logger.d("Returning true for $key");
          return false;
        } else {
          // cache not expired
          _logger.d("Returning false for $key");
          return true;
        }
      } else {
        //key does not exists, cache can be added.
        _logger.d("isCacheable does not exists");
        return false;
      }
    } catch (e) {
      _logger.d("Something went wrong: $e");
      return false;
    }
  }

  Future<Map> getApiCache({@required String key}) async {
    if (sharedPreferences == null) {
      sharedPreferences = await SharedPreferences.getInstance();
    }

    bool isApiCached = await _isApiCached(key);

    if (isApiCached) {
      final List<String> cache = sharedPreferences.getStringList(key);
      final String valueString = cache[1];
      final Map value = jsonDecode(valueString);
      return value;
    } else {
      return null;
    }
  }

  Future<void> writeApiCache({
    //apiPath as key
    @required String key,
    @required Duration ttl,
    @required Map value,
  }) async {
    final writeTimeStamp = DateTime.now();
    _logger.d("writeApiCache called isCacheable $key");

    if (sharedPreferences == null) {
      sharedPreferences = await SharedPreferences.getInstance();
    }

    final DateTime cacheExpireTime = writeTimeStamp.add(ttl);

    try {
      final String valueString = jsonEncode(value);

      bool isDataAdded = await sharedPreferences
          .setStringList(key, [cacheExpireTime.toString(), valueString]);

      _logger.d("Cache added for $key $isDataAdded");
    } catch (e) {
      _logger.e("Cache not added for $key : $e");
    }
  }

  Future<void> clearCacheMemory() async {
    try {
      if (sharedPreferences == null) {
        sharedPreferences = await SharedPreferences.getInstance();
      }
      await sharedPreferences.clear();
      _logger.i("Api cache cleared.");
    } catch (e) {
      _logger.d("Something went wrong $e");
    }
  }
}
