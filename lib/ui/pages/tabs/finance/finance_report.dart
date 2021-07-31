import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/model/UserFundWallet.dart';
import 'package:felloapp/core/model/chartFundItem.dart';
import 'package:felloapp/ui/dialogs/Fold-Card/card.dart';
import 'package:felloapp/ui/pages/tabs/finance/finance_screen.dart';
import 'package:felloapp/util/size_config.dart';
import 'package:felloapp/util/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../../../main.dart';

class YourFunds extends StatefulWidget {
  final List<ChartFundItem> chartFunds;

  final UserFundWallet userFundWallet;
  //final VoidCallback doRefresh;

  YourFunds({
    Key key,
    this.chartFunds,
    this.userFundWallet,
    //this.doRefresh
  }) : super(key: key);
  @override
  _YourFundsState createState() => _YourFundsState();
}

class _YourFundsState extends State<YourFunds> {
  List<double> breakdownWidth = [0, 0, 0, 0];

  BaseUtil baseProvider;
  @override
  void initState() {
    widget.chartFunds.sort((a, b) => b.fundAmount.compareTo(a.fundAmount));
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Future.delayed(
          Duration(milliseconds: 100), () => getFundBreakdownWidth());
    });
    super.initState();
  }

  getFundBreakdownWidth() {
    double totalWealth = widget.userFundWallet.getEstTotalWealth();
    List<double> temp = [];
    widget.chartFunds.forEach((element) {
      temp.add((element.fundAmount / totalWealth));
    });
    setState(() {
      breakdownWidth = temp;
    });
  }

  @override
  Widget build(BuildContext context) {
    baseProvider = Provider.of<BaseUtil>(context);

    return Scaffold(
        body: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(color: Colors.black),
          width: SizeConfig.screenWidth,
          height: SizeConfig.screenHeight * 0.24,
          child: Stack(
            children: [
              ListView(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                children: List.generate(
                  3,
                  (i) => AnimatedContainer(
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    duration: Duration(seconds: 2),
                    curve: Curves.easeOutCirc,
                    width: breakdownWidth[i] * SizeConfig.screenWidth,
                    height: SizeConfig.screenHeight * 0.24,
                    color: widget.chartFunds[i].color,
                  ),
                ),
              ),
              SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: SizeConfig.screenWidth,
                      height: kToolbarHeight,
                      child: Row(
                        children: [
                          SizedBox(width: SizeConfig.blockSizeHorizontal),
                          IconButton(
                            iconSize: 30,
                            color: Colors.white,
                            icon: Icon(
                              Icons.arrow_back_rounded,
                            ),
                            onPressed: () => backButtonDispatcher.didPopRoute(),
                          ),
                          Spacer(),
                          Image.asset(
                            "images/fello_logo.png",
                            width: SizeConfig.screenWidth * 0.1,
                            color: Colors.white,
                          ),
                          Spacer(),
                          IconButton(
                            iconSize: 30,
                            color: Colors.white,
                            icon: SizedBox(),
                            onPressed: () {},
                          ),
                        ],
                      ),
                    ),
                    Spacer(),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: SizeConfig.blockSizeHorizontal * 5,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Total Balance',
                            style: TextStyle(
                                fontSize: SizeConfig.largeTextSize,
                                color: Colors.white60),
                          ),
                          SizedBox(height: 4),
                          Text(
                            '₹ ${widget.userFundWallet.getEstTotalWealth().toStringAsFixed(2)}',
                            style: TextStyle(
                                fontSize: SizeConfig.cardTitleTextSize * 1.6,
                                fontWeight: FontWeight.w700,
                                color: Colors.white),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: SizeConfig.blockSizeHorizontal * 3),
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Column(
                children: List.generate(
                    widget.chartFunds.length,
                    (index) =>
                        // widget.chartFunds[index].fundAmount > 0
                        //     ?
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: SizeConfig.blockSizeHorizontal * 3,
                              vertical: 8),
                          margin: EdgeInsets.symmetric(
                              vertical: SizeConfig.blockSizeHorizontal * 3),
                          width: SizeConfig.screenWidth,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color:
                                widget.chartFunds[index].color.withOpacity(0.1),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    height: 50,
                                    width: 50,
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Image.asset(
                                      widget.chartFunds[index].logo,
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Text(
                                    widget.chartFunds[index].fundName,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      // color: widget.chartFunds[index].color,
                                      fontSize: SizeConfig.mediumTextSize,
                                    ),
                                  ),
                                  Spacer(),
                                  Text(
                                    '₹ ${widget.chartFunds[index].fundAmount.toStringAsFixed(2)}',
                                    style: TextStyle(
                                      color: widget.chartFunds[index].color,
                                      fontWeight: FontWeight.w700,
                                      fontSize: SizeConfig.largeTextSize,
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(height: 12),
                              Text(
                                widget.chartFunds[index].description[0],
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: SizeConfig.mediumTextSize,
                                    height: 1.5),
                              ),
                              SizedBox(height: 12),
                              baseProvider.userFundWallet.prizeBalance > 0 &&
                                      widget.chartFunds[index].action
                                  ? ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          primary:
                                              widget.chartFunds[index].color),
                                      onPressed:
                                          widget.chartFunds[index].function,
                                      child: Text(
                                        //widget.chartFunds[index].buttonText,
                                        !baseProvider.userFundWallet
                                                .isPrizeBalanceUnclaimed()
                                            ? "Share"
                                            : "Claim Prize",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    )
                                  : SizedBox()
                            ],
                          ),
                        )
                    // : SizedBox(),
                    ),
              ),
            ),
          ),
        )
      ],
    ));
  }
}
