import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:felloapp/core/model/golden_ticket_model.dart';
import 'package:felloapp/core/model/journey_models/journey_asset_model.dart';

class MilestoneModel {
  final String id;
  final JourneyAssetModel asset;
  final double dx;
  final double dy;
  final List<Reward> rewards;
  final String description;
  final String actionUri;
  final String animType;
  final bool isCompleted;
  final int page;
  final int level;
  final String aligment; //Left || Right
  final MilestoneShadowModel shadow;
  final bool hFlip;
  final bool vFlip;
  MilestoneModel({
    @required this.id,
    @required this.asset,
    @required this.dx,
    @required this.dy,
    this.rewards,
    @required this.description,
    @required this.actionUri,
    @required this.animType,
    this.isCompleted = false,
    @required this.page,
    @required this.level,
    this.aligment = 'LEFT',
    this.shadow,
    this.hFlip = false,
    this.vFlip = false,
  });

  MilestoneModel copyWith({
    String id,
    JourneyAssetModel asset,
    double dx,
    double dy,
    List<Reward> rewards,
    String description,
    String actionUri,
    String animType,
    bool isCompleted,
    int page,
    int level,
    String aligment,
    MilestoneShadowModel shadow,
    bool hFlip,
    bool vFlip,
  }) {
    return MilestoneModel(
      id: id ?? this.id,
      asset: asset ?? this.asset,
      dx: dx ?? this.dx,
      dy: dy ?? this.dy,
      rewards: rewards ?? this.rewards,
      description: description ?? this.description,
      actionUri: actionUri ?? this.actionUri,
      animType: animType ?? this.animType,
      isCompleted: isCompleted ?? this.isCompleted,
      page: page ?? this.page,
      level: level ?? this.level,
      aligment: aligment ?? this.aligment,
      shadow: shadow ?? this.shadow,
      hFlip: hFlip ?? this.hFlip,
      vFlip: vFlip ?? this.vFlip,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'asset': asset.toMap(),
      'dx': dx,
      'dy': dy,
      'rewards': rewards.map((x) => Reward.toMap(x)).toList(),
      'description': description,
      'actionUri': actionUri,
      'animType': animType,
      'isCompleted': isCompleted,
      // 'page': page,
      'level': level,
      'aligment': aligment,
      'shadow': shadow?.toMap(),
      'hFlip': hFlip,
      'vFlip': vFlip,
    };
  }

  factory MilestoneModel.fromMap(Map<String, dynamic> map) {
    return MilestoneModel(
      id: map['id'],
      asset: JourneyAssetModel.fromMap(map['asset']),
      dx: map['dx']?.toDouble() ?? 0.0,
      dy: map['dy']?.toDouble() ?? 0.0,
      rewards: Reward.objArray(map['rewards']),
      description: map['description'] ?? '',
      actionUri: map['actionUri'] ?? '',
      animType: map['animType'] ?? '',
      isCompleted: map['isCompleted'] ?? false,
      page: map['page']?.toInt() ?? 0,
      level: map['level']?.toInt() ?? 0,
      aligment: map['aligment'] ?? '',
      shadow: MilestoneShadowModel.fromMap(map['shadow']),
      hFlip: map['hFlip'] ?? false,
      vFlip: map['vFlip'] ?? false,
    );
  }

  String toJson() => json.encode(toMap());

  factory MilestoneModel.fromJson(String source) =>
      MilestoneModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'MilestoneModel(id: $id, asset: $asset, dx: $dx, dy: $dy, rewards: $rewards, description: $description, actionUri: $actionUri, animType: $animType, isCompleted: $isCompleted, page: $page, level: $level, aligment: $aligment, shadow: $shadow, hFlip: $hFlip, vFlip: $vFlip)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is MilestoneModel &&
        other.asset == asset &&
        other.dx == dx &&
        other.dy == dy &&
        listEquals(other.rewards, rewards) &&
        other.description == description &&
        other.actionUri == actionUri &&
        other.animType == animType &&
        other.isCompleted == isCompleted &&
        other.page == page &&
        other.level == level &&
        other.aligment == aligment &&
        other.shadow == shadow &&
        other.hFlip == hFlip &&
        other.vFlip == vFlip;
  }

  @override
  int get hashCode {
    return asset.hashCode ^
        dx.hashCode ^
        dy.hashCode ^
        rewards.hashCode ^
        description.hashCode ^
        actionUri.hashCode ^
        animType.hashCode ^
        isCompleted.hashCode ^
        page.hashCode ^
        level.hashCode ^
        aligment.hashCode ^
        shadow.hashCode ^
        hFlip.hashCode ^
        vFlip.hashCode;
  }
}

class MilestoneShadowModel {
  final String id;
  final JourneyAssetModel asset;
  final double dx, dy;
  final String animType;
  final bool isCompleted;
  final int page;
  final int level;
  final bool aligment;
  final bool hFlip, vFlip;
  MilestoneShadowModel({
    @required this.id,
    @required this.asset,
    @required this.dy,
    @required this.dx,
    this.animType = "none",
    this.isCompleted = false,
    @required this.page,
    @required this.level,
    this.aligment = true,
    this.vFlip = false,
    this.hFlip = false,
  });

  MilestoneShadowModel copyWith({
    String id,
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
      id: id ?? this.id,
      asset: asset ?? this.asset,
      dy: dy ?? this.dy,
      dx: dx ?? this.dx,
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
      'id': id,
      'asset': asset.toMap(),
      'dy': dy,
      'dx': dx,
      'animType': animType,
      'isCompleted': isCompleted,
      // 'page': page,
      'level': level,
      'aligment': aligment,
      'vFlip': vFlip,
      'hFlip': hFlip
    };
  }

  factory MilestoneShadowModel.fromMap(Map<String, dynamic> map) {
    return MilestoneShadowModel(
      id: map['id'] ?? '',
      asset: map['asset'] ?? '',
      dy: map['dy'],
      dx: map['dx'],
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
    return 'MilestoneShadowModel(id: $id, asset: $asset, dy: $dy, animType: $animType, isCompleted: $isCompleted, page: $page, level: $level, aligment: $aligment, vFlip: $vFlip, hFlip: $hFlip)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is MilestoneShadowModel &&
        other.asset == asset &&
        other.dy == dy &&
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
        animType.hashCode ^
        isCompleted.hashCode ^
        page.hashCode ^
        level.hashCode ^
        aligment.hashCode ^
        vFlip.hashCode;
  }
}
