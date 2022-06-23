import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:felloapp/core/model/golden_ticket_model.dart';

class MilestoneModel {
  final String asset;
  final double dx, dy;
  final double width, height;
  final List<Reward> rewards;
  final String description;
  final String route;
  final String assetType;
  final String animType;
  final bool isCompleted;
  final int page;
  final int level;
  final bool aligment; //Left || Right
  final MilestoneShadowModel shadow;
  final bool hFlip, vFlip;

  MilestoneModel(
      {this.asset,
      this.dy,
      this.dx,
      this.height,
      this.width,
      this.rewards,
      this.description,
      this.route,
      this.assetType,
      this.animType,
      this.isCompleted = false,
      this.page,
      this.level,
      this.aligment,
      this.vFlip,
      this.hFlip,
      this.shadow});

  MilestoneModel copyWith({
    String asset,
    double dx,
    dy,
    double width,
    height,
    int level,
    List<Reward> rewards,
    String description,
    String route,
    String assetType,
    String animType,
    bool isCompleted,
    int page,
    bool aligment,
    MilestoneShadowModel shadow,
    bool hFlip,
    bool vFlip,
  }) {
    return MilestoneModel(
      asset: asset ?? this.asset,
      dy: dy ?? this.dy,
      height: height ?? this.height,
      rewards: rewards ?? this.rewards,
      description: description ?? this.description,
      route: route ?? this.route,
      assetType: assetType ?? this.assetType,
      animType: animType ?? this.animType,
      isCompleted: isCompleted ?? this.isCompleted,
      page: page ?? this.page,
      level: level ?? this.level,
      aligment: aligment ?? this.aligment,
      shadow: shadow ?? this.shadow,
      vFlip: vFlip ?? this.vFlip,
      hFlip: hFlip ?? this.hFlip,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'asset': asset,
      'dy': dy,
      'height': height,
      'rewards': rewards.map((x) => Reward.toMap(x)).toList(),
      'description': description,
      'route': route,
      'assetType': assetType,
      'animType': animType,
      'isCompleted': isCompleted,
      'page': page,
      'level': level,
      'aligment': aligment,
      'shadow': shadow,
      'vFlip': vFlip,
      'hFlip': hFlip
    };
  }

  factory MilestoneModel.fromMap(Map<String, dynamic> map) {
    return MilestoneModel(
      asset: map['asset'] ?? '',
      dy: map['dy'] ?? 0.0,
      dx: map['dx'] ?? 0.0,
      height: map['height'] ?? 0.0,
      width: map['width'] ?? 0.0,
      rewards:
          List<Reward>.from(map['rewards']?.map((x) => Reward.fromJson(x))),
      description: map['description'] ?? '',
      route: map['route'] ?? '',
      assetType: map['assetType'] ?? '',
      animType: map['animType'] ?? '',
      isCompleted: map['isCompleted'] ?? false,
      page: map['page']?.toInt() ?? 0,
      level: map['level']?.toInt() ?? 0,
      aligment: map['aligment'] ?? false,
      shadow: map['shadow'],
      vFlip: map['vFlip'] ?? false,
      hFlip: map['hFlip'] ?? false,
    );
  }

  String toJson() => json.encode(toMap());

  factory MilestoneModel.fromJson(String source) =>
      MilestoneModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'MilestoneModel(asset: $asset, dy: $dy, height: $height, rewards: $rewards, description: $description, route: $route, assetType: $assetType, animType: $animType, isCompleted: $isCompleted, page: $page, level: $level, aligment: $aligment, shadow: ${shadow.toString()}, vFlip: $vFlip, hFlip: $hFlip)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is MilestoneModel &&
        other.asset == asset &&
        other.dy == dy &&
        other.height == height &&
        listEquals(other.rewards, rewards) &&
        other.description == description &&
        other.route == route &&
        other.assetType == assetType &&
        other.animType == animType &&
        other.isCompleted == isCompleted &&
        other.page == page &&
        other.aligment == aligment;
  }

  @override
  int get hashCode {
    return asset.hashCode ^
        dy.hashCode ^
        height.hashCode ^
        rewards.hashCode ^
        description.hashCode ^
        route.hashCode ^
        assetType.hashCode ^
        animType.hashCode ^
        isCompleted.hashCode ^
        page.hashCode ^
        aligment.hashCode;
  }
}

class MilestoneShadowModel {
  final String asset;
  final double dx, dy;
  final double width, height;
  final String animType;
  final bool isCompleted;
  final int page;
  final int level;
  final bool aligment;
  final bool hFlip, vFlip;
  MilestoneShadowModel({
    @required this.asset,
    @required this.dy,
    @required this.dx,
    @required this.height,
    @required this.width,
    this.animType = "none",
    this.isCompleted = false,
    @required this.page,
    @required this.level,
    this.aligment = true,
    this.vFlip = false,
    this.hFlip = false,
  });

  MilestoneShadowModel copyWith({
    String asset,
    double dx,
    dy,
    double width,
    height,
    String animType,
    bool isCompleted,
    int page,
    int level,
    bool aligment,
    bool hFlip,
    bool vFlip,
  }) {
    return MilestoneShadowModel(
      asset: asset ?? this.asset,
      dy: dy ?? this.dy,
      dx: dx ?? this.dx,
      height: height ?? this.height,
      width: width ?? this.width,
      animType: animType ?? this.animType,
      isCompleted: isCompleted ?? this.isCompleted,
      page: page ?? this.page,
      level: level ?? this.level,
      aligment: aligment ?? this.aligment,
      vFlip: vFlip ?? this.vFlip,
      hFlip: hFlip ?? this.hFlip,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'asset': asset,
      'dy': dy,
      'dx': dx,
      'width': width,
      'height': height,
      'animType': animType,
      'isCompleted': isCompleted,
      'page': page,
      'level': level,
      'aligment': aligment,
      'vFlip': vFlip,
      'hFlip': hFlip
    };
  }

  factory MilestoneShadowModel.fromMap(Map<String, dynamic> map) {
    return MilestoneShadowModel(
      asset: map['asset'] ?? '',
      dy: double.tryParse(map['dy']),
      dx: double.tryParse(map['dx']),
      height: double.tryParse(map['height']),
      width: double.tryParse(map['width']),
      animType: map['animType'] ?? '',
      isCompleted: map['isCompleted'] ?? false,
      page: map['page']?.toInt() ?? 0,
      level: map['level']?.toInt() ?? 0,
      aligment: map['aligment'] ?? false,
      vFlip: map['vFlip'] ?? false,
      hFlip: map['hFlip'] ?? false,
    );
  }

  String toJson() => json.encode(toMap());

  factory MilestoneShadowModel.fromJson(String source) =>
      MilestoneShadowModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'MilestoneShadowModel(asset: $asset, dy: $dy, height: $height, animType: $animType, isCompleted: $isCompleted, page: $page, level: $level, aligment: $aligment, vFlip: $vFlip, hFlip: $hFlip)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is MilestoneShadowModel &&
        other.asset == asset &&
        other.dy == dy &&
        other.height == height &&
        other.animType == animType &&
        other.isCompleted == isCompleted &&
        other.page == page &&
        other.level == level &&
        other.aligment == aligment &&
        other.vFlip == vFlip;
  }

  @override
  int get hashCode {
    return asset.hashCode ^
        dy.hashCode ^
        height.hashCode ^
        animType.hashCode ^
        isCompleted.hashCode ^
        page.hashCode ^
        level.hashCode ^
        aligment.hashCode ^
        vFlip.hashCode;
  }
}
