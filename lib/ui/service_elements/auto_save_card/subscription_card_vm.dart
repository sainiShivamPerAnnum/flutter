import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/constants/analytics_events_constants.dart';
import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/core/model/subscription_models/active_subscription_model.dart';
import 'package:felloapp/core/service/analytics/analyticsProperties.dart';
import 'package:felloapp/core/service/analytics/analytics_service.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/core/service/payments/paytm_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/ui/architecture/base_vm.dart';
import 'package:felloapp/ui/pages/others/finance/augmont/augmont_gold_details/save_assets_view.dart';
import 'package:felloapp/ui/pages/others/finance/autopay/autopay_process/autopay_process_view.dart';
import 'package:felloapp/ui/widgets/buttons/fello_button/large_button.dart';
import 'package:felloapp/ui/widgets/fello_dialog/fello_info_dialog.dart';
import 'package:felloapp/util/constants.dart';
import 'package:felloapp/util/haptic.dart';
import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SubscriptionCardViewModel extends BaseViewModel {
  final PaytmService? _paytmService = locator<PaytmService>();
  final UserService? _userService = locator<UserService>();
  bool _isResumingInProgress = false;
  bool _isLoading = false;
  final AnalyticsService? _analyticsService = locator<AnalyticsService>();
  S locale = locator<S>();

  bool get isResumingInProcess => _isResumingInProgress;
  bool get isLoading => _isLoading;

  updateLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  init() async {
    // await _paytmService!.getActiveSubscriptionDetails();
  }

  isUserProfileComplete() {
    return _userService!.userJourneyStats!.mlIndex! > 1;
  }

  String getactiveSubtitle(ActiveSubscriptionModel subscription) {
    if (subscription == null ||
        (subscription.status == Constants.SUBSCRIPTION_INIT ||
            subscription.status == Constants.SUBSCRIPTION_CANCELLED)) {
      return locale.felloAutoSave;
    }
    if (subscription.status == Constants.SUBSCRIPTION_PROCESSING) {
      return locale.inProgress;
    } else {
      if (subscription.status == Constants.SUBSCRIPTION_ACTIVE) {
        return "₹${subscription.autoAmount!.toInt()}${getFreq(subscription.autoFrequency)}";
      }
      if (subscription.status == Constants.SUBSCRIPTION_INACTIVE) {
        if (subscription.autoAmount == 0.0)
          return locale.startSavingNow;
        else {
          if (subscription.resumeDate!.isEmpty)
            return locale.felloAutoSave;
          else
            return locale.till + "${getResumeDate()}";
        }
      }
      return locale.zeroperDay;
    }
  }

  String getActiveButtonText(ActiveSubscriptionModel subscription) {
    if (subscription == null ||
        (subscription.status == Constants.SUBSCRIPTION_INIT ||
            subscription.status == Constants.SUBSCRIPTION_CANCELLED)) {
      return locale.startAnSIP;
    }
    if (subscription.status == Constants.SUBSCRIPTION_PROCESSING) {
      return locale.view;
    } else {
      if (subscription.status == Constants.SUBSCRIPTION_ACTIVE) {
        return locale.view;
      }
      if (subscription.status == Constants.SUBSCRIPTION_INACTIVE) {
        if (subscription.autoAmount == 0.0)
          return locale.setAmount;
        else {
          if (subscription.resumeDate!.isEmpty)
            return locale.restart;
          else
            return locale.resume;
        }
      }
      return locale.details;
    }
  }

  getActiveButtonAction() async {
    Haptic.vibrate();
    // if (_userService!.userJourneyStats!.mlIndex! < 2)
    //   return BaseUtil.openDialog(
    //       addToScreenStack: true,
    //       isBarrierDismissible: true,
    //       hapticVibrate: false,
    //       content: CompleteProfileDialog(
    //         subtitle:
    //             'Please complete your profile to win your first reward and to start autosaving',
    //       ));
    // await _paytmService!.getActiveSubscriptionDetails();
    if (_paytmService!.activeSubscription == null ||
        (_paytmService!.activeSubscription!.status ==
                Constants.SUBSCRIPTION_INIT ||
            _paytmService!.activeSubscription!.status ==
                Constants.SUBSCRIPTION_CANCELLED)) {
      AppState.delegate!.appState.currentAction = PageAction(
          page: AutosaveDetailsViewPageConfig, state: PageState.addPage);
      // _paytmService.initiateSubscription();
    } else if (_paytmService!.activeSubscription!.status ==
        Constants.SUBSCRIPTION_PROCESSING) {
      AppState.delegate!.appState.currentAction = PageAction(
          page: AutosaveProcessViewPageConfig,
          widget: AutosaveProcessView(page: 1),
          state: PageState.addWidget);
    } else {
      if (_paytmService!.activeSubscription!.status ==
          Constants.SUBSCRIPTION_ACTIVE) {
        AppState.delegate!.appState.currentAction = PageAction(
            page: UserAutosaveDetailsViewPageConfig, state: PageState.addPage);
      }
      if (_paytmService!.activeSubscription!.status ==
          Constants.SUBSCRIPTION_INACTIVE) {
        if (_paytmService!.activeSubscription!.autoAmount == 0.0) {
          AppState.delegate!.appState.currentAction = PageAction(
              page: AutosaveProcessViewPageConfig,
              widget: AutosaveProcessView(page: 2),
              state: PageState.addWidget);
        } else {
          if (_paytmService!.activeSubscription!.resumeDate!.isEmpty) {
            AppState.delegate!.appState.currentAction = PageAction(
                page: AutosaveProcessViewPageConfig,
                widget: AutosaveProcessView(page: 2),
                state: PageState.addWidget);
          } else {
            AppState.delegate!.appState.currentAction = PageAction(
                page: UserAutosaveDetailsViewPageConfig,
                state: PageState.addPage);
            // }
          }
        }
      }
    }

    _analyticsService!.track(
        eventName: AnalyticsEvents.sipStartTapped,
        properties:
            AnalyticsProperties.getDefaultPropertiesMap(extraValuesMap: {
          "location": AppState.delegate!.appState.currentAction.widget ==
                  SaveAssetView()
              ? "Save Asset View"
              : "Save Section",
        }));
  }

  String getResumeDate() {
    if (_paytmService!.activeSubscription!.resumeDate != null) {
      List<String> dateSplitList =
          _paytmService!.activeSubscription!.resumeDate!.split('-');
      int day = int.tryParse(dateSplitList[0])!;
      int month = int.tryParse(dateSplitList[1])!;
      int year = int.tryParse(dateSplitList[2])!;
      final resumeDate = DateTime(year, month, day);
      return DateFormat("dd MMM yyyy").format(resumeDate);
    } else {
      return "Forever";
    }
  }

  getFreq(String? freq) {
    if (freq == "DAILY") return "/day";
    if (freq == "WEEKLY") return "/week";
    return "";
  }

  String getActiveTitle(ActiveSubscriptionModel? subscription) {
    if (subscription == null ||
        (subscription.status == Constants.SUBSCRIPTION_INIT ||
            subscription.status == Constants.SUBSCRIPTION_CANCELLED)) {
      return locale.sipWithAutoSave;
    }
    if (subscription.status == Constants.SUBSCRIPTION_PROCESSING) {
      return locale.autoSIP;
    } else {
      if (subscription.status == Constants.SUBSCRIPTION_ACTIVE) {
        return locale.active;
      }
      if (subscription.status == Constants.SUBSCRIPTION_INACTIVE) {
        if (subscription.autoAmount == 0.0)
          return locale.autoSaveSetupComplete;
        else {
          if (subscription.resumeDate!.isEmpty)
            return locale.savingsOnAutoPilot;
          else
            return locale.paused;
        }
      }
      return locale.autoSave;
    }
  }

  String getActivityStatus(ActiveSubscriptionModel subscription) {
    if (subscription == null ||
        (subscription.status == Constants.SUBSCRIPTION_INIT ||
            subscription.status == Constants.SUBSCRIPTION_CANCELLED)) {
      return "Cancelled";
    }
    if (subscription.status == Constants.SUBSCRIPTION_PROCESSING) {
      return "Processing";
    } else {
      if (subscription.status == Constants.SUBSCRIPTION_ACTIVE) {
        return "Active";
      }
      if (subscription.status == Constants.SUBSCRIPTION_INACTIVE) {
        if (subscription.autoAmount == 0.0)
          return "Paused";
        else {
          if (subscription.resumeDate!.isEmpty)
            return "";
          else
            return "";
        }
      }
      return "Autosave";
    }
  }

  navigateToAutoSave() {
    if (_paytmService!.activeSubscription != null &&
        _paytmService!.activeSubscription!.status !=
            Constants.SUBSCRIPTION_INIT &&
        _paytmService!.activeSubscription!.status !=
            Constants.SUBSCRIPTION_CANCELLED)
      AppState.delegate!.appState.currentAction = PageAction(
        state: PageState.addPage,
        page: UserAutosaveDetailsViewPageConfig,
      );
    else
      AppState.delegate!.appState.currentAction = PageAction(
        state: PageState.addPage,
        page: AutosaveDetailsViewPageConfig,
      );
  }
}
