import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:felloapp/core/model/journey_models/avatar_path_model.dart';
import 'package:felloapp/core/model/journey_models/journey_path_model.dart';
import 'package:felloapp/core/model/journey_models/milestone_model.dart';

class JourneyPage {
  String bgImage;
  int page;
  List<JourneyPathModel> path;
  List<AvatarPathModel> avatarPath;
  List<MilestoneModel> milestones;
  JourneyPage({
    @required this.bgImage,
    @required this.path,
    @required this.page,
    @required this.avatarPath,
    @required this.milestones,
  });

  JourneyPage copyWith({
    String bgImage,
    List<JourneyPathModel> path,
    List<AvatarPathModel> avatarPath,
    int page,
    List<MilestoneModel> milestones,
  }) {
    return JourneyPage(
      bgImage: bgImage ?? this.bgImage,
      path: path ?? this.path,
      page: page ?? this.page,
      avatarPath: avatarPath ?? this.avatarPath,
      milestones: milestones ?? this.milestones,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'bgImage': bgImage,
      'page': page,
      'path': path.map((x) => x.toMap()).toList(),
      'avatarPath': avatarPath.map((x) => x.toMap()).toList(),
      'milestones': milestones.map((x) => x.toMap()).toList(),
    };
  }

  factory JourneyPage.fromMap(Map<String, dynamic> map) {
    return JourneyPage(
      page: map["page"] ?? 0,
      bgImage: map['bgImage'] ?? '',
      path: List<JourneyPathModel>.from(
          map['path']?.map((x) => JourneyPathModel.fromMap(x))),
      avatarPath: List<AvatarPathModel>.from(
          map['avatarPath']?.map((x) => AvatarPathModel.fromMap(x))),
      milestones: List<MilestoneModel>.from(
          map['milestones']?.map((x) => MilestoneModel.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory JourneyPage.fromJson(String source) =>
      JourneyPage.fromMap(json.decode(source));

  @override
  String toString() {
    return 'JourneyPage(bgImage: $bgImage, path: $path, avatarPath: $avatarPath, milestones: $milestones)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is JourneyPage &&
        other.bgImage == bgImage &&
        listEquals(other.path, path) &&
        listEquals(other.avatarPath, avatarPath) &&
        listEquals(other.milestones, milestones);
  }

  @override
  int get hashCode {
    return bgImage.hashCode ^
        path.hashCode ^
        avatarPath.hashCode ^
        milestones.hashCode;
  }
}

enum AssetType { png, svg, csp }

enum AssetSource { nwt, ast, file, raw, mmry }

enum Mlastype { svg, png, lottie, rive }

enum Mlanimtype { rotate, scale, bounce, translate }
