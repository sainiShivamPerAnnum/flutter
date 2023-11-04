// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/material.dart';

enum ImageType {
  svg,
  lottie,
}

class QuickLinksModel {
  String name;
  String asset;
  String deeplink;
  Color color;
  ImageType imageType;

  QuickLinksModel({
    required this.name,
    required this.asset,
    required this.deeplink,
    required this.color,
    this.imageType = ImageType.svg,
  });

  QuickLinksModel copyWith({
    String? name,
    String? asset,
    String? deeplink,
    Color? color,
  }) {
    return QuickLinksModel(
      name: name ?? this.name,
      asset: asset ?? this.asset,
      deeplink: deeplink ?? this.deeplink,
      color: color ?? this.color,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'asset': asset,
      'deeplink': deeplink,
      'color': color.value,
    };
  }

  factory QuickLinksModel.fromMap(Map<String, dynamic> map) {
    return QuickLinksModel(
      name: map['name'] as String,
      asset: map['asset'] as String,
      deeplink: map['deeplink'] as String,
      color: Color(map['color'] as int),
    );
  }

  String toJson() => json.encode(toMap());

  factory QuickLinksModel.fromJson(String source) =>
      QuickLinksModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'QuickLinksModel(name: $name, asset: $asset, deeplink: $deeplink, color: $color)';
  }

  @override
  bool operator ==(covariant QuickLinksModel other) {
    if (identical(this, other)) return true;

    return other.name == name &&
        other.asset == asset &&
        other.deeplink == deeplink &&
        other.color == color;
  }

  @override
  int get hashCode {
    return name.hashCode ^ asset.hashCode ^ deeplink.hashCode ^ color.hashCode;
  }
}
