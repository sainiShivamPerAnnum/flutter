import 'dart:io';

import 'package:animations/animations.dart';
import 'package:felloapp/core/enums/transaction_state_enum.dart';
import 'package:felloapp/core/enums/transaction_type_enum.dart';
import 'package:felloapp/core/service/payments/lendbox_transaction_service.dart';
import 'package:felloapp/ui/architecture/base_view.dart';
import 'package:felloapp/ui/pages/finance/lendbox/lendbox_loading_view.dart';
import 'package:felloapp/ui/pages/finance/lendbox/withdrawal/lendbox_withdrawal_input_view.dart';
import 'package:felloapp/ui/pages/finance/lendbox/withdrawal/lendbox_withdrawal_success_view.dart';
import 'package:felloapp/ui/pages/finance/lendbox/withdrawal/lendbox_withdrawal_vm.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:provider/provider.dart';

class LendboxWithdrawalView extends StatefulWidget {
  @override
  State<LendboxWithdrawalView> createState() => _LendboxWithdrawalViewState();
}

class _LendboxWithdrawalViewState extends State<LendboxWithdrawalView>
    with WidgetsBindingObserver {
  final LendboxTransactionService _txnService =
      locator<LendboxTransactionService>();
  AppLifecycleState? appLifecycleState;
  final iosScreenShotChannel = const MethodChannel('secureScreenshotChannel');
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
      _txnService.run();
    }
    super.didChangeAppLifecycleState(state);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LendboxTransactionService>(
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
                child: BaseView<LendboxWithdrawalViewModel>(
                  onModelReady: (model) => model.init(),
                  builder: (ctx, model, child) {
                    _secureScreenshots(txnService, model);
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

  _secureScreenshots(LendboxTransactionService txnService,
      LendboxWithdrawalViewModel model) async {
    if (Platform.isAndroid) {
      if (model.inProgress ||
          txnService.currentTransactionState == TransactionState.ongoing) {
        await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
      } else {
        await FlutterWindowManager.clearFlags(FlutterWindowManager.FLAG_SECURE);
      }
    }
    if (Platform.isIOS) {
      if (model.inProgress ||
          txnService.currentTransactionState == TransactionState.ongoing) {
        iosScreenShotChannel.invokeMethod('secureiOS');
      } else {
        iosScreenShotChannel.invokeMethod("unSecureiOS");
      }
    }
  }

  Widget _getView(
    LendboxTransactionService txnService,
    LendboxWithdrawalViewModel model,
  ) {
    const type = TransactionType.WITHDRAWAL;

    if (txnService.currentTransactionState == TransactionState.idle) {
      return LendboxWithdrawalInputView(
        model: model,
      );
    } else if (txnService.currentTransactionState == TransactionState.ongoing) {
      return LendboxLoadingView(transactionType: type);
    } else if (txnService.currentTransactionState == TransactionState.success) {
      return const LendboxWithdrawalSuccessView();
    }

    return LendboxLoadingView(transactionType: type);
  }

  double? _getHeight(txnService) {
    if (txnService.currentTransactionState == TransactionState.idle) {
      return SizeConfig.screenHeight! * 0.9;
    } else if (txnService.currentTransactionState == TransactionState.ongoing) {
      return SizeConfig.screenHeight! * 0.95;
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
