import 'package:felloapp/util/haptic.dart';
import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class LineGradientChart extends StatefulWidget {
  const LineGradientChart({Key? key}) : super(key: key);

  @override
  State<LineGradientChart> createState() => _LineGradientChartState();
}

class _LineGradientChartState extends State<LineGradientChart> {
  List<ChartData>? chartData;
  double lastItem = 25;

  int _selectedIndex = 0;

  get selectedIndex => _selectedIndex;

  set selectedIndex(value) {
    _selectedIndex = value;
    Haptic.vibrate();
    setState(() {});
  }

  @override
  void initState() {
    chartData = [
      ChartData(day: 18, price: 6547),
      ChartData(day: 19, price: 6562),
      ChartData(day: 20, price: 6585),
      ChartData(day: 21, price: 6345),
      ChartData(day: 22, price: 6953),
      ChartData(day: 23, price: 6467),
      ChartData(day: 24, price: 6925),
      ChartData(day: 25, price: 6638),
      ChartData(day: 26, price: 6385),
      ChartData(day: 27, price: 6836),
      ChartData(day: 28, price: 6653),
      ChartData(day: 29, price: 6958),
      ChartData(day: 30, price: 6284),
      ChartData(day: 31, price: 6594),
      ChartData(day: 32, price: 6136),
      ChartData(day: 33, price: 6956),
      ChartData(day: 34, price: 6355),
      ChartData(day: 35, price: 6764),
      ChartData(day: 36, price: 6938),
      ChartData(day: 37, price: 6630),
      ChartData(day: 38, price: 7000),
      ChartData(day: 39, price: 6374),
      ChartData(day: 40, price: 6468),
      ChartData(day: 41, price: 6938),
      ChartData(day: 42, price: 6368),
      ChartData(day: 43, price: 6732),
      ChartData(day: 44, price: 6793),
      ChartData(day: 45, price: 6544),
    ];

    super.initState();
  }

  void updateChartData() {
    setState(() {
      chartData!.addAll([
        ChartData(day: 27, price: 6836),
        ChartData(day: 28, price: 6653),
        ChartData(day: 29, price: 6958),
        ChartData(day: 30, price: 6284),
        ChartData(day: 31, price: 6594),
        ChartData(day: 32, price: 6136),
        ChartData(day: 33, price: 6956),
        ChartData(day: 34, price: 6355),
        ChartData(day: 35, price: 6764),
        ChartData(day: 36, price: 6938),
        ChartData(day: 37, price: 6630),
        ChartData(day: 38, price: 7000),
        ChartData(day: 39, price: 6374),
        ChartData(day: 40, price: 6468),
        ChartData(day: 41, price: 6938),
        ChartData(day: 42, price: 6368),
        ChartData(day: 43, price: 6732),
        ChartData(day: 44, price: 6793),
        ChartData(day: 45, price: 6544),
      ]);
    }); //refresh the widget to show updated data in UI
  }

  void updateChartData2() {
    setState(() {
      lastItem += 5;
    }); //refresh the widget to show updated data in UI
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Wrap(
          children: [
            Text(
              "Historic Returns  ",
              style: GoogleFonts.rajdhani(
                color: Colors.grey,
                fontWeight: FontWeight.w600,
                fontSize: SizeConfig.body1,
              ),
            ),
            GestureDetector(
              onTap: updateChartData2,
              child: const Icon(
                Icons.thumbs_up_down,
                color: Colors.grey,
              ),
            )
          ],
        ),
        Wrap(
          crossAxisAlignment: WrapCrossAlignment.end,
          children: [
            Text(
              "11.5% ",
              style: GoogleFonts.sourceSansPro(
                  fontWeight: FontWeight.w700,
                  fontSize: SizeConfig.titleSize,
                  color: Colors.white),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: SizeConfig.body3 * 0.3),
              child: Text(
                "(1 year)",
                style: GoogleFonts.sourceSansPro(
                    fontSize: SizeConfig.title3 * 0.7, color: Colors.white),
              ),
            )
          ],
        ),
        SizedBox(
          height: SizeConfig.screenWidth! * 0.6,
          child: SfCartesianChart(
            margin: EdgeInsets.zero,
            borderWidth: 0,
            borderColor: UiConstants.kBackgroundColor,
            plotAreaBorderWidth: 0,
            primaryXAxis: NumericAxis(
              minimum: chartData!.first.day.toDouble(),
              maximum: lastItem,
              // maximum: chartData!.last.day.toDouble(),
              interval: 100,
              isVisible: false,
              borderWidth: 0,
              borderColor: Colors.transparent,
            ),
            primaryYAxis: NumericAxis(
              minimum: 6000,
              maximum: 7000,
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
                animationDuration: 4000,
                enableTooltip: true,
                gradient: LinearGradient(colors: [
                  UiConstants.kGoldContainerColor,
                  UiConstants.kBackgroundColor.withOpacity(0.02),
                ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
              ),
              SplineSeries(
                color: UiConstants.kSaveDigitalGoldCardBg,
                width: 1,
                animationDuration: 4000,
                enableTooltip: true,

                // markerSettings: const MarkerSettings(
                //     isVisible: true,
                //     color: ChartStyle.spline_color,
                //     width: 4,
                //     shape: DataMarkerType.circle,
                //     borderColor: ChartStyle.accent_color),
                dataSource: chartData!,
                xValueMapper: (ChartData data, _) => data.day,
                yValueMapper: (ChartData data, _) => data.price,
                splineType: SplineType.natural,
              )
            ],
          ),
        ),
        Transform.translate(
          offset: Offset(0, -SizeConfig.padding24),
          child: Container(
            margin: EdgeInsets.symmetric(
                horizontal: SizeConfig.pageHorizontalMargins),
            child: Row(
              children: List.generate(
                chips.length,
                (index) => Expanded(
                  child: GestureDetector(
                    onTap: () => selectedIndex = index,
                    child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
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
