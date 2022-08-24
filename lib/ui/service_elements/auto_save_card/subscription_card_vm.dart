import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/core/model/subscription_models/active_subscription_model.dart';
import 'package:felloapp/core/service/notifier_services/paytm_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/ui/architecture/base_vm.dart';
import 'package:felloapp/ui/pages/others/finance/autopay/autopay_process/autopay_process_view.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/constants.dart';
import 'package:felloapp/util/haptic.dart';
import 'package:felloapp/util/locator.dart';
import 'package:intl/intl.dart';

class SubscriptionCardViewModel extends BaseModel {
  final _paytmService = locator<PaytmService>();
  bool _isResumingInProgress = false;
  bool _isLoading = false;

  bool get isResumingInProcess => _isResumingInProgress;
  bool get isLoading => _isLoading;

  updateLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  init() async {
    await _paytmService.getActiveSubscriptionDetails();
  }

  String getactiveSubtitle(ActiveSubscriptionModel subscription) {
    if (subscription == null ||
        (subscription.status == Constants.SUBSCRIPTION_INIT ||
            subscription.status == Constants.SUBSCRIPTION_CANCELLED)) {
      return "Fello Autosave";
    }
    if (subscription.status == Constants.SUBSCRIPTION_PROCESSING) {
      return "in Progress";
    } else {
      if (subscription.status == Constants.SUBSCRIPTION_ACTIVE) {
        return "₹${subscription.autoAmount.toInt()}${getFreq(subscription.autoFrequency)}";
      }
      if (subscription.status == Constants.SUBSCRIPTION_INACTIVE) {
        if (subscription.autoAmount == 0.0)
          return "Start saving now";
        else {
          if (subscription.resumeDate.isEmpty)
            return "Fello Autosave";
          else
            return "till ${getResumeDate()}";
        }
      }
      return "0.0/day";
    }
  }

  String getActiveButtonText(ActiveSubscriptionModel subscription) {
    if (subscription == null ||
        (subscription.status == Constants.SUBSCRIPTION_INIT ||
            subscription.status == Constants.SUBSCRIPTION_CANCELLED)) {
      return "Start an SIP";
    }
    if (subscription.status == Constants.SUBSCRIPTION_PROCESSING) {
      return "View";
    } else {
      if (subscription.status == Constants.SUBSCRIPTION_ACTIVE) {
        return "View";
      }
      if (subscription.status == Constants.SUBSCRIPTION_INACTIVE) {
        if (subscription.autoAmount == 0.0)
          return "Set amount";
        else {
          if (subscription.resumeDate.isEmpty)
            return "Restart";
          else
            return "Resume";
        }
      }
      return "Details";
    }
  }

  getActiveButtonAction() async {
    Haptic.vibrate();
    await _paytmService.getActiveSubscriptionDetails();
    if (_paytmService.activeSubscription == null ||
        (_paytmService.activeSubscription.status ==
                Constants.SUBSCRIPTION_INIT ||
            _paytmService.activeSubscription.status ==
                Constants.SUBSCRIPTION_CANCELLED)) {
      AppState.delegate.appState.currentAction = PageAction(
          page: AutosaveDetailsViewPageConfig, state: PageState.addPage);
      // _paytmService.initiateSubscription();
    } else if (_paytmService.activeSubscription.status ==
        Constants.SUBSCRIPTION_PROCESSING) {
      AppState.delegate.appState.currentAction = PageAction(
          page: AutosaveProcessViewPageConfig,
          widget: AutosaveProcessView(page: 1),
          state: PageState.addWidget);
    } else {
      if (_paytmService.activeSubscription.status ==
          Constants.SUBSCRIPTION_ACTIVE) {
        AppState.delegate.appState.currentAction = PageAction(
            page: UserAutosaveDetailsViewPageConfig, state: PageState.addPage);
      }
      if (_paytmService.activeSubscription.status ==
          Constants.SUBSCRIPTION_INACTIVE) {
        if (_paytmService.activeSubscription.autoAmount == 0.0) {
          AppState.delegate.appState.currentAction = PageAction(
              page: AutosaveProcessViewPageConfig,
              widget: AutosaveProcessView(page: 2),
              state: PageState.addWidget);
        } else {
          if (_paytmService.activeSubscription.resumeDate.isEmpty) {
            AppState.delegate.appState.currentAction = PageAction(
                page: AutosaveProcessViewPageConfig,
                widget: AutosaveProcessView(page: 2),
                state: PageState.addWidget);
          } else {
            AppState.delegate.appState.currentAction = PageAction(
                page: UserAutosaveDetailsViewPageConfig,
                state: PageState.addPage);
            // }
          }
        }
      }
    }
  }

  String getResumeDate() {
    if (_paytmService.activeSubscription.resumeDate != null) {
      List<String> dateSplitList =
          _paytmService.activeSubscription.resumeDate.split('-');
      int day = int.tryParse(dateSplitList[0]);
      int month = int.tryParse(dateSplitList[1]);
      int year = int.tryParse(dateSplitList[2]);
      final resumeDate = DateTime(year, month, day);
      return DateFormat("dd MMM yyyy").format(resumeDate);
    } else {
      return "Forever";
    }
  }

  getImage(ActiveSubscriptionModel subscription) {
    if (subscription == null ||
        (subscription.status == Constants.SUBSCRIPTION_INIT ||
            subscription.status == Constants.SUBSCRIPTION_CANCELLED)) {
      return Assets.preautosave;
    }
    if (subscription.status == Constants.SUBSCRIPTION_PROCESSING) {
      return Assets.preautosave;
    } else {
      if (subscription.status == Constants.SUBSCRIPTION_ACTIVE) {
        return Assets.postautosave;
      }
      if (subscription.status == Constants.SUBSCRIPTION_INACTIVE) {
        if (subscription.autoAmount == 0.0)
          return Assets.preautosave;
        else {
          if (subscription.resumeDate.isEmpty)
            return Assets.preautosave;
          else
            return Assets.autopause;
        }
      }
      return Assets.preautosave;
    }
  }

  getFreq(String freq) {
    if (freq == "DAILY") return "/day";
    if (freq == "WEEKLY") return "/week";
    return "";
  }

  String getActiveTitle(ActiveSubscriptionModel subscription) {
    if (subscription == null ||
        (subscription.status == Constants.SUBSCRIPTION_INIT ||
            subscription.status == Constants.SUBSCRIPTION_CANCELLED)) {
      return "Start an SIP with Fello Autosave";
    }
    if (subscription.status == Constants.SUBSCRIPTION_PROCESSING) {
      return "AUTO SIP";
    } else {
      if (subscription.status == Constants.SUBSCRIPTION_ACTIVE) {
        return "Active";
      }
      if (subscription.status == Constants.SUBSCRIPTION_INACTIVE) {
        if (subscription.autoAmount == 0.0)
          return "Your Autosave setup is complete";
        else {
          if (subscription.resumeDate.isEmpty)
            return "Savings on autopilot with";
          else
            return "Paused";
        }
      }
      return "Autosave";
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
          if (subscription.resumeDate.isEmpty)
            return "";
          else
            return "";
        }
      }
      return "Autosave";
    }
  }

  navigateToAutoSave() {
    if (_paytmService.activeSubscription != null &&
        _paytmService.activeSubscription.status !=
            Constants.SUBSCRIPTION_INIT &&
        _paytmService.activeSubscription.status !=
            Constants.SUBSCRIPTION_CANCELLED)
      AppState.delegate.appState.currentAction = PageAction(
        state: PageState.addPage,
        page: UserAutosaveDetailsViewPageConfig,
      );
    else
      AppState.delegate.appState.currentAction = PageAction(
        state: PageState.addPage,
        page: AutosaveDetailsViewPageConfig,
      );
  }
}
