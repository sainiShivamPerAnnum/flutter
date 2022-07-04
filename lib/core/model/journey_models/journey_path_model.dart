import 'dart:convert';

import 'package:felloapp/core/model/journey_models/journey_asset_model.dart';
import 'package:flutter/material.dart';

class JourneyPathModel {
  final String id;
  final JourneyAssetModel asset;
  final String alignment; //Left || Right
  final double dx;
  final double dy;
  final bool isBase;
  final bool hFlip;
  final bool vFlip;
  final int dz;
  final int page;
  final int level;
  JourneyPathModel({
    @required this.id,
    @required this.asset,
    this.alignment = "LEFT",
    @required this.dx,
    @required this.dy,
    this.isBase = false,
    this.hFlip = false,
    this.vFlip = false,
    @required this.dz,
    @required this.page,
    @required this.level,
  });

  JourneyPathModel copyWith({
    String id,
    JourneyAssetModel asset,
    String alignment,
    double dx,
    double dy,
    bool isBase,
    bool hFlip,
    bool vFlip,
    int dz,
    int page,
    int level,
  }) {
    return JourneyPathModel(
      id: id ?? this.id,
      asset: asset ?? this.asset,
      alignment: alignment ?? this.alignment,
      dx: dx ?? this.dx,
      dy: dy ?? this.dy,
      isBase: isBase ?? this.isBase,
      hFlip: hFlip ?? this.hFlip,
      vFlip: vFlip ?? this.vFlip,
      dz: dz ?? this.dz,
      page: page ?? this.page,
      level: level ?? this.level,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'asset': asset.toMap(),
      'alignment': alignment,
      'dx': dx,
      'dy': dy,
      'isBase': isBase,
      'hFlip': hFlip,
      'vFlip': vFlip,
      'dz': dz,
      // 'page': page,
      'level': level,
    };
  }

  factory JourneyPathModel.fromMap(Map<String, dynamic> map) {
    return JourneyPathModel(
      id: map['id'],
      asset: JourneyAssetModel.fromMap(map['asset']),
      alignment: map['alignment'] ?? '',
      dx: map['dx']?.toDouble() ?? 0.0,
      dy: map['dy']?.toDouble() ?? 0.0,
      isBase: map['isBase'] ?? false,
      hFlip: map['hFlip'] ?? false,
      vFlip: map['vFlip'] ?? false,
      dz: map['dz']?.toInt() ?? 0,
      page: map['page']?.toInt() ?? 0,
      level: map['level']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory JourneyPathModel.fromJson(String source) =>
      JourneyPathModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'JourneyPathModel(id: $id, asset: $asset, alignment: $alignment, dx: $dx, dy: $dy, isBase: $isBase, hFlip: $hFlip, vFlip: $vFlip, dz: $dz, page: $page, level: $level)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is JourneyPathModel &&
        other.asset == asset &&
        other.alignment == alignment &&
        other.dx == dx &&
        other.dy == dy &&
        other.isBase == isBase &&
        other.hFlip == hFlip &&
        other.vFlip == vFlip &&
        other.dz == dz &&
        other.page == page &&
        other.level == level;
  }

  @override
  int get hashCode {
    return asset.hashCode ^
        alignment.hashCode ^
        dx.hashCode ^
        dy.hashCode ^
        isBase.hashCode ^
        hFlip.hashCode ^
        vFlip.hashCode ^
        dz.hashCode ^
        page.hashCode ^
        level.hashCode;
  }
}
