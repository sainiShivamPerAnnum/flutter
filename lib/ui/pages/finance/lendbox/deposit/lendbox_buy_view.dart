import 'dart:io';

import 'package:animations/animations.dart';
import 'package:felloapp/core/enums/transaction_state_enum.dart';
import 'package:felloapp/core/enums/transaction_type_enum.dart';
import 'package:felloapp/core/enums/view_state_enum.dart';
import 'package:felloapp/core/service/payments/lendbox_transaction_service.dart';
import 'package:felloapp/navigator/back_button_actions.dart';
import 'package:felloapp/ui/architecture/base_view.dart';
import 'package:felloapp/ui/pages/finance/lendbox/deposit/lendbox_buy_input_view.dart';
import 'package:felloapp/ui/pages/finance/lendbox/deposit/lendbox_buy_vm.dart';
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

class LendboxBuyView extends StatefulWidget {
  final int? amount;
  final bool skipMl;
  final OnAmountChanged? onChanged;
  final String floAssetType;
  final String? initialCouponCode;
  final String? entryPoint;
  final bool quickCheckout;

  const LendboxBuyView({
    required this.onChanged,
    required this.floAssetType,
    super.key,
    this.amount = 250,
    this.skipMl = false,
    this.initialCouponCode,
    this.entryPoint,
    this.quickCheckout = false,
  });

  @override
  State<LendboxBuyView> createState() => _LendboxBuyViewState();
}

class _LendboxBuyViewState extends State<LendboxBuyView>
    with WidgetsBindingObserver, SingleTickerProviderStateMixin {
  final LendboxTransactionService _txnService =
      locator<LendboxTransactionService>();
  AppLifecycleState? appLifecycleState;

  final iosScreenShotChannel = const MethodChannel('secureScreenshotChannel');

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _txnService.isIOSTxnInProgress = false;
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
    if (appLifecycleState == AppLifecycleState.resumed &&
        Platform.isIOS &&
        _txnService.isIOSTxnInProgress) {
      _txnService.isIOSTxnInProgress = false;
      _txnService.currentTransactionState = TransactionState.ongoing;
      _txnService.initiatePolling();
    }
    super.didChangeAppLifecycleState(state);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Consumer<LendboxTransactionService>(
        builder: (transactionContext, lboxTxnService, transactionProperty) {
          return AnimatedContainer(
            width: double.infinity,
            height: _getHeight(lboxTxnService),
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
                _getBackground(lboxTxnService),
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
                  child: BaseView<LendboxBuyViewModel>(
                    onModelReady: (model) => model.init(
                      widget.amount,
                      widget.skipMl,
                      this,
                      assetTypeFlow: widget.floAssetType,
                      initialCouponCode: widget.initialCouponCode,
                      entryPoint: widget.entryPoint,
                      quickCheckout: widget.quickCheckout,
                    ),
                    builder: (ctx, model, child) {
                      _secureScreenshots(lboxTxnService);

                      return model.state == ViewState.Busy
                          ? const Center(child: FullScreenLoader())
                          : _getView(
                              lboxTxnService,
                              model,
                            );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  _secureScreenshots(LendboxTransactionService txnService) async {
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

  Widget _getView(
    LendboxTransactionService lboxTxnService,
    LendboxBuyViewModel model,
  ) {
    const type = TransactionType.DEPOSIT;

    switch (lboxTxnService.currentTransactionState) {
      case TransactionState.idle:
        return LendboxBuyInputView(
          amount: widget.amount,
          skipMl: widget.skipMl,
          model: model,
        );

      case TransactionState.ongoing:
      case TransactionState.overView:
        return LendboxLoadingView(
          transactionType: type,
        );

      case TransactionState.success:
        return const LendboxSuccessView(
          transactionType: type,
        );
    }
  }

  double? _getHeight(lboxTxnService) {
    if (lboxTxnService.currentTransactionState == TransactionState.idle) {
      return SizeConfig.screenHeight!;
    } else if (lboxTxnService.currentTransactionState ==
        TransactionState.ongoing) {
      return SizeConfig.screenHeight!;
    } else if (lboxTxnService.currentTransactionState ==
        TransactionState.success) {
      return SizeConfig.screenHeight;
    }
    return 0;
  }

  Widget _getBackground(LendboxTransactionService lboxTxnService) {
    if (lboxTxnService.currentTransactionState == TransactionState.idle) {
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
    } else if (lboxTxnService.currentTransactionState ==
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
    } else if (lboxTxnService.currentTransactionState ==
        TransactionState.success) {
      return Container(
        color: UiConstants.kBackgroundColor2,
      );
    }
    return Container();
  }
}
