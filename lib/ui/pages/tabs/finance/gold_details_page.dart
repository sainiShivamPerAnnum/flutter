import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/model/AugGoldRates.dart';
import 'package:felloapp/core/model/UserAugmontDetail.dart';
import 'package:felloapp/core/model/UserTransaction.dart';
import 'package:felloapp/core/ops/augmont_ops.dart';
import 'package:felloapp/core/ops/db_ops.dart';
import 'package:felloapp/core/ops/icici_ops.dart';
import 'package:felloapp/ui/dialogs/augmont_disabled_dialog.dart';
import 'package:felloapp/ui/elements/animated_line_chrt.dart';
import 'package:felloapp/ui/elements/faq_card.dart';
import 'package:felloapp/ui/elements/gold_profit_calculator.dart';
import 'package:felloapp/ui/modals/augmont_deposit_modal_sheet.dart';
import 'package:felloapp/ui/pages/onboarding/augmont/augmont_onboarding_page.dart';
import 'package:felloapp/ui/pages/tabs/finance/augmont_withdraw_screen.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/fail_types.dart';
import 'package:felloapp/util/icici_api_util.dart';
import 'package:felloapp/util/logger.dart';
import 'package:felloapp/util/size_config.dart';
import 'package:felloapp/util/ui_constants.dart';
import 'package:fl_animated_linechart/chart/area_line_chart.dart';
import 'package:fl_animated_linechart/chart/line_chart.dart';
import 'package:fl_animated_linechart/common/pair.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class GoldDetailsPage extends StatefulWidget {
  @override
  _GoldDetailsPageState createState() => _GoldDetailsPageState();
}

class _GoldDetailsPageState extends State<GoldDetailsPage> {
  Log log = new Log('GoldDetails');
  BaseUtil baseProvider;
  DBModel dbProvider;
  AugmontModel augmontProvider;
  ICICIModel iProvider;
  GlobalKey<AugmontDepositModalSheetState> _modalKey2 = GlobalKey();
  GlobalKey<AugmontOnboardingState> _onboardingKey = GlobalKey();
  GlobalKey<AugmontWithdrawScreenState> _withdrawalDialogKey2 = GlobalKey();
  double containerHeight = 10;
  Map<String, dynamic> _withdrawalRequestDetails;
  AugmontRates _currentBuyRates;
  AugmontRates _currentSellRates;
  static const int STATUS_UNAVAILABLE = 0;
  static const int STATUS_REGISTER = 1;
  static const int STATUS_OPEN = 2;

  @override
  Widget build(BuildContext context) {
    baseProvider = Provider.of<BaseUtil>(context, listen: false);
    dbProvider = Provider.of<DBModel>(context, listen: false);
    augmontProvider = Provider.of<AugmontModel>(context, listen: false);
    iProvider = Provider.of<ICICIModel>(context, listen: false);

    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, true);
        return true;
      },
      child: Scaffold(
        appBar: BaseUtil.getAppBar(),
        body: Column(
          children: [
            Expanded(
              child: Container(
                child: SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      FundInfo(),
                      FundGraph(),
                      FundDetailsTable(
                          baseProvider.userFundWallet.augGoldQuantity),
                      GoldProfitCalculator(),
                      FAQCard(Assets.goldFaqHeaders, Assets.goldFaqAnswers),
                      _buildBetaWithdrawButton(),
                    ],
                  ),
                ),
              ),
            ),
            _buildSaveButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildSaveButton() {
    return Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 0.07,
      decoration: BoxDecoration(
        gradient: new LinearGradient(colors: [
          UiConstants.primaryColor,
          UiConstants.primaryColor.withBlue(200),
        ], begin: Alignment(0.5, -1.0), end: Alignment(0.5, 1.0)),
      ),
      child: new Material(
        child: MaterialButton(
          child: (!baseProvider.isAugDepositRouteLogicInProgress)
              ? Text(
                  _getActionButtonText(),
                  style: Theme.of(context)
                      .textTheme
                      .button
                      .copyWith(color: Colors.white),
                )
              : SpinKitThreeBounce(
                  color: UiConstants.spinnerColor2,
                  size: 18.0,
                ),
          onPressed: () async {
            HapticFeedback.vibrate();
            baseProvider.isAugDepositRouteLogicInProgress = true;
            setState(() {});
            ///////////DUMMY///////////////////////////////////
            // baseProvider.iciciDetail =
            // await dbProvider.getUserIciciDetails(baseProvider.myUser.uid);
            // Navigator.of(context).pop();
            // Navigator.push(context, MaterialPageRoute(
            //   builder: (ctx) => DepositVerification(tranId: '3433559',userTxnId: 'tdcT4bxF0Gyv9qlhqmlx',
            //     panNumber: baseProvider.iciciDetail.panNumber,),
            // ));
            //////////////////////////////////////
            _onDepositClicked().then((value) {
              setState(() {});
            });
          },
          highlightColor: Colors.white30,
          splashColor: Colors.white30,
        ),
        color: Colors.transparent,
        borderRadius: new BorderRadius.circular(20.0),
      ),
    );
  }

  Widget _buildBetaWithdrawButton() {
    return Container(
      margin: EdgeInsets.symmetric(
        vertical: 16,
        horizontal: MediaQuery.of(context).size.height * 0.02,
      ),
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 0.05,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        gradient: new LinearGradient(
          colors: [
            Colors.blueGrey,
            Colors.blueGrey[800],
          ],
          begin: Alignment(0.5, -1.0),
          end: Alignment(0.5, 1.0),
        ),
      ),
      child: new Material(
        child: MaterialButton(
          child: (!baseProvider.isAugWithdrawRouteLogicInProgress)
              ? Text(
                  'WITHDRAW',
                  style: Theme.of(context)
                      .textTheme
                      .button
                      .copyWith(color: Colors.white),
                )
              : SpinKitThreeBounce(
                  color: UiConstants.spinnerColor2,
                  size: 18.0,
                ),
          onPressed: () async {
            if (!baseProvider.isAugWithdrawRouteLogicInProgress) {
              HapticFeedback.vibrate();
              _onWithdrawalClicked();
              // double amt = await augmontProvider.getGoldBalance();
              // log.debug(amt.toString());
            }
          },
          highlightColor: Colors.orange.withOpacity(0.5),
          splashColor: Colors.orange.withOpacity(0.5),
        ),
        color: Colors.transparent,
        borderRadius: new BorderRadius.circular(20.0),
      ),
    );
  }

  int _checkAugmontStatus() {
    //check who is allowed to deposit
    String _perm =
        BaseUtil.remoteConfig.getString('augmont_deposit_permission');
    int _isGeneralUserAllowed = 1;
    bool _isAllowed = false;
    if (_perm != null && _perm.isNotEmpty) {
      try {
        _isGeneralUserAllowed = int.parse(_perm);
      } catch (e) {
        _isGeneralUserAllowed = 1;
      }
    }
    if (_isGeneralUserAllowed == 0) {
      //General permission is denied. Check if specific user permission granted
      if (baseProvider.myUser.isAugmontEnabled != null &&
          baseProvider.myUser.isAugmontEnabled) {
        //this specific user is allowed to use Augmont
        _isAllowed = true;
      } else {
        _isAllowed = false;
      }
    } else {
      _isAllowed = true;
    }

    if (!_isAllowed)
      return STATUS_UNAVAILABLE;
    else if (baseProvider.myUser.isAugmontOnboarded == null ||
        baseProvider.myUser.isAugmontOnboarded == false)
      return STATUS_REGISTER;
    else
      return STATUS_OPEN;
  }

  String _getActionButtonText() {
    int _status = _checkAugmontStatus();
    if (_status == STATUS_UNAVAILABLE)
      return 'UNAVAILABLE';
    else if (_status == STATUS_REGISTER)
      return 'REGISTER';
    else
      return 'DEPOSIT';
  }

  Future<bool> _onDepositClicked() async {
    baseProvider.augmontDetail = (baseProvider.augmontDetail == null)
        ? (await dbProvider.getUserAugmontDetails(baseProvider.myUser.uid))
        : baseProvider.augmontDetail;
    int _status = _checkAugmontStatus();
    if (_status == STATUS_UNAVAILABLE) {
      baseProvider.isAugDepositRouteLogicInProgress = false;
      showDialog(
          context: context,
          builder: (BuildContext context) => AugmontDisabled());
      setState(() {});
      return true;
    } else if (_status == STATUS_REGISTER) {
      await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => AugmontOnboarding(
                    key: _onboardingKey,
                  )));
      baseProvider.isAugDepositRouteLogicInProgress = false;
      setState(() {});
      return true;
    } else {
      _currentBuyRates = await augmontProvider.getRates();
      baseProvider.isAugDepositRouteLogicInProgress = false;
      if (_currentBuyRates == null) {
        baseProvider.showNegativeAlert('Portal unavailable',
            'The current rates couldn\'t be loaded. Please try again', context);
        return false;
      } else {
        showModalBottomSheet(
            isDismissible: false,
            backgroundColor: Colors.transparent,
            context: context,
            isScrollControlled: true,
            builder: (context) {
              return AugmontDepositModalSheet(
                key: _modalKey2,
                onDepositConfirmed: (double amount) {
                  augmontProvider.initiateGoldPurchase(
                      _currentBuyRates, amount);
                  augmontProvider.setAugmontTxnProcessListener(
                      _onDepositTransactionComplete);
                },
                currentRates: _currentBuyRates,
              );
            });
      }
    }
    return true;
  }

  Future<void> _onDepositTransactionComplete(UserTransaction txn) async {
    if (txn.tranStatus == UserTransaction.TRAN_STATUS_COMPLETE) {
      if (baseProvider.currentAugmontTxn != null) {
        ///update augmont transaction closing balance and ticketupcount
        ///tickets will be based on amount spent, closing balance will be based on taxed amount
        baseProvider.currentAugmontTxn.ticketUpCount =
            baseProvider.getTicketCountForTransaction(
                baseProvider.currentAugmontTxn.amount);
        baseProvider.currentAugmontTxn.closingBalance =
            baseProvider.getUpdatedClosingBalance(baseProvider.currentAugmontTxn
                .augmnt[UserTransaction.subFldAugPostTaxTotal]);

        ///update user wallet object account balance and ticket count
        double _tempCurrentBalance = baseProvider.userFundWallet.augGoldBalance;
        baseProvider.userFundWallet =
            await dbProvider.updateUserAugmontGoldBalance(
                baseProvider.myUser.uid,
                baseProvider.userFundWallet,
                BaseUtil.toDouble(baseProvider.currentAugmontTxn
                    .augmnt[UserTransaction.subFldAugPostTaxTotal]),
                baseProvider.currentAugmontTxn
                    .augmnt[UserTransaction.subFldAugTotalGoldGm]);

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
              FailType.UserAugmontDepositUpdateDiscrepancy, _data);
        }

        ///update user transaction
        await dbProvider.updateUserTransaction(
            baseProvider.myUser.uid, baseProvider.currentAugmontTxn);

        ///update UI
        _modalKey2.currentState.onDepositComplete(true);
        augmontProvider.completeTransaction();
        return true;
      }
    } else if (txn.tranStatus == UserTransaction.TRAN_STATUS_CANCELLED) {
      //razorpay payment failed
      log.debug('Payment cancelled');
      if (baseProvider.currentAugmontTxn != null) {
        _modalKey2.currentState.onDepositComplete(false);
        augmontProvider.completeTransaction();
      }
    } else if (txn.tranStatus == UserTransaction.TRAN_STATUS_PENDING) {
      //razorpay completed but augmont purchase didnt go through
      log.debug('Payment pending');
      if (baseProvider.currentAugmontTxn != null) {
        _modalKey2.currentState.onDepositComplete(false);
        augmontProvider.completeTransaction();
      }
    }
  }

  _onWithdrawalClicked() async {
    HapticFeedback.vibrate();
    baseProvider.augmontDetail = (baseProvider.augmontDetail == null)
        ? (await dbProvider.getUserAugmontDetails(baseProvider.myUser.uid))
        : baseProvider.augmontDetail;
    if (!baseProvider.myUser.isAugmontOnboarded) {
      baseProvider.showNegativeAlert(
          'Not onboarded', 'You havent been onboarded to Augmont yet', context);
    } else if (baseProvider.userFundWallet.augGoldBalance == null ||
        baseProvider.userFundWallet.augGoldBalance == 0) {
      baseProvider.showNegativeAlert('No balance',
          'Your Augmont wallet has no balance presently', context);
    } else {
      baseProvider.isAugWithdrawRouteLogicInProgress = true;
      setState(() {});
      double _liveGoldQuantityBalance;
      try {
        _currentSellRates = await augmontProvider.getRates();
      } catch (e) {
        log.error('Failed to fetch current sell rates: $e');
      }
      try {
        _liveGoldQuantityBalance = await augmontProvider.getGoldBalance();
      } catch (e) {
        log.error('Failed to fetch current gold balance: $e');
      }
      if (_currentSellRates == null ||
          _liveGoldQuantityBalance == null ||
          _liveGoldQuantityBalance == 0) {
        baseProvider.isAugWithdrawRouteLogicInProgress = false;
        setState(() {});
        baseProvider.showNegativeAlert('Couldn\'t complete your request',
            'Please try again in some time', context);
      } else {
        baseProvider.isAugWithdrawRouteLogicInProgress = false;
        setState(() {});
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (ctx) => AugmontWithdrawScreen(
                key: _withdrawalDialogKey2,
                passbookBalance: _liveGoldQuantityBalance,
                sellRate: _currentSellRates.goldSellPrice,
                onAmountConfirmed: (Map<String, double> amountDetails) {
                  _onInitiateWithdrawal(amountDetails['withdrawal_amount']);
                },
                bankHolderName: baseProvider.augmontDetail.bankHolderName,
                bankAccNo: baseProvider.augmontDetail.bankAccNo,
                bankIfsc: baseProvider.augmontDetail.ifsc,
              ),
            ));
      }
    }
  }

  _onInitiateWithdrawal(double amt) {
    if (_currentSellRates != null && amt != null) {
      augmontProvider.initiateWithdrawal(_currentSellRates, amt);
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
                -1 * baseProvider.currentAugmontTxn.amount,
                baseProvider.currentAugmontTxn
                    .augmnt[UserTransaction.subFldAugTotalGoldGm]);

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

        ///update UI and clear global variables
        baseProvider.currentAugmontTxn = null;
        baseProvider.userMiniTxnList = null; //make null so it refreshes
        _withdrawalDialogKey2.currentState.onTransactionProcessed(true);
      }
    } else {
      _withdrawalDialogKey2.currentState.onTransactionProcessed(false);
    }
  }
}

class FundDetailsTable extends StatelessWidget {
  final double _goldBalance;

  FundDetailsTable(this._goldBalance);

  @override
  Widget build(BuildContext context) {
    double _height = MediaQuery.of(context).size.height;
    return Container(
      margin: EdgeInsets.all(
        _height * 0.02,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: <BoxShadow>[
          BoxShadow(
            offset: Offset(5, 5),
            blurRadius: 5,
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
            vertical: 20, horizontal: SizeConfig.screenWidth * 0.08),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              "images/svgs/gold.svg",
              height: SizeConfig.screenWidth * 0.07,
              // width: SizeConfig.screenWidth*0.05,
            ),
            SizedBox(
              width: 10,
            ),
            Text(
                'Current Gold Balance: ${_goldBalance.toStringAsFixed(4)} grams'),
          ],
        ),
      ),
    );
  }
}

class FundGraph extends StatelessWidget {
  final Map<DateTime, double> line1 = {
    DateTime.utc(2018, 03, 19): 3130,
    DateTime.utc(2018, 04, 29): 3199,
    DateTime.utc(2018, 05, 30): 3205,
    DateTime.utc(2018, 06, 10): 3152,
    DateTime.utc(2018, 07, 18): 3053,
    DateTime.utc(2018, 08, 03): 3118,
    DateTime.utc(2018, 09, 02): 3138,
    DateTime.utc(2018, 10, 04): 3281,
    DateTime.utc(2018, 12, 10): 3142,
    DateTime.utc(2019, 01, 25): 3223,
    DateTime.utc(2019, 02, 17): 3223,
    DateTime.utc(2019, 03, 12): 3443,
    DateTime.utc(2019, 04, 14): 3280,
    DateTime.utc(2019, 05, 18): 3279,
    DateTime.utc(2019, 06, 10): 3294,
    DateTime.utc(2019, 07, 18): 3466,
    DateTime.utc(2019, 08, 03): 3590,
    DateTime.utc(2019, 09, 02): 3994,
    DateTime.utc(2019, 10, 04): 3877,
    DateTime.utc(2019, 12, 10): 4008,
    DateTime.utc(2020, 01, 25): 3925,
    DateTime.utc(2020, 02, 17): 4026,
    DateTime.utc(2020, 03, 12): 4221,
    DateTime.utc(2020, 04, 14): 4347,
    DateTime.utc(2020, 05, 18): 4473,
    DateTime.utc(2020, 06, 10): 4650,
    DateTime.utc(2020, 07, 18): 4848,
    DateTime.utc(2020, 08, 03): 5050,
    DateTime.utc(2020, 09, 02): 5530,
    DateTime.utc(2020, 10, 04): 5340,
    DateTime.utc(2020, 12, 10): 5225,
    DateTime.utc(2021, 01, 25): 5141,
    DateTime.utc(2021, 02, 17): 4702,
    DateTime.utc(2021, 03, 12): 4588,
  };

  @override
  Widget build(BuildContext context) {
    double _height = MediaQuery.of(context).size.height;
    LineChart chart = AreaLineChart.fromDateTimeMaps(
      [line1],
      [UiConstants.primaryColor],
      ['₹'],
      gradients: [
        Pair(Colors.white, UiConstants.primaryColor.withOpacity(0.1))
      ],
    );
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: _height * 0.02,
      ),
      height: _height * 0.3,
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: CustomAnimatedLineChart(
          chart,
        ), //Unique key to force animations
      ),
    );
  }
}

class FundInfo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double _height = MediaQuery.of(context).size.height;
    double _width = MediaQuery.of(context).size.width;
    return Column(
      children: [
        Row(
          children: [
            Container(
              margin: EdgeInsets.only(
                left: _height * 0.02,
                top: _height * 0.02,
                bottom: _height * 0.02,
              ),
              width: _width * 0.2,
              child: Image.asset(Assets.augmontLogo, fit: BoxFit.contain),
            ),
            SizedBox(
              width: 10,
            ),
            Expanded(
              child: Text(
                "Augmont Digital Gold",
                textAlign: TextAlign.left,
                style: GoogleFonts.montserrat(
                    fontWeight: FontWeight.w700,
                    fontSize: SizeConfig.largeTextSize),
              ),
            ),
            SizedBox(
              width: _height * 0.02,
            )
          ],
        ),
        Padding(
          padding: EdgeInsets.only(bottom: _height * 0.02, left: 20, right: 30),
          child: Text(
            'A strong asset with a 17% growth rate over the past 3 years. Augmont is the leading ' +
                'gold bullion of India. Invest in 24K digital gold ' +
                'with 999 purity.',
            textAlign: TextAlign.center,
            style: TextStyle(
                color: UiConstants.accentColor, fontStyle: FontStyle.italic),
          ),
        ),
      ],
    );
  }
}

class FundDetailsCell extends StatelessWidget {
  final String title, data, info;

  FundDetailsCell({
    @required this.data,
    @required this.title,
    @required this.info,
  });

  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    return Container(
      height: 75,
      width: _width * 0.5,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(
              top: 10,
              left: 20,
            ),
            child: Row(
              children: [
                Text(
                  "$title ",
                ),
                GestureDetector(
                  child: Icon(
                    Icons.info_outline,
                    size: 12,
                    color: UiConstants.spinnerColor,
                  ),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => new AlertDialog(
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(UiConstants.padding),
                        ),
                        title: new Text(title),
                        content: Text(info),
                        actions: <Widget>[
                          new TextButton(
                            onPressed: () {
                              Navigator.of(context, rootNavigator: true)
                                  .pop(); // dismisses only the dialog and returns nothing
                            },
                            child: new Text(
                              'OK',
                              style: TextStyle(
                                color: UiConstants.primaryColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                )
              ],
            ),
          ),
          Expanded(
            child: Center(
              child: Text(data,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 22,
                    color: Colors.black54,
                  )),
            ),
          )
        ],
      ),
    );
  }
}
