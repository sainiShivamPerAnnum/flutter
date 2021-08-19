import 'dart:math' as math;

import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/base_analytics.dart';
import 'package:felloapp/core/ops/augmont_ops.dart';
import 'package:felloapp/core/ops/db_ops.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/ui/dialogs/integrated_icici_disabled_dialog.dart';
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

class _FinancePageState extends State<FinancePage>
    with SingleTickerProviderStateMixin {
  Log log = new Log('FinanceScreen');
  final bool hasFund = true;
  BaseUtil baseProvider;
  AugmontModel augmontProvider;
  DBModel dbProvider;
  AppState appState;

  double _scale;
  AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(
        milliseconds: 200,
      ),
      lowerBound: 0.0,
      upperBound: 0.1,
    )..addListener(() {
        setState(() {});
      });

    BaseAnalytics.analytics
        .setCurrentScreen(screenName: BaseAnalytics.PAGE_FINANCE);
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  void _onTapDown() {
    if (mounted)
      _controller.forward().then(
            (value) => _controller.reverse().then((value) {
              AppState.screenStack.add(ScreenItem.dialog);
              showDialog(
                context: context,
                builder: (BuildContext context) => Dialog(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.asset(
                      "images/unavailable.png",
                      width: SizeConfig.screenWidth * 0.8,
                    ),
                  ),
                ),
              );
            }),
          );
  }

  @override
  Widget build(BuildContext context) {
    _scale = 1 - _controller.value;

    baseProvider = Provider.of<BaseUtil>(context);
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
              padding: EdgeInsets.symmetric(
                  horizontal: SizeConfig.globalMargin,
                  vertical: SizeConfig.blockSizeVertical),
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
                    Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: SizeConfig.blockSizeVertical),
                      child: Divider(
                        color: Colors.black38,
                      ),
                    ),
                    Text(
                      "Discover Assets",
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
                        GestureDetector(
                          onTap: () => appState.currentAction = PageAction(
                              state: PageState.addPage,
                              page: AugDetailsPageConfig),
                          child: FundWidget(
                            fund: fundList[1],
                            isAvailable: (AugmontDetailsPage.checkAugmontStatus(
                                    baseProvider.myUser) !=
                                AugmontDetailsPage.STATUS_UNAVAILABLE),
                          ),
                        ),
                        GestureDetector(
                          onTap: _onTapDown,
                          child: Transform.scale(
                            scale: _scale,
                            child: FundWidget(
                              fund: fundList[0],
                              isAvailable:
                                  (MFDetailsPage.checkICICIDespositStatus(
                                          baseProvider.myUser) !=
                                      MFDetailsPage.STATUS_UNAVAILABLE),
                            ),
                          ),
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
            padding: const EdgeInsets.fromLTRB(20.0, 20, 20, 2),
            child: Text(
              "Your savings and prize balance is currently zero.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: SizeConfig.mediumTextSize,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(2.0),
            child: Text(
              "Start now ⏬",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey,
                fontWeight: FontWeight.w100,
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
  final bool isAvailable;

  const FundWidget({this.fund, this.isAvailable = true});

  @override
  Widget build(BuildContext context) {
    return Opacity(
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
                          fontSize: math.max(SizeConfig.cardTitleTextSize, 22),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ))
                : Container()
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

class jiggler extends StatefulWidget {
  final Widget child;
  jiggler({this.child});
  @override
  State<StatefulWidget> createState() => _jiggler();
}

class _jiggler extends State<jiggler> with SingleTickerProviderStateMixin {
  final TextEditingController textController = TextEditingController();
  AnimationController controller;

  @override
  void initState() {
    controller = AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Animation<double> offsetAnimation = Tween(begin: 0.0, end: 24.0)
        .chain(CurveTween(curve: Curves.elasticIn))
        .animate(controller)
          ..addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              controller.reverse();
            }
          });

    return AnimatedBuilder(
        animation: offsetAnimation,
        builder: (buildContext, child) {
          if (offsetAnimation.value < 0.0)
            print('${offsetAnimation.value + 8.0}');
          return InkWell(
            onTap: () => controller.forward(from: 0.0),
            child: Container(
                margin: EdgeInsets.symmetric(horizontal: 24.0),
                padding: EdgeInsets.only(
                    left: offsetAnimation.value + 24.0,
                    right: 24.0 - offsetAnimation.value),
                child: child),
          );
        });
  }
}
