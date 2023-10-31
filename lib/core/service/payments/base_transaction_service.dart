import 'dart:async';
import 'dart:developer';

import 'package:felloapp/core/enums/transaction_state_enum.dart';
import 'package:felloapp/core/service/notifier_services/scratch_card_service.dart';
import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/locator.dart';
import 'package:flutter/material.dart';
import 'package:upi_pay/upi_pay.dart';

/// An abstract class for rescheduling a task with retries.
abstract class BaseTransactionService<T> with ChangeNotifier {
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

  double? currentTxnAmount = 0;

  String? currentTxnOrderId;
  int currentTxnTambolaTicketsCount = 0;
  bool isIOSTxnInProgress = false;
  int currentTxnScratchCardCount = 0;
  Map<String, dynamic>? currentTransactionAnalyticsDetails;

  /// The current retry count.
  int _retryCount = 0;

  /// The maximum number of times the task can be retried.
  final int _rescheduleLimit = 2;

  /// The asynchronous task that will be executed and potentially rescheduled.
  Future<T> task();

  /// A predicate function that determines whether the task is complete based on
  /// its result.
  bool predicate(T value);

  /// Validates the response returned from [task], when [predicate] confirms
  /// successful execution of [task].
  void validateResponse(T value);

  /// Runs the [task] and potentially reschedule it until it reaches the
  /// reschedule limit or meets the completion condition.
  Future<void> run() async {
    while (_retryCount < _rescheduleLimit) {
      try {
        final result = await task();
        if (predicate(result)) {
          return validateResponse(result);
        } else {
          _retryCount++;
        }
      } catch (e) {
        _retryCount++;
      }
    }
  }

  Future<void> processUpiTransaction();

  Future<void> processRazorpayTransaction();

  Future<void> transactionResponseUpdate({
    List<String>? gtIds,
    double? amount,
  });

  Future<void> showGtIfAvailable() async {
    await Future.delayed(
      const Duration(milliseconds: 500),
      _gtService.showMultipleScratchCardsView,
    );
  }
}
