import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/constants/analytics_events_constants.dart';
import 'package:felloapp/core/enums/view_state_enum.dart';
import 'package:felloapp/core/model/subscription_models/subscription_model.dart';
import 'package:felloapp/core/model/subscription_models/subscription_transaction_model.dart';
import 'package:felloapp/core/repository/subscription_repo.dart';
import 'package:felloapp/core/service/analytics/analyticsProperties.dart';
import 'package:felloapp/core/service/analytics/analytics_service.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/core/service/subscription_service.dart';
import 'package:felloapp/ui/architecture/base_vm.dart';
import 'package:felloapp/ui/modalsheets/pause_autosave_modalsheet.dart';
import 'package:felloapp/util/custom_logger.dart';
import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';

//TODO Pause autosave analytics not showing up
class AutosaveDetailsViewModel extends BaseViewModel {
  final UserService? _userService = locator<UserService>();
  // final PaytmService? _paytmService = locator<PaytmService>();
  final SubService _subService = locator<SubService>();
  final CustomLogger? _logger = locator<CustomLogger>();
  final AnalyticsService _analyticsService = locator<AnalyticsService>();
  final SubscriptionRepo? _subcriptionRepo = locator<SubscriptionRepo>();
  S locale = locator<S>();

  SubscriptionModel? _activeSubscription;
  List<SubscriptionTransactionModel>? filteredList;
  int lastTappedChipIndex = 1;
  bool hasMoreTxns = false;
  bool _isFetchingTransactions = false;
  bool get isFetchingTransactions => this._isFetchingTransactions;

  set isFetchingTransactions(bool fetchingTransactions) {
    this._isFetchingTransactions = fetchingTransactions;
    notifyListeners();
  }

  SubscriptionModel? get activeSubscription => this._activeSubscription;

  set activeSubscription(value) {
    this._activeSubscription = value;
    notifyListeners();
  }

  init() async {
    setState(ViewState.Busy);
    await findActiveSubscription();
    setState(ViewState.Idle);
  }

  findActiveSubscription() async {
    activeSubscription = _subService.subscriptionData;
    if (activeSubscription != null) {
      fetchAutosaveTransactions();
    }
  }

  Future<void> fetchAutosaveTransactions() async {
    isFetchingTransactions = true;
    await _subService.getSubscriptionTransactionHistory();
    filteredList = _subService.allSubTxnList;
    isFetchingTransactions = false;
  }

  pauseResume() async {
    if (_subService.autosaveState == AutosaveState.PAUSED ||
        _subService.autosaveState == AutosaveState.PAUSED_FOREVER) {
      if (_subService.isPauseOrResuming) return;
      _analyticsService
          .track(eventName: AnalyticsEvents.autosavePauseModal, properties: {
        "frequency": activeSubscription!.frequency,
        "amount": activeSubscription!.amount,
        "SIP deducted Count": filteredList != null ? filteredList!.length : 0,
        // "SIP started timestamp": DateTime.fromMillisecondsSinceEpoch(
        //     activeSubscription!.createdOn!.microsecondsSinceEpoch),
        "Total invested amount": AnalyticsProperties.getGoldInvestedAmount() +
            AnalyticsProperties.getFelloFloAmount(),
        "Amount invested in gold": AnalyticsProperties.getGoldInvestedAmount(),
        "Grams of gold owned": AnalyticsProperties.getGoldQuantityInGrams(),
      });

      bool response = await _subService.resumeSubscription();
      if (!response) {
        BaseUtil.showNegativeAlert(
            "Failed to resume Autosave", "Please try again");
      } else {
        BaseUtil.showPositiveAlert("Autosave resumed successfully",
            "For more details check Autosave section");
      }
    } else {
      _analyticsService
          .track(eventName: AnalyticsEvents.autosavePauseModal, properties: {
        "frequency": activeSubscription!.frequency,
        "amount": activeSubscription!.amount,
        "SIP deducted Count": filteredList != null ? filteredList!.length : 0,
        // "SIP started timestamp": DateTime.fromMillisecondsSinceEpoch(
        //     activeSubscription!.createdOn!.microsecondsSinceEpoch),
        "Total invested amount": AnalyticsProperties.getGoldInvestedAmount() +
            AnalyticsProperties.getFelloFloAmount(),
        "Amount invested in gold": AnalyticsProperties.getGoldInvestedAmount(),
        "Grams of gold owned": AnalyticsProperties.getGoldQuantityInGrams(),
      });
      BaseUtil.openModalBottomSheet(
        addToScreenStack: true,
        hapticVibrate: true,
        backgroundColor:
            UiConstants.kRechargeModalSheetAmountSectionBackgroundColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(SizeConfig.roundness16),
          topRight: Radius.circular(SizeConfig.roundness16),
        ),
        isBarrierDismissible: false,
        isScrollControlled: true,
        content: PauseAutosaveModal(
          model: _subService,
        ),
      );
    }
  }

  trackPauseAnalytics(int value) {
    _analyticsService
        .track(eventName: AnalyticsEvents.autosavePauseModal, properties: {
      "frequency": activeSubscription?.frequency,
      "amount": activeSubscription?.amount,
      "SIP deducted Count": filteredList != null ? filteredList?.length : 0,
      "SIP started timestamp": DateTime.fromMillisecondsSinceEpoch(
          activeSubscription?.createdOn?.microsecondsSinceEpoch ?? 0),
      "Total invested amount": AnalyticsProperties.getGoldInvestedAmount() +
          AnalyticsProperties.getFelloFloAmount(),
      "Amount invested in gold": AnalyticsProperties.getGoldInvestedAmount(),
      "Grams of gold owned": AnalyticsProperties.getGoldQuantityInGrams(),
      "Amount Chip Selected": lastTappedChipIndex,
      "Pause Value": value,
    });
  }
}
