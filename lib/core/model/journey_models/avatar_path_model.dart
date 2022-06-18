import 'dart:convert';

import 'package:flutter/foundation.dart';

// enum PathType { cubic, quadratic, linear, arc, rect, move }

class AvatarPathModel {
  final String pathType;
  int mlIndex;
  final List<double> cords;
  final int page;
  AvatarPathModel({
    @required this.pathType,
    @required this.mlIndex,
    @required this.cords,
    @required this.page,
  });

  AvatarPathModel copyWith({
    String pathType,
    int mlIndex,
    List<double> cords,
    int page,
  }) {
    return AvatarPathModel(
      pathType: pathType ?? this.pathType,
      mlIndex: mlIndex ?? this.mlIndex,
      cords: cords ?? this.cords,
      page: page ?? this.page,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'pathType': pathType,
      'mlIndex': mlIndex,
      'cords': cords,
      'page': page,
    };
  }

  factory AvatarPathModel.fromMap(Map<String, dynamic> map) {
    return AvatarPathModel(
      pathType: map['pathType'] ?? "linear",
      mlIndex: map['mlIndex']?.toInt() ?? 0,
      cords: List<double>.from(map['cords']),
      page: map['page']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory AvatarPathModel.fromJson(String source) =>
      AvatarPathModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'AvatarPathModel(pathType: $pathType, mlIndex: $mlIndex, cords: $cords, page: $page)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AvatarPathModel &&
        other.pathType == pathType &&
        other.mlIndex == mlIndex &&
        listEquals(other.cords, cords) &&
        other.page == page;
  }

  @override
  int get hashCode {
    return pathType.hashCode ^
        mlIndex.hashCode ^
        cords.hashCode ^
        page.hashCode;
  }
}
