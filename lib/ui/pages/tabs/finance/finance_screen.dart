import 'dart:math' as math;

import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/base_analytics.dart';
import 'package:felloapp/core/ops/augmont_ops.dart';
import 'package:felloapp/core/ops/db_ops.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/ui/elements/plots/funds_chart_view.dart';
import 'package:felloapp/util/logger.dart';
import 'package:felloapp/util/size_config.dart';
import 'package:felloapp/util/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'augmont/augmont-details.dart';
import 'icici/mf_details_page.dart';

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

  // GlobalKey _showcaseHeader = GlobalKey();
  // GlobalKey _showcaseFooter = GlobalKey();

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
      baseProvider.refreshFunds();
      //_updateAugmontBalance();
      baseProvider.isAugmontRealTimeBalanceFetched = true;
    }
    // if (baseProvider.show_finance_tutorial) {
    //   WidgetsBinding.instance.addPostFrameCallback((_) {
    //     ShowCaseWidget.of(context)
    //         .startShowCase([_showcaseFooter, _showcaseHeader]);
    //   });
    // }
    return RefreshIndicator(
      onRefresh: () async {
        await baseProvider.refreshFunds();
        //_onFundsRefresh();
      },
      child: Container(
        height: SizeConfig.screenHeight,
        decoration: BoxDecoration(
          color: UiConstants.backgroundColor,
          borderRadius: SizeConfig.homeViewBorder,
        ),
        child: SafeArea(
          child: ClipRRect(
            borderRadius: SizeConfig.homeViewBorder,
            child: Padding(
              padding:
                  EdgeInsets.symmetric(horizontal: SizeConfig.globalMargin),
              child: CustomScrollView(
                slivers: [
                  SliverList(
                      delegate: SliverChildListDelegate([
                    Container(
                      height: kToolbarHeight / 1.6,
                    ),
                    Consumer<BaseUtil>(
                      builder: (context, baseUtil, child) {
                        return Container(
                          child: baseProvider.userFundWallet
                                      .getEstTotalWealth() >
                                  0
                              ? FundsChartView(
                                  userFundWallet: baseProvider.userFundWallet,
                                  goldMoreInfo: goldMoreInfoStr,
                                )
                              : const ZeroBalView(),
                        );
                      },
                    ),
                    // BaseUtil.buildShowcaseWrapper(_showcaseHeader,
                    //     'Your savings and investments will show up here. The balances are based on live market rates.',
                    //
                    // ),
                    Divider(
                      color: Colors.black38,
                    ),
                    Text(
                      "Available Funds",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: SizeConfig.largeTextSize,
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
                        // BaseUtil.buildShowcaseWrapper(
                        //   _showcaseFooter,
                        //   'Choose any of the assets to deposit in. Fello lists strong proven assets with great historical returns.',
                        //
                        // ),
                        FundWidget(
                          fund: fundList[1],
                          isAvailable: (AugmontDetailsPage.checkAugmontStatus(
                                  baseProvider.myUser) !=
                              AugmontDetailsPage.STATUS_UNAVAILABLE),
                          onPressed: () => appState.currentAction = PageAction(
                              state: PageState.addPage,
                              page: AugDetailsPageConfig),
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
    String _s = '';
    String _t = '.';
    if (baseProvider.userFundWallet.augGoldQuantity == 0) {
      _s = 'This is your current digital Gold balance';
    } else {
      _s =
          'You currently own ${baseProvider.userFundWallet.augGoldQuantity} grams of digital Gold.\n\nThe balance shown here is based on the current selling rate of gold';
    }
    if (baseProvider.userFundWallet.augGoldQuantity > 0 &&
        baseProvider.augmontGoldRates != null) {
      _t =
          ', which is ₹${baseProvider.augmontGoldRates.goldSellPrice} per gram.';
    }
    return '$_s$_t';
  }
}

class ZeroBalView extends StatelessWidget {
  const ZeroBalView();

  @override
  Widget build(BuildContext context) {
    BaseUtil baseProvider = Provider.of<BaseUtil>(context);
    return Container(
      height: SizeConfig.screenHeight * 0.3,
      padding: EdgeInsets.all(SizeConfig.blockSizeHorizontal * 2),
      child: Column(
        children: [
          Expanded(
            child: Center(
              child: Image.asset(
                "images/${baseProvider.zeroBalanceAssetUri}.png",
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

  const FundWidget({this.fund, this.onPressed, this.isAvailable = true});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: onPressed,
        child: Opacity(
          opacity: (isAvailable) ? 1 : 0.6,
          child: Container(
            padding: EdgeInsets.all(SizeConfig.blockSizeHorizontal * 3),
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
                      color: isAvailable
                          ? Colors.white
                          : Colors.white.withOpacity(0.5),
                      height: 1.4,
                      fontSize: math.min(SizeConfig.largeTextSize, 30),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                (!isAvailable)
                    ? Align(
                        alignment: Alignment.bottomCenter,
                        child: Padding(
                          padding: EdgeInsets.only(
                              bottom: SizeConfig.blockSizeHorizontal * 10),
                          child: Text(
                            'Coming\nSoon',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              shadows: [
                                BoxShadow(
                                    color: Colors.black.withOpacity(0.4),
                                    blurRadius: 2,
                                    offset: Offset(2, 2),
                                    spreadRadius: 2)
                              ],
                              color: Colors.white,
                              fontSize:
                                  math.max(SizeConfig.cardTitleTextSize, 22),
                              fontWeight: FontWeight.w700,
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
