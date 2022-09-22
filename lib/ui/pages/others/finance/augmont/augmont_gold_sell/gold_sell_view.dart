import 'package:animations/animations.dart';
import 'package:felloapp/core/enums/transaction_service_enum.dart';
import 'package:felloapp/core/enums/transaction_state_enum.dart';
import 'package:felloapp/core/service/notifier_services/transaction_service.dart';
import 'package:felloapp/ui/architecture/base_view.dart';
import 'package:felloapp/ui/pages/others/finance/augmont/augmont_gold_sell/gold_sell_input_view.dart';
import 'package:felloapp/ui/pages/others/finance/augmont/augmont_gold_sell/gold_sell_loading_view.dart';
import 'package:felloapp/ui/pages/others/finance/augmont/augmont_gold_sell/gold_sell_success_view.dart';
import 'package:felloapp/ui/pages/others/finance/augmont/augmont_gold_sell/gold_sell_vm.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:property_change_notifier/property_change_notifier.dart';

class GoldSellView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PropertyChangeConsumer<AugmontTransactionService,
        GoldTransactionServiceProperties>(
      properties: [
        GoldTransactionServiceProperties.transactionState,
        GoldTransactionServiceProperties.transactionStatus
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
                child: BaseView<GoldSellViewModel>(
                  onModelReady: (model) {
                    model.init();
                  },
                  onModelDispose: (model) {},
                  builder: (ctx, model, child) => _getView(txnService, model),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _getView(
      AugmontTransactionService txnService, GoldSellViewModel model) {
    if (txnService.currentTransactionState == TransactionState.idleTrasantion) {
      return GoldSellInputView(model: model, augTxnservice: txnService);
    } else if (txnService.currentTransactionState ==
        TransactionState.ongoingTransaction) {
      return GoldSellLoadingView(model: model, augTxnservice: txnService);
    } else if (txnService.currentTransactionState ==
        TransactionState.successTransaction) {
      return GoldSellSuccessView(model: model, augTxnservice: txnService);
    }
    return GoldSellInputView(model: model, augTxnservice: txnService);
  }

  double _getHeight(txnService) {
    if (txnService.currentTransactionState == TransactionState.idleTrasantion) {
      return SizeConfig.screenHeight * 0.9;
    } else if (txnService.currentTransactionState ==
        TransactionState.ongoingTransaction) {
      return SizeConfig.screenHeight * 0.95;
    } else if (txnService.currentTransactionState ==
        TransactionState.successTransaction) {
      return SizeConfig.screenHeight;
    }

    return 0;
  }

  _getBackground(AugmontTransactionService txnService) {
    if (txnService.currentTransactionState == TransactionState.idleTrasantion) {
      return Container(
        decoration: BoxDecoration(
          color: UiConstants.kRechargeModalSheetAmountSectionBackgroundColor,
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
          color: UiConstants.kRechargeModalSheetAmountSectionBackgroundColor,
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
      return Container(
        color: UiConstants.kBackgroundColor2,
      );
    }
    return Container();
  }
}
