import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:felloapp/util/flavor_config.dart';
import 'package:flutter/material.dart';

import '../../util/custom_logger.dart';
import '../../util/locator.dart';
import '../service/notifier_services/user_service.dart';

abstract class BaseRepo {
  @protected
  final logger = locator<CustomLogger>();
  @protected
  UserService get userService => locator<UserService>();

  @protected
  Future<String> getBearerToken() async {
    String token = await userService.firebaseUser.getIdToken();
    return token;
  }

  @protected
  String getGameApiToken(String gameName) {
    final jwt = JWT(
      {'uid': userService.baseUser.uid, 'gameTitle': gameName},
    );
    String token =
        jwt.sign(SecretKey(FlavorConfig.instance.values.gameApiTokenSecret));
    return token;
  }
}
