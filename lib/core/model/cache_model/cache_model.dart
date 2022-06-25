import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:isar/isar.dart';

part 'cache_model.g.dart';

@Collection()
class CacheModel {
  @Id()
  int id = Isar.autoIncrement;

  final String key;
  final int ttl;
  final int expireAfterTimestamp;
  final String data;

  CacheModel({
    this.id,
    @required this.key,
    @required this.ttl,
    @required this.expireAfterTimestamp,
    @required this.data,
  });

  CacheModel copyWith({
    int id,
    String key,
    int ttl,
    int expireAfterTimestamp,
    String data,
  }) {
    return CacheModel(
      id: id ?? this.id,
      key: key ?? this.key,
      ttl: ttl ?? this.ttl,
      expireAfterTimestamp: expireAfterTimestamp ?? this.expireAfterTimestamp,
      data: data ?? this.data,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'key': key,
      'ttl': ttl,
      'expireAfterTimestamp': expireAfterTimestamp,
      'data': data,
    };
  }

  factory CacheModel.fromMap(Map<String, dynamic> map) {
    return CacheModel(
      id: map['id']?.toInt() ?? 0,
      key: map['key'] ?? '',
      ttl: map['ttl']?.toInt() ?? 0,
      expireAfterTimestamp: map['expireAfterTimestamp']?.toInt() ?? 0,
      data: map['data'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory CacheModel.fromJson(String source) =>
      CacheModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'CacheModel(id: $id, key: $key, ttl: $ttl, expireAfterTimestamp: $expireAfterTimestamp, data: $data)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CacheModel &&
        other.id == id &&
        other.key == key &&
        other.ttl == ttl &&
        other.expireAfterTimestamp == expireAfterTimestamp &&
        other.data == data;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        key.hashCode ^
        ttl.hashCode ^
        expireAfterTimestamp.hashCode ^
        data.hashCode;
  }
}
