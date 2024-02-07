// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_config_serialized_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppConfigV2Data _$AppConfigV2DataFromJson(Map<String, dynamic> json) =>
    AppConfigV2Data(
      loginAssetUrl: json['loginAssetUrl'] as String? ?? '',
      invalidateBefore: json['invalidateBefore'] as num? ?? 0,
      autosaveActive: json['autosaveActive'] as bool? ?? false,
      referralBonus: json['referralBonus'] as num? ?? 0,
      referralFlcBonus: json['referralFlcBonus'] as num? ?? 0,
      tamBolaDailyPickCount: json['tambolaDailyPickCount'] as num? ?? 0,
      tamBolaCost: json['tambolaCost'] as num? ?? 0,
      minPrincipleForPrize: json['minPrincipleForPrize'] as num? ?? 0,
      minWithdrawablePrize: json['minWithdrawablePrize'] as num? ?? 0,
      appShareMessage: json['appShareMessage'] as String? ?? '',
      activePgAndroid: json['activePgAndroid'] as String? ?? '',
      activePgIos: json['activePgIos'] as String? ?? '',
      enabledPspApps: json['enabledPspApps'] as String? ?? '',
      payTmMid: json['paytmMid'] as String? ?? '',
      rzpMid: json['rzpMid'] as String? ?? '',
      enableDailyBonus: json['enableDailyBonus'] as bool? ?? false,
      enableTrueCallerLogin: json['enableTruecallerLogin'] as bool? ?? false,
      changeAppIcon: json['changeAppIcon'] as bool? ?? false,
      showNewAutosave: json['showNewAutosave'] as bool? ?? false,
      enableJourney: json['enableJourney'] as bool? ?? false,
      canChangePostMaturityPreference:
          json['canChangePostMaturityPreference'] as bool? ?? false,
      lendBoxP2P: (json['LENDBOXP2P'] as List<dynamic>?)
              ?.map((e) => Lendboxp2P.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      youtubeVideos: (json['youtubeVideos'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      ticketsYoutubeVideos: (json['ticketsYoutubeVideos'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      ticketsCategories: json['ticketsCategories'] == null
          ? null
          : TicketsCategories.fromJson(
              json['ticketsCategories'] as Map<String, dynamic>),
      powerPlayConfig: json['powerplayConfig'] == null
          ? null
          : PowerPlayConfig.fromJson(
              json['powerplayConfig'] as Map<String, dynamic>),
      revampedReferralsConfig: json['revampedReferralsConfig'] == null
          ? null
          : RevampedReferralsConfig.fromJson(
              json['revampedReferralsConfig'] as Map<String, dynamic>),
      quizConfig: json['quizConfig'] == null
          ? null
          : QuizConfig.fromJson(json['quizConfig'] as Map<String, dynamic>),
      appReferralMessage: json['appReferralMessage'] as String? ?? '',
      paymentBriefView: json['paymentBriefView'] as bool? ?? false,
      useNewUrlUserOps: json['useNewUrlUserOps'] as bool? ?? false,
      overrideUrls: json['overrideUrls'] == null
          ? null
          : OverrideUrls.fromJson(json['overrideUrls'] as Map<String, dynamic>),
      goldProMinimumInvestment: json['goldProMinimumInvestment'] as num? ?? 0,
      goldProInvestmentChips: (json['goldProInvestmentChips'] as List<dynamic>?)
              ?.map((e) => e as num)
              .toList() ??
          const [],
      goldProInterest: json['goldProInterest'] as num? ?? 0,
      quickActions: (json['quickActions'] as List<dynamic>?)
              ?.map((e) => QuickAction.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      features: json['features'] as Map<String, dynamic>? ?? const {},
    );

Lendboxp2P _$Lendboxp2PFromJson(Map<String, dynamic> json) => Lendboxp2P(
      fundType: json['fundType'] as String? ?? '',
      maturityPeriodText: json['maturityPeriodText'] as String? ?? '',
      minAmountText: json['minAmountText'] as String? ?? '',
      descText: json['descText'] as String? ?? '',
      tamBolaMultiplier: json['tambolaMultiplier'] as num? ?? 0,
      isForOldLb: json['isForOldLb'] as bool? ?? false,
    );

OverrideUrls _$OverrideUrlsFromJson(Map<String, dynamic> json) => OverrideUrls(
      userOps: json['userOps'] as String? ?? '',
      rewards: json['rewards'] as String? ?? '',
    );

PowerPlayConfig _$PowerPlayConfigFromJson(Map<String, dynamic> json) =>
    PowerPlayConfig(
      saveScreen: json['saveScreen'] == null
          ? null
          : SaveScreen.fromJson(json['saveScreen'] as Map<String, dynamic>),
      howScreen: json['howScreen'] == null
          ? null
          : HowScreen.fromJson(json['howScreen'] as Map<String, dynamic>),
      predictScreen: json['predictScreen'] == null
          ? null
          : PredictScreen.fromJson(
              json['predictScreen'] as Map<String, dynamic>),
    );

HowScreen _$HowScreenFromJson(Map<String, dynamic> json) => HowScreen(
      tileUrls: (json['tileUrls'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      predictionCondition: json['predictionCondition'] == null
          ? null
          : PredictionCondition.fromJson(
              json['predictionCondition'] as Map<String, dynamic>),
      predictionReward: (json['predictionReward'] as List<dynamic>?)
              ?.map((e) => PredictionReward.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      seasonReward: json['seasonReward'] == null
          ? null
          : SeasonReward.fromJson(json['seasonReward'] as Map<String, dynamic>),
    );

PredictionCondition _$PredictionConditionFromJson(Map<String, dynamic> json) =>
    PredictionCondition(
      callOutText: json['calloutText'] as String? ?? '',
      callOutIconUrl: json['calloutIconUrl'] as String? ?? '',
      subText: json['subText'] as String? ?? '',
      explainerUrl: json['explainerUrl'] as String? ?? '',
    );

PredictionReward _$PredictionRewardFromJson(Map<String, dynamic> json) =>
    PredictionReward(
      winnerDesc: json['winnerDesc'] as String? ?? '',
      rewardDesc: json['rewardDesc'] as String? ?? '',
    );

SeasonReward _$SeasonRewardFromJson(Map<String, dynamic> json) => SeasonReward(
      asideIcon: json['asideIcon'] as String? ?? '',
      rewardDesc: json['rewardDesc'] as String? ?? '',
    );

PredictScreen _$PredictScreenFromJson(Map<String, dynamic> json) =>
    PredictScreen(
      cardCarousel: (json['cardCarousel'] as List<dynamic>?)
              ?.map((e) => CardCarousel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

CardCarousel _$CardCarouselFromJson(Map<String, dynamic> json) => CardCarousel(
      imgUrl: json['imgUrl'] as String? ?? '',
      onTapLink: json['onTapLink'] as String? ?? '',
    );

SaveScreen _$SaveScreenFromJson(Map<String, dynamic> json) => SaveScreen(
      title: json['title'] as String? ?? '',
      subtitle: json['subtitle'] as String? ?? '',
    );

QuickAction _$QuickActionFromJson(Map<String, dynamic> json) => QuickAction(
      name: json['name'] as String? ?? '',
      img: json['img'] as String? ?? '',
      deepLink: json['deeplink'] as String? ?? '',
      color: json['color'] as String? ?? '',
    );

QuizConfig _$QuizConfigFromJson(Map<String, dynamic> json) => QuizConfig(
      title: json['title'] as String? ?? '',
      image: json['image'] as String? ?? '',
      deepLink: json['deeplink'] as String? ?? '',
      baseUrl: json['baseUrl'] as String? ?? '',
    );

RevampedReferralsConfig _$RevampedReferralsConfigFromJson(
        Map<String, dynamic> json) =>
    RevampedReferralsConfig(
      hero: json['hero'] == null
          ? null
          : SaveScreen.fromJson(json['hero'] as Map<String, dynamic>),
      how: (json['how'] as List<dynamic>?)
              ?.map((e) => How.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      rewardValues: json['rewardValues'] == null
          ? null
          : RewardValues.fromJson(json['rewardValues'] as Map<String, dynamic>),
      stats: json['stats'] == null
          ? null
          : Stats.fromJson(json['stats'] as Map<String, dynamic>),
    );

How _$HowFromJson(Map<String, dynamic> json) => How(
      image: json['image'] as String? ?? '',
      text: json['text'] as String? ?? '',
    );

RewardValues _$RewardValuesFromJson(Map<String, dynamic> json) => RewardValues(
      invest1K: json['invest1K'] as num? ?? 0,
      invest10KFlo12: json['invest10kflo12'] as num? ?? 0,
    );

Stats _$StatsFromJson(Map<String, dynamic> json) => Stats(
      referrersCount: json['referrersCount'] as String? ?? '',
      usersFromReferrals: json['usersFromReferrals'] as String? ?? '',
      rewardsFromReferrals: json['rewardsFromReferrals'] as String? ?? '',
    );

TicketsCategories _$TicketsCategoriesFromJson(Map<String, dynamic> json) =>
    TicketsCategories(
      category1: json['category_1'] as String? ?? '',
      category2: json['category_2'] as String? ?? '',
      category3: json['category_3'] as String? ?? '',
      category4: json['category_4'] as String? ?? '',
      category5: json['category_5'] as String? ?? '',
    );
