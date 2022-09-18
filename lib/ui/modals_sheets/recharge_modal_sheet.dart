import 'package:animations/animations.dart';
import 'package:felloapp/core/enums/transaction_service_enum.dart';
import 'package:felloapp/core/enums/transaction_state_enum.dart';
import 'package:felloapp/core/service/notifier_services/paytm_service.dart';
import 'package:felloapp/core/service/notifier_services/transaction_service.dart';
import 'package:felloapp/ui/architecture/base_view.dart';
import 'package:felloapp/ui/pages/others/finance/augmont/augmont_buy_screen/augmont_buy_vm.dart';
import 'package:felloapp/ui/pages/others/finance/augmont/augmont_buy_screen/new_augmont_buy_view.dart';
import 'package:felloapp/ui/pages/static/congratulatory_coin_view.dart';
import 'package:felloapp/ui/pages/static/congratulatory_view.dart';
import 'package:felloapp/ui/pages/static/new_square_background.dart';
import 'package:felloapp/ui/pages/static/recharge_loading_view.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:property_change_notifier/property_change_notifier.dart';

class RechargeModalSheet extends StatefulWidget {
  final int amount;
  final bool skipMl;
  const RechargeModalSheet({Key key, this.amount = 250, this.skipMl = false})
      : super(key: key);

  @override
  State<RechargeModalSheet> createState() => _RechargeModalSheetState();
}

class _RechargeModalSheetState extends State<RechargeModalSheet>
    with WidgetsBindingObserver {
  final PaytmService _paytmService = locator<PaytmService>();
  final TransactionService _txnService = locator<TransactionService>();
  AppLifecycleState appLifecycleState;

  @override
  void initState() {
    super.initState();
    _txnService.currentTransactionState = TransactionState.idleTrasantion;
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    appLifecycleState = state;
    if (appLifecycleState == AppLifecycleState.resumed) {
      _paytmService.handleIOSUpiTransaction();
    }
    super.didChangeAppLifecycleState(state);
  }

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
                  child: BaseView<AugmontGoldBuyViewModel>(
                      onModelReady: (model) =>
                          model.init(widget.amount, widget.skipMl),
                      builder: (ctx, model, child) {
                        return _getView(txnService, model);
                      })),
            ],
          ),
        );
      },
    );
  }

  Widget _getView(
      TransactionService txnService, AugmontGoldBuyViewModel model) {
    if (txnService.currentTransactionState == TransactionState.idleTrasantion) {
      return NewAugmontBuyView(
          amount: widget.amount, skipMl: widget.skipMl, model: model);
    } else if (txnService.currentTransactionState ==
        TransactionState.ongoingTransaction) {
      return RechargeLoadingView(model: model);
    } else if (txnService.currentTransactionState ==
        TransactionState.successTransaction) {
      return CongratulatoryView();
    }
    // else if (txnService.currentTransactionState ==
    //     TransactionState.successCoinTransaction) {
    //   return CongratulatoryCoinView();
    // }
    return RechargeLoadingView(model: model);
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
    // else if (txnService.currentTransactionState ==
    //     TransactionState.successCoinTransaction) {
    //   return SizeConfig.screenHeight;
    // }
    return 0;
  }

  _getBackground(TransactionService txnService) {
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
    // else if (txnService.currentTransactionState ==
    //     TransactionState.successCoinTransaction) {
    //   return NewSquareBackground();
    // }
    return Container();
  }
}
