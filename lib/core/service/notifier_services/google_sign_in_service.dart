import 'dart:developer';

import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/model/base_user_model.dart';
import 'package:felloapp/core/ops/https/http_ops.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/core/repository/user_repo.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/util/custom_logger.dart';
import 'package:felloapp/util/locator.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleSignInService extends ChangeNotifier {
  final _googleSignIn = GoogleSignIn();
  final _httpProvider = locator<HttpModel>();
  final _userService = locator<UserService>();
  final _userRepo = locator<UserRepository>();
  final _logger = locator<CustomLogger>();

  Future<String> signInWithGoogle() async {
    try {
      if (await _googleSignIn.isSignedIn()) await _googleSignIn.signOut();
      print('Signed out');
    } catch (e) {
      print('Failed to signout: $e');
    }
    try {
      final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        BaseUtil.showNegativeAlert(
          "No account selected",
          "Please choose an account from the list",
        );
        return null;
      }

      if (!(await _httpProvider.isEmailNotRegistered(
          _userService.baseUser.uid, googleUser.email))) {
        BaseUtil.showNegativeAlert(
          "Email already registered",
          "Please try with another email",
        );
        return null;
      }

      final userEmail = googleUser.email;
      _userService.setEmail(userEmail);
      final res = await _userRepo.updateUser(dMap: {
        BaseUser.fldIsEmailVerified: true,
        'email': userEmail,
      });
      if (res.isSuccess() && res.model) {
        _userService.isEmailVerified = true;
        AppState.backButtonDispatcher.didPopRoute();
        return userEmail;
      } else
        BaseUtil.showNegativeAlert(
            res.errorMessage ?? "Something is wrong!", "Please try again");
      return null;
    } catch (e) {
      _logger.d(e.toString());
      BaseUtil.showNegativeAlert(
        "Unable to verify",
        "Please try a different method",
      );
      return null;
    }
  }
}
