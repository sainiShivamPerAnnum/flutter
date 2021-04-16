import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/base_analytics.dart';
import 'package:felloapp/core/ops/augmont_ops.dart';
import 'package:felloapp/ui/pages/tabs/finance/gold_details_page.dart';
import 'package:felloapp/ui/pages/tabs/finance/mf_details_page.dart';
import 'package:felloapp/util/logger.dart';
import 'package:felloapp/util/size_config.dart';
import 'package:felloapp/util/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:provider/provider.dart';

class FinancePage extends StatefulWidget {
  @override
  _FinancePageState createState() => _FinancePageState();
}

class _FinancePageState extends State<FinancePage> {
  Log log = new Log('FinanceScreen');
  final bool hasFund = true;
  BaseUtil baseProvider;
  AugmontModel augmontProvider;
  Map<String, double> chartData;

  Map<String, double> getChartMap() {
    return {
      "ICICI Balance": baseProvider.myUserWallet.iciciBalance,
      "Augmont Balance": baseProvider.myUserWallet.augGoldBalance,
      "Prize Balance": baseProvider.myUserWallet.prizeBalance,
    };
  }

  refresh() {
    setState(() {});
  }

  _updateAugmontBalance() async {
    if (augmontProvider == null ||
        (baseProvider.myUserWallet.augGoldQuantity == 0 &&
            baseProvider.myUserWallet.augGoldBalance == 0)) return;
    augmontProvider.getRates().then((currRates) {
      if (currRates == null || currRates.goldSellPrice == null) return;

      // double gBuyRate = currRates.goldBuyPrice;
      double gSellRate = currRates.goldSellPrice;
      if (baseProvider.myUserWallet.augGoldQuantity == 0) return;
      baseProvider.myUserWallet.augGoldBalance =
          (baseProvider.myUserWallet.augGoldQuantity * gSellRate).roundToDouble();
      setState(() {}); //might cause ui error if screen no longer active
    }).catchError((err) {
      print('$err');
    });
  }

  @override
  void initState() {
    super.initState();
    BaseAnalytics.analytics
        .setCurrentScreen(screenName: BaseAnalytics.PAGE_FINANCE);
  }

  @override
  Widget build(BuildContext context) {
    baseProvider = Provider.of<BaseUtil>(context, listen: false);
    augmontProvider = Provider.of<AugmontModel>(context, listen: false);
    if (!baseProvider.isAugmontRealTimeBalanceFetched) {
      _updateAugmontBalance();
      baseProvider.isAugmontRealTimeBalanceFetched = true;
    }
    chartData = getChartMap();
    return RefreshIndicator(
      onRefresh: () async {
        setState(() {});
      },
      child: Container(
        height: SizeConfig.screenHeight,
        decoration: BoxDecoration(
          color: UiConstants.backgroundColor,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(50),
            bottomRight: Radius.circular(50),
          ),
        ),
        child: SafeArea(
          child: ClipRRect(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(50),
              bottomRight: Radius.circular(50),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: SizeConfig.screenHeight * 0.016),
              child: CustomScrollView(
                slivers: [
                  SliverList(
                      delegate: SliverChildListDelegate([
                    Container(
                      height: AppBar().preferredSize.height * 0.7,
                    ),
                    Container(
                      child: baseProvider.estTotalWealth > 0
                          ? FundChartView(
                              dataMap: chartData,
                              totalBal: baseProvider.estTotalWealth
                                  .toDouble(),
                            )
                          : ZeroBalView(),
                    ),
                    // Row(
                    Divider(
                      color: UiConstants.textColor,
                    ),
                    Text(
                      "Available Funds",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w500,
                        fontSize: 24,
                        color: UiConstants.textColor,
                      ),
                    ),
                  ])),
                  SliverGrid(
                    gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 275,
                      childAspectRatio: 2 / 3,
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 20,
                    ),
                    delegate: SliverChildListDelegate(
                      [
                        FundWidget(
                            fund: fundList[0],
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (ctx) => MFDetailsPage(),
                                ),
                              );
                              //baseProvider.showNegativeAlert('Locked', 'Feature currently locked', context);

                              setState(() {});
                            }),
                        FundWidget(
                          fund: fundList[1],
                          onPressed: () async {
                            bool res = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (ctx) => GoldDetailsPage(),
                              ),
                            );
                            if (res) {
                              setState(() {});
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class FundChartView extends StatelessWidget {
  final Map<String, double> dataMap;
  final double totalBal;

  FundChartView({this.dataMap, this.totalBal});

  final List<Color> colorListLight = [
    UiConstants.primaryColor,
    Color(0xffF18805),
    Color(0xff03256C),
  ];

  final List<Color> colorList = [
    UiConstants.primaryColor,
    Color(0xffF18805),
    Color(0xff2e89ba),
  ];

  @override
  Widget build(BuildContext context) {
    List<String> title = dataMap.keys.toList();
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: SizeConfig.blockSizeHorizontal,
          ),
          height: MediaQuery.of(context).size.height * 0.3,
          alignment: Alignment.centerRight,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Legend(
                title: title[0],
                amount: "₹ ${dataMap[title[0]].toStringAsFixed(1)}",
                color: colorList[0],
              ),
              Legend(
                title: title[1],
                amount: "₹ ${dataMap[title[1]].toStringAsFixed(1)}",
                color: colorList[1],
              ),
              Legend(
                title: title[2],
                amount: "₹ ${dataMap[title[2]].toStringAsFixed(1)}",
                color: colorList[2],
              ),
            ],
          ),
        ),
        SizedBox(
          width: SizeConfig.blockSizeHorizontal * 10,
        ),
        Container(
          child: PieChart(
            dataMap: dataMap,
            animationDuration: Duration(milliseconds: 800),
            chartLegendSpacing: 40,
            chartRadius: MediaQuery.of(context).size.width / 2,
            colorList: colorList,
            initialAngleInDegree: 0,
            chartType: ChartType.ring,
            ringStrokeWidth: 5,
            centerText: "₹ $totalBal",
            legendOptions: LegendOptions(
              showLegendsInRow: false,
              legendPosition: LegendPosition.left,
              showLegends: false,
              legendShape: BoxShape.circle,
              legendTextStyle: GoogleFonts.montserrat(
                fontWeight: FontWeight.bold,
              ),
            ),
            chartValuesOptions: ChartValuesOptions(
              showChartValueBackground: true,
              showChartValues: false,
              chartValueBackgroundColor: UiConstants.backgroundColor,
              chartValueStyle: GoogleFonts.montserrat(
                fontSize: 40,
                color: UiConstants.textColor,
              ),
              showChartValuesInPercentage: false,
              showChartValuesOutside: false,
            ),
          ),
        ),
      ],
    );
  }
}

class ZeroBalView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: SizeConfig.screenHeight * 0.3,
      padding: EdgeInsets.all(SizeConfig.blockSizeHorizontal * 2),
      child: Column(
        children: [
          Expanded(
            child: Center(
              child: Image.asset(
                "images/zero-balance.png",
                fit: BoxFit.contain,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text(
              "Your savings and prizes will show up here!",
              style: GoogleFonts.montserrat(
                fontWeight: FontWeight.w500,
                fontSize: SizeConfig.mediumTextSize,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Legend extends StatelessWidget {
  final String title, amount;
  final Color color;

  Legend({this.amount, this.title, this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.bottomCenter,
      padding: const EdgeInsets.only(top: 8, bottom: 8),
      child: Row(
        children: [
          CircleAvatar(
            radius: MediaQuery.of(context).size.width * 0.016,
            backgroundColor: color,
          ),
          SizedBox(
            width: 8,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                amount,
                style: GoogleFonts.montserrat(
                  fontSize: SizeConfig.mediumTextSize,
                  fontWeight: FontWeight.w500,
                  color: UiConstants.textColor,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Text(
                  title,
                  style: GoogleFonts.montserrat(
                    fontSize: SizeConfig.smallTextSize,
                    color: UiConstants.textColor,
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}

class FundWidget extends StatelessWidget {
  final Fund fund;
  final Function onPressed;

  FundWidget({this.fund, this.onPressed});

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: EdgeInsets.all(
          height * 0.02,
        ),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(fund.assetName),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              fund.title,
              style: GoogleFonts.montserrat(
                color: Colors.white,
                fontSize: height * 0.024,
                fontWeight: FontWeight.w500,
              ),
            )
          ],
        ),
      ),
    );
  }
}

class Fund {
  final String assetName;
  final String title;
  final Function onPressed;

  Fund({this.assetName, this.onPressed, this.title});
}

List<Fund> fundList = [
  Fund(
    assetName: "images/integrated.png",
    title: "ICICI Prudential Fund ",
  ),
  Fund(
    assetName: "images/augmont.png",
    title: "Augmont Digital Gold",
  ),
];
