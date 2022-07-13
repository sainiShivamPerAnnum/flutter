import 'dart:convert';

import 'package:flutter/material.dart';

class JourneyAssetModel {
  final String uri;
  final String name;
  final double height;
  final double width;
  final int page;
  final String assetType;
  JourneyAssetModel({
    @required this.uri,
    @required this.name,
    @required this.height,
    @required this.width,
    @required this.page,
    this.assetType = 'SVG',
  });

  JourneyAssetModel copyWith({
    String uri,
    String name,
    double height,
    double width,
    int page,
    int level,
    String type,
  }) {
    return JourneyAssetModel(
      uri: uri ?? this.uri,
      name: name ?? this.name,
      height: height ?? this.height,
      width: width ?? this.width,
      page: page ?? this.page,
      assetType: type ?? this.assetType,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uri': uri,
      'name': name,
      'height': height,
      'width': width,
      'type': assetType,
    };
  }

  factory JourneyAssetModel.fromMap(Map<String, dynamic> map) {
    return JourneyAssetModel(
      uri: map['uri'] ?? '',
      name: map['name'] ?? '',
      height: map['height']?.toDouble() ?? 0.0,
      width: map['width']?.toDouble() ?? 0.0,
      page: map['page']?.toInt() ?? 0,
      assetType: map['assetType'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory JourneyAssetModel.fromJson(String source) =>
      JourneyAssetModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'JourneyAssetModel(uri: $uri, name: $name, height: $height, width: $width, page: $page, type: $assetType)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is JourneyAssetModel &&
        other.uri == uri &&
        other.name == name &&
        other.height == height &&
        other.width == width &&
        other.page == page &&
        other.assetType == assetType;
  }

  @override
  int get hashCode {
    return uri.hashCode ^
        name.hashCode ^
        height.hashCode ^
        width.hashCode ^
        page.hashCode ^
        assetType.hashCode;
  }
}
