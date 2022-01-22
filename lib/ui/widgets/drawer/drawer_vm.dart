import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/core/service/analytics/analytics_events.dart';
import 'package:felloapp/core/service/analytics/analytics_service.dart';
import 'package:felloapp/core/service/user_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/ui/architecture/base_vm.dart';
import 'package:felloapp/ui/pages/root/root_vm.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/locator.dart';

class DrawerModel {
  String title;
  String icon;
  PageConfiguration pageConfig;

  DrawerModel({this.icon, this.pageConfig, this.title});
}

class FDrawerVM extends BaseModel {
  final userService = locator<UserService>();
  final _analyticsService = locator<AnalyticsService>();

  List<DrawerModel> _drawerItems = [
    DrawerModel(
      icon: Assets.dReferNEarn,
      title: "Refer and Earn",
      pageConfig: ReferralDetailsPageConfig,
    ),
    DrawerModel(
      icon: Assets.gold24K,
      title: "My Rewards",
      pageConfig: MyWinnigsPageConfig,
    ),
    DrawerModel(
      icon: Assets.dPanKyc,
      title: "PAN & KYC",
      pageConfig: KycDetailsPageConfig,
    ),
    DrawerModel(
      icon: Assets.dTransactions,
      title: "Transactions",
      pageConfig: TransactionPageConfig,
    ),
    DrawerModel(
      icon: Assets.dHelpNSupport,
      title: "Help & Support",
      pageConfig: SupportPageConfig,
    ),
    DrawerModel(
      icon: Assets.dHowItWorks,
      title: "How it works",
      pageConfig: WalkThroughConfig,
    ),
    DrawerModel(
      icon: Assets.dAboutDigitalGold,
      title: "About Digital Gold",
      pageConfig: AugmontGoldDetailsPageConfig,
    ),
  ];

  List<DrawerModel> get drawerList => _drawerItems;
  String get username => userService.baseUser.username;

  void onItemSelected(int i) {
    if (RootViewModel.scaffoldKey.currentState.isDrawerOpen)
      RootViewModel.scaffoldKey.currentState.openEndDrawer();

    AppState.delegate.appState.currentAction = PageAction(
      state: PageState.addPage,
      page: drawerList[i].pageConfig,
    );

    if (i == 0)
      _analyticsService.track(eventName: AnalyticsEvents.referralSection);
  }

  refreshDrawer() {
    notifyListeners();
  }
}
