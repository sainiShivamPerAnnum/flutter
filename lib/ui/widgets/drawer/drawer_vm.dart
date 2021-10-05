import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/service/user_service.dart';
import 'package:felloapp/ui/architecture/base_vm.dart';
import 'package:felloapp/util/locator.dart';

class FDrawerVM extends BaseModel {
  BaseUtil _baseUtil = locator<BaseUtil>();
  final _userService = locator<UserService>();

  String get myUserDpUrl => _userService.myUserDpUrl;
  
  String get name => _baseUtil.myUser.name;
  String get username => _baseUtil.myUser.username;


}
