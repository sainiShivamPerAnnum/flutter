// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fd_home.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AllFdsData _$AllFdsDataFromJson(Map<String, dynamic> json) => AllFdsData(
      id: json['id'] as String,
      displayName: json['displayName'] as String,
      subText: json['subText'] as String,
      investDetailsList: (json['investDetailsList'] as List<dynamic>)
          .map((e) => InvestDetail.fromJson(e as Map<String, dynamic>))
          .toList(),
      tags: (json['tags'] as List<dynamic>)
          .map((e) => Tag.fromJson(e as Map<String, dynamic>))
          .toList(),
      icon: json['icon'] as String,
      tncLink: json['tncLink'] as String,
    );

InvestDetail _$InvestDetailFromJson(Map<String, dynamic> json) => InvestDetail(
      label: json['label'] as String,
      value: json['value'] as String,
    );

Tag _$TagFromJson(Map<String, dynamic> json) => Tag(
      text: json['text'] as String,
      color: json['color'] as String,
      textColor: json['textColor'] as String,
    );
