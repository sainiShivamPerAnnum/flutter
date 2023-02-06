import 'dart:math';
import 'dart:ui' as ui;

import 'package:carousel_slider/carousel_slider.dart';
import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/enums/faqTypes.dart';
import 'package:felloapp/core/enums/investment_type.dart';
import 'package:felloapp/core/enums/user_service_enum.dart';
import 'package:felloapp/core/service/notifier_services/transaction_history_service.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/ui/elements/buttons/black_white_button/black_white_button.dart';
import 'package:felloapp/ui/elements/helpers/tnc_text.dart';
import 'package:felloapp/ui/elements/title_subtitle_container.dart';
import 'package:felloapp/ui/pages/finance/mini_trans_card/mini_trans_card_view.dart';
import 'package:felloapp/ui/pages/games/tambola/tambola_home/tambola_new_user_page.dart';
import 'package:felloapp/ui/pages/login/login_components/login_support.dart';
import 'package:felloapp/ui/pages/static/app_widget.dart';
import 'package:felloapp/ui/service_elements/gold_sell_card/sell_card_view.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/constants.dart';
import 'package:felloapp/util/dynamic_ui_utils.dart';
import 'package:felloapp/util/extensions/investment_returns_extension.dart';
import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:property_change_notifier/property_change_notifier.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

import '../../../../service_elements/user_service/user_fund_quantity_se.dart';

class AssetSectionView extends StatelessWidget {
  AssetSectionView({Key? key, required this.type, UserService? userService})
      : _userService = userService ?? locator<UserService>(),
        super(key: key);
  final InvestmentType type;
  final UserService _userService;
  bool get _isGold => type == InvestmentType.AUGGOLD99;

  final String _goldSubtitle = "24K Gold  •  99.99% Pure •  100% Secure";
  final String _floSubtitle = "P2P Asset  • 10% Returns • RBI Certified";

  final String __goldDescription =
      "Digital gold is an efficient way of investing in gold. Each unit is backed by 24K 99.9% purity gold.";

  final String _floDescription =
      "Fello Flo is an RBI regulated peer to peer lending asset offered in partnership with Lendbox-an RBI regulated P2P NBFC";

  final Map<String, String> _goldInfo = {
    "24K": "Gold",
    "99.9%": "Pure",
    "48 Hrs": "Lock-in"
  };

  final Map<String, String> _lbInfo = {
    "P2P": "Asset",
    "10%": "Returns",
    "7 days": "Lock-in"
  };

  @override
  Widget build(BuildContext context) {
    return PropertyChangeConsumer<UserService, UserServiceProperties>(
        properties: [
          UserServiceProperties.myUserWallet,
          UserServiceProperties.myAugmontDetails,
          UserServiceProperties.myUserFund,
          UserServiceProperties.mySegments,
        ],
        builder: (_, model, ___) {
          bool isNewUser = model!.baseUser!.segments.contains("NEW_USER");
          final balance = type == InvestmentType.AUGGOLD99
              ? model.userFundWallet!.augGoldQuantity
              : model.userFundWallet!.wLbBalance;
          return Scaffold(
            backgroundColor: Color(0xff232326),
            body: Stack(
              children: [
                Container(
                  height: SizeConfig.screenHeight! * 0.5,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [
                      _getBackgroundColor,
                      _secondaryColor,
                    ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
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
                          style:
                              TextStyles.rajdhaniSB.title3.colour(Colors.white),
                        ),
                        SizedBox(
                          height: SizeConfig.padding4,
                        ),

                        Text(
                          _isGold ? _goldSubtitle : _floSubtitle,
                          style: TextStyles.sourceSans.body2
                              .colour(_subTitleColor),
                        ),
                        SizedBox(
                          height: SizeConfig.padding10,
                        ),
                        if (balance == 0)
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: SizeConfig.padding40),
                            child: Text(
                              _isGold ? __goldDescription : _floDescription,
                              textAlign: TextAlign.center,
                              style: TextStyles.sourceSans.body3.colour(
                                Colors.white.withOpacity(0.6),
                              ),
                            ),
                          ),
                        if (balance != 0)
                          _BuildOwnAsset(
                            type: type,
                            userService: model,
                          ),
                        SizedBox(
                          height: SizeConfig.padding4,
                        ),
                        if (balance == 0) ...[
                          SizedBox(
                            height: SizeConfig.padding10,
                          ),
                          _buildInfoSection(),
                          SizedBox(
                            height: SizeConfig.padding10,
                          ),
                        ],
                        //TODO: Find a better slider to do this

                        if (!isNewUser) ...[
                          MiniTransactionCard(investmentType: type),
                          if (balance != 0) ...[
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding:
                                    EdgeInsets.only(left: SizeConfig.padding10),
                                child: TitleSubtitleContainer(
                                    title: "Withdrawal", leadingPadding: false),
                              ),
                            ),
                            SizedBox(
                              height: SizeConfig.padding12,
                            ),
                            SellCardView(investmentType: type),
                            SizedBox(
                              height: SizeConfig.padding28,
                            ),
                          ]
                        ],
                        SizedBox(
                          height: SizeConfig.padding8,
                        ),
                        Text(
                          _isGold
                              ? "How to save in Digital Gold?"
                              : "How Fello Flo works?",
                          style: TextStyles.rajdhaniSB.title5,
                        ),
                        SizedBox(
                          height: SizeConfig.padding24,
                        ),

                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: SizeConfig.padding20),
                          child: TambolaVideoPlayer(
                              link: "https://fello.in/videos/howToInvest.webm"),
                        ),
                        ...[
                          SizedBox(
                            height: SizeConfig.padding24,
                          ),
                          _CircularSlider(
                            type: type,
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
                        TermsAndConditions(url: Constants.savingstnc),
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
                    color: Color(0xff232326).withOpacity(0.9),
                    padding:
                        EdgeInsets.symmetric(vertical: SizeConfig.padding14)
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
                                    ? DynamicUiUtils.ctaText.AUGGOLD99 ?? ""
                                    : DynamicUiUtils.ctaText.LENDBOXP2P ?? "",
                                style: TextStyles.sourceSans.body4.colour(
                                  Color(0xff919193),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: SizeConfig.padding4,
                        ),
                        SizedBox(
                          width: SizeConfig.screenWidth! * 0.8,
                          height: SizeConfig.screenHeight! * 0.07,
                          child: AppPositiveBtn(
                              btnText: "SAVE",
                              onPressed: () {
                                BaseUtil().openRechargeModalSheet(
                                    investmentType: type);
                              }),
                        ),
                        SizedBox(
                          height: SizeConfig.padding2,
                        ),
                      ],
                    ),
                  ),
                ),
                SafeArea(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      BackButton(
                        color: Colors.white,
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                      Spacer(),
                      FaqPill(
                        type: FaqsType.savings,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }

  Widget _buildInfoSection() {
    final info = _isGold ? _goldInfo : _lbInfo;
    List<Widget> children = [];
    for (var e in info.entries) {
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
      if (!(info.values.toList().indexOf(e.value) == info.values.length - 1))
        children.add(
          SizedBox(
            height: SizeConfig.padding54,
            child: VerticalDivider(
              color: Color(0xff7F86A3).withOpacity(0.3),
              thickness: 0.5,
              width: 20,
            ),
          ),
        );
    }
    return Padding(
      padding: EdgeInsets.zero,
      child: Row(
        children: children,
      ),
    );
  }

  Color get _getBackgroundColor =>
      _isGold ? Color(0xff39498C) : Color(0xff023C40);
  Color get _secondaryColor => _isGold
      ? Color(0xff293566).withOpacity(0)
      : Color(0xff297264).withOpacity(0);

  String get _getAsset => _isGold ? Assets.goldAsset : Assets.floAsset;

  Color get _subTitleColor => _isGold ? Color(0xff93B5FE) : Color(0xff62E3C4);
}

class _BuildOwnAsset extends StatelessWidget {
  const _BuildOwnAsset(
      {Key? key, required this.type, required this.userService})
      : super(key: key);
  final InvestmentType type;
  final UserService userService;
  @override
  Widget build(BuildContext context) {
    bool isGold = type == InvestmentType.AUGGOLD99;
    return Container(
      margin: EdgeInsets.symmetric(
          horizontal: SizeConfig.padding34, vertical: SizeConfig.padding10),
      padding: EdgeInsets.symmetric(
          horizontal: SizeConfig.padding24, vertical: SizeConfig.padding20),
      decoration: BoxDecoration(
        color: color,
        border: Border.all(color: Colors.white.withOpacity(0.5)),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Text(
                isGold
                    ? "You Own"
                    : (userService.userFundWallet?.wLbBalance ==
                            userService.userFundWallet?.wLbPrinciple)
                        ? "Invested Amount"
                        : "Current Amount",
                style: TextStyles.sourceSans.body2,
                textAlign: TextAlign.center,
              ),
              if (!isGold &&
                  !(userService.userFundWallet?.wLbBalance ==
                      userService.userFundWallet?.wLbPrinciple))
                LboxGrowthArrow(),
              Spacer(),
              Text(
                isGold
                    ? (userService.userFundWallet?.augGoldQuantity ?? 0)
                            .toString() +
                        " gms"
                    : "₹ " +
                        (userService.userFundWallet?.wLbBalance ?? 0)
                            .toStringAsFixed(2),
                textAlign: TextAlign.center,
                style: TextStyles.rajdhaniSB.title3.colour(
                  Colors.white.withOpacity(0.8),
                ),
              )
            ],
          ),
          if (type == InvestmentType.LENDBOXP2P &&
              !(userService.userFundWallet?.wLbBalance ==
                  userService.userFundWallet?.wLbPrinciple)) ...[
            SizedBox(
              height: SizeConfig.padding4,
            ),
            Row(
              children: [
                Text(
                  "Invested Amount",
                  style: TextStyles.sourceSans.body2,
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  width: SizeConfig.padding1,
                ),
                Spacer(),
                Text(
                  "₹ " +
                      (userService.userFundWallet?.wLbPrinciple ?? 0)
                          .toStringAsFixed(2),
                  textAlign: TextAlign.center,
                  style: TextStyles.rajdhaniSB.title3.colour(
                    Colors.white.withOpacity(0.8),
                  ),
                )
              ],
            ),
          ]
        ],
      ),
    );
  }

  Color get color =>
      type == InvestmentType.AUGGOLD99 ? Color(0xff303B6A) : Color(0xff023C40);
}

class ComparisonBox extends StatelessWidget {
  const ComparisonBox(
      {Key? key, required this.backgroundColor, required this.isGold})
      : super(key: key);
  final Color backgroundColor;
  final bool isGold;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(bottom: SizeConfig.padding20),
      color: Color(0xff1A1A1A),
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
                        text: isGold ? "Gold " : "Fello Flo ",
                        style:
                            TextStyles.rajdhaniSB.title5.colour(Colors.white),
                        children: [
                          TextSpan(
                            text: "vs ",
                            style: TextStyles.rajdhaniSB.title5.colour(
                              Color(0xffF6CC60),
                            ),
                          ),
                          TextSpan(
                            text: "other investments",
                            style: TextStyles.rajdhaniSB.title5
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
                        horizontal: SizeConfig.padding28,
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
                              isGold ? "100%" : "10%",
                              style: TextStyles.rajdhaniSB.title1,
                            ),
                            // SizedBox(
                            //   height: SizeConfig.padding10,
                            // ),
                            Text(
                              isGold ? "Stable returns" : "Assured Returns",
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
                            horizontal: SizeConfig.padding34,
                            vertical: SizeConfig.padding10),
                        decoration: BoxDecoration(
                          color: Color(0xff323232),
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
                                  "No Fixed returns\nHigh Risk",
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
                            horizontal: SizeConfig.padding34,
                            vertical: SizeConfig.padding10),
                        decoration: BoxDecoration(
                          color: Color(0xff323232),
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
                                  "Mutual Funds",
                                  style: TextStyles.sourceSans.body3,
                                ),
                                SizedBox(
                                  height: SizeConfig.padding10,
                                ),
                                Text(
                                  "Low Returns\nHigh Risk",
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
                            horizontal: SizeConfig.padding34,
                            vertical: SizeConfig.padding10),
                        decoration: BoxDecoration(
                          color: Color(0xff323232),
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
                                  "Volatile Returns\nHigh Risk",
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
                            horizontal: SizeConfig.padding34,
                            vertical: SizeConfig.padding10),
                        decoration: BoxDecoration(
                          color: Color(0xff323232),
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
                                  "Volatile Returns\nHigh Lock-in",
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
                  padding: EdgeInsets.all(8),
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
  _WhySection({Key? key, required this.isDigitalGold}) : super(key: key);
  final bool isDigitalGold;

  final Map<dynamic, Widget> goldPros = {
    Assets.arrowIcon: RichText(
      text: TextSpan(
          text: "Steady returns ",
          style: TextStyles.sourceSans.body2.colour(Colors.white),
          children: [
            TextSpan(
              text: "on the investment",
              style: TextStyles.sourceSans.body2.colour(Color(0xffA7A7A8)),
            )
          ]),
    ),
    Assets.timer: RichText(
      text: TextSpan(
          text: "Interest Credited",
          style: TextStyles.sourceSans.body2.colour(Color(0xffA7A7A8)),
          children: [
            TextSpan(
                text: "Everyday",
                style: TextStyles.sourceSans.body2.colour(Colors.white))
          ]),
    ),
    Assets.shield: RichText(
      text: TextSpan(
        text: "No risks ",
        style: TextStyles.sourceSans.body2.colour(Colors.white),
        children: [
          TextSpan(
              text: "involved",
              style: TextStyles.sourceSans.body2.colour(Color(0xffA7A7A8)))
        ],
      ),
    ),
    Icons.lock_outline: Text("48 hours Lock-in",
        style: TextStyles.sourceSans.body2.colour(Color(0xffA7A7A8)))
  };
  final Map<dynamic, Widget> felloPros = {
    Assets.arrowIcon: RichText(
      text: TextSpan(
          text: "Higher returns ",
          style: TextStyles.sourceSans.body2.colour(Colors.white),
          children: [
            TextSpan(
              text: "than other assets",
              style: TextStyles.sourceSans.body2.colour(Color(0xffA7A7A8)),
            )
          ]),
    ),
    Assets.timer: RichText(
      text: TextSpan(
          text: "Interest Credited",
          style: TextStyles.sourceSans.body2.colour(Color(0xffA7A7A8)),
          children: [
            TextSpan(
                text: " Everyday",
                style: TextStyles.sourceSans.body2.colour(Colors.white)),
          ]),
    ),
    Assets.shield: RichText(
      text: TextSpan(
        text: "No risks ",
        style: TextStyles.sourceSans.body2.colour(Colors.white),
        children: [
          TextSpan(
              text: "involved",
              style: TextStyles.sourceSans.body2.colour(Color(0xffA7A7A8)))
        ],
      ),
    ),
    Icons.lock_outline: Text("7 days Lock-in",
        style: TextStyles.sourceSans.body2.colour(Color(0xffA7A7A8)))
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
            style: TextStyles.rajdhaniSB.title5,
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
                            color: Color(0xff62E3C4).withOpacity(0.7),
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
  const _Footer({Key? key, required this.isGold}) : super(key: key);
  final bool isGold;
  static String goldTitle =
      "₹1Cr invested till date\nin digital Gold on \nFello";
  static String felloTitle = "₹80 Lakh invested \ntill date on Fello flo";

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
          RichText(
            text: TextSpan(
              text: highlightedText + " ",
              style: TextStyles.sourceSansSB.title5.colour(
                Color(0xffA9C6D6).withOpacity(0.7),
              ),
              children: [
                TextSpan(
                  text: remaining,
                  style: TextStyles.sourceSansSB.title5.colour(
                    Color(0xff919193),
                  ),
                )
              ],
            ),
          ),
          Column(
            children: [
              SizedBox(
                height: SizeConfig.padding32,
              ),
              Image.asset(
                isGold ? Assets.goldConveyor : Assets.floConveyor,
                fit: BoxFit.fill,
              ),
            ],
          )
        ],
      ),
    );
  }
}

class _CircularSlider extends StatefulWidget {
  const _CircularSlider({Key? key, required this.type}) : super(key: key);
  final InvestmentType type;

  @override
  State<_CircularSlider> createState() => _CircularSliderState();
}

class _CircularSliderState extends State<_CircularSlider> {
  double _volumeValue = 500;

  void onVolumeChanged(double value) {
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
                      color: Color(0xffD9D9D9).withOpacity(0.5),
                      thickness: 6),
                  pointers: <GaugePointer>[
                    RangePointer(
                      value: _volumeValue,
                      cornerStyle: CornerStyle.bothCurve,
                      enableAnimation: true,
                      width: 12,
                      sizeUnit: GaugeSizeUnit.logicalPixel,
                      color: Color(0xff3DA49D),
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
                            "Invest Today",
                            style: TextStyles.sourceSans.body2.colour(
                              Color(0xffA9C6D6),
                            ),
                          ),
                          Text(
                            "₹" + _volumeValue.round().toString(),
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
          top: 12,
          child: Text(
            "Return Calculator",
            style: TextStyles.rajdhaniSB.title5,
          ),
        ),
        Padding(
          padding:
              EdgeInsets.symmetric(horizontal: SizeConfig.screenWidth! * 0.1),
          child: Column(
            children: [
              Text(
                "To see it grow into",
                style: TextStyles.sourceSans.body0.colour(Color(0xffA9C6D6)),
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
                          "₹" +
                              6.getReturns(
                                  widget.type, _volumeValue.round(), 0),
                          style: TextStyles.rajdhaniSB.body1,
                        ),
                        Text(
                          "6 mo",
                          style: TextStyles.sourceSans.body3.colour(
                            Color(0xff919193),
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
                          "₹" +
                              12.getReturns(
                                  widget.type, _volumeValue.round(), 0),
                          style: TextStyles.rajdhaniSB.body1,
                        ),
                        Text(
                          "1 Y",
                          style: TextStyles.sourceSans.body3.colour(
                            Color(0xff919193),
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
                          "₹" +
                              3.calculateCompoundInterest(
                                  widget.type, _volumeValue.round()),
                          style: TextStyles.rajdhaniSB.body1,
                        ),
                        Text(
                          "3 Y",
                          style: TextStyles.sourceSans.body3.colour(
                            Color(0xff919193),
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
                          "₹" +
                              5.calculateCompoundInterest(
                                  widget.type, _volumeValue.round()),
                          style: TextStyles.rajdhaniSB.body1,
                        ),
                        Text(
                          "5 Y",
                          style: TextStyles.sourceSans.body3.colour(
                            Color(0xff919193),
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
        (size.width * (0.41 - (0.06 * i))),
        Paint()
          ..color = Color(0xffD9D9D9).withOpacity(0.1)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1
          ..shader = ui.Gradient.linear(
            Offset(size.width, size.height),
            Offset(0, size.height),
            [Color(0xffD9D9D9), Color(0xffD9D9D9).withOpacity(0)],
          ),
      );
    }
  }

  @override
  bool shouldRepaint(CirclePainter painter) => false;
}
