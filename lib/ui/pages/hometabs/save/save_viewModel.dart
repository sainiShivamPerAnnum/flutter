import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/ui/architecture/base_vm.dart';
import 'package:felloapp/util/locator.dart';

class SaveViewModel extends BaseModel {
  final userService = locator<UserService>();

  init() {}

  navigateToSaveFunds() {}
}
