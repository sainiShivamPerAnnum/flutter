import 'package:flutter/material.dart';

import '../../util/custom_logger.dart';
import '../../util/locator.dart';
import '../service/notifier_services/user_service.dart';

abstract class BaseRepo {
  @protected
  final CustomLogger logger = locator<CustomLogger>();
  @protected
  UserService get userService => locator<UserService>();
}
