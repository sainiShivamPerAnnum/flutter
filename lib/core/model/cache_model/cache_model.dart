import 'package:flutter/foundation.dart';
import 'package:isar/isar.dart';

part 'cache_model.g.dart';

@Collection()
class CacheModel {
  Id id = Isar.autoIncrement;

  final String? key;
  final int? ttl;
  final int? expireAfterTimestamp;
  final String? data;

  CacheModel({
    @required this.key,
    @required this.ttl,
    @required this.expireAfterTimestamp,
    @required this.data,
  });

  @override
  String toString() {
    return 'CacheModel(id: $id, key: $key, ttl: $ttl, expireAfterTimestamp: $expireAfterTimestamp, data: $data)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CacheModel &&
        other.key == key &&
        other.ttl == ttl &&
        other.expireAfterTimestamp == expireAfterTimestamp &&
        other.data == data;
  }

  @override
  int get hashCode {
    return key.hashCode ^
        ttl.hashCode ^
        expireAfterTimestamp.hashCode ^
        data.hashCode;
  }
}
