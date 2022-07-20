import 'dart:convert';

import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

import '../../util/api_response.dart';
import '../../util/custom_logger.dart';
import '../../util/locator.dart';
import '../model/cache_model/cache_model.dart';

class CacheService {
  static Isar _isar;
  final _logger = locator<CustomLogger>();

  static Future<void> initialize() async {
    if (_isar == null) {
      final dir = await getApplicationSupportDirectory();
      _isar = await Isar.open(
        schemas: [CacheModelSchema],
        directory: dir.path,
      );
    }
  }

  Future<void> invalidateAll() async {
    try {
      _logger.d('cache: invalidate all');
      await _isar.writeTxn((i) async {
        await i.clear();
      });
    } catch (e) {
      _logger.e('cache: invalidation failed $e');
    }
  }

  Future<ApiResponse> cachedApi(
    String key,
    int ttl,
    Future<dynamic> Function() apiReq,
    ApiResponse Function(dynamic) parseData,
  ) async {
    final cachedData = await getData(key);

    if (cachedData != null) {
      try {
        _logger.d('cache: data read successfully');
        return parseData(json.decode(cachedData.data));
      } catch (e) {
        _logger.e(
            'cache: parsing saved cache failed, trying to fetch from API', e);
        await invalidateByKey(key);
        return await _processApiAndSaveToCache(
          key,
          ttl,
          apiReq,
          parseData,
        );
      }
    }

    return await _processApiAndSaveToCache(key, ttl, apiReq, parseData);
  }

  Future<ApiResponse> _processApiAndSaveToCache(
    String key,
    int ttl,
    Future<dynamic> Function() apiReq,
    ApiResponse Function(dynamic) parseData,
  ) async {
    final response = await apiReq();
    final res = parseData(response);

    if (response != null &&
        response['data'] != null &&
        response['data'].isNotEmpty) await writeMap(key, ttl, response);

    return res;
  }

  Future<bool> writeMap(String key, int ttl, Map data) async {
    return writeString(key, ttl, json.encode(data));
  }

  Future<bool> writeString(String key, int ttl, String data) async {
    try {
      final now = DateTime.now().millisecondsSinceEpoch;
      final cache = new CacheModel(
        key: key,
        ttl: ttl,
        expireAfterTimestamp: now + (ttl * 60 * 1000),
        data: data,
      );
      _logger.d('cache: write $cache');
      await _isar.writeTxn((i) async {
        final id = await i.cacheModels.put(cache);
        _logger.d('cache: write id $id');
      });

      return true;
    } catch (e) {
      _logger.e('cache: writing to cache failed', e);
      return false;
    }
  }

  Future<bool> invalidateByKey(String key) async {
    try {
      _logger.d('cache: invalidating key $key');

      await _isar.writeTxn((i) async {
        final data = await i.cacheModels.filter().keyEqualTo(key).findAll();
        _logger.d('cache: $data');

        final c = await i.cacheModels.deleteAll(data.map((e) => e.id).toList());
        _logger.d('cache: invalidated $c');
      });

      return true;
    } catch (e) {
      _logger.e('cache: invalidation for key $key failed $e');
      return false;
    }
  }

  Future<bool> _invalidate(int id) async {
    try {
      _logger.d('cache: invalidating id $id');

      await _isar.writeTxn((i) async {
        return await i.cacheModels.delete(id);
      });

      return true;
    } catch (e) {
      _logger.e('cache: invalidation for id $id failed', e);
      return false;
    }
  }

  Future<CacheModel> getData(String key) async {
    final data = await _isar.cacheModels.filter().keyEqualTo(key).findFirst();
    final now = DateTime.now().millisecondsSinceEpoch;

    if (data != null) {
      _logger.d(
          'cache: data read from cache ${data.id} ${data.key} ${data.expireAfterTimestamp} $now');

      if (data.expireAfterTimestamp > now) {
        return data;
      } else {
        await invalidateByKey(key);
      }
    }

    return null;
  }
}
