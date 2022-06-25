import 'package:flutter/material.dart';

import '../../util/custom_logger.dart';
import '../../util/locator.dart';
import '../service/notifier_services/user_service.dart';

abstract class BaseRepo {
  @protected
  final logger = locator<CustomLogger>();
  @protected
  final userService = locator<UserService>();

  @protected
  Future<String> getBearerToken() async {
    String token = await userService.firebaseUser.getIdToken();
    logger.d(token);
    return token;
  }
}
