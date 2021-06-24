import 'package:felloapp/core/base_remote_config.dart';
import 'package:felloapp/core/model/UserFundWallet.dart';
import 'package:felloapp/ui/dialogs/Fold-Card/card.dart';
import 'package:felloapp/ui/dialogs/more_info_dialog.dart';
import 'package:felloapp/util/size_config.dart';
import 'package:felloapp/util/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pie_chart/pie_chart.dart';

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

  Map<String, double> getChartMap() {
    return {
      "ICICI Balance": widget.userFundWallet.iciciBalance,
      "Gold Balance": widget.userFundWallet.augGoldBalance,
      "Prize Balance": widget.userFundWallet.prizeBalance,
      "Locked Balance": widget.userFundWallet.lockedPrizeBalance
    };
  }

  @override
  Widget build(BuildContext context) {
    Map<String, double> dataMap = getChartMap();
    List<String> title = dataMap.keys.toList();
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: SizeConfig.blockSizeHorizontal,
          ),
          height: SizeConfig.screenWidth * 0.4,
          alignment: Alignment.centerRight,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              (dataMap[title[0]] > 0)
                  ? Expanded(
                      child: Legend(
                        title: title[0],
                        amount: "₹ ${dataMap[title[0]].toStringAsFixed(2)}",
                        color: colorList[0],
                      ),
                    )
                  : Container(),
              Expanded(
                child: Legend(
                  title: title[1],
                  amount: "₹ ${dataMap[title[1]].toStringAsFixed(2)}",
                  color: colorList[1],
                  onClick: () {
                    HapticFeedback.vibrate();
                    showDialog(
                        context: context,
                        builder: (BuildContext context) => MoreInfoDialog(
                              text: widget.goldMoreInfo,
                              title: 'Your Gold Balance',
                            ));
                  },
                ),
              ),
              Expanded(
                child: Legend(
                  title: title[2],
                  amount: "₹ ${dataMap[title[2]].toStringAsFixed(2)}",
                  color: colorList[2],
                  isHighlighted:
                      widget.userFundWallet.isPrizeBalanceUnclaimed(),
                  onClick: () {
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
                                isClaimed: !widget.userFundWallet
                                    .isPrizeBalanceUnclaimed(),
                                unclaimedPrize:
                                    widget.userFundWallet.unclaimedBalance,
                                onComplete: () async {
                                  print('onComplete called');
                                  widget.doRefresh();
                                }),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
              (dataMap[title[3]] > 0)
                  ? Expanded(
                      child: Legend(
                        title: title[3],
                        amount: "₹ ${dataMap[title[3]].toStringAsFixed(2)}",
                        color: colorList[3],
                        onClick: () {
                          HapticFeedback.vibrate();
                          showDialog(
                              context: context,
                              builder: (BuildContext context) => MoreInfoDialog(
                                    text:
                                        'Referral rewards could be locked due to either of the reasons: \n\n• You were referred by your friend but you haven\'t saved at least ₹${BaseRemoteConfig.UNLOCK_REFERRAL_AMT.toString()} yet. \n\n• You referred your friends but they haven\'t saved at least ₹${BaseRemoteConfig.UNLOCK_REFERRAL_AMT.toString()} yet.',
                                    title: 'Locked Balance',
                                  ));
                        },
                      ),
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
            chartRadius: SizeConfig.screenWidth / 2,
            colorList: colorList,
            initialAngleInDegree: 0,
            chartType: ChartType.ring,
            ringStrokeWidth: 5,
            centerText:
                "₹ ${widget.userFundWallet.getEstTotalWealth().toStringAsFixed(2)}",
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

class Legend extends StatelessWidget {
  final String title, amount;
  final Color color;
  final Function onClick;
  final bool isHighlighted;

  Legend(
      {this.amount,
      this.title,
      this.color,
      this.onClick,
      this.isHighlighted = false});

  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.bottomCenter,
        padding: const EdgeInsets.only(top: 8, bottom: 8),
        child: GestureDetector(
          onTap: onClick,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                fit: StackFit.passthrough,
                children: [
                  Container(
                    height: SizeConfig.screenWidth * 0.06,
                    width: SizeConfig.screenWidth * 0.06,
                    alignment: Alignment.center,
                    child: CircleAvatar(
                      radius: SizeConfig.screenWidth * 0.016,
                      backgroundColor: color,
                    ),
                  ),
                  (isHighlighted)
                      ? Container(
                          height: SizeConfig.screenWidth * 0.06,
                          width: SizeConfig.screenWidth * 0.06,
                          alignment: Alignment.center,
                          child: SpinKitPulse(
                            color: color,
                            size: SizeConfig.screenWidth * 0.1,
                          ),
                        )
                      : Container()
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
