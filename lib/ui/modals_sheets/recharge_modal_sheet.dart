import 'package:animations/animations.dart';
import 'package:felloapp/core/enums/transaction_service_enum.dart';
import 'package:felloapp/core/enums/transaction_state_enum.dart';
import 'package:felloapp/core/service/notifier_services/transaction_service.dart';
import 'package:felloapp/ui/pages/others/finance/augmont/augmont_buy_screen/new_augmont_buy_view.dart';
import 'package:felloapp/ui/pages/static/congratulatory_coin_view.dart';
import 'package:felloapp/ui/pages/static/congratulatory_view.dart';
import 'package:felloapp/ui/pages/static/new_square_background.dart';
import 'package:felloapp/ui/pages/static/recharge_loading_view.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:property_change_notifier/property_change_notifier.dart';

class RechargeModalSheet extends StatelessWidget {
  final int amount;
  final bool skipMl;
  const RechargeModalSheet({Key key, this.amount = 250, this.skipMl = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PropertyChangeConsumer<TransactionService,
        TransactionServiceProperties>(
      properties: [
        TransactionServiceProperties.transactionStatus,
      ],
      builder: (transactionContext, txnService, transactionProperty) {
        return AnimatedContainer(
          width: double.infinity,
          height: _getHeight(txnService),
          decoration: BoxDecoration(
            color: UiConstants.kSecondaryBackgroundColor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(SizeConfig.padding16),
              topRight: Radius.circular(SizeConfig.padding16),
            ),
          ),
          duration: const Duration(milliseconds: 500),
          child: Stack(
            children: [
              _getBackground(txnService),
              PageTransitionSwitcher(
                duration: const Duration(milliseconds: 500),
                transitionBuilder: (
                  Widget child,
                  Animation<double> animation,
                  Animation<double> secondaryAnimation,
                ) {
                  return FadeThroughTransition(
                    fillColor: Colors.transparent,
                    child: child,
                    animation: animation,
                    secondaryAnimation: secondaryAnimation,
                  );
                },
                child: _getView(txnService),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _getView(TransactionService txnService) {
    if (txnService.currentTransactionState == TransactionState.idleTrasantion) {
      return NewAugmontBuyView(amount: amount, skipMl: skipMl);
    } else if (txnService.currentTransactionState ==
        TransactionState.ongoingTransaction) {
      return RechargeLoadingView();
    } else if (txnService.currentTransactionState ==
        TransactionState.successTransaction) {
      return CongratulatoryView();
    } else if (txnService.currentTransactionState ==
        TransactionState.successCoinTransaction) {
      return CongratulatoryCoinView();
    }
    return Container();
  }

  double _getHeight(txnService) {
    if (txnService.currentTransactionState == TransactionState.idleTrasantion) {
      return SizeConfig.screenHeight * 0.8;
    } else if (txnService.currentTransactionState ==
        TransactionState.ongoingTransaction) {
      return SizeConfig.screenHeight * 0.8;
    } else if (txnService.currentTransactionState ==
        TransactionState.successTransaction) {
      return SizeConfig.screenHeight;
    } else if (txnService.currentTransactionState ==
        TransactionState.successCoinTransaction) {
      return SizeConfig.screenHeight;
    }
    return 0;
  }

  _getBackground(TransactionService txnService) {
    if (txnService.currentTransactionState == TransactionState.idleTrasantion) {
      return Container(
        decoration: BoxDecoration(
          color: UiConstants.kSecondaryBackgroundColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(SizeConfig.padding16),
            topRight: Radius.circular(SizeConfig.padding16),
          ),
        ),
        width: double.infinity,
        height: double.infinity,
      );
    } else if (txnService.currentTransactionState ==
        TransactionState.ongoingTransaction) {
      return Container(
        decoration: BoxDecoration(
          color: UiConstants.kSecondaryBackgroundColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(SizeConfig.padding16),
            topRight: Radius.circular(SizeConfig.padding16),
          ),
        ),
        width: double.infinity,
        height: double.infinity,
      );
    } else if (txnService.currentTransactionState ==
        TransactionState.successTransaction) {
      return NewSquareBackground();
    } else if (txnService.currentTransactionState ==
        TransactionState.successCoinTransaction) {
      return NewSquareBackground();
    }
    return Container();
  }
}
