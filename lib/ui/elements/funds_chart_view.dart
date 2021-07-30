import 'dart:math';

import 'package:felloapp/core/base_remote_config.dart';
import 'package:felloapp/core/model/UserFundWallet.dart';
import 'package:felloapp/core/model/chartFundItem.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/ui/dialogs/Fold-Card/card.dart';
import 'package:felloapp/ui/dialogs/more_info_dialog.dart';
import 'package:felloapp/ui/pages/tabs/finance/finance_report.dart';
import 'package:felloapp/util/fundPalettes.dart';
import 'package:felloapp/util/size_config.dart';
import 'package:felloapp/util/ui_constants.dart';
import 'package:provider/provider.dart';
import 'pie_chart/pie.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math' as math;

class FundsChartView extends StatefulWidget {
  final UserFundWallet userFundWallet;
  final String
      goldMoreInfo; //should be altered to a more info array for all assets
  final VoidCallback doRefresh;

  FundsChartView({this.userFundWallet, this.goldMoreInfo, this.doRefresh});

  @override
  State createState() => _FundsChartViewState();
}

class _FundsChartViewState extends State<FundsChartView> {
  AppState appState;
  final List<Color> colorListLight = [
    UiConstants.primaryColor,
    augmontGoldPalette.primaryColor,
    Color(0xff03256C),
  ];

  final List<Color> colorList = [
    UiConstants.primaryColor,
    augmontGoldPalette.primaryColor,
    Color(0xff2e89ba),
    Colors.blueGrey,
  ];

  List<bool> getHighlightStatus() {
    List<bool> shouldHighlight = [];
    chartData.forEach((element) {
      shouldHighlight.add(element.isHighlighted);
    });
    return shouldHighlight;
  }

  Map<String, double> getChartMap() {
    Map<String, double> chartMap = {};
    chartData.forEach((element) {
      chartMap[element.fundName] = element.fundAmount;
    });
    return chartMap;
    // return {
    //   "ICICI Balance": widget.userFundWallet.iciciBalance,
    //   "Gold Balance": widget.userFundWallet.augGoldBalance,
    //   "Prize Balance": widget.userFundWallet.prizeBalance,
    //   "Locked Balance": widget.userFundWallet.lockedPrizeBalance
    // };
    // Map<String, double> res = {
    //   "ICICI Balance": 500,
    //   "Gold Balance": 200,
    //   "Prize Balance": 50,
    //   "Locked Balance": 100
    // };
    //return res;
  }

  List<Color> getColorList() {
    List<Color> colorList = [];
    chartData.forEach((element) {
      colorList.add(element.color);
    });
    return colorList;
  }

  static List<ChartFundItem> chartData = [];
  getchartData() {
    chartData = [
      ChartFundItem(
          fundName: "ICICI Balance",
          buttonText: "",
          color: Color(0xff66DE93),
          description: ["Here ICICI Fund balance will be shown"],
          function: () {},
          fundAmount: widget.userFundWallet.iciciBalance,
          logo: "images/icici.png",
          isHighlighted: false),
      ChartFundItem(
          fundName: "Gold Balance",
          buttonText: "",
          color: Color(0xffF5B819),
          description: [widget.goldMoreInfo],
          function: () {},
          fundAmount: widget.userFundWallet.augGoldBalance,
          logo: "images/augmont-logo.jpg",
          isHighlighted: false),
      ChartFundItem(
          fundName: "Prize Balance",
          buttonText: widget.userFundWallet.isPrizeBalanceUnclaimed()
              ? "Claim prize"
              : "Share",
          color: Color(0xff6389F2),
          description: [
            "This is the amount of money you've earned as prized playing our games!"
          ],
          function: () {
            HapticFeedback.vibrate();
            if (widget.userFundWallet.prizeBalance <= 0) return;
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (ctx) {
                return Center(
                  child: Material(
                    color: Colors.transparent,
                    child: FCard(
                        isClaimed:
                            !widget.userFundWallet.isPrizeBalanceUnclaimed(),
                        unclaimedPrize: widget.userFundWallet.unclaimedBalance,
                        onComplete: () async {
                          print('onComplete called');
                          widget.doRefresh();
                        }),
                  ),
                );
              },
            );
          },
          fundAmount: widget.userFundWallet.prizeBalance,
          logo: "images/fello_logo.png",
          isHighlighted: widget.userFundWallet.isPrizeBalanceUnclaimed()),
      ChartFundItem(
          fundName: "Locked Balance",
          buttonText: "",
          color: Color(0xff0A1931),
          description: [
            'Referral rewards could be locked due to either of the reasons: \n\n• You were referred by your friend but you haven\'t saved at least ₹${BaseRemoteConfig.UNLOCK_REFERRAL_AMT.toString()} yet. \n\n• You referred your friends but they haven\'t saved at least ₹${BaseRemoteConfig.UNLOCK_REFERRAL_AMT.toString()} yet.'
          ],
          function: () {
            HapticFeedback.vibrate();
            showDialog(
                context: context,
                builder: (BuildContext context) => MoreInfoDialog(
                      text:
                          'Referral rewards could be locked due to either of the reasons: \n\n• You were referred by your friend but you haven\'t saved at least ₹${BaseRemoteConfig.UNLOCK_REFERRAL_AMT.toString()} yet. \n\n• You referred your friends but they haven\'t saved at least ₹${BaseRemoteConfig.UNLOCK_REFERRAL_AMT.toString()} yet.',
                      title: 'Locked Balance',
                    ));
          },
          fundAmount: widget.userFundWallet.lockedPrizeBalance,
          logo: "images/fello_logo.png",
          isHighlighted: true),
    ];
  }

  @override
  Widget build(BuildContext context) {
    appState = Provider.of<AppState>(context, listen: false);
    getchartData();
    return Container(
      width: SizeConfig.screenWidth,
      height: SizeConfig.screenHeight * 0.25,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
              onTap: () {
                // showDialog(context: context,builder: (ctx) { return _buildFundInfoDialog(dataMap, title, descriptions);});

                HapticFeedback.vibrate();
                appState.currentAction = PageAction(
                    state: PageState.addWidget,
                    widget: YourFunds(
                      chartFunds: chartData,
                      doRefresh: widget.doRefresh,
                      userFundWallet: widget.userFundWallet,
                    ),
                    page: YourFundsConfig);
              },
              child: Container(
                child: PieChart(
                  dataMap: getChartMap(),
                  animationDuration: Duration(milliseconds: 800),
                  chartLegendSpacing: 40,
                  chartRadius: SizeConfig.screenWidth / 2,
                  colorList: getColorList(),
                  initialAngleInDegree: 0,
                  shouldHighlight: getHighlightStatus(),
                  chartType: ChartType.ring,
                  ringStrokeWidth: 10.0,
                  centerText:
                      "₹ ${widget.userFundWallet.getEstTotalWealth().toStringAsFixed(2)}",
                  legendOptions: LegendOptions(
                    showLegendsInRow: false,
                    legendPosition: LegendPosition.left,
                    showLegends: false,
                    legendShape: BoxShape.circle,
                    legendTextStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  chartValuesOptions: ChartValuesOptions(
                    showChartValueBackground: true,
                    showChartValues: false,
                    chartValueBackgroundColor: UiConstants.backgroundColor,
                    chartValueStyle: GoogleFonts.montserrat(
                      fontSize: math.min(
                          (SizeConfig.screenWidth) /
                              (widget.userFundWallet
                                      .getEstTotalWealth()
                                      .toStringAsFixed(2)
                                      .length *
                                  1.6),
                          SizeConfig.largeTextSize * 2),
                      color: UiConstants.textColor,
                    ),
                    showChartValuesInPercentage: false,
                    showChartValuesOutside: false,
                  ),
                ),
              )),
          SizedBox(width: SizeConfig.blockSizeHorizontal * 5),
          Container(
            width: SizeConfig.screenWidth * 0.3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                chartData.length,
                (i) => chartData[i].fundAmount > 0
                    ? Legend(
                        title: chartData[i].fundName,
                        amount:
                            "₹ ${chartData[i].fundAmount.toStringAsFixed(2)}",
                        color: chartData[i].color,
                        titleTextStyle: TextStyle(
                          fontSize: SizeConfig.smallTextSize * 1.2,
                          color: UiConstants.textColor,
                        ),
                        bodyTextStyle: TextStyle(
                          fontSize: SizeConfig.mediumTextSize,
                          color: UiConstants.textColor,
                        ),
                        onClick: chartData[i].function,
                        isHighlighted: chartData[i].isHighlighted,
                      )
                    : Container(),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class Legend extends StatelessWidget {
  final String title, amount;
  final Color color;
  final Function onClick;
  final bool isHighlighted;
  final TextStyle titleTextStyle;
  final TextStyle bodyTextStyle;

  Legend(
      {this.amount,
      this.title,
      this.color,
      this.onClick,
      this.titleTextStyle,
      this.bodyTextStyle,
      this.isHighlighted = false});

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: GestureDetector(
          onTap: onClick,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Stack(
                fit: StackFit.passthrough,
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Icon(
                      Icons.circle,
                      color: color,
                      size: 16,
                    ),
                  ),
                ],
              ),
              SizedBox(
                width: 8,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    amount,
                    style: (bodyTextStyle == null)
                        ? TextStyle(
                            fontSize: SizeConfig.mediumTextSize,
                            fontWeight: FontWeight.w500,
                            color: UiConstants.textColor,
                          )
                        : bodyTextStyle,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: Text(
                      title,
                      style: (titleTextStyle == null)
                          ? TextStyle(
                              fontSize: SizeConfig.smallTextSize * 1.2,
                              color: UiConstants.textColor,
                            )
                          : titleTextStyle,
                    ),
                  ),
                ],
              )
            ],
          ),
        ));
  }
}
