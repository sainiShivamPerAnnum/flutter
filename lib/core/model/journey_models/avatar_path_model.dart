import 'dart:convert';

import 'package:flutter/foundation.dart';

// enum moveType { cubic, quadratic, linear, arc, rect, move }

class AvatarPathModel {
  final String moveType;
  int milestoneIndex;
  final List<double> coords;
  final int page;
  final int level;
  AvatarPathModel({
    @required this.moveType,
    @required this.milestoneIndex,
    @required this.coords,
    @required this.page,
    @required this.level,
  });

  AvatarPathModel copyWith({
    String moveType,
    int milestoneIndex,
    List<double> coords,
    int page,
    int level,
  }) {
    return AvatarPathModel(
      moveType: moveType ?? this.moveType,
      milestoneIndex: milestoneIndex ?? this.milestoneIndex,
      coords: coords ?? this.coords,
      page: page ?? this.page,
      level: level ?? this.level,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'moveType': moveType,
      'milestoneIndex': milestoneIndex,
      'coords': coords,
      // 'page': page,
      'level': level,
    };
  }

  factory AvatarPathModel.fromMap(Map<String, dynamic> map) {
    return AvatarPathModel(
      moveType: map['moveType'] ?? "linear",
      milestoneIndex: map['milestoneIndex']?.toInt() ?? 0,
      coords: List<double>.from(map['coords']),
      page: map['page']?.toInt() ?? 0,
      level: map['page']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory AvatarPathModel.fromJson(String source) =>
      AvatarPathModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'AvatarPathModel(moveType: $moveType, milestoneIndex: $milestoneIndex, coords: $coords, page: $page, level: $level)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AvatarPathModel &&
        other.moveType == moveType &&
        other.milestoneIndex == milestoneIndex &&
        listEquals(other.coords, coords) &&
        other.page == page;
  }

  @override
  int get hashCode {
    return moveType.hashCode ^
        milestoneIndex.hashCode ^
        coords.hashCode ^
        page.hashCode;
  }
}
