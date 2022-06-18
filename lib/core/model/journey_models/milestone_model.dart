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
  final bool aligment; //Left || Right
  MilestoneModel({
    this.asset,
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
    this.aligment,
  });

  MilestoneModel copyWith({
    String asset,
    double dx,
    dy,
    double width,
    height,
    List<Reward> rewards,
    String description,
    String route,
    String assetType,
    String animType,
    bool isCompleted,
    int page,
    bool aligment,
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
      aligment: aligment ?? this.aligment,
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
      'aligment': aligment,
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
      aligment: map['aligment'] ?? false,
    );
  }

  String toJson() => json.encode(toMap());

  factory MilestoneModel.fromJson(String source) =>
      MilestoneModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'MilestoneModel(asset: $asset, dy: $dy, height: $height, rewards: $rewards, description: $description, route: $route, assetType: $assetType, animType: $animType, isCompleted: $isCompleted, page: $page, aligment: $aligment)';
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
