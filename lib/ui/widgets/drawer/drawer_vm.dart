import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/service/user_service.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/ui/architecture/base_vm.dart';
import 'package:felloapp/ui/pages/others/profile/transactions_history/transactions_history_view.dart';
import 'package:felloapp/util/locator.dart';
import 'package:flutter/material.dart';

class DrawerModel {
  String title;
  Widget icon;
  PageConfiguration pageConfig;

  DrawerModel({this.icon, this.pageConfig, this.title});
}

class FDrawerVM extends BaseModel {
  final userService = locator<UserService>();
  List<DrawerModel> _drawerItems = [
    DrawerModel(
      icon: Icon(Icons.ac_unit),
      title: "Refer and Earn",
    ),
    DrawerModel(
      icon: Icon(Icons.ac_unit),
      title: "PAN & KYC",
      pageConfig: KycDetailsPageConfig,
    ),
    DrawerModel(
      icon: Icon(Icons.ac_unit),
      title: "Transactions",
      pageConfig: TransactionPageConfig,
    ),
    DrawerModel(
      icon: Icon(Icons.ac_unit),
      title: "Help & Support",
      pageConfig: SupportPageConfig,
    ),
    DrawerModel(
      icon: Icon(Icons.ac_unit),
      title: "How it works",
    ),
    DrawerModel(
      icon: Icon(Icons.ac_unit),
      title: "About Digital Gold",
    ),
  ];

  List<DrawerModel> get drawerList => _drawerItems;
  String get username => userService.baseUser.username;

  refreshDrawer() {
    notifyListeners();
  }
}
