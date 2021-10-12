//Project Imports
import 'package:felloapp/core/base_remote_config.dart';
import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/core/enums/screen_item_enum.dart';
import 'package:felloapp/core/model/user_funt_wallet_model.dart';
import 'package:felloapp/core/model/chart_fund_item_model.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/ui/dialogs/golden_ticket_claim.dart';
import 'package:felloapp/ui/elements/plots/pie_chart/chart_values_options.dart';
import 'package:felloapp/ui/elements/plots/pie_chart/legend_options.dart';
import 'package:felloapp/ui/elements/plots/pie_chart/pie_chart.dart';
import 'package:felloapp/ui/pages/others/finance/finance_report.dart';
import 'package:felloapp/util/haptic.dart';
import 'package:felloapp/util/styles/palette.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/ui_constants.dart';

//Flutter & Dart Imports
import 'dart:math' as math;
import 'package:flutter/material.dart';

//Pub Imports
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class FundsChartView extends StatefulWidget {
  final UserFundWallet userFundWallet;
  final String
      goldMoreInfo; //should be altered to a more info array for all assets
  //final VoidCallback doRefresh;

  FundsChartView({
    this.userFundWallet,
    this.goldMoreInfo,
    //this.doRefresh
  });

  @override
  State createState() => _FundsChartViewState();
}

class _FundsChartViewState extends State<FundsChartView> {
  AppState appState;
  final List<Color> colorListLight = [
    UiConstants.primaryColor,
    FelloColorPalette.augmontFundPalette().primaryColor,
    Color(0xff03256C),
  ];

  final List<Color> colorList = [
    UiConstants.primaryColor,
    FelloColorPalette.augmontFundPalette().primaryColor,
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
          color: Color(0xff66DE93),
          description: ["This is your current ICICI Balance."],
          fundAmount: widget.userFundWallet.iciciBalance,
          logo: "images/icici.png",
          isHighlighted: false),
      ChartFundItem(
          fundName: "Gold Balance",
          color: Color(0xffF5B819),
          description: [widget.goldMoreInfo],
          fundAmount: widget.userFundWallet.augGoldBalance,
          logo: "images/augmont-logo.jpg",
          isHighlighted: false),
      ChartFundItem(
          fundName: "Prize Balance",
          color: Color(0xff6389F2),
          description: [
            "This is the amount you've earned as rewards playing games and through successful referrals!"
          ],
          fundAmount: widget.userFundWallet.prizeBalance,
          logo: "images/fello_logo.png",
          isHighlighted: widget.userFundWallet.isPrizeBalanceUnclaimed()),
      ChartFundItem(
          fundName: "Locked Balance",
          color: Colors.grey[500],
          description: [
            'Referral rewards could be locked due to either of the reasons: \n\n• You were referred by your friend but you haven\'t saved at least ₹${BaseRemoteConfig.UNLOCK_REFERRAL_AMT.toString()} yet. \n\n• You referred your friends but they haven\'t saved at least ₹${BaseRemoteConfig.UNLOCK_REFERRAL_AMT.toString()} yet.'
          ],
          fundAmount: widget.userFundWallet.lockedPrizeBalance,
          logo: "images/fello_logo.png",
          isHighlighted: false),
    ];
  }

  @override
  Widget build(BuildContext context) {
    appState = Provider.of<AppState>(context, listen: false);
    getchartData();
    return GestureDetector(
      onTap: () {
        Haptic.vibrate();
        if (widget.userFundWallet.getEstTotalWealth() > 0.0)
          appState.currentAction = PageAction(
              state: PageState.addWidget,
              widget: YourFunds(
                chartFunds: chartData,
                //doRefresh: widget.doRefresh,
                userFundWallet: widget.userFundWallet,
              ),
              page: YourFundsConfig);
      },
      child: Container(
        width: SizeConfig.screenWidth,
        // height: SizeConfig.screenHeight * 0.25,
        child: Stack(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
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
                                      1.8),
                              SizeConfig.largeTextSize * 2),
                          color: UiConstants.textColor,
                          fontWeight: FontWeight.w400),
                      showChartValuesInPercentage: false,
                      showChartValuesOutside: false,
                    ),
                  ),
                ),
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
                                color: UiConstants.textColor.withOpacity(0.5),
                              ),
                              bodyTextStyle: TextStyle(
                                fontSize: SizeConfig.mediumTextSize * 1.1,
                                fontWeight: FontWeight.w600,
                                color: UiConstants.textColor,
                              ),
                              isHighlighted: chartData[i].isHighlighted,
                            )
                          : Container(),
                    ),
                  ),
                )
              ],
            ),
            IconButton(
                icon: Icon(Icons.info),
                onPressed: () {
                  AppState.screenStack.add(ScreenItem.dialog);
                  return showDialog(
                    context: context,
                    builder: (_) => GoldenTicketClaimDialog(
                      ticketCount: 0,
                      failMsg: "abc",
                    ),
                  );
                },
                color: Colors.grey)
          ],
        ),
      ),
    );
  }
}

class Legend extends StatelessWidget {
  final String title, amount;
  final Color color;
  final bool isHighlighted;
  final TextStyle titleTextStyle;
  final TextStyle bodyTextStyle;

  Legend(
      {this.amount,
      this.title,
      this.color,
      this.titleTextStyle,
      this.bodyTextStyle,
      this.isHighlighted = false});

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(
              Icons.circle,
              color: color,
              size: 16,
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
                            fontWeight: FontWeight.w300)
                        : titleTextStyle,
                  ),
                ),
              ],
            )
          ],
        ));
  }
}
