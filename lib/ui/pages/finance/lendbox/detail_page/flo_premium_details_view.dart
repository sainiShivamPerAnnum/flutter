// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';

import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/constants/analytics_events_constants.dart';
import 'package:felloapp/core/enums/app_config_keys.dart';
import 'package:felloapp/core/enums/faqTypes.dart';
import 'package:felloapp/core/enums/investment_type.dart';
import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/core/model/app_config_model.dart';
import 'package:felloapp/core/model/lendbox_maturity_response.dart';
import 'package:felloapp/core/service/analytics/analytics_service.dart';
import 'package:felloapp/core/service/lendbox_maturity_service.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/feature/flo_withdrawals/ui/reinvestment_sheet.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/ui/architecture/base_view.dart';
import 'package:felloapp/ui/pages/finance/lendbox/deposit/widget/prompt.dart';
import 'package:felloapp/ui/pages/finance/lendbox/detail_page/flo_premium_details_vm.dart';
import 'package:felloapp/ui/pages/finance/transactions_history/transaction_details_view.dart';
import 'package:felloapp/ui/pages/hometabs/save/flo_components/flo_permium_card.dart';
import 'package:felloapp/ui/pages/hometabs/save/save_components/asset_view_section.dart';
import 'package:felloapp/ui/pages/login/login_components/login_support.dart';
import 'package:felloapp/ui/pages/static/save_assets_footer.dart';
import 'package:felloapp/ui/service_elements/user_service/lendbox_principle_value.dart';
import 'package:felloapp/ui/service_elements/user_service/user_fund_quantity_se.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/constants.dart';
import 'package:felloapp/util/extensions/rich_text_extension.dart';
import 'package:felloapp/util/haptic.dart';
import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class FloPremiumDetailsView extends StatefulWidget {
  final bool is12;

  const FloPremiumDetailsView({required this.is12, super.key});

  @override
  State<FloPremiumDetailsView> createState() => _FloPremiumDetailsViewState();
}

class _FloPremiumDetailsViewState extends State<FloPremiumDetailsView>
    with SingleTickerProviderStateMixin {
  ScrollController? controller;

  AnimationController? _animController;
  Animation<double>? offsetAnim;

  bool _seeAll = false;

  void seeAllClicked() {
    setState(() {
      _seeAll = true;
    });
  }

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    )..addListener(() {
        setState(() {});
      });

    offsetAnim = CurvedAnimation(
        curve: Curves.easeInCubic,
        parent: _animController!,
        reverseCurve: Curves.decelerate);
    controller = ScrollController();
  }

  @override
  void dispose() {
    controller?.dispose();
    _animController!.dispose();
    super.dispose();
    _seeAll = false;
  }

  String getText() {
    List lendboxDetails = AppConfig.getValue(AppConfigKey.lendbox);

    // bool isLendboxOldUser = locator<UserService>().userSegments.contains(Constants.US_FLO_OLD);

    if (widget.is12) {
      return (lendboxDetails[0]["tambolaMultiplier"] != null)
          ? "Get *${lendboxDetails[0]["tambolaMultiplier"]}X tickets* on saving in 12% Flo till maturity"
          : "Get consistent returns on saving in 12% Flo till maturity";
    }

    return (lendboxDetails[1]["tambolaMultiplier"] != null)
        ? "Get *${lendboxDetails[1]["tambolaMultiplier"]}X tickets* on saving in 10% Flo till maturity"
        : "Get consistent returns on saving in 10% Flo till maturity";
  }

  @override
  Widget build(BuildContext context) {
    return BaseView<FloPremiumDetailsViewModel>(
      onModelReady: (model) => model.init(widget.is12),
      onModelDispose: (model) => model.dump(),
      builder: (context, model, _) {
        final value = context.watch<LendboxMaturityService>().callTxnApi;

        WidgetsFlutterBinding.ensureInitialized()
            .addPostFrameCallback((timeStamp) {
          if (value && mounted) {
            model.getTransactions();
            context.read<LendboxMaturityService>().callTxnApi = false;
          }
        });

        return RefreshIndicator(
          color: UiConstants.primaryColor,
          backgroundColor: Colors.black,
          onRefresh: () async {
            // await state.refreshTransactions(widget.type);
            await model.getTransactions();
          },
          child: Scaffold(
            backgroundColor: Colors.black,
            body: Container(
              color: UiConstants.kBackgroundColor,
              child: Stack(
                children: [
                  Container(
                    height: SizeConfig.screenHeight! * 0.5,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                          colors: [
                            UiConstants.kFloContainerColor,
                            const Color(0xff297264).withOpacity(0),
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter),
                    ),
                  ),
                  SafeArea(
                    child: Column(
                      children: [
                        const SizedBox(height: kToolbarHeight * 0.8),
                        Expanded(
                          child: SingleChildScrollView(
                            controller: controller,
                            child: Column(
                              children: [
                                Transform.translate(
                                  offset:
                                      Offset(0, -1 * offsetAnim!.value * 50),
                                  child: AnimatedSwitcher(
                                    duration: const Duration(seconds: 2),
                                    child: model.is12
                                        ? Column(
                                            children: [
                                              FloPremiumHeader(
                                                  key: const ValueKey(
                                                      "12floHeader"),
                                                  model: model),
                                              SizedBox(
                                                  height: SizeConfig.padding32),
                                              if (model.isInvested)
                                                Container(
                                                  margin: EdgeInsets.symmetric(
                                                      horizontal:
                                                          SizeConfig.padding16),
                                                  padding: EdgeInsets.only(
                                                    top: SizeConfig.padding16,
                                                    // horizontal:
                                                    //     SizeConfig.padding16,
                                                  ),
                                                  decoration: ShapeDecoration(
                                                    color:
                                                        const Color(0xFF013B3F),
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      side: const BorderSide(
                                                        width: 1,
                                                        strokeAlign: BorderSide
                                                            .strokeAlignOutside,
                                                        color:
                                                            Color(0xFF326164),
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              16),
                                                    ),
                                                  ),
                                                  child: Column(
                                                    children: [
                                                      Container(
                                                        margin: EdgeInsets
                                                            .symmetric(
                                                          horizontal: SizeConfig
                                                              .padding24,
                                                        ),
                                                        child:
                                                            const FloBalanceBriefRow(
                                                          key: ValueKey(
                                                              "10floBalance"),
                                                          tier: Constants
                                                              .ASSET_TYPE_FLO_FIXED_6,
                                                          mini: true,
                                                          endAlign: true,
                                                        ),
                                                      ),
                                                      SizedBox(
                                                          height: SizeConfig
                                                              .padding16),
                                                      Container(
                                                        margin: EdgeInsets
                                                            .symmetric(
                                                          horizontal: SizeConfig
                                                              .padding16,
                                                        ),
                                                        child:
                                                            FloPremiumTransactionsList(
                                                          key: const ValueKey(
                                                              "12floTxns"),
                                                          model: model,
                                                          seeAll: _seeAll,
                                                        ),
                                                      ),
                                                      SizedBox(
                                                          height: SizeConfig
                                                              .padding8),
                                                      if (model.transactionsList
                                                              .length >
                                                          2)
                                                        GestureDetector(
                                                          onTap: () {
                                                            setState(() {
                                                              _seeAll =
                                                                  !_seeAll;
                                                            });
                                                          },
                                                          child: Container(
                                                            decoration: BoxDecoration(
                                                                color: Colors
                                                                    .white
                                                                    .withOpacity(
                                                                        0.10),
                                                                borderRadius: BorderRadius.only(
                                                                    bottomLeft: Radius.circular(
                                                                        SizeConfig
                                                                            .roundness16),
                                                                    bottomRight:
                                                                        Radius.circular(
                                                                            SizeConfig.roundness16))),
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Text(
                                                                  _seeAll
                                                                      ? 'View less Investments'
                                                                      : 'View more Investments',
                                                                  style: TextStyles
                                                                      .sourceSansSB
                                                                      .body2
                                                                      .colour(Colors
                                                                          .white),
                                                                ),
                                                                SizedBox(
                                                                  width: SizeConfig
                                                                      .padding4,
                                                                ),
                                                                Icon(
                                                                  _seeAll
                                                                      ? Icons
                                                                          .keyboard_arrow_up
                                                                      : Icons
                                                                          .keyboard_arrow_down_outlined,
                                                                  color: Colors
                                                                      .white,
                                                                  size: SizeConfig
                                                                      .padding28,
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        )
                                                    ],
                                                  ),
                                                ),
                                              if (model.isInvested)
                                                SizedBox(
                                                    height:
                                                        SizeConfig.padding16)
                                            ],
                                          )
                                        : Column(
                                            children: [
                                              FloPremiumHeader(
                                                  key: const ValueKey(
                                                      "10floHeader"),
                                                  model: model),
                                              SizedBox(
                                                  height: SizeConfig.padding32),
                                              if (model.isInvested)
                                                Container(
                                                  margin: EdgeInsets.symmetric(
                                                      horizontal:
                                                          SizeConfig.padding16),
                                                  padding: EdgeInsets.only(
                                                    top: SizeConfig.padding16,
                                                    // horizontal:
                                                    //     SizeConfig.padding16,
                                                  ),
                                                  decoration: ShapeDecoration(
                                                    color:
                                                        const Color(0xFF013B3F),
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      side: const BorderSide(
                                                        width: 1,
                                                        strokeAlign: BorderSide
                                                            .strokeAlignOutside,
                                                        color:
                                                            Color(0xFF326164),
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              16),
                                                    ),
                                                  ),
                                                  child: Column(
                                                    children: [
                                                      if (model.isInvested)
                                                        Container(
                                                          margin: EdgeInsets
                                                              .symmetric(
                                                            horizontal:
                                                                SizeConfig
                                                                    .padding24,
                                                          ),
                                                          child:
                                                              const FloBalanceBriefRow(
                                                            key: ValueKey(
                                                                "10floBalance"),
                                                            tier: Constants
                                                                .ASSET_TYPE_FLO_FIXED_3,
                                                            mini: true,
                                                            endAlign: true,
                                                          ),
                                                        ),
                                                      if (model.isInvested)
                                                        SizedBox(
                                                            height: SizeConfig
                                                                .padding16),
                                                      Container(
                                                        margin: EdgeInsets
                                                            .symmetric(
                                                          horizontal: SizeConfig
                                                              .padding16,
                                                        ),
                                                        child:
                                                            FloPremiumTransactionsList(
                                                          key: const ValueKey(
                                                              "10floTxns"),
                                                          model: model,
                                                          seeAll: _seeAll,
                                                        ),
                                                      ),
                                                      SizedBox(
                                                          height: SizeConfig
                                                              .padding8),
                                                      if (model.isInvested &&
                                                          (model.transactionsList
                                                                  .length >
                                                              2))
                                                        GestureDetector(
                                                          onTap: () {
                                                            setState(() {
                                                              _seeAll =
                                                                  !_seeAll;
                                                            });
                                                          },
                                                          child: Container(
                                                            decoration: BoxDecoration(
                                                                color: Colors
                                                                    .white
                                                                    .withOpacity(
                                                                        0.10),
                                                                borderRadius: BorderRadius.only(
                                                                    bottomLeft: Radius.circular(
                                                                        SizeConfig
                                                                            .roundness16),
                                                                    bottomRight:
                                                                        Radius.circular(
                                                                            SizeConfig.roundness16))),
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Text(
                                                                  _seeAll
                                                                      ? 'View less Investments'
                                                                      : 'View more Investments',
                                                                  style: TextStyles
                                                                      .sourceSansSB
                                                                      .body2
                                                                      .colour(Colors
                                                                          .white),
                                                                ),
                                                                SizedBox(
                                                                  width: SizeConfig
                                                                      .padding4,
                                                                ),
                                                                Icon(
                                                                  _seeAll
                                                                      ? Icons
                                                                          .keyboard_arrow_up
                                                                      : Icons
                                                                          .keyboard_arrow_down_outlined,
                                                                  color: Colors
                                                                      .white,
                                                                  size: SizeConfig
                                                                      .padding28,
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        )
                                                    ],
                                                  ),
                                                ),
                                              if (model.isInvested)
                                                SizedBox(
                                                    height:
                                                        SizeConfig.padding16)
                                            ],
                                          ),
                                    transitionBuilder: (child, animation) {
                                      return FadeTransition(
                                        opacity: animation,
                                        child: child,
                                      );
                                    },
                                  ),
                                ),

                                SizedBox(
                                    height: SizeConfig.pageHorizontalMargins),
                                CircularSlider(
                                    type: InvestmentType.LENDBOXP2P,
                                    isNewUser: false,
                                    interest: model.is12 ? 12 : 10),

                                //From our 12% Flo Savers
                                SizedBox(height: SizeConfig.padding40),
                                Text(
                                  "From our 12% Flo Savers",
                                  style: TextStyles.rajdhaniSB.title4
                                      .colour(Colors.white),
                                  textAlign: TextAlign.center,
                                ),
                                SizedBox(height: SizeConfig.padding24),
                                const Testomonials(),

                                SizedBox(height: SizeConfig.padding20),

                                const SaveAssetsFooter(isFlo: true),
                                SizedBox(
                                    height: SizeConfig.pageHorizontalMargins),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: SizeConfig.padding16),
                                  child: Text(
                                    "Frequently Asked Questions",
                                    style: TextStyles.rajdhaniSB.title4
                                        .colour(Colors.white),
                                  ),
                                ),
                                SizedBox(
                                  width: SizeConfig.screenWidth,
                                  child: Column(
                                    children: [
                                      Theme(
                                        data: ThemeData(
                                            brightness: Brightness.dark),
                                        child: ExpansionPanelList(
                                          animationDuration:
                                              const Duration(milliseconds: 600),
                                          expandedHeaderPadding:
                                              const EdgeInsets.all(0),
                                          dividerColor: UiConstants
                                              .kDividerColor
                                              .withOpacity(0.3),
                                          elevation: 0,
                                          children: List.generate(
                                            model.faqHeaders.length,
                                            (index) => ExpansionPanel(
                                              backgroundColor:
                                                  Colors.transparent,
                                              canTapOnHeader: true,
                                              headerBuilder: (ctx, isOpen) =>
                                                  Padding(
                                                padding: EdgeInsets.only(
                                                  top: SizeConfig.padding20,
                                                  left: SizeConfig
                                                      .pageHorizontalMargins,
                                                  bottom: SizeConfig.padding20,
                                                ),
                                                child: Text(
                                                    model.faqHeaders[index] ??
                                                        "",
                                                    style: TextStyles
                                                        .sourceSans.body2
                                                        .colour(Colors.white)),
                                              ),
                                              isExpanded:
                                                  model.detStatus[index],
                                              body: Container(
                                                margin: EdgeInsets.symmetric(
                                                    horizontal: SizeConfig
                                                        .pageHorizontalMargins),
                                                alignment: Alignment.centerLeft,
                                                child: Text(
                                                    model.faqResponses[index]!,
                                                    textAlign: TextAlign.start,
                                                    style: TextStyles.body3
                                                        .colour(UiConstants
                                                            .kFAQsAnswerColor)),
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
                                Container(
                                  decoration: BoxDecoration(
                                      color: UiConstants.kSaveStableFelloCardBg,
                                      borderRadius: BorderRadius.circular(
                                          SizeConfig.roundness16),
                                      border: Border.all(
                                          color: Colors.white, width: 2)),
                                  margin: EdgeInsets.all(
                                      SizeConfig.pageHorizontalMargins),
                                  padding: EdgeInsets.all(SizeConfig.padding16),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      SizedBox(
                                        width: SizeConfig.padding200 +
                                            SizeConfig.padding4,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "We’ll be happy to assist",
                                              style:
                                                  TextStyles.rajdhaniSB.body1,
                                            ),
                                            SizedBox(
                                                height: SizeConfig.padding12),
                                            Text(
                                              "Get in touch with the experts at Fello to assist you in your savings",
                                              style: TextStyles.body3
                                                  .colour(Colors.white),
                                            )
                                          ],
                                        ),
                                      ),
                                      Stack(
                                        children: [
                                          SvgPicture.asset(
                                            'assets/svg/customer_help.svg',
                                            height: SizeConfig.padding104,
                                          ),
                                          Transform.translate(
                                            offset:
                                                Offset(0, SizeConfig.padding54),
                                            child: Align(
                                              alignment: Alignment.bottomCenter,
                                              child: OutlinedButton(
                                                onPressed: () {
                                                  Haptic.vibrate();
                                                  AppState.delegate!.appState
                                                          .currentAction =
                                                      PageAction(
                                                    state: PageState.addPage,
                                                    page:
                                                        FreshDeskHelpPageConfig,
                                                  );
                                                  trackHelpBannerTapped(
                                                      model.is12);
                                                },
                                                style: ButtonStyle(
                                                    backgroundColor:
                                                        MaterialStateProperty
                                                            .all(const Color(
                                                                0xFF01656B)),
                                                    side: MaterialStateProperty
                                                        .all(const BorderSide(
                                                            color: Colors.white,
                                                            width: 1.0,
                                                            style: BorderStyle
                                                                .solid))),
                                                child: Text(
                                                  "ASK FELLO",
                                                  style: TextStyles
                                                      .rajdhaniB.body2
                                                      .colour(Colors.white),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: SizeConfig.navBarHeight * 2,
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      color: UiConstants.kBackgroundColor.withOpacity(0.96),
                      width: SizeConfig.screenWidth,
                      height: SizeConfig.screenWidth! * 0.26 +
                          MediaQuery.of(context).viewPadding.bottom / 2,
                      child: Stack(
                        children: [
                          if (model.is12)
                            SvgPicture.asset(
                              Assets.btnBg,
                              fit: BoxFit.cover,
                              width: SizeConfig.screenWidth! * 1.5,
                            ),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(height: SizeConfig.padding6),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SvgPicture.asset(
                                    Assets.floAsset,
                                    height: SizeConfig.screenHeight! * 0.03,
                                    width: SizeConfig.screenHeight! * 0.03,
                                  ),
                                  SizedBox(
                                    height: SizeConfig.padding1,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: SizeConfig.padding4),
                                    child: getText().beautify(
                                      boldStyle: TextStyles.sourceSansB.body4
                                          .colour(Colors.white),
                                      style: TextStyles.sourceSans.body4
                                          .colour(Colors.white),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: SizeConfig.padding4,
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal:
                                        SizeConfig.pageHorizontalMargins),
                                width: SizeConfig.screenWidth!,
                                child: Row(
                                  children: [
                                    if (!model.is12)
                                      Expanded(
                                        child: SizedBox(
                                          height: SizeConfig.padding44,
                                          child: OutlinedButton(
                                              style: ButtonStyle(
                                                  side:
                                                      MaterialStateProperty.all(
                                                          const BorderSide(
                                                              color:
                                                                  Colors.white,
                                                              width: 1.0,
                                                              style: BorderStyle
                                                                  .solid))),
                                              child: Text(
                                                "UPGRADE TO 12%",
                                                style: TextStyles
                                                    .rajdhaniSB.body2
                                                    .colour(Colors.white),
                                              ),
                                              onPressed: () async {
                                                Haptic.vibrate();
                                                await controller
                                                    ?.animateTo(0,
                                                        duration:
                                                            const Duration(
                                                                milliseconds:
                                                                    200),
                                                        curve:
                                                            Curves.decelerate)
                                                    .then((_) {
                                                  _animController!
                                                      .forward()
                                                      .then((value) {
                                                    model
                                                        .cleanTransactionsList();
                                                    _animController!.reverse();
                                                    model.is12 = true;

                                                    model.getTransactions();
                                                  });
                                                });
                                              }),
                                        ),
                                      ),
                                    if (!model.is12)
                                      SizedBox(width: SizeConfig.padding12),
                                    Expanded(
                                      child: MaterialButton(
                                          color: Colors.white,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                                SizeConfig.roundness5),
                                          ),
                                          height: SizeConfig.padding44,
                                          child: Text(
                                            "SAVE",
                                            style: TextStyles.rajdhaniB.body1
                                                .colour(Colors.black),
                                          ),
                                          onPressed: () {
                                            BaseUtil.openFloBuySheet(
                                              floAssetType: model.is12
                                                  ? Constants
                                                      .ASSET_TYPE_FLO_FIXED_6
                                                  : Constants
                                                      .ASSET_TYPE_FLO_FIXED_3,
                                            );
                                            trackSaveTapped(model.is12);
                                          }),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: SizeConfig.padding12),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  SafeArea(
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
                            type: FaqsType.savings,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void trackSaveTapped(bool is12) {
    locator<AnalyticsService>().track(
        eventName: AnalyticsEvents.investNowInFloSlabTapped,
        properties: {
          "asset name": is12 ? "12% Flo" : "10% Flo",
          "new user":
              locator<UserService>().userSegments.contains(Constants.NEW_USER),
          "total invested amount": is12
              ? locator<UserService>().userPortfolio.flo.fixed1.principle
              : locator<UserService>().userPortfolio.flo.fixed2.principle,
          "total current amount": is12
              ? locator<UserService>().userPortfolio.flo.fixed1.balance
              : locator<UserService>().userPortfolio.flo.fixed2.balance,
        });
  }

  void trackHelpBannerTapped(bool is12) {
    locator<AnalyticsService>()
        .track(eventName: AnalyticsEvents.helpInFloSlabTapped, properties: {
      "asset name": is12 ? "12% Flo" : "10% Flo",
      "new user":
          locator<UserService>().userSegments.contains(Constants.NEW_USER),
      "total invested amount": is12
          ? locator<UserService>().userPortfolio.flo.fixed1.principle
          : locator<UserService>().userPortfolio.flo.fixed2.principle,
      "total current amount": is12
          ? locator<UserService>().userPortfolio.flo.fixed1.balance
          : locator<UserService>().userPortfolio.flo.fixed2.balance,
    });
  }
}

class Testomonials extends StatelessWidget {
  const Testomonials({
    super.key,
    this.type = InvestmentType.LENDBOXP2P,
  });

  final InvestmentType? type;

  final Map<String, List<String>> testimonials = const {
    "Akash mahesh": [
      "Fello has completely changed the way I save money. I now earn interest on saving money and save more to play tambola and win rewards. The app has truly motimvated me to save more. Highly recommend it to everyone",
      'https://d37gtxigg82zaw.cloudfront.net/testimonials/1.jpg'
    ],
    "Vinay Kumar": [
      "I wanted to build a habit of saving money and Fello made it possible. It is a win win situation where I save and invest money and then play Tambola and get chance for getting more rewards",
      'https://d37gtxigg82zaw.cloudfront.net/testimonials/2.jpg',
    ],
    "Rohit": [
      "Fello has taken monotony out of saving money. It is very easy to use. The addition of Tambola to a savings app is a very good idea as it makes saving money rewarding and fun. I have personally won rewards when playing Tambola",
      'https://d37gtxigg82zaw.cloudfront.net/testimonials/3.jpg',
    ]
  };

  @override
  Widget build(BuildContext context) {
    List<String> shuffledKeys = testimonials.keys.toList()..shuffle();

    return SizedBox(
      height: SizeConfig.padding160,
      child: ListView.builder(
        itemCount: testimonials.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          String name = shuffledKeys[index];
          String? testimonial = testimonials[name]![0];
          String image = testimonials[name]![1];

          return Container(
            width: SizeConfig.padding300,
            margin: EdgeInsets.only(left: SizeConfig.pageHorizontalMargins),
            height: SizeConfig.padding160,
            decoration: BoxDecoration(
              // color: const Color(0xFF191919),
              border: Border.all(
                  color: UiConstants.kGoldProBorder,
                  width: type == InvestmentType.AUGGOLD99 ? 1 : 0),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(8),
                      bottomLeft: Radius.circular(8),
                    ),
                    clipBehavior: Clip.hardEdge,
                    child: Image.network(
                      image,
                      fit: BoxFit.fitHeight,
                      height: SizeConfig.padding160,
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Stack(
                    children: [
                      Container(
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(8),
                            bottomRight: Radius.circular(8),
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(8),
                            bottomRight: Radius.circular(8),
                          ),
                          clipBehavior: Clip.hardEdge,
                          child: Image.asset(
                            'assets/svg/comma.png',
                            fit: BoxFit.fitHeight,
                            height: SizeConfig.padding160,
                          ),
                        ),
                      ),
                      if (type == InvestmentType.AUGGOLD99)
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.only(
                              topRight: Radius.circular(8),
                              bottomRight: Radius.circular(8),
                            ),
                            color: UiConstants.kGoldProBorder.withOpacity(0.2),
                          ),
                          child: ClipRRect(
                            borderRadius: const BorderRadius.only(
                              topRight: Radius.circular(8),
                              bottomRight: Radius.circular(8),
                            ),
                            clipBehavior: Clip.hardEdge,
                            child: SizedBox(
                              width: SizeConfig.screenWidth,
                              height: SizeConfig.screenWidth,
                            ),
                          ),
                        ),
                      Positioned(
                        left: 15,
                        top: 10,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              name,
                              style: TextStyles.sourceSansSB.body3
                                  .colour(Colors.white),
                            ),
                            SizedBox(height: SizeConfig.padding8),
                            Padding(
                              padding:
                                  EdgeInsets.only(right: SizeConfig.padding12),
                              child: SizedBox(
                                width: SizeConfig.padding152,
                                child: Text(
                                  testimonial ?? "",
                                  style: TextStyles.sourceSans.body4
                                      .colour(Colors.white),
                                  maxLines: 5,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.left,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}

class FloPremiumHeader extends StatelessWidget {
  final FloPremiumDetailsViewModel model;

  const FloPremiumHeader({
    required this.model,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final daysRemaining =
        BaseUtil.calculateRemainingDays(DateTime(2023, 12, 31));

    return Padding(
      padding:
          EdgeInsets.symmetric(horizontal: SizeConfig.pageHorizontalMargins),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          margin: EdgeInsets.only(top: SizeConfig.padding12),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                offset: const Offset(-10, 40),
                                color:
                                    UiConstants.primaryColor.withOpacity(0.95),
                                blurRadius: 50,
                              )
                            ],
                          ),
                          child: Text(
                            model.is12 ? "12% Flo" : "10% Flo",
                            style: TextStyles.rajdhaniB.title0.colour(
                              model.is12
                                  ? UiConstants.primaryColor
                                  : Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Text(
                      model.is12 ? "12% Returns p.a." : "10% Returns p.a.",
                      style: TextStyles.rajdhaniSB.title4,
                    ),
                    if (daysRemaining > 0)
                      SizedBox(height: SizeConfig.padding16),
                    if (daysRemaining > 0)
                      SizedBox(
                        width: SizeConfig.screenWidth! * 0.5,
                        child: Stack(
                          children: [
                            Row(
                              children: [
                                Text(
                                  "Available only for",
                                  style: TextStyles.sourceSans.body3,
                                ),
                                SizedBox(width: SizeConfig.padding4),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: SizeConfig.padding12,
                                      vertical: SizeConfig.padding2),
                                  decoration: BoxDecoration(
                                    color: const Color(0xff62E3C4),
                                    borderRadius: BorderRadius.circular(
                                        SizeConfig.roundness12),
                                  ),
                                  child: Shimmer.fromColors(
                                    period: const Duration(milliseconds: 2500),
                                    baseColor: Colors.grey[900]!,
                                    highlightColor: Colors.grey[100]!,
                                    loop: 3,
                                    child: Text(
                                      "$daysRemaining days",
                                      style: TextStyles.sourceSansB.body3
                                          .colour(Colors.black),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Positioned(
                              right: 10,
                              child: CustomPaint(
                                size: Size(SizeConfig.padding12,
                                    (SizeConfig.padding12 * 1.09).toDouble()),
                                painter: StarCustomPainter(),
                              ),
                            ),
                            Positioned(
                              right: 5,
                              child: CustomPaint(
                                size: Size(SizeConfig.padding6,
                                    (SizeConfig.padding6 * 1.09).toDouble()),
                                painter: StarCustomPainter(),
                              ),
                            )
                          ],
                        ),
                      )
                  ],
                ),
              ),
              SvgPicture.asset(
                Assets.floAsset,
                height: SizeConfig.screenHeight! * 0.1,
              ),
            ],
          ),
          SizedBox(height: SizeConfig.padding16),
          Text(
            model.is12 ? model.flo12Highlights : model.flo10Highlights,
            style: TextStyles.sourceSans.body2.colour(UiConstants.primaryColor),
          ),
          SizedBox(height: SizeConfig.padding4),
          Text(
            model.is12 ? model.flo12Description : model.flo10Description,
            style: TextStyles.sourceSans.body2.colour(Colors.white54),
          ),
        ],
      ),
    );
  }
}

class FloPremiumTransactionsList extends StatefulWidget {
  final FloPremiumDetailsViewModel model;
  final bool seeAll;

  const FloPremiumTransactionsList({
    required this.model,
    required this.seeAll,
    Key? key,
  }) : super(key: key);

  @override
  State<FloPremiumTransactionsList> createState() =>
      _FloPremiumTransactionsListState();
}

class _FloPremiumTransactionsListState
    extends State<FloPremiumTransactionsList> {
  late LendboxMaturityService _lendboxMaturityService;
  bool showChangeCTA =
      AppConfig.getValue(AppConfigKey.canChangePostMaturityPreference);

  void trackTransactionCardTap(
      double currentAmount, double investedAmount, String maturityDate) {
    locator<AnalyticsService>().track(
        eventName: AnalyticsEvents.depositCardInFloSlabTapped,
        properties: {
          "asset name": widget.model.is12 ? "12% Flo" : "10% Flo",
          "new user":
              locator<UserService>().userSegments.contains(Constants.NEW_USER),
          "invested amount": investedAmount,
          "current amount": currentAmount,
          "maturity date": maturityDate
        });
  }

  void trackDecideButtonTap(
      double currentAmount, double investedAmount, String maturityDate) {
    locator<AnalyticsService>().track(
        eventName: AnalyticsEvents.decideOnDepositCardTapped,
        properties: {
          "asset name": widget.model.is12 ? "12% Flo" : "10% Flo",
          "new user":
              locator<UserService>().userSegments.contains(Constants.NEW_USER),
          "invested amount": investedAmount,
          "current amount": currentAmount,
          "maturity date": maturityDate
        });
  }

  int getLength() {
    if (widget.model.transactionsList.length > 2) {
      if (widget.seeAll) {
        return widget.model.transactionsList.length;
      } else {
        return 2;
      }
    } else {
      return widget.model.transactionsList.length;
    }
  }

  @override
  void initState() {
    super.initState();
    _lendboxMaturityService = locator<LendboxMaturityService>();
  }

  @override
  Widget build(BuildContext context) {
    return Selector<LendboxMaturityService, List<Deposit>?>(
      selector: (context, data) => data.filteredDeposits,
      builder: (context, filteredDeposits, child) {
        return AnimatedContainer(
          duration: const Duration(seconds: 1),
          curve: Curves.easeIn,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: getLength(),
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (ctx, i) {
              String formattedInvestmentDate = DateFormat('dd MMM, yyyy')
                  .format(DateTime.fromMillisecondsSinceEpoch(widget.model
                      .transactionsList[i].timestamp!.millisecondsSinceEpoch));

              String formattedMaturityDate = DateFormat('dd MMM, yyyy').format(
                  DateTime.fromMillisecondsSinceEpoch(widget
                      .model
                      .transactionsList[i]
                      .lbMap
                      .maturityAt!
                      .millisecondsSinceEpoch));

              double currentValue = BaseUtil.digitPrecision(
                  widget.model.transactionsList[i].amount +
                      (widget.model.transactionsList[i].lbMap.gainAmount ?? 0),
                  2);

              double principleValue = BaseUtil.digitPrecision(
                  widget.model.transactionsList[i].amount, 2);

              double gain = BaseUtil.digitPrecision(
                  widget.model.transactionsList[i].lbMap.gainAmount ?? 0,
                  2,
                  false);

              bool hasUserDecided =
                  widget.model.transactionsList[i].lbMap.maturityPref != "NA";
              String userMaturityPref = BaseUtil.getMaturityPref(
                  widget.model.transactionsList[i].lbMap.maturityPref ?? "NA",
                  widget.key == const ValueKey('10floTxns'));
              bool showNeedHelp =
                  widget.model.transactionsList[i].lbMap.hasDecidedPref ??
                      false;

              log("qwerty => ${widget.model.transactionsList[i].lbMap.hasDecidedPref}");

              bool showConfirm = (filteredDeposits?.isNotEmpty ?? false) &&
                  filteredDeposits!.any((element) =>
                      element.txnId ==
                          widget.model.transactionsList[i].docKey &&
                      (element.hasConfirmed ?? true) == false);

              log("filteredDeposits => ${filteredDeposits?.length}");

              Deposit? depositData = filteredDeposits?.firstWhere(
                  (element) =>
                      element.txnId == widget.model.transactionsList[i].docKey,
                  orElse: Deposit.new);

              log("depositData => ${depositData?.decisionMade}");

              log("showNeedHelp: $showNeedHelp || showConfirm: $showConfirm");
              return (widget.model.transactionsList[i].lbMap.fundType ?? "")
                      .isNotEmpty
                  ? InkWell(
                      onTap: () {
                        Haptic.vibrate();
                        AppState.delegate!.appState.currentAction = PageAction(
                          state: PageState.addWidget,
                          page: TransactionDetailsPageConfig,
                          widget: TransactionDetailsPage(
                            txn: widget.model.transactionsList[i],
                          ),
                        );
                        trackTransactionCardTap(currentValue,
                            currentValue - gain, formattedMaturityDate);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white10,
                          borderRadius:
                              BorderRadius.circular(SizeConfig.roundness16),
                        ),
                        margin: EdgeInsets.only(
                            //     horizontal: SizeConfig.pageHorizontalMargins,
                            bottom: SizeConfig.padding16),
                        child: Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(
                                top: SizeConfig.padding12,
                                bottom: SizeConfig.padding12,
                                left: SizeConfig.padding12,
                                right: SizeConfig.padding12,
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Invested on",
                                            style: TextStyles.body3.colour(
                                                UiConstants
                                                    .kTextFieldTextColor),
                                          ),
                                          FloPremiumTierChip(
                                            value: formattedInvestmentDate,
                                          )
                                        ],
                                      ),
                                      SizedBox(width: SizeConfig.padding16),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Matures on",
                                            style: TextStyles.body3.colour(
                                                UiConstants
                                                    .kTextFieldTextColor),
                                          ),
                                          FloPremiumTierChip(
                                            value: formattedMaturityDate,
                                          )
                                        ],
                                      ),
                                      const Spacer(),
                                      const Icon(
                                        Icons.arrow_forward_ios_rounded,
                                        color: UiConstants.kTextFieldTextColor,
                                      )
                                    ],
                                  ),
                                  SizedBox(height: SizeConfig.padding16),
                                  FloBalanceBriefRow(
                                    lead: currentValue,
                                    trail: principleValue,
                                    percent: (gain / principleValue) * 100,
                                    leftAlign: true,
                                    tier: widget.model.is12
                                        ? Constants.ASSET_TYPE_FLO_FIXED_6
                                        : Constants.ASSET_TYPE_FLO_FIXED_3,
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              width: SizeConfig.screenWidth,
                              padding: EdgeInsets.symmetric(
                                vertical: SizeConfig.padding8,
                                horizontal: SizeConfig.padding16,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white10,
                                borderRadius: BorderRadius.only(
                                    bottomLeft:
                                        Radius.circular(SizeConfig.roundness16),
                                    bottomRight: Radius.circular(
                                        SizeConfig.roundness16)),
                              ),
                              alignment: Alignment.center,
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      userMaturityPref,
                                      style: TextStyles.sourceSans.body3,
                                    ),
                                  ),
                                  SizedBox(width: SizeConfig.padding10),
                                  if (showChangeCTA)
                                    MaterialButton(
                                      elevation:
                                          (showNeedHelp || showConfirm) ? 0 : 2,
                                      onPressed: () {
                                        Haptic.vibrate();

                                        log('showNeedHelp: $showNeedHelp');

                                        if (showNeedHelp) {
                                          AppState.delegate!.appState
                                              .currentAction = PageAction(
                                            state: PageState.addPage,
                                            page: FreshDeskHelpPageConfig,
                                          );
                                        } else if (showConfirm &&
                                            depositData != null &&
                                            depositData != Deposit()) {
                                          BaseUtil.openModalBottomSheet(
                                            addToScreenStack: true,
                                            enableDrag: false,
                                            hapticVibrate: true,
                                            isBarrierDismissible: false,
                                            backgroundColor: Colors.transparent,
                                            isScrollControlled: true,
                                            content: ReInvestmentSheet(
                                              decision: _lendboxMaturityService
                                                  .setDecision(depositData
                                                          .decisionMade ??
                                                      "3"),
                                              depositData: depositData,
                                            ),
                                          );
                                        } else {
                                          BaseUtil.openModalBottomSheet(
                                            isBarrierDismissible: false,
                                            addToScreenStack: true,
                                            hapticVibrate: true,
                                            isScrollControlled: true,
                                            content: MaturityPrefModalSheet(
                                              amount: "${currentValue - gain}",
                                              txnId: widget.model
                                                  .transactionsList[i].docKey!,
                                              assetType: widget.model.is12
                                                  ? Constants
                                                      .ASSET_TYPE_FLO_FIXED_6
                                                  : Constants
                                                      .ASSET_TYPE_FLO_FIXED_3,
                                            ),
                                          ).then((value) =>
                                              widget.model.getTransactions());
                                        }

                                        trackDecideButtonTap(
                                          currentValue,
                                          currentValue - gain,
                                          formattedMaturityDate,
                                        );
                                      },
                                      color: (showNeedHelp || showConfirm)
                                          ? Colors.black.withOpacity(0.25)
                                          : Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                            SizeConfig.roundness5),
                                      ),
                                      child: Text(
                                        showNeedHelp
                                            ? "NEED HELP ?"
                                            : showConfirm
                                                ? "CONFIRM"
                                                : hasUserDecided
                                                    ? "CHANGE"
                                                    : "CHOOSE",
                                        style: TextStyles.rajdhaniB.body2
                                            .colour(
                                                (showNeedHelp || showConfirm)
                                                    ? Colors.white
                                                    : Colors.black),
                                      ),
                                    )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    )
                  : const SizedBox();
            },
          ),
        );
      },
    );
  }
}

class LBoxAssetCard extends StatelessWidget {
  const LBoxAssetCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    S locale = S.of(context);
    return Container(
      margin:
          EdgeInsets.symmetric(horizontal: SizeConfig.pageHorizontalMargins),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(SizeConfig.roundness12),
        color: UiConstants.kSaveStableFelloCardBg,
      ),
      padding: EdgeInsets.fromLTRB(
          SizeConfig.pageHorizontalMargins / 2,
          SizeConfig.pageHorizontalMargins,
          SizeConfig.pageHorizontalMargins,
          SizeConfig.pageHorizontalMargins),
      child: Stack(
        children: [
          Transform.translate(
            offset: Offset(-SizeConfig.padding12, -SizeConfig.padding40),
            child: Image.asset(
              Assets.felloFlo,
              height: SizeConfig.screenWidth! * 0.32,
              width: SizeConfig.screenWidth! * 0.32,
            ),
          ),
          Column(
            children: [
              Row(
                children: [
                  SizedBox(width: SizeConfig.screenWidth! * 0.35),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(locale.felloFloText,
                            style: TextStyles.rajdhaniB.title2),
                        Text(locale.felloFloSubTitle,
                            style: TextStyles.sourceSans.body4),
                      ],
                    ),
                  )
                ],
              ),
              Padding(
                padding: EdgeInsets.only(
                    left: SizeConfig.pageHorizontalMargins,
                    top: SizeConfig.padding35),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          LendboxPrincipleValue(
                            prefix: "\u20b9",
                            style: TextStyles.rajdhaniSB.title4,
                          ),
                          SizedBox(
                            height: SizeConfig.padding2,
                          ),
                          Text(
                            locale.invested,
                            style: TextStyles.sourceSans.body3.colour(
                              UiConstants.kTextColor.withOpacity(0.8),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: SizeConfig.padding16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          UserFundQuantitySE(
                            style: TextStyles.rajdhaniSB.title4,
                            investmentType: InvestmentType.LENDBOXP2P,
                          ),
                          SizedBox(
                            height: SizeConfig.padding2,
                          ),
                          Row(
                            children: [
                              Text(
                                locale.currentText,
                                style: TextStyles.sourceSans.body3.colour(
                                    UiConstants.kTextColor.withOpacity(0.8)),
                              ),
                              SizedBox(width: SizeConfig.padding4),
                              const LboxGrowthArrow()
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class StarCustomPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Path path_0 = Path();
    path_0.moveTo(size.width * 0.5184209, size.height);
    path_0.lineTo(size.width * 0.4815791, size.height);
    path_0.cubicTo(
        size.width * 0.4815791,
        size.height * 0.7342100,
        size.width * 0.2657891,
        size.height * 0.5184208,
        0,
        size.height * 0.5184208);
    path_0.lineTo(0, size.height * 0.4815792);
    path_0.cubicTo(
        size.width * 0.2657891,
        size.height * 0.4815792,
        size.width * 0.4815791,
        size.height * 0.2657892,
        size.width * 0.4815791,
        0);
    path_0.lineTo(size.width * 0.5184209, 0);
    path_0.cubicTo(
        size.width * 0.5184209,
        size.height * 0.2657892,
        size.width * 0.7342109,
        size.height * 0.4815792,
        size.width,
        size.height * 0.4815792);
    path_0.lineTo(size.width, size.height * 0.5184208);
    path_0.cubicTo(
        size.width * 0.7342109,
        size.height * 0.5184208,
        size.width * 0.5184209,
        size.height * 0.7342100,
        size.width * 0.5184209,
        size.height);
    path_0.close();

    Paint paint0Fill = Paint()..style = PaintingStyle.fill;
    paint0Fill.color = Colors.white.withOpacity(1.0);
    canvas.drawPath(path_0, paint0Fill);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
