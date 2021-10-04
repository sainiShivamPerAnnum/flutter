import 'package:felloapp/base_util.dart';
import 'package:felloapp/ui/architecture/base_viewmodel.dart';
import 'package:felloapp/util/locator.dart';

class FDrawerVM extends BaseModel {
  BaseUtil _baseUtil = locator<BaseUtil>();
  String get myUserDpUrl => _baseUtil.myUserDpUrl;
  String get name => _baseUtil.myUser.name;
  String get username => _baseUtil.myUser.username;
}
