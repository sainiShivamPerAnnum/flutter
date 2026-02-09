import 'dart:ui' as ui;

import 'package:collection/collection.dart';
import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/constants/analytics_events_constants.dart';
import 'package:felloapp/core/enums/investment_type.dart';
import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/core/enums/user_service_enum.dart';
import 'package:felloapp/core/service/analytics/analytics_service.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/ui/elements/title_subtitle_container.dart';
import 'package:felloapp/ui/elements/video_player/app_video_player.dart';
import 'package:felloapp/ui/pages/finance/mini_trans_card/mini_trans_card_view.dart';
import 'package:felloapp/ui/pages/hometabs/save/save_viewModel.dart';
import 'package:felloapp/ui/pages/hometabs/save/silver_components/silver_comparison_section.dart';
import 'package:felloapp/ui/pages/hometabs/save/silver_components/silver_hero_card.dart';
import 'package:felloapp/ui/pages/hometabs/save/silver_components/silver_rate_graph.dart';
import 'package:felloapp/ui/pages/hometabs/save/silver_components/silver_rate_widget.dart';
import 'package:felloapp/ui/pages/login/login_components/login_support.dart';
import 'package:felloapp/ui/pages/static/app_widget.dart';
import 'package:felloapp/ui/service_elements/gold_sell_card/sell_card_view.dart';
import 'package:felloapp/util/assets.dart';
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

import '../../../../../core/enums/faqTypes.dart';

class SilverSectionView extends StatefulWidget {
  const SilverSectionView({
    this.showSkip = false,
    super.key,
  });

  final bool showSkip;

  @override
  State<SilverSectionView> createState() => _SilverSectionViewState();
}

class _SilverSectionViewState extends State<SilverSectionView> {

  final String subtitle = "99.9% Pure Silver • Secure Vault Storage ";
  final String description =
    "Digital silver is an efficient way of investing in silver. Each unit is backed by 99.9% purity silver.";

  final Map<String, String> _silverInfo = {
    "Steady": "Returns",
    "100%": "Secure",
    "Live": "Silver Rate",
  };

   final Map<String, String> _complainceInfo = {
    "In compliance with": Assets.sebiLogo,
    "RBI Approved": Assets.rbiLogo,
    "Banking Partner": Assets.iciciLogo,
  };

  FaqsType _getFaqTypeFromAsset(InvestmentType type) {
    return FaqsType.silver;
  }


  Color get _getBackgroundColor =>
    const Color.fromARGB(255, 18, 30, 36);

  Color get _secondaryColor => 
 const Color.fromARGB(255, 46, 81, 102).withOpacity(0);

  String get _getAsset => Assets.silverAsset;
  Color get _subTitleColor => const Color.fromARGB(255, 216, 218, 221);

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

        final balance = model.userFundWallet?.augGoldQuantity ?? 0;
        // final balance = model.userFundWallet?.augSilverQuantity ?? 0;
            
        return ChangeNotifierProvider.value(
          value: locator<SaveViewModel>(),
          builder: (context, child) {
            return Consumer<SaveViewModel>(
              builder: (context, state, _) {
                return RefreshIndicator(
                  color: UiConstants.primaryColor,
                  backgroundColor: Colors.black,
                  onRefresh: () async => await state.refreshTransactions(
                    InvestmentType.SILVER,
                  ),
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
                              end: Alignment.bottomCenter,
                            ),
                          ),
                        ),
                        SingleChildScrollView(
                          child: Padding(
                            padding: EdgeInsets.only(top: SizeConfig.padding28),
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
                                      ),
                                    ],
                                  ),
                                  child: SvgPicture.asset(
                                    _getAsset,
                                    height: SizeConfig.screenHeight! * 0.12,
                                  ),
                                ),
                                SizedBox(
                                  height: SizeConfig.padding4,
                                ),
                                Text(
                                 "Digital Silver",
                                  style: TextStyles.rajdhaniSB.title3
                                      .colour(Colors.white),
                                ),
                                SizedBox(
                                  height: SizeConfig.padding6,
                                ),
                                Text(
                                subtitle,
                                  style: TextStyles.sourceSans.body2
                                      .colour(_subTitleColor),
                                ),
                                 SizedBox(
                                  height: SizeConfig.padding6,
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: SizeConfig.padding40,
                                  ),
                                  child: Text(
                                    description,
                                    textAlign: TextAlign.center,
                                    style: TextStyles.sourceSans.body3.colour(
                                      Colors.white.withOpacity(0.8),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: SizeConfig.padding26,
                                ),
                                if (balance == 0)
                                  _buildInfoSection()
                                else
                                  const SilverInfoWidget(),
                                const SilverRateWidget(),
                                if (!hasSavedInAug) const LineSilverGradientChart(),
                                // const LineSilverGradientChart(),  // remove after testing
                                if (balance == 0)
                                  SizedBox(
                                    height: SizeConfig.padding14,
                                  ),
                                SizedBox(
                                  height: SizeConfig.padding14,
                                ),
                                if (!isNewUser) ...[
                                  const MiniTransactionCard(
                                    investmentType: InvestmentType.SILVER,
                                  ),
                                  if (balance != 0) ...[
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Padding(
                                        padding: EdgeInsets.only(
                                          left: SizeConfig.padding10,
                                        ),
                                        child: const TitleSubtitleContainer(
                                          title: "Withdrawal",
                                          leadingPadding: false,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: SizeConfig.padding12,
                                    ),
                                    const SellCardView(
                                    investmentType: InvestmentType.SILVER,
                                    ),
                                    SizedBox(
                                      height: SizeConfig.padding10,
                                    ),
                                  ],
                                ],
                                if (!isNewUser) ...[
                                  SizedBox(
                                    height: SizeConfig.padding24,
                                  ),
                                  CircularSlider(
                                    isNewUser: isNewUser,
                                    type: InvestmentType.SILVER,
                                    interest:8,
                                  ),
                                ],
                                SizedBox(
                                  height: SizeConfig.padding24,
                                ),
                                Text(
                                  "How to invest in Digital Silver?",
                                  style: TextStyles.rajdhaniSB.title3,
                                ),
                                SizedBox(
                                  height: SizeConfig.padding16,
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: SizeConfig.padding20,
                                  ),
                                  child: const AppVideoPlayer(
                                       "https://d37gtxigg82zaw.cloudfront.net/flo-workflow.mp4",
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
                                    type: InvestmentType.SILVER,
                                    interest: 8,
                                  ),
                                ],
                                SizedBox(
                                  height: SizeConfig.padding40,
                                ),
                                _WhySection(),
                                SizedBox(
                                  height: SizeConfig.screenHeight! * 0.06,
                                ),
                                const SilverComparisonSection(
                                  backgroundColor: Color.fromARGB(255, 3, 85, 132),
                                ),
                                SizedBox( height: SizeConfig.padding42,),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: SizeConfig.padding20,
                                  ),
                                  child: _buildComplianceSection(),
                                ),
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
                              vertical: SizeConfig.padding14,
                            ).copyWith(top: 2),
                            width: double.infinity,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(
                                        left: SizeConfig.padding4,
                                        right: SizeConfig.padding4,
                                        top: 2,
                                        bottom: 0,
                                      ),
                                      child: Text(
                                        "Powered by",
                                        style:
                                            TextStyles.sourceSans.body4.colour(
                                          UiConstants.kTextColor2,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: SizeConfig.padding1,
                                    ),
                                    SvgPicture.asset(
                                      Assets.augmontLogo,
                                      height: SizeConfig.screenHeight! * 0.01,
                                      width: SizeConfig.screenHeight! * 0.01,
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: SizeConfig.padding4,
                                ),
                                const AssetBottomButtons(
                                  type: InvestmentType.SILVER,),
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
                                  type: _getFaqTypeFromAsset(
                                    InvestmentType.SILVER),
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
                                        ),
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
          },
        );
      },
    );
  }

  Widget _buildInfoSection() {
    List<Widget> children = [];
    final info = _silverInfo;
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


  Widget _buildComplianceSection() {
  final info = _complainceInfo;
  List<Widget> children = [];

  info.entries.forEachIndexed((index, e) {
    children.add(
      Expanded(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              e.key,
              textAlign: TextAlign.center,
              style: TextStyles.rajdhaniSB.body4.colour(
                Colors.white.withOpacity(0.8),
              ),
            ),
            e.key == 'Banking Partner' ?
             SizedBox(height: SizeConfig.padding14) 
             : SizedBox(height: SizeConfig.padding8),
             AppImage(
              e.value,
              height: e.key == 'Banking Partner' ?
               SizeConfig.padding16 : SizeConfig.padding24,
            ),
          ],
        ),
      ),
    );

    if (index != info.length - 1) {
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
  });

  return Row(children: children);
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
    return Container(
      margin: EdgeInsets.only(top: SizeConfig.padding12),
      width: SizeConfig.screenWidth! * 0.85,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
         Expanded(
          flex: 5,
          child: Container(
            height: SizeConfig.padding44,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                Color(0xFF9DA5A6),
                Color(0xFFFBFBFB),
                Color(0xFFBBBBBB),
                Color(0xFF898989),
                Color(0xFF8C8C8C),
                Color(0xFFD9D8D6),
                Color(0xFFC5C4C4),
                ],
                stops: [
                  0.0,
                  0.1322,
                  0.659,
                  0.7762,
                  0.838,
                  0.9643,
                  1.0,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(SizeConfig.roundness5),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(SizeConfig.roundness5),
                onTap: () {
                  Haptic.vibrate();
                  BaseUtil().openRechargeModalSheet(investmentType: type);
                  locator<AnalyticsService>().track(
                    eventName: AnalyticsEvents.saveOnce,
                    properties: {
                      'assetType': type.toString(),
                    },
                  );
                },
                child: Center(
                  child: Text(
                    "INVEST NOW",
                    style: TextStyles.rajdhaniB.body1.colour(Colors.black),
                  ),
                ),
              ),
            ),
          ),
        ),
       ],
      ),
    );
  }
}

class _WhySection extends StatelessWidget {
  final Map<dynamic, Widget> silverPros = {
    Assets.arrowIcon: RichText(
      text: TextSpan(
        text: "Pure 99.9% ",
        style: TextStyles.sourceSans.body2.colour(Colors.white),
        children: [
          TextSpan(
            text: "BIS Hallmark Silver",
            style: TextStyles.sourceSans.body2.colour(const Color(0xffA7A7A8)),
          )
        ],
      ),
    ),
    Assets.timer: RichText(
      text: TextSpan(
        text: "Stable ",
        style: TextStyles.sourceSans.body2.colour(const Color(0xffA7A7A8)),
        children: [
          TextSpan(
            text: "returns",
            style: TextStyles.sourceSans.body2.colour(Colors.white),
          )
        ],
      ),
    ),
    Assets.shield: RichText(
      text: TextSpan(
        text: "Safest mode ",
        style: TextStyles.sourceSans.body2.colour(Colors.white),
        children: [
          TextSpan(
            text: "of saving",
            style: TextStyles.sourceSans.body2.colour(const Color(0xffA7A7A8)),
          ),
        ],
      ),
    ),
    Icons.lock_outline: Text(
      "48 hours Lock-in",
      style: TextStyles.sourceSans.body2.colour(const Color(0xffA7A7A8)),
    )
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
            "Why Digital Silver?",
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
    var list = silverPros;

    list.forEach(
      (key, value) {
        children.add(
          Padding(
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
          ),
        );
      },
    );

    return children;
  }
}

class CircularSlider extends StatefulWidget {
  const CircularSlider({
    required this.type,
    required this.isNewUser,
    required this.interest,
    super.key,
  });
  final InvestmentType type;
  final bool isNewUser;
  final num interest;

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
        properties: {"new user": widget.isNewUser},
      );
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
                    thickness: 6,
                  ),
                  pointers: <GaugePointer>[
                    RangePointer(
                      value: _volumeValue,
                      cornerStyle: CornerStyle.bothCurve,
                      enableAnimation: true,
                      width: 12,
                      sizeUnit: GaugeSizeUnit.logicalPixel,
                      color: const ui.Color.fromARGB(255, 72, 125, 158),
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
                      borderColor: Colors.white,
                    )
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
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
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
