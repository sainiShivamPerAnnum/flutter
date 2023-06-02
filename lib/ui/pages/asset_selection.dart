import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/enums/investment_type.dart';
import 'package:felloapp/core/enums/marketing_event_handler_enum.dart';
import 'package:felloapp/core/model/happy_hour_campign.dart';
import 'package:felloapp/core/service/notifier_services/marketing_event_handler_service.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/feature/tambola/tambola.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/architecture/base_view.dart';
import 'package:felloapp/ui/pages/finance/augmont/gold_buy/augmont_buy_vm.dart';
import 'package:felloapp/ui/pages/hometabs/save/flo_components/flo_permium_card.dart';
import 'package:felloapp/ui/pages/hometabs/save/save_components/save_banner.dart';
import 'package:felloapp/ui/pages/root/root_controller.dart';
import 'package:felloapp/ui/pages/static/gold_rate_card.dart';
import 'package:felloapp/util/constants.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:property_change_notifier/property_change_notifier.dart';
import 'package:provider/provider.dart';

class AssetSelectionPage extends StatelessWidget {
  const AssetSelectionPage(
      {Key? key,
      required this.showOnlyFlo,
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
    return Scaffold(
      backgroundColor: const Color(0xff232326),
      body: Padding(
        padding:
            EdgeInsets.symmetric(horizontal: SizeConfig.pageHorizontalMargins),
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
                  AppState.backButtonDispatcher?.didPopRoute();
                },
              ),
              title: Text(
                'Select plan to save',
                style: TextStyles.rajdhaniSB.title5,
              ),
            ),
            if (!showOnlyFlo) SizedBox(height: SizeConfig.padding24),
            if (!showOnlyFlo) GoldPlanWidget(fetchGoldRate: !showOnlyFlo),
            SizedBox(height: SizeConfig.padding24),
            FloPlanWidget(amount: amount, isSkipMl: isSkipMl),
          ],
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

    return GestureDetector(
      onTap: () {
        //todo: redirect to flo details page
      },
      child: Container(
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
                // const Spacer(),
                // SvgPicture.asset(
                //   'assets/svg/Arrow_dotted.svg',
                //   height: SizeConfig.padding24,
                //   width: SizeConfig.padding24,
                // ),
              ],
            ),
            SizedBox(height: SizeConfig.padding16),
            FelloFloPrograms(
              percentage: '12%',
              isRecommended: true,
              chipString1: '6 month maturity',
              chipString2: 'Min - ₹10,000',
              floAssetType: Constants.ASSET_TYPE_FLO_FIXED_6,
              amount: amount,
              isSkipMl: isSkipMl,
            ),
            SizedBox(width: SizeConfig.padding12),
            FelloFloPrograms(
              percentage: '10%',
              isRecommended: false,
              chipString1:
                  isLendboxOldUser ? "1 month lockin" : '3 month maturity',
              chipString2: isLendboxOldUser ? 'Min - ₹100' : 'Min - ₹1000',
              floAssetType: isLendboxOldUser
                  ? Constants.ASSET_TYPE_FLO_FELXI
                  : Constants.ASSET_TYPE_FLO_FIXED_3,
              amount: amount,
              isSkipMl: isSkipMl,
            ),
            SizedBox(width: SizeConfig.padding12),
            if (!isLendboxOldUser)
              FelloFloPrograms(
                percentage: '8%',
                isRecommended: false,
                chipString1: '1 week lockin',
                chipString2: 'Min - ₹100',
                floAssetType: Constants.ASSET_TYPE_FLO_FELXI,
                amount: amount,
                isSkipMl: isSkipMl,
              ),
          ],
        ),
      ),
    );
  }
}

class GoldPlanWidget extends StatelessWidget {
  const GoldPlanWidget({
    super.key,
    required this.fetchGoldRate,
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
          // AppState.backButtonDispatcher?.didPopRoute();
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
                        'Save in Digital Gold',
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
                  SvgPicture.asset(
                    'assets/svg/Arrow_dotted.svg',
                    height: SizeConfig.padding24,
                    width: SizeConfig.padding24,
                  ),
                ],
              ),
              SizedBox(height: SizeConfig.padding34),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: SizeConfig.padding16,
                  vertical: SizeConfig.padding16,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xffD9D9D9).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
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
      );
    });
  }
}

class FelloFloPrograms extends StatelessWidget {
  const FelloFloPrograms(
      {Key? key,
      required this.percentage,
      required this.isRecommended,
      required this.chipString1,
      required this.chipString2,
      required this.floAssetType,
      this.amount,
      this.isSkipMl})
      : super(key: key);

  final String percentage;
  final bool isRecommended;
  final String chipString1;
  final String chipString2;
  final String floAssetType;
  final int? amount;
  final bool? isSkipMl;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (isRecommended)
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: SizeConfig.padding8,
              vertical: SizeConfig.padding2,
            ),
            decoration: const BoxDecoration(
              color: Color(0xff62E3C4),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(5),
                topRight: Radius.circular(5),
              ),
            ),
            child: Text(
              'Recommended',
              style: TextStyles.sourceSans.body5.colour(Colors.black),
            ),
          ),
        // if (!isRecommended) const Spacer(),
        GestureDetector(
          onTap: () {
            // AppState.backButtonDispatcher?.didPopRoute();
            BaseUtil.openFloBuySheet(
                floAssetType: floAssetType, amt: amount, isSkipMl: isSkipMl);
          },
          child: Container(
            margin:
                EdgeInsets.only(top: isRecommended ? 0 : SizeConfig.padding12),
            padding: EdgeInsets.symmetric(
              vertical: SizeConfig.padding12,
              horizontal: SizeConfig.padding12,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(SizeConfig.roundness5),
              color: const Color(0xffD9D9D9).withOpacity(0.2),
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
                          style: TextStyles.rajdhaniSB.title2
                              .colour(Colors.white.withOpacity(0.8)),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(width: SizeConfig.padding2),
                        Column(
                          children: [
                            Text(
                              'Returns',
                              style: TextStyles.sourceSansSB.body3
                                  .colour(Colors.white.withOpacity(0.8)),
                            ),
                            SizedBox(
                              height: SizeConfig.padding8,
                            )
                          ],
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        FloPremiumTierChip(value: chipString1),
                        SizedBox(width: SizeConfig.padding4),
                        FloPremiumTierChip(value: chipString2),
                      ],
                    ),
                  ],
                ),
                SvgPicture.asset(
                  'assets/svg/Arrow_dotted.svg',
                  height: SizeConfig.padding24,
                  width: SizeConfig.padding24,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
