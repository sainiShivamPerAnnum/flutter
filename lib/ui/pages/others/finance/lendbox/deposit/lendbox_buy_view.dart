import 'package:animations/animations.dart';
import 'package:felloapp/core/enums/transaction_service_enum.dart';
import 'package:felloapp/core/enums/transaction_state_enum.dart';
import 'package:felloapp/core/enums/transaction_type_enum.dart';
import 'package:felloapp/core/service/payments/lendbox_transaction_service.dart';
import 'package:felloapp/ui/architecture/base_view.dart';
import 'package:felloapp/ui/pages/others/finance/lendbox/deposit/lendbox_buy_vm.dart';
import 'package:felloapp/ui/pages/others/finance/lendbox/deposit/lendbox_buy_input_view.dart';
import 'package:felloapp/ui/pages/others/finance/lendbox/lendbox_loading_view.dart';
import 'package:felloapp/ui/pages/others/finance/lendbox/lendbox_success_view.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:property_change_notifier/property_change_notifier.dart';

class LendboxBuyView extends StatefulWidget {
  final int amount;
  final bool skipMl;

  const LendboxBuyView({Key key, this.amount = 250, this.skipMl = false})
      : super(key: key);

  @override
  State<LendboxBuyView> createState() => _LendboxBuyViewState();
}

class _LendboxBuyViewState extends State<LendboxBuyView>
    with WidgetsBindingObserver {
  final LendboxTransactionService _txnService =
      locator<LendboxTransactionService>();
  AppLifecycleState appLifecycleState;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _txnService.currentTransactionState = TransactionState.idle;
    });
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
      if (!_txnService.isIOSTxnInProgress) return;
      _txnService.isIOSTxnInProgress = false;
      _txnService.initiatePolling();
    }
    super.didChangeAppLifecycleState(state);
  }

  @override
  Widget build(BuildContext context) {
    return PropertyChangeConsumer<LendboxTransactionService,
        TransactionServiceProperties>(
      properties: [
        TransactionServiceProperties.transactionState,
        TransactionServiceProperties.transactionStatus
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
                child: BaseView<LendboxBuyViewModel>(
                  onModelReady: (model) => model.init(
                    widget.amount,
                    widget.skipMl,
                  ),
                  builder: (ctx, model, child) {
                    return _getView(
                      txnService,
                      model,
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _getView(
    LendboxTransactionService txnService,
    LendboxBuyViewModel model,
  ) {
    final type = TransactionType.DEPOSIT;

    if (txnService.currentTransactionState == TransactionState.idle) {
      return LendboxBuyInputView(
        amount: widget.amount,
        skipMl: widget.skipMl,
        model: model,
      );
    } else if (txnService.currentTransactionState == TransactionState.ongoing) {
      return LendboxLoadingView(transactionType: type);
    } else if (txnService.currentTransactionState == TransactionState.success) {
      return LendboxSuccessView(
        transactionType: type,
      );
    }

    return LendboxLoadingView(transactionType: type);
  }

  double _getHeight(txnService) {
    if (txnService.currentTransactionState == TransactionState.idle) {
      return SizeConfig.screenHeight * 0.8;
    } else if (txnService.currentTransactionState == TransactionState.ongoing) {
      return SizeConfig.screenHeight * 0.95;
    } else if (txnService.currentTransactionState == TransactionState.success) {
      return SizeConfig.screenHeight;
    }
    return 0;
  }

  _getBackground(LendboxTransactionService txnService) {
    if (txnService.currentTransactionState == TransactionState.idle) {
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
    } else if (txnService.currentTransactionState == TransactionState.ongoing) {
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
    } else if (txnService.currentTransactionState == TransactionState.success) {
      return Container(
        color: UiConstants.kBackgroundColor2,
      );
    }
    return Container();
  }
}
