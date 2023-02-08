import 'dart:io';

import 'package:animations/animations.dart';
import 'package:felloapp/core/enums/transaction_state_enum.dart';
import 'package:felloapp/core/enums/view_state_enum.dart';
import 'package:felloapp/core/service/payments/augmont_transaction_service.dart';
import 'package:felloapp/navigator/back_button_actions.dart';
import 'package:felloapp/ui/architecture/base_view.dart';
import 'package:felloapp/ui/pages/finance/augmont/gold_buy/augmont_buy_vm.dart';
import 'package:felloapp/ui/pages/finance/augmont/gold_buy/gold_buy_input_view.dart';
import 'package:felloapp/ui/pages/finance/augmont/gold_buy/gold_buy_loading_view.dart';
import 'package:felloapp/ui/pages/finance/augmont/gold_buy/gold_buy_success_view.dart';
import 'package:felloapp/ui/pages/static/loader_widget.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:provider/provider.dart';

class GoldBuyView extends StatefulWidget {
  final int? amount;
  final bool skipMl;
  final OnAmountChanged onChanged;
  const GoldBuyView(
      {Key? key, this.amount, this.skipMl = false, required this.onChanged})
      : super(key: key);

  @override
  State<GoldBuyView> createState() => _GoldBuyViewState();
}

class _GoldBuyViewState extends State<GoldBuyView>
    with WidgetsBindingObserver, SingleTickerProviderStateMixin {
  final AugmontTransactionService _txnService =
      locator<AugmontTransactionService>();
  AppLifecycleState? appLifecycleState;
  final iosScreenShotChannel = const MethodChannel('secureScreenshotChannel');
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      _txnService.currentTxnGms = 0.0;
      _txnService.currentTxnAmount = 0.0;
      _txnService.currentTxnOrderId = '';
      _txnService.currentTxnScratchCardCount = 0;
      _txnService.currentTxnTambolaTicketsCount = 0;
      _txnService.currentTransactionState = TransactionState.idle;
    });
    WidgetsBinding.instance!.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
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
    return Consumer<AugmontTransactionService>(
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
              _getBackground(txnService!),
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
                child: BaseView<GoldBuyViewModel>(
                  onModelReady: (model) =>
                      model.init(widget.amount, widget.skipMl, this),
                  builder: (ctx, model, child) {
                    if (model.state == ViewState.Busy)
                      return Center(child: FullScreenLoader());
                    _secureScreenshots(txnService);

                    return _getView(txnService, model);
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
      AugmontTransactionService txnService, GoldBuyViewModel model) {
    if (txnService.currentTransactionState == TransactionState.idle) {
      return GoldBuyInputView(
        // amount: widget.amount,
        skipMl: widget.skipMl,
        model: model,
        augTxnService: txnService,
      );
    } else if (txnService.currentTransactionState == TransactionState.ongoing) {
      return GoldBuyLoadingView(model: model);
    } else if (txnService.currentTransactionState == TransactionState.success) {
      return GoldBuySuccessView();
    }

    return GoldBuyLoadingView(model: model);
  }

  double? _getHeight(txnService) {
    if (txnService.currentTransactionState == TransactionState.idle) {
      return SizeConfig.screenHeight! * 0.95;
    } else if (txnService.currentTransactionState == TransactionState.ongoing) {
      return SizeConfig.screenHeight! * 0.95;
    } else if (txnService.currentTransactionState == TransactionState.success) {
      return SizeConfig.screenHeight;
    }
    return 0;
  }

  _secureScreenshots(AugmontTransactionService txnService) async {
    if (Platform.isAndroid) {
      if (txnService.currentTransactionState == TransactionState.ongoing) {
        await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
      } else {
        await FlutterWindowManager.clearFlags(FlutterWindowManager.FLAG_SECURE);
      }
    }
    if (Platform.isIOS) {
      if (txnService.currentTransactionState == TransactionState.ongoing) {
        iosScreenShotChannel.invokeMethod('secureiOS');
      } else {
        iosScreenShotChannel.invokeMethod("unSecureiOS");
      }
    }
  }

  _getBackground(AugmontTransactionService txnService) {
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
