import 'dart:io';

import 'package:animations/animations.dart';
import 'package:felloapp/core/enums/transaction_state_enum.dart';
import 'package:felloapp/core/service/payments/augmont_transaction_service.dart';
import 'package:felloapp/ui/architecture/base_view.dart';
import 'package:felloapp/ui/pages/finance/augmont/gold_sell/gold_sell_input_view.dart';
import 'package:felloapp/ui/pages/finance/augmont/gold_sell/gold_sell_loading_view.dart';
import 'package:felloapp/ui/pages/finance/augmont/gold_sell/gold_sell_success_view.dart';
import 'package:felloapp/ui/pages/finance/augmont/gold_sell/gold_sell_vm.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:provider/provider.dart';

class GoldSellView extends StatelessWidget {
  final iosScreenShotChannel = const MethodChannel('secureScreenshotChannel');

  const GoldSellView({Key? key}) : super(key: key);

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
                child: BaseView<GoldSellViewModel>(
                    onModelReady: (model) {
                      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                        txnService.currentTransactionState =
                            TransactionState.idle;
                      });
                      model.init();
                    },
                    onModelDispose: (model) {},
                    builder: (ctx, model, child) {
                      _secureScreenshots(txnService);
                      return _getView(txnService, model);
                    }),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _getView(
      AugmontTransactionService txnService, GoldSellViewModel model) {
    if (txnService.currentTransactionState == TransactionState.idle) {
      return GoldSellInputView(model: model, augTxnService: txnService);
    } else if (txnService.currentTransactionState == TransactionState.ongoing) {
      return GoldSellLoadingView(model: model);
    } else if (txnService.currentTransactionState == TransactionState.success) {
      return GoldSellSuccessView(model: model, augTxnservice: txnService);
    }
    return GoldSellInputView(model: model, augTxnService: txnService);
  }

  _secureScreenshots(AugmontTransactionService txnService) async {
    if (Platform.isAndroid) {
      if (txnService.isGoldSellInProgress ||
          txnService.currentTransactionState == TransactionState.ongoing) {
        await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
      } else {
        await FlutterWindowManager.clearFlags(FlutterWindowManager.FLAG_SECURE);
      }
    }
    if (Platform.isIOS) {
      if (txnService.isGoldSellInProgress ||
          txnService.currentTransactionState == TransactionState.ongoing) {
        iosScreenShotChannel.invokeMethod('secureiOS');
      } else {
        iosScreenShotChannel.invokeMethod("unSecureiOS");
      }
    }
  }

  double? _getHeight(txnService) {
    if (txnService.currentTransactionState == TransactionState.idle) {
      return SizeConfig.screenHeight! * 0.84;
    } else if (txnService.currentTransactionState == TransactionState.ongoing) {
      return SizeConfig.screenHeight! * 0.95;
    } else if (txnService.currentTransactionState == TransactionState.success) {
      return SizeConfig.screenHeight;
    }
    return 0;
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
