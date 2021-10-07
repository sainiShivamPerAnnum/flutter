//Project Imports
import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/enums/pagestate.dart';
import 'package:felloapp/core/enums/screen_item.dart';
import 'package:felloapp/core/model/tambola_winners_details.dart';
import 'package:felloapp/core/model/user_funt_wallet_model.dart';
import 'package:felloapp/core/model/user_transaction_model.dart';
import 'package:felloapp/core/model/chart_fund_item_model.dart';
import 'package:felloapp/core/ops/augmont_ops.dart';
import 'package:felloapp/core/ops/db_ops.dart';
import 'package:felloapp/core/ops/lcl_db_ops.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/ui/dialogs/Prize-Card/card.dart';
import 'package:felloapp/ui/dialogs/share-card.dart';
import 'package:felloapp/ui/modals_sheets/simple_kyc_modal_sheet.dart';
import 'package:felloapp/ui/pages/tabs/finance/augmont/augmont_withdraw_screen.dart';
import 'package:felloapp/util/fail_types.dart';
import 'package:felloapp/util/logger.dart';
import 'package:felloapp/util/styles/size_config.dart';

//Dart and Flutter Imports
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

//Pub Imports
import 'package:provider/provider.dart';

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
  Log log = new Log('FinanceReport');

  BaseUtil baseProvider;
  LocalDBModel localDBModel;
  DBModel dbProvider;
  AugmontModel augmontProvider;
  double _withdrawableGoldQnty;

  // PrizeClaimChoice choice;
  GlobalKey<AugmontWithdrawScreenState> _withdrawalDialogKey2 = GlobalKey();

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

  Future<PrizeClaimChoice> getClaimChoice() async {
    return await localDBModel.getPrizeClaimChoice();
  }

  @override
  Widget build(BuildContext context) {
    baseProvider = Provider.of<BaseUtil>(context);
    localDBModel = Provider.of<LocalDBModel>(context, listen: false);
    dbProvider = Provider.of<DBModel>(context, listen: false);
    augmontProvider = Provider.of<AugmontModel>(context, listen: false);

    return Scaffold(
        body: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(color: Colors.black),
          width: SizeConfig.screenWidth,
          height: SizeConfig.screenHeight * 0.27,
          child: Stack(
            children: [
              ListView(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                children: List.generate(
                  4,
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
                            onPressed: () =>
                                AppState.backButtonDispatcher.didPopRoute(),
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
                                    padding: const EdgeInsets.all(10),
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
                              const SizedBox(height: 12),
                              Text(
                                widget.chartFunds[index].description[0],
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: SizeConfig.mediumTextSize,
                                    height: 1.5),
                              ),
                              const SizedBox(height: 12),
                              checkForAction(
                                widget.chartFunds[index].fundName,
                                widget.chartFunds[index].color,
                              )
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

  checkForAction(String fundName, Color color) {
    if (fundName == "Gold Balance" &&
        widget.userFundWallet.augGoldBalance > 0 &&
        baseProvider.myUser.isAugmontOnboarded)
      return ElevatedButton(
        style: ElevatedButton.styleFrom(primary: color),
        onPressed: _onWithdrawalClicked,
        child: Text(
          "Withdraw",
          style: TextStyle(color: Colors.white),
        ),
      );
    else if (fundName == "Prize Balance" &&
        baseProvider.userFundWallet.prizeBalance > 0) {
      return baseProvider.checkKycMissing
          ? _addKycInfoWidget()
          : ElevatedButton(
              style: ElevatedButton.styleFrom(primary: color),
              onPressed: prizeBalanceAction,
              child: Text(
                baseProvider.userFundWallet.isPrizeBalanceUnclaimed()
                    ? "Claim Prize"
                    : "Share",
                style: TextStyle(color: Colors.white),
              ),
            );
    } else
      return SizedBox();
  }

  prizeBalanceAction() async {
    HapticFeedback.vibrate();
    if (baseProvider.userFundWallet.isPrizeBalanceUnclaimed())
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (ctx) {
          return Center(
            child: Material(
              color: Colors.transparent,
              child: FCard(
                isClaimed:
                    !baseProvider.userFundWallet.isPrizeBalanceUnclaimed(),
                unclaimedPrize: widget.userFundWallet.unclaimedBalance,
              ),
            ),
          );
        },
      );
    else {
      final choice = await getClaimChoice();
      AppState.screenStack.add(ScreenItem.dialog);
      showDialog(
        context: context,
        builder: (ctx) => ShareCard(
          dpUrl: baseProvider.myUserDpUrl,
          claimChoice: choice,
          prizeAmount: baseProvider.userFundWallet.prizeBalance,
          username: baseProvider.myUser.name,
        ),
      );
    }
  }

  Widget _addKycInfoWidget() {
    return InkWell(
      onTap: () {
        if (baseProvider.showNoInternetAlert(context)) return;
        AppState.screenStack.add(ScreenItem.dialog);
        showModalBottomSheet(
            isDismissible: false,
            // backgroundColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            context: context,
            isScrollControlled: true,
            builder: (context) {
              return SimpleKycModalSheet();
            });
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: Color(0xff6389F2).withOpacity(0.5),
          borderRadius: BorderRadius.circular(SizeConfig.blockSizeVertical),
        ),
        child: Padding(
          padding: EdgeInsets.all(SizeConfig.blockSizeHorizontal * 2),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              Icon(
                Icons.info_outline,
                size: SizeConfig.mediumTextSize,
              ),
              Spacer(),
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  'Complete your KYC to claim your prize balance',
                  textAlign: TextAlign.center,
                ),
              ),
              Spacer(),
              SizedBox()
            ],
          ),
        ),
      ),
    );
  }

  _onWithdrawalClicked() async {
    HapticFeedback.vibrate();
    if (baseProvider.showNoInternetAlert(context)) return;
    baseProvider.augmontDetail = (baseProvider.augmontDetail == null)
        ? (await dbProvider.getUserAugmontDetails(baseProvider.myUser.uid))
        : baseProvider.augmontDetail;
    if (!baseProvider.myUser.isAugmontOnboarded) {
      baseProvider.showNegativeAlert(
          'Not onboarded', 'You havent been onboarded to Augmont yet', context);
    } else if (baseProvider.userFundWallet.augGoldQuantity == null ||
        baseProvider.userFundWallet.augGoldQuantity == 0) {
      baseProvider.showNegativeAlert('No balance',
          'Your Augmont wallet has no balance presently', context);
    } else {
      baseProvider.isAugWithdrawRouteLogicInProgress = true;
      setState(() {});
      double _liveGoldQuantityBalance;
      try {
        baseProvider.augmontGoldRates = await augmontProvider.getRates();
      } catch (e) {
        log.error('Failed to fetch current sell rates: $e');
      }
      try {
        _liveGoldQuantityBalance = await augmontProvider.getGoldBalance();
      } catch (e) {
        log.error('Failed to fetch current gold balance: $e');
      }
      try {
        double _w = await dbProvider
            .getNonWithdrawableAugGoldQuantity(baseProvider.myUser.uid);
        _withdrawableGoldQnty = (_w != null)
            ? math.max(_liveGoldQuantityBalance - _w, 0)
            : _liveGoldQuantityBalance;
      } catch (e) {
        log.error('Failed to fetch non withdrawable gold quantity');
      }
      if (baseProvider.augmontGoldRates == null ||
          _liveGoldQuantityBalance == null ||
          _liveGoldQuantityBalance == 0) {
        baseProvider.isAugWithdrawRouteLogicInProgress = false;
        setState(() {});
        baseProvider.showNegativeAlert('Couldn\'t complete your request',
            'Please try again in some time', context);
      } else {
        baseProvider.isAugWithdrawRouteLogicInProgress = false;
        setState(() {});
        AppState.delegate.appState.currentAction = PageAction(
          state: PageState.addWidget,
          page: AugWithdrawalPageConfig,
          widget: AugmontWithdrawScreen(
            key: _withdrawalDialogKey2,
            passbookBalance: _liveGoldQuantityBalance,
            withdrawableGoldQnty: _withdrawableGoldQnty,
            sellRate: baseProvider.augmontGoldRates.goldSellPrice,
            onAmountConfirmed: (Map<String, double> amountDetails) {
              _onInitiateWithdrawal(amountDetails['withdrawal_quantity']);
            },
            bankHolderName: baseProvider.augmontDetail.bankHolderName,
            bankAccNo: baseProvider.augmontDetail.bankAccNo,
            bankIfsc: baseProvider.augmontDetail.ifsc,
          ),
        );
      }
    }
  }

  _onInitiateWithdrawal(double qnt) {
    if (baseProvider.augmontGoldRates != null && qnt != null) {
      augmontProvider.initiateWithdrawal(baseProvider.augmontGoldRates, qnt);
      augmontProvider.setAugmontTxnProcessListener(_onSellComplete);
    }
  }

  _onSellComplete(UserTransaction txn) async {
    if (baseProvider.currentAugmontTxn != null) {
      if (baseProvider.currentAugmontTxn.tranStatus !=
          UserTransaction.TRAN_STATUS_COMPLETE) {
        _withdrawalDialogKey2.currentState.onTransactionProcessed(false);
      } else {
        ///reduce tickets and amount
        baseProvider.currentAugmontTxn.closingBalance =
            baseProvider.getUpdatedWithdrawalClosingBalance(
                baseProvider.currentAugmontTxn.amount);
        baseProvider.currentAugmontTxn.ticketUpCount =
            baseProvider.getTicketCountForTransaction(
                baseProvider.currentAugmontTxn.amount);
        await dbProvider.updateUserTransaction(
            baseProvider.myUser.uid, baseProvider.currentAugmontTxn);

        ///update user wallet balance
        double _tempCurrentBalance = baseProvider.userFundWallet.augGoldBalance;
        baseProvider.userFundWallet =
            await dbProvider.updateUserAugmontGoldBalance(
                baseProvider.myUser.uid,
                baseProvider.userFundWallet,
                baseProvider.augmontGoldRates.goldSellPrice,
                BaseUtil.toDouble(baseProvider.currentAugmontTxn
                    .augmnt[UserTransaction.subFldAugTotalGoldGm]),
                -1 * baseProvider.currentAugmontTxn.amount);

        ///check if balance updated correctly
        if (baseProvider.userFundWallet.augGoldBalance == _tempCurrentBalance) {
          //wallet balance was not updated. Transaction update failed
          Map<String, dynamic> _data = {
            'txn_id': baseProvider.currentAugmontTxn.docKey,
            'aug_tran_id': baseProvider
                .currentAugmontTxn.augmnt[UserTransaction.subFldAugTranId],
            'note':
                'Transaction completed, but found inconsistency while updating balance'
          };
          await dbProvider.logFailure(baseProvider.myUser.uid,
              FailType.UserAugmontWthdrwUpdateDiscrepancy, _data);
        }

        if (baseProvider.currentAugmontTxn.ticketUpCount > 0) {
          ///update user ticket count
          int _tempCurrentCount = baseProvider.userTicketWallet.augGold99Tck;
          baseProvider.userTicketWallet =
              await dbProvider.updateAugmontGoldUserTicketCount(
                  baseProvider.myUser.uid,
                  baseProvider.userTicketWallet,
                  -1 * baseProvider.currentAugmontTxn.ticketUpCount);

          ///check if ticket count updated correctly
          if (baseProvider.userTicketWallet.augGold99Tck == _tempCurrentCount) {
            //ticket count did not update
            Map<String, dynamic> _data = {
              'txn_id': baseProvider.currentAugmontTxn.docKey,
              'aug_tran_id': baseProvider
                  .currentAugmontTxn.augmnt[UserTransaction.subFldAugTranId],
              'note':
                  'Transaction completed, but found inconsistency while updating tickets'
            };
            await dbProvider.logFailure(baseProvider.myUser.uid,
                FailType.UserAugmontWthdrwUpdateDiscrepancy, _data);
          }
        }

        ///update UI and clear global variables
        baseProvider.currentAugmontTxn = null;
        baseProvider.userMiniTxnList = null; //make null so it refreshes
        _withdrawalDialogKey2.currentState.onTransactionProcessed(true);
      }
    } else {
      _withdrawalDialogKey2.currentState.onTransactionProcessed(false);
    }
  }

  List<Function> cardButtonFunctions = [() {}, () {}, () {}];
}
