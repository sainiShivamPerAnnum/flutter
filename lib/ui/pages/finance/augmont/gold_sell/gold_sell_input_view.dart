//Project Imports
import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/enums/investment_type.dart';
import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/core/enums/view_state_enum.dart';
import 'package:felloapp/core/model/user_funt_wallet_model.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/core/service/payments/augmont_transaction_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/ui/dialogs/confirm_action_dialog.dart';
import 'package:felloapp/ui/pages/finance/augmont/gold_buy/widgets/buy_app_bar.dart';
import 'package:felloapp/ui/pages/finance/augmont/gold_sell/gold_sell_vm.dart';
import 'package:felloapp/ui/pages/finance/sell_confirmation_screen.dart';
import 'package:felloapp/ui/pages/static/app_widget.dart';
import 'package:felloapp/ui/pages/static/gold_rate_card.dart';
import 'package:felloapp/ui/pages/static/loader_widget.dart';
import 'package:felloapp/ui/service_elements/gold_sell_card/sell_card_components.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/constants.dart';
import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class GoldSellInputView extends StatelessWidget {
  final GoldSellViewModel model;
  final AugmontTransactionService augTxnService;

  const GoldSellInputView(
      {required this.model, required this.augTxnService, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    S? locale = S.of(context);
    return (model.state == ViewState.Busy)
        ? Container(
            width: SizeConfig.screenWidth,
            decoration: BoxDecoration(
              color: UiConstants.kDarkBackgroundColor.withOpacity(0.5),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(SizeConfig.roundness12),
                topRight: Radius.circular(SizeConfig.roundness12),
              ),
            ),
            child: const FullScreenLoader())
        : Stack(
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: SizeConfig.padding16),
                  RechargeModalSheetAppBar(
                      txnService: augTxnService,
                      trackCloseTapped: () =>
                          AppState.backButtonDispatcher!.didPopRoute()),
                  SizedBox(
                    height: SizeConfig.padding24,
                  ),
                  if (model.nonWithdrawableQnt != null &&
                      model.nonWithdrawableQnt != 0)
                    SellCardInfoStrips(content: model.withdrawableQtyMessage),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: SizeConfig.padding12,
                        horizontal: SizeConfig.pageHorizontalMargins),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          locale.withdrawGoldBalance,
                          style: TextStyles.sourceSans.body3
                              .colour(UiConstants.kTextColor2),
                        ),
                        Text(
                          "${model.withdrawableQnt.toString()}gms",
                          style: TextStyles.sourceSansSB.body0
                              .colour(UiConstants.kTextColor),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: SizeConfig.padding6,
                  ),
                  Container(
                    height: SizeConfig.screenWidth! * 0.22,
                    width: SizeConfig.screenWidth,
                    margin: EdgeInsets.symmetric(
                        horizontal: SizeConfig.pageHorizontalMargins),
                    decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.circular(SizeConfig.roundness12),
                        border: Border.all(
                            color: Colors.grey.withOpacity(0.4),
                            width: 0.5,
                            style: BorderStyle.solid)),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              model.sellFieldNode.unfocus();
                              Future.delayed(const Duration(milliseconds: 100),
                                  () {
                                model.sellFieldNode.requestFocus();
                              });
                            },
                            child: Container(
                              height: SizeConfig.screenWidth! * 0.5,
                              // width: SizeConfig.screenWidth * 0.6,
                              decoration: BoxDecoration(
                                color: UiConstants.kFAQDividerColor
                                    .withOpacity(0.5),
                                borderRadius: BorderRadius.only(
                                  topLeft:
                                      Radius.circular(SizeConfig.roundness12),
                                  bottomLeft:
                                      Radius.circular(SizeConfig.roundness12),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  AnimatedContainer(
                                    duration: const Duration(seconds: 0),
                                    curve: Curves.easeIn,
                                    width: model.fieldWidth,
                                    child: TextField(
                                      focusNode: model.sellFieldNode,
                                      enabled:
                                          !augTxnService.isGoldSellInProgress,
                                      controller: model.goldAmountController,
                                      // enableInteractiveSelection: false,
                                      textAlign: TextAlign.center,
                                      cursorHeight: SizeConfig.padding35,
                                      keyboardType:
                                          const TextInputType.numberWithOptions(
                                              decimal: true),
                                      style: TextStyles.rajdhaniB.title2,
                                      onChanged: model.updateGoldAmount,
                                      autofocus: true,
                                      showCursor: true,
                                      textInputAction: TextInputAction.done,
                                      inputFormatters: [
                                        FilteringTextInputFormatter.allow(
                                          RegExp(r'^\d*\.?\d*$'),
                                        )
                                      ],
                                      decoration: const InputDecoration(
                                        fillColor: Colors.transparent,
                                        filled: true,
                                        contentPadding: EdgeInsets.zero,
                                        enabledBorder: InputBorder.none,
                                        focusedBorder: InputBorder.none,
                                        disabledBorder: InputBorder.none,
                                      ),
                                    ),
                                  ),
                                  Text(locale.g,
                                      style: TextStyles.rajdhaniB.title2
                                          .colour(UiConstants.kTextColor))
                                ],
                              ),
                            ),
                          ),
                        ),
                        Container(
                          width: SizeConfig.screenWidth! * 0.36,
                          height: SizeConfig.screenWidth! * 0.5,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(SizeConfig.roundness12),
                              bottomRight:
                                  Radius.circular(SizeConfig.roundness12),
                            ),
                            color: UiConstants.kModalSheetBackgroundColor,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              FittedBox(
                                alignment: Alignment.center,
                                child: Text(
                                  "₹ ${model.goldAmountFromGrams.toStringAsFixed(2)}",
                                  style: TextStyles.sourceSansSB.body1.colour(
                                      UiConstants
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
                  if (model.showMaxCap)
                    Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: SizeConfig.padding8,
                          horizontal: SizeConfig.pageHorizontalMargins * 1.5),
                      child: Text(
                        locale.goldSellingCapacity,
                        style: TextStyles.sourceSans.body4.bold
                            .colour(UiConstants.primaryColor),
                      ),
                    ),
                  if (model.showMinCap)
                    Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: SizeConfig.padding8,
                          horizontal: SizeConfig.pageHorizontalMargins * 1.5),
                      child: Text(
                        locale.minimumAmount,
                        style: TextStyles.sourceSans.body4.bold
                            .colour(Colors.red[400]),
                      ),
                    ),
                  const GoldLeaseWithdrawInfo(),
                  const Spacer(),
                  augTxnService.isGoldSellInProgress
                      ? Center(
                          child: Container(
                            height: SizeConfig.screenWidth! * 0.1556,
                            alignment: Alignment.center,
                            width: SizeConfig.screenWidth! * 0.7,
                            child: const LinearProgressIndicator(
                              color: UiConstants.primaryColor,
                              backgroundColor: UiConstants.kDarkBackgroundColor,
                            ),
                          ),
                        )
                      : Container(
                          margin:
                              EdgeInsets.all(SizeConfig.pageHorizontalMargins),
                          child: ReactivePositiveAppButton(
                            btnText: locale.saveSellButton,
                            onPressed: () async {
                              if (model.responseModel.data!.limitQuantity <
                                  double.parse(model
                                          .goldAmountController!.text.isNotEmpty
                                      ? model.goldAmountController!.text
                                      : '0')) {
                                await BaseUtil.openDialog(
                                  isBarrierDismissible: false,
                                  addToScreenStack: true,
                                  content: ConfirmationDialog(
                                      asset: Padding(
                                        padding: EdgeInsets.all(
                                            SizeConfig.padding16),
                                        child: SvgPicture.asset(
                                          Assets.securityCheck,
                                          height:
                                              SizeConfig.screenHeight! * 0.15,
                                          width:
                                              SizeConfig.screenHeight! * 0.15,
                                        ),
                                      ),
                                      title: model
                                          .responseModel.data!.limitHeading,
                                      description: model
                                          .responseModel.data!.limitMessage,
                                      showSecondaryButton: false,
                                      buttonText: "OKAY",
                                      confirmAction: () {
                                        AppState.backButtonDispatcher!
                                            .didPopRoute();
                                      },
                                      cancelAction: () {}),
                                );
                              } else if (!augTxnService.isGoldSellInProgress &&
                                  !model.isQntFetching) {
                                FocusScope.of(context).unfocus();
                                bool isDetailComplete =
                                    await model.verifyGoldSaleDetails();
                                if (isDetailComplete) {
                                  AppState.delegate!.appState.currentAction =
                                      PageAction(
                                    widget: SellConfirmationView(
                                      amount: model.goldAmountFromGrams,
                                      grams: model.goldSellGrams,
                                      onSuccess: () async {
                                        await AppState.backButtonDispatcher!
                                            .didPopRoute();
                                        model.initiateSell();
                                      },
                                      investmentType: InvestmentType.AUGGOLD99,
                                    ),
                                    page: SellConfirmationViewConfig,
                                    state: PageState.addWidget,
                                  );
                                }
                                // BaseUtil.openDialog(
                                //   addToScreenStack: true,
                                //   hapticVibrate: true,
                                //   isBarrierDismissible: false,
                                //   content: ConfirmationDialog(
                                //     title: 'Are you sure you want\nto sell?',
                                //     // asset: SvgPicture.asset(Assets.magicalSpiritBall),
                                //     asset: BankDetailsCard(),
                                //     description:
                                //         '₹${BaseUtil.digitPrecision(model.goldAmountFromGrams, 2)} will be credited to your linked bank account instantly',
                                //     buttonText: 'SELL',
                                //     confirmAction: () async {
                                //       AppState.backButtonDispatcher!.didPopRoute();
                                //       await model.initiateSell();
                                //     },
                                //     cancelAction: () {
                                //       AppState.backButtonDispatcher!.didPopRoute();
                                //     },
                                //   ),
                                // );
                              }
                            },
                          ),
                        ),
                ],
              ),
              CustomKeyboardSubmitButton(
                onSubmit: () => model.sellFieldNode.unfocus(),
              ),
            ],
          );
  }

//   _buildRow(String key, String value){
//  return Row(children: [
//   Expanded(child: Text(key,style:TextStyles.sourceSansB),)
//  ],)
//   }
}

class GoldLeaseWithdrawInfo extends StatelessWidget {
  const GoldLeaseWithdrawInfo({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Selector<UserService, UserFundWallet?>(
        selector: (p0, p1) => p1.userFundWallet,
        builder: (context, wallet, child) {
          return (wallet?.wAugFdQty ?? 0) <= 0
              ? const SizedBox()
              : Container(
                  margin: EdgeInsets.all(SizeConfig.pageHorizontalMargins),
                  padding: EdgeInsets.symmetric(
                    horizontal: SizeConfig.pageHorizontalMargins,
                    vertical: SizeConfig.padding16,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: UiConstants.kFAQDividerColor,
                      width: 0.5,
                    ),
                    borderRadius: BorderRadius.circular(SizeConfig.roundness16),
                  ),
                  child: Column(children: [
                    Row(
                      children: [
                        Icon(
                          Icons.info_outline_rounded,
                          size: SizeConfig.iconSize2,
                          color: UiConstants.kFAQDividerColor,
                        ),
                        Text(
                          "  Leased Gold Amount-",
                          style: TextStyles.sourceSansM.body2
                              .colour(UiConstants.kFAQDividerColor),
                        ),
                        const Spacer(),
                        Text(
                          "${BaseUtil.digitPrecision(wallet!.wAugFdQty!, 2)}gms",
                          style:
                              TextStyles.sourceSans.body2.colour(Colors.white),
                        )
                      ],
                    ),
                    SizedBox(height: SizeConfig.padding8),
                    Text(
                      "You can un-Lease your Digital gold in ${Constants.ASSET_GOLD_STAKE} section to be make it withdrawable",
                      style: TextStyles.body3.colour(Colors.grey),
                    )
                  ]),
                );
        });
  }
}
