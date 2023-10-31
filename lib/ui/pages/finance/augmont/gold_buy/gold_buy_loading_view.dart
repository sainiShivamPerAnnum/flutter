import 'dart:async';
import 'dart:developer';

import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/enums/investment_type.dart';
import 'package:felloapp/core/enums/transaction_state_enum.dart';
import 'package:felloapp/core/service/notifier_services/transaction_history_service.dart';
import 'package:felloapp/core/service/payments/augmont_transaction_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/back_button_actions.dart';
import 'package:felloapp/ui/pages/finance/augmont/gold_buy/augmont_buy_vm.dart';
import 'package:felloapp/util/assets.dart' as a;
import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class GoldBuyLoadingView extends StatelessWidget {
  final GoldBuyViewModel model;

  GoldBuyLoadingView({required this.model, super.key});

  final AugmontTransactionService _augTxnService =
      locator<AugmontTransactionService>();
  final int waitTimeInSec = 45;

  @override
  Widget build(BuildContext context) {
    S locale = locator<S>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(height: SizeConfig.fToolBarHeight / 2),
        Text(locale.digitalGoldText, style: TextStyles.rajdhaniSB.body2),
        SizedBox(
          height: SizeConfig.padding12,
          width: SizeConfig.screenWidth,
        ),
        Text(
          locale.digitalGoldSubTitle,
          style: TextStyles.sourceSans.body4.colour(UiConstants.kTextColor3),
        ),
        Expanded(
          child: Lottie.network(a.Assets.goldDepostLoadingLottie,
              height: SizeConfig.screenHeight! * 0.7),
        ),
        Column(
          children: [
            Text(
              locale.transactionProgress,
              style:
                  TextStyles.sourceSans.body2.colour(UiConstants.kTextColor2),
            ),
            SizedBox(height: SizeConfig.padding16),
            TweenAnimationBuilder<Duration>(
              duration: Duration(seconds: waitTimeInSec),
              tween: Tween(
                begin: Duration(seconds: waitTimeInSec),
                end: Duration.zero,
              ),
              onEnd: () {},
              builder: (BuildContext context, Duration value, Widget? child) {
                final seconds = value.inSeconds % 60;
                return Container(
                  width: SizeConfig.screenWidth! * 0.7,
                  child: LinearProgressIndicator(
                    value: 1 - (seconds / waitTimeInSec),
                    color: UiConstants.primaryColor,
                    backgroundColor: UiConstants.kDarkBackgroundColor,
                  ),
                );
              },
            ),
            SizedBox(height: SizeConfig.padding16),
            TweenAnimationBuilder<Duration>(
              duration: Duration(seconds: waitTimeInSec),
              tween: Tween(
                begin: Duration(seconds: waitTimeInSec),
                end: Duration.zero,
              ),
              onEnd: () async {
                // TODO: Check whethere it is required or not.
                // await _augTxnService!.validateResponse();
                if (_augTxnService!.currentTransactionState !=
                    TransactionState.ongoing) return;
                _augTxnService!.isGoldBuyInProgress = false;
                _augTxnService!.currentTransactionState = TransactionState.idle;
                locator<BackButtonActions>().isTransactionCancelled = false;
                AppState.onTap = null;
                AppState.amt = 0;
                AppState.isRepeated = false;
                AppState.type = null;
                AppState.isTxnProcessing = true;
                unawaited(locator<TxnHistoryService>()
                    .updateTransactions(InvestmentType.AUGGOLD99));
                log("Screen Stack:${AppState.screenStack.toString()}");
                AppState.unblockNavigation();
                log("Screen Stack:${AppState.screenStack.toString()}");

                AppState.backButtonDispatcher!.didPopRoute();
                log("Screen Stack:${AppState.screenStack.toString()}");

                showTransactionPendingDialog();
                log("Screen Stack:${AppState.screenStack.toString()}");
              },
              builder: (BuildContext context, Duration value, Widget? child) {
                final minutes = value.inMinutes;
                final seconds = value.inSeconds % 60;
                return Text(
                  '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}',
                  style: TextStyles.sourceSansB.body3
                      .colour(UiConstants.kTextColor2),
                );
              },
            ),
          ],
        ),
        SizedBox(height: SizeConfig.padding24),
      ],
    );
  }

  showTransactionPendingDialog() {
    S locale = locator<S>();

    BaseUtil.openDialog(
      addToScreenStack: true,
      hapticVibrate: true,
      isBarrierDismissible: false,
      content: PendingDialog(
        title: locale.processing,
        subtitle: locale.txnDelay,
        duration: '15 ' + locale.minutes,
      ),
    ).then((value) {
      locator<BackButtonActions>().isTransactionCancelled = false;
      AppState.onTap = null;
      AppState.amt = 0;
      AppState.isTxnProcessing = true;
      AppState.isRepeated = false;
      AppState.type = null;
    });
  }
}
