//Project Imports
import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/base_remote_config.dart';
import 'package:felloapp/core/enums/pagestate.dart';
import 'package:felloapp/core/enums/screen_item.dart';
import 'package:felloapp/core/fcm_listener.dart';
import 'package:felloapp/core/model/base_user_model.dart';
import 'package:felloapp/core/model/user_transaction_model.dart';
import 'package:felloapp/core/ops/augmont_ops.dart';
import 'package:felloapp/core/ops/db_ops.dart';
import 'package:felloapp/core/ops/icici_ops.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/ui/dialogs/augmont_disabled_dialog.dart';
import 'package:felloapp/ui/elements/Texts/marquee_text.dart';
import 'package:felloapp/ui/elements/faq_card.dart';
import 'package:felloapp/ui/elements/plots/fund_graph.dart';
import 'package:felloapp/ui/elements/profit_calculator.dart';
import 'package:felloapp/ui/modals_sheets/augmont_deposit_modal_sheet.dart';
import 'package:felloapp/ui/modals_sheets/augmont_register_modal_sheet.dart';
import 'package:felloapp/ui/pages/tabs/finance/augmont/augmont_withdraw_screen.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/fail_types.dart';
import 'package:felloapp/util/fcm_topics.dart';
import 'package:felloapp/util/haptic.dart';
import 'package:felloapp/util/logger.dart';
import 'package:felloapp/util/styles/palette.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/ui_constants.dart';

//Dart and Flutter Imports
import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

//Pub Imports
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class AugmontDetailsPage extends StatefulWidget {
  static const int STATUS_UNAVAILABLE = 0;
  static const int STATUS_REGISTER = 1;
  static const int STATUS_OPEN = 2;

  @override
  _AugmontDetailsPageState createState() => _AugmontDetailsPageState();

  static int checkAugmontStatus(BaseUser baseUser) {
    //check who is allowed to deposit
    String _perm = BaseRemoteConfig.remoteConfig
        .getString(BaseRemoteConfig.AUGMONT_DEPOSIT_PERMISSION);
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
      if (baseUser.isAugmontEnabled != null && baseUser.isAugmontEnabled) {
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
    else if (baseUser.isAugmontOnboarded == null ||
        baseUser.isAugmontOnboarded == false)
      return STATUS_REGISTER;
    else
      return STATUS_OPEN;
  }
}

class _AugmontDetailsPageState extends State<AugmontDetailsPage> {
  Log log = new Log('GoldDetails');
  BaseUtil baseProvider;
  DBModel dbProvider;
  AugmontModel augmontProvider;
  FcmListener fcmProvider;
  ICICIModel iProvider;
  AppState appState;
  GlobalKey<AugmontDepositModalSheetState> _modalKey2 = GlobalKey();
  // GlobalKey<AugmontOnboardingState> _onboardingKey = GlobalKey();
  GlobalKey<AugmontWithdrawScreenState> _withdrawalDialogKey2 = GlobalKey();
  double containerHeight = 10;
  double _withdrawableGoldQnty;

  @override
  Widget build(BuildContext context) {
    baseProvider = Provider.of<BaseUtil>(context, listen: false);
    dbProvider = Provider.of<DBModel>(context, listen: false);
    augmontProvider = Provider.of<AugmontModel>(context, listen: false);
    iProvider = Provider.of<ICICIModel>(context, listen: false);
    fcmProvider = Provider.of<FcmListener>(context, listen: false);
    appState = Provider.of<AppState>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: FelloColorPalette.augmontFundPalette().secondaryColor,
        iconTheme: IconThemeData(color: Colors.white),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("images/augmont-share.png",
                height: kToolbarHeight * 0.4),
            SizedBox(width: 5),
            FittedBox(
              child: Text(
                "Augmont Gold",
                style: GoogleFonts.montserrat(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        actions: [IconButton(onPressed: () {}, icon: SizedBox())],
      ),

      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                MarqueeText(
                  infoList: [
                    "24k Digital Gold",
                    "99.99% Purity",
                    "26% growth in the past 2 years",
                    "India's favored gold bullion"
                  ],
                  showBullet: true,
                ),
                Container(
                    margin: EdgeInsets.only(top: kToolbarHeight / 2),
                    width: SizeConfig.screenWidth,
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: LineChartWidget()),
                FundDetailsTable(baseProvider.userFundWallet.augGoldQuantity),
                // GoldProfitCalculator(),
                ProfitCalculator(
                  calFactor: (0.17 / 12),
                  invGradient: [
                    FelloColorPalette.augmontFundPalette()
                        .secondaryColor
                        .withBlue(800),
                    FelloColorPalette.augmontFundPalette().secondaryColor
                  ],
                  retGradient: [
                    FelloColorPalette.augmontFundPalette().primaryColor,
                    FelloColorPalette.augmontFundPalette().primaryColor2
                  ],
                ),
                FAQCard(Assets.goldFaqHeaders, Assets.goldFaqAnswers,
                    FelloColorPalette.augmontFundPalette().primaryColor),
                _buildBetaWithdrawButton(),
              ],
            ),
          ),
          Positioned(bottom: 0, child: _buildSaveButton()),
        ],
      ),
      // ),
    );
  }

  Widget _buildSaveButton() {
    return Container(
      width: SizeConfig.screenWidth,
      height: MediaQuery.of(context).size.height * 0.07,
      decoration: BoxDecoration(
        gradient: new LinearGradient(colors: [
          // UiConstants.primaryColor,
          // UiConstants.primaryColor.withBlue(200),
          FelloColorPalette.augmontFundPalette().primaryColor,
          FelloColorPalette.augmontFundPalette().primaryColor2
        ], begin: Alignment(0.5, -1.0), end: Alignment(0.5, 1.0)),
      ),
      child: new Material(
        child: MaterialButton(
          child: (!baseProvider.isAugDepositRouteLogicInProgress)
              ? Consumer<BaseUtil>(
                  builder: (ctx, bp, child) {
                    return Text(
                      _getActionButtonText(),
                      style: Theme.of(context)
                          .textTheme
                          .button
                          .copyWith(color: Colors.white),
                    );
                  },
                )
              : SpinKitThreeBounce(
                  color: UiConstants.spinnerColor2,
                  size: 18.0,
                ),
          onPressed: () async {
            if (await baseProvider.showNoInternetAlert(context)) return;

            Haptic.vibrate();
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
      margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).size.height * 0.1,
          left: SizeConfig.blockSizeHorizontal * 5,
          right: SizeConfig.blockSizeHorizontal * 5,
          top: 8),
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 0.05,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        gradient: new LinearGradient(
          colors: [
            FelloColorPalette.augmontFundPalette().secondaryColor.withBlue(800),
            FelloColorPalette.augmontFundPalette().secondaryColor,
            //Colors.blueGrey,
            //Colors.blueGrey[800],
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
            if (await baseProvider.showNoInternetAlert(context)) return;

            if (!baseProvider.isAugWithdrawRouteLogicInProgress) {
              Haptic.vibrate();
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

  String _getActionButtonText() {
    int _status = AugmontDetailsPage.checkAugmontStatus(baseProvider.myUser);
    if (_status == AugmontDetailsPage.STATUS_UNAVAILABLE)
      return 'UNAVAILABLE';
    else if (_status == AugmontDetailsPage.STATUS_REGISTER)
      return 'REGISTER';
    else
      return 'SAVE';
  }

  Future<bool> _onDepositClicked() async {
    baseProvider.augmontDetail = (baseProvider.augmontDetail == null)
        ? (await dbProvider.getUserAugmontDetails(baseProvider.myUser.uid))
        : baseProvider.augmontDetail;
    int _status = AugmontDetailsPage.checkAugmontStatus(baseProvider.myUser);
    if (_status == AugmontDetailsPage.STATUS_UNAVAILABLE) {
      baseProvider.isAugDepositRouteLogicInProgress = false;
      showDialog(
          context: context,
          builder: (BuildContext context) => AugmontDisabled());
      setState(() {});
      return true;
    } else if (_status == AugmontDetailsPage.STATUS_REGISTER) {
      // await Navigator.push(
      //     context,
      //     MaterialPageRoute(
      //         builder: (context) => AugmontOnboarding(
      //               key: _onboardingKey,
      //             )));
      // appState.currentAction = PageAction(
      //     state: PageState.addWidget,
      //     widget: AugmontOnboarding(
      //       key: _onboardingKey,
      //     ),
      //     page: AugOnboardPageConfig);
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
            return AugmontRegisterModalSheet();
          });

      baseProvider.isAugDepositRouteLogicInProgress = false;
      setState(() {});
      return true;
    } else {
      baseProvider.augmontGoldRates =
          await augmontProvider.getRates(); //refresh rates
      baseProvider.isAugDepositRouteLogicInProgress = false;
      if (baseProvider.augmontGoldRates == null) {
        baseProvider.showNegativeAlert('Portal unavailable',
            'The current rates couldn\'t be loaded. Please try again', context);
        return false;
      } else {
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
              return AugmontDepositModalSheet(
                key: _modalKey2,
                onDepositConfirmed: (double amount) {
                  augmontProvider.initiateGoldPurchase(
                      baseProvider.augmontGoldRates, amount);
                  augmontProvider.setAugmontTxnProcessListener(
                      _onDepositTransactionComplete);
                },
                currentRates: baseProvider.augmontGoldRates,
              );
            });
      }
    }
    return true;
  }

  Future<void> _onDepositTransactionComplete(UserTransaction txn) async {
    if (txn.tranStatus == UserTransaction.TRAN_STATUS_COMPLETE) {
      if (baseProvider.currentAugmontTxn != null) {
        ///update user wallet object account balance
        double _tempCurrentBalance = baseProvider.userFundWallet.augGoldBalance;
        baseProvider.userFundWallet =
            await dbProvider.updateUserAugmontGoldBalance(
                baseProvider.myUser.uid,
                baseProvider.userFundWallet,
                baseProvider.augmontGoldRates.goldSellPrice,
                baseProvider.currentAugmontTxn
                    .augmnt[UserTransaction.subFldAugTotalGoldGm],
                baseProvider.currentAugmontTxn.amount);

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

        ///update user ticket count
        ///tickets will be updated based on total amount spent
        int _ticketUpdateCount = baseProvider.getTicketCountForTransaction(
            baseProvider.currentAugmontTxn.amount);
        if (_ticketUpdateCount > 0) {
          int _tempCurrentCount = baseProvider.userTicketWallet.augGold99Tck;
          baseProvider.userTicketWallet =
              await dbProvider.updateAugmontGoldUserTicketCount(
                  baseProvider.myUser.uid,
                  baseProvider.userTicketWallet,
                  _ticketUpdateCount);

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
                FailType.UserAugmontDepositUpdateDiscrepancy, _data);
          }
        }

        ///update user transaction
        ///update augmont transaction closing balance and ticketupcount
        ///closing balance will be based on taxed amount
        baseProvider.currentAugmontTxn.ticketUpCount = _ticketUpdateCount;
        baseProvider.currentAugmontTxn.closingBalance =
            baseProvider.getCurrentTotalClosingBalance();
        await dbProvider.updateUserTransaction(
            baseProvider.myUser.uid, baseProvider.currentAugmontTxn);

        ///if this was the user's first investment
        ///- update AugmontDetail obj
        ///- add notification subscription
        if (!baseProvider.augmontDetail.firstInvMade) {
          baseProvider.augmontDetail.firstInvMade = true;
          bool _aflag = await dbProvider.updateUserAugmontDetails(
              baseProvider.myUser.uid, baseProvider.augmontDetail);
          if (_aflag) {
            fcmProvider.removeSubscription(FcmTopic.MISSEDCONNECTION);
            fcmProvider.addSubscription(FcmTopic.GOLDINVESTOR);
          }
        }

        ///check if referral bonuses need to be unlocked
        if (baseProvider.userFundWallet.augGoldPrinciple >=
            BaseRemoteConfig.UNLOCK_REFERRAL_AMT) {
          bool _isUnlocked =
              await dbProvider.unlockReferralTickets(baseProvider.myUser.uid);
          if (_isUnlocked) {
            //give it a few seconds before showing congratulatory message
            Timer(const Duration(seconds: 4), () {
              baseProvider.showPositiveAlert('Congratulations are in order!',
                  'Your referral bonus has been unlocked 🎉', context);
            });
          }
        }

        ///update UI
        _modalKey2.currentState.onDepositComplete(true);
        augmontProvider.completeTransaction();
        baseProvider.refreshAugmontBalance();
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
    Haptic.vibrate();
    baseProvider.augmontDetail = (baseProvider.augmontDetail == null)
        ? (await dbProvider.getUserAugmontDetails(baseProvider.myUser.uid))
        : baseProvider.augmontDetail;
    if (!baseProvider.myUser.isAugmontOnboarded) {
      baseProvider.showNegativeAlert(
          'Not onboarded', 'You havent been onboarded to Augmont yet', context);
    } else if (baseProvider.userFundWallet.augGoldQuantity == null ||
        baseProvider.userFundWallet.augGoldQuantity == 0) {
      baseProvider.showNegativeAlert('No Balance Available',
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
        appState.currentAction = PageAction(
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
}

class FundDetailsTable extends StatelessWidget {
  final double _goldBalance;

  FundDetailsTable(this._goldBalance);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        left: SizeConfig.globalMargin,
        right: SizeConfig.globalMargin,
        bottom: 24,
        top: 16,
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
            vertical: 20, horizontal: SizeConfig.screenWidth * 0.05),
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
              'Current Gold Balance: ${_goldBalance.toStringAsFixed(4)} grams',
              style: TextStyle(
                fontSize: SizeConfig.mediumTextSize,
              ),
            ),
          ],
        ),
      ),
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
                          borderRadius: BorderRadius.circular(
                              SizeConfig.cardBorderRadius),
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
