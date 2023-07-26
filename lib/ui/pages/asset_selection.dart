// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';

import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/constants/analytics_events_constants.dart';
import 'package:felloapp/core/enums/app_config_keys.dart';
import 'package:felloapp/core/enums/investment_type.dart';
import 'package:felloapp/core/enums/marketing_event_handler_enum.dart';
import 'package:felloapp/core/model/app_config_model.dart';
import 'package:felloapp/core/model/happy_hour_campign.dart';
import 'package:felloapp/core/service/analytics/analytics_service.dart';
import 'package:felloapp/core/service/notifier_services/marketing_event_handler_service.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/feature/tambola/tambola.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/architecture/base_view.dart';
import 'package:felloapp/ui/pages/finance/augmont/gold_buy/augmont_buy_vm.dart';
import 'package:felloapp/ui/pages/finance/lendbox/detail_page/flo_premium_details_view.dart';
import 'package:felloapp/ui/pages/hometabs/save/save_components/save_banner.dart';
import 'package:felloapp/ui/pages/root/root_controller.dart';
import 'package:felloapp/ui/pages/static/gold_rate_card.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/constants.dart';
import 'package:felloapp/util/extensions/rich_text_extension.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:property_change_notifier/property_change_notifier.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class AssetSelectionPage extends StatelessWidget {
  const AssetSelectionPage(
      {required this.showOnlyFlo,
      Key? key,
      this.amount,
      this.isSkipMl,
      this.isFromGlobal = false})
      : super(key: key);

  final bool showOnlyFlo;
  final int? amount;
  final bool? isSkipMl;
  final bool isFromGlobal;

  bool _showHappyHour() {
    if (locator<RootController>().currentNavBarItemModel ==
        RootController.tambolaNavBar) {
      return (locator<TambolaService>().bestTickets?.data?.totalTicketCount ??
          0) >
          0;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    log("AssetSelectionPage:: amount: $amount & isSkipMl: $isSkipMl & showOnlyFlo: $showOnlyFlo & isFromGlobal: $isFromGlobal",
        name: "AssetSelectionPage");

    return Scaffold(
      backgroundColor: const Color(0xff232326),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: SizeConfig.pageHorizontalMargins),
          child: Column(
            children: [
              if (isFromGlobal) SizedBox(height: SizeConfig.fToolBarHeight / 2),
              AppBar(
                elevation: 0,
                backgroundColor: Colors.transparent,
                leading: IconButton(
                  icon: const Icon(
                    Icons.arrow_back_ios,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    locator<AnalyticsService>().track(
                      eventName: AnalyticsEvents.savePageClosed,
                    );

                    AppState.backButtonDispatcher?.didPopRoute();
                  },
                ),
                title: Text(
                  'Select plan to save',
                  style: TextStyles.rajdhaniSB.title5,
                ),
              ),
              if (!showOnlyFlo) SizedBox(height: SizeConfig.padding24),
              if (!showOnlyFlo)
                GoldPlanWidget(
                  fetchGoldRate: !showOnlyFlo,
                  isSkipMl: isSkipMl,
                  amount: amount,
                ),
              SizedBox(height: SizeConfig.padding24),
              FloPlanWidget(amount: amount, isSkipMl: isSkipMl),
            ],
          ),
        ),
      ),
      bottomNavigationBar: PropertyChangeProvider<MarketingEventHandlerService,
          MarketingEventsHandlerProperties>(
        value: locator<MarketingEventHandlerService>(),
        child: PropertyChangeConsumer<MarketingEventHandlerService,
            MarketingEventsHandlerProperties>(
          properties: const [MarketingEventsHandlerProperties.HappyHour],
          builder: (context, state, _) {
            return !state!.showHappyHourBanner
                ? const SizedBox()
                : Consumer<AppState>(
              builder: (ctx, m, child) {
                return AnimatedContainer(
                  height: !(locator<RootController>()
                      .currentNavBarItemModel ==
                      RootController.journeyNavBarItem ||
                      !_showHappyHour())
                      ? SizeConfig.navBarHeight
                      : -50,
                  alignment: Alignment.bottomCenter,
                  duration: const Duration(milliseconds: 400),
                  child: HappyHourBanner(
                    model: locator<HappyHourCampign>(),
                    isComingFromSave: true,
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class FloPlanWidget extends StatelessWidget {
  const FloPlanWidget({super.key, this.amount, this.isSkipMl});

  final int? amount;
  final bool? isSkipMl;

  @override
  Widget build(BuildContext context) {
    bool isLendboxOldUser =
    locator<UserService>().userSegments.contains(Constants.US_FLO_OLD);
    List lendboxDetails = AppConfig.getValue(AppConfigKey.lendbox);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: SizeConfig.padding16,
        vertical: SizeConfig.padding16,
      ),
      decoration: BoxDecoration(
        color: const Color(0xff01656B),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SvgPicture.asset(
                'assets/svg/fello_flo.svg',
                height: SizeConfig.padding44,
                width: SizeConfig.padding44,
                fit: BoxFit.cover,
              ),
              SizedBox(width: SizeConfig.padding12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Save in Fello Flo',
                    style: TextStyles.rajdhaniSB.body0,
                  ),
                  SizedBox(height: SizeConfig.padding4),
                  Text(
                    'P2P Asset • RBI Certified',
                    style: TextStyles.sourceSans.body4
                        .colour(Colors.white.withOpacity(0.8)),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: SizeConfig.padding26),
          FelloFloPrograms(
            percentage: '12%',
            isRecommended: true,
            chipString1: lendboxDetails[0]["maturityPeriodText"],
            chipString2: lendboxDetails[0]["minAmountText"],
            floAssetType: Constants.ASSET_TYPE_FLO_FIXED_6,
            amount: amount,
            isSkipMl: isSkipMl,
            promoText: lendboxDetails[0]["tambolaMultiplier"] != null
                ? "Get *${lendboxDetails[0]["tambolaMultiplier"]}X tickets* on saving"
                : null,
            // promoText: "Get *5X tickets* on saving",
          ),
          // SizedBox(height: SizeConfig.padding12),
          FelloFloPrograms(
            percentage: '10%',
            isRecommended: false,
            chipString1: isLendboxOldUser
                ? lendboxDetails[2]["maturityPeriodText"]
                : lendboxDetails[1]["maturityPeriodText"] ?? "1 Week Lockin",
            chipString2: isLendboxOldUser
                ? lendboxDetails[2]["minAmountText"]
                : lendboxDetails[1]["minAmountText"] ?? 'Min - ₹1000',
            floAssetType: isLendboxOldUser
                ? Constants.ASSET_TYPE_FLO_FELXI
                : Constants.ASSET_TYPE_FLO_FIXED_3,
            amount: amount,
            isSkipMl: isSkipMl,
            promoText: isLendboxOldUser
                ? lendboxDetails[2]["tambolaMultiplier"] != null
                ? "Get *${lendboxDetails[2]["tambolaMultiplier"]}X tickets* on saving"
                : null
                : lendboxDetails[1]["tambolaMultiplier"] != null
                ? "Get *${lendboxDetails[1]["tambolaMultiplier"]}X tickets* on saving"
                : null,
          ),
          // SizedBox(height: SizeConfig.padding12),
          if (!isLendboxOldUser)
            FelloFloPrograms(
                percentage: '8%',
                isRecommended: false,
                chipString1:
                lendboxDetails[3]["maturityPeriodText"] ?? "1 Week Lockin",
                chipString2: lendboxDetails[3]["minAmountText"] ?? 'Min - ₹100',
                floAssetType: Constants.ASSET_TYPE_FLO_FELXI,
                amount: amount,
                isSkipMl: isSkipMl,
                promoText: null),
        ],
      ),
    );
  }
}

class GoldPlanWidget extends StatelessWidget {
  const GoldPlanWidget({
    required this.fetchGoldRate,
    super.key,
    this.amount,
    this.isSkipMl,
  });

  final bool fetchGoldRate;
  final int? amount;
  final bool? isSkipMl;

  @override
  Widget build(BuildContext context) {
    return BaseView<GoldBuyViewModel>(onModelReady: (model) {
      if (fetchGoldRate) {
        model.fetchGoldRates();
      }
    }, builder: (ctx, model, child) {
      return GestureDetector(
        onTap: () {
          locator<AnalyticsService>().track(
              eventName: AnalyticsEvents.assetSelectionProceed,
              properties: {
                'Asset': 'Gold',
                'Market Rate': model.goldRates?.goldBuyPrice,
              });

          BaseUtil().openRechargeModalSheet(
              investmentType: InvestmentType.AUGGOLD99,
              amt: amount,
              isSkipMl: isSkipMl);
        },
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: SizeConfig.padding16,
            vertical: SizeConfig.padding16,
          ),
          decoration: BoxDecoration(
            color: const Color(0xff495DB2),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SvgPicture.asset(
                    'assets/svg/digitalgold.svg',
                    height: SizeConfig.padding44,
                    width: SizeConfig.padding44,
                    fit: BoxFit.cover,
                  ),
                  SizedBox(width: SizeConfig.padding12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Digital Gold',
                        style: TextStyles.rajdhaniSB.body0,
                      ),
                      SizedBox(height: SizeConfig.padding4),
                      Text(
                        '24K Gold • Withdraw anytime • 100% Secure',
                        style: TextStyles.sourceSans.body4
                            .colour(Colors.white.withOpacity(0.8)),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: SizeConfig.padding34),
              DigitalGoldPrograms(
                title: "Save in ${Constants.ASSET_GOLD_STAKE}",
                model: model,
                showRates: false,
                isRecommended: true,
                promoText: "*4.5% Extra Gold* by saving Min *0.5g* in Gold",
                amount: amount,
                isSkipMl: isSkipMl,
                isPro: true,
              ),
              DigitalGoldPrograms(
                title: "Save in Gold",
                model: model,
                showRates: true,
                amount: amount,
                isSkipMl: isSkipMl,
              )
            ],
          ),
        ),
      );
    });
  }
}

class FelloFloPrograms extends StatelessWidget {
  const FelloFloPrograms(
      {required this.percentage,
      required this.isRecommended,
      required this.chipString1,
      required this.chipString2,
      required this.floAssetType,
      Key? key,
      this.amount,
      this.isSkipMl,
      this.promoText})
      : super(key: key);

  final String percentage;
  final bool isRecommended;
  final String chipString1;
  final String chipString2;
  final String floAssetType;
  final int? amount;
  final bool? isSkipMl;
  final String? promoText;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
          onTap: () {
            BaseUtil.openFloBuySheet(
                floAssetType: floAssetType, amt: amount, isSkipMl: isSkipMl);

            locator<AnalyticsService>().track(
                eventName: AnalyticsEvents.assetSelectionProceed,
                properties: {
                  'Asset': floAssetType,
                  'Slab Return Percentage': percentage,
                  'Slab Lockin Period': chipString1,
                  'Recommended': isRecommended,
                });
          },
          child: Container(
            margin:
            EdgeInsets.only(top: isRecommended ? 0 : SizeConfig.padding12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(SizeConfig.roundness8),
              color: const Color(0xFF246F74),
              boxShadow: [
                BoxShadow(
                  color: const Color(0x3F000000).withOpacity(0.1),
                  blurRadius: 2,
                  offset: const Offset(0, 1),
                  spreadRadius: 0,
                )
              ],
            ),
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                    vertical: SizeConfig.padding12,
                    horizontal: SizeConfig.padding12,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(SizeConfig.roundness5),
                    color: const Color(0xffD9D9D9).withOpacity(0.15),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                percentage,
                                style: TextStyles.sourceSansSB.title3
                                    .colour(Colors.white.withOpacity(0.8)),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(width: SizeConfig.padding2),
                              Column(
                                children: [
                                  Text(
                                    'Flo',
                                    style: TextStyles.sourceSansSB.body3
                                        .colour(Colors.white.withOpacity(0.8)),
                                  ),
                                  SizedBox(
                                    height: SizeConfig.padding4,
                                  )
                                ],
                              ),
                            ],
                          ),
                          SizedBox(height: SizeConfig.padding8),
                          Text(chipString1, style: TextStyles.sourceSans.body4)
                        ],
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          SvgPicture.asset(
                            'assets/svg/Arrow_dotted.svg',
                            height: SizeConfig.padding24,
                            width: SizeConfig.padding24,
                          ),
                          SizedBox(height: SizeConfig.padding12),
                          Text(chipString2, style: TextStyles.sourceSans.body4)
                        ],
                      ),
                    ],
                  ),
                ),
                if (promoText != null && promoText!.isNotEmpty)
                  Container(
                    padding: EdgeInsets.symmetric(
                      vertical: SizeConfig.padding6,
                    ),
                    decoration: ShapeDecoration(
                      // color: const Color(0xFF246F74),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(SizeConfig.roundness8),
                          bottomRight: Radius.circular(SizeConfig.roundness8),
                        ),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          'assets/svg/tambola_icon.svg',
                          height: SizeConfig.padding16,
                        ),
                        SizedBox(width: SizeConfig.padding4),
                        promoText!.beautify(
                          boldStyle:
                          TextStyles.sourceSansB.body4.colour(Colors.white),
                          style:
                          TextStyles.sourceSans.body4.colour(Colors.white),
                        ),
                      ],
                    ),
                  )
              ],
            ),
          ),
        ),
        if (isRecommended)
          Transform.translate(
            offset: Offset(0, -SizeConfig.padding12),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                margin: EdgeInsets.only(
                  left: SizeConfig.screenWidth! / 8,
                ),
                width: SizeConfig.screenWidth! * 0.5,
                child: const AvailabilityOfferWidget(),
              ),
            ),
          ),
      ],
    );
  }
}

class AvailabilityOfferWidget extends StatelessWidget {
  const AvailabilityOfferWidget({
    this.text,
    this.color,
    this.width,
    super.key,
  });

  final String? text;
  final Color? color;
  final double? width;

  @override
  Widget build(BuildContext context) {
    final daysRemaining = BaseUtil.calculateRemainingDays(DateTime(2023, 9, 1));

    return Stack(
      children: [
        Container(
          // alignment: Alignment.center,
          padding: EdgeInsets.symmetric(
              horizontal: SizeConfig.padding12, vertical: SizeConfig.padding2),
          decoration: BoxDecoration(
            color: color ?? const Color(0xff62E3C4),
            borderRadius: BorderRadius.circular(SizeConfig.roundness12),
          ),
          child: Shimmer.fromColors(
            period: const Duration(milliseconds: 2500),
            baseColor: Colors.grey[900]!,
            highlightColor: Colors.grey[100]!,
            loop: 3,
            child:
                (text ?? "Available only for *$daysRemaining days*").beautify(
              boldStyle: TextStyles.sourceSansB.body4.colour(Colors.white),
              style: TextStyles.sourceSans.body4.colour(Colors.white),
              alignment: TextAlign.center,
            ),
          ),
        ),
        Positioned(
          right: 30,
          child: CustomPaint(
            size: Size(
                SizeConfig.padding14, (SizeConfig.padding14 * 1.09).toDouble()),
            painter: StarCustomPainter(),
          ),
        ),
        Positioned(
          right: 22,
          child: CustomPaint(
            size: Size(
                SizeConfig.padding8, (SizeConfig.padding8 * 1.09).toDouble()),
            painter: StarCustomPainter(),
          ),
        )
      ],
    );
  }
}

class DigitalGoldPrograms extends StatelessWidget {
  final String title;
  final bool showRates;
  final bool isRecommended;
  final int? amount;
  final bool? isSkipMl;
  final String? promoText;
  final GoldBuyViewModel model;
  final bool isPro;

  const DigitalGoldPrograms({
    required this.title,
    this.isRecommended = false,
    this.showRates = false,
    Key? key,
    this.amount,
    this.isSkipMl = false,
    this.promoText,
    this.isPro = false,
    required this.model,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
          onTap: () {
            if (isPro) {
              BaseUtil.openGoldProBuyView();
            } else {
              BaseUtil().openRechargeModalSheet(
                  investmentType: InvestmentType.AUGGOLD99);

              locator<AnalyticsService>().track(
                  eventName: AnalyticsEvents.assetSelectionProceed,
                  properties: {
                    'Asset': InvestmentType.AUGGOLD99.name,
                    'Recommended': isRecommended,
                  });
            }
          },
          child: Container(
            margin:
                EdgeInsets.only(top: isRecommended ? 0 : SizeConfig.padding12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(SizeConfig.roundness8),
              color: const Color(0xffD9D9D9).withOpacity(0.1),
              boxShadow: [
                BoxShadow(
                  color: const Color(0x3F000000).withOpacity(0.1),
                  blurRadius: 2,
                  offset: const Offset(0, 1),
                  spreadRadius: 0,
                )
              ],
            ),
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                    vertical: SizeConfig.padding12,
                    horizontal: SizeConfig.padding12,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(SizeConfig.roundness5),
                    color: const Color(0xffD9D9D9).withOpacity(0.15),
                  ),
                  child: Column(
                    children: [
                      SizedBox(height: SizeConfig.padding8),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            title,
                            style: TextStyles.sourceSansSB.body0
                                .colour(Colors.white),
                            textAlign: TextAlign.center,
                          ),
                          const Spacer(),
                          SvgPicture.asset(
                            Assets.chevRonRightArrow,
                            color: Colors.white,
                            height: SizeConfig.padding24,
                            width: SizeConfig.padding24,
                          ),
                        ],
                      ),
                      if (showRates)
                        Container(
                          margin: EdgeInsets.only(top: SizeConfig.padding20),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Market Rate',
                                style: TextStyles.sourceSans.body3,
                              ),
                              const Spacer(),
                              model.isGoldRateFetching
                                  ? SpinKitThreeBounce(
                                      size: SizeConfig.body2,
                                      color: Colors.white,
                                    )
                                  : Text(
                                      "₹ ${(model.goldRates != null ? model.goldRates!.goldBuyPrice : 0.0)?.toStringAsFixed(2)}/gm",
                                      style: TextStyles.sourceSansSB.body1
                                          .colour(Colors.white),
                                    ),
                              NewCurrentGoldPriceWidget(
                                fetchGoldRates: model.fetchGoldRates,
                                goldprice: model.goldRates != null
                                    ? model.goldRates!.goldBuyPrice
                                    : 0.0,
                                isFetching: model.isGoldRateFetching,
                                mini: true,
                                textColor: Colors.white,
                              ),
                            ],
                          ),
                        )
                    ],
                  ),
                ),
                if (promoText != null && promoText!.isNotEmpty)
                  Container(
                    padding: EdgeInsets.symmetric(
                      vertical: SizeConfig.padding6,
                    ),
                    decoration: ShapeDecoration(
                      // color: const Color(0xFF246F74),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(SizeConfig.roundness8),
                          bottomRight: Radius.circular(SizeConfig.roundness8),
                        ),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          Assets.dailyAppBonusHero,
                          height: SizeConfig.padding16,
                        ),
                        SizedBox(width: SizeConfig.padding4),
                        promoText!.beautify(
                          boldStyle:
                              TextStyles.sourceSansB.body4.colour(Colors.white),
                          style:
                              TextStyles.sourceSans.body4.colour(Colors.white),
                        ),
                      ],
                    ),
                  )
              ],
            ),
          ),
        ),
        if (isRecommended)
          Transform.translate(
            offset: Offset(0, -SizeConfig.padding12),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                margin: EdgeInsets.only(
                  left: SizeConfig.screenWidth! / 8,
                ),
                width: SizeConfig.screenWidth! * 0.39,
                child: const AvailabilityOfferWidget(
                    color: UiConstants.kBlogTitleColor,
                    text: "*16% Returns p.a*"),
              ),
            ),
          ),
      ],
    );
  }
}
