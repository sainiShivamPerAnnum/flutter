import 'dart:async';
import 'dart:io';

import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/enums/app_config_keys.dart';
import 'package:felloapp/core/enums/transaction_service_enum.dart';
import 'package:felloapp/core/enums/transaction_state_enum.dart';
import 'package:felloapp/core/model/app_config_model.dart';
import 'package:felloapp/core/service/notifier_services/scratch_card_service.dart';
import 'package:felloapp/ui/pages/finance/augmont/gold_buy/upi_intent_view.dart';
import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:flutter/material.dart';
import 'package:property_change_notifier/property_change_notifier.dart';
import 'package:upi_pay/upi_pay.dart';

abstract class BaseTransactionService
    extends PropertyChangeNotifier<TransactionServiceProperties> {
  final ScratchCardService? _gtService = locator<ScratchCardService>();
  S locale = locator<S>();

  TransactionState _currentTransactionState = TransactionState.idle;
  TransactionState get currentTransactionState => _currentTransactionState;
  set currentTransactionState(TransactionState state) {
    _currentTransactionState = state;
    notifyListeners(TransactionServiceProperties.transactionState);
  }

  List<ApplicationMeta> appMetaList = [];
  UpiApplication? upiApplication;
  String? selectedUpiApplicationName;

  Timer? pollingPeriodicTimer;
  double? currentTxnAmount = 0;
  String? currentTxnOrderId;
  int currentTxnTambolaTicketsCount = 0;
  bool isIOSTxnInProgress = false;
  int currentTxnScratchCardCount = 0;
  Map<String, dynamic>? currentTransactionAnalyticsDetails;

  Future<void> initiatePolling() async {
    this.pollingPeriodicTimer = Timer.periodic(
      Duration(seconds: 5),
      this.processPolling,
    );
  }

  Future<void> processPolling(Timer timer);

  String getPaymentMode() {
    String paymentMode = "RZP-PG";

    paymentMode = Platform.isAndroid
        ? AppConfig.getValue(AppConfigKey.active_pg_android)
        : AppConfig.getValue(AppConfigKey.active_pg_ios);

    return paymentMode;
  }

  Future<void> processUpiTransaction();
  Future<void> processPaytmTransaction();
  Future<void> processRazorpayTransaction();

  Future<void> getUserUpiAppChoice(BaseTransactionService service) async {
    await getUPIApps();
    BaseUtil.openModalBottomSheet(
      addToScreenStack: true,
      backgroundColor: Colors.transparent,
      isBarrierDismissible: false,
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(SizeConfig.roundness12),
        topRight: Radius.circular(SizeConfig.roundness12),
      ),
      content: UPIAppsBottomSheet(txnServiceInstance: service),
    );
  }

  Future<void> getUPIApps() async {
    try {
      List<ApplicationMeta> allUpiApps =
          await UpiPay.getInstalledUpiApplications(
              statusType: UpiApplicationDiscoveryAppStatusType.all);
      allUpiApps.forEach((element) {
        if (element.upiApplication.appName == "Paytm" &&
            AppConfig.getValue<String>(AppConfigKey.enabled_psp_apps)
                .contains('P')) {
          appMetaList.add(element);
        }
        if (element.upiApplication.appName == "PhonePe" &&
            AppConfig.getValue<String>(AppConfigKey.enabled_psp_apps)
                .contains('E')) {
          appMetaList.add(element);
        }
        if (element.upiApplication.appName == "Google Pay" &&
            AppConfig.getValue<String>(AppConfigKey.enabled_psp_apps)
                .contains('G')) {
          appMetaList.add(element);
        }
      });
    } catch (e) {
      BaseUtil.showNegativeAlert(locale.unableToGetUpi, locale.tryLater);
    }
  }

  getAmount(double amount) {
    if (amount > amount.toInt())
      return amount;
    else
      return amount.toInt();
  }

  void showGtIfAvailable() {
    Future.delayed(Duration(milliseconds: 500), () {
      _gtService!.showMultipleScratchCardsView();
      // _gtService!.showInstantScratchCardView(
      //   amount: this.currentTxnAmount,
      //   showAutoSavePrompt: true,
      //   title: locale.youSaved + "₹${this.getAmount(this.currentTxnAmount!)}",
      //   source: GTSOURCE.deposit,
      // );
    });
  }
}
