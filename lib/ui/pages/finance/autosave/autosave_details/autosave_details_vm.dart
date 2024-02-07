// import 'package:felloapp/base_util.dart';
// import 'package:felloapp/core/constants/analytics_events_constants.dart';
// import 'package:felloapp/core/enums/view_state_enum.dart';
// import 'package:felloapp/core/model/subscription_models/all_subscription_model.dart';
// import 'package:felloapp/core/model/subscription_models/subscription_transaction_model.dart';
// import 'package:felloapp/core/repository/subscription_repo.dart';
// import 'package:felloapp/core/service/analytics/analyticsProperties.dart';
// import 'package:felloapp/core/service/analytics/analytics_service.dart';
// import 'package:felloapp/core/service/notifier_services/user_service.dart';
// import 'package:felloapp/core/service/subscription_service.dart';
// import 'package:felloapp/ui/architecture/base_vm.dart';
// import 'package:felloapp/ui/modalsheets/pause_autosave_modalsheet.dart';
// import 'package:felloapp/util/constants.dart';
// import 'package:felloapp/util/custom_logger.dart';
// import 'package:felloapp/util/localization/generated/l10n.dart';
// import 'package:felloapp/util/locator.dart';
// import 'package:felloapp/util/styles/size_config.dart';
// import 'package:felloapp/util/styles/ui_constants.dart';
// import 'package:flutter/material.dart';

// //TODO Pause autosave analytics not showing up
// class AutosaveDetailsViewModel extends BaseViewModel {
//   final UserService _userService = locator<UserService>();
//   // final PaytmService? _paytmService = locator<PaytmService>();
//   final SubService _subService = locator<SubService>();
//   final CustomLogger _logger = locator<CustomLogger>();
//   final AnalyticsService _analyticsService = locator<AnalyticsService>();
//   final SubscriptionRepo _subcriptionRepo = locator<SubscriptionRepo>();
//   PageController? txnPageController = PageController(initialPage: 0);
//   S locale = locator<S>();

//   AllSubscriptionModel? _activeSubscription;
//   List<SubscriptionTransactionModel>? augTxnList;
//   List<SubscriptionTransactionModel>? lbTxnList;
//   bool hasMoreTxns = false;

//   int _currentPage = 0;
//   int get currentPage => _currentPage;

//   set currentPage(int value) {
//     _currentPage = value;
//     notifyListeners();
//   }

//   bool _isFetchingTransactions = false;
//   bool get isFetchingTransactions => _isFetchingTransactions;

//   set isFetchingTransactions(bool fetchingTransactions) {
//     _isFetchingTransactions = fetchingTransactions;
//     notifyListeners();
//   }

//   AllSubscriptionModel? get activeSubscription => _activeSubscription;

//   set activeSubscription(value) {
//     _activeSubscription = value;
//     notifyListeners();
//   }

//   init() async {
//     state = ViewState.Busy;
//     // setState(ViewState.Busy);
//     await findActiveSubscription();
//     setState(ViewState.Idle);
//   }

//   findActiveSubscription() async {
//     activeSubscription = _subService.subscriptionData;
//     if (activeSubscription != null) {
//       fetchAutosaveTransactions();
//     }
//   }

//   Future<void> fetchAutosaveTransactions() async {
//     isFetchingTransactions = true;
//     await _subService.getSubscriptionTransactionHistory(
//         asset: Constants.ASSET_TYPE_AUGMONT);
//     await _subService.getSubscriptionTransactionHistory(
//         asset: Constants.ASSET_TYPE_LENDBOX);
//     lbTxnList = _subService.lbSubTxnList;
//     augTxnList = _subService.augSubTxnList;
//     txnPageController = PageController();
//     isFetchingTransactions = false;
//   }

//   pauseResume() async {
//     if (_subService.isPauseOrResuming) return;
//     if (_subService.autosaveState == AutosaveState.PAUSED ||
//         _subService.autosaveState == AutosaveState.INACTIVE) {
//       locator<AnalyticsService>()
//           .track(eventName: AnalyticsEvents.asResumeTapped, properties: {
//         "frequency": activeSubscription!.frequency,
//         "amount": activeSubscription!.amount,
//       });

//       bool response = await _subService.resumeSubscription();
//       if (!response) {
//         BaseUtil.showNegativeAlert(
//             "Failed to resume Autosave", "Please try again");
//       } else {
//         BaseUtil.showPositiveAlert("Autosave resumed successfully",
//             "For more details check Autosave section");
//       }
//     } else {
//       _analyticsService
//           .track(eventName: AnalyticsEvents.asPauseTapped, properties: {
//         "frequency": activeSubscription!.frequency,
//         "amount": activeSubscription!.amount,
//       });
//       return BaseUtil.openModalBottomSheet(
//         addToScreenStack: true,
//         hapticVibrate: true,
//         backgroundColor:
//             UiConstants.kRechargeModalSheetAmountSectionBackgroundColor,
//         borderRadius: BorderRadius.only(
//           topLeft: Radius.circular(SizeConfig.roundness16),
//           topRight: Radius.circular(SizeConfig.roundness16),
//         ),
//         isBarrierDismissible: false,
//         isScrollControlled: true,
//         content: PauseAutosaveModal(
//           model: _subService,
//         ),
//       );
//     }
//   }

//   trackPauseAnalytics(int value) {
//     _analyticsService
//         .track(eventName: AnalyticsEvents.autosavePauseModal, properties: {
//       "frequency": activeSubscription?.frequency,
//       "amount": activeSubscription?.amount,
//       // "SIP deducted Count": filteredList != null ? filteredList?.length : 0,
//       "SIP started timestamp": DateTime.fromMillisecondsSinceEpoch(
//           activeSubscription?.createdOn?.microsecondsSinceEpoch ?? 0),
//       "Total invested amount": AnalyticsProperties.getGoldInvestedAmount() +
//           AnalyticsProperties.getFelloFloAmount(),
//       "Amount invested in gold": AnalyticsProperties.getGoldInvestedAmount(),
//       "Grams of gold owned": AnalyticsProperties.getGoldQuantityInGrams(),
//       // "Amount Chip Selected": lastTappedChipIndex,
//       "Pause Value": value,
//     });
//   }
// }
