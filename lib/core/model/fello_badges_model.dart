import 'package:felloapp/core/model/action.dart';
import 'package:json_annotation/json_annotation.dart';

part 'fello_badges_model.g.dart';

const _serializable = JsonSerializable(
  explicitToJson: true,
);

@_serializable
class FelloBadgesModel {
  final String message;
  final FelloBadgesData data;

  const FelloBadgesModel({
    required this.data,
    this.message = '',
  });

  factory FelloBadgesModel.fromJson(Map<String, dynamic> json) =>
      _$FelloBadgesModelFromJson(json);

  Map<String, dynamic> toJson() => _$FelloBadgesModelToJson(this);
}

@_serializable
class FelloBadgesData {
  final String title;
  final List<Level> levels;
  final SuperFelloWorks superFelloWorks;
  final List<BadgeLevelInformation> otherBadges;

  const FelloBadgesData({
    required this.superFelloWorks,
    this.otherBadges = const [],
    this.levels = const [],
    this.title = '',
  });

  factory FelloBadgesData.fromJson(Map<String, dynamic> json) =>
      _$FelloBadgesDataFromJson(json);

  Map<String, dynamic> toJson() => _$FelloBadgesDataToJson(this);
}

@_serializable
class LevelBenefit {
  const LevelBenefit({
    this.title = '',
    this.list = const [],
  });

  final String title;
  final List<String> list;

  factory LevelBenefit.fromJson(Map<String, dynamic> json) =>
      _$LevelBenefitFromJson(json);

  Map<String, dynamic> toJson() => _$LevelBenefitToJson(this);
}

enum SuperFelloLevel {
  BEGINNER(0),
  INTERMEDIATE(1),
  SUPERFELLO(2);

  const SuperFelloLevel(this.level);
  final int level;
}

@_serializable
class Level {
  final String badgeurl;
  final LevelBenefit benefits;
  @JsonKey(name: 'lvl_data')
  final List<BadgeLevelInformation> lvlData;
  final bool isCompleted;
  @JsonKey(name: 'lvl_title')
  final String levelTitle;
  final SuperFelloLevel level;

  const Level({
    required this.benefits,
    required this.level,
    this.badgeurl = '',
    this.lvlData = const [],
    this.isCompleted = false,
    this.levelTitle = '',
  });

  factory Level.fromJson(Map<String, dynamic> json) => _$LevelFromJson(json);

  Map<String, dynamic> toJson() => _$LevelToJson(this);
}

@_serializable
class BadgeLevelInformation {
  final num achieve;
  final String title;
  final String barHeading;
  final String badgeurl;
  final String referText;
  final String bottomSheetText;
  final String bottomSheetCta;
  final Action? ctaAction;
  final String id;
  final bool isBadgeAchieved;

  const BadgeLevelInformation({
    this.achieve = 0.0,
    this.title = '',
    this.barHeading = '',
    this.badgeurl = '',
    this.referText = '',
    this.bottomSheetText = '',
    this.bottomSheetCta = '',
    this.ctaAction,
    this.id = '',
    this.isBadgeAchieved = false,
  });

  factory BadgeLevelInformation.fromJson(Map<String, dynamic> json) =>
      _$BadgeLevelInformationFromJson(json);

  Map<String, dynamic> toJson() => _$BadgeLevelInformationToJson(this);
}

@_serializable
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

  Map<String, dynamic> toJson() => _$SuperFelloWorksToJson(this);
}
