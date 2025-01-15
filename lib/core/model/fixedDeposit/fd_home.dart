import 'package:json_annotation/json_annotation.dart';

part 'fd_home.g.dart';

const _deserializable = JsonSerializable(
  createToJson: false,
);

@_deserializable
class AllFdsData {
  final String id;
  final String displayName;
  final String subText;
  final List<InvestDetail> investDetailsList;
  final List<Tag> tags;
  final String icon;
  final String tncLink;

  AllFdsData({
    required this.id,
    required this.displayName,
    required this.subText,
    required this.investDetailsList,
    required this.tags,
    required this.icon,
    required this.tncLink,
  });

  factory AllFdsData.fromJson(Map<String, dynamic> json) =>
      _$AllFdsDataFromJson(json);
}

@_deserializable
class InvestDetail {
  final String label;
  final String value;

  InvestDetail({
    required this.label,
    required this.value,
  });

  factory InvestDetail.fromJson(Map<String, dynamic> json) =>
      _$InvestDetailFromJson(json);
}

@_deserializable
class Tag {
  final String text;
  final String color;
  final String textColor;

  Tag({
    required this.text,
    required this.color,
    required this.textColor,
  });

  factory Tag.fromJson(Map<String, dynamic> json) => _$TagFromJson(json);
}
