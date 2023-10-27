// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:felloapp/core/model/journey_models/journey_asset_model.dart';
import 'package:felloapp/core/model/journey_models/milestone_description.dart';
import 'package:felloapp/core/model/journey_models/milestone_shadow_model.dart';
import 'package:felloapp/core/model/scratch_card_model.dart';
import 'package:flutter/foundation.dart';

class MilestoneModel {
  final String? id;
  final JourneyAssetModel asset;
  final JourneyAssetModel? animAsset;
  final double? x;
  final double? y;
  final double? ax;
  final double? ay;
  List<Reward>? rewards;
  Map<String, dynamic>? skipCost;
  final List<MlSteps> steps;
  final String? actionUri;
  final String? animType;
  final String? tooltip;
  bool? isCompleted = false;
  final String? prizeSubType;
  final int page;
  final int? index;
  final MilestoneShadowModel? shadow;
  final bool? hFlip;
  final bool vFlip;
  final int? value;
  MilestoneModel({
    required this.asset,
    required this.x,
    required this.y,
    required this.steps,
    required this.actionUri,
    required this.page,
    required this.index,
    this.id,
    this.animAsset,
    this.ax,
    this.ay,
    this.rewards,
    this.tooltip,
    this.skipCost,
    this.prizeSubType,
    this.animType = "NONE",
    this.isCompleted,
    this.shadow,
    this.hFlip = false,
    this.vFlip = false,
    this.value,
  });

  MilestoneModel copyWith({
    String? id,
    JourneyAssetModel? asset,
    JourneyAssetModel? animAsset,
    double? x,
    double? y,
    double? ax,
    double? ay,
    Map<String, dynamic>? skipCost,
    List<Reward>? rewards,
    List<MlSteps>? description,
    String? actionUri,
    String? animType,
    String? tooltip,
    bool? isCompleted,
    String? prizeSubType,
    int? page,
    int? mlIndex,
    MilestoneShadowModel? shadow,
    bool? hFlip,
    bool? vFlip,
    int? value,
  }) {
    return MilestoneModel(
      id: id ?? this.id,
      asset: asset ?? this.asset,
      animAsset: animAsset ?? this.animAsset,
      x: x ?? this.x,
      y: y ?? this.y,
      ax: ax ?? this.ax,
      ay: ay ?? this.ay,
      rewards: rewards ?? this.rewards,
      steps: description ?? steps,
      actionUri: actionUri ?? this.actionUri,
      skipCost: skipCost ?? this.skipCost,
      animType: animType ?? this.animType,
      tooltip: tooltip ?? this.tooltip,
      isCompleted: isCompleted ?? this.isCompleted,
      prizeSubType: prizeSubType ?? this.prizeSubType,
      page: page ?? this.page,
      index: mlIndex ?? index,
      shadow: shadow ?? this.shadow,
      hFlip: hFlip ?? this.hFlip,
      vFlip: vFlip ?? this.vFlip,
      value: value ?? this.value,
    );
  }

  Map<String, dynamic> toJourneyMap() {
    return <String, dynamic>{
      'x': x,
      'y': y,
      if (animAsset != null) 'ax': ax,
      if (animAsset != null) 'ay': ay,
      if (shadow != null) 'sx': shadow!.x,
      if (shadow != null) 'sy': shadow!.y,
      'hFlip': hFlip ?? false
    };
  }

  Map<String, dynamic> toMap(int page) {
    return <String, dynamic>{
      'assetRef': asset.name,
      if (animAsset != null) 'animRef': animAsset!.name,
      'animType': animType ?? "none",
      'actionUri': actionUri ?? '',
      'toolTip': tooltip ?? '',
      'page': page,
      'steps': steps.map((x) => x.toMap()).toList(),
      'prizeSubType': prizeSubType ?? '',
      if (shadow != null) 'shadow': {'assetRef': shadow!.name},
    };
  }

  factory MilestoneModel.fromMap(Map<String, dynamic> map, int page) {
    return MilestoneModel(
      index: map['index'] as int?,
      x: map['x'] as double?,
      y: map['y'] as double?,
      ax: map.containsKey('ax') && map['ax'] != 0 ? map['ax'] as double? : null,
      ay: map.containsKey('ay') && map['ay'] != 0 ? map['ay'] as double? : null,
      hFlip: map['hFlip'] as bool?,
      tooltip: map['toolTip'] as String?,
      steps: List<MlSteps>.from(
        (map['steps'] as List<dynamic>).map<MlSteps>(
          (x) => MlSteps.fromMap(x as Map<String, dynamic>),
        ),
      ),
      skipCost: map['skipCost'] ?? {},
      prizeSubType: map['prizeSubType'] as String?,
      animType: map['animType'] as String?,
      actionUri: map['actionUri'] as String?,
      asset:
          JourneyAssetModel.fromMap(map['asset'] as Map<String, dynamic>, page),
      animAsset: map.containsKey('animAsset')
          ? JourneyAssetModel.fromMap(
              map['asset'] as Map<String, dynamic>, page)
          : null,
      page: page,
      rewards: map["rewards"] != null
          ? List<Reward>.from(
              (map['rewards'] as List<int>).map<Reward>(
                (x) => Reward.fromMap(x as Map<String, dynamic>),
              ),
            )
          : null,
      isCompleted: map['isCompleted'] ?? false,
      shadow: map["shadow"] != null
          ? MilestoneShadowModel.fromMap(
              map['shadow'] as Map<String, dynamic>, map, page)
          : null,
      value: map['value'] ?? 0,
    );
  }

  String toJson(page) => json.encode(toMap(page));

  factory MilestoneModel.fromJson(String source, int page) =>
      MilestoneModel.fromMap(json.decode(source) as Map<String, dynamic>, page);

  @override
  String toString() {
    return 'MilestoneModel(id: $id, asset: $asset, x: $x, y: $y, ax:  $ax  ay: $ay rewards: $rewards, description: $steps, actionUri: $actionUri, animType: $animType, isCompleted: $isCompleted, page: $page, prizeSubType: $prizeSubType, mlIndex: $index, shadow: $shadow, hFlip: $hFlip, vFlip: $vFlip)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is MilestoneModel &&
        other.id == id &&
        other.asset == asset &&
        other.animAsset == animAsset &&
        other.x == x &&
        other.y == y &&
        other.ax == ax &&
        other.ay == ay &&
        listEquals(other.rewards, rewards) &&
        listEquals(other.steps, steps) &&
        other.skipCost == skipCost &&
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
        animAsset.hashCode ^
        ax.hashCode ^
        ay.hashCode ^
        rewards.hashCode ^
        steps.hashCode ^
        actionUri.hashCode ^
        skipCost.hashCode ^
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
