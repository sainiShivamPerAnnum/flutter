import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/core/service/analytics/analytics_service.dart';
import 'package:felloapp/core/service/notifier_services/paytm_service.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/ui/architecture/base_vm.dart';
import 'package:felloapp/util/constants.dart';
import 'package:felloapp/util/locator.dart';

class SaveViewModel extends BaseModel {
  final userService = locator<UserService>();
  final _paytmService = locator<PaytmService>();

  init() {}

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

  navigateToSaveFunds() {}
}
