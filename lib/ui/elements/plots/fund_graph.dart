import 'package:felloapp/core/enums/connectivity_status_enum.dart';
import 'package:felloapp/core/ops/augmont_ops.dart';
import 'package:felloapp/core/ops/db_ops.dart';
import 'package:felloapp/ui/elements/network_bar.dart';
import 'package:felloapp/util/fail_types.dart';
import 'package:felloapp/util/styles/palette.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../base_util.dart';

class LineChartWidget extends StatefulWidget {
  @override
  _LineChartWidgetState createState() => _LineChartWidgetState();
}

class _LineChartWidgetState extends State<LineChartWidget> {
  Future<List<GoldGraphPoint>> _getDataPoints() async {
    List<GoldGraphPoint> _res;
    try {
      _res = await augmontProvider.getGoldRateChart(
          DateTime(2018, 1, 1), DateTime.now());
      _res.sort((GoldGraphPoint a, GoldGraphPoint b) {
        return a.timestamp.compareTo(b.timestamp);
      });
      print(_res.length);
    } catch (err) {
      if (baseProvider.myUser.uid != null) {
        Map<String, dynamic> errorDetails = {
          'error_msg': 'Fetching gold rates for api for line chart failed',
        };
        dbProvider.logFailure(baseProvider.myUser.uid,
            FailType.GoldRateFetchFailed, errorDetails);
      }
      print(err);
    }
    return _res;
  }

  final List<Color> gradientColors = [
    UiConstants.primaryColor,
    Colors.white,
  ];

  List<GoldGraphPoint> graphPoints = [];
  List<FlSpot> dataItems = [];
  AugmontModel augmontProvider;
  DBModel dbProvider;
  BaseUtil baseProvider;
  String _dataPointsState = "loading";
  int _selectedFrequency = 3;
  Map<int, DateTime> xAxisdata = {};
  Map<int, double> yAxisData = {};

  List<FlSpot> filteredDataItems = [];
  double maxX = 97;
  double minX = 0;

  @override
  Widget build(BuildContext context) {
    augmontProvider = Provider.of<AugmontModel>(context, listen: false);
    ConnectivityStatus connectivityStatus =
        Provider.of<ConnectivityStatus>(context, listen: false);
    if (_dataPointsState == "loading") {
      _getDataPoints().then((value) {
        if (value != null) {
          _dataPointsState = "done";
          graphPoints = value;
          for (int i = 0; i < value.length; i++) {
            dataItems.add(FlSpot(i.toDouble(), value[i].rate));
            xAxisdata[i + 1] = graphPoints[i].timestamp;
            yAxisData[i + 1] = graphPoints[i].rate;
          }

          filteredDataItems = dataItems;
        } else {
          _dataPointsState = "error";
        }

        setState(() {});
      });
    }
    if (_dataPointsState == "loading") {
      return Container(
        height: SizeConfig.screenHeight * 0.3,
        width: double.infinity,
        child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: connectivityStatus == ConnectivityStatus.Offline
                ? NetworkBar(
                    textColor: Colors.black,
                  )
                : SpinKitThreeBounce(
                    color: UiConstants.primaryColor,
                    size: 30.0,
                  )),
      );
    }
    if (_dataPointsState == "done") {
      return Column(
        children: [
          Container(
            margin: EdgeInsets.all(SizeConfig.pageHorizontalMargins),
            height: SizeConfig.screenHeight * 0.4,
            child: LineChart(
              LineChartData(
                minX: 0,
                maxX: graphPoints.length.toDouble(),
                minY: 3000,
                maxY: 6000,
                lineTouchData: LineTouchData(
                    enabled: true,
                    handleBuiltInTouches: true,
                    touchTooltipData: LineTouchTooltipData(
                      tooltipRoundedRadius: 8,
                      showOnTopOfTheChartBoxArea: true,
                      fitInsideHorizontally: true,
                      fitInsideVertically: true,
                      tooltipPadding:
                          EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      getTooltipItems: (lbs) {
                        String date = getDate(lbs[0]);
                        return lbs.map((LineBarSpot touchedSpot) {
                          return LineTooltipItem(
                              '•  ',
                              GoogleFonts.montserrat(
                                color: UiConstants.primaryColor,
                                fontSize: SizeConfig.mediumTextSize,
                                fontWeight: FontWeight.w900,
                              ),
                              textAlign: TextAlign.left,
                              children: [
                                TextSpan(
                                  text: '₹ ${touchedSpot.y.toStringAsFixed(2)}',
                                  style: GoogleFonts.montserrat(
                                    color: Colors.black,
                                    height: 2,
                                    fontSize: SizeConfig.mediumTextSize,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                TextSpan(
                                  text: "\n$date",
                                  style: GoogleFonts.montserrat(
                                    color: Colors.grey,
                                    height: 1.5,
                                    fontSize: SizeConfig.smallTextSize,
                                  ),
                                ),
                              ]);
                        }).toList();
                      },
                      maxContentWidth: 120,
                    )),
                titlesData: FlTitlesData(
                    show: true,
                    bottomTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 35,
                      getTextStyles: (ctx, value) => GoogleFonts.montserrat(
                        color: Colors.grey,
                        fontSize: SizeConfig.smallTextSize,
                      ),
                      getTitles: (value) {
                        DateTime date = xAxisdata[value.toInt() + 1];
                        return value % 15 == 0
                            ? DateFormat('dd MMM\nyyyy').format(date)
                            : "";
                      },
                    ),
                    leftTitles: SideTitles(
                      showTitles: true,
                      reservedSize: SizeConfig.padding32,
                      getTextStyles: (ctx, value) =>
                          TextStyles.body4.colour(Colors.grey),
                      getTitles: (value) {
                        return (value > 0 && value % 1000 == 0)
                            ? "₹ ${value.toString().substring(0, 1)}K"
                            : "";
                      },
                    )),
                gridData: FlGridData(
                  show: true,
                  horizontalInterval: 1000,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                        color: UiConstants.primaryColor,
                        strokeWidth: 0.3,
                        dashArray: [10, 10]);
                  },
                ),
                borderData: FlBorderData(
                  show: false,
                ),
                lineBarsData: [
                  LineChartBarData(
                    spots: filteredDataItems,
                    isCurved: true,
                    isStrokeCapRound: false,
                    colors: gradientColors,
                    gradientFrom: Offset(SizeConfig.screenWidth * 0.5, 0),
                    gradientTo: Offset(
                        SizeConfig.screenWidth * 0.5, SizeConfig.screenHeight),
                    barWidth: 2,
                    dotData: FlDotData(
                        show: false,
                        getDotPainter: (spot, d, data, i) {
                          return FlDotCirclePainter(
                            radius: 1,
                            color: UiConstants.primaryColor,
                            strokeColor: Colors.red,
                            strokeWidth: 2,
                          );
                        },
                        checkToShowDot: (spot, data) {
                          return true;
                        }),
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    }
  }

  getDate(LineBarSpot lbs) {
    DateTime time =
        graphPoints.firstWhere((element) => element.rate == lbs.y).timestamp;
    return DateFormat('dd MMM, yyyy').format(time);
  }

  getvalue(double value) {
    switch (_selectedFrequency) {
      case 3:
        if (value % 2 == 0)
          return value.toString();
        else
          return '';
        break;
      case 4:
        if (value % 3 == 0)
          return value.toString();
        else
          return '';
        break;
      default:
        return value.toString();
    }
  }
}

class LineTitles {
  static getTitleData() => FlTitlesData(
        show: true,
        bottomTitles: SideTitles(
          showTitles: true,
          reservedSize: 35,
          getTextStyles: (ctx, value) => const TextStyle(
            color: Color(0xff68737d),
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
          getTitles: (value) {
            switch (value.toInt()) {
              case 2:
                return 'MAR';
              case 5:
                return 'JUN';
              case 8:
                return 'SEP';
            }
            return '';
          },
          margin: 8,
        ),
        leftTitles: SideTitles(
          showTitles: true,
          getTextStyles: (ctx, value) => const TextStyle(
            color: Color(0xff67727d),
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
          getTitles: (value) {
            switch (value.toInt()) {
              case 1:
                return '10k';
              case 3:
                return '30k';
              case 5:
                return '50k';
            }
            return '';
          },
          reservedSize: 35,
          margin: 12,
        ),
      );
}
