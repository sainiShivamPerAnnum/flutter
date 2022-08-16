//Project Imports

import 'package:felloapp/base_util.dart';
import 'dart:math' as math;
import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/core/enums/screen_item_enum.dart';
import 'package:felloapp/core/enums/user_service_enum.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/ui/architecture/base_view.dart';
import 'package:felloapp/ui/dialogs/confirm_action_dialog.dart';
import 'package:felloapp/ui/pages/others/finance/augmont/augmont_gold_sell/augmont_gold_sell_vm.dart';
import 'package:felloapp/ui/pages/others/finance/augmont/edit_augmont_bank_details.dart';
import 'package:felloapp/ui/pages/static/FelloTile.dart';
import 'package:felloapp/ui/pages/static/fello_appbar.dart';
import 'package:felloapp/ui/pages/static/gold_rate_card.dart';
import 'package:felloapp/ui/pages/static/home_background.dart';
import 'package:felloapp/ui/widgets/buttons/fello_button/large_button.dart';
import 'package:felloapp/ui/widgets/buttons/nav_buttons/nav_buttons.dart';
import 'package:felloapp/ui/widgets/helpers/inner_shadow.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/constants.dart';
import 'package:felloapp/util/haptic.dart';
import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/logger.dart';
import 'package:felloapp/util/styles/palette.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
//Pub Imports
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:property_change_notifier/property_change_notifier.dart';
import 'package:provider/provider.dart';

class AugmontGoldSellView extends StatefulWidget {
  final double passbookBalance;
  final double withdrawableGoldQnty;
  final double sellRate;
  final String bankHolderName;
  final String bankAccNo;
  final String bankIfsc;
  final ValueChanged<Map<String, double>> onAmountConfirmed;

  AugmontGoldSellView(
      {Key key,
      this.passbookBalance,
      this.withdrawableGoldQnty,
      this.sellRate,
      this.bankHolderName,
      this.bankAccNo,
      this.bankIfsc,
      this.onAmountConfirmed})
      : super(key: key);

  @override
  State createState() => AugmontGoldSellViewState();
}

class AugmontGoldSellViewState extends State<AugmontGoldSellView>
    with SingleTickerProviderStateMixin {
  final Log log = new Log('AugmontGoldSellView');
  TextEditingController _quantityController = TextEditingController();
  BaseUtil baseProvider;
  AppState appState;
  String _amountError;
  String _errorMessage;
  bool _isLoading = false;
  double _width;
  bool _isInitialised = false;
  double _scale;
  AnimationController _controller;

  var scaleAnimation;

  final TextStyle tTextStyle =
      TextStyle(fontSize: 18, fontWeight: FontWeight.w300);
  final TextStyle gTextStyle =
      TextStyle(fontSize: 18, fontWeight: FontWeight.bold);

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: Duration(
        milliseconds: 200,
      ),
      // lowerBound: 0.0,
      // upperBound: 0.1,
    )..addListener(() {
        setState(() {});
      });

    scaleAnimation = new Tween(
      begin: 1.0,
      end: 1.2,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.bounceOut));
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _width = MediaQuery.of(context).size.width;
    baseProvider = Provider.of<BaseUtil>(context);
    appState = Provider.of<AppState>(context, listen: false);
    S locale = S.of(context);
    return BaseView<AugmontGoldSellViewModel>(
      onModelReady: (model) {
        model.init();
      },
      builder: (ctx, model, child) => Scaffold(
        backgroundColor: UiConstants.kSecondaryBackgroundColor,
        resizeToAvoidBottomInset: false,
        body: Column(
          children: [
            FelloAppBar(
              leading: FelloAppBarBackButton(),
              title: "Sell Digital Gold",
            ),
            Stack(
              fit: StackFit.loose,
              children: [
                Container(
                  height: SizeConfig.screenWidth * 1.72,
                  margin: EdgeInsets.all(SizeConfig.pageHorizontalMargins),
                  padding: EdgeInsets.symmetric(
                      horizontal: SizeConfig.padding24,
                      vertical: SizeConfig.padding20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(SizeConfig.roundness32),
                    color: UiConstants.kModalSheetBackgroundColor,
                  ),
                  child: SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    child: Padding(
                        padding: EdgeInsets.only(
                            top: 10, bottom: 0, left: 10, right: 10),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Transform(
                                  alignment: Alignment.center,
                                  transform: Matrix4.rotationY(math.pi),
                                  child: Image.asset(
                                    Assets.digitalGoldBar,
                                    height: SizeConfig.screenWidth * 0.18,
                                    width: SizeConfig.screenWidth * 0.18,
                                  ),
                                ),
                                SizedBox(
                                  width: SizeConfig.padding10,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Digital Gold',
                                      style: TextStyles.rajdhaniM.body1,
                                    ),
                                    Text(
                                      'Safest digital investment',
                                      style: TextStyles.sourceSans.body4
                                          .colour(UiConstants.kTextColor2),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(
                              height: SizeConfig.padding80,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Saleable Gold Balance',
                                  style: TextStyles.sourceSans.body3
                                      .colour(UiConstants.kTextColor2),
                                ),
                                PropertyChangeConsumer<UserService,
                                    UserServiceProperties>(
                                  properties: [
                                    UserServiceProperties.myUserFund
                                  ],
                                  builder: (ctx, model, child) => Text(
                                    locale.saveGoldBalanceValue(
                                        model.userFundWallet.augGoldQuantity ??
                                            0.0),
                                    style: TextStyles.sourceSansSB.body0
                                        .colour(UiConstants.kTextColor),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: SizeConfig.padding10,
                            ),
                            Container(
                              height: SizeConfig.screenWidth * 0.22,
                              width: SizeConfig.screenWidth,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                      SizeConfig.roundness12),
                                  border: Border.all(
                                      color: Colors.grey.withOpacity(0.4),
                                      width: 0.5,
                                      style: BorderStyle.solid)),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    height: SizeConfig.screenWidth * 0.22,
                                    width: SizeConfig.screenWidth * 0.35,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(
                                            SizeConfig.roundness12,
                                          ),
                                          bottomLeft: Radius.circular(
                                            SizeConfig.roundness12,
                                          )),
                                      child: TextField(
                                        focusNode: model.sellFieldNode,
                                        enabled: !model.isGoldSellInProgress,
                                        controller: model.goldAmountController,
                                        enableInteractiveSelection: false,
                                        cursorHeight: SizeConfig.padding46,
                                        keyboardType:
                                            TextInputType.numberWithOptions(
                                                decimal: true, signed: true),
                                        style: TextStyles.rajdhaniSB.body0,
                                        onChanged: (val) {
                                          model.goldSellGrams =
                                              double.tryParse(val);
                                          model.updateGoldAmount();
                                        },
                                        showCursor: false,
                                        textInputAction: TextInputAction.done,
                                        decoration: InputDecoration(
                                          contentPadding: EdgeInsets.symmetric(
                                              vertical: SizeConfig.padding32,
                                              horizontal: SizeConfig.padding10),
                                          fillColor: UiConstants
                                              .kFAQDividerColor
                                              .withOpacity(0.5),
                                          filled: true,
                                          suffix: Text("gms  ",
                                              style: TextStyles.rajdhaniSB.body1
                                                  .colour(
                                                      UiConstants.kTextColor)),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(
                                                  SizeConfig.roundness12,
                                                ),
                                                bottomLeft: Radius.circular(
                                                  SizeConfig.roundness12,
                                                )),
                                            borderSide: BorderSide(
                                                width: 0,
                                                style: BorderStyle.none,
                                                color: Colors.transparent),
                                          ),
                                          focusedBorder: InputBorder.none,
                                          disabledBorder: InputBorder.none,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: SizeConfig.screenWidth * 0.36,
                                    height: SizeConfig.screenWidth * 0.22,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(
                                            SizeConfig.roundness12),
                                        bottomRight: Radius.circular(
                                            SizeConfig.roundness12),
                                      ),
                                      color: UiConstants
                                          .kModalSheetBackgroundColor,
                                    ),
                                    padding: EdgeInsets.only(
                                        left: SizeConfig.padding10),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        FittedBox(
                                          alignment: Alignment.center,
                                          child: Text(
                                            "₹ ${model.goldAmountFromGrams.toStringAsFixed(1)}",
                                            style: TextStyles.sourceSansSB.body1
                                                .colour(UiConstants
                                                    .kModalSheetMutedTextBackgroundColor),
                                          ),
                                        ),
                                        FittedBox(
                                          alignment: Alignment.center,
                                          child: CurrentPriceWidget(
                                            fetchGoldRates:
                                                model.fetchGoldRates,
                                            goldprice:
                                                model.goldSellPrice ?? 0.0,
                                            isFetching:
                                                model.isGoldRateFetching,
                                            mini: true,
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                            SizedBox(
                              height: SizeConfig.padding20,
                            ),
                          ],
                        )),
                  ),
                ),
                SizedBox(
                  height: SizeConfig.padding20,
                ),
                Container(
                  height: SizeConfig.screenWidth * 1.4,
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: EdgeInsets.only(
                        left: SizeConfig.padding34,
                        right: SizeConfig.padding34,
                        bottom:
                            MediaQuery.of(context).viewInsets.bottom * 0.5 ??
                                0),
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        text:
                            "Your balance will be credited to your registered bank account within 1-2 business working days",
                        style: TextStyles.body4.colour(Colors.grey),
                      ),
                    ),
                  ),
                ),
                (baseProvider.checkKycMissing)
                    ? _addKycInfoWidget()
                    : Container(),
                (_checkBankInfoMissing) ? _addBankInfoWidget() : Container(),
                (baseProvider.checkKycMissing || _checkBankInfoMissing)
                    ? Container()
                    : Container(
                        height: SizeConfig.screenWidth * 1.6,
                        alignment: Alignment.bottomCenter,
                        padding: EdgeInsets.symmetric(
                            horizontal: SizeConfig.padding64),
                        child: Container(
                          margin: EdgeInsets.only(top: SizeConfig.padding24),
                          width: SizeConfig.screenWidth,
                          child: FelloButtonLg(
                            child: model.isGoldSellInProgress
                                ? SpinKitThreeBounce(
                                    color: Colors.white,
                                    size: 20,
                                  )
                                : Text(
                                    "SELL",
                                    style: TextStyles.body2
                                        .colour(Colors.white)
                                        .bold,
                                  ),
                            onPressed: () {
                              if (!model.isGoldSellInProgress &&
                                  !model.isQntFetching) {
                                FocusScope.of(context).unfocus();
                                model.initiateSell();
                              }
                            },
                          ),
                        ),
                      ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  _buildNonWithdrawString(AugmontGoldSellViewModel model) {
    DateTime _dt = new DateTime.now()
        .add(Duration(days: Constants.AUG_GOLD_WITHDRAW_OFFSET));
    String _dtStr = DateFormat("dd MMMM").format(_dt);
    int _hrs = Constants.AUG_GOLD_WITHDRAW_OFFSET * 24;

    return '${model.nonWithdrawableQnt} grams is locked. Digital Gold can be withdrawn after $_hrs hours of successful deposit.';
  }

  dialogContent(BuildContext context) {
    return;
  }

  Widget _addBankInfoWidget() {
    return FelloBriefTile(
      leadingAsset: Assets.wmtsaveMoney,
      title: "Add bank information",
      onTap: () {
        AppState.delegate.appState.currentAction = PageAction(
            page: EditAugBankDetailsPageConfig, state: PageState.addPage);
      },
    );
  }

  Widget _addKycInfoWidget() {
    return FelloBriefTile(
      leadingIcon: Icons.verified_user,
      title: "Complete your KYC to withdraw",
      onTap: () {
        AppState.delegate.appState.currentAction =
            PageAction(page: KycDetailsPageConfig, state: PageState.addPage);
      },
      // onTap: () {
      //   AppState.screenStack.add(ScreenItem.dialog);
      //   showModalBottomSheet(
      //       isDismissible: false,
      //       // backgroundColor: Colors.transparent,
      //       shape: RoundedRectangleBorder(
      //         borderRadius: BorderRadius.circular(16),
      //       ),
      //       context: context,
      //       isScrollControlled: true,
      //       builder: (context) {
      //         return SimpleKycModalSheetView();
      //       });
      // },
    );
  }

  Widget _getGoldAmount(String qnt) {
    if (qnt == null || qnt.isEmpty) return Container();
    double _gQnt = 0;
    try {
      _gQnt = double.parse(qnt);
    } catch (e) {
      return Container();
    }
    if (_gQnt == null || _gQnt < 0.0001)
      return Container();
    else {
      double _goldAmt = BaseUtil.digitPrecision(_gQnt * widget.sellRate);
      bool _isValid = (_goldAmt > _getTotalGoldAvailable());
      return Text(
        ' = ₹ ${_goldAmt.toStringAsFixed(2)}',
        textAlign: TextAlign.start,
        style: TextStyle(
            color: (_isValid) ? Colors.red : Colors.black87,
            fontSize: SizeConfig.mediumTextSize * 1.2,
            fontWeight: FontWeight.bold),
      );
    }
  }

  double _getTotalGoldAvailable() {
    if (widget.sellRate != null && widget.withdrawableGoldQnty != null) {
      double _net = BaseUtil.digitPrecision(
          widget.sellRate * widget.withdrawableGoldQnty);
      return _net;
    }
    return 0;
  }

  onTransactionProcessed(bool flag) {
    baseProvider.activeGoldWithdrawalQuantity = 0;
    _isLoading = false;
    setState(() {});
    if (baseProvider.withdrawFlowStackCount == 1)
      Navigator.of(context).pop();
    else {
      Navigator.of(context).pop();
      Navigator.of(context).pop();
    }
    if (!flag) {
      BaseUtil.showNegativeAlert('Withdrawal Failed',
          'Please try again in some time or contact us for assistance',
          seconds: 5);
    } else {
      BaseUtil.showPositiveAlert('Withdrawal Request is now processing',
          'We will inform you once the withdrawal is complete!');
    }
  }

  Widget _buildSubmitButton(BuildContext context) {
    LinearGradient _gradient = new LinearGradient(colors: [
      FelloColorPalette.augmontFundPalette().secondaryColor.withBlue(800),
      FelloColorPalette.augmontFundPalette().secondaryColor,
      //Colors.blueGrey,
      //Colors.blueGrey[800],
    ], begin: Alignment(0.5, -1.0), end: Alignment(0.5, 1.0));

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        FelloButtonLg(
          color: FelloColorPalette.augmontFundPalette().secondaryColor,
          child: Text(
            _checkBankInfoMissing ? 'PROCEED' : 'WITHDRAW ',
            style: TextStyles.body2.colour(Colors.white),
          ),
          onPressed: () async {
            Haptic.vibrate();
            FocusScope.of(context).unfocus();
            if (BaseUtil.showNoInternetAlert()) return;
            if (baseProvider.checkKycMissing) {
              _controller.forward().then((value) => _controller.reverse());
            } else {
              if (widget.withdrawableGoldQnty == 0.0) {
                BaseUtil.showNegativeAlert(
                  'Unable to process',
                  'Your withdrawable balance is low',
                );
                return;
              }
              final amtErr = _validateAmount(_quantityController.text);
              if (amtErr != null) {
                setState(() {
                  _amountError = amtErr;
                });
                return;
              }
              setState(() {
                _amountError = null;
              });
              if (_amountError == null) {
                baseProvider.activeGoldWithdrawalQuantity =
                    double.parse(_quantityController.text);
                if (_checkBankInfoMissing) {
                  appState.currentAction = PageAction(
                      state: PageState.addWidget,
                      page: EditAugBankDetailsPageConfig,
                      widget: EditAugmontBankDetail(
                        isWithdrawFlow: true,
                        addBankComplete: () {
                          baseProvider.withdrawFlowStackCount = 2;
                          widget.onAmountConfirmed({
                            'withdrawal_quantity':
                                baseProvider.activeGoldWithdrawalQuantity,
                          });
                        },
                      ));
                } else {
                  String _confirmMsg =
                      "Are you sure you want to continue? ${baseProvider.activeGoldWithdrawalQuantity} grams of digital gold shall be processed.";
                  AppState.screenStack.add(ScreenItem.dialog);
                  showDialog(
                    context: context,
                    builder: (ctx) => ConfirmActionDialog(
                      title: "Please confirm your action",
                      description: _confirmMsg,
                      buttonText: "Withdraw",
                      cancelBtnText: 'Cancel',
                      confirmAction: () {
                        _isLoading = true;
                        setState(() {});
                        baseProvider.withdrawFlowStackCount = 1;
                        widget.onAmountConfirmed({
                          'withdrawal_quantity':
                              baseProvider.activeGoldWithdrawalQuantity,
                        });
                        return true;
                      },
                      cancelAction: () {
                        return false;
                      },
                    ),
                  );
                }
              }
            }
          },
        ),
      ],
    );
  }

  bool get _checkBankInfoMissing => (baseProvider.augmontDetail == null ||
      baseProvider.augmontDetail.bankAccNo == null ||
      baseProvider.augmontDetail.bankAccNo.isEmpty ||
      baseProvider.augmontDetail.bankHolderName.isEmpty ||
      baseProvider.augmontDetail.bankHolderName == null ||
      baseProvider.augmontDetail.ifsc.isEmpty ||
      baseProvider.augmontDetail.ifsc == null);

  _buildRow(String title, String value) {
    return ListTile(
      title: Container(
        width: SizeConfig.screenWidth * 0.2,
        child: Text(
          '$title: ',
          style: TextStyle(
            color: UiConstants.accentColor,
            fontSize: SizeConfig.mediumTextSize,
          ),
        ),
      ),
      trailing: Container(
        width: SizeConfig.screenWidth * 0.4,
        child: Text(
          value,
          overflow: TextOverflow.clip,
          style: TextStyle(
            color: Colors.black54,
            fontSize: SizeConfig.mediumTextSize,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  _buildLockedGoldRow(
      String title, String value, AugmontGoldSellViewModel model) {
    double _rem_gold =
        model.userFundWallet.augGoldQuantity - widget.withdrawableGoldQnty;
    return ListTile(
      title: Container(
        width: SizeConfig.screenWidth * 0.2,
        child: Text(
          '$title: ',
          style: TextStyle(
            color: UiConstants.accentColor,
            fontSize: SizeConfig.mediumTextSize,
          ),
        ),
      ),
      trailing: Container(
        width: SizeConfig.screenWidth * 0.4,
        child: GestureDetector(
          child: Row(
            children: [
              Text(
                '$value ',
                overflow: TextOverflow.clip,
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: SizeConfig.mediumTextSize,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Icon(
                Icons.info_outline,
                size: 14,
                color: UiConstants.spinnerColor,
              ),
            ],
          ),
          onTap: () {
            Haptic.vibrate();
            showDialog(
              context: context,
              builder: (context) => new AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(SizeConfig.cardBorderRadius),
                ),
                title: new Text(title),
                content: Text(
                    'All gold deposits are available for withdrawal after ${Constants.AUG_GOLD_WITHDRAW_OFFSET * 24} hours. The ${_rem_gold.toStringAsFixed(4)} grams can be withdrawn tomorrow.'),
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
        ),
      ),
    );
  }

  String _validateAmount(String value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a valid amount';
    }
    try {
      Pattern pattern = "^[0-9.]*\$";
      RegExp amRegex = RegExp(pattern);
      if (!amRegex.hasMatch(value)) {
        return 'Please enter a valid amount';
      }
      List<String> fractionalPart = value.split('.');
      double amount = double.parse(value);
      if (amount > widget.withdrawableGoldQnty)
        return 'Insufficient balance';
      else if (amount < 0.0001)
        return 'Please enter a greater amount';
      else if (fractionalPart != null &&
          fractionalPart.length > 1 &&
          fractionalPart[1] != null &&
          fractionalPart[1].length > 4)
        return 'Upto 4 decimals allowed';
      else
        return null;
    } catch (e) {
      return 'Please enter a valid amount';
    }
  }
}
