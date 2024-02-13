import 'package:json_annotation/json_annotation.dart';

part 'app_config_serialized_model.g.dart';

const _deserializable = JsonSerializable(
  createToJson: false,
);

class AppConfigV2 {
  const AppConfigV2._();

  static AppConfigV2Data? _instance;

  static init(Map<String, dynamic> json) {
    _instance ??= AppConfigV2Data.fromJson(json);
  }

  static AppConfigV2Data get instance {
    assert(_instance != null, 'message');
    return _instance!;
  }
}

@_deserializable
class AppConfigV2Data {
  final String loginAssetUrl;

  final num invalidateBefore;

  final bool autosaveActive;

  final num referralBonus;

  final num referralFlcBonus;
  @JsonKey(name: "tambolaDailyPickCount")
  final num tamBolaDailyPickCount;
  @JsonKey(name: "tambolaCost")
  final num tamBolaCost;

  final num minPrincipleForPrize;

  final num minWithdrawablePrize;

  final String appShareMessage;

  final String activePgAndroid;

  final String activePgIos;

  final String enabledPspApps;
  @JsonKey(name: "paytmMid")
  final String payTmMid;

  final String rzpMid;

  final bool enableDailyBonus;
  @JsonKey(name: "enableTruecallerLogin")
  final bool enableTrueCallerLogin;

  final bool changeAppIcon;

  final bool showNewAutosave;

  final bool enableJourney;

  final bool canChangePostMaturityPreference;
  @JsonKey(name: "LENDBOXP2P")
  final List<Lendboxp2P> lendBoxP2P;

  final List<String> youtubeVideos;

  final List<String> ticketsYoutubeVideos;

  final TicketsCategories? ticketsCategories;
  @JsonKey(name: "powerplayConfig")
  final PowerPlayConfig? powerPlayConfig;

  final RevampedReferralsConfig? revampedReferralsConfig;

  final QuizConfig? quizConfig;

  final String appReferralMessage;

  final bool paymentBriefView;

  final bool useNewUrlUserOps;

  final OverrideUrls? overrideUrls;

  final num goldProMinimumInvestment;

  final List<num> goldProInvestmentChips;

  final num goldProInterest;

  final List<QuickAction> quickActions;

  final Map<String, dynamic> features;

  const AppConfigV2Data({
    this.loginAssetUrl = '',
    this.invalidateBefore = 0,
    this.autosaveActive = false,
    this.referralBonus = 0,
    this.referralFlcBonus = 0,
    this.tamBolaDailyPickCount = 0,
    this.tamBolaCost = 0,
    this.minPrincipleForPrize = 0,
    this.minWithdrawablePrize = 0,
    this.appShareMessage = '',
    this.activePgAndroid = '',
    this.activePgIos = '',
    this.enabledPspApps = '',
    this.payTmMid = '',
    this.rzpMid = '',
    this.enableDailyBonus = false,
    this.enableTrueCallerLogin = false,
    this.changeAppIcon = false,
    this.showNewAutosave = false,
    this.enableJourney = false,
    this.canChangePostMaturityPreference = false,
    this.lendBoxP2P = const [],
    this.youtubeVideos = const [],
    this.ticketsYoutubeVideos = const [],
    this.ticketsCategories,
    this.powerPlayConfig,
    this.revampedReferralsConfig,
    this.quizConfig,
    this.appReferralMessage = '',
    this.paymentBriefView = false,
    this.useNewUrlUserOps = false,
    this.overrideUrls,
    this.goldProMinimumInvestment = 0,
    this.goldProInvestmentChips = const [],
    this.goldProInterest = 0,
    this.quickActions = const [],
    this.features = const {},
  });

  factory AppConfigV2Data.fromJson(Map<String, dynamic> json) =>
      _$AppConfigV2DataFromJson(json);
}

@_deserializable
class Lendboxp2P {
  final String fundType;

  final String maturityPeriodText;

  final String minAmountText;

  final String descText;
  @JsonKey(name: "tambolaMultiplier")
  final num tamBolaMultiplier;

  final bool isForOldLb;

  const Lendboxp2P({
    this.fundType = '',
    this.maturityPeriodText = '',
    this.minAmountText = '',
    this.descText = '',
    this.tamBolaMultiplier = 0,
    this.isForOldLb = false,
  });

  factory Lendboxp2P.fromJson(Map<String, dynamic> json) =>
      _$Lendboxp2PFromJson(json);
}

@_deserializable
class OverrideUrls {
  final String userOps;

  final String rewards;

  const OverrideUrls({
    this.userOps = '',
    this.rewards = '',
  });

  factory OverrideUrls.fromJson(Map<String, dynamic> json) =>
      _$OverrideUrlsFromJson(json);
}

@_deserializable
class PowerPlayConfig {
  final SaveScreen? saveScreen;

  final HowScreen? howScreen;

  final PredictScreen? predictScreen;

  const PowerPlayConfig({
    this.saveScreen,
    this.howScreen,
    this.predictScreen,
  });

  factory PowerPlayConfig.fromJson(Map<String, dynamic> json) =>
      _$PowerPlayConfigFromJson(json);
}

@_deserializable
class HowScreen {
  final List<String> tileUrls;

  final PredictionCondition? predictionCondition;

  final List<PredictionReward> predictionReward;

  final SeasonReward? seasonReward;

  const HowScreen({
    this.tileUrls = const [],
    this.predictionCondition,
    this.predictionReward = const [],
    this.seasonReward,
  });

  factory HowScreen.fromJson(Map<String, dynamic> json) =>
      _$HowScreenFromJson(json);
}

@_deserializable
class PredictionCondition {
  @JsonKey(name: "calloutText")
  final String callOutText;
  @JsonKey(name: "calloutIconUrl")
  final String callOutIconUrl;

  final String subText;

  final String explainerUrl;

  const PredictionCondition({
    this.callOutText = '',
    this.callOutIconUrl = '',
    this.subText = '',
    this.explainerUrl = '',
  });

  factory PredictionCondition.fromJson(Map<String, dynamic> json) =>
      _$PredictionConditionFromJson(json);
}

@_deserializable
class PredictionReward {
  final String winnerDesc;

  final String rewardDesc;

  const PredictionReward({
    this.winnerDesc = '',
    this.rewardDesc = '',
  });

  factory PredictionReward.fromJson(Map<String, dynamic> json) =>
      _$PredictionRewardFromJson(json);
}

@_deserializable
class SeasonReward {
  final String asideIcon;

  final String rewardDesc;

  const SeasonReward({
    this.asideIcon = '',
    this.rewardDesc = '',
  });

  factory SeasonReward.fromJson(Map<String, dynamic> json) =>
      _$SeasonRewardFromJson(json);
}

@_deserializable
class PredictScreen {
  @JsonKey(name: "cardCarousel")
  final List<CardCarousel> cardCarousel;

  const PredictScreen({
    this.cardCarousel = const [],
  });

  factory PredictScreen.fromJson(Map<String, dynamic> json) =>
      _$PredictScreenFromJson(json);
}

@_deserializable
class CardCarousel {
  final String imgUrl;

  final String onTapLink;

  const CardCarousel({
    this.imgUrl = '',
    this.onTapLink = '',
  });

  factory CardCarousel.fromJson(Map<String, dynamic> json) =>
      _$CardCarouselFromJson(json);
}

@_deserializable
class SaveScreen {
  final String title;

  final String subtitle;

  const SaveScreen({
    this.title = '',
    this.subtitle = '',
  });

  factory SaveScreen.fromJson(Map<String, dynamic> json) =>
      _$SaveScreenFromJson(json);
}

@_deserializable
class QuickAction {
  final String name;

  final String img;
  @JsonKey(name: "deeplink")
  final String deepLink;

  final String color;

  const QuickAction({
    this.name = '',
    this.img = '',
    this.deepLink = '',
    this.color = '',
  });

  factory QuickAction.fromJson(Map<String, dynamic> json) =>
      _$QuickActionFromJson(json);
}

@_deserializable
class QuizConfig {
  final String title;

  final String image;
  @JsonKey(name: "deeplink")
  final String deepLink;

  final String baseUrl;

  const QuizConfig({
    this.title = '',
    this.image = '',
    this.deepLink = '',
    this.baseUrl = '',
  });

  factory QuizConfig.fromJson(Map<String, dynamic> json) =>
      _$QuizConfigFromJson(json);
}

@_deserializable
class RevampedReferralsConfig {
  final SaveScreen? hero;

  final List<HowReferralWorks> how;

  final RewardValues? rewardValues;

  final Stats? stats;

  const RevampedReferralsConfig({
    this.hero,
    this.how = const [],
    this.rewardValues,
    this.stats,
  });

  factory RevampedReferralsConfig.fromJson(Map<String, dynamic> json) =>
      _$RevampedReferralsConfigFromJson(json);
}

@_deserializable
class HowReferralWorks {
  final String image;

  final String text;

  const HowReferralWorks({
    this.image = '',
    this.text = '',
  });

  factory HowReferralWorks.fromJson(Map<String, dynamic> json) =>
      _$HowReferralWorksFromJson(json);
}

@_deserializable
class RewardValues {
  final num invest1K;
  @JsonKey(name: "invest10kflo12")
  final num invest10KFlo12;

  const RewardValues({
    this.invest1K = 0,
    this.invest10KFlo12 = 0,
  });

  factory RewardValues.fromJson(Map<String, dynamic> json) =>
      _$RewardValuesFromJson(json);
}

@_deserializable
class Stats {
  final String referrersCount;

  final String usersFromReferrals;

  final String rewardsFromReferrals;

  const Stats({
    this.referrersCount = '',
    this.usersFromReferrals = '',
    this.rewardsFromReferrals = '',
  });

  factory Stats.fromJson(Map<String, dynamic> json) => _$StatsFromJson(json);
}

@_deserializable
class TicketsCategories {
  @JsonKey(name: "category_1")
  final String category1;
  @JsonKey(name: "category_2")
  final String category2;
  @JsonKey(name: "category_3")
  final String category3;
  @JsonKey(name: "category_4")
  final String category4;
  @JsonKey(name: "category_5")
  final String category5;

  const TicketsCategories({
    this.category1 = '',
    this.category2 = '',
    this.category3 = '',
    this.category4 = '',
    this.category5 = '',
  });

  factory TicketsCategories.fromJson(Map<String, dynamic> json) =>
      _$TicketsCategoriesFromJson(json);
}
