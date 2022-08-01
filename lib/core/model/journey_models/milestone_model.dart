// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:felloapp/core/model/golden_ticket_model.dart';
import 'package:felloapp/core/model/journey_models/journey_asset_model.dart';
import 'package:felloapp/core/model/journey_models/milestone_description.dart';

class MilestoneModel {
  final String id;
  final JourneyAssetModel asset;
  final JourneyAssetModel animAsset;
  final double x;
  final double y;
  final double ax;
  final double ay;
  List<Reward> rewards;
  final List<MlSteps> steps;
  final String actionUri;
  final String animType;
  final String tooltip;
  bool isCompleted = false;
  final String prizeSubType;
  final int page;
  final int index;
  final MilestoneShadowModel shadow;
  final bool hFlip;
  final bool vFlip;
  MilestoneModel({
    this.id,
    @required this.asset,
    this.animAsset,
    @required this.x,
    @required this.y,
    this.ax,
    this.ay,
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
    JourneyAssetModel animAsset,
    double x,
    double y,
    double ax,
    double ay,
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
      animAsset: animAsset ?? this.animAsset,
      x: x ?? this.x,
      y: y ?? this.y,
      ax: ax ?? this.ax,
      ay: ay ?? this.ay,
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

  Map<String, dynamic> toJourneyMap() {
    return animAsset != null
        ? <String, dynamic>{
            'x': x,
            'y': y,
            'ax': ax,
            'ay': ay,
            'sx': shadow.x,
            'sy': shadow.y,
            'hFlip': hFlip ?? false
          }
        : <String, dynamic>{
            'x': x,
            'y': y,
            'sx': shadow.x,
            'sy': shadow.y,
            'hFlip': hFlip ?? false,
          };
  }

  Map<String, dynamic> toMap(int page) {
    return shadow != null
        ? (animAsset != null
            ? <String, dynamic>{
                'assetRef': asset.name,
                'animRef': animAsset.name,
                'animType': animType ?? "none",
                'actionUri': actionUri ?? '',
                'toolTip': tooltip ?? '',
                'page': page,
                'steps': steps.map((x) => x.toMap()).toList(),
                'prizeSubType': prizeSubType ?? '',
                'shadow': {'assetRef': shadow.name},
              }
            : <String, dynamic>{
                'assetRef': asset.name,
                'animType': animType ?? "none",
                'actionUri': actionUri ?? '',
                'toolTip': tooltip ?? '',
                'page': page,
                'steps': steps.map((x) => x.toMap()).toList(),
                'prizeSubType': prizeSubType ?? '',
                'shadow': {'assetRef': shadow.name},
              })
        : (animAsset != null
            ? <String, dynamic>{
                'assetRef': asset.name,
                'animAssetRef': animAsset.name,
                'animType': animType ?? "none",
                'actionUri': actionUri ?? '',
                'toolTip': tooltip ?? '',
                'page': page,
                'steps': steps.map((x) => x.toMap()).toList(),
                'prizeSubType': prizeSubType ?? '',
              }
            : <String, dynamic>{
                'assetRef': asset.name,
                'animType': animType ?? "none",
                'actionUri': actionUri ?? '',
                'toolTip': tooltip ?? '',
                'page': page,
                'steps': steps.map((x) => x.toMap()).toList(),
                'prizeSubType': prizeSubType ?? '',
              });
  }

  factory MilestoneModel.fromMap(Map<String, dynamic> map, int page) {
    return MilestoneModel(
      index: map['mlIndex'] as int,
      x: map['x'] as double,
      y: map['y'] as double,
      ax: map.containsKey('ax') && map['ax'] != 0 ? map['ax'] as double : null,
      ay: map.containsKey('ay') && map['ay'] != 0 ? map['ay'] as double : null,
      hFlip: map['hFlip'] as bool,
      tooltip: map['toolTip'] as String,
      steps: List<MlSteps>.from(
        (map['steps'] as List<dynamic>).map<MlSteps>(
          (x) => MlSteps.fromMap(x as Map<String, dynamic>),
        ),
      ),
      prizeSubType: map['prizeSubType'] as String,
      animType: map['animType'] as String,
      actionUri: map['actionUri'] as String,
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
  final String name;
  final JourneyAssetModel asset;
  final double x, y;
  final String animType;
  final bool isCompleted;
  final int page;
  final int index;
  final bool hFlip, vFlip;
  MilestoneShadowModel({
    @required this.id,
    @required this.name,
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
    JourneyAssetModel asset,
    double dx,
    String name,
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
      name: name ?? this.name,
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
