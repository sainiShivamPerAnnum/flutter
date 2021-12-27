import 'package:felloapp/core/service/user_service.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/ui/architecture/base_vm.dart';
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
  List<DrawerModel> _drawerItems = [
    DrawerModel(
      icon: Assets.dReferNEarn,
      title: "Refer and Earn",
      pageConfig: ReferralDetailsPageConfig,
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

  refreshDrawer() {
    notifyListeners();
  }
}
