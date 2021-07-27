import 'dart:async';
import 'dart:collection';
import 'dart:math';

import 'package:felloapp/core/base_remote_config.dart';
import 'package:felloapp/core/model/UserFundWallet.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/ui/dialogs/Fold-Card/card.dart';
import 'package:felloapp/ui/dialogs/more_info_dialog.dart';
import 'package:felloapp/ui/pages/tabs/finance/finance_report.dart';
import 'package:felloapp/util/size_config.dart';
import 'package:felloapp/util/ui_constants.dart';
import 'package:provider/provider.dart';
import 'pie_chart/pie.dart';
import 'package:flutter/gestures.dart';
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
    Color(0xffF5B819),
    Color(0xff03256C),
  ];

  final List<Color> colorList = [
    Color(0xff66DE93),
    Color(0xffF5B819),
    Color(0xff6389F2),
    Color(0xff783FF9),
  ];

  final List<Color> borderColorList = [
    Color(0xff50CB93),
    Color(0xffFFA900),
    Color(0xff185ADB),
    Color(0xff7952B3),
  ];

  final List<bool> shouldHighlight = [
    false,
    true,
    true,
    false,
  ];

  int startDegree = 0;

  Map<String, double> getChartMap() {
    return {
      "ICICI Balance": widget.userFundWallet.iciciBalance,
      "Gold Balance": widget.userFundWallet.augGoldBalance,
      "Prize Balance": widget.userFundWallet.prizeBalance,
      "Locked Balance": widget.userFundWallet.lockedPrizeBalance
    };
    // Map<String, double> res = {
    //   "ICICI Balance": 500,
    //   "Gold Balance": 200,
    //   "Prize Balance": 50,
    //   "Locked Balance": 100
    // };
    //return res;
  }

  Map<String, String> _getDataDescriptions() {
    return {
      "Gold Balance" : widget.goldMoreInfo,
      "Prize Balance" : "This is the amount of money you've earned as prized playing our games!",
      "Locked Balance" : 'Referral rewards could be locked due to either of the reasons: \n\n• You were referred by your friend but you haven\'t saved at least ₹${BaseRemoteConfig.UNLOCK_REFERRAL_AMT.toString()} yet. \n\n• You referred your friends but they haven\'t saved at least ₹${BaseRemoteConfig.UNLOCK_REFERRAL_AMT.toString()} yet.',
    };
  }

  @override
  void initState() {
    startDegree = Random().nextInt(360) + 1;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    appState = Provider.of<AppState>(context, listen: false);
    Map<String, double> dataMap = getChartMap();
    List<String> title = dataMap.keys.toList();
    Map<String,String> descriptions = _getDataDescriptions();
    return Container(
      width: SizeConfig.screenWidth,
      height: SizeConfig.screenHeight * 0.25,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: (){
              // showDialog(context: context,builder: (ctx) { return _buildFundInfoDialog(dataMap, title, descriptions);});
              HapticFeedback.vibrate();
                      appState.currentAction = PageAction(
                          state: PageState.addWidget,
                          widget: YourFunds(
                            userFundWallet: widget.userFundWallet,
                            goldMoreInfoStr: widget.goldMoreInfo,
                            fundsValueMap: dataMap,
                            fundTitles: title,
                            fundDescriptions: descriptions,
                          ),
                          page: YourFundsConfig);
            },
            child: Container(
              child: PieChart(
                dataMap: dataMap,
                animationDuration: Duration(milliseconds: 800),
                chartLegendSpacing: 40,
                chartRadius: SizeConfig.screenWidth / 2,
                colorList: colorList,
                initialAngleInDegree: 0,
                shouldHighlight: shouldHighlight,
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
                  fontSize: math.min((SizeConfig.screenWidth) /
                      (widget.userFundWallet
                              .getEstTotalWealth()
                              .toStringAsFixed(2)
                              .length *
                          1.6),SizeConfig.largeTextSize*2),
                          color: UiConstants.textColor,
                        ),
                  showChartValuesInPercentage: false,
                  showChartValuesOutside: false,
                ),
              ),
            )
          ),
          SizedBox(width: SizeConfig.blockSizeHorizontal * 5),
          Container(
            width: SizeConfig.screenWidth * 0.3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                (dataMap[title[0]] > 0)
                    ? Legend(
                        title: title[0],
                        amount: "₹ ${dataMap[title[0]].toStringAsFixed(2)}",
                        color: colorList[0],
                        titleTextStyle: TextStyle(
                          fontSize: SizeConfig.smallTextSize * 1.2,
                          color: UiConstants.textColor,),
                        bodyTextStyle: TextStyle(
                          fontSize: SizeConfig.mediumTextSize,
                          color: UiConstants.textColor,
                        ),
                      )
                    : Container(),
                Legend(
                  title: title[1],
                  amount: "₹ ${dataMap[title[1]].toStringAsFixed(2)}",
                  color: colorList[1],
                  titleTextStyle: TextStyle(
                    fontSize: SizeConfig.smallTextSize * 1.2,
                    color: UiConstants.textColor,),
                  bodyTextStyle: TextStyle(
                    fontSize: SizeConfig.mediumTextSize,
                    color: UiConstants.textColor,
                  ),
                  onClick: () {
                    HapticFeedback.vibrate();
                    showDialog(
                      context: context,
                      builder: (BuildContext context) => MoreInfoDialog(
                        text: widget.goldMoreInfo,
                        title: 'Your Gold Balance',
                      ),
                    );
                  },
                ),
                Legend(
                  title: title[2],
                  amount: "₹ ${dataMap[title[2]].toStringAsFixed(2)}",
                  color: colorList[2],
                  titleTextStyle: TextStyle(
                    fontSize: SizeConfig.smallTextSize * 1.2,
                    color: UiConstants.textColor,),
                  bodyTextStyle: TextStyle(
                    fontSize: SizeConfig.mediumTextSize,
                    color: UiConstants.textColor,
                  ),
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
                (dataMap[title[3]] > 0)
                    ? Legend(
                        title: title[3],
                        amount: "₹ ${dataMap[title[3]].toStringAsFixed(2)}",
                        color: colorList[3],
                        titleTextStyle: TextStyle(
                          fontSize: SizeConfig.smallTextSize * 1.2,
                          color: UiConstants.textColor,),
                        bodyTextStyle: TextStyle(
                          fontSize: SizeConfig.mediumTextSize,
                          color: UiConstants.textColor,
                        ),
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
                      )
                    : Container(),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildFundInfoDialog(Map<String,double> dataMap, List<String> titles, Map<String,String> descriptions) {
    List<String> _validTitles = [];
    for(var i in titles) {
      if(dataMap[i]>0 && descriptions.containsKey(i)) {
        _validTitles.add(i);
      }
    }
    return Dialog(
      shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(30.0)),
      child: Container(
        height: SizeConfig.screenHeight*0.6,
        child: Stack(
          children: [
            Container(
              padding: EdgeInsets.only(top : 30.0, left : 15.0, right: 15.0, bottom:30.0),
              child: ListView.separated(
                separatorBuilder: (ctx, index) {
                  return SizedBox(height: SizeConfig.blockSizeVertical*5);
                },
                itemCount: _validTitles.length,
                itemBuilder: (ctx, index) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(_validTitles[index] , style: TextStyle(fontWeight: FontWeight.bold, fontSize: SizeConfig.largeTextSize)),
                      SizedBox(height: SizeConfig.blockSizeVertical*1),
                      Text(descriptions[_validTitles[index]], style: TextStyle(fontSize: SizeConfig.mediumTextSize*1.3))
                    ],
                  );
                },
              ),
            ),
            Align(
              alignment: Alignment.topRight,
              child: IconButton(splashRadius: SizeConfig.blockSizeVertical*1.5,icon: Icon(Icons.close),onPressed: (){Navigator.of(context).pop();},)
            ),
          ],
        ),
      ),
    );
  }

//   List<PieChartSectionData> _getSections() {
//     List<PieChartSectionData> res = [];
//     int _i = 0;
//     getChartMap().forEach((key, value) {
//       final isTouched = _i == touchedIndex;
//       final fontSize = isTouched
//           ? SizeConfig.mediumTextSize * 1.2
//           : SizeConfig.mediumTextSize;
//       final radius = isTouched
//           ? SizeConfig.blockSizeHorizontal * 10
//           : SizeConfig.blockSizeHorizontal * 7;
//       res.add(PieChartSectionData(
//           borderSide: BorderSide(
//             width: 2,
//             color: borderColorList[_i],
//           ),
//           color: colorList[_i],
//           value: value,
//           title: key,
//           titlePositionPercentageOffset: 2,
//           showTitle: false,
//           radius: radius,
//           titleStyle: TextStyle(fontSize: fontSize, color: Colors.black)));
//       _i++;
//     });
//     return res;
//   }
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
                  (isHighlighted)
                      ? Align(
                          alignment: Alignment.center,
                          child: SpinKitPulse(
                            color: color,
                            duration: Duration(seconds: 2),
                            size: 16,
                          ),
                        )
                      : Align(
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
                              fontSize: SizeConfig.smallTextSize,
                              color: Colors.grey,
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
