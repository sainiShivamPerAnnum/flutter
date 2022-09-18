import 'dart:developer';
import "dart:math" as math;

import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/enums/screen_item_enum.dart';
import 'package:felloapp/core/enums/transaction_state_enum.dart';
import 'package:felloapp/core/service/notifier_services/transaction_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/pages/others/finance/augmont/augmont_buy_screen/augmont_buy_vm.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lottie/lottie.dart';

class RechargeLoadingView extends StatelessWidget {
  final AugmontGoldBuyViewModel model;
  RechargeLoadingView({@required this.model});
  final TransactionService _txnService = locator<TransactionService>();
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(height: SizeConfig.padding32),
        Text('Digital Gold', style: TextStyles.rajdhaniSB.body2),
        SizedBox(
          height: SizeConfig.padding12,
          width: SizeConfig.screenWidth,
        ),
        Text(
          "Safest Digital Investment",
          style: TextStyles.sourceSans.body4.colour(UiConstants.kTextColor3),
        ),
        Expanded(
          child: Lottie.asset(Assets.goldDepostLoadingLottie,
              height: SizeConfig.screenHeight * 0.7),
        ),
        Column(
          children: [
            Text(
              "Your transaction is in progress",
              style:
                  TextStyles.sourceSans.body2.colour(UiConstants.kTextColor2),
            ),
            SizedBox(height: SizeConfig.padding16),
            TweenAnimationBuilder<Duration>(
              duration: Duration(seconds: 30),
              tween: Tween(
                begin: Duration(seconds: 30),
                end: Duration.zero,
              ),
              onEnd: () {},
              builder: (BuildContext context, Duration value, Widget child) {
                final seconds = value.inSeconds % 60;
                return Container(
                  width: SizeConfig.screenWidth * 0.7,
                  child: LinearProgressIndicator(
                    value: 1 - (seconds / 30),
                    color: UiConstants.primaryColor,
                    backgroundColor: UiConstants.kDarkBackgroundColor,
                  ),
                );
              },
            ),
            SizedBox(height: SizeConfig.padding16),
            TweenAnimationBuilder<Duration>(
              duration: Duration(seconds: 30),
              tween: Tween(
                begin: Duration(seconds: 30),
                end: Duration.zero,
              ),
              onEnd: () {
                if (_txnService.currentTransactionState !=
                    TransactionState.ongoingTransaction) return;
                AppState.pollingPeriodicTimer?.cancel();

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
}
