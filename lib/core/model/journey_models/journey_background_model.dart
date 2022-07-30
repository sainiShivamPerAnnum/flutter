// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'dart:ui';

import 'package:flutter/foundation.dart';

import 'package:felloapp/core/model/journey_models/journey_asset_model.dart';

class JourneyBackgroundModel {
  List<Color> colors;
  List<double> stops;
  JourneyAssetModel asset;
  JourneyBackgroundModel({
    @required this.colors,
    @required this.stops,
    @required this.asset,
  });

  JourneyBackgroundModel copyWith({
    List<Color> colors,
    List<double> stops,
    JourneyAssetModel asset,
  }) {
    return JourneyBackgroundModel(
      colors: colors ?? this.colors,
      stops: stops ?? this.stops,
      asset: asset ?? this.asset,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'colors':
          colors.map((x) => x.value.toRadixString(16).substring(2)).toList(),
      'stops': stops,
      'asset': asset.toMap(),
    };
  }

  factory JourneyBackgroundModel.fromMap(Map<String, dynamic> map, int page) {
    return JourneyBackgroundModel(
      colors: List<Color>.from(
        (map['colors'] as List<dynamic>).map<Color>(
          (x) => x.toString().toColor(),
        ),
      ),
      stops: List<double>.from(
          (map['stops'] as List<dynamic>).map((e) => e.toDouble()).toList()),
      asset:
          JourneyAssetModel.fromMap(map['asset'] as Map<String, dynamic>, page),
    );
  }

  String toJson() => json.encode(toMap());

  factory JourneyBackgroundModel.fromJson(String source, int page) =>
      JourneyBackgroundModel.fromMap(
          json.decode(source) as Map<String, dynamic>, page);

  @override
  String toString() =>
      'JourneyBackgroundModel(colors: $colors, stops: $stops, asset: $asset)';

  @override
  bool operator ==(covariant JourneyBackgroundModel other) {
    if (identical(this, other)) return true;

    return listEquals(other.colors, colors) &&
        listEquals(other.stops, stops) &&
        other.asset == asset;
  }

  @override
  int get hashCode => colors.hashCode ^ stops.hashCode ^ asset.hashCode;
}

extension ColorExtension on String {
  Color toColor() {
    var hexColor = this.replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    if (hexColor.length == 8) {
      return Color(int.parse("0x$hexColor"));
    }
  }
}
