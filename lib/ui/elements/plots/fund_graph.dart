import 'package:felloapp/core/enums/connectivity_status.dart';
import 'package:felloapp/core/ops/augmont_ops.dart';
import 'package:felloapp/core/ops/db_ops.dart';
import 'package:felloapp/ui/elements/network_bar.dart';
import 'package:felloapp/util/fail_types.dart';
import 'package:felloapp/util/palette.dart';
import 'package:felloapp/util/size_config.dart';
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
    FelloColorPalette.augmontFundPalette().primaryColor,
    Colors.white,
  ];

  List<GoldGraphPoint> graphPoints = [];
  List<FlSpot> dataItems = [];
  AugmontModel augmontProvider;
  DBModel dbProvider;
  BaseUtil baseProvider;
  String _dataPointsState = "loading";
  int _selectedFrequency = 3;

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
        margin: EdgeInsets.symmetric(
          horizontal: SizeConfig.screenHeight * 0.02,
        ),
        height: SizeConfig.screenHeight * 0.2,
        width: double.infinity,
        child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: connectivityStatus == ConnectivityStatus.Offline
                ? NetworkBar(
                    textColor: Colors.black,
                  )
                : SpinKitThreeBounce(
                    color: FelloColorPalette.augmontFundPalette().primaryColor,
                    size: 30.0,
                  )),
      );
    }
    if (_dataPointsState == "done") {
      return Column(
        children: [
          Container(
            height: SizeConfig.screenHeight * 0.2,
            child: LineChart(
              LineChartData(
                // minX: minX,
                // maxX: maxX,
                minY: 0,
                maxY: 6000,
                lineTouchData: LineTouchData(
                    enabled: true,
                    touchTooltipData: LineTouchTooltipData(
                      tooltipRoundedRadius: 8,
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
                                color: FelloColorPalette.augmontFundPalette()
                                    .primaryColor,
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
                    show: false,
                    bottomTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 35,
                      getTextStyles: (value) => GoogleFonts.montserrat(
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                        fontSize: SizeConfig.smallTextSize,
                      ),
                      //  getTitles: (value) => getvalue(value),
                    ),
                    leftTitles: SideTitles(margin: 0)),
                gridData: FlGridData(
                  show: true,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: const Color(0xff37434d),
                      strokeWidth: 0,
                    );
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
                            color: FelloColorPalette.augmontFundPalette()
                                .primaryColor,
                            strokeColor: Colors.red,
                            strokeWidth: 2,
                          );
                        },
                        checkToShowDot: (spot, data) {
                          return true;
                        }),
                    belowBarData: BarAreaData(
                      show: true,
                      gradientColorStops: [0.6, 1],
                      gradientFrom: Offset(0.5, 0),
                      gradientTo: Offset(0.5, 1),
                      colors: gradientColors
                          .map((color) => color.withOpacity(0.2))
                          .toList(),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(
                horizontal: SizeConfig.blockSizeHorizontal * 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: List.generate(
                4,
                (index) => GestureDetector(
                  onTap: () => getSplitedChartData(index),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: index == _selectedFrequency ? 0 : 1,
                        color: Colors.black45.withOpacity(0.1),
                      ),
                      borderRadius: BorderRadius.circular(6),
                      color: index == _selectedFrequency
                          ? FelloColorPalette.augmontFundPalette().primaryColor
                          : Colors.transparent,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        segmentList[index],
                        style: TextStyle(
                          fontWeight: index == _selectedFrequency
                              ? FontWeight.w700
                              : FontWeight.w300,
                          fontSize: SizeConfig.mediumTextSize,
                          color: index == _selectedFrequency
                              ? Colors.white
                              : Colors.black45,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      );
    }
  }

  List<String> segmentList = ['3M', '6M', '1Y', '3Y'];
  getSplitedChartData(int index) {
    switch (index) {
      case 0:
        setState(() {
          _selectedFrequency = 0;
          filteredDataItems = dataItems.sublist(dataItems.length - 9);
          maxX = 95;
          minX = 87;
        });
        break;
      case 1:
        setState(() {
          _selectedFrequency = 1;
          filteredDataItems = dataItems.sublist(dataItems.length - 18);
          maxX = 95;
          minX = 78;
        });
        break;
      case 2:
        setState(() {
          _selectedFrequency = 2;
          filteredDataItems = dataItems.sublist(dataItems.length - 36);
          maxX = 95;
          minX = 60;
        });
        break;
      case 3:
        setState(() {
          _selectedFrequency = 3;
          filteredDataItems = dataItems;
          maxX = 97;
          minX = 0;
        });
        break;
    }
  }

  getDate(LineBarSpot lbs) {
    DateTime time =
        graphPoints.firstWhere((element) => element.rate == lbs.y).timestamp;
    return DateFormat('dd MMM, yyyy').format(time);
  }

  // getvalue(double value) {
  //   switch (_selectedFrequency) {
  //     case 3:
  //       if (value % 2 == 0)
  //         return value.toString();
  //       else
  //         return '';
  //       break;
  //     case 4:
  //       if (value % 3 == 0)
  //         return value.toString();
  //       else
  //         return '';
  //       break;
  //     default:
  //       return value.toString();
  //   }
  // }
}
