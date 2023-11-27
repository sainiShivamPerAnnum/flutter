// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:felloapp/core/model/timestamp_model.dart';

class FelloFactsModel {
  final String? id;
  final String? title;
  final String? type;
  final String? subTitle;
  final String? bgColor;
  final String? asset;
  final String? actionUri;
  final TimestampModel createdOn;
  FelloFactsModel({
    required this.id,
    required this.title,
    required this.type,
    required this.subTitle,
    required this.bgColor,
    required this.asset,
    required this.actionUri,
    required this.createdOn,
  });

  FelloFactsModel copyWith({
    String? id,
    String? title,
    String? type,
    String? subTitle,
    String? bgColor,
    String? asset,
    String? actionUri,
    TimestampModel? createdOn,
  }) {
    return FelloFactsModel(
      id: id ?? this.id,
      title: title ?? this.title,
      type: type ?? this.type,
      subTitle: subTitle ?? this.subTitle,
      bgColor: bgColor ?? this.bgColor,
      asset: asset ?? this.asset,
      actionUri: actionUri ?? this.actionUri,
      createdOn: createdOn ?? this.createdOn,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'type': type,
      'subTitle': subTitle,
      'bgColor': bgColor,
      'asset': asset,
      'actionUri': actionUri,
      'createdOn': createdOn.toMap(),
    };
  }

  factory FelloFactsModel.fromMap(Map<String, dynamic> map) {
    return FelloFactsModel(
      id: map['id'] as String?,
      title: map['title'] as String?,
      type: map['type'] as String?,
      subTitle: map['subTitle'] as String?,
      bgColor: map['bgColor'] as String?,
      asset: map['asset'] as String?,
      actionUri: map['actionUri'] as String?,
      createdOn: TimestampModel.fromMap(map['createdOn']),
    );
  }

  String toJson() => json.encode(toMap());

  factory FelloFactsModel.fromJson(String source) =>
      FelloFactsModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'FelloFactsModel(id: $id, title: $title, type: $type, subTitle: $subTitle, bgColor: $bgColor, asset: $asset, actionUri: $actionUri, createdOn: $createdOn)';
  }

  @override
  bool operator ==(covariant FelloFactsModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.title == title &&
        other.type == type &&
        other.subTitle == subTitle &&
        other.bgColor == bgColor &&
        other.asset == asset &&
        other.actionUri == actionUri &&
        other.createdOn == createdOn;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        title.hashCode ^
        type.hashCode ^
        subTitle.hashCode ^
        bgColor.hashCode ^
        asset.hashCode ^
        actionUri.hashCode ^
        createdOn.hashCode;
  }
}
