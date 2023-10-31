import 'dart:async';
import 'dart:developer';

import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/enums/investment_type.dart';
import 'package:felloapp/core/enums/transaction_state_enum.dart';
import 'package:felloapp/core/enums/transaction_type_enum.dart';
import 'package:felloapp/core/service/notifier_services/transaction_history_service.dart';
import 'package:felloapp/core/service/payments/lendbox_transaction_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/back_button_actions.dart';
import 'package:felloapp/ui/pages/finance/augmont/gold_buy/augmont_buy_vm.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class LendboxLoadingView extends StatelessWidget {
  final TransactionType transactionType;
  final LendboxTransactionService _txnService =
      locator<LendboxTransactionService>();
  final int waitTimeInSec = 60;

  LendboxLoadingView({required this.transactionType, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    S locale = S.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(height: SizeConfig.fToolBarHeight / 2),
        Text(locale.felloFloText, style: TextStyles.rajdhaniSB.body2),
        SizedBox(
          height: SizeConfig.padding12,
          width: SizeConfig.screenWidth,
        ),
        Text(
          "Earn up to 12% Returns",
          style: TextStyles.sourceSans.body4.colour(UiConstants.kTextColor3),
        ),
        Expanded(
          child: Lottie.network(Assets.floDepostLoadingLottie,
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
                await _txnService.transactionProcessFuture;
                if (_txnService.currentTransactionState !=
                    TransactionState.ongoing) return;

                locator<BackButtonActions>().isTransactionCancelled = false;
                AppState.onTap = null;
                AppState.amt = 0;
                AppState.isRepeated = false;
                AppState.isTxnProcessing = true;
                AppState.type = null;
                _txnService.currentTransactionState = TransactionState.idle;
                unawaited(locator<TxnHistoryService>()
                    .updateTransactions(InvestmentType.LENDBOXP2P));
                log("Screen Stack:${AppState.screenStack.toString()}");
                AppState.unblockNavigation();
                log("Screen Stack:${AppState.screenStack.toString()}");

                // while (AppState.screenStack.length > 1) {
                await AppState.backButtonDispatcher!.didPopRoute();
                // }
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

  void showTransactionPendingDialog() {
    BaseUtil.openDialog(
      addToScreenStack: true,
      hapticVibrate: true,
      isBarrierDismissible: false,
      content: const PendingDialog(
        title: "We're still processing!",
        subtitle:
            "Your transaction is taking longer than usual. We'll get back to you in ",
        duration: '15 minutes',
      ),
    );
  }
}
