// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_config_serialized_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppConfigV2Data _$AppConfigV2DataFromJson(Map<String, dynamic> json) =>
    AppConfigV2Data(
      contactDetails: json['contactDetails'] as String? ?? "support@fello.in",
      socialBtnTxt: json['socialBtnTxt'] as String? ?? "Raise a Ticket",
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
      lendBoxP2Pv2: (json['LENDBOX_P2P_V2'] as List<dynamic>?)
              ?.map((e) =>
                  LendboxAssetConfiguration.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      lbV2: json['p2p_v2'] == null
          ? const {}
          : AppConfigV2Data._convertP2PV2(json['p2p_v2'] as List?),
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
      revampedReferralsConfigV1: json['revampedReferralsConfigV1'] == null
          ? null
          : RevampedReferralsConfig.fromJson(
              json['revampedReferralsConfigV1'] as Map<String, dynamic>),
      quizConfig: json['quizConfig'] == null
          ? null
          : QuizConfig.fromJson(json['quizConfig'] as Map<String, dynamic>),
      appReferralMessageV1: json['appReferralMessageV1'] as String? ?? '',
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
      socialLinks: (json['socialLinks'] as List<dynamic>?)
              ?.map((e) => SocialItems.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      socialVideos: (json['socialVideos'] as List<dynamic>?)
              ?.map((e) => SocialVideo.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      rpsDisclaimer: json['rpsDisclaimer'] as String? ??
          'This repayment schedule is estimated based on past performance of the loans mapped to you. Past performance is not a guarantee of future returns. Actual repayment amount received will depend on repayments made by the borrowers.',
      rpsLearnMore: (json['rpsLearnMore'] as List<dynamic>?)
              ?.map((e) => Map<String, String>.from(e as Map))
              .toList() ??
          const [],
      onboarding: (json['onboarding'] as List<dynamic>?)
              ?.map((e) => Onboarding.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [
            Onboarding(
                title: "Discuss finance with certified experts",
                subtitle:
                    "Book one-on-one sessions with expert  advisors who understand your goals.",
                image: Assets.onbaording1),
            Onboarding(
                title: "Ask Questions, Get Answers in Live Webinar",
                subtitle:
                    "Ask Questions and Gain Insights by Joining live streams hosted by trusted advisors.",
                image: Assets.onbaording2),
            Onboarding(
                title: "Invest in Digital Gold to get safe Returns",
                subtitle:
                    "Invest in trusted gold at market rates, powered by Augmont and get stable returns.",
                image: Assets.onbaording3)
          ],
    );

LendboxAssetConfiguration _$LendboxAssetConfigurationFromJson(
        Map<String, dynamic> json) =>
    LendboxAssetConfiguration(
      fundType: json['fundType'] as String,
      maturityPeriodText: json['maturityPeriodText'] as String,
      minAmountText: json['minAmountText'] as String,
      descText: json['descText'] as String,
      tambolaMultiplier: json['tambolaMultiplier'] as num,
      reinvestInterestGain: json['reinvestInterestGain'] as num? ?? 0,
      isForOldLb: json['isForOldLb'] as bool? ?? false,
      interest: json['interest'] as num? ?? 10,
      maturityDuration: json['maturityDuration'] as int? ?? 3,
      assetName: json['assetName'] as String? ?? '',
      highlights: json['highlights'] as String? ?? '',
      description: json['description'] as String? ?? '',
      minAmount: json['minAmount'] as num? ?? 100,
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

Onboarding _$OnboardingFromJson(Map<String, dynamic> json) => Onboarding(
      image: json['image'] as String? ?? '',
      title: json['title'] as String? ?? '',
      subtitle: json['subtitle'] as String? ?? '',
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
              ?.map((e) => HowReferralWorks.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      rewardValues: json['rewardValues'] == null
          ? null
          : RewardValues.fromJson(json['rewardValues'] as Map<String, dynamic>),
      stats: json['stats'] == null
          ? null
          : Stats.fromJson(json['stats'] as Map<String, dynamic>),
    );

HowReferralWorks _$HowReferralWorksFromJson(Map<String, dynamic> json) =>
    HowReferralWorks(
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
