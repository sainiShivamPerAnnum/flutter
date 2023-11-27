import 'dart:math';

import 'package:felloapp/core/constants/analytics_events_constants.dart';
import 'package:felloapp/core/model/portfolio_model.dart';
import 'package:felloapp/core/repository/getters_repo.dart';
import 'package:felloapp/core/service/analytics/analytics_service.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/haptic.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class LineGradientChart extends StatefulWidget {
  const LineGradientChart({Key? key, this.isPro = false}) : super(key: key);

  final bool isPro;
  @override
  State<LineGradientChart> createState() => _LineGradientChartState();
}

class _LineGradientChartState extends State<LineGradientChart> {
  Map? responseData;
  List<String>? returnsList;
  List<ChartData>? ogChartData;

  List<ChartData>? _chartData;

  get chartData => _chartData;

  set chartData(value) {
    if (value != null) {
      _chartData = value;
      min = 2600;
      max = 2700;
      _chartData!.forEach((e) {
        min = e.price < min ? e.price : min;
        max = e.price > max ? e.price : max;
      });
      max += 100;
    }
    if (mounted) {
      setState(() {});
    }
  }

  double min = 2600, max = 2700;
  double lastItem = 25;

  int _selectedIndex = 0;

  get selectedIndex => _selectedIndex;

  set selectedIndex(value) {
    _selectedIndex = value;
    Future.delayed(const Duration(milliseconds: 100)).then((value) {
      chartData = ogChartData!.sublist(
          (ogChartData!.length - (12 * (selectedIndex + 1))).toInt(),
          ogChartData!.length);
    });

    Haptic.vibrate();
  }

  @override
  void initState() {
    getGoldGraphChartData();
    super.initState();
  }

  Future<void> getGoldGraphChartData() async {
    final res = await locator<GetterRepository>().getGoldRatesGraphItems();
    if (res.isSuccess()) {
      responseData = res.model;
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        returnsList = responseData!["returnsList"];
        if (returnsList!.length < 5) returnsList!.addAll(["123.3", "232.34"]);
        ogChartData = responseData!["chartDataList"];
        selectedIndex = 4;
      });
    }
  }

  void updateChartData2() {
    setState(() {
      if (selectedIndex == 4) {
        selectedIndex = 0;
      } else {
        selectedIndex++;
      }
    }); //refresh the widget to show updated data in UI
  }

  @override
  Widget build(BuildContext context) {
    return chartData != null
        ? Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Selector<UserService, Portfolio>(
                selector: (p0, p1) => p1.userPortfolio,
                builder: (context, portfolio, child) {
                  return Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: SizeConfig.pageHorizontalMargins),
                    child: Row(
                      mainAxisAlignment: widget.isPro
                          ? (portfolio.augmont.fd.principle > 0
                              ? MainAxisAlignment.spaceBetween
                              : MainAxisAlignment.center)
                          : MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: updateChartData2,
                          child: Column(
                            crossAxisAlignment: widget.isPro
                                ? (portfolio.augmont.fd.principle > 0
                                    ? CrossAxisAlignment.start
                                    : CrossAxisAlignment.center)
                                : CrossAxisAlignment.center,
                            children: [
                              Wrap(
                                children: [
                                  Text(
                                    "Historic Returns  ",
                                    style: GoogleFonts.rajdhani(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.w600,
                                      fontSize: SizeConfig.body3,
                                    ),
                                  ),
                                  SvgPicture.asset(
                                    Assets.graphArrows,
                                    height: SizeConfig.iconSize0,
                                    width: SizeConfig.iconSize0,
                                    color: Colors.grey,
                                  )
                                ],
                              ),
                              Wrap(
                                crossAxisAlignment: WrapCrossAlignment.end,
                                children: [
                                  Text(
                                    "${returnsList![selectedIndex]}% ",
                                    style: GoogleFonts.sourceSansPro(
                                        fontWeight: FontWeight.w700,
                                        fontSize: SizeConfig.title2,
                                        color: Colors.white),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        bottom: SizeConfig.padding6),
                                    child: Text(
                                      "(${chips[selectedIndex]})",
                                      style: GoogleFonts.sourceSansPro(
                                          fontSize: SizeConfig.body3,
                                          color: Colors.white),
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                        if (widget.isPro)
                          portfolio.augmont.fd.principle > 0
                              ? GestureDetector(
                                  onTap: updateChartData2,
                                  child: Column(
                                    crossAxisAlignment: widget.isPro
                                        ? CrossAxisAlignment.start
                                        : CrossAxisAlignment.center,
                                    children: [
                                      Wrap(
                                        children: [
                                          Text(
                                            "Your Expected Returns  ",
                                            style: GoogleFonts.rajdhani(
                                              color: Colors.grey,
                                              fontWeight: FontWeight.w600,
                                              fontSize: SizeConfig.body3,
                                            ),
                                          ),
                                          SvgPicture.asset(
                                            Assets.graphArrows,
                                            height: SizeConfig.iconSize0,
                                            width: SizeConfig.iconSize0,
                                            color: Colors.grey,
                                          )
                                        ],
                                      ),
                                      Wrap(
                                        crossAxisAlignment:
                                            WrapCrossAlignment.end,
                                        children: [
                                          Text(
                                            "₹${((portfolio.augmont.fd.principle * pow((1 + 0.155), selectedIndex + 1)).toInt())}",
                                            style: GoogleFonts.sourceSansPro(
                                                fontWeight: FontWeight.w700,
                                                fontSize: SizeConfig.title2,
                                                color: UiConstants
                                                    .kGoldProPrimary),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(
                                                bottom: SizeConfig.padding6),
                                            child: Text(
                                              "(15.5%)",
                                              style: GoogleFonts.sourceSansPro(
                                                  fontSize:
                                                      SizeConfig.title4 * 0.7,
                                                  color: UiConstants
                                                      .kGoldProPrimary),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                )
                              : const SizedBox()
                      ],
                    ),
                  );
                },
              ),
              AbsorbPointer(
                child: SizedBox(
                  height: SizeConfig.screenWidth! * 0.6,
                  child: SfCartesianChart(
                    margin: EdgeInsets.zero,
                    borderWidth: 0,
                    borderColor: Colors.transparent,
                    plotAreaBorderWidth: 0,
                    primaryXAxis: NumericAxis(
                      minimum: chartData!.first.day.toDouble(),
                      maximum: chartData!.last.day.toDouble(),
                      interval: 100,
                      isVisible: false,
                      borderWidth: 0,
                      borderColor: Colors.transparent,
                    ),
                    primaryYAxis: NumericAxis(
                      minimum: min,
                      maximum: max,
                      isVisible: false,
                      borderWidth: 0,
                      borderColor: Colors.transparent,
                    ),
                    series: <ChartSeries<ChartData, int>>[
                      SplineAreaSeries(
                        dataSource: chartData!,
                        xValueMapper: (ChartData data, _) => data.day,
                        yValueMapper: (ChartData data, _) => data.price,
                        splineType: SplineType.natural,
                        animationDuration: 0,
                        animationDelay: 0,
                        enableTooltip: true,
                        gradient: LinearGradient(
                            colors: widget.isPro
                                ? [
                                    UiConstants.KGoldProPrimaryDark,
                                    UiConstants.kBackgroundColor
                                        .withOpacity(0.02)
                                  ]
                                : [
                                    UiConstants.kGoldContainerColor,
                                    UiConstants.kBackgroundColor
                                        .withOpacity(0.02),
                                  ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter),
                      ),
                      SplineSeries(
                        color: widget.isPro
                            ? UiConstants.KGoldProPrimaryDark
                            : UiConstants.kSaveDigitalGoldCardBg,
                        width: 1,
                        enableTooltip: true,
                        animationDelay: 0,
                        animationDuration: 0,
                        dataSource: chartData!,
                        xValueMapper: (ChartData data, _) => data.day,
                        yValueMapper: (ChartData data, _) => data.price,
                        splineType: SplineType.natural,
                      )
                    ],
                  ),
                ),
              ),
              Transform.translate(
                offset: Offset(0, -SizeConfig.padding12),
                child: Container(
                  margin: EdgeInsets.symmetric(
                      horizontal: SizeConfig.pageHorizontalMargins),
                  child: Row(
                    children: List.generate(
                      chips.length,
                      (index) => Expanded(
                        child: GestureDetector(
                          onTap: () {
                            selectedIndex = index;
                            locator<AnalyticsService>().track(
                              eventName: AnalyticsEvents.yearTappedOnGraph,
                              properties: {
                                'location':
                                    widget.isPro ? "GOLD PRO" : "DIGITAL GOLD",
                                'year number tapped': chips[selectedIndex]
                              },
                            );
                          },
                          child: Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                border: Border.all(
                                  color: index == selectedIndex
                                      ? Colors.white24
                                      : Colors.transparent,
                                ),
                                borderRadius: BorderRadius.circular(100),
                                color: index == selectedIndex
                                    ? UiConstants.kBackgroundColor2
                                    : Colors.transparent),
                            padding: EdgeInsets.all(SizeConfig.padding10),
                            child: Text(
                              chips[index],
                              style: TextStyles.body2.colour(Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              )
            ],
          )
        : SizedBox(
            height: SizeConfig.screenWidth! * 0.84,
          );
  }

  List<String> chips = [
    "1 Year",
    "2 Year",
    "3 Year",
    "4 Year",
    "5 Year",
  ];
}

class ChartData {
  int day = 0;
  double price = 0.0;

  ChartData({
    required this.day,
    required this.price,
  });
}

// chartData = [
//   ChartData(day: 18, price: 6547),
//   ChartData(day: 19, price: 6562),
//   ChartData(day: 20, price: 6585),
//   ChartData(day: 21, price: 6345),
//   ChartData(day: 22, price: 6953),
//   ChartData(day: 23, price: 6467),
//   ChartData(day: 24, price: 6925),
//   ChartData(day: 25, price: 6638),
//   ChartData(day: 26, price: 6385),
//   ChartData(day: 27, price: 6836),
//   ChartData(day: 28, price: 6653),
//   ChartData(day: 29, price: 6958),
//   ChartData(day: 30, price: 6284),
//   ChartData(day: 31, price: 6594),
//   ChartData(day: 32, price: 6136),
//   ChartData(day: 33, price: 6956),
//   ChartData(day: 34, price: 6355),
//   ChartData(day: 35, price: 6764),
//   ChartData(day: 36, price: 6938),
//   ChartData(day: 37, price: 6630),
//   ChartData(day: 38, price: 7000),
//   ChartData(day: 39, price: 6374),
//   ChartData(day: 40, price: 6468),
//   ChartData(day: 41, price: 6938),
//   ChartData(day: 42, price: 6368),
//   ChartData(day: 43, price: 6732),
//   ChartData(day: 44, price: 6793),
//   ChartData(day: 45, price: 6544),
// ];
