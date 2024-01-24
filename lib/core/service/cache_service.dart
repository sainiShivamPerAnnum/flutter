import 'dart:convert';
import 'dart:developer';

import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/enums/app_config_keys.dart';
import 'package:felloapp/core/enums/ttl.dart';
import 'package:felloapp/core/model/app_config_model.dart';
import 'package:felloapp/core/model/cache_model/story_model.dart';
import 'package:felloapp/util/date_helper.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

import '../../util/api_response.dart';
import '../../util/custom_logger.dart';
import '../../util/locator.dart';
import '../model/cache_model/cache_model.dart';

/// Signature callback for parsing and converting source [S] to [ApiResponse] of
/// type [T].
typedef ParseCallBack<T, S> = ApiResponse<T> Function(S);

class LocalDbService {
  LocalDbService();
  Isar? _isar;

  Isar get isar {
    assert(_isar != null, 'Service must be initialized');
    return _isar!;
  }

  Future<void> initialize() async {
    try {
      final dir = await getApplicationSupportDirectory();
      _isar = await Isar.open(
        [CacheModelSchema, StoryCollectionSchema],
        directory: dir.path,
      );
    } catch (e) {
      BaseUtil.showNegativeAlert(
        "Isar initialization failed",
        e.toString(),
        seconds: 20,
      );
      log("ISAR:: Unable to initialize isar");
    }
  }
}

class CacheService {
  final CustomLogger _logger = locator<CustomLogger>();
  static final _db = locator<LocalDbService>();

  static Future<void> checkIfInvalidationRequired() async {
    final now = DateTime.now().millisecondsSinceEpoch;
    final invalidate = AppConfig.getValue<int>(AppConfigKey.invalidateBefore);
    if (now <= invalidate) {
      await CacheService.invalidateAll();
    }
  }

  static Future<void> invalidateAll() async {
    final CustomLogger logger = locator<CustomLogger>();

    try {
      logger.d('cache: invalidate all');
      await _db.isar.writeTxn(() async {
        await _db.isar.clear();
      });
    } catch (e) {
      logger.e('cache: invalidation failed $e');
    }
  }

  Future<ApiResponse<T>> cachedApi<T>(
    String key,
    int ttl,
    Future<dynamic> Function() apiReq,
    ParseCallBack<T, dynamic> parseData, {
    bool isFromCdn = false,
  }) async {
    final cachedData = await getData(key);

    if (cachedData != null && ttl != 0) {
      try {
        _logger.d('cache: data read successfully');
        log("CACHED API: ${cachedData.data!}");
        return parseData(json.decode(cachedData.data!));
      } catch (e) {
        _logger.e(
            'cache: parsing saved cache failed, trying to fetch from API', e);
        await invalidateByKey(key);
        return await _processApiAndSaveToCache(
          key,
          ttl,
          apiReq,
          parseData,
          isFromCdn: isFromCdn,
        );
      }
    }
    return await _processApiAndSaveToCache(
      key,
      ttl,
      apiReq,
      parseData,
      isFromCdn: isFromCdn,
    );
  }

  Future<ApiResponse<T>> _processApiAndSaveToCache<T, S>(
    String key,
    int ttl,
    Future<dynamic> Function() apiReq,
    ParseCallBack<T, dynamic> parseData, {
    bool isFromCdn = false,
  }) async {
    final response = await apiReq();

    final res = parseData(response);
    try {
      if (isFromCdn) {
        if (response != null) await writeMap(key, ttl, response);
      } else if (response != null &&
          response['data'] != null &&
          response['data'].isNotEmpty &&
          ttl != 0) {
        await writeMap(key, ttl, response);
      }
    } catch (e) {
      _logger
          .d("Writing to isar failed, returning data directly without caching");
    }

    return res;
  }

  Future<bool> writeMap(String key, int ttl, Object data) async {
    return writeString(key, ttl, json.encode(data));
  }

  Future<bool> writeString(String key, int ttl, String data) async {
    try {
      final now = DateTime.now().millisecondsSinceEpoch;
      final cache = CacheModel(
        key: key,
        ttl: ttl,
        expireAfterTimestamp: now +
            (ttl == TTL.UPTO_SIX_PM
                ? DateHelper.getMillisecondsTillNextSixPm()
                : (ttl * 60 * 1000)),
        data: data,
      );
      _logger.d('cache: write $cache');
      await _db.isar.writeTxn(() async {
        final id = await _db.isar.cacheModels.put(cache);
        _logger.d('cache: write id $id');
      });

      return true;
    } catch (e) {
      _logger.e('cache: writing to cache failed', e);
      return false;
    }
  }

  static Future<bool> invalidateByKey(String key) async {
    final CustomLogger logger = locator<CustomLogger>();

    try {
      logger.d('cache: invalidating key $key');
      await _db.isar.writeTxn(() async {
        final List<CacheModel> data = await _db.isar
            .collection<CacheModel>()
            .filter()
            .keyEqualTo(key)
            .findAll();

        if (data.isEmpty) return;

        logger.d('cache: $data');

        final c = await _db.isar
            .collection<CacheModel>()
            .deleteAll(data.map((e) => e.id).toList());
        logger.d('cache: invalidated $c');
      });

      return true;
    } catch (e) {
      logger.e('cache: invalidation for key $key failed $e');
      return false;
    }
  }

  Future<CacheModel?> getData(String key) async {
    try {
      final data =
          await _db.isar.cacheModels.filter().keyEqualTo(key).findFirst();

      if (data == null) return null;

      final now = DateTime.now().millisecondsSinceEpoch;

      _logger.d(
          'cache: data read from cache ${data.id} ${data.key} ${data.expireAfterTimestamp} $now');

      if (data.expireAfterTimestamp! > now) {
        return data;
      } else {
        await invalidateByKey(key);
      }
    } catch (e) {
      return null;
    }

    return null;
  }

  Future<ApiResponse<T>> paginatedCachedApi<T>(
    String keyPrefix,
    int start,
    int end,
    int ttl,
    Future<dynamic> Function() apiReq,
    ParseCallBack<T, dynamic> parseData,
  ) async {
    // fetch data from cache
    final items = [];
    for (int i = start; i <= end; i++) {
      final key = '$keyPrefix/$i';
      final cachedData = await getData(key);
      if (cachedData != null && ttl != 0) {
        items.add(json.decode(cachedData.data!));
      }
    }

    if (items.length == end - start + 1) {
      try {
        _logger.d('cache: paginated data read successfully $items');
        return parseData({"start": start, "end": end, "items": items});
      } catch (e) {
        _logger.e(
            'cache: parsing saved cache failed, trying to fetch from API', e);

        // invalidate all keys
        for (int i = start; i <= end; i++) {
          final key = '$keyPrefix/$i';
          await invalidateByKey(key);
        }

        return await _processPaginatedApiAndSaveToCache(
          keyPrefix,
          ttl,
          apiReq,
          parseData,
        );
      }
    }

    return await _processPaginatedApiAndSaveToCache(
      keyPrefix,
      ttl,
      apiReq,
      parseData,
    );
  }

  Future<ApiResponse<T>> _processPaginatedApiAndSaveToCache<T>(
    String keyPrefix,
    int ttl,
    Future<dynamic> Function() apiReq,
    ParseCallBack<T, dynamic> parseData,
  ) async {
    final response = await apiReq();
    final responseData = response['data'];
    final res = parseData(responseData);
    List<dynamic>? items = responseData["items"];

    if (responseData != null &&
        responseData.isNotEmpty &&
        ttl != 0 &&
        items!.isNotEmpty) {
      final start = responseData["start"];
      final end = responseData["end"];
      List<dynamic>? items = responseData["items"];

      for (int i = start; i <= end; i++) {
        final key = '$keyPrefix/$i';
        await writeMap(key, ttl, items![i - start as int]);
      }
    }

    return res;
  }
}
