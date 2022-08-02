import 'dart:developer';

import 'package:felloapp/core/enums/screen_item_enum.dart';
import 'package:felloapp/core/enums/transaction_state_enum.dart';
import 'package:felloapp/core/service/notifier_services/transaction_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/pages/static/new_square_background.dart';
import 'package:felloapp/ui/pages/static/seprator.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CongratulatoryCoinView extends StatelessWidget {
  CongratulatoryCoinView({
    Key key,
  }) : super(key: key);
  final TransactionService _txnService = locator<TransactionService>();
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(height: SizeConfig.padding24),
        Align(
          alignment: Alignment.centerRight,
          child: IconButton(
            icon: Icon(
              Icons.close,
              color: UiConstants.kTextColor,
              size: SizeConfig.padding24,
            ),
            onPressed: () {
              log("KUNJ: else ${AppState.screenStack.last}");
              if (AppState.screenStack.last == ScreenItem.loader) {
                AppState.screenStack.remove(AppState.screenStack.last);
                AppState.backButtonDispatcher.didPopRoute();
                _txnService.currentTransactionState =
                    TransactionState.idleTrasantion;
              }
            },
          ),
        ),
        SizedBox(height: SizeConfig.padding64),
        Image.asset(
          "assets/temp/congratulation_dialog_coin_logo.png",
          width: SizeConfig.screenWidth * 0.56,
          height: SizeConfig.screenWidth * 0.4933,
        ),
        SizedBox(height: SizeConfig.padding32),
        Text(
          "Wohoo!",
          style: TextStyles.rajdhaniB.title2,
        ),
        SizedBox(height: SizeConfig.padding12),
        Text(
          "${(_txnService.depositFcmResponseModel.amount).toInt()} Fello tokens won!",
          style: TextStyles.sourceSans.body2,
        ),
        Spacer(),
        Container(
          margin: EdgeInsets.symmetric(horizontal: SizeConfig.padding24),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(SizeConfig.roundness12),
            color: UiConstants.kRechargeModalSheetAmountSectionBackgroundColor
                .withOpacity(0.5),
          ),
          padding: EdgeInsets.symmetric(
            horizontal: SizeConfig.padding32,
            vertical: SizeConfig.padding20,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Tokens won", style: TextStyles.rajdhaniSB.body1),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SvgPicture.asset(
                    'assets/temp/Tokens.svg',
                    width: SizeConfig.iconSize5,
                    height: SizeConfig.iconSize5,
                  ),
                  SizedBox(width: SizeConfig.padding2),
                  Text(
                      "${(_txnService.depositFcmResponseModel.amount).toInt()}",
                      style: TextStyles.sourceSansSB.body2),
                ],
              ),
            ],
          ),
        ),
        SizedBox(height: SizeConfig.padding8),
        Container(
          margin: EdgeInsets.symmetric(horizontal: SizeConfig.padding24),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(SizeConfig.roundness12),
            color: UiConstants.kRechargeModalSheetAmountSectionBackgroundColor
                .withOpacity(0.8),
          ),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: SizeConfig.padding24,
                  vertical: SizeConfig.padding20,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "Invested",
                      style: TextStyles.sourceSans.body3.setOpecity(0.5),
                    ),
                    Spacer(),
                    Text(
                      "₹${_txnService.depositFcmResponseModel.amount}",
                      style: TextStyles.sourceSansSB.body2,
                    ),
                  ],
                ),
              ),
              Separator(
                color: UiConstants.kTextColor.withOpacity(0.2),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: SizeConfig.padding24,
                  vertical: SizeConfig.padding6,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "Total Digital Gold",
                      style: TextStyles.sourceSans.body3.setOpecity(0.5),
                    ),
                    Spacer(),
                    SvgPicture.asset(
                      'assets/temp/digital_gold.svg',
                      height: SizeConfig.screenWidth * 0.12,
                      width: SizeConfig.screenWidth * 0.12,
                    ),
                    Text(
                      "${_txnService.depositFcmResponseModel.augmontGoldQty}g",
                      style: TextStyles.sourceSansSB.body2,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Spacer()
      ],
    );
  }
}
