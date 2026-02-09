import 'dart:io';

import 'package:animations/animations.dart';
import 'package:felloapp/core/enums/transaction_state_enum.dart';
import 'package:felloapp/core/enums/view_state_enum.dart';
import 'package:felloapp/core/service/payments/silver_transaction_service.dart';
import 'package:felloapp/ui/architecture/base_view.dart';
import 'package:felloapp/ui/pages/finance/augmont/silver_buy/silver_buy_input_view.dart';
import 'package:felloapp/ui/pages/finance/augmont/silver_buy/silver_buy_loading_view.dart';
import 'package:felloapp/ui/pages/finance/augmont/silver_buy/silver_buy_success_view.dart';
import 'package:felloapp/ui/pages/static/loader_widget.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:provider/provider.dart';

import 'augmont_buy_vm.dart';

class SilverBuyView extends StatefulWidget {
  final int? amount;
  final bool skipMl;
  final double? gms;
  final String? initialCoupon;
  final String? entryPoint;
  final bool quickCheckout;

  const SilverBuyView({
    super.key,
    this.amount,
    this.skipMl = false,
    this.gms,
    this.initialCoupon,
    this.entryPoint,
    this.quickCheckout = false,
  });

  @override
  State<SilverBuyView> createState() => _SilverBuyViewState();
}

class _SilverBuyViewState extends State<SilverBuyView>
    with WidgetsBindingObserver, SingleTickerProviderStateMixin {
  final AugmontSilverTransactionService _txnService =
      locator<AugmontSilverTransactionService>();

  final iosScreenShotChannel = const MethodChannel('secureScreenshotChannel');

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _txnService.currentTxnGms = 0.0;
      _txnService.currentTxnAmount = 0.0;
      _txnService.currentTxnOrderId = '';
      _txnService.currentTxnScratchCardCount = 0;
      _txnService.currentTxnTambolaTicketsCount = 0;
      _txnService.isIOSTxnInProgress = false;
      _txnService.isSilverBuyInProgress = false;

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
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed &&
        Platform.isIOS &&
        _txnService.isIOSTxnInProgress) {
      _txnService.isIOSTxnInProgress = false;
      _txnService.currentTransactionState = TransactionState.ongoing;
      _txnService.checkTransactionStatus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AugmontSilverTransactionService>(
      builder: (transactionContext, txnService, _) {
        return MediaQuery.removePadding(
          context: context,
          removeTop: true,
          child: Material(
            borderRadius: BorderRadius.zero,
            color: Colors.transparent,
            elevation: 0,
            shadowColor: Colors.transparent,
            child: AnimatedContainer(
              width: double.infinity,
              height: _getHeight(txnService),
              duration: const Duration(milliseconds: 500),
              child: Stack(
                children: [
                  _getBackground(txnService),
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
                    child: BaseView<SilverBuyViewModel>(
                      onModelReady: (model) => model.init(
                        widget.amount,
                        widget.skipMl,
                        this,
                        widget.gms,
                        initialCouponCode: widget.initialCoupon,
                        entryPoint: widget.entryPoint,
                        quickCheckout: widget.quickCheckout,
                      ),
                      builder: (ctx, model, child) {
                        if (model.state == ViewState.Busy) {
                          return const Center(child: FullScreenLoader());
                        }
                        _secureScreenshots(txnService);

                        return _getView(txnService, model);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _getView(AugmontSilverTransactionService service, SilverBuyViewModel model)
  {
    switch (service.currentTransactionState) {
      case TransactionState.idle:
        return SilverBuyInputView(
          amount: widget.amount,
          skipMl: widget.skipMl,
          model: model,
          augTxnService: service,
        );

      case TransactionState.ongoing:
      case TransactionState.overView:
        return SilverBuyLoadingView(model: model);

      case TransactionState.success:
        return const SilverBuySuccessView();
    }
  }

  double? _getHeight(txnService) {
    if (txnService.currentTransactionState == TransactionState.idle) {
      return SizeConfig.screenHeight!;
    } else if (txnService.currentTransactionState == TransactionState.ongoing) {
      return SizeConfig.screenHeight!;
    } else if (txnService.currentTransactionState == TransactionState.success) {
      return SizeConfig.screenHeight;
    }
    return 0;
  }

  Future<void> _secureScreenshots(AugmontSilverTransactionService txnService) async {
    if (txnService.isNetBankingInProgress) return;
    if (Platform.isAndroid) {
      if (txnService.currentTransactionState == TransactionState.ongoing) {
        await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
      } else {
        await FlutterWindowManager.clearFlags(FlutterWindowManager.FLAG_SECURE);
      }
    }
    if (Platform.isIOS) {
      if (txnService.currentTransactionState == TransactionState.ongoing) {
        await iosScreenShotChannel.invokeMethod('secureiOS');
      } else {
        await iosScreenShotChannel.invokeMethod("unSecureiOS");
      }
    }
  }

  Widget _getBackground(AugmontSilverTransactionService txnService) {
    if (txnService.currentTransactionState == TransactionState.idle) {
      return Container(
        color: UiConstants.kRechargeModalSheetAmountSectionBackgroundColor,
        width: double.infinity,
        height: double.infinity,
      );
    } else if (txnService.currentTransactionState == TransactionState.ongoing) {
      return Container(
        color: UiConstants.kRechargeModalSheetAmountSectionBackgroundColor,
        width: double.infinity,
        height: double.infinity,
      );
    } else if (txnService.currentTransactionState == TransactionState.success) {
      return Container(
        color: UiConstants.kBackgroundColor2,
      );
    }
    return const SizedBox.shrink();
  }
}