import 'dart:io';

import 'package:animations/animations.dart';
import 'package:felloapp/core/enums/investment_type.dart';
import 'package:felloapp/core/enums/transaction_state_enum.dart';
import 'package:felloapp/core/enums/transaction_type_enum.dart';
import 'package:felloapp/core/enums/view_state_enum.dart';
import 'package:felloapp/core/service/payments/augmont_transaction_service.dart';
import 'package:felloapp/core/service/payments/lendbox_transaction_service.dart';
import 'package:felloapp/navigator/back_button_actions.dart';
import 'package:felloapp/ui/architecture/base_view.dart';
import 'package:felloapp/ui/pages/buy_flow/buy_input_view.dart';
import 'package:felloapp/ui/pages/finance/augmont/gold_buy/gold_buy_loading_view.dart';
import 'package:felloapp/ui/pages/finance/augmont/gold_buy/gold_buy_success_view.dart';
import 'package:felloapp/ui/pages/finance/lendbox/lendbox_loading_view.dart';
import 'package:felloapp/ui/pages/finance/lendbox/lendbox_success_view.dart';
import 'package:felloapp/ui/pages/static/loader_widget.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:provider/provider.dart';

import 'buy_vm.dart';

InvestmentType? investmentAsset;

class BuyModalSheet extends StatefulWidget {
  final int? amount;
  final bool skipMl;
  final OnAmountChanged onChanged;
  final InvestmentType? investmentType;

  const BuyModalSheet(
      {Key? key,
      this.amount,
      this.skipMl = false,
      required this.onChanged,
      this.investmentType})
      : super(key: key);

  @override
  State<BuyModalSheet> createState() => _GoldBuyViewState();
}

class _GoldBuyViewState extends State<BuyModalSheet>
    with WidgetsBindingObserver, SingleTickerProviderStateMixin {
  final AugmontTransactionService _txnService =
      locator<AugmontTransactionService>();

  final LendboxTransactionService _lendboxTxnService =
      locator<LendboxTransactionService>();

  AppLifecycleState? appLifecycleState;
  final iosScreenShotChannel = const MethodChannel('secureScreenshotChannel');

  @override
  void initState() {
    super.initState();
    investmentAsset = widget.investmentType;
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      _txnService.currentTxnGms = 0.0;
      _txnService.currentTxnAmount = 0.0;
      _txnService.currentTxnOrderId = '';
      _txnService.currentTxnScratchCardCount = 0;
      _txnService.currentTxnTambolaTicketsCount = 0;
      _txnService.currentTransactionState = TransactionState.idle;
      _lendboxTxnService.currentTransactionState = TransactionState.idle;
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
      if (widget.investmentType == InvestmentType.AUGGOLD99) {
        if (!_txnService.isIOSTxnInProgress) return;
        _txnService.isIOSTxnInProgress = false;
        _txnService.initiatePolling();
      }

      if (widget.investmentType == InvestmentType.LENDBOXP2P) {
        if (!_lendboxTxnService.isIOSTxnInProgress) return;
        _lendboxTxnService.isIOSTxnInProgress = false;
        _lendboxTxnService.initiatePolling();
      }
    }
    super.didChangeAppLifecycleState(state);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<AugmontTransactionService, LendboxTransactionService>(
      builder: (transactionContext, augmontTxnService, lendBoxTxnService,
          transactionProperty) {
        return AnimatedContainer(
          width: double.infinity,
          height: SizeConfig.screenHeight,
          decoration: BoxDecoration(
            color: UiConstants.kRechargeModalSheetAmountSectionBackgroundColor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(SizeConfig.padding16),
              topRight: Radius.circular(SizeConfig.padding16),
            ),
          ),
          duration: const Duration(milliseconds: 500),
          child: Stack(
            children: [
              _getBackground(augmontTxnService, lendBoxTxnService),
              PageTransitionSwitcher(
                duration: const Duration(milliseconds: 500),
                transitionBuilder: (
                  child,
                  animation,
                  secondaryAnimation,
                ) {
                  return FadeThroughTransition(
                    fillColor: Colors.transparent,
                    animation: animation,
                    secondaryAnimation: secondaryAnimation,
                    child: child,
                  );
                },
                child: BaseView<BuyViewModel>(
                  onModelReady: (model) => model.init(
                    widget.amount,
                    widget.skipMl,
                    this,
                    investmentType: widget.investmentType,
                  ),
                  builder: (ctx, model, child) {
                    if (model.state == ViewState.Busy) {
                      return const Center(child: FullScreenLoader());
                    }
                    _secureScreenshots(augmontTxnService, lendBoxTxnService);

                    return _getView(
                      model,
                      widget.investmentType,
                      augmontTxnService,
                      lendBoxTxnService,
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
      BuyViewModel model,
      InvestmentType? investmentType,
      AugmontTransactionService augmontTransactionService,
      LendboxTransactionService lendboxTransactionService) {
    switch (investmentAsset) {
      case InvestmentType.LENDBOXP2P:
        const type = TransactionType.DEPOSIT;

        if (lendboxTransactionService.currentTransactionState ==
            TransactionState.idle) {
          return BuyInputView(
            amount: widget.amount,
            skipMl: widget.skipMl,
            model: model,
            // augTxnService: txnService,
            investmentType: widget.investmentType,
          );
          // return LendboxBuyInputView(
          //   amount: widget.amount,
          //   skipMl: widget.skipMl,
          //   model: model,
          // );
        } else if (lendboxTransactionService.currentTransactionState ==
            TransactionState.ongoing) {
          return LendboxLoadingView(transactionType: type);
        } else if (lendboxTransactionService.currentTransactionState ==
            TransactionState.success) {
          return LendboxSuccessView(
            transactionType: type,
          );
        }

        return LendboxLoadingView(transactionType: type);

      case InvestmentType.AUGGOLD99:
      default:
        if (augmontTransactionService.currentTransactionState ==
            TransactionState.idle) {
          return BuyInputView(
            amount: widget.amount,
            skipMl: widget.skipMl,
            model: model,
            investmentType: widget.investmentType,
          );
        } else if (augmontTransactionService.currentTransactionState ==
            TransactionState.ongoing) {
          return GoldBuyLoadingView(model: model);
        } else if (augmontTransactionService.currentTransactionState ==
            TransactionState.success) {
          return GoldBuySuccessView();
        }

        return GoldBuyLoadingView(model: model);
    }
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

  _secureScreenshots(AugmontTransactionService augmontTransactionService,
      LendboxTransactionService lendboxTransactionService) async {
    if (Platform.isAndroid) {
      if (augmontTransactionService.currentTransactionState ==
              TransactionState.ongoing ||
          lendboxTransactionService.currentTransactionState ==
              TransactionState.ongoing) {
        await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
      } else {
        await FlutterWindowManager.clearFlags(FlutterWindowManager.FLAG_SECURE);
      }
    }
    if (Platform.isIOS) {
      if (augmontTransactionService.currentTransactionState ==
              TransactionState.ongoing ||
          lendboxTransactionService.currentTransactionState ==
              TransactionState.ongoing) {
        iosScreenShotChannel.invokeMethod('secureiOS');
      } else {
        iosScreenShotChannel.invokeMethod("unSecureiOS");
      }
    }
  }

  _getBackground(AugmontTransactionService augmontTransactionService,
      LendboxTransactionService lendboxTransactionService) {
    if (augmontTransactionService.currentTransactionState ==
            TransactionState.idle ||
        lendboxTransactionService.currentTransactionState ==
            TransactionState.idle) {
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
    } else if (augmontTransactionService.currentTransactionState ==
            TransactionState.ongoing ||
        lendboxTransactionService.currentTransactionState ==
            TransactionState.ongoing) {
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
    } else if (augmontTransactionService.currentTransactionState ==
            TransactionState.success ||
        lendboxTransactionService.currentTransactionState ==
            TransactionState.success) {
      return Container(
        color: UiConstants.kBackgroundColor2,
      );
    }
    return Container();
  }
}
