import 'dart:io';

import 'package:flutter/services.dart';
import 'package:felloapp/base_util.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/ui/dialogs/confirm_action_dialog.dart';
import 'package:felloapp/ui/modals/simple_kyc_modal_sheet.dart';
import 'package:felloapp/ui/pages/onboarding/icici/input-elements/input_field.dart';
import 'package:felloapp/ui/pages/tabs/finance/augmont/edit_augmont_bank_details.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/constants.dart';
import 'package:felloapp/util/haptic.dart';
import 'package:felloapp/util/palettes.dart';
import 'package:felloapp/util/logger.dart';
import 'package:felloapp/util/size_config.dart';
import 'package:felloapp/util/ui_constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class AugmontWithdrawScreen extends StatefulWidget {
  final double passbookBalance;
  final double withdrawableGoldQnty;
  final double sellRate;
  final String bankHolderName;
  final String bankAccNo;
  final String bankIfsc;
  final ValueChanged<Map<String, double>> onAmountConfirmed;

  AugmontWithdrawScreen(
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
  State createState() => AugmontWithdrawScreenState();
}

class AugmontWithdrawScreenState extends State<AugmontWithdrawScreen>
    with SingleTickerProviderStateMixin {
  final Log log = new Log('AugmontWithdrawScreen');
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
    baseProvider = Provider.of<BaseUtil>(context, listen: false);
    appState = Provider.of<AppState>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        actions: [
          Padding(
            padding: EdgeInsets.fromLTRB(0, 5, 5, 0),
            child: MaterialButton(
              child: !_checkBankInfoMissing
                  ? Consumer<BaseUtil>(
                      builder: (ctx, bp, child) {
                        return Container(
                          child: Padding(
                              padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                              child: Text('Edit Bank Info')),
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: augmontGoldPalette.primaryColor),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        );
                      },
                    )
                  : Container(),
              onPressed: () {
                appState.currentAction = PageAction(
                    state: PageState.addPage,
                    page: EditAugBankDetailsPageConfig);
              },
            ),
          )
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: dialogContent(context),
      ),
    );
  }

  dialogContent(BuildContext context) {
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Padding(
          padding: EdgeInsets.only(top: 10, bottom: 0, left: 10, right: 10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              (baseProvider.checkKycMissing)
                  ? _addKycInfoWidget()
                  : Container(),
              SizedBox(
                child: Image(
                  image: AssetImage(Assets.onboardingSlide[1]),
                  fit: BoxFit.contain,
                ),
                width: SizeConfig.screenWidth * 0.3,
                height: SizeConfig.screenWidth * 0.3,
              ),
              Text(
                'WITHDRAW',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    color: augmontGoldPalette.primaryColor),
              ),
              (_isLoading)
                  ? Padding(
                      padding: EdgeInsets.all(30),
                      child: SpinKitWave(
                        color: UiConstants.primaryColor,
                      ))
                  : Container(),
              (_errorMessage != null && !_isLoading)
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: _width * 0.7,
                          child: Text('Error: $_errorMessage',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.redAccent, fontSize: 16)),
                        )
                      ],
                    )
                  : Container(),
              SizedBox(
                height: 10,
              ),
              (!_isLoading)
                  ? _buildRow('Current Gold Selling Rate',
                      '₹${widget.sellRate} per gram')
                  : Container(),
              (!_isLoading)
                  ? SizedBox(
                      height: 5,
                    )
                  : Container(),
              (!_isLoading)
                  ? _buildRow('Total Gold Owned',
                      '${baseProvider.userFundWallet.augGoldQuantity.toStringAsFixed(4)} grams')
                  : Container(),
              (!_isLoading &&
                      widget.withdrawableGoldQnty !=
                          baseProvider.userFundWallet.augGoldQuantity)
                  ? _buildLockedGoldRow('Total Gold available for withdrawal',
                      '${widget.withdrawableGoldQnty.toStringAsFixed(4)} grams')
                  : Container(),
              (!_isLoading)
                  ? SizedBox(
                      height: 5,
                    )
                  : Container(),
              (!_isLoading)
                  ? _buildRow('Total withdrawable balance',
                      '${widget.withdrawableGoldQnty.toStringAsFixed(4)} * ${widget.sellRate} = ₹${_getTotalGoldAvailable().toStringAsFixed(3)}')
                  : Container(),
              (!_isLoading)
                  ? SizedBox(
                      height: 30,
                    )
                  : Container(),
              (!_isLoading)
                  ? Container(
                      margin: EdgeInsets.only(top: 12),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: Theme(
                              data: ThemeData.light().copyWith(
                                  textTheme: GoogleFonts.montserratTextTheme(),
                                  colorScheme: ColorScheme.light(
                                      primary:
                                          augmontGoldPalette.primaryColor)),
                              child: TextField(
                                controller: _quantityController,
                                keyboardType: (Platform.isAndroid)
                                    ? TextInputType.number
                                    : TextInputType.numberWithOptions(
                                        decimal: true),
                                readOnly: false,
                                enabled: true,
                                autofocus: false,
                                decoration: augmontFieldInputDecoration(
                                    'Quantity (in grams)', null),
                                onChanged: (value) {
                                  setState(() {});
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  : Container(),
              (!_isLoading)
                  ? Padding(
                      padding: EdgeInsets.only(top: 10),
                      child: _getGoldAmount(_quantityController.text),
                    )
                  : Container(),
              (!_isLoading && _amountError != null)
                  ? Container(
                      margin: EdgeInsets.only(top: 4, left: 12),
                      child: Text(
                        _amountError,
                        style: TextStyle(color: Colors.red),
                      ),
                    )
                  : Container(),
              SizedBox(
                height: 25,
              ),
              (_checkBankInfoMissing) ? _addBankInfoWidget() : Container(),
              (!_isLoading) ? _buildSubmitButton(context) : Container(),
              // (!_isLoading)
              //     ? Padding(
              //         padding: EdgeInsets.only(
              //           top: 10,
              //         ),
              //         child: Text(
              //           'All withdrawals are processed within 2 business working days.',
              //           textAlign: TextAlign.center,
              //           style: TextStyle(
              //               color: Colors.blueGrey[600],
              //               fontSize: SizeConfig.mediumTextSize,
              //               fontWeight: FontWeight.w400),
              //         ),
              //       )
              //     : Container(),
              SizedBox(
                height: 10,
              ),
            ],
          )),
    );
  }

  Widget _addBankInfoWidget() {
    return Container(
      width: SizeConfig.screenWidth,
      decoration: BoxDecoration(
        color: Colors.amber[100],
        borderRadius: BorderRadius.circular(4),
      ),
      alignment: Alignment.centerLeft,
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Padding(
        padding: EdgeInsets.all(SizeConfig.blockSizeHorizontal * 2),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            'You will be asked for your bank information in next step',
            style: TextStyle(
                fontSize: SizeConfig.smallTextSize * 1.2,
                color: Colors.black54),
          ),
        ),
      ),
    );
  }

  Widget _addKycInfoWidget() {
    return InkWell(
      onTap: () {
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
        height: SizeConfig.cardTitleTextSize * 2,
        alignment: Alignment.center,
        child: Transform.scale(
          scale: scaleAnimation.value,
          child: Container(
            width: SizeConfig.screenWidth * 0.8,
            decoration: BoxDecoration(
              color: Colors.amber[200],
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
                      'Complete your KYC to withdraw',
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Spacer(),
                  SizedBox()
                ],
              ),
            ),
          ),
        ),
      ),
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
      baseProvider.showNegativeAlert('Withdrawal Failed',
          'Please try again in some time or contact us for assistance', context,
          seconds: 5);
    } else {
      baseProvider.showPositiveAlert('Withdrawal Request is now processing',
          'We will inform you once the withdrawal is complete!', context);
    }
  }

  Widget _buildSubmitButton(BuildContext context) {
    LinearGradient _gradient = new LinearGradient(colors: [
      augmontGoldPalette.secondaryColor.withBlue(800),
      augmontGoldPalette.secondaryColor,
      //Colors.blueGrey,
      //Colors.blueGrey[800],
    ], begin: Alignment(0.5, -1.0), end: Alignment(0.5, 1.0));

    return Container(
      width: MediaQuery.of(context).size.width - 40,
      height: 50.0,
      decoration: BoxDecoration(
        gradient: _gradient,
        borderRadius: new BorderRadius.circular(10.0),
      ),
      child: new Material(
        child: MaterialButton(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                _checkBankInfoMissing ? 'PROCEED' : 'WITHDRAW ',
                style: Theme.of(context)
                    .textTheme
                    .button
                    .copyWith(color: Colors.white),
              ),
            ],
          ),
          onPressed: () async {
            Haptic.vibrate();
            if (baseProvider.showNoInternetAlert(context)) return;
            if (baseProvider.checkKycMissing) {
              _controller.forward().then((value) => _controller.reverse());
            } else {
              if (widget.withdrawableGoldQnty == 0.0) {
                baseProvider.showNegativeAlert('Unable to process',
                    'Your withdrawable balance is low', context);
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
                  showDialog(
                    context: context,
                    builder: (ctx) => ConfirmActionDialog(
                      title: "Please confirm your action",
                      description: _confirmMsg,
                      buttonText: "Withdraw",
                      cancelBtnText: 'Cancel',
                      confirmAction: () {
                        Navigator.of(context).pop();
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
                        Navigator.of(context).pop();
                        return false;
                      },
                    ),
                  );
                }
              }
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

  bool get _checkBankInfoMissing =>
      (baseProvider.augmontDetail.bankAccNo.isEmpty ||
          baseProvider.augmontDetail.bankAccNo == null ||
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

  _buildLockedGoldRow(String title, String value) {
    double _rem_gold = baseProvider.userFundWallet.augGoldQuantity -
        widget.withdrawableGoldQnty;
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
                  borderRadius: BorderRadius.circular(UiConstants.padding),
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
