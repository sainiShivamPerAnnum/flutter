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

  Future<ApiResponse> cachedApi(
    String key,
    int ttl,
    Future<dynamic> Function() apiReq,
    ApiResponse Function(dynamic) parseData,
  ) async {
    final cachedData = await _getData(key, ttl);

    if (cachedData != null) {
      try {
        _logger.d('data read from cache successfully');
        return parseData(json.decode(cachedData.data));
      } catch (e) {
        _logger.e('parsing saved cache failed, trying to fetch from API', e);
        _delete(cachedData.id);
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
    await _write(key, ttl, response);

    return res;
  }

  Future<bool> _write(String key, int ttl, Map data) async {
    try {
      final cache = new CacheModel(
        key: key,
        ttl: ttl,
        expireAfterTimestamp:
            DateTime.now().millisecondsSinceEpoch + ttl * 60 * 1000,
        data: json.encode(data),
      );
      _logger.d('write $cache');
      await _isar.writeTxn((i) async {
        final id = await i.cacheModels.put(cache);
        _logger.d('write id $id');
      });

      return true;
    } catch (e) {
      _logger.e('writing to cache failed', e);
      return false;
    }
  }

  Future<bool> _delete(int id) async {
    try {
      await _isar.writeTxn((i) async {
        return await i.cacheModels.delete(id);
      });

      return true;
    } catch (e) {
      _logger.e('writing to cache failed', e);
      return false;
    }
  }

  Future<CacheModel> _getData(String key, int ttl) async {
    final data = await _isar.cacheModels.filter().keyEqualTo(key).findFirst();
    _logger.d('data read from cache $data');

    if (data != null &&
        data.expireAfterTimestamp < DateTime.now().millisecondsSinceEpoch) {
      return data;
    }

    return null;
  }
}
