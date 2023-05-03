// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:felloapp/core/model/helper_model.dart';

class SubComboModel {
  int order;
  String title;
  bool popular;
  int AUGGOLD99;
  int LENDBOXP2P;
  String icon;
  bool isSelected;
  SubComboModel(
      {required this.order,
      required this.title,
      required this.popular,
      required this.AUGGOLD99,
      required this.LENDBOXP2P,
      required this.icon,
      required this.isSelected});

  static final helper = HelperModel<SubComboModel>(
    (map) => SubComboModel.fromMap(map),
  );

  factory SubComboModel.fromMap(Map<String, dynamic> map) {
    return SubComboModel(
      order: map['order'] as int,
      title: map['title'] as String,
      popular: map['popular'] as bool,
      AUGGOLD99: map['AUGGOLD99'] as int,
      LENDBOXP2P: map['LENDBOXP2P'] as int,
      icon: map['icon'] as String,
      isSelected: false,
    );
  }

  @override
  String toString() {
    return 'SubCombos(order: $order, title: $title, popular: $popular, AUGGOLD99: $AUGGOLD99, LENDBOXP2P: $LENDBOXP2P, icon: $icon)';
  }
}

class MaxMin {
  final MaxMinAsset min;
  final MaxMinAsset max;
  MaxMin({
    required this.min,
    required this.max,
  });

  MaxMin copyWith({
    MaxMinAsset? min,
    MaxMinAsset? max,
  }) {
    return MaxMin(
      min: min ?? this.min,
      max: max ?? this.max,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'min': min.toMap(),
      'max': max,
    };
  }

  factory MaxMin.fromMap(Map<String, dynamic> map) {
    return MaxMin(
      min: MaxMinAsset.fromMap(map['min'] as Map<String, dynamic>),
      max: MaxMinAsset.fromMap(map['max'] as Map<String, dynamic>),
    );
  }

  String toJson() => json.encode(toMap());

  factory MaxMin.fromJson(String source) =>
      MaxMin.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'MaxMin(min: $min, max: $max)';

  @override
  bool operator ==(covariant MaxMin other) {
    if (identical(this, other)) return true;

    return other.min == min && other.max == max;
  }

  @override
  int get hashCode => min.hashCode ^ max.hashCode;
}

class MaxMinAsset {
  final int AUGGOLD99;
  final int LENDBOXP2P;
  MaxMinAsset({
    required this.AUGGOLD99,
    required this.LENDBOXP2P,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'AUGGOLD99': AUGGOLD99,
      'LENDBOXP2P': LENDBOXP2P,
    };
  }

  factory MaxMinAsset.fromMap(Map<String, dynamic> map) {
    return MaxMinAsset(
      AUGGOLD99: map['AUGGOLD99'],
      LENDBOXP2P: map['LENDBOXP2P'],
    );
  }

  String toJson() => json.encode(toMap());

  factory MaxMinAsset.fromJson(String source) =>
      MaxMinAsset.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'MinAsset(AUGGOLD99: $AUGGOLD99, LENDBOXP2P: $LENDBOXP2P)';

  @override
  bool operator ==(covariant MaxMinAsset other) {
    if (identical(this, other)) return true;

    return other.AUGGOLD99 == AUGGOLD99 && other.LENDBOXP2P == LENDBOXP2P;
  }

  @override
  int get hashCode => AUGGOLD99.hashCode ^ LENDBOXP2P.hashCode;
}
