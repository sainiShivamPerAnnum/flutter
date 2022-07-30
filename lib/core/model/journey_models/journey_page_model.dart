import 'dart:convert';

import 'package:felloapp/core/model/journey_models/avatar_path_model.dart';
import 'package:felloapp/core/model/journey_models/journey_background_model.dart';
import 'package:felloapp/core/model/journey_models/journey_path_model.dart';
import 'package:felloapp/core/model/journey_models/milestone_model.dart';
import 'package:flutter/foundation.dart';

class JourneyPage {
  JourneyBackgroundModel bgAsset;
  int page;
  List<JourneyPathModel> paths;
  List<AvatarPathModel> avatarPath;
  List<MilestoneModel> milestones;
  JourneyPage({
    @required this.bgAsset,
    @required this.paths,
    @required this.page,
    @required this.avatarPath,
    @required this.milestones,
  });

  JourneyPage copyWith({
    JourneyBackgroundModel bgAsset,
    List<JourneyPathModel> paths,
    List<AvatarPathModel> avatarPath,
    int level,
    int page,
    List<MilestoneModel> milestones,
  }) {
    return JourneyPage(
      bgAsset: bgAsset ?? this.bgAsset,
      paths: paths ?? this.paths,
      page: page ?? this.page,
      avatarPath: avatarPath ?? this.avatarPath,
      milestones: milestones ?? this.milestones,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'bgImage': bgAsset.toMap(),
      'paths': paths.map((x) => x.toMap()).toList(),
      'avatarPath': avatarPath.map((x) => x.toMap()).toList(),
      'milestones': {
        "startRange": 0,
        "items": milestones.map((x) => x.toJourneyMap()).toList()
      },
    };
  }

  factory JourneyPage.fromMap(Map<String, dynamic> map) {
    return JourneyPage(
      page: map["page"] ?? 0,
      bgAsset: JourneyBackgroundModel.fromMap(map["bg"], map['page']),
      paths: List<JourneyPathModel>.from(
        map['paths']?.map(
          (x) => JourneyPathModel.fromMap(
            x,
            map['page'],
          ),
        ),
      ),
      avatarPath: List<AvatarPathModel>.from(
        map['avatarPath']?.map(
          (x) => AvatarPathModel.fromMap(
            x,
            map['page'],
          ),
        ),
      ),
      milestones: List<MilestoneModel>.from(
        map['milestones']?.map(
          (x) => MilestoneModel.fromMap(
            x,
            map['page'],
          ),
        ),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory JourneyPage.fromJson(String source) =>
      JourneyPage.fromMap(json.decode(source));

  @override
  String toString() {
    return 'JourneyPage(bgAsset: $bgAsset, paths: $paths, avatarPath: $avatarPath, milestones: $milestones)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is JourneyPage &&
        other.bgAsset == bgAsset &&
        listEquals(other.paths, paths) &&
        listEquals(other.avatarPath, avatarPath) &&
        listEquals(other.milestones, milestones);
  }

  @override
  int get hashCode {
    return bgAsset.hashCode ^
        paths.hashCode ^
        avatarPath.hashCode ^
        milestones.hashCode;
  }
}

enum AssetType { png, svg, csp }

enum AssetSource { nwt, ast, file, raw, mmry }

enum Mlastype { svg, png, lottie, rive }

enum Mlanimtype { rotate, scale, bounce, translate }
