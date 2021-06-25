import 'dart:async';

import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/base_analytics.dart';
import 'package:felloapp/core/ops/augmont_ops.dart';
import 'package:felloapp/core/ops/db_ops.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/ui/pages/tabs/finance/gold_details_page.dart';
import 'package:felloapp/ui/elements/funds_chart_view.dart';
import 'package:felloapp/ui/pages/tabs/finance/mf_details_page.dart';
import 'package:felloapp/util/logger.dart';
import 'package:felloapp/util/size_config.dart';
import 'package:felloapp/util/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
  GlobalKey _showcaseHeader = GlobalKey();
  GlobalKey _showcaseFooter = GlobalKey();

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
                                ? FundsChartView(
                                    userFundWallet: baseProvider.userFundWallet,
                                    goldMoreInfo: goldMoreInfoStr,
                                    doRefresh: () {
                                      _onFundsRefresh();
                                    },
                                  )
                                : ZeroBalView(),
                      ),
                    ),
                    Divider(
                      color: Colors.black38,
                    ),
                    Text(
                      "Available Funds",
                      textAlign: TextAlign.center,
                      style: TextStyle(
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
              style: TextStyle(
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
                    style: TextStyle(
                      color: Colors.white,
                      height: 1.4,
                      letterSpacing: 1.5,
                      fontSize: SizeConfig.largeTextSize,
                      fontWeight: FontWeight.w700,
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
                            style: TextStyle(
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
