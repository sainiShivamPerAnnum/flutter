import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/service/user_service.dart';
import 'package:felloapp/ui/architecture/base_vm.dart';
import 'package:felloapp/util/locator.dart';
import 'package:flutter/material.dart';

class FDrawerVM extends BaseModel {
  BaseUtil _baseUtil = locator<BaseUtil>();
  final userService = locator<UserService>();

  String get myUserDpUrl => userService.myUserDpUrl;

  String get name => _baseUtil.myUser.name;
  String get username => _baseUtil.myUser.username;

  refreshDrawer() {
    notifyListeners();
  }
}
