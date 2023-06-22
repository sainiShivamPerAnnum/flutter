import 'dart:developer';

import 'package:felloapp/core/enums/investment_type.dart';
import 'package:felloapp/core/enums/transaction_type_enum.dart';
import 'package:felloapp/core/service/payments/lendbox_transaction_service.dart';
import 'package:felloapp/core/service/power_play_service.dart';
import 'package:felloapp/feature/tambola/tambola.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/pages/finance/augmont/gold_buy/gold_buy_success_view.dart';
import 'package:felloapp/ui/service_elements/user_service/user_fund_quantity_se.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/constants.dart';
import 'package:felloapp/util/dynamic_ui_utils.dart';
import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class LendboxSuccessView extends StatelessWidget {
  final TransactionType transactionType;
  final LendboxTransactionService _txnService =
  locator<LendboxTransactionService>();

  LendboxSuccessView({Key? key, required this.transactionType})
      : super(key: key);

  void showGtIfAvailable() {
    if (transactionType == TransactionType.DEPOSIT) {
      _txnService!.showGtIfAvailable();
    }
  }

  @override
  Widget build(BuildContext context) {
    S locale = S.of(context);
    return Material(
      color: Colors.black,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: SizeConfig.padding32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SafeArea(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    onPressed: () {
                      AppState.isRepeated = true;
                      AppState.unblockNavigation();
                      AppState.backButtonDispatcher!.didPopRoute();
                      showGtIfAvailable();
                    },
                    icon: const Icon(
                      Icons.close,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Lottie.network(
                      Assets.floDepositSuccessLottie,
                      fit: BoxFit.cover,
                    ),
                  ),
                  if (_txnService!.currentTxnAmount! > 0)
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        margin: EdgeInsets.only(
                          left: SizeConfig.padding12,
                          bottom: SizeConfig.padding24,
                        ),
                        child: Lottie.network(
                          Assets.floatingTokenIslandLottie,
                          width: SizeConfig.screenWidth! * 0.3,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  if (_txnService!.currentTxnScratchCardCount > 0)
                    Align(
                      alignment: Alignment.centerRight,
                      child: Container(
                        margin: EdgeInsets.only(
                          right: SizeConfig.padding12,
                          top: SizeConfig.padding24,
                        ),
                        child: Lottie.network(
                          Assets.floatingScratchCardIslandLottie,
                          width: SizeConfig.screenWidth! * 0.3,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  if (_txnService!.currentTxnTambolaTicketsCount > 0)
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        child: Lottie.network(
                          Assets.floatingTambolaTicketIslandLottie,
                          width: SizeConfig.screenWidth! * 0.3,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Text(
              locale.btnCongratulations,
              style: TextStyles.rajdhaniB.title2,
            ),
            SizedBox(height: SizeConfig.padding12),
            if (_txnService?.transactionReponseModel?.data?.txnDisplayMsg
                ?.isNotEmpty ??
                false)
              SizedBox(
                width: SizeConfig.screenWidth! * 0.8,
                child: Text(
                    _txnService?.transactionReponseModel?.data?.txnDisplayMsg ??
                        "",
                    textAlign: TextAlign.center,
                    style: TextStyles.sourceSans.body2.setOpacity(0.7)),
              )
            else
              Text(
                locale.txnInvestmentSuccess,
                textAlign: TextAlign.center,
                style: TextStyles.sourceSans.body2.setOpacity(0.7),
              ),
            SizedBox(
              height: SizeConfig.padding10,
            ),
            Text(
              "#whatafello",
              style: TextStyles.sourceSansBL.body2.colour(Colors.white),
            ),
            Container(
              margin: EdgeInsets.only(
                left: SizeConfig.pageHorizontalMargins,
                right: SizeConfig.pageHorizontalMargins,
                top: SizeConfig.pageHorizontalMargins,
              ),
              decoration: BoxDecoration(
                border: Border.all(width: 0.5, color: UiConstants.kTextColor2),
                borderRadius: BorderRadius.all(
                  Radius.circular(SizeConfig.roundness12),
                ),
              ),
              child: Column(
                children: [
                  IntrinsicHeight(
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            margin: EdgeInsets.only(
                              left: SizeConfig.pageHorizontalMargins,
                              top: SizeConfig.padding16,
                              bottom: SizeConfig.padding16,
                              right: SizeConfig.padding8,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(locale.invested,
                                    style: TextStyles.sourceSans.body2
                                        .colour(UiConstants.kTextColor2)),
                                SizedBox(height: SizeConfig.padding16),
                                Text(
                                  "₹ ${_txnService!.currentTxnAmount!.toStringAsFixed(2)}",
                                  style: TextStyles.rajdhaniB.title3,
                                ),
                                SizedBox(
                                  height: SizeConfig.padding12,
                                ),
                              ],
                            ),
                          ),
                        ),
                        VerticalDivider(
                          width: 3,
                          thickness: 0.5,
                          indent: SizeConfig.padding6,
                          endIndent: SizeConfig.padding6,
                          color: UiConstants.kTextColor2,
                        ),
                        Expanded(
                          child: Container(
                            margin: EdgeInsets.only(
                                left: SizeConfig.pageHorizontalMargins,
                                top: SizeConfig.padding16,
                                bottom: SizeConfig.padding16,
                                right: SizeConfig.padding16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  _txnService
                                      ?.transactionReponseModel
                                      ?.data
                                      ?.floDepositDetails
                                      ?.maturityDate !=
                                      null
                                      ? "Return %"
                                      : locale.totalBalance,
                                  style: TextStyles.sourceSans.body2
                                      .colour(UiConstants.kTextColor2),
                                ),
                                SizedBox(height: SizeConfig.padding16),
                                _txnService?.transactionReponseModel?.data
                                    ?.floDepositDetails?.maturityDate !=
                                    null
                                    ? Text(
                                  getFundType(_txnService
                                      ?.transactionReponseModel
                                      ?.data
                                      ?.floDepositDetails
                                      ?.fundType),
                                  style: TextStyles.rajdhaniB.title3,
                                )
                                    : UserFundQuantitySE(
                                  style: TextStyles.rajdhaniB.title3,
                                  investmentType:
                                  InvestmentType.LENDBOXP2P,
                                ),
                                SizedBox(
                                  height: SizeConfig.padding12,
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  if (_txnService?.transactionReponseModel?.data
                      ?.floDepositDetails?.maturityDate !=
                      null)
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: SizeConfig.pageHorizontalMargins,
                          vertical: SizeConfig.padding6),
                      child: Text(
                        _txnService?.transactionReponseModel?.data
                            ?.floDepositDetails?.maturityDate ??
                            "",
                        style: TextStyles.sourceSans.body2
                            .colour(UiConstants.kFAQsAnswerColor),
                      ),
                    ),
                  if (_txnService?.transactionReponseModel?.data
                      ?.floDepositDetails?.maturityString !=
                      null)
                    Container(
                      width: SizeConfig.screenWidth,
                      alignment: Alignment.center,
                      margin: EdgeInsets.only(top: SizeConfig.padding6),
                      decoration: BoxDecoration(
                          color: UiConstants.kBackgroundColor,
                          borderRadius: BorderRadius.only(
                              bottomLeft:
                              Radius.circular(SizeConfig.roundness12),
                              bottomRight:
                              Radius.circular(SizeConfig.roundness12))),
                      padding: EdgeInsets.symmetric(
                          horizontal: SizeConfig.pageHorizontalMargins,
                          vertical: SizeConfig.padding6),
                      child: Text(
                        _txnService?.transactionReponseModel?.data
                            ?.floDepositDetails?.maturityString ??
                            "",
                        style: TextStyles.sourceSans.body2.colour(Colors.white),
                      ),
                    )
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.only(
                top: SizeConfig.padding20,
                bottom: SizeConfig.padding20,
                right: SizeConfig.pageHorizontalMargins,
                left: SizeConfig.pageHorizontalMargins,
              ),
              child: Row(
                children: [
                  WinningChips(
                      title: locale.felloTokens,
                      tooltip: locale.winChipsTitle1,
                      asset: Assets.token,
                      qty: _txnService!.currentTxnAmount!.toInt()),
                  if (_txnService!.currentTxnScratchCardCount > 0)
                    SizedBox(width: SizeConfig.padding12),
                  if (_txnService!.currentTxnScratchCardCount > 0)
                    WinningChips(
                        title: _txnService!.currentTxnScratchCardCount > 1
                            ? locale.scratchCards
                            : locale.scratchCard,
                        tooltip: locale.winChipsTitle2,
                        asset: Assets.unredemmedScratchCardBG,
                        qty: _txnService!.currentTxnScratchCardCount),
                  if (_txnService!.currentTxnTambolaTicketsCount > 0)
                    SizedBox(width: SizeConfig.padding12),
                  if (_txnService!.currentTxnTambolaTicketsCount > 0)
                    WinningChips(
                      title: 'Ticket',
                      tooltip: locale.winChipsTitle3,
                      asset: Assets.singleTmbolaTicket,
                      qty: _txnService!.currentTxnTambolaTicketsCount.toInt(),
                    )
                ],
              ),
            ),
            const AutopaySetupWidget(),
            SizedBox(height: SizeConfig.padding20),
            TextButton(
              onPressed: () async {
                AppState.isRepeated = true;
                AppState.unblockNavigation();

                log("Current Configuration: ${AppState.delegate!.currentConfiguration!.key} ||  screenStack.last ${AppState.screenStack.last}");

                while (AppState.screenStack.length > 1) {
                  await AppState.backButtonDispatcher!.didPopRoute();
                }

                // if (AppState.delegate!.currentConfiguration!.key ==
                //         'AssetSelectionViewPath' ||
                //     AppState.screenStack.last == ScreenItem.dialog) {
                //   AppState.backButtonDispatcher!.didPopRoute();
                // }

                AppState.delegate!.appState.setCurrentTabIndex = DynamicUiUtils
                    .navBar
                    .indexWhere((element) => element == 'SV');

                locator<TambolaService>().getBestTambolaTickets();
                showGtIfAvailable();
              },
              child: Text(
                PowerPlayService.powerPlayDepositFlow
                    ? "Make another prediction"
                    : locale.obDone,
                style: TextStyles.rajdhaniSB.body0
                    .colour(UiConstants.primaryColor),
              ),
            )
          ],
        ),
      ),
    );
  }

  String getFundType(String? fundType) {
    switch (fundType) {
      case Constants.ASSET_TYPE_FLO_FIXED_6:
        return "12%";
      case Constants.ASSET_TYPE_FLO_FIXED_3:
        return "10%";
      default:
        return "NA";
    }
  }
}
