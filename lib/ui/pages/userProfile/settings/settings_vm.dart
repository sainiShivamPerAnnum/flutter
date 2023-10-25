// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/model/settings_items_model.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/ui/architecture/base_vm.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/locator.dart';

class SettingsViewModel extends BaseViewModel {
  final _userService = locator<UserService>();
  final _baseUtil = locator<BaseUtil>();
  String? username;
  List<SettingsListItemModel>? items;
  init() {
    username = _userService.diplayUsername(_userService.baseUser!.username!);
    fetchSettingsItems();
  }

  fetchSettingsItems() {
    if (_baseUtil.settingsItemList == null ||
        _baseUtil.settingsItemList!.isEmpty) {
      items = [
        SettingsListItemModel(
            title: "Profile",
            asset: Assets.securityCheck,
            actionUri: '/profile'),
        SettingsListItemModel(
          title: "KYC",
          asset: Assets.securityCheck,
          actionUri: '/kycVerify',
        ),
        SettingsListItemModel(
            title: "Feedback",
            asset: Assets.securityCheck,
            actionUri: '/kycDetails'),
        SettingsListItemModel(
            title: "FAQs",
            asset: Assets.securityCheck,
            actionUri: '/kycDetails'),
        SettingsListItemModel(
            title: "Contact Us",
            asset: Assets.securityCheck,
            actionUri: 'https://flutter.dev'),
      ];
    } else {
      items = _baseUtil.settingsItemList;
    }
  }

  dump() {}
}
