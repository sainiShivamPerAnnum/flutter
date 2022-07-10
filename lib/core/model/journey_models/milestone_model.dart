// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:felloapp/core/model/golden_ticket_model.dart';
import 'package:felloapp/core/model/journey_models/journey_asset_model.dart';
import 'package:felloapp/core/model/journey_models/milestone_description.dart';

class MilestoneModel {
  final String id;
  final JourneyAssetModel asset;
  final double x;
  final double y;
  List<Reward> rewards;
  final List<MlSteps> steps;
  final String actionUri;
  final String animType;
  final String tooltip;
  bool isCompleted;
  final String prizeSubType;
  final int page;
  final int index;
  final MilestoneShadowModel shadow;
  final bool hFlip;
  final bool vFlip;
  MilestoneModel({
    this.id,
    @required this.asset,
    @required this.x,
    @required this.y,
    this.rewards,
    this.tooltip,
    this.prizeSubType,
    @required this.steps,
    @required this.actionUri,
    this.animType = "NONE",
    this.isCompleted,
    @required this.page,
    @required this.index,
    this.shadow,
    this.hFlip = false,
    this.vFlip = false,
  });

  MilestoneModel copyWith({
    String id,
    JourneyAssetModel asset,
    double x,
    double y,
    List<Reward> rewards,
    List<MlSteps> description,
    String actionUri,
    String animType,
    String tooltip,
    bool isCompleted,
    String prizeSubType,
    int page,
    int mlIndex,
    MilestoneShadowModel shadow,
    bool hFlip,
    bool vFlip,
  }) {
    return MilestoneModel(
      id: id ?? this.id,
      asset: asset ?? this.asset,
      x: x ?? this.x,
      y: y ?? this.y,
      rewards: rewards ?? this.rewards,
      steps: description ?? this.steps,
      actionUri: actionUri ?? this.actionUri,
      animType: animType ?? this.animType,
      tooltip: tooltip ?? this.tooltip,
      isCompleted: isCompleted ?? this.isCompleted,
      prizeSubType: prizeSubType ?? this.prizeSubType,
      page: page ?? this.page,
      index: mlIndex ?? this.index,
      shadow: shadow ?? this.shadow,
      hFlip: hFlip ?? this.hFlip,
      vFlip: vFlip ?? this.vFlip,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'asset': asset.toMap(),
      'x': x,
      'y': y,
      'rewards': rewards.map((x) => x.toMap()).toList(),
      'description': steps.map((x) => x.toMap()).toList(),
      'actionUri': actionUri,
      'animType': animType,
      'isCompleted': isCompleted,
      'tooltip': tooltip,
      'prizeSubType': prizeSubType,
      'page': page,
      'mlIndex': index,
      'shadow': shadow.toMap(),
      'hFlip': hFlip,
      'vFlip': vFlip,
    };
  }

  factory MilestoneModel.fromMap(Map<String, dynamic> map) {
    return MilestoneModel(
      id: map['id'] as String,
      asset: JourneyAssetModel.fromMap(map['asset'] as Map<String, dynamic>),
      x: map['x'] as double,
      y: map['y'] as double,
      rewards: List<Reward>.from(
        (map['rewards'] as List<int>).map<Reward>(
          (x) => Reward.fromMap(x as Map<String, dynamic>),
        ),
      ),
      steps: List<MlSteps>.from(
        (map['description'] as List<int>).map<MlSteps>(
          (x) => MlSteps.fromMap(x as Map<String, dynamic>),
        ),
      ),
      actionUri: map['actionUri'] as String,
      prizeSubType: map['prizeSubType'] as String,
      tooltip: map['tooltip'] as String,
      animType: map['animType'] as String,
      isCompleted: map['isCompleted'] as bool,
      page: map['page'] as int,
      index: map['mlIndex'] as int,
      shadow:
          MilestoneShadowModel.fromMap(map['shadow'] as Map<String, dynamic>),
      hFlip: map['hFlip'] as bool,
      vFlip: map['vFlip'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory MilestoneModel.fromJson(String source) =>
      MilestoneModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'MilestoneModel(id: $id, asset: $asset, x: $x, y: $y, rewards: $rewards, description: $steps, actionUri: $actionUri, animType: $animType, isCompleted: $isCompleted, page: $page, prizeSubType: $prizeSubType, mlIndex: $index, shadow: $shadow, hFlip: $hFlip, vFlip: $vFlip)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is MilestoneModel &&
        other.id == id &&
        other.asset == asset &&
        other.x == x &&
        other.y == y &&
        listEquals(other.rewards, rewards) &&
        listEquals(other.steps, steps) &&
        other.actionUri == actionUri &&
        other.animType == animType &&
        other.tooltip == tooltip &&
        other.isCompleted == isCompleted &&
        other.page == page &&
        other.prizeSubType == prizeSubType &&
        other.index == index &&
        other.shadow == shadow &&
        other.hFlip == hFlip &&
        other.vFlip == vFlip;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        asset.hashCode ^
        x.hashCode ^
        y.hashCode ^
        rewards.hashCode ^
        steps.hashCode ^
        actionUri.hashCode ^
        animType.hashCode ^
        tooltip.hashCode ^
        isCompleted.hashCode ^
        page.hashCode ^
        prizeSubType.hashCode ^
        index.hashCode ^
        shadow.hashCode ^
        hFlip.hashCode ^
        vFlip.hashCode;
  }
}

class MilestoneShadowModel {
  final String id;
  final JourneyAssetModel asset;
  final double x, y;
  final String animType;
  final bool isCompleted;
  final int page;
  final int index;
  final bool hFlip, vFlip;
  MilestoneShadowModel({
    @required this.id,
    @required this.asset,
    @required this.y,
    @required this.x,
    this.animType = "none",
    this.isCompleted = false,
    @required this.page,
    @required this.index,
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
      y: dy ?? this.y,
      x: dx ?? this.x,
      animType: animType ?? this.animType,
      isCompleted: isCompleted ?? this.isCompleted,
      page: page ?? this.page,
      index: level ?? this.index,
      vFlip: vFlip ?? this.vFlip,
      hFlip: hFlip ?? this.hFlip,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
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

  factory MilestoneShadowModel.fromMap(Map<String, dynamic> map) {
    return MilestoneShadowModel(
      id: map['id'] ?? '',
      asset: map['asset'] ?? '',
      y: map['dy'],
      x: map['dx'],
      animType: map['animType'] ?? '',
      isCompleted: map['isCompleted'] ?? false,
      page: map['page']?.toInt() ?? 0,
      index: map['level']?.toInt() ?? 0,
      vFlip: map['vFlip'] ?? false,
      hFlip: map['hFlip'] ?? false,
    );
  }

  String toJson() => json.encode(toMap());

  factory MilestoneShadowModel.fromJson(String source) =>
      MilestoneShadowModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'MilestoneShadowModel(id: $id, asset: $asset, dy: $y, animType: $animType, isCompleted: $isCompleted, page: $page, level: $index, vFlip: $vFlip, hFlip: $hFlip)';
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
