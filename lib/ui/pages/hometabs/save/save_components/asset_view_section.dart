import 'dart:math';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:felloapp/core/enums/faqTypes.dart';
import 'package:felloapp/core/enums/investment_type.dart';
import 'package:felloapp/ui/elements/buttons/black_white_button/black_white_button.dart';
import 'package:felloapp/ui/pages/login/login_components/login_support.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class AssetSectionView extends StatelessWidget {
  AssetSectionView({Key? key, required this.type}) : super(key: key);
  final InvestmentType type;

  bool get _isGold => type == InvestmentType.AUGGOLD99;

  final String _goldSubtitle = "Low risk   • Withdraw anytime •   No KYC";
  final String _floSubtitle = "Quick Returns • Withdraw anytime";

  final String __goldDescription =
      "Digital gold is an efficient way of investing in gold. Each unit is backed by 24K 99.9% purity gold.";

  final String _floDescription =
      "A peer to peer lending asset which is regulated by RBI, promised to give quick and steady returns";

  final Map<String, String> _goldInfo = {
    "24K": "Gold",
    "99.9%": "Pure",
    "Live": "Gold Rate"
  };

  final Map<String, String> _lbInfo = {
    "P2P": "Asset",
    "10%": "Returns",
    "Everyday": "Credits"
  };

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
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
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      BackButton(
                        color: Colors.white,
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                      FaqPill(
                        type: FaqsType.savings,
                      ),
                    ],
                  ),
                  Container(
                    decoration:
                        BoxDecoration(shape: BoxShape.circle, boxShadow: [
                      BoxShadow(
                        color: Colors.white.withOpacity(0.3),
                        blurRadius: 50,
                      )
                    ]),
                    child: SvgPicture.asset(
                      _getAsset,
                      height: SizeConfig.screenHeight! * 0.15,
                    ),
                  ),
                  SizedBox(
                    height: SizeConfig.padding10,
                  ),
                  Text(
                    _isGold ? "Digital Gold" : "Fello Flo",
                    style: TextStyles.rajdhaniSB.title4.colour(Colors.white),
                  ),
                  Text(
                    _isGold ? _goldSubtitle : _floSubtitle,
                    style: TextStyles.sourceSans.body2.colour(_subTitleColor),
                  ),
                  SizedBox(
                    height: SizeConfig.padding10,
                  ),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: SizeConfig.padding40),
                    child: Text(
                      _isGold ? __goldDescription : _floDescription,
                      textAlign: TextAlign.center,
                      style: TextStyles.sourceSans.body3.colour(
                        Colors.white.withOpacity(0.6),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: SizeConfig.padding20,
                  ),
                  _buildInfoSection(),
                  //TODO: Find a better slider to do this
                  _CircularSlider(),
                  _WhySection(isDigitalGold: _isGold),

                  SizedBox(
                    height: SizeConfig.screenHeight! * 0.15,
                  ),
                  ComparisonBox(
                    backgroundColor: _getBackgroundColor,
                    isGold: _isGold,
                  ),
                  _Footer(
                    isGold: _isGold,
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                color: Color(0xff232326),
                padding: EdgeInsets.symmetric(vertical: SizeConfig.padding14),
                width: double.infinity,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    BlackWhiteButton(
                      width: SizeConfig.screenWidth! * 0.8,
                      padding: EdgeInsets.symmetric(vertical: 12),
                      onPress: () {},
                      title: "Invest Now",
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          _getAsset,
                          height: SizeConfig.screenHeight! * 0.05,
                          width: SizeConfig.screenHeight! * 0.05,
                        ),
                        Text(
                          "56% of our users have invested in ${_isGold ? "Digital gold" : "Fello flo"}",
                          style: TextStyles.sourceSans.body4.colour(
                            Color(0xff919193),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildInfoSection() {
    final info = _isGold ? _goldInfo : _lbInfo;
    List<Widget> children = [];
    for (var e in info.entries) {
      children.add(
        Column(
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
      padding: EdgeInsets.symmetric(horizontal: SizeConfig.screenWidth! * 0.12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                RichText(
                  text: TextSpan(
                    text: "Gold ",
                    style: TextStyles.rajdhaniSB.title5.colour(Colors.white),
                    children: [
                      TextSpan(
                        text: "vs ",
                        style: TextStyles.rajdhaniSB.title5.colour(
                          Color(0xffF6CC60),
                        ),
                      ),
                      TextSpan(
                        text: "other investments",
                        style:
                            TextStyles.rajdhaniSB.title5.colour(Colors.white),
                      )
                    ],
                  ),
                ),
                Text(
                  "Swipe to compare",
                  style: TextStyles.sourceSans.body4.colour(
                    Color(0xffA0A0A0),
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
                        EdgeInsets.symmetric(horizontal: SizeConfig.padding32),
                    padding: EdgeInsets.symmetric(
                        horizontal: SizeConfig.padding34,
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
                          width: SizeConfig.padding24,
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
                              height: SizeConfig.padding10,
                            ),
                            Text(
                              isGold ? "100%" : "10%",
                              style: TextStyles.rajdhaniSB.title1,
                            ),
                            SizedBox(
                              height: SizeConfig.padding10,
                            ),
                            Text(
                              isGold ? "Risk Free" : "Assured Returns",
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
                              width: SizeConfig.padding24,
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
                                  height: SizeConfig.padding10,
                                ),
                                Text(
                                  isGold ? "100%" : "10%",
                                  style: TextStyles.rajdhaniSB.title1,
                                ),
                                SizedBox(
                                  height: SizeConfig.padding10,
                                ),
                                Text(
                                  isGold ? "Risk Free" : "Assured Returns",
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
                              width: SizeConfig.padding24,
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
                                  height: SizeConfig.padding10,
                                ),
                                Text(
                                  isGold ? "100%" : "10%",
                                  style: TextStyles.rajdhaniSB.title1,
                                ),
                                SizedBox(
                                  height: SizeConfig.padding10,
                                ),
                                Text(
                                  isGold ? "Risk Free" : "Assured Returns",
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

  final Map<String, Widget> goldPros = {
    Assets.arrowIcon: RichText(
      text: TextSpan(
          text: "Steady returns ",
          style: TextStyles.sourceSans.body3.colour(Colors.white),
          children: [
            TextSpan(
              text: "on the investment",
              style: TextStyles.sourceSans.body3.colour(Color(0xffA7A7A8)),
            )
          ]),
    ),
    Assets.timer: RichText(
      text: TextSpan(
          text: "Best for ",
          style: TextStyles.sourceSans.body3.colour(Color(0xffA7A7A8)),
          children: [
            TextSpan(
                text: "Long term ",
                style: TextStyles.sourceSans.body3.colour(Colors.white)),
            TextSpan(text: "savings")
          ]),
    ),
    Assets.shield: RichText(
      text: TextSpan(
        text: "No risks ",
        style: TextStyles.sourceSans.body3.colour(Colors.white),
        children: [
          TextSpan(
              text: "involved",
              style: TextStyles.sourceSans.body3.colour(Color(0xffA7A7A8)))
        ],
      ),
    ),
  };
  final Map<String, Widget> felloPros = {
    Assets.arrowIcon: RichText(
      text: TextSpan(
          text: "Higher returns ",
          style: TextStyles.sourceSans.body3.colour(Colors.white),
          children: [
            TextSpan(
              text: "than other assets",
              style: TextStyles.sourceSans.body3.colour(Color(0xffA7A7A8)),
            )
          ]),
    ),
    Assets.timer: RichText(
      text: TextSpan(
          text: "Best for ",
          style: TextStyles.sourceSans.body3.colour(Color(0xffA7A7A8)),
          children: [
            TextSpan(
                text: "Quick turnarounds",
                style: TextStyles.sourceSans.body3.colour(Colors.white)),
          ]),
    ),
    Assets.shield: RichText(
      text: TextSpan(
        text: "No risks ",
        style: TextStyles.sourceSans.body3.colour(Colors.white),
        children: [
          TextSpan(
              text: "involved",
              style: TextStyles.sourceSans.body3.colour(Color(0xffA7A7A8)))
        ],
      ),
    ),
  };
  final List<String> svgs = [Assets.arrowIcon, Assets.timer, Assets.shield];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: SizeConfig.padding32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Why ${isDigitalGold ? "Digital Gold" : "Fello Flo"}?",
            style: TextStyles.rajdhaniSB.title5,
          ),
          SizedBox(
            height: SizeConfig.padding26,
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
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: SizeConfig.padding16,
                width: SizeConfig.padding16,
                child: SvgPicture.asset(
                  key,
                  fit: BoxFit.fill,
                ),
              ),
              SizedBox(
                width: SizeConfig.padding24,
              ),
              value
            ],
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
  static String goldTitle = "56% of our users\nhave invested in\nDigital gold ";
  static String felloTitle = "200% profits earned\non Fello Flo\ninvestments";

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
              SvgPicture.asset(
                  isGold ? Assets.goldConveyor : Assets.floConveyor),
            ],
          )
        ],
      ),
    );
  }
}

class _CircularSlider extends StatefulWidget {
  const _CircularSlider({Key? key}) : super(key: key);

  @override
  State<_CircularSlider> createState() => _CircularSliderState();
}

class _CircularSliderState extends State<_CircularSlider> {
  double _volumeValue = 50;

  void onVolumeChanged(double value) {
    setState(() {
      _volumeValue = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SfRadialGauge(axes: <RadialAxis>[
      RadialAxis(
        minimum: 0,
        maximum: 100,
        startAngle: 270,
        endAngle: 270,
        showLabels: false,
        showTicks: false,
        radiusFactor: 0.6,
        axisLineStyle: AxisLineStyle(
            cornerStyle: CornerStyle.bothFlat,
            color: Color(0xffD9D9D9).withOpacity(0.5),
            thickness: 2),
        pointers: <GaugePointer>[
          RangePointer(
            value: _volumeValue,
            cornerStyle: CornerStyle.bothCurve,
            width: 12,
            sizeUnit: GaugeSizeUnit.logicalPixel,
            color: Color(0xFFAD1457),
          ),
          MarkerPointer(
              value: _volumeValue,
              enableDragging: true,
              onValueChanged: onVolumeChanged,
              markerHeight: 20,
              markerWidth: 20,
              markerType: MarkerType.circle,
              color: Color(0xFFF8BBD0),
              borderWidth: 0,
              borderColor: Colors.white54)
        ],
      )
    ]);
  }
}
