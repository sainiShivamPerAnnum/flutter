import 'package:felloapp/core/model/action.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'home_page_sections.freezed.dart';
part 'home_page_sections.g.dart';

const _deserializable = JsonSerializable(
  createToJson: false,
);

@Freezed(unionKey: 'type', toJson: false)
sealed class HomePageSection with _$HomePageSection {
  @FreezedUnionValue('stories')
  const factory HomePageSection.stories(StoriesData data) = StoriesSection;

  @FreezedUnionValue('steps')
  const factory HomePageSection.steps(StepsData data) = StepsSection;

  @FreezedUnionValue('image')
  const factory HomePageSection.image(ImageSectionData data) = ImageSection;

  @FreezedUnionValue('quickActionCards')
  const factory HomePageSection.quickActions(ImageSectionData data) =
      QuickActions;

  factory HomePageSection.fromJson(Map<String, dynamic> json) =>
      _$HomePageSectionFromJson(json);
}

@_deserializable
class QuickActionsCardsData {
  final List<QuickActionCard> cards;

  const QuickActionsCardsData({
    this.cards = const [],
  });

  factory QuickActionsCardsData.fromJson(Map<String, dynamic> json) =>
      _$QuickActionsCardsDataFromJson(json);
}

@_deserializable
class QuickActionCard {
  final int order;
  final String icon;
  final String title;
  final String subtitle;
  final String style;

  const QuickActionCard({
    required this.style,
    this.order = 0,
    this.icon = '',
    this.title = '',
    this.subtitle = '',
  });

  factory QuickActionCard.fromJson(Map<String, dynamic> json) =>
      _$QuickActionCardFromJson(json);
}

@_deserializable
class QuickActionCardStyle {
  final String bgColor;

  const QuickActionCardStyle(
    this.bgColor,
  );

  factory QuickActionCardStyle.fromJson(Map<String, dynamic> json) =>
      _$QuickActionCardStyleFromJson(json);
}

@_deserializable
class ImageSectionData {
  final String url;
  final Action action;

  const ImageSectionData({
    required this.action,
    this.url = '',
  });

  factory ImageSectionData.fromJson(Map<String, dynamic> json) =>
      _$ImageSectionDataFromJson(json);
}

@_deserializable
class StoriesData {
  final List<Story> stories;

  const StoriesData({
    this.stories = const [],
  });

  factory StoriesData.fromJson(Map<String, dynamic> json) =>
      _$StoriesDataFromJson(json);
}

@_deserializable
class Story {
  final int order;
  final String title;
  final String subtitle;
  final String thumbnail;
  final String hash;
  final String story;

  const Story({
    this.order = 0,
    this.title = '',
    this.subtitle = '',
    this.thumbnail = '',
    this.hash = '',
    this.story = '',
  });

  factory Story.fromJson(Map<String, dynamic> json) => _$StoryFromJson(json);
}

@_deserializable
class StepsData {
  final String title;
  final List<Step> steps;
  @StylesConverter()
  final Map<String, StepStyle> styles;

  const StepsData({
    this.title = '',
    this.steps = const [],
    this.styles = const {},
  });

  factory StepsData.fromJson(Map<String, dynamic> json) =>
      _$StepsDataFromJson(json);
}

@_deserializable
class Step {
  final int order;
  final String icon;
  final String title;
  final String description;
  final String ctaLabel;
  final Action action;
  final String style;

  const Step({
    required this.action,
    required this.style,
    this.order = 0,
    this.icon = '',
    this.title = '',
    this.description = '',
    this.ctaLabel = '',
  });

  factory Step.fromJson(Map<String, dynamic> json) => _$StepFromJson(json);
}

class StylesConverter<T>
    extends JsonConverter<Map<String, StepStyle>, Map<String, dynamic>> {
  const StylesConverter();
  @override
  Map<String, StepStyle> fromJson(Map<String, dynamic> json) {
    return json.map<String, StepStyle>(
      (key, value) => MapEntry(key, StepStyle.fromJson(value)),
    );
  }

  @override
  Map<String, dynamic> toJson(Map<String, StepStyle> object) {
    return object.map<String, dynamic>(
      (key, value) => MapEntry(key, value.toJson()),
    );
  }
}

@JsonSerializable()
class StepStyle {
  final String backgroundColor;
  final String ctaLabelColor;
  final String ctaColor;

  const StepStyle(
    this.backgroundColor,
    this.ctaLabelColor,
    this.ctaColor,
  );

  factory StepStyle.fromJson(Map<String, dynamic> json) =>
      _$StepStyleFromJson(json);

  Map<String, dynamic> toJson() => _$StepStyleToJson(this);
}
