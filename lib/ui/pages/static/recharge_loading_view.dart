import 'dart:developer';

import 'package:felloapp/core/enums/screen_item_enum.dart';
import 'package:felloapp/core/enums/transaction_state_enum.dart';
import 'package:felloapp/core/service/notifier_services/transaction_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class RechargeLoadingView extends StatelessWidget {
  RechargeLoadingView({Key key}) : super(key: key);
  final TransactionService _txnService = locator<TransactionService>();
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Spacer(),
        SpinKitChasingDots(
          color: UiConstants.primaryColor,
        ),
        Spacer(),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Please wait ",
              style: TextStyles.body4.colour(Colors.grey).light,
            ),
            TweenAnimationBuilder<Duration>(
              duration: Duration(seconds: 30),
              tween: Tween(
                begin: Duration(seconds: 30),
                end: Duration.zero,
              ),
              onEnd: () {
                log('Timer ended', name: 'KUNJ');
                if (_txnService.currentTransactionState !=
                    TransactionState.ongoingTransaction) return;

                _txnService.currentTransactionState =
                    TransactionState.idleTrasantion;
                log("Screen Stack:${AppState.screenStack.toString()}");
                if (AppState.screenStack.last == ScreenItem.loader) {
                  AppState.screenStack.remove(AppState.screenStack.last);
                }
                log("Screen Stack:${AppState.screenStack.toString()}");

                AppState.backButtonDispatcher.didPopRoute();
                log("Screen Stack:${AppState.screenStack.toString()}");

                _txnService.showTransactionPendingDialog();
                log("Screen Stack:${AppState.screenStack.toString()}");
              },
              builder: (BuildContext context, Duration value, Widget child) {
                final minutes = value.inMinutes;
                final seconds = value.inSeconds % 60;
                return Text(
                  '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}',
                  style: TextStyles.sourceSansB.body3
                      .colour(UiConstants.kPrimaryColor),
                );
              },
            ),
          ],
        ),
        SizedBox(height: SizeConfig.padding24),
      ],
    );
  }
}
