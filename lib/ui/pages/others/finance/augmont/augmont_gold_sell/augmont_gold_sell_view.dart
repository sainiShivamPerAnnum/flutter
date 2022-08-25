//Project Imports
import 'package:felloapp/base_util.dart';
import 'dart:math' as math;
import 'package:felloapp/core/enums/user_service_enum.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/architecture/base_view.dart';
import 'package:felloapp/ui/pages/others/finance/augmont/augmont_gold_sell/augmont_gold_sell_vm.dart';
import 'package:felloapp/ui/pages/static/app_widget.dart';
import 'package:felloapp/ui/pages/static/fello_appbar.dart';
import 'package:felloapp/ui/pages/static/gold_rate_card.dart';
import 'package:felloapp/ui/widgets/buttons/fello_button/large_button.dart';
import 'package:felloapp/ui/widgets/buttons/nav_buttons/nav_buttons.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/constants.dart';
import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/logger.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
//Pub Imports
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
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
      builder: (ctx, model, child) => Container(
        height: SizeConfig.screenHeight * 0.85,
        width: SizeConfig.screenWidth,
        child: Column(
          children: [
            Container(
              height: SizeConfig.screenWidth * 1.8,
              padding: EdgeInsets.symmetric(
                  horizontal: SizeConfig.padding24,
                  vertical: SizeConfig.padding20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(SizeConfig.roundness32),
                    topRight: Radius.circular(SizeConfig.roundness32)),
                color: UiConstants.kModalSheetBackgroundColor,
              ),
              child: Padding(
                  padding:
                      EdgeInsets.only(top: 10, bottom: 0, left: 10, right: 10),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Align(
                        alignment: Alignment.topRight,
                        child: GestureDetector(
                          onTap: () {
                            AppState.backButtonDispatcher.didPopRoute();
                          },
                          child: Icon(
                            Icons.close,
                            size: SizeConfig.padding32,
                            color: UiConstants.kTextColor2,
                          ),
                        ),
                      ),
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
                        height: SizeConfig.padding54,
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
                            properties: [UserServiceProperties.myUserFund],
                            builder: (ctx, model, child) => Text(
                              locale.saveGoldBalanceValue(
                                  model.userFundWallet.augGoldQuantity ?? 0.0),
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
                            borderRadius:
                                BorderRadius.circular(SizeConfig.roundness12),
                            border: Border.all(
                                color: Colors.grey.withOpacity(0.4),
                                width: 0.5,
                                style: BorderStyle.solid)),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              height: SizeConfig.screenWidth * 0.5,
                              width: SizeConfig.screenWidth * 0.42,
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
                                  textAlign: TextAlign.center,
                                  cursorHeight: SizeConfig.padding46,
                                  keyboardType: TextInputType.numberWithOptions(
                                      decimal: true, signed: true),
                                  style: TextStyles.rajdhaniB.title2,
                                  onChanged: (val) {
                                    model.goldSellGrams = double.tryParse(val);
                                    model.updateGoldAmount();
                                  },
                                  autofocus: true,
                                  showCursor: false,
                                  textInputAction: TextInputAction.done,
                                  inputFormatters: [
                                    LengthLimitingTextInputFormatter(6),
                                  ],
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.symmetric(
                                        vertical: SizeConfig.padding24,
                                        horizontal: SizeConfig.padding28),
                                    fillColor: UiConstants.kFAQDividerColor
                                        .withOpacity(0.5),
                                    filled: true,
                                    suffix: Padding(
                                      padding: EdgeInsets.only(
                                          right: SizeConfig.padding10),
                                      child: Text("g",
                                          style: TextStyles.rajdhaniB.title2
                                              .colour(UiConstants.kTextColor)),
                                    ),
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
                              width: SizeConfig.screenWidth * 0.4,
                              height: SizeConfig.screenWidth * 0.22,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  topRight:
                                      Radius.circular(SizeConfig.roundness12),
                                  bottomRight:
                                      Radius.circular(SizeConfig.roundness12),
                                ),
                                color: UiConstants.kModalSheetBackgroundColor,
                              ),
                              padding:
                                  EdgeInsets.only(left: SizeConfig.padding10),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
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
                                      fetchGoldRates: model.fetchGoldRates,
                                      goldprice: model.goldSellPrice ?? 0.0,
                                      isFetching: model.isGoldRateFetching,
                                      mini: true,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      Spacer(),
                      Padding(
                          padding: EdgeInsets.only(
                              left: SizeConfig.padding34,
                              right: SizeConfig.padding34,
                              bottom: MediaQuery.of(context).viewInsets.bottom *
                                      0.5 ??
                                  0),
                          child: Text(
                            _buildNonWithdrawString(model),
                            style: TextStyles.body4.colour(Colors.grey),
                            textAlign: TextAlign.center,
                          )),
                      SizedBox(
                        height: SizeConfig.padding24,
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: SizeConfig.padding24),
                        child: AppPositiveCustomChildBtn(
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
                          onPressed: () async {
                            if (!model.isGoldSellInProgress &&
                                !model.isQntFetching) {
                              FocusScope.of(context).unfocus();
                              bool isDetailComplete =
                                  await model.verifyGoldSaleDetails();
                              isDetailComplete == true
                                  ? BaseUtil.openDialog(
                                      addToScreenStack: true,
                                      hapticVibrate: true,
                                      isBarrierDismissable: false,
                                      content: _SellConfimrationDialog(
                                        goldAmount: model.goldSellGrams,
                                        positiveTap: () async {
                                          AppState.backButtonDispatcher
                                              .didPopRoute();
                                          await model.initiateSell();
                                        },
                                        negativeTap: () {
                                          AppState.backButtonDispatcher
                                              .didPopRoute();
                                        },
                                      ))
                                  : () {};
                            }
                          },
                          width: SizeConfig.screenWidth,
                        ),
                      ),
                      SizedBox(
                        height: SizeConfig.padding32,
                      )
                    ],
                  )),
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
}

class _SellConfimrationDialog extends StatelessWidget {
  final double goldAmount;
  final Function() positiveTap;
  final Function() negativeTap;

  const _SellConfimrationDialog(
      {Key key, this.goldAmount = 0, this.positiveTap, this.negativeTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(SizeConfig.roundness16),
            gradient: LinearGradient(colors: [
              Color(0xFFFFFFFF),
              Color(0xFF000000),
              Color(0xFFF5F5F5).withOpacity(0.22),
            ], begin: Alignment(2, -2), end: Alignment(-2, 2))),
        child: Padding(
          padding: EdgeInsets.all(SizeConfig.padding2 / 1.8),
          child: Container(
            height: SizeConfig.screenWidth * 1.1,
            width: SizeConfig.screenWidth * 0.87,
            decoration: BoxDecoration(
                color: UiConstants.kModalSheetBackgroundColor,
                borderRadius: BorderRadius.circular(SizeConfig.roundness16)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: SizeConfig.padding24),
                  child: Text(
                    'Are you sure you want\nto sell?',
                    style: TextStyles.sourceSansSB.title5,
                    textAlign: TextAlign.center,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(SizeConfig.padding8),
                  child: Column(
                    children: [
                      SvgPicture.asset(Assets.magicalSpiritBall),
                      SizedBox(
                        height: SizeConfig.padding4,
                      ),
                      Text(
                        'Your $goldAmount gms could have grown to\n${(goldAmount * 12).toStringAsPrecision(2)} gms by 2025',
                        style: TextStyles.sourceSans.body3,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: SizeConfig.padding12,
                      vertical: SizeConfig.padding24),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: negativeTap,
                        child: Container(
                          height: SizeConfig.screenWidth * 0.14,
                          width: SizeConfig.screenWidth * 0.35,
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.circular(SizeConfig.roundness5),
                              border: Border.all(color: Colors.white)),
                          child: Center(
                            child: Text(
                              'CANCEL',
                              style: TextStyles.rajdhaniSB.body0,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: SizeConfig.screenWidth * 0.35,
                        child: FelloButtonLg(
                          onPressed: positiveTap,
                          height: SizeConfig.screenWidth * 0.14,
                          child: Text(
                            'SELL',
                            style: TextStyles.rajdhaniSB.body0,
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
