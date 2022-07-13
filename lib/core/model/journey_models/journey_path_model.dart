import 'dart:convert';

import 'package:felloapp/core/model/journey_models/journey_asset_model.dart';
import 'package:flutter/material.dart';

class JourneyPathModel {
  final String id;
  final JourneyAssetModel asset;
  final double x;
  final double y;
  final bool isBase;
  final bool hFlip;
  final bool vFlip;
  final int z;
  final int page;
  final int mlIndex;
  JourneyPathModel({
    @required this.id,
    @required this.asset,
    @required this.x,
    @required this.y,
    this.isBase = false,
    this.hFlip = false,
    this.vFlip = false,
    @required this.z,
    @required this.page,
    @required this.mlIndex,
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
      x: dx ?? this.x,
      y: dy ?? this.y,
      isBase: isBase ?? this.isBase,
      hFlip: hFlip ?? this.hFlip,
      vFlip: vFlip ?? this.vFlip,
      z: dz ?? this.z,
      page: page ?? this.page,
      mlIndex: level ?? this.mlIndex,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'x': x,
      'y': y,
      'z': z,
      'isBase': isBase ?? false,
      'assetRef': asset.name,
      'mlIndex': mlIndex,
      'hFlip': hFlip ?? false,
    };
  }

  factory JourneyPathModel.fromMap(Map<String, dynamic> map, int page) {
    return JourneyPathModel(
      x: map['x']?.toDouble() ?? 0.0,
      y: map['y']?.toDouble() ?? 0.0,
      z: map['z']?.toInt() ?? 0,
      isBase: map['isBase'] ?? false,
      mlIndex: map['level']?.toInt() ?? 0,
      hFlip: map['hFlip'] ?? false,
      id: map['id'],
      asset: JourneyAssetModel.fromMap(map['asset']),
      page: page ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory JourneyPathModel.fromJson(String source, int page) =>
      JourneyPathModel.fromMap(json.decode(source), page);

  @override
  String toString() {
    return 'JourneyPathModel(id: $id, asset: $asset, dx: $x, dy: $y, isBase: $isBase, hFlip: $hFlip, vFlip: $vFlip, dz: $z, page: $page, level: $mlIndex)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is JourneyPathModel &&
        other.asset == asset &&
        other.x == x &&
        other.y == y &&
        other.isBase == isBase &&
        other.hFlip == hFlip &&
        other.vFlip == vFlip &&
        other.z == z &&
        other.page == page &&
        other.mlIndex == mlIndex;
  }

  @override
  int get hashCode {
    return asset.hashCode ^
        x.hashCode ^
        y.hashCode ^
        isBase.hashCode ^
        hFlip.hashCode ^
        vFlip.hashCode ^
        z.hashCode ^
        page.hashCode ^
        mlIndex.hashCode;
  }
}
