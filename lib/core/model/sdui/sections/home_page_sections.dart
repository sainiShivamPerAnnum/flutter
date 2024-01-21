import 'package:felloapp/core/model/action.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'home_page_sections.freezed.dart';
part 'home_page_sections.g.dart';

const _deserializable = JsonSerializable(
  createToJson: false,
);

@_deserializable
class PageData {
  final Styles styles;
  final ScreenData screens;

  const PageData({
    required this.styles,
    required this.screens,
  });

  factory PageData.fromJson(Map<String, dynamic> json) =>
      _$PageDataFromJson(json);
}

@_deserializable
class ScreenData {
  final HomePageScreenData home;
  final AssetPreferenceData assetPreference;

  const ScreenData({
    required this.home,
    required this.assetPreference,
  });

  factory ScreenData.fromJson(Map<String, dynamic> json) =>
      _$ScreenDataFromJson(json);
}

@_deserializable
class AssetPreferenceData {
  final String title;
  final String subtitle;
  final List<AssetPrefOption> options;
  final BottomSheetComponent notSure;
  final BottomSheetComponent skipToHome;

  const AssetPreferenceData({
    required this.notSure,
    required this.skipToHome,
    this.title = '',
    this.subtitle = '',
    this.options = const [],
  });

  factory AssetPreferenceData.fromJson(Map<String, dynamic> json) =>
      _$AssetPreferenceDataFromJson(json);
}

enum AssetPrefType {
  P2P,
  GOLD,
  NONE;

  bool get isNone => this == AssetPrefType.NONE;
}

@_deserializable
class AssetPrefOption {
  final AssetPrefType assetType;
  final String icon;
  final String title;
  final String description;
  final List<AssetOptionInfo> info;
  final Map<String, dynamic> events;

  const AssetPrefOption({
    this.assetType = AssetPrefType.GOLD,
    this.events = const {},
    this.icon = '',
    this.title = '',
    this.description = '',
    this.info = const [],
  });

  factory AssetPrefOption.fromJson(Map<String, dynamic> json) =>
      _$AssetPrefOptionFromJson(json);
}

@_deserializable
class AssetOptionInfo {
  final String title;
  final String subtitle;

  const AssetOptionInfo({
    this.title = '',
    this.subtitle = '',
  });

  factory AssetOptionInfo.fromJson(Map<String, dynamic> json) =>
      _$AssetOptionInfoFromJson(json);
}

@_deserializable
class BottomSheetComponent {
  final BottomSheetData data;

  const BottomSheetComponent(this.data);

  factory BottomSheetComponent.fromJson(Map<String, dynamic> json) =>
      _$BottomSheetComponentFromJson(json);
}

@_deserializable
class BottomSheetData {
  final String title;
  final String subtitle;
  final String image;
  final List<Cta> cta;

  const BottomSheetData({
    this.title = '',
    this.subtitle = '',
    this.image = '',
    this.cta = const [],
  });

  factory BottomSheetData.fromJson(Map<String, dynamic> json) =>
      _$BottomSheetDataFromJson(json);
}

enum CTAType {
  secondary,
  secondaryOutline;
}

@_deserializable
class Cta {
  final String label;
  @JsonKey(unknownEnumValue: CTAType.secondary)
  final CTAType style;
  final Action? action;

  const Cta({
    this.label = '',
    this.style = CTAType.secondary,
    this.action,
  });

  factory Cta.fromJson(Map<String, dynamic> json) => _$CtaFromJson(json);
}

@_deserializable
class HomePageScreenData {
  final Map<String, HomePageSection> sections;
  final List<String> sectionOrder;

  const HomePageScreenData({
    this.sections = const {},
    this.sectionOrder = const [],
  });

  factory HomePageScreenData.fromJson(Map<String, dynamic> json) =>
      _$HomePageScreenDataFromJson(json);
}

@Freezed(unionKey: 'type', toJson: false)
sealed class HomePageSection with _$HomePageSection {
  @FreezedUnionValue('stories')
  const factory HomePageSection.stories(StoriesData data) = StoriesSection;

  @FreezedUnionValue('steps')
  const factory HomePageSection.steps(StepsData data) = StepsSection;

  @FreezedUnionValue('infoCards')
  const factory HomePageSection.quickActions(QuickActionsCardsData data) =
      QuickActions;

  @FreezedUnionValue('image')
  const factory HomePageSection.image(ImageSectionData data) = ImageSection;

  /// TODO(@DK070202): Placeholder thing here.
  @FreezedUnionValue('nudgeCard')
  const factory HomePageSection.nudge() = NudgeSection;

  factory HomePageSection.fromJson(Map<String, dynamic> json) =>
      _$HomePageSectionFromJson(json);
}

@_deserializable
class QuickActionsCardsData {
  final String title;
  final List<QuickActionCard> cards;

  const QuickActionsCardsData({
    required this.title,
    this.cards = const [],
  });

  factory QuickActionsCardsData.fromJson(Map<String, dynamic> json) =>
      _$QuickActionsCardsDataFromJson(json);
}

@_deserializable
class QuickActionCard {
  final String icon;
  final String title;
  final String subtitle;
  final Action? action;
  final String style;

  const QuickActionCard({
    required this.style,
    this.icon = '',
    this.title = '',
    this.subtitle = '',
    this.action,
  });

  factory QuickActionCard.fromJson(Map<String, dynamic> json) =>
      _$QuickActionCardFromJson(json);
}

@_deserializable
class ImageSectionData {
  final String url;
  final Action? action;

  const ImageSectionData({
    this.action,
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
  final String title;
  final String subtitle;
  final String thumbnail;
  final String blurHash;
  final String story;
  final List<Cta> cta;
  final String style;
  final String id;
  final int order;
  final Map<String, dynamic> events;

  const Story({
    this.cta = const [],
    this.title = '',
    this.subtitle = '',
    this.thumbnail = '',
    this.blurHash = '',
    this.story = '',
    this.id = '',
    this.order = 0,
    this.style = 'tl3',
    this.events = const {},
  });

  factory Story.fromJson(Map<String, dynamic> json) => _$StoryFromJson(json);
}

@_deserializable
class StepsData {
  final String title;
  final List<Step> steps;

  const StepsData({
    this.title = '',
    this.steps = const [],
  });

  factory StepsData.fromJson(Map<String, dynamic> json) =>
      _$StepsDataFromJson(json);
}

@_deserializable
class Step {
  final String icon;
  final String title;
  final String description;
  final String ctaLabel;
  final String style;
  final Cta cta;

  const Step({
    required this.style,
    required this.cta,
    this.icon = '',
    this.title = '',
    this.description = '',
    this.ctaLabel = '',
  });

  factory Step.fromJson(Map<String, dynamic> json) => _$StepFromJson(json);
}

@_deserializable
class Styles {
  final Map<String, StepStyle> steps;
  final Map<String, InfoCardStyle> infoCards;
  final Map<String, StoryStyle> stories;

  const Styles({
    this.steps = const {},
    this.infoCards = const {},
    this.stories = const {},
  });

  factory Styles.fromJson(Map<String, dynamic> json) => _$StylesFromJson(json);
}

@_deserializable
class StoryStyle {
  final String subtitleColor;

  const StoryStyle(this.subtitleColor);

  factory StoryStyle.fromJson(Map<String, dynamic> json) =>
      _$StoryStyleFromJson(json);
}

@_deserializable
class StepStyle {
  final String shadowColor;
  final String ctaColor;
  final String ctaBgColor;

  const StepStyle(
    this.shadowColor,
    this.ctaBgColor,
    this.ctaColor,
  );

  factory StepStyle.fromJson(Map<String, dynamic> json) =>
      _$StepStyleFromJson(json);
}

@_deserializable
class InfoCardStyle {
  final String bgColor;

  const InfoCardStyle({
    this.bgColor = '',
  });

  factory InfoCardStyle.fromJson(Map<String, dynamic> json) =>
      _$InfoCardStyleFromJson(json);
}
