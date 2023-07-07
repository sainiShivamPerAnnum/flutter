import 'dart:async';
import 'dart:developer';

import 'package:felloapp/core/enums/transaction_state_enum.dart';
import 'package:felloapp/core/service/notifier_services/scratch_card_service.dart';
import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/locator.dart';
import 'package:flutter/material.dart';
import 'package:upi_pay/upi_pay.dart';

abstract class BaseTransactionService extends ChangeNotifier {
  final ScratchCardService _gtService = locator<ScratchCardService>();
  S locale = locator<S>();

  TransactionState _currentTransactionState = TransactionState.idle;
  TransactionState get currentTransactionState => _currentTransactionState;
  set currentTransactionState(TransactionState state) {
    _currentTransactionState = state;
    log("currentTransactionState: $state");
    notifyListeners();
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
    pollingPeriodicTimer = Timer.periodic(
      const Duration(seconds: 5),
      processPolling,
    );
  }

  Future<void> processPolling(Timer timer);

  Future<void> processUpiTransaction();
  Future<void> processRazorpayTransaction();
  Future<void> transactionResponseUpdate({List<String>? gtIds, double? amount});

  void showGtIfAvailable() {
    Future.delayed(const Duration(milliseconds: 500), () {
      _gtService!.showMultipleScratchCardsView();
    });
  }
}
