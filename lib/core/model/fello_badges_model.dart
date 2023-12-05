import 'package:json_annotation/json_annotation.dart';

part 'fello_badges_model.g.dart';

const _deserializable = JsonSerializable(
  createToJson: false,
);

@_deserializable
class FelloBadgesModel {
  final String message;
  final FelloBadgesData data;

  const FelloBadgesModel({
    required this.data,
    this.message = '',
  });

  factory FelloBadgesModel.fromJson(Map<String, dynamic> json) =>
      _$FelloBadgesModelFromJson(json);
}

@_deserializable
class FelloBadgesData {
  final String title;

  final List<Level> levels;
  final SuperFelloWorks superFelloWorks;

  const FelloBadgesData({
    required this.superFelloWorks,
    this.levels = const [],
    this.title = '',
  });

  factory FelloBadgesData.fromJson(Map<String, dynamic> json) =>
      _$FelloBadgesDataFromJson(json);
}

@_deserializable
class LevelBenefit {
  const LevelBenefit({
    this.title = '',
    this.list = const [],
  });

  final String title;
  final List<String> list;

  factory LevelBenefit.fromJson(Map<String, dynamic> json) =>
      _$LevelBenefitFromJson(json);
}

@_deserializable
class Level {
  final String badgeurl;
  final LevelBenefit benefits;
  @JsonKey(name: 'lvl_data')
  final List<LevelData> lvlData;
  final bool isCompleted;

  const Level({
    required this.benefits,
    this.badgeurl = '',
    this.lvlData = const [],
    this.isCompleted = false,
  });

  factory Level.fromJson(Map<String, dynamic> json) => _$LevelFromJson(json);
}

@_deserializable
class LevelData {
  final num achieve;
  final String title;
  final String barHeading;
  final String badgeurl;
  final String referText;
  final String bottomSheetText;
  final String bottomSheetCta;
  final String ctaUrl;
  final DateTime updatedAt;

  const LevelData({
    required this.updatedAt,
    this.achieve = 0.0,
    this.title = '',
    this.barHeading = '',
    this.badgeurl = '',
    this.referText = '',
    this.bottomSheetText = '',
    this.bottomSheetCta = '',
    this.ctaUrl = '',
  });

  factory LevelData.fromJson(Map<String, dynamic> json) =>
      _$LevelDataFromJson(json);
}

@_deserializable
class SuperFelloWorks {
  @JsonKey(name: 'main_text')
  final String mainText;
  @JsonKey(name: 'sub_text')
  final List<String> subText;

  const SuperFelloWorks({
    this.mainText = '',
    this.subText = const [],
  });

  factory SuperFelloWorks.fromJson(Map<String, dynamic> json) =>
      _$SuperFelloWorksFromJson(json);
}
