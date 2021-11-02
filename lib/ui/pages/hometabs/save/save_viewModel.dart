import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/core/service/user_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/ui/architecture/base_vm.dart';
import 'package:felloapp/util/locator.dart';
import 'package:url_launcher/url_launcher.dart';

class SaveViewModel extends BaseModel {
  BaseUtil _baseUtil = locator<BaseUtil>();
  UserService _userService = locator<UserService>();

  getGoldBalance() {
    return _baseUtil.userFundWallet?.augGoldQuantity ?? 0.0;
  }

  getUnclaimedPrizeBalance() {
    return _userService.userFundWallet?.prizeLifetimeWin ?? 0.0;
  }

  navigateToBuyScreen() {
    AppState.delegate.appState.currentAction =
        PageAction(state: PageState.addPage, page: AugmontGoldBuyPageConfig);
  }

  navigateToAboutGold() {
    AppState.delegate.appState.currentAction = PageAction(
        state: PageState.addPage, page: AugmontGoldDetailsPageConfig);
  }

  openAugmontWebUri() async {
    const url = "https://www.augmont.com/about-us";
    if (await canLaunch(url))
      await launch(url);
    else
      BaseUtil.showNegativeAlert(
          'Failed to launch URL', 'Please try again in sometime');
  }
}
