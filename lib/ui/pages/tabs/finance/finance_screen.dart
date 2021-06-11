import 'dart:async';

import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/base_analytics.dart';
import 'package:felloapp/core/ops/augmont_ops.dart';
import 'package:felloapp/core/ops/db_ops.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/ui/dialogs/more_info_dialog.dart';
import 'package:felloapp/ui/pages/tabs/finance/gold_details_page.dart';
import 'package:felloapp/ui/pages/tabs/finance/mf_details_page.dart';
import 'package:felloapp/util/constants.dart';
import 'package:felloapp/util/logger.dart';
import 'package:felloapp/util/size_config.dart';
import 'package:felloapp/util/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:provider/provider.dart';
import 'package:showcaseview/showcase_widget.dart';

class FinancePage extends StatefulWidget {
  @override
  _FinancePageState createState() => _FinancePageState();
}

class _FinancePageState extends State<FinancePage> {
  Log log = new Log('FinanceScreen');
  final bool hasFund = true;
  BaseUtil baseProvider;
  AugmontModel augmontProvider;
  DBModel dbProvider;
  AppState appState;
  Map<String, double> chartData;
  GlobalKey _showcaseHeader = GlobalKey();
  GlobalKey _showcaseFooter = GlobalKey();

  Map<String, double> getChartMap() {
    return {
      "ICICI Balance": baseProvider.userFundWallet.iciciBalance,
      "Gold Balance": baseProvider.userFundWallet.augGoldBalance,
      "Prize Balance": baseProvider.userFundWallet.prizeBalance,
      "Locked Balance": baseProvider.userFundWallet.lockedPrizeBalance
    };
  }

  Future<void> _onFundsRefresh() async {
    //TODO ADD LOADER
    return dbProvider.getUserFundWallet(baseProvider.myUser.uid).then((aValue) {
      if (aValue != null) {
        baseProvider.userFundWallet = aValue;
        if (baseProvider.userFundWallet.augGoldQuantity > 0)
          _updateAugmontBalance(); //setstate call in method
        else
          setState(() {});
      }
    });
  }

  Future<void> _updateAugmontBalance() async {
    if (augmontProvider == null ||
        (baseProvider.userFundWallet.augGoldQuantity == 0 &&
            baseProvider.userFundWallet.augGoldBalance == 0)) return;
    augmontProvider.getRates().then((currRates) {
      if (currRates == null ||
          currRates.goldSellPrice == null ||
          baseProvider.userFundWallet.augGoldQuantity == 0) return;

      baseProvider.augmontGoldRates = currRates;
      double gSellRate = baseProvider.augmontGoldRates.goldSellPrice;
      baseProvider.userFundWallet.augGoldBalance = BaseUtil.digitPrecision(
          baseProvider.userFundWallet.augGoldQuantity * gSellRate);
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
    dbProvider = Provider.of<DBModel>(context, listen: false);
    augmontProvider = Provider.of<AugmontModel>(context, listen: false);
    appState = Provider.of<AppState>(context, listen: false);
    if (!baseProvider.isAugmontRealTimeBalanceFetched) {
      _updateAugmontBalance();
      baseProvider.isAugmontRealTimeBalanceFetched = true;
    }
    if (baseProvider.show_finance_tutorial) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ShowCaseWidget.of(context)
            .startShowCase([_showcaseFooter, _showcaseHeader]);
      });
    }
    chartData = getChartMap();
    return RefreshIndicator(
      onRefresh: () async {
        await _onFundsRefresh();
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
                    BaseUtil.buildShowcaseWrapper(
                      _showcaseHeader,
                      'Your savings and investments will show up here. The balances are based on live market rates.',
                      Container(
                        child:
                            baseProvider.userFundWallet.getEstTotalWealth() > 0
                                ? FundChartView(
                                    dataMap: chartData,
                                    totalBal: baseProvider.userFundWallet
                                        .getEstTotalWealth(),
                                    goldMoreInfo: goldMoreInfoStr)
                                : ZeroBalView(),
                      ),
                    ),
                    // Container(
                    //   child:
                    //   baseProvider.userFundWallet.getEstTotalWealth() > 0
                    //       ? FundChartView(
                    //       dataMap: chartData,
                    //       totalBal: baseProvider.userFundWallet
                    //           .getEstTotalWealth(),
                    //       goldMoreInfo: goldMoreInfoStr)
                    //       : ZeroBalView(),
                    // ),
                    // Row(
                    Divider(
                      color: Colors.black38,
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
                  // BaseUtil.buildShowcaseWrapper(
                  //   _showcaseFooter,
                  //   'This is a test',
                  //
                  // ),
                  SliverGrid(
                    gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 275,
                      childAspectRatio: 2 / 3,
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 20,
                    ),
                    delegate: SliverChildListDelegate(
                      [
                        BaseUtil.buildShowcaseWrapper(
                          _showcaseFooter,
                          'Choose any of the assets to deposit in. Fello lists strong proven assets with great historical returns.',
                          FundWidget(
                            fund: fundList[1],
                            isAvailable: (AugmontDetailsPage.checkAugmontStatus(
                                    baseProvider.myUser) !=
                                AugmontDetailsPage.STATUS_UNAVAILABLE),
                            // onPressed: () async {
                            //   bool res = await Navigator.push(
                            //     context,
                            //     MaterialPageRoute(
                            //       builder: (ctx) => AugmontDetailsPage(),
                            //     ),
                            //   );
                            //   if (res) {
                            //     setState(() {});
                            //   }
                            // },
                            onPressed: () => appState.currentAction =
                                PageAction(
                                    state: PageState.addPage,
                                    page: AugDetailsPageConfig),
                          ),
                        ),
                        FundWidget(
                            fund: fundList[0],
                            isAvailable:
                                (MFDetailsPage.checkICICIDespositStatus(
                                        baseProvider.myUser) !=
                                    MFDetailsPage.STATUS_UNAVAILABLE),
                            // onPressed: () {
                            //   Navigator.push(
                            //     context,
                            //     MaterialPageRoute(
                            //       builder: (ctx) => MFDetailsPage(),
                            //     ),
                            //   );
                            //   //baseProvider.showNegativeAlert('Locked', 'Feature currently locked', context);
                            //   setState(() {});
                            // }),
                            onPressed: () => appState.currentAction =
                                PageAction(
                                    state: PageState.addPage,
                                    page: MfDetailsPageConfig)),
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

  String get goldMoreInfoStr {
    String _s =
        'The balance shown here is based on the current live selling rate of gold';
    String _t = '.';
    if (baseProvider.userFundWallet.augGoldQuantity > 0 &&
        baseProvider.augmontGoldRates != null) {
      _t =
          ', which is ₹${baseProvider.augmontGoldRates.goldSellPrice} per gram';
    }
    return '$_s$_t';
  }
}

class FundChartView extends StatelessWidget {
  final Map<String, double> dataMap;
  final double totalBal;
  final String
      goldMoreInfo; //should be altered to a more info array for all assets

  FundChartView({this.dataMap, this.totalBal, this.goldMoreInfo});

  final List<Color> colorListLight = [
    UiConstants.primaryColor,
    Color(0xffF18805),
    Color(0xff03256C),
  ];

  final List<Color> colorList = [
    UiConstants.primaryColor,
    Color(0xffF18805),
    Color(0xff2e89ba),
    Colors.blueGrey,
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
                amount: "₹ ${dataMap[title[0]].toStringAsFixed(2)}",
                color: colorList[0],
              ),
              Legend(
                title: title[1],
                amount: "₹ ${dataMap[title[1]].toStringAsFixed(2)}",
                color: colorList[1],
                onClick: () {
                  HapticFeedback.vibrate();
                  showDialog(
                      context: context,
                      builder: (BuildContext context) => MoreInfoDialog(
                            text: goldMoreInfo,
                            title: 'Your Gold Balance',
                          ));
                },
              ),
              Legend(
                title: title[2],
                amount: "₹ ${dataMap[title[2]].toStringAsFixed(2)}",
                color: colorList[2],
              ),
              (dataMap[title[3]] > 0)
                  ? Legend(
                      title: title[3],
                      amount: "₹ ${dataMap[title[3]].toStringAsFixed(2)}",
                      color: colorList[3],
                      onClick: () {
                        HapticFeedback.vibrate();
                        showDialog(
                            context: context,
                            builder: (BuildContext context) => MoreInfoDialog(
                                  text:
                                      'Referral rewards could be locked due to either of the reasons: \n\n• You were referred by your friend but you haven\'t saved at least ₹${Constants.UNLOCK_REFERRAL_AMT} yet. \n\n• You referred your friends but they haven\'t saved at least ₹${Constants.UNLOCK_REFERRAL_AMT} yet.',
                                  title: 'Locked Balance',
                                ));
                      },
                    )
                  : Container(),
            ],
          ),
        ),
        SizedBox(
          width: SizeConfig.blockSizeHorizontal * 8,
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
              "Your savings and prize balance is currently zero.",
              textAlign: TextAlign.center,
              style: GoogleFonts.montserrat(
                fontWeight: FontWeight.w400,
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
  final Function onClick;

  Legend({this.amount, this.title, this.color, this.onClick});

  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.bottomCenter,
        padding: const EdgeInsets.only(top: 8, bottom: 8),
        child: GestureDetector(
          onTap: onClick,
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
                        fontSize: SizeConfig.smallTextSize * 1.2,
                        color: UiConstants.textColor,
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ));
  }
}

class FundWidget extends StatelessWidget {
  final Fund fund;
  final Function onPressed;
  final bool isAvailable;

  FundWidget({this.fund, this.onPressed, this.isAvailable = true});

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return GestureDetector(
        onTap: onPressed,
        child: Opacity(
          opacity: (isAvailable) ? 1 : 0.75,
          child: Container(
            padding: EdgeInsets.all(
              height * 0.02,
            ),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(fund.assetName),
              ),
            ),
            child: Stack(
              // mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: Text(
                    fund.title,
                    style: GoogleFonts.montserrat(
                      color: Colors.white,
                      fontSize: height * 0.024,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                (!isAvailable)
                    ? Align(
                        alignment: Alignment.bottomCenter,
                        child: Padding(
                          padding: EdgeInsets.only(bottom: height * 0.022),
                          child: Text(
                            'Coming Soon',
                            style: GoogleFonts.montserrat(
                              color: Colors.white,
                              fontSize: height * 0.020,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ))
                    : Container()
              ],
            ),
          ),
        ));
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
