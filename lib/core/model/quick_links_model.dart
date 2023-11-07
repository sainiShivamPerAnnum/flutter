// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:felloapp/core/model/helper_model.dart';
import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';

enum ImageType {
  svg,
  lottie,
}

class QuickLinksModel {
  final String name;
  final String asset;
  final String deeplink;
  final Color color;

  const QuickLinksModel({
    required this.name,
    required this.asset,
    required this.deeplink,
    required this.color,
  });

  factory QuickLinksModel.fromMap(Map<String, dynamic> map) {
    return QuickLinksModel(
      name: map['name'] as String,
      asset: map['img'] as String,
      deeplink: map['deeplink'] as String,
      color: (map['color'] as String).toColor()!,
    );
  }

  static List<QuickLinksModel> fromJsonList(Object json) =>
      HelperModel<QuickLinksModel>(QuickLinksModel.fromMap).fromMapArray(json);

  factory QuickLinksModel.fromJson(String source) =>
      QuickLinksModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'QuickLinksModel(name: $name, asset: $asset, deeplink: $deeplink, color: $color)';
  }
}
