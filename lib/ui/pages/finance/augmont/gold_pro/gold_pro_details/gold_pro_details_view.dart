import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/constants/analytics_events_constants.dart';
import 'package:felloapp/core/enums/app_config_keys.dart';
import 'package:felloapp/core/enums/faqTypes.dart';
import 'package:felloapp/core/model/app_config_model.dart';
import 'package:felloapp/core/model/gold_pro_models/gold_pro_config_model.dart';
import 'package:felloapp/core/model/user_funt_wallet_model.dart';
import 'package:felloapp/core/service/analytics/analytics_service.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/architecture/base_view.dart';
import 'package:felloapp/ui/pages/finance/augmont/gold_pro/gold_pro_details/gold_pro_details_vm.dart';
import 'package:felloapp/ui/pages/finance/augmont/gold_pro/gold_pro_transactions/gold_pro_mini_txn.dart';
import 'package:felloapp/ui/pages/hometabs/save/gold_components/gold_balance_brief_row.dart';
import 'package:felloapp/ui/pages/hometabs/save/gold_components/gold_pro_card.dart';
import 'package:felloapp/ui/pages/hometabs/save/gold_components/gold_pro_hero_card.dart';
import 'package:felloapp/ui/pages/hometabs/save/gold_components/gold_rate_graph.dart';
import 'package:felloapp/ui/pages/login/login_components/login_support.dart';
import 'package:felloapp/ui/pages/static/new_square_background.dart';
import 'package:felloapp/ui/pages/static/youtube_player_view.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/constants.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class GoldProDetailsView extends StatelessWidget {
  const GoldProDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseView<GoldProDetailsViewModel>(
      onModelReady: (model) => model.init(),
      onModelDispose: (model) => model.dump(),
      builder: (context, model, child) => Scaffold(
        body: Stack(
          children: [
            const NewSquareBackground(),
            RefreshIndicator(
              onRefresh: model.pullToRefresh,
              backgroundColor: Colors.black,
              color: UiConstants.kGoldProPrimary,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Selector<UserService, UserFundWallet>(
                        selector: (p0, p1) => p1.userFundWallet!,
                        builder: (context, wallet, child) {
                          return Container(
                            height: (wallet.wAugFdQty ?? 0) > 0
                                ? (SizeConfig.screenWidth! * 1.03)
                                : SizeConfig.screenWidth! * 0.88,
                            width: SizeConfig.screenWidth,
                            decoration: BoxDecoration(
                              color: UiConstants.kGoldProBgColor,
                              borderRadius: BorderRadius.only(
                                bottomLeft:
                                    Radius.circular(SizeConfig.roundness24),
                                bottomRight:
                                    Radius.circular(SizeConfig.roundness24),
                              ),
                            ),
                            child: Stack(
                              children: [
                                const GoldShimmerWidget(
                                  size: ShimmerSizeEnum.large,
                                ),
                                Builder(builder: (context) {
                                  final subText =
                                      model.goldProConfig?.data?.subText;

                                  if (subText == null || subText.isEmpty) {
                                    return const SizedBox.shrink();
                                  }

                                  return Align(
                                    alignment: Alignment.bottomCenter,
                                    child: GoldProExclusiveLabel(
                                      label: subText,
                                      curvedRadius: CurvedRadius.bottom,
                                    ),
                                  );
                                }),
                                SizedBox(
                                  width: SizeConfig.screenWidth,
                                  child: Stack(
                                    children: [
                                      Align(
                                        alignment: Alignment.center,
                                        child: SizedBox(
                                          width: SizeConfig.screenWidth,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              SizedBox(
                                                height: SizeConfig.padding20 +
                                                    kToolbarHeight / 2,
                                              ),
                                              Container(
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.white
                                                          .withOpacity(0.3),
                                                      blurRadius: 50,
                                                    )
                                                  ],
                                                ),
                                                child: SvgPicture.asset(
                                                  Assets.goldAsset,
                                                  height:
                                                      SizeConfig.screenHeight! *
                                                          0.18,
                                                ),
                                              ),
                                              SizedBox(
                                                height: SizeConfig.padding4,
                                              ),
                                              Text(
                                                Constants.ASSET_GOLD_STAKE,
                                                style: TextStyles
                                                    .rajdhaniSB.title3
                                                    .colour(UiConstants
                                                        .kGoldProPrimary),
                                              ),
                                              SizedBox(
                                                height: SizeConfig.padding4,
                                              ),
                                              Text(
                                                "Lease your Gold with Augmont",
                                                style: TextStyles
                                                    .sourceSans.body2
                                                    .colour(UiConstants
                                                        .KGoldProPrimaryDark),
                                              ),
                                              SizedBox(
                                                height: SizeConfig.padding26,
                                              ),
                                              RichText(
                                                text: TextSpan(
                                                    text: "Earn",
                                                    style: TextStyles
                                                        .sourceSans.body0
                                                        .colour(Colors.white),
                                                    children: [
                                                      TextSpan(
                                                        text:
                                                            " ${AppConfig.getValue(AppConfigKey.goldProInterest).toDouble()}% Extra Gold ",
                                                        style: TextStyles
                                                            .sourceSansB.body0
                                                            .colour(UiConstants
                                                                .kGoldProPrimary),
                                                      ),
                                                      const TextSpan(
                                                        text: "every year",
                                                      )
                                                    ]),
                                                textAlign: TextAlign.center,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      (wallet.wAugFdQty ?? 0) > 0
                                          ? Positioned(
                                              bottom: 0,
                                              left: 0,
                                              right: 0,
                                              child: Transform.translate(
                                                offset: Offset(
                                                    0, SizeConfig.padding44),
                                                child: Container(
                                                  margin: EdgeInsets.symmetric(
                                                      horizontal: SizeConfig
                                                          .pageHorizontalMargins),
                                                  padding: EdgeInsets.all(
                                                      SizeConfig
                                                          .pageHorizontalMargins),
                                                  decoration: BoxDecoration(
                                                    color: UiConstants.grey5,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            SizeConfig
                                                                .roundness24),
                                                  ),
                                                  child:
                                                      const GoldBalanceBriefRow(
                                                    mini: true,
                                                  ),
                                                ),
                                              ),
                                            )
                                          : const SizedBox()
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                    Selector<UserService, UserFundWallet>(
                        selector: (p0, p1) => p1.userFundWallet!,
                        builder: (context, wallet, child) {
                          return SizedBox(
                              height: (wallet.wAugFdQty ?? 0) > 0
                                  ? SizeConfig.padding70
                                  : SizeConfig.padding24);
                        }),
                    const LineGradientChart(isPro: true),
                    GoldProInterestBreakdownWidget(model: model),
                    // SizedBox(height: SizeConfig.padding14),
                    const GoldProMiniTransactions(),
                    HowGoldProWorksSection(model: model),
                    WhyGoldProSection(model: model),
                    // SizedBox(height: SizeConfig.padding24),
                    const GoldProSellCard(),
                    // Testomonials(type: InvestmentType.AUGGOLD99),

                    SizedBox(height: SizeConfig.pageHorizontalMargins),
                    GoldProFaqs(model: model),

                    SizedBox(height: SizeConfig.padding20),
                    // const SaveAssetsFooter(),
                    SizedBox(height: SizeConfig.navBarHeight * 2),
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: SafeArea(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    BackButton(
                      color: Colors.white,
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    Padding(
                      padding: EdgeInsets.only(right: SizeConfig.padding8),
                      child: const FaqPill(
                        type: FaqsType.goldPro,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                color: UiConstants.kBackgroundColor,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: SizeConfig.padding16),
                    Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Text("Powered by ",
                            style: TextStyles.body3.colour(Colors.grey)),
                        SvgPicture.asset(
                          Assets.augmontLogo,
                          color: Colors.grey,
                          height: SizeConfig.body4,
                        )
                      ],
                    ),
                    Padding(
                        padding: EdgeInsets.only(
                            top: SizeConfig.padding8,
                            bottom: SizeConfig.pageHorizontalMargins,
                            left: SizeConfig.pageHorizontalMargins,
                            right: SizeConfig.pageHorizontalMargins),
                        child: MaterialButton(
                          height: SizeConfig.padding44,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  SizeConfig.roundness12)),
                          onPressed: () => locator<BaseUtil>()
                              .openGoldProBuyView(
                                  location: "Gold Pro Details View"),
                          minWidth: SizeConfig.screenWidth,
                          color: UiConstants.kGoldProPrimary,
                          child: Text(
                            "EARN ${AppConfig.getValue(AppConfigKey.goldProInterest).toDouble()}% EXTRA RETURNS",
                            style:
                                TextStyles.rajdhaniB.body1.colour(Colors.black),
                          ),
                        )),
                    SizedBox(
                      height: SizeConfig.viewInsets.bottom,
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class GoldProFaqs extends StatelessWidget {
  const GoldProFaqs({
    required this.model,
    super.key,
  });

  final GoldProDetailsViewModel model;

  @override
  Widget build(BuildContext context) {
    return (model.goldProConfig?.data?.faqs ?? []).isNotEmpty
        ? Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: SizeConfig.padding16),
                child: Text(
                  "Frequently Asked Questions",
                  style: TextStyles.rajdhaniSB.title4.colour(Colors.white),
                ),
              ),
              SizedBox(
                width: SizeConfig.screenWidth,
                child: Column(
                  children: [
                    Theme(
                      data: ThemeData(brightness: Brightness.dark),
                      child: ExpansionPanelList(
                        animationDuration: const Duration(milliseconds: 600),
                        expandedHeaderPadding: const EdgeInsets.all(0),
                        dividerColor:
                            UiConstants.kDividerColor.withOpacity(0.3),
                        elevation: 0,
                        children: List.generate(
                          model.faqHeaders.length,
                          (index) => ExpansionPanel(
                            backgroundColor: Colors.transparent,
                            canTapOnHeader: true,
                            headerBuilder: (ctx, isOpen) => Padding(
                              padding: EdgeInsets.only(
                                top: SizeConfig.padding20,
                                left: SizeConfig.pageHorizontalMargins,
                                bottom: SizeConfig.padding20,
                              ),
                              child: Text(model.faqHeaders[index] ?? "",
                                  style: TextStyles.sourceSans.body2
                                      .colour(Colors.white)),
                            ),
                            isExpanded: model.detStatus[index],
                            body: Container(
                              margin: EdgeInsets.symmetric(
                                  horizontal: SizeConfig.pageHorizontalMargins),
                              alignment: Alignment.centerLeft,
                              child: Text(model.faqResponses[index]!,
                                  textAlign: TextAlign.start,
                                  style: TextStyles.body3
                                      .colour(UiConstants.kFAQsAnswerColor)),
                            ),
                          ),
                        ),
                        expansionCallback: (i, isOpen) {
                          model.updateDetStatus(i, !isOpen);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          )
        : const SizedBox();
  }
}

class GoldProSellCard extends StatelessWidget {
  const GoldProSellCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Selector<UserService, UserFundWallet?>(
      selector: (p0, p1) => p1.userFundWallet,
      builder: (context, wallet, child) {
        return (wallet?.wAugFdQty ?? 0) > 0 ? child! : const SizedBox();
      },
      child: Container(
        padding: EdgeInsets.all(SizeConfig.pageHorizontalMargins),
        margin: EdgeInsets.all(SizeConfig.pageHorizontalMargins),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(SizeConfig.roundness16),
            color: UiConstants.kGoldProPrimaryDark2),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Transfer ${Constants.ASSET_GOLD_STAKE}",
              style: TextStyles.sourceSansSB.body0.colour(Colors.black),
            ),
            SizedBox(height: SizeConfig.padding12),
            Row(
              children: [
                Expanded(
                    child: Text(
                  "Get the lease back in your Digital Gold wallet",
                  style: TextStyles.sourceSans.body3.colour(Colors.black),
                )),
                SizedBox(width: SizeConfig.padding18),
                MaterialButton(
                  onPressed: () {
                    AppState.delegate!.parseRoute(Uri.parse("goldProSell"));
                    final userService = locator<UserService>();
                    locator<AnalyticsService>().track(
                        eventName: AnalyticsEvents.unleaseOnGoldProDetailsPage,
                        properties: {
                          "current gold value":
                              userService.userPortfolio.augmont.fd.balance,
                          "current gold weight":
                              userService.userFundWallet?.wAugFdQty ?? 0,
                        });
                  },
                  color: Colors.white,
                  height: SizeConfig.padding44,
                  minWidth: SizeConfig.screenWidth! * 0.3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(SizeConfig.roundness8),
                  ),
                  child: Text(
                    "UN-LEASE",
                    style: TextStyles.rajdhaniB.body1.colour(Colors.black),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}

class GoldProInterestBreakdownWidget extends StatelessWidget {
  const GoldProInterestBreakdownWidget({
    required this.model,
    super.key,
  });

  final GoldProDetailsViewModel model;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(SizeConfig.pageHorizontalMargins),
      padding: EdgeInsets.symmetric(
        vertical: SizeConfig.pageHorizontalMargins,
        horizontal: SizeConfig.pageHorizontalMargins / 2,
      ),
      decoration: BoxDecoration(
        color: UiConstants.grey5,
        borderRadius: BorderRadius.circular(SizeConfig.roundness24),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                  flex: 4,
                  child: Column(
                    children: [
                      Wrap(
                        crossAxisAlignment: WrapCrossAlignment.end,
                        children: [
                          Text(
                            "${model.goldProConfig?.data?.interestBreakDown?.fixed?.title ?? '2.75%'} ",
                            style: TextStyles.sourceSansSB.title4
                                .colour(UiConstants.kGoldProPrimary),
                          ),
                          Text(
                            "p.a",
                            style: TextStyles.body3.colour(Colors.white),
                          )
                        ],
                      ),
                      SizedBox(height: SizeConfig.padding4),
                      Text(
                        model.goldProConfig?.data?.interestBreakDown?.fixed
                                ?.subTitle ??
                            'credited daily',
                        style: TextStyles.body3.colour(Colors.white),
                      )
                    ],
                  )),
              Expanded(
                flex: 6,
                child: Column(
                  children: [
                    Wrap(
                      crossAxisAlignment: WrapCrossAlignment.end,
                      children: [
                        Text(
                          "${model.goldProConfig?.data?.interestBreakDown?.extra?.title ?? '1.75%'} ",
                          style: TextStyles.sourceSansSB.title4
                              .colour(UiConstants.kGoldProPrimary),
                        ),
                        Text(
                          "p.a",
                          style: TextStyles.body3.colour(Colors.white),
                        )
                      ],
                    ),
                    SizedBox(height: SizeConfig.padding4),
                    Text(
                      model.goldProConfig?.data?.interestBreakDown?.extra
                              ?.subTitle ??
                          'credited every 6 months',
                      style: TextStyles.body3.colour(Colors.white),
                    )
                  ],
                ),
              )
            ],
          ),
          SizedBox(height: SizeConfig.padding20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                model.goldProConfig?.data?.interestBreakDown?.subText ??
                    '10K + Users are enjoying ${AppConfig.getValue(AppConfigKey.goldProInterest).toDouble()}% Extra Gold',
                style: TextStyles.body4.colour(UiConstants.KGoldProPrimaryDark),
              )
            ],
          )
        ],
      ),
    );
  }
}

class HowGoldProWorksSection extends StatelessWidget {
  const HowGoldProWorksSection({
    required this.model,
    super.key,
  });

  final GoldProDetailsViewModel model;

  @override
  Widget build(BuildContext context) {
    return (model.goldProConfig?.data?.videos ?? []).isNotEmpty
        ? Container(
            margin: EdgeInsets.symmetric(vertical: SizeConfig.padding14),
            child: Column(
              children: [
                Text(
                  "How ${Constants.ASSET_GOLD_STAKE} works?",
                  style: TextStyles.rajdhaniSB.title3.colour(Colors.white),
                ),
                SizedBox(height: SizeConfig.padding16),
                SizedBox(
                  height: SizeConfig.screenWidth! * 0.5,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: EdgeInsets.symmetric(
                        horizontal: SizeConfig.pageHorizontalMargins),
                    itemBuilder: (context, i) => GestureDetector(
                      onTap: () {
                        final UserService userService = locator<UserService>();
                        BaseUtil.openDialog(
                            isBarrierDismissible: true,
                            addToScreenStack: true,
                            hapticVibrate: true,
                            barrierColor: Colors.black54,
                            content: Dialog(
                                child: YoutubePlayerView(
                                    url: model.goldProConfig!.data!.videos![i]
                                        .src!)));
                        locator<AnalyticsService>().track(
                          eventName: AnalyticsEvents.videoTappedOnGoldPro,
                          properties: {
                            "existing lease amount":
                                userService.userPortfolio.augmont.fd.balance,
                            "existing lease grams":
                                userService.userFundWallet?.wAugFdQty ?? 0
                          },
                        );
                      },
                      child: Container(
                        width: SizeConfig.screenWidth! * 0.36,
                        margin: EdgeInsets.only(right: SizeConfig.padding16),
                        decoration: BoxDecoration(
                          // color: UiConstants.KGoldProPrimaryDark,
                          image: DecorationImage(
                            image: NetworkImage(
                                'https://img.youtube.com/vi/${model.goldProConfig!.data!.videos![i].src!.substring(model.goldProConfig!.data!.videos![i].src!.length - 11)}/0.jpg'),
                            fit: BoxFit.cover,
                          ),
                          borderRadius:
                              BorderRadius.circular(SizeConfig.roundness16),
                        ),
                        alignment: Alignment.center,
                        child: Image.network(
                          Assets.youtubeLogo,
                          width: SizeConfig.padding54,
                        ),
                      ),
                    ),
                    itemCount: model.goldProConfig!.data!.videos!.length,
                  ),
                )
              ],
            ),
          )
        : const SizedBox();
  }
}

class WhyGoldProSection extends StatelessWidget {
  const WhyGoldProSection({
    required this.model,
    super.key,
  });
  final GoldProDetailsViewModel model;

  @override
  Widget build(BuildContext context) {
    final highlights = model.goldProConfig?.data?.highlights ?? [];

    if (highlights.isEmpty) {
      return const SizedBox();
    }

    return Container(
      margin: EdgeInsets.symmetric(vertical: SizeConfig.padding14),
      child: Column(
        children: [
          Text(
            "Why ${Constants.ASSET_GOLD_STAKE}?",
            style: TextStyles.rajdhaniSB.title3.colour(Colors.white),
          ),
          SizedBox(
            height: SizeConfig.padding16,
          ),
          SizedBox(
            height: SizeConfig.screenWidth! * 0.45,
            child: ListView.builder(
              itemCount: model.goldProConfig!.data!.highlights!.length,
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(
                  horizontal: SizeConfig.pageHorizontalMargins),
              itemBuilder: (context, index) => HighLightCard(
                highlight: highlights[index],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class HighLightCard extends StatelessWidget {
  const HighLightCard({
    required this.highlight,
    super.key,
  });

  final Highlights highlight;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: SizeConfig.screenWidth! * 0.38,
      margin: EdgeInsets.only(right: SizeConfig.padding16),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [
          UiConstants.KGoldProPrimaryDark,
          const Color(0xffEAAC4D),
        ], begin: Alignment.bottomLeft, end: Alignment.topRight),
        borderRadius: BorderRadius.circular(
          SizeConfig.roundness24,
        ),
      ),
      alignment: Alignment.center,
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(
              SizeConfig.roundness24,
            ),
            child: const GoldShimmerWidget(
              size: ShimmerSizeEnum.small,
              primary: Colors.white24,
              secondary: Color(0xffF7C463),
              tertiary: Colors.white24,
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: SizeConfig.padding6,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: SizeConfig.padding24,
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        highlight.title!,
                        style: TextStyles.rajdhaniB.title0.colour(Colors.black),
                      ),
                    ),
                  ),
                  Text(
                    highlight.subTitle!,
                    style: TextStyles.sourceSansSB.body0.colour(Colors.black),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: SizeConfig.padding24,
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
