import 'dart:convert';

import 'package:flutter/foundation.dart';

// enum moveType { cubic, quadratic, linear, arc, rect, move }

class AvatarPathModel {
  final String moveType;
  final List<double> coords;
  final int page;
  final int mlIndex;
  AvatarPathModel({
    required this.moveType,
    required this.coords,
    required this.page,
    required this.mlIndex,
  });

  AvatarPathModel copyWith({
    String? moveType,
    int? milestoneIndex,
    List<double>? coords,
    int? page,
    int? level,
  }) {
    return AvatarPathModel(
      moveType: moveType ?? this.moveType,
      coords: coords ?? this.coords,
      page: page ?? this.page,
      mlIndex: level ?? mlIndex,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'moveType': moveType,
      'coords': coords,
      'mlIndex': mlIndex,
    };
  }

  factory AvatarPathModel.fromMap(Map<String, dynamic> map, int page) {
    return AvatarPathModel(
      moveType: map['moveType'] ?? "linear",
      coords: List<double>.from(
          (map['coords'] as List<dynamic>).map((e) => e.toDouble()).toList()),
      page: page ?? 0,
      mlIndex: map['mlIndex'] ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory AvatarPathModel.fromJson(String source, int page) =>
      AvatarPathModel.fromMap(json.decode(source), page);

  @override
  String toString() {
    return 'AvatarPathModel(moveType: $moveType, coords: $coords, page: $page, level: $mlIndex)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AvatarPathModel &&
        other.moveType == moveType &&
        listEquals(other.coords, coords) &&
        other.page == page;
  }

  @override
  int get hashCode {
    return moveType.hashCode ^ coords.hashCode ^ page.hashCode;
  }
}
