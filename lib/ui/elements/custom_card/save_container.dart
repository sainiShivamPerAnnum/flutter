import 'package:carousel_slider/carousel_slider.dart';
import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/constants/analytics_events_constants.dart';
import 'package:felloapp/core/enums/investment_type.dart';
import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/core/service/analytics/analyticsProperties.dart';
import 'package:felloapp/core/service/analytics/analytics_service.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/ui/elements/buttons/black_white_button/black_white_button.dart';
import 'package:felloapp/ui/pages/hometabs/save/save_components/asset_view_section.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/dynamic_ui_utils.dart';
import 'package:felloapp/util/extensions/investment_returns_extension.dart';
import 'package:felloapp/util/haptic.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';

// ignore: camel_case_types
typedef onInvestmentChange = void Function(int amount);

Map<String, String> _goldInfo = {
  "24K": "Gold",
  "99.9%": "Pure",
  "Live": "Gold Rate"
};

Map<String, String> _lbInfo = {
  "P2P": "Asset",
  "10%": "Returns",
  "Everyday": "Credits"
};

final _goldMarquee = [
  "₹1 Crore+ invested in Gold on Fello",
  "Minimize risks in your portfolio",
  "48 hours lock-in period"
];

final _floMarquee = [
  "Higher returns than FDs",
  "Your money is safe with us",
  "7 days lock-in period"
];

class SaveContainer extends StatefulWidget {
  SaveContainer({
    Key? key,
    required this.investmentType,
    this.isPopular = false,
    required this.bottomStrip,
  })  : isGold = investmentType == InvestmentType.AUGGOLD99,
        super(key: key);
  final InvestmentType investmentType;
  final bool isPopular;
  final List<String> bottomStrip;

  final bool isGold;

  @override
  State<SaveContainer> createState() => _SaveContainerState();
}

class _SaveContainerState extends State<SaveContainer> {
  late int value;

  @override
  initState() {
    value = widget.investmentType == InvestmentType.AUGGOLD99 ? 500 : 1000;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        locator<AnalyticsService>().track(
          eventName: AnalyticsEvents.assetBannerTapped,
          properties: AnalyticsProperties.getDefaultPropertiesMap(
            extraValuesMap: {
              "isNewUser": true,
              'Asset': widget.investmentType == InvestmentType.AUGGOLD99
                  ? "Gold"
                  : "Flo",
              "Failed transaction count":
                  AnalyticsProperties.getFailedTxnCount(),
              "Successs transaction count":
                  AnalyticsProperties.getSucessTxnCount(),
              "Pending transaction count":
                  AnalyticsProperties.getPendingTxnCount(),
              "amt": value,
            },
          ),
        );
        AppState.delegate!.appState.currentAction = PageAction(
            state: PageState.addWidget,
            page: AssetViewPageConfig,
            widget: AssetSectionView(type: widget.investmentType));
      },
      child: Padding(
        padding: EdgeInsets.only(bottom: SizeConfig.padding20),
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: SizeConfig.padding24),
          height: SizeConfig.screenHeight! * 0.35,
          decoration: BoxDecoration(
            color: getCardBgColor,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [BoxShadow(color: Color.fromRGBO(0, 0, 0, 1))],
            border: widget.isPopular
                ? Border.all(color: borderColor, width: 2)
                : null,
          ),
          child: Stack(
            children: [
              Column(
                children: [
                  _Header(
                    investmentType: widget.investmentType,
                  ),
                  SizedBox(
                    height: SizeConfig.padding20 + SizeConfig.padding2,
                  ),
                  _InvestmentDetails(
                    type: widget.investmentType,
                    initialValue: value,
                    onChange: (p0) => value = p0,
                  ),
                  // SizedBox(
                  //   height: SizeConfig.padding20,
                  // ),
                  // Stack(
                  //   children: [
                  //     Padding(
                  //       padding: EdgeInsets.symmetric(
                  //           horizontal: SizeConfig.padding16),
                  //       child: Divider(
                  //         color: Color(0xff93B5FE).withOpacity(0.3),
                  //       ),
                  //     ),
                  //     Align(
                  //       alignment: Alignment.center,
                  //       child: ColoredBox(
                  //         color: getCardBgColor,
                  //         child: Padding(
                  //           padding: EdgeInsets.symmetric(horizontal: 8),
                  //           child: Text(
                  //             "You will invest in",
                  //             style: TextStyles.sourceSans.body4
                  //                 .colour(Colors.white.withOpacity(0.6)),
                  //           ),
                  //         ),
                  //       ),
                  //     ),
                  //   ],
                  // ),
                  // SizedBox(
                  //   height: SizeConfig.padding14,
                  // ),
                  // _buildInformationRow(),
                  // SizedBox(
                  //   height: SizeConfig.padding14,
                  // ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: SizeConfig.padding16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: BlackWhiteButton.inverse(
                                height: SizeConfig.screenHeight! * 0.05,
                                onPress: () {
                                  locator<AnalyticsService>().track(
                                      eventName: "Asset Learn More Tapped",
                                      properties: {
                                        "asset name": widget.investmentType ==
                                                InvestmentType.AUGGOLD99
                                            ? "Gold"
                                            : "Flo",
                                        "amt": value,
                                        "isPopular": widget.isPopular,
                                        // "popularTag":
                                      });
                                  AppState.delegate!.appState.currentAction =
                                      PageAction(
                                    state: PageState.addWidget,
                                    page: AssetViewPageConfig,
                                    widget: AssetSectionView(
                                        type: widget.investmentType),
                                  );
                                },
                                title: "LEARN MORE"),
                          ),
                          SizedBox(
                            width: SizeConfig.padding6,
                          ),
                          Expanded(
                            child: BlackWhiteButton(
                              height: SizeConfig.screenHeight! * 0.05,
                              onPress: () {
                                locator<AnalyticsService>().track(
                                    eventName: "Save on Asset Banner",
                                    properties: {
                                      "asset name": widget.investmentType ==
                                              InvestmentType.AUGGOLD99
                                          ? "Gold"
                                          : "Flo",
                                      "balance in gold": locator<UserService>()
                                              .userFundWallet
                                              ?.augGoldBalance ??
                                          0,
                                      "isNewUser": true,
                                      "balance in flo": locator<UserService>()
                                              .userFundWallet
                                              ?.wLbBalance ??
                                          0,
                                      "amt": value
                                    });
                                BaseUtil().openRechargeModalSheet(
                                    investmentType: widget.investmentType,
                                    amt: value);
                              },
                              title: "SAVE NOW",
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(
                    height: SizeConfig.padding40,
                    width: double.infinity,
                    child: Builder(builder: (context) {
                      final type =
                          widget.investmentType == InvestmentType.AUGGOLD99
                              ? _goldMarquee
                              : _floMarquee;
                      return CarouselSlider.builder(
                        itemCount: type.length,
                        itemBuilder: (context, index, realIndex) => Center(
                          child: Text(
                            type[index],
                            textAlign: TextAlign.center,
                            style: TextStyles.sourceSans.body3
                                .colour(Colors.white.withOpacity(0.3)),
                          ),
                        ),
                        options: CarouselOptions(
                            autoPlay: true,
                            viewportFraction: 1,
                            scrollPhysics: NeverScrollableScrollPhysics()),
                      );
                    }),
                  ),
                  // SizedBox(
                  //   height: SizeConfig.padding8,
                  // ),
                ],
              ),
              if (widget.isPopular)
                Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: SizeConfig.padding12,
                      vertical: SizeConfig.padding2,
                    ),
                    decoration: BoxDecoration(
                        color: borderColor,
                        borderRadius:
                            BorderRadius.vertical(bottom: Radius.circular(5))),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SvgPicture.asset(Assets.arrowTreading),
                        SizedBox(
                          width: SizeConfig.padding4,
                        ),
                        Text(
                          widget.investmentType == InvestmentType.AUGGOLD99
                              ? DynamicUiUtils.goldTag
                              : DynamicUiUtils.lbTag,
                          style: TextStyles.sourceSansSB.body4
                              .colour(UiConstants.kBackgroundColor),
                        ),
                      ],
                    ),
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInformationRow() {
    final info = widget.isGold ? _goldInfo : _lbInfo;

    List<Widget> children = [];

    info.forEach((key, value) {
      final child = Column(
        crossAxisAlignment: getAlignment(info.keys.toList().indexOf(key)),
        children: [
          Text(
            key,
            style: TextStyles.rajdhaniSB.body2.colour(
              Colors.white.withOpacity(0.5),
            ),
          ),
          Text(
            value,
            style: TextStyles.sourceSans.body4
                .colour(Colors.white.withOpacity(0.4)),
          )
        ],
      );

      children.add(child);
    });

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: SizeConfig.padding16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: children,
      ),
    );
  }

  CrossAxisAlignment getAlignment(int i) {
    switch (i) {
      case 0:
        return CrossAxisAlignment.start;
      case 1:
        return CrossAxisAlignment.center;
      case 2:
        return CrossAxisAlignment.end;

      default:
        return CrossAxisAlignment.center;
    }
  }

  Color get getCardBgColor {
    if (widget.isGold) return Color(0xff293566);

    return Color(0xff173B3F);
  }

  //TODO: Get a border color for lendbox container
  Color get borderColor =>
      widget.isGold ? Color(0xff93B5FE) : Color(0xff3CB9A4);
}

class _InvestmentDetails extends StatelessWidget {
  _InvestmentDetails(
      {Key? key,
      required this.type,
      required this.initialValue,
      required this.onChange})
      : super(key: key);

  final int initialValue;
  final InvestmentType type;
  final void Function(int) onChange;
  @override
  Widget build(BuildContext context) {
    ValueNotifier<int> _onValueChanged = ValueNotifier(initialValue);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: SizeConfig.padding20)
          .copyWith(right: SizeConfig.padding34),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Invest today",
                style: TextStyles.sourceSans.body4.colour(
                  Colors.white.withOpacity(0.7),
                ),
              ),
              SizedBox(
                height: SizeConfig.padding2,
              ),
              _InvestCounter(
                  initialCount: initialValue,
                  onChange: (value) {
                    _onValueChanged.value = value;
                    onChange.call(value);
                  }),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Gain in 3Y",
                style: TextStyles.sourceSans.body4.colour(
                  Colors.white.withOpacity(0.7),
                ),
              ),
              SizedBox(
                height: SizeConfig.padding2,
              ),
              ValueListenableBuilder<int>(
                valueListenable: _onValueChanged,
                builder: (context, snapshot, child) {
                  return Text(
                      "₹${3.calculateCompoundInterest(type, _onValueChanged.value * 1.0)}",
                      style: TextStyles.rajdhaniSB.title4);
                },
              )
            ],
          ),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({Key? key, required this.investmentType}) : super(key: key);
  final InvestmentType investmentType;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: SizeConfig.padding20)
          .copyWith(bottom: SizeConfig.padding4, top: SizeConfig.padding8),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(12),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                investmentType == InvestmentType.AUGGOLD99
                    ? "Digital Gold"
                    : "Fello Flo",
                style: TextStyles.rajdhaniSB.title4,
              ),
              Text(
                investmentType == InvestmentType.AUGGOLD99
                    ? "24K Gold • 99.99% Pure  •  100% Secure"
                    : "P2P Asset  • 10% Returns •  RBI Certified",
                style: TextStyles.sourceSans.body4
                    .colour(Colors.white.withOpacity(0.8)),
              ),
            ],
          ),
          SvgPicture.asset(
            investmentType == InvestmentType.AUGGOLD99
                ? Assets.goldAsset
                : Assets.floAsset,
          )
        ],
      ),
    );
  }

  Color get bgColor => investmentType == InvestmentType.AUGGOLD99
      ? Color(0xff495DB2)
      : Color(0xff01656B);
}

class _InvestCounter extends StatefulWidget {
  _InvestCounter({Key? key, this.initialCount, this.onChange})
      : super(key: key);
  final int? initialCount;
  final onInvestmentChange? onChange;

  @override
  State<_InvestCounter> createState() => _InvestCounterState();
}

class _InvestCounterState extends State<_InvestCounter> {
  late ValueNotifier<int> _investmentCounter;

  @override
  initState() {
    _investmentCounter = ValueNotifier(widget.initialCount ?? 200);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _buildIconButton(Icons.remove, _onRemove),
        ValueListenableBuilder<int>(
            valueListenable: _investmentCounter,
            builder: (context, snapshot, child) {
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: SizeConfig.padding12),
                child: Text(
                  "₹$snapshot",
                  style: TextStyles.rajdhaniSB.title4,
                ),
              );
            }),
        _buildIconButton(Icons.add, _onAdd),
      ],
    );
  }

  void _onAdd() {
    locator<AnalyticsService>().track(
        eventName: "Amount Edit on Asset Banner", properties: {"type": "plus"});
    _investmentCounter.value += 100;
    widget.onChange?.call(_investmentCounter.value);
  }

  void _onRemove() {
    if (_investmentCounter.value == 100) return;
    locator<AnalyticsService>().track(
        eventName: "Amount Edit on Asset Banner",
        properties: {"type": "minus"});
    _investmentCounter.value -= 100;
    widget.onChange?.call(_investmentCounter.value);
  }

  Widget _buildIconButton(IconData icons, void Function() onChange) {
    return InkWell(
      onTap: () {
        Haptic.vibrate();
        onChange.call();
      },
      child: Padding(
        padding: EdgeInsets.all(4),
        child: Container(
          height: SizeConfig.padding24,
          width: SizeConfig.padding24,
          decoration: BoxDecoration(
              color: Color(0Xff0C1D20).withOpacity(0.5),
              shape: BoxShape.circle),
          child: Icon(icons, color: Colors.white, size: SizeConfig.padding16),
        ),
      ),
    );
  }
}
