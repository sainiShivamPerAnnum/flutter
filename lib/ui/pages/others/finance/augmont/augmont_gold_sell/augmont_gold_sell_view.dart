//Project Imports

import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/core/enums/screen_item_enum.dart';
import 'package:felloapp/core/enums/user_service_enum.dart';
import 'package:felloapp/core/service/user_service.dart';
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
import 'package:felloapp/ui/widgets/simple_kyc_modalsheet/simple_kyc_modalsheet_view.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/constants.dart';
import 'package:felloapp/util/haptic.dart';
import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/logger.dart';
import 'package:felloapp/util/styles/palette.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
//Pub Imports
import 'package:flutter_spinkit/flutter_spinkit.dart';
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
    ).animate(
        new CurvedAnimation(parent: _controller, curve: Curves.bounceOut));
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
        resizeToAvoidBottomInset: false,
        body: HomeBackground(
          whiteBackground: WhiteBackground(
              color: UiConstants.scaffoldColor,
              height: SizeConfig.screenHeight * 0.08),
          child: Column(
            children: [
              FelloAppBar(
                leading: FelloAppBarBackButton(),
                title: "Sell Digital Gold",
              ),
              Expanded(
                child: Container(
                  margin: EdgeInsets.all(SizeConfig.pageHorizontalMargins),
                  padding: EdgeInsets.all(SizeConfig.padding20),
                  decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.circular(SizeConfig.roundness32),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Color(0xff0B175F0D),
                          blurRadius: SizeConfig.padding12,
                          offset: Offset(0, SizeConfig.padding12),
                          spreadRadius: SizeConfig.padding20,
                        )
                      ]),
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(locale.saveGoldBalancelabel,
                                    style: TextStyles.title5.light),
                                PropertyChangeConsumer<UserService,
                                    UserServiceProperties>(
                                  builder: (ctx, model, child) => Text(
                                    locale.saveGoldBalanceValue(
                                        model.userFundWallet.augGoldQuantity ??
                                            0.0),
                                    style: TextStyles.title5.bold
                                        .colour(UiConstants.tertiarySolid),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: SizeConfig.padding32),
                            Row(
                              children: [
                                Text(
                                  "Sell in grams",
                                  style: TextStyles.title4.bold,
                                ),
                              ],
                            ),
                            SizedBox(
                              height: SizeConfig.padding16,
                            ),
                            Container(
                              width: SizeConfig.screenWidth,
                              height: SizeConfig.screenWidth * 0.135,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Color(0xffDFE4EC),
                                ),
                                borderRadius: BorderRadius.circular(
                                    SizeConfig.roundness12),
                              ),
                              child: Row(
                                children: [
                                  SizedBox(width: SizeConfig.padding24),
                                  Expanded(
                                    child: TextField(
                                      focusNode: model.sellFieldNode,
                                      enabled: !model.isGoldSellInProgress,
                                      controller: model.goldAmountController,
                                      enableInteractiveSelection: false,
                                      keyboardType:
                                          TextInputType.numberWithOptions(
                                              decimal: true, signed: true),
                                      style: TextStyles.body2.bold,
                                      onChanged: (val) {
                                        model.goldSellGrams =
                                            double.tryParse(val);
                                        model.updateGoldAmount();
                                      },
                                      decoration: InputDecoration(
                                        suffix: Text("gms  ",
                                            style: TextStyles.body2.bold),
                                        border: InputBorder.none,
                                        enabledBorder: InputBorder.none,
                                        focusedBorder: InputBorder.none,
                                        disabledBorder: InputBorder.none,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: SizeConfig.screenWidth * 0.275,
                                    height: SizeConfig.screenWidth * 0.135,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(
                                            SizeConfig.roundness12),
                                        bottomRight: Radius.circular(
                                            SizeConfig.roundness12),
                                      ),
                                      color: UiConstants.scaffoldColor,
                                    ),
                                    padding: EdgeInsets.only(
                                        left: SizeConfig.padding20),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "You receive",
                                          style: TextStyles.body3
                                              .colour(Colors.grey),
                                        ),
                                        SizedBox(
                                            height: SizeConfig.padding4 / 2),
                                        FittedBox(
                                          child: Text(
                                            "₹ ${model.goldAmountFromGrams.toStringAsFixed(2)}",
                                            style: TextStyles.body2.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                            SizedBox(
                              height: SizeConfig.padding24,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                model.amoutChip(model.chipAmountList[0]),
                                model.amoutChip(model.chipAmountList[1]),
                                model.amoutChip(model.chipAmountList[2]),
                                // model.amoutChip(model.chipAmountList[3]),
                              ],
                            ),
                            SizedBox(height: SizeConfig.padding54),
                            Container(
                              margin:
                                  EdgeInsets.only(bottom: SizeConfig.padding24),
                              child: CurrentPriceWidget(
                                fetchGoldRates: model.fetchGoldRates,
                                goldprice: model.goldSellPrice ?? 0.0,
                                isFetching: model.isGoldRateFetching,
                              ),
                            ),
                            (baseProvider.checkKycMissing)
                                ? _addKycInfoWidget()
                                : Container(),
                            (_checkBankInfoMissing)
                                ? _addBankInfoWidget()
                                : Container(),

                            (baseProvider.checkKycMissing ||
                                    _checkBankInfoMissing)
                                ? Container()
                                : Container(
                                    margin: EdgeInsets.only(
                                        top: SizeConfig.padding24),
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
                                        if (!model.isGoldSellInProgress) {
                                          FocusScope.of(context).unfocus();
                                          model.initiateSell();
                                        }
                                      },
                                    ),
                                  ),
                            SizedBox(
                              height: SizeConfig.padding20,
                            ),
                            Text(
                              "You will receive the amount within 24-48 hours",
                              textAlign: TextAlign.center,
                              style: TextStyles.body3.colour(Colors.grey),
                            ),
                            SizedBox(height: SizeConfig.padding80),

                            // SizedBox(
                            //   child: Image(
                            //     image: AssetImage(Assets.onboardingSlide[1]),
                            //     fit: BoxFit.contain,
                            //   ),
                            //   width: SizeConfig.screenWidth * 0.3,
                            //   height: SizeConfig.screenWidth * 0.3,
                            // ),
                            // Text(
                            //   'WITHDRAW',
                            //   textAlign: TextAlign.center,
                            //   style: TextStyle(
                            //       fontSize: 28,
                            //       fontWeight: FontWeight.w700,
                            //       color: FelloColorPalette.augmontFundPalette()
                            //           .primaryColor),
                            // ),
                            // (_isLoading)
                            //     ? Padding(
                            //         padding: EdgeInsets.all(30),
                            //         child: SpinKitWave(
                            //           color: UiConstants.primaryColor,
                            //         ))
                            //     : Container(),
                            // (_errorMessage != null && !_isLoading)
                            //     ? Row(
                            //         mainAxisAlignment: MainAxisAlignment.center,
                            //         children: [
                            //           Container(
                            //             width: _width * 0.7,
                            //             child: Text('Error: $_errorMessage',
                            //                 textAlign: TextAlign.center,
                            //                 style: TextStyle(
                            //                     color: Colors.redAccent,
                            //                     fontSize: 16)),
                            //           )
                            //         ],
                            //       )
                            //     : Container(),
                            // SizedBox(
                            //   height: 10,
                            // ),
                            // (!_isLoading)
                            //     ? _buildRow('Current Gold Selling Rate',
                            //         '₹${widget.sellRate} per gram')
                            //     : Container(),
                            // (!_isLoading)
                            //     ? SizedBox(
                            //         height: 5,
                            //       )
                            //     : Container(),
                            // (!_isLoading)
                            //     ? _buildRow('Total Gold Owned',
                            //         '${model.userFundWallet.augGoldQuantity.toStringAsFixed(4)} grams')
                            //     : Container(),
                            // (!_isLoading &&
                            //         widget.withdrawableGoldQnty !=
                            //             model.userFundWallet.augGoldQuantity)
                            //     ? _buildLockedGoldRow(
                            //         'Total Gold available for withdrawal',
                            //         '${widget.withdrawableGoldQnty.toStringAsFixed(4)} grams',
                            //         model)
                            //     : Container(),
                            // (!_isLoading)
                            //     ? SizedBox(
                            //         height: 5,
                            //       )
                            //     : Container(),
                            // (!_isLoading)
                            //     ? _buildRow('Total withdrawable balance',
                            //         '${widget.withdrawableGoldQnty.toStringAsFixed(4)} * ${widget.sellRate} = ₹${_getTotalGoldAvailable().toStringAsFixed(3)}')
                            //     : Container(),
                            // (!_isLoading)
                            //     ? SizedBox(
                            //         height: 30,
                            //       )
                            //     : Container(),
                            // (!_isLoading)
                            //     ? Container(
                            //         margin: EdgeInsets.only(top: 12),
                            //         child: Row(
                            //           children: <Widget>[
                            //             Expanded(
                            //               child: Theme(
                            //                 data: ThemeData.light().copyWith(
                            //                     textTheme: GoogleFonts
                            //                         .montserratTextTheme(),
                            //                     colorScheme: ColorScheme.light(
                            //                         primary: FelloColorPalette
                            //                                 .augmontFundPalette()
                            //                             .primaryColor)),
                            //                 child: TextField(
                            //                   controller: _quantityController,
                            //                   keyboardType: (Platform.isAndroid)
                            //                       ? TextInputType.number
                            //                       : TextInputType
                            //                           .numberWithOptions(
                            //                               decimal: true),
                            //                   readOnly: false,
                            //                   enabled: true,
                            //                   autofocus: false,
                            //                   decoration:
                            //                       augmontFieldInputDecoration(
                            //                           'Quantity (in grams)',
                            //                           null),
                            //                   onChanged: (value) {
                            //                     setState(() {});
                            //                   },
                            //                 ),
                            //               ),
                            //             ),
                            //           ],
                            //         ),
                            //       )
                            //     : Container(),
                            // (!_isLoading)
                            //     ? Padding(
                            //         padding: EdgeInsets.only(top: 10),
                            //         child: _getGoldAmount(
                            //             _quantityController.text),
                            //       )
                            //     : Container(),
                            // (!_isLoading && _amountError != null)
                            //     ? Container(
                            //         margin: EdgeInsets.only(top: 4, left: 12),
                            //         child: Text(
                            //           _amountError,
                            //           style: TextStyle(color: Colors.red),
                            //         ),
                            //       )
                            //     : Container(),
                            // SizedBox(
                            //   height: 25,
                            // ),

                            // (!_isLoading)
                            //     ? _buildSubmitButton(context)
                            //     : Container(),
                            // // (!_isLoading)
                            // //     ? Padding(
                            // //         padding: EdgeInsets.only(
                            // //           top: 10,
                            // //         ),
                            // //         child: Text(
                            // //           'All withdrawals are processed within 2 business working days.',
                            // //           textAlign: TextAlign.center,
                            // //           style: TextStyle(
                            // //               color: Colors.blueGrey[600],
                            // //               fontSize: SizeConfig.mediumTextSize,
                            // //               fontWeight: FontWeight.w400),
                            // //         ),
                            // //       )
                            // //     : Container(),
                            // SizedBox(
                            //   height: 10,
                            // ),
                          ],
                        )),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
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











//  appBar: AppBar(
//           backgroundColor: Theme.of(context).scaffoldBackgroundColor,
//           elevation: 0,
//           actions: [
//             Padding(
//               padding: EdgeInsets.fromLTRB(0, 5, 5, 0),
//               child: MaterialButton(
//                 child: !_checkBankInfoMissing
//                     ? Consumer<BaseUtil>(
//                         builder: (ctx, bp, child) {
//                           return Container(
//                             child: Padding(
//                                 padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
//                                 child: Text('Edit Bank Info')),
//                             decoration: BoxDecoration(
//                               border: Border.all(
//                                   color: FelloColorPalette.augmontFundPalette()
//                                       .primaryColor),
//                               borderRadius: BorderRadius.circular(10),
//                             ),
//                           );
//                         },
//                       )
//                     : Container(),
//                 onPressed: () {
//                   appState.currentAction = PageAction(
//                       state: PageState.addPage,
//                       page: EditAugBankDetailsPageConfig);
//                 },
//               ),
//             )
//           ],
//         ),