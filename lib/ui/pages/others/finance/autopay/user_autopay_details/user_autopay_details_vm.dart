import 'package:felloapp/core/enums/view_state_enum.dart';
import 'package:felloapp/core/model/subscription_models/active_subscription_model.dart';
import 'package:felloapp/core/ops/db_ops.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/ui/architecture/base_vm.dart';
import 'package:felloapp/util/locator.dart';
import 'package:flutter/cupertino.dart';

class UserAutoPayDetailsViewModel extends BaseModel {
  final _dbModel = locator<DBModel>();
  final _userService = locator<UserService>();

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

  init() async {
    subIdController = new TextEditingController();
    pUpiController = new TextEditingController();
    subAmountController = new TextEditingController();
    subStatusController = new TextEditingController(text: "Active");
    await findActiveSubscription();
  }

  findActiveSubscription() async {
    setState(ViewState.Busy);
    activeSubscription =
        await _dbModel.getActiveSubscriptionDetails(_userService.baseUser.uid);
    subIdController.text = activeSubscription.subId;
    pUpiController.text = activeSubscription.vpa;
    subAmountController.text = activeSubscription.dailyAmount.toString();
    setState(ViewState.Idle);
  }
}
