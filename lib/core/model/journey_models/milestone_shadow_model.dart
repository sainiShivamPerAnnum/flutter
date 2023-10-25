import 'dart:convert';
import 'package:felloapp/core/model/journey_models/journey_asset_model.dart';

class MilestoneShadowModel {
  final String id;
  final String name;
  final JourneyAssetModel asset;
  final double? x, y;
  final String animType;
  final bool isCompleted;
  final int page;
  final int index;
  final bool hFlip, vFlip;
  MilestoneShadowModel({
    required this.id,
    required this.name,
    required this.asset,
    required this.y,
    required this.x,
    required this.page,
    required this.index,
    this.animType = "none",
    this.isCompleted = false,
    this.vFlip = false,
    this.hFlip = false,
  });

  MilestoneShadowModel copyWith({
    String? id,
    JourneyAssetModel? asset,
    double? dx,
    String? name,
    dy,
    double? width,
    height,
    String? animType,
    bool? isCompleted,
    int? page,
    int? level,
    bool? aligment,
    bool? hFlip,
    bool? vFlip,
  }) {
    return MilestoneShadowModel(
      id: id ?? this.id,
      name: name ?? this.name,
      asset: asset ?? this.asset,
      y: dy ?? y,
      x: dx ?? x,
      animType: animType ?? this.animType,
      isCompleted: isCompleted ?? this.isCompleted,
      page: page ?? this.page,
      index: level ?? index,
      vFlip: vFlip ?? this.vFlip,
      hFlip: hFlip ?? this.hFlip,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      // 'id': id,
      'name': name,
      'asset': asset.toMap(),
      'dy': y,
      'dx': x,
      'animType': animType,
      'isCompleted': isCompleted,
      // 'page': page,
      'level': index,
      'vFlip': vFlip,
      'hFlip': hFlip
    };
  }

  factory MilestoneShadowModel.fromMap(
      Map<String, dynamic> map, Map<String, dynamic> parentMap, int page) {
    return MilestoneShadowModel(
      id: map['id'] ?? '',
      x: map['x'],
      y: map['y'],
      name: map['assetRef'] ?? '',
      asset: JourneyAssetModel.fromMap(map['asset'], page),
      animType: parentMap['animType'] ?? '',
      isCompleted: parentMap['isCompleted'] ?? false,
      page: page ?? 0,
      index: parentMap['index']?.toInt() ?? 0,
      hFlip: parentMap['hFlip'] ?? false,
    );
  }

  String toJson() => json.encode(toMap());

  factory MilestoneShadowModel.fromJson(
          String source, Map<String, dynamic> map, int page) =>
      MilestoneShadowModel.fromMap(json.decode(source), map, page);

  @override
  String toString() {
    return 'MilestoneShadowModel(id: $id, asset: $asset, name: $name, dy: $y, animType: $animType, isCompleted: $isCompleted, page: $page, level: $index, vFlip: $vFlip, hFlip: $hFlip)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is MilestoneShadowModel &&
        other.asset == asset &&
        other.y == y &&
        other.animType == animType &&
        other.isCompleted == isCompleted &&
        other.page == page &&
        other.index == index &&
        other.vFlip == vFlip;
  }

  @override
  int get hashCode {
    return asset.hashCode ^
        y.hashCode ^
        animType.hashCode ^
        isCompleted.hashCode ^
        page.hashCode ^
        index.hashCode ^
        vFlip.hashCode;
  }
}
