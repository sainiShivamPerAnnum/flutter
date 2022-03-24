import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/enums/view_state_enum.dart';
import 'package:felloapp/core/model/subscription_models/active_subscription_model.dart';
import 'package:felloapp/core/ops/db_ops.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/architecture/base_vm.dart';
import 'package:felloapp/util/locator.dart';
import 'package:flutter/cupertino.dart';
import 'package:felloapp/core/service/notifier_services/paytm_service.dart';

class UserAutoPayDetailsViewModel extends BaseModel {
  final _dbModel = locator<DBModel>();
  final _userService = locator<UserService>();
  final _paytmService = locator<PaytmService>();

  ActiveSubscriptionModel _activeSubscription;

  ActiveSubscriptionModel get activeSubscription => this._activeSubscription;

  set activeSubscription(value) {
    this._activeSubscription = value;
    notifyListeners();
  }

  TextEditingController subIdController,
      pUpiController,
      subAmountController,
      subStatusController;
  bool isVerified = true;

  bool _isPausingInProgress = false;

  bool get isPausingInProgress => _isPausingInProgress;

  set isPausingInProgress(bool val) {
    this._isPausingInProgress = val;
    notifyListeners();
  }

  init() async {
    subIdController = new TextEditingController();
    pUpiController = new TextEditingController();
    subAmountController = new TextEditingController();
    subStatusController = new TextEditingController(text: "Active");
    await findActiveSubscription();
  }

  findActiveSubscription() async {
    setState(ViewState.Busy);
    activeSubscription = _paytmService.activeSubscription;
    // await _dbModel.getActiveSubscriptionDetails(_userService.baseUser.uid);
    if (activeSubscription != null) {
      subIdController.text = activeSubscription.subId;
      pUpiController.text = activeSubscription.vpa;
      subAmountController.text =
          "${activeSubscription.autoAmount.toString()}/${activeSubscription.autoFrequency}";
      subStatusController.text = activeSubscription.status;
    }
    setState(ViewState.Idle);
  }

  pauseSubscription() async {
    isPausingInProgress = true;
    bool response =
        await _paytmService.pauseDailySubscription(activeSubscription.subId, 2);
    if (response) {
      AppState.backButtonDispatcher.didPopRoute();
      BaseUtil.showPositiveAlert("Subscription paused for 2 days",
          "Remember it will automatically after 2 days");
    } else
      BaseUtil.showNegativeAlert(
          "Failed to pause Subscription", "Please try again");
    isPausingInProgress = false;
  }
}
