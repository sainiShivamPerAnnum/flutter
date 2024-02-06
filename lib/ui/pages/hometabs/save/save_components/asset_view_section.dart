import 'dart:ui' as ui;

import 'package:carousel_slider/carousel_slider.dart';
import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/constants/analytics_events_constants.dart';
import 'package:felloapp/core/enums/app_config_keys.dart';
import 'package:felloapp/core/enums/faqTypes.dart';
import 'package:felloapp/core/enums/investment_type.dart';
import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/core/enums/user_service_enum.dart';
import 'package:felloapp/core/model/app_config_model.dart';
import 'package:felloapp/core/model/portfolio_model.dart';
import 'package:felloapp/core/model/subscription_models/all_subscription_model.dart';
import 'package:felloapp/core/service/analytics/analytics_service.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/core/service/subscription_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/ui/architecture/base_view.dart';
import 'package:felloapp/ui/elements/helpers/tnc_text.dart';
import 'package:felloapp/ui/elements/title_subtitle_container.dart';
import 'package:felloapp/ui/elements/video_player/app_video_player.dart';
import 'package:felloapp/ui/pages/asset_selection.dart';
import 'package:felloapp/ui/pages/finance/autosave/autosave_setup/autosave_process_view.dart';
import 'package:felloapp/ui/pages/finance/mini_trans_card/mini_trans_card_view.dart';
import 'package:felloapp/ui/pages/hometabs/save/flo_components/flo_basic_card.dart';
import 'package:felloapp/ui/pages/hometabs/save/flo_components/flo_premium_section.dart';
import 'package:felloapp/ui/pages/hometabs/save/gold_components/gold_hero_card.dart';
import 'package:felloapp/ui/pages/hometabs/save/gold_components/gold_rate_widget.dart';
import 'package:felloapp/ui/pages/hometabs/save/save_viewModel.dart';
import 'package:felloapp/ui/pages/login/login_components/login_support.dart';
import 'package:felloapp/ui/pages/static/app_widget.dart';
import 'package:felloapp/ui/pages/static/web_view.dart';
import 'package:felloapp/ui/service_elements/auto_save_card/subscription_card.dart';
import 'package:felloapp/ui/service_elements/gold_sell_card/sell_card_view.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/constants.dart';
import 'package:felloapp/util/dynamic_ui_utils.dart';
import 'package:felloapp/util/extensions/investment_returns_extension.dart';
import 'package:felloapp/util/haptic.dart';
import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/preference_helper.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:property_change_notifier/property_change_notifier.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

import '../gold_components/gold_pro_card.dart';
import '../gold_components/gold_rate_graph.dart';

class AssetSectionView extends StatefulWidget {
  const AssetSectionView({
    required this.type,
    this.showSkip = false,
    super.key,
  });

  final InvestmentType type;
  final bool showSkip;

  @override
  State<AssetSectionView> createState() => _AssetSectionViewState();
}

class _AssetSectionViewState extends State<AssetSectionView> {
  bool get _isGold => widget.type == InvestmentType.AUGGOLD99;

  final String _goldSubtitle = "24K Gold  •  99.99% Pure •  100% Secure";

  final String _floSubtitle = "P2P Asset •  Consistent Returns • RBI Certified";

  final String __goldDescription =
      "Digital gold is an efficient way of investing in gold. Each unit is backed by 24K 99.9% purity gold.";

  final String _floDescription =
      "Fello Flo is a peer to peer lending asset offered in partnership with Lendbox - an RBI regulated P2P NBFC";

  final Map<String, String> _goldInfo = {
    "24K": "Gold",
    "99.9%": "Pure",
    "48 Hrs": "Lock-in"
  };

  final Map<String, String> _lbInfo = {
    "P2P": "Asset",
    "10%": "Returns",
  };

  FaqsType _getFaqTypeFromAsset(InvestmentType type) {
    switch (type) {
      case InvestmentType.AUGGOLD99:
        return FaqsType.gold;
      case InvestmentType.GOLDPRO:
        return FaqsType.goldPro;
      case InvestmentType.LENDBOXP2P:
        return FaqsType.flo;
    }
  }

  void _onSkip() {
    AppState.delegate!.appState.currentAction = PageAction(
      state: PageState.replaceAll,
      page: RootPageConfig,
    );

    PreferenceHelper.setBool(
      PreferenceHelper.isUserOnboardingComplete,
      true,
    );
  }

  @override
  Widget build(BuildContext context) {
    final locale = locator<S>();
    return PropertyChangeConsumer<UserService, UserServiceProperties>(
        properties: const [
          UserServiceProperties.myUserWallet,
          UserServiceProperties.myAugmontDetails,
          UserServiceProperties.myUserFund,
          UserServiceProperties.mySegments,
        ],
        builder: (_, model, ___) {
          bool isNewUser = model!.userSegments.contains("NEW_USER");
          bool hasSavedInAug = false;

          for (final segment in model.userSegments) {
            if (segment.toString().contains('SAVE_AUG_AMT')) {
              hasSavedInAug = true;
            }
          }

          final balance = widget.type == InvestmentType.AUGGOLD99
              ? ((model.userFundWallet?.augGoldQuantity ?? 0) +
                  (model.userFundWallet?.wAugFdQty ?? 0))
              : model.userFundWallet?.wLbBalance ?? 0;
          return BaseView<SaveViewModel>(
            builder: (context, state, _) {
              return RefreshIndicator(
                color: UiConstants.primaryColor,
                backgroundColor: Colors.black,
                onRefresh: () async {
                  await state.refreshTransactions(widget.type);
                },
                child: Scaffold(
                  backgroundColor: UiConstants.kBackgroundColor,
                  body: Stack(
                    children: [
                      Container(
                        height: SizeConfig.screenHeight! * 0.35,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                              colors: [
                                _getBackgroundColor,
                                _secondaryColor,
                              ],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter),
                        ),
                      ),
                      SingleChildScrollView(
                        child: Padding(
                          padding: EdgeInsets.only(top: SizeConfig.padding16),
                          child: Column(
                            children: [
                              SizedBox(
                                height: SizeConfig.padding20,
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.white.withOpacity(0.3),
                                      blurRadius: 50,
                                    )
                                  ],
                                ),
                                child: SvgPicture.asset(
                                  _getAsset,
                                  height: SizeConfig.screenHeight! * 0.18,
                                ),
                              ),
                              SizedBox(
                                height: SizeConfig.padding4,
                              ),
                              Text(
                                _isGold ? "Digital Gold" : "Fello Flo",
                                style: TextStyles.rajdhaniSB.title3
                                    .colour(Colors.white),
                              ),
                              SizedBox(
                                height: SizeConfig.padding4,
                              ),
                              Text(
                                _isGold ? _goldSubtitle : _floSubtitle,
                                style: TextStyles.sourceSans.body2
                                    .colour(_subTitleColor),
                              ),
                              if (balance == 0 &&
                                  widget.type == InvestmentType.AUGGOLD99)
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: SizeConfig.padding40),
                                  child: Text(
                                    __goldDescription,
                                    textAlign: TextAlign.center,
                                    style: TextStyles.sourceSans.body3.colour(
                                      Colors.white.withOpacity(0.6),
                                    ),
                                  ),
                                ),
                              SizedBox(
                                height: SizeConfig.padding26,
                              ),
                              if (widget.type == InvestmentType.AUGGOLD99) ...[
                                balance == 0
                                    ? _buildInfoSection()
                                    : const GoldInfoWidget(),
                                const GoldRateWidget(),
                                if (widget.type == InvestmentType.AUGGOLD99 &&
                                    !hasSavedInAug)
                                  const LineGradientChart(),
                              ],
                              if (balance == 0)
                                SizedBox(
                                  height: SizeConfig.padding14,
                                ),
                              if (balance == 0 &&
                                  widget.type == InvestmentType.LENDBOXP2P)
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: SizeConfig.padding40),
                                  child: Text(
                                    _floDescription,
                                    textAlign: TextAlign.center,
                                    style: TextStyles.sourceSans.body3.colour(
                                      Colors.white.withOpacity(0.6),
                                    ),
                                  ),
                                ),
                              if (balance != 0)
                                _BuildOwnAsset(
                                  type: widget.type,
                                  userService: model,
                                ),
                              SizedBox(
                                height: SizeConfig.padding4,
                              ),
                              SizedBox(
                                height: SizeConfig.padding10,
                              ),
                              if (!_isGold) FloPremiumSection(model: model),
                              if (!_isGold) FloBasicCard(model: model),
                              if (!isNewUser) ...[
                                MiniTransactionCard(
                                  investmentType: widget.type,
                                ),
                                if (balance != 0 && _isGold) ...[
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                          left: SizeConfig.padding10),
                                      child: const TitleSubtitleContainer(
                                          title: "Withdrawal",
                                          leadingPadding: false),
                                    ),
                                  ),
                                  SizedBox(
                                    height: SizeConfig.padding12,
                                  ),
                                  SellCardView(investmentType: widget.type),
                                  SizedBox(
                                    height: SizeConfig.padding10,
                                  ),
                                ],
                              ],
                              GoldenDayUiEntryPoint(
                                isGold: _isGold,
                              ),
                              if (widget.type == InvestmentType.AUGGOLD99)
                                const GoldProCard(),
                              if (!isNewUser)
                                const AutosaveCard(
                                  investmentType: InvestmentType.AUGGOLD99,
                                ),
                              if (!isNewUser) ...[
                                CircularSlider(
                                  isNewUser: isNewUser,
                                  type: widget.type,
                                  interest: _isGold ? 8 : 12,
                                )
                              ],
                              SizedBox(
                                height: SizeConfig.padding24,
                              ),
                              Text(
                                _isGold
                                    ? "How to save in Digital Gold?"
                                    : "How Fello Flo works?",
                                style: TextStyles.rajdhaniSB.title3,
                              ),
                              SizedBox(
                                height: SizeConfig.padding16,
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: SizeConfig.padding20),
                                child: AppVideoPlayer(
                                  _isGold
                                      ? "https://d37gtxigg82zaw.cloudfront.net/digital-gold-workflow.mp4"
                                      : "https://d37gtxigg82zaw.cloudfront.net/flo-workflow.mp4",
                                  aspectRatio: 1.4,
                                  showShimmer: true,
                                ),
                              ),
                              if (isNewUser) ...[
                                SizedBox(
                                  height: SizeConfig.padding24,
                                ),
                                CircularSlider(
                                  isNewUser: isNewUser,
                                  type: widget.type,
                                  interest: _isGold ? 8 : 12,
                                )
                              ],
                              SizedBox(
                                height: SizeConfig.padding40,
                              ),
                              _WhySection(isDigitalGold: _isGold),
                              SizedBox(
                                height: SizeConfig.screenHeight! * 0.06,
                              ),
                              ComparisonBox(
                                backgroundColor: _getBackgroundColor,
                                isGold: _isGold,
                              ),
                              _Footer(
                                isGold: _isGold,
                              ),
                              const TermsAndConditions(
                                  url: Constants.savingstnc),
                              SizedBox(
                                height: SizeConfig.screenHeight! * 0.15,
                              ),
                            ],
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          color: const Color(0xff232326).withOpacity(0.95),
                          padding: EdgeInsets.symmetric(
                                  vertical: SizeConfig.padding14)
                              .copyWith(top: 2),
                          width: double.infinity,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SvgPicture.asset(
                                    _getAsset,
                                    height: SizeConfig.screenHeight! * 0.03,
                                    width: SizeConfig.screenHeight! * 0.03,
                                  ),
                                  SizedBox(
                                    height: SizeConfig.padding1,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: SizeConfig.padding4),
                                    child: Text(
                                      _isGold
                                          ? DynamicUiUtils.ctaText.AUGGOLD99 ??
                                              ""
                                          : DynamicUiUtils.ctaText.LENDBOXP2P ??
                                              "",
                                      style: TextStyles.sourceSans.body4.colour(
                                        UiConstants.kTextColor2,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: SizeConfig.padding4,
                              ),
                              AssetBottomButtons(type: widget.type),
                              SizedBox(
                                height: SizeConfig.padding10,
                              ),
                            ],
                          ),
                        ),
                      ),
                      SafeArea(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            BackButton(
                              color: Colors.white,
                              onPressed: () => Navigator.of(context).pop(),
                            ),
                            const Spacer(),
                            Padding(
                              padding:
                                  EdgeInsets.only(right: SizeConfig.padding8),
                              child: FaqPill(
                                type: _getFaqTypeFromAsset(widget.type),
                              ),
                            ),
                            if (widget.showSkip)
                              InkWell(
                                onTap: _onSkip,
                                child: Padding(
                                  padding: EdgeInsets.only(
                                    right: SizeConfig.padding16,
                                  ),
                                  child: Row(
                                    children: [
                                      Text(
                                        locale.skip,
                                        style: TextStyles.rajdhaniB.body2,
                                      ),
                                      SizedBox(
                                        width: SizeConfig.padding12,
                                      ),
                                      AppImage(
                                        Assets.chevRonRightArrow,
                                        color: Colors.white,
                                        height: SizeConfig.padding20,
                                      )
                                    ],
                                  ),
                                ),
                              )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        });
  }

  Widget _buildInfoSection() {
    final info = _isGold ? _goldInfo : _lbInfo;
    List<Widget> children = [];
    for (final e in info.entries) {
      children.add(
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                e.key,
                style: TextStyles.rajdhaniSB.body1.colour(
                  Colors.white.withOpacity(0.8),
                ),
              ),
              Text(
                e.value,
                style: TextStyles.sourceSans.body3.colour(
                  Colors.white.withOpacity(0.4),
                ),
              )
            ],
          ),
        ),
      );
      if (!(info.values.toList().indexOf(e.value) == info.values.length - 1)) {
        children.add(
          SizedBox(
            height: SizeConfig.padding54,
            child: VerticalDivider(
              color: const Color(0xff7F86A3).withOpacity(0.3),
              thickness: 0.5,
              width: 20,
            ),
          ),
        );
      }
    }
    return Padding(
      padding: EdgeInsets.zero,
      child: Row(
        children: children,
      ),
    );
  }

  Color get _getBackgroundColor => _isGold
      ? UiConstants.kGoldContainerColor
      : UiConstants.kFloContainerColor;

  Color get _secondaryColor => _isGold
      ? const Color(0xff293566).withOpacity(0)
      : const Color(0xff297264).withOpacity(0);

  String get _getAsset => _isGold ? Assets.goldAsset : Assets.floAsset;

  Color get _subTitleColor =>
      _isGold ? UiConstants.kBlogTitleColor : UiConstants.kTabBorderColor;
}

class GoldenDayUiEntryPoint extends StatelessWidget {
  final bool isGold;
  final DateTime _startTime;
  final DateTime _endTime;

  GoldenDayUiEntryPoint({
    required this.isGold,
    super.key,
  })  : _startTime = DateTime(2023, 11, 7),
        _endTime = DateTime(2023, 11, 21);

  Future<void> _onTap() async {
    const url = 'https://fello.in/diwali-23';
    AppState.delegate!.appState.currentAction = PageAction(
      page: WebViewPageConfig,
      state: PageState.addWidget,
      widget: WebViewScreen(
        url: url,
        onUrlChanged: (value) {
          if (value != url) {
            AppState.backButtonDispatcher!.didPopRoute();
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!isGold) return const SizedBox.shrink();

    final now = DateTime.now();
    final isValidDate = now.isAfter(_startTime) && now.isBefore(_endTime);

    if (!isValidDate) return const SizedBox.shrink();

    return InkWell(
      onTap: _onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: SizeConfig.padding20,
          vertical: SizeConfig.padding8,
        ),
        child: AspectRatio(
          aspectRatio: 4.34,
          child: Image.network(
              'https://ik.imagekit.io/9xfwtu0xm/Offer%20Banners/Gold%20Details%20screen%20banner.png'),
        ),
      ),
    );
  }
}

class AssetBottomButtons extends StatelessWidget {
  const AssetBottomButtons({
    required this.type,
    super.key,
  });

  final InvestmentType type;

  @override
  Widget build(BuildContext context) {
    return type == InvestmentType.AUGGOLD99
        ? Container(
            margin: EdgeInsets.only(top: SizeConfig.padding12),
            width: SizeConfig.screenWidth! * 0.85,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  flex: 5,
                  child: MaterialButton(
                    height: SizeConfig.padding44,
                    shape: RoundedRectangleBorder(
                      side: const BorderSide(width: 1.5, color: Colors.white),
                      borderRadius:
                          BorderRadius.circular(SizeConfig.roundness5),
                    ),
                    child: Text(
                      "SAVE IN GOLD",
                      style: TextStyles.rajdhaniB.body1.colour(Colors.white),
                    ),
                    onPressed: () {
                      Haptic.vibrate();

                      BaseUtil().openRechargeModalSheet(investmentType: type);

                      locator<AnalyticsService>().track(
                          eventName: AnalyticsEvents.saveOnce,
                          properties: {
                            'assetType': type.toString(),
                          });
                    },
                  ),
                ),
                SizedBox(width: SizeConfig.padding12),
                Expanded(
                  flex: 6,
                  child: Stack(
                    children: [
                      MaterialButton(
                        minWidth: SizeConfig.padding156,
                        color: Colors.white,
                        height: SizeConfig.padding44,
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(SizeConfig.roundness5),
                        ),
                        child: Text(
                          "SAVE IN GOLD PRO",
                          style:
                              TextStyles.rajdhaniB.body1.colour(Colors.black),
                        ),
                        onPressed: () {
                          Haptic.vibrate();
                          AppState.delegate!.parseRoute(
                            Uri.parse('goldProDetails'),
                          );
                        },
                      ),
                      Transform.translate(
                        offset: Offset(0, -SizeConfig.padding12),
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            margin: EdgeInsets.only(
                              left: SizeConfig.padding20,
                            ),
                            width: SizeConfig.screenWidth! * 0.39,
                            child: AvailabilityOfferWidget(
                                color: UiConstants.kBlogTitleColor,
                                text:
                                    "*${AppConfig.getValue(AppConfigKey.goldProInterest).toDouble()}% Extra Returns*"),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          )
        : Selector<SubService, Subscriptions?>(
            selector: (_, subService) => subService.subscriptionData,
            builder: (context, state, child) {
              // state = SubscriptionModel();
              var userSegments = locator<UserService>().userSegments;

              // if(state == null && )
              return SizedBox(
                width: SizeConfig.screenWidth! * 0.85,
                child: Row(
                  mainAxisAlignment: state != null
                      ? MainAxisAlignment.center
                      : MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    if (state == null &&
                        !userSegments.contains(Constants.NO_SAVE_AUG) &&
                        !userSegments.contains(Constants.NO_SAVE_LB))
                      Expanded(
                        flex: 1,
                        child: MaterialButton(
                          minWidth:
                              state != null ? null : SizeConfig.padding156,
                          color: state != null ? Colors.white : null,
                          height: SizeConfig.padding44,
                          shape: RoundedRectangleBorder(
                            side: const BorderSide(
                                width: 1.5, color: Colors.white),
                            borderRadius:
                                BorderRadius.circular(SizeConfig.roundness5),
                          ),
                          child: Text(
                            "SAVE DAILY",
                            style: TextStyles.rajdhaniB.body1.colour(
                                state != null ? Colors.black : Colors.white),
                          ),
                          onPressed: () {
                            Haptic.vibrate();

                            if (state != null) {
                              BaseUtil()
                                  .openRechargeModalSheet(investmentType: type);
                            } else {
                              // AppState.delegate!.appState.currentAction =
                              //     PageAction(
                              //   state: PageState.addWidget,
                              //   page: AutosaveProcessViewPageConfig,
                              //   widget: AutosaveProcessView(
                              //     investmentType: type,
                              //   ),
                              // );
                            }

                            locator<AnalyticsService>().track(
                                eventName: state != null
                                    ? AnalyticsEvents.saveOnce
                                    : AnalyticsEvents.saveDaily,
                                properties: {
                                  'assetType': type.toString(),
                                });
                          },
                        ),
                      ),
                    SizedBox(width: SizeConfig.padding12),
                    Expanded(
                      flex: 1,
                      child: MaterialButton(
                        minWidth: SizeConfig.padding156,
                        color: Colors.white,
                        height: SizeConfig.padding44,
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(SizeConfig.roundness5),
                        ),
                        child: Text(
                          (state == null &&
                                  !userSegments
                                      .contains(Constants.NO_SAVE_AUG) &&
                                  !userSegments.contains(Constants.NO_SAVE_LB))
                              ? "SAVE ONCE"
                              : "SAVE",
                          style:
                              TextStyles.rajdhaniB.body1.colour(Colors.black),
                        ),
                        onPressed: () {
                          Haptic.vibrate();
                          BaseUtil()
                              .openRechargeModalSheet(investmentType: type);
                          locator<AnalyticsService>().track(
                              eventName: AnalyticsEvents.saveOnce,
                              properties: {
                                'assetType': type.toString(),
                              });
                          // BaseUtil().openRechargeModalSheet(
                          //     investmentType: widget.type);
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          );
  }
}

class _BuildOwnAsset extends StatelessWidget {
  const _BuildOwnAsset(
      {required this.type, required this.userService, Key? key})
      : super(key: key);
  final InvestmentType type;
  final UserService userService;

  @override
  Widget build(BuildContext context) {
    bool isGold = type == InvestmentType.AUGGOLD99;
    return isGold
        ? const SizedBox()
        : Padding(
            padding: EdgeInsets.only(
              top: SizeConfig.pageHorizontalMargins,
              bottom: SizeConfig.pageHorizontalMargins / 3,
              left: SizeConfig.pageHorizontalMargins / 2,
              right: SizeConfig.pageHorizontalMargins / 2,
            ),
            child: const FloBalanceBriefRow(
              tier: Constants.ASSET_TYPE_LENDBOX,
            ),
          );
  }

  Color get color => type == InvestmentType.AUGGOLD99
      ? const Color(0xff303B6A)
      : UiConstants.kFloContainerColor;
}

class FloBalanceBriefRow extends StatelessWidget {
  const FloBalanceBriefRow({
    required this.tier,
    this.mini = false,
    this.leftAlign = false,
    this.endAlign = false,
    super.key,
    this.lead,
    this.trail,
    this.percent,
  });

  final double? lead, trail, percent;
  final String tier;
  final bool mini;
  final bool leftAlign;
  final bool endAlign;

  @override
  Widget build(BuildContext context) {
    return Selector<UserService, Portfolio>(
      builder: (context, portfolio, child) => Row(
        children: [
          Expanded(
            flex: 6,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: (mini || leftAlign)
                  ? CrossAxisAlignment.start
                  : CrossAxisAlignment.center,
              children: [
                Text(
                  "Current",
                  style: TextStyles.rajdhaniM.colour(Colors.white60),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: (mini || leftAlign)
                      ? MainAxisAlignment.start
                      : MainAxisAlignment.center,
                  children: [
                    Flexible(
                      fit: FlexFit.loose,
                      child: Text(
                        "₹${BaseUtil.digitPrecision(lead ?? getCurrentValue(tier, portfolio), 2)}",
                        style: mini
                            ? TextStyles.sourceSansSB.body0
                            : TextStyles.sourceSansSB.title4,
                      ),
                    ),
                    Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            SizedBox(width: SizeConfig.padding6),
                            Transform.translate(
                              offset: Offset(0, -SizeConfig.padding4),
                              child: RotatedBox(
                                quarterTurns:
                                    getPercValue(tier, portfolio) >= 0 ? 0 : 2,
                                child: SvgPicture.asset(
                                  Assets.arrow,
                                  width: mini
                                      ? SizeConfig.iconSize3
                                      : SizeConfig.iconSize2,
                                  color: getPercValue(tier, portfolio) >= 0
                                      ? UiConstants.primaryColor
                                      : Colors.red,
                                ),
                              ),
                            ),
                            Text(
                                " ${BaseUtil.digitPrecision(
                                  getPercValue(tier, portfolio),
                                  2,
                                  false,
                                )}%",
                                style: TextStyles.sourceSans.body3.colour(
                                    getPercValue(tier, portfolio) >= 0
                                        ? UiConstants.primaryColor
                                        : Colors.red)),
                          ],
                        ),
                        SizedBox(
                          height:
                              mini ? SizeConfig.padding2 : SizeConfig.padding4,
                        )
                      ],
                    ),
                  ],
                )
              ],
            ),
          ),
          Expanded(
            flex: 4,
            child: Column(
              crossAxisAlignment: (mini || leftAlign)
                  ? CrossAxisAlignment.end
                  : endAlign
                      ? CrossAxisAlignment.end
                      : CrossAxisAlignment.center,
              children: [
                Text(
                  "Invested",
                  style: TextStyles.rajdhaniM.colour(Colors.white60),
                ),
                Text(
                  "₹${BaseUtil.digitPrecision(trail ?? getInvestedValue(tier, portfolio), 2)}",
                  style: mini
                      ? TextStyles.sourceSansSB.body0
                      : TextStyles.sourceSansSB.title4,
                )
              ],
            ),
          )
        ],
      ),
      selector: (p0, p1) => p1.userPortfolio,
    );
  }

  double getPercValue(String tier, Portfolio portfolio) {
    if (percent != null) return percent!;
    switch (tier) {
      case Constants.ASSET_TYPE_FLO_FIXED_6:
        return portfolio.flo.fixed2.percGains;
      case Constants.ASSET_TYPE_FLO_FIXED_3:
        return portfolio.flo.fixed1.percGains;
      case Constants.ASSET_TYPE_FLO_FELXI:
        return portfolio.flo.flexi.percGains;
      default:
        return portfolio.flo.percGains;
    }
  }

  double getCurrentValue(String tier, Portfolio portfolio) {
    switch (tier) {
      case Constants.ASSET_TYPE_FLO_FIXED_6:
        return portfolio.flo.fixed2.balance;
      case Constants.ASSET_TYPE_FLO_FIXED_3:
        return portfolio.flo.fixed1.balance;
      case Constants.ASSET_TYPE_FLO_FELXI:
        return portfolio.flo.flexi.balance;
      default:
        return portfolio.flo.balance;
    }
  }

  double getInvestedValue(String tier, Portfolio portfolio) {
    switch (tier) {
      case Constants.ASSET_TYPE_FLO_FIXED_6:
        return portfolio.flo.fixed2.principle;
      case Constants.ASSET_TYPE_FLO_FIXED_3:
        return portfolio.flo.fixed1.principle;
      case Constants.ASSET_TYPE_FLO_FELXI:
        return portfolio.flo.flexi.principle;
      default:
        return portfolio.flo.principle;
    }
  }
}

class ComparisonBox extends StatelessWidget {
  const ComparisonBox(
      {required this.backgroundColor, required this.isGold, Key? key})
      : super(key: key);
  final Color backgroundColor;
  final bool isGold;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(bottom: SizeConfig.padding20),
      color: UiConstants.kArrowButtonBackgroundColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: SizeConfig.padding20,
                vertical: SizeConfig.padding10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: SizeConfig.padding8),
                    child: RichText(
                      text: TextSpan(
                        text: isGold ? "Gold " : "Flo ",
                        style:
                            TextStyles.rajdhaniSB.title3.colour(Colors.white),
                        children: [
                          TextSpan(
                            text: "vs ",
                            style: TextStyles.rajdhaniSB.title3.colour(
                              const Color(0xffF6CC60),
                            ),
                          ),
                          TextSpan(
                            text: "other investments",
                            style: TextStyles.rajdhaniSB.title3
                                .colour(Colors.white),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Stack(
            alignment: Alignment.center,
            children: [
              Column(
                children: [
                  Container(
                    margin:
                        EdgeInsets.symmetric(horizontal: SizeConfig.padding40),
                    padding: EdgeInsets.symmetric(
                        horizontal: SizeConfig.padding24,
                        vertical: SizeConfig.padding10),
                    decoration: BoxDecoration(
                      color: backgroundColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          isGold ? Assets.goldAsset : Assets.floAsset,
                          height: SizeConfig.screenHeight! * 0.15,
                          width: SizeConfig.screenHeight! * 0.15,
                        ),
                        SizedBox(
                          width: SizeConfig.padding32,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              isGold ? "Digital Gold" : "Fello Flo",
                              style: TextStyles.sourceSans.body3,
                            ),
                            SizedBox(
                              width: SizeConfig.padding20,
                            ),
                            Text(
                              isGold ? "100%" : "12%",
                              style: TextStyles.rajdhaniSB.title1,
                            ),

                            // SizedBox(
                            //   height: SizeConfig.padding10,
                            // ),
                            Text(
                              isGold ? "Stable returns" : "Returns*",
                              style: TextStyles.sourceSans.body3
                                  .colour(Colors.white.withOpacity(0.4)),
                            ),
                            Text(
                              '(Per annum)',
                              style: TextStyles.sourceSans.body3
                                  .colour(Colors.white.withOpacity(0.4)),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: SizeConfig.padding16,
                  ),
                  CarouselSlider(
                    items: [
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: SizeConfig.padding24,
                            vertical: SizeConfig.padding10),
                        decoration: BoxDecoration(
                          color: const Color(0xff323232),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              Assets.crypto,
                              height: SizeConfig.screenHeight! * 0.12,
                              width: SizeConfig.screenHeight! * 0.12,
                            ),
                            SizedBox(
                              width: SizeConfig.padding32,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Crypto",
                                  style: TextStyles.sourceSans.body2,
                                  textAlign: TextAlign.start,
                                ),
                                SizedBox(
                                  height: SizeConfig.padding10,
                                ),
                                Text(
                                  "High volatility\nHigh Risk",
                                  textAlign: TextAlign.start,
                                  style: TextStyles.sourceSans.body3.colour(
                                    Colors.white.withOpacity(0.4),
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: SizeConfig.padding24,
                            vertical: SizeConfig.padding10),
                        decoration: BoxDecoration(
                          color: const Color(0xff323232),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              Assets.volatile,
                              height: SizeConfig.screenHeight! * 0.15,
                              width: SizeConfig.screenHeight! * 0.15,
                            ),
                            SizedBox(
                              width: SizeConfig.padding24,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "FDs",
                                  style: TextStyles.sourceSans.body3,
                                ),
                                SizedBox(
                                  height: SizeConfig.padding10,
                                ),
                                Text(
                                  "Low returns\nHigh lock-in",
                                  style: TextStyles.sourceSans.body3
                                      .colour(Colors.white.withOpacity(0.4)),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: SizeConfig.padding24,
                            vertical: SizeConfig.padding10),
                        decoration: BoxDecoration(
                          color: const Color(0xff323232),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              "assets/svg/stocks.svg",
                              height: SizeConfig.screenHeight! * 0.15,
                              width: SizeConfig.screenHeight! * 0.15,
                            ),
                            SizedBox(
                              width: SizeConfig.padding24,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Stocks",
                                  style: TextStyles.sourceSans.body3,
                                ),
                                SizedBox(
                                  height: SizeConfig.padding10,
                                ),
                                Text(
                                  "Volatile Returns\nHigh risk",
                                  style: TextStyles.sourceSans.body3
                                      .colour(Colors.white.withOpacity(0.4)),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: SizeConfig.padding24,
                            vertical: SizeConfig.padding10),
                        decoration: BoxDecoration(
                          color: const Color(0xff323232),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              "assets/svg/bonds.svg",
                              height: SizeConfig.screenHeight! * 0.15,
                              width: SizeConfig.screenHeight! * 0.15,
                            ),
                            SizedBox(
                              width: SizeConfig.padding24,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Bonds",
                                  style: TextStyles.sourceSans.body3,
                                ),
                                SizedBox(
                                  height: SizeConfig.padding10,
                                ),
                                Text(
                                  "Stable returns\nHigh Lock-in",
                                  style: TextStyles.sourceSans.body3
                                      .colour(Colors.white.withOpacity(0.4)),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    ],
                    options: CarouselOptions(
                        enlargeCenterPage: true,
                        autoPlay: true,
                        aspectRatio: 2.75,
                        viewportFraction: 0.8),
                  )
                ],
              ),
              Align(
                alignment: Alignment.center,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                      color: Colors.black,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white)),
                  child: Text(
                    "VS",
                    style: TextStyles.sourceSansB.body2,
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}

class _WhySection extends StatelessWidget {
  _WhySection({required this.isDigitalGold, Key? key}) : super(key: key);
  final bool isDigitalGold;

  final Map<dynamic, Widget> goldPros = {
    Assets.arrowIcon: RichText(
      text: TextSpan(
          text: "Pure 99.9% ",
          style: TextStyles.sourceSans.body2.colour(Colors.white),
          children: [
            TextSpan(
              text: "BIS Hallmark Gold",
              style:
                  TextStyles.sourceSans.body2.colour(const Color(0xffA7A7A8)),
            )
          ]),
    ),
    Assets.timer: RichText(
      text: TextSpan(
          text: "Stable ",
          style: TextStyles.sourceSans.body2.colour(const Color(0xffA7A7A8)),
          children: [
            TextSpan(
                text: "returns",
                style: TextStyles.sourceSans.body2.colour(Colors.white))
          ]),
    ),
    Assets.shield: RichText(
      text: TextSpan(
        text: "Safest mode ",
        style: TextStyles.sourceSans.body2.colour(Colors.white),
        children: [
          TextSpan(
              text: "of saving",
              style:
                  TextStyles.sourceSans.body2.colour(const Color(0xffA7A7A8)))
        ],
      ),
    ),
    Icons.lock_outline: Text("48 hours Lock-in",
        style: TextStyles.sourceSans.body2.colour(const Color(0xffA7A7A8)))
  };
  final Map<dynamic, Widget> felloPros = {
    Assets.arrowIcon: RichText(
      text: TextSpan(
          text: "Higher returns ",
          style: TextStyles.sourceSans.body2.colour(Colors.white),
          children: [
            TextSpan(
              text: "than other assets",
              style:
                  TextStyles.sourceSans.body2.colour(const Color(0xffA7A7A8)),
            )
          ]),
    ),
    Assets.timer: RichText(
      text: TextSpan(
          text: "Interest Credited",
          style: TextStyles.sourceSans.body2.colour(const Color(0xffA7A7A8)),
          children: [
            TextSpan(
                text: " Everyday",
                style: TextStyles.sourceSans.body2.colour(Colors.white)),
          ]),
    ),
    Assets.shield: RichText(
      text: TextSpan(
        text: "Authorized ",
        style: TextStyles.sourceSans.body2.colour(Colors.white),
        children: [
          TextSpan(
              text: "& Secured",
              style:
                  TextStyles.sourceSans.body2.colour(const Color(0xffA7A7A8)))
        ],
      ),
    ),
  };

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: SizeConfig.padding32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "Why ${isDigitalGold ? "Digital Gold" : "Fello Flo"}?",
            style: TextStyles.rajdhaniSB.title3,
          ),
          SizedBox(
            height: SizeConfig.padding14,
          ),
          ..._buildPros()
        ],
      ),
    );
  }

  List<Widget> _buildPros() {
    var children = <Widget>[];
    var list = isDigitalGold ? goldPros : felloPros;

    list.forEach(
      (key, value) {
        children.add(Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: SizeConfig.padding16,
                  width: SizeConfig.padding16,
                  child: key is String
                      ? Center(
                          child: SvgPicture.asset(
                            key,
                            fit: BoxFit.contain,
                          ),
                        )
                      : Center(
                          child: Icon(
                            key,
                            size: SizeConfig.padding20,
                            color: const Color(0xff62E3C4).withOpacity(0.7),
                          ),
                        ),
                ),
                SizedBox(
                  width: SizeConfig.padding24,
                ),
                value
              ],
            ),
          ),
        ));
      },
    );

    return children;
  }
}

class _Footer extends StatelessWidget {
  const _Footer({required this.isGold, Key? key}) : super(key: key);
  final bool isGold;
  final String goldTitle = "11% Returns gained from\nDigital Gold in 2022";
  final String felloTitle = "₹1000 invested every \nminute on Fello Flo";

  @override
  Widget build(BuildContext context) {
    final title = isGold ? goldTitle : felloTitle;
    final list = title.split(" ");
    final highlightedText = list.first;
    list.removeAt(0);
    final remaining = list.join(" ");
    return Padding(
      padding: EdgeInsets.symmetric(vertical: SizeConfig.padding32),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.topRight,
            child: Column(
              children: [
                SizedBox(
                  height: SizeConfig.padding32,
                ),
                Image.asset(
                  isGold ? Assets.goldConveyor : Assets.floConveyor,
                  fit: BoxFit.fill,
                  width: SizeConfig.screenHeight! * 0.4,
                ),
              ],
            ),
          ),
          Positioned(
            left: SizeConfig.padding44,
            child: RichText(
              text: TextSpan(
                text: "$highlightedText ",
                style: TextStyles.sourceSansSB.title5.colour(
                  const Color(0xffA9C6D6).withOpacity(0.7),
                ),
                children: [
                  TextSpan(
                    text: remaining,
                    style: TextStyles.sourceSansSB.title5.colour(
                      UiConstants.kTextColor2,
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CircularSlider extends StatefulWidget {
  const CircularSlider(
      {required this.type,
      required this.isNewUser,
      required this.interest,
      Key? key})
      : super(key: key);
  final InvestmentType type;
  final bool isNewUser;
  final int interest;

  @override
  State<CircularSlider> createState() => CircularSliderState();
}

class CircularSliderState extends State<CircularSlider> {
  double _volumeValue = 10000;
  bool isEventSent = false;

  void onVolumeChanged(double value) {
    if (!isEventSent) {
      locator<AnalyticsService>().track(
          eventName: "Return Calculator Used",
          properties: {"new user": widget.isNewUser});
      isEventSent = true;
    }
    setState(() {
      _volumeValue = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.loose,
      alignment: Alignment.bottomCenter,
      children: [
        Padding(
          padding: EdgeInsets.only(bottom: SizeConfig.padding40),
          child: CustomPaint(
            painter: CirclePainter(),
            child: SfRadialGauge(
              axes: <RadialAxis>[
                RadialAxis(
                  minimum: 100,
                  maximum: 50000,
                  startAngle: 270,
                  endAngle: 270,
                  showLabels: false,
                  showTicks: false,
                  radiusFactor: 0.6,
                  axisLineStyle: AxisLineStyle(
                      cornerStyle: CornerStyle.bothFlat,
                      color: const Color(0xffD9D9D9).withOpacity(0.5),
                      thickness: 6),
                  pointers: <GaugePointer>[
                    RangePointer(
                      value: _volumeValue,
                      cornerStyle: CornerStyle.bothCurve,
                      enableAnimation: true,
                      width: 12,
                      sizeUnit: GaugeSizeUnit.logicalPixel,
                      color: const Color(0xff3DA49D),
                    ),
                    MarkerPointer(
                        value: _volumeValue,
                        enableAnimation: true,
                        enableDragging: true,
                        onValueChanged: onVolumeChanged,
                        markerHeight: 24,
                        markerWidth: 24,
                        markerType: MarkerType.circle,
                        color: Colors.white,
                        borderWidth: 0,
                        borderColor: Colors.white)
                  ],
                  annotations: [
                    GaugeAnnotation(
                      widget: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Save Today",
                            style: TextStyles.sourceSans.body2.colour(
                              const Color(0xffA9C6D6),
                            ),
                          ),
                          Text(
                            "₹${_volumeValue.round()}",
                            style: TextStyles.rajdhaniB.title2,
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
        Positioned(
          top: -5,
          child: Column(
            children: [
              Text(
                "Return Calculator",
                style: TextStyles.rajdhaniSB.title3,
              ),
              Text(
                widget.type == InvestmentType.LENDBOXP2P
                    ? widget.interest == 12
                        ? "(Based on 12% returns*)"
                        : "(Based on 10% returns*)"
                    : "(Based on last years' returns)",
                style:
                    TextStyles.sourceSans.body3.colour(const Color(0xffA9C6D6)),
              ),
            ],
          ),
        ),
        Padding(
          padding:
              EdgeInsets.symmetric(horizontal: SizeConfig.screenWidth! * 0.1),
          child: Column(
            children: [
              Text(
                "To see it grow into",
                style:
                    TextStyles.sourceSans.body0.colour(const Color(0xffA9C6D6)),
              ),
              SizedBox(
                height: SizeConfig.padding16 + SizeConfig.padding2,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "₹${6.getReturns(widget.type, _volumeValue, widget.interest, 0)}",
                          style: TextStyles.rajdhaniSB.body1,
                        ),
                        Text(
                          "6 mo",
                          style: TextStyles.sourceSans.body3.colour(
                            UiConstants.kTextColor2,
                          ),
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "₹${12.getReturns(widget.type, _volumeValue, widget.interest, 0)}",
                          style: TextStyles.rajdhaniSB.body1,
                        ),
                        Text(
                          "1 Y",
                          style: TextStyles.sourceSans.body3.colour(
                            UiConstants.kTextColor2,
                          ),
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "₹${3.calculateCompoundInterest(
                            widget.type,
                            _volumeValue,
                            widget.interest,
                          )}",
                          style: TextStyles.rajdhaniSB.body1,
                        ),
                        Text(
                          "3 Y",
                          style: TextStyles.sourceSans.body3.colour(
                            UiConstants.kTextColor2,
                          ),
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "₹${5.calculateCompoundInterest(widget.type, _volumeValue, widget.interest)}",
                          style: TextStyles.rajdhaniSB.body1,
                        ),
                        Text(
                          "5 Y",
                          style: TextStyles.sourceSans.body3.colour(
                            UiConstants.kTextColor2,
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ],
          ),
        )
      ],
    );
  }
}

class CirclePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    for (var i = 0; i < 2; i++) {
      canvas.drawCircle(
        Offset(size.width / 2, size.height / 2),
        size.width * (0.41 - (0.06 * i)),
        Paint()
          ..color = const Color(0xffD9D9D9).withOpacity(0.1)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1
          ..shader = ui.Gradient.linear(
            Offset(size.width, size.height),
            Offset(0, size.height),
            [const Color(0xffD9D9D9), const Color(0xffD9D9D9).withOpacity(0)],
          ),
      );
    }
  }

  @override
  bool shouldRepaint(CirclePainter painter) => false;
}
