import 'dart:async';
import 'dart:io';

import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/base_remote_config.dart';
import 'package:felloapp/core/enums/transaction_service_enum.dart';
import 'package:felloapp/core/enums/transaction_state_enum.dart';
import 'package:felloapp/core/service/notifier_services/golden_ticket_service.dart';
import 'package:felloapp/ui/pages/others/finance/augmont/gold_buy/upi_intent_view.dart';
import 'package:felloapp/ui/pages/others/rewards/golden_scratch_dialog/gt_instant_view.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:flutter/material.dart';
import 'package:property_change_notifier/property_change_notifier.dart';
import 'package:upi_pay/upi_pay.dart';

abstract class BaseTransactionService
    extends PropertyChangeNotifier<TransactionServiceProperties> {
  final _gtService = locator<GoldenTicketService>();

  TransactionState _currentTransactionState = TransactionState.idle;
  TransactionState get currentTransactionState => _currentTransactionState;
  set currentTransactionState(TransactionState state) {
    _currentTransactionState = state;
    notifyListeners(TransactionServiceProperties.transactionState);
  }

  List<ApplicationMeta> appMetaList = [];
  UpiApplication upiApplication;
  String selectedUpiApplicationName;

  Timer pollingPeriodicTimer;
  double currentTxnAmount = 0;
  String currentTxnOrderId;
  int currentTxnTambolaTicketsCount = 0;
  bool isIOSTxnInProgress = false;

  Future<void> initiatePolling() async {
    this.pollingPeriodicTimer = Timer.periodic(
      Duration(seconds: 5),
      this.processPolling,
    );
  }

  Future<void> processPolling(Timer timer);

  String getPaymentMode() {
    String paymentMode = "PAYTM-PG";
    if (Platform.isAndroid)
      paymentMode = BaseRemoteConfig.remoteConfig
          .getString(BaseRemoteConfig.ACTIVE_PG_ANDROID);
    else if (Platform.isIOS)
      paymentMode = BaseRemoteConfig.remoteConfig
          .getString(BaseRemoteConfig.ACTIVE_PG_IOS);

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
      isBarrierDismissable: false,
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
            BaseRemoteConfig.remoteConfig
                .getString(BaseRemoteConfig.ENABLED_PSP_APPS)
                .contains('P')) {
          appMetaList.add(element);
        }
        if (element.upiApplication.appName == "PhonePe" &&
            BaseRemoteConfig.remoteConfig
                .getString(BaseRemoteConfig.ENABLED_PSP_APPS)
                .contains('E')) {
          appMetaList.add(element);
        }
        if (element.upiApplication.appName == "Google Pay" &&
            BaseRemoteConfig.remoteConfig
                .getString(BaseRemoteConfig.ENABLED_PSP_APPS)
                .contains('G')) {
          appMetaList.add(element);
        }
      });
    } catch (e) {
      BaseUtil.showNegativeAlert(
          "Unable to get Upi apps", "Please try again in sometime");
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
      _gtService.showInstantGoldenTicketView(
        amount: this.currentTxnAmount,
        showAutoSavePrompt: true,
        title:
            "You have successfully saved ₹${this.getAmount(this.currentTxnAmount)}",
        source: GTSOURCE.deposit,
      );
    });
  }
}
