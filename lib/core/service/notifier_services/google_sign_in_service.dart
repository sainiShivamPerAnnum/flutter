import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/model/base_user_model.dart';
import 'package:felloapp/core/repository/user_repo.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/util/custom_logger.dart';
import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/locator.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleSignInService extends ChangeNotifier {
  final _googleSignIn = GoogleSignIn();
  final UserService _userService = locator<UserService>();
  final UserRepository _userRepo = locator<UserRepository>();
  final CustomLogger _logger = locator<CustomLogger>();
  S locale = locator<S>();

  Future<String?> signInWithGoogle() async {
    try {
      if (await _googleSignIn.isSignedIn()) await _googleSignIn.signOut();
      print('Signed out');
    } catch (e) {
      print('Failed to signout: $e');
    }
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        BaseUtil.showNegativeAlert(
          locale.noAccSelected,
          locale.chooseAnAcc,
        );
        return null;
      }

      final isEmailRegistered =
          await _userRepo!.isEmailRegistered(googleUser.email);

      if (isEmailRegistered.model!) {
        BaseUtil.showNegativeAlert(
          locale.emailAlreadyRegistered,
          locale.anotherEmail,
        );
        return null;
      }

      final userEmail = googleUser.email;
      _userService!.setEmail(userEmail);
      final res = await _userRepo!.updateUser(dMap: {
        BaseUser.fldIsEmailVerified: true,
        BaseUser.fldEmail: userEmail,
      });
      if (res.isSuccess() && res.model!) {
        _userService!.isEmailVerified = true;
        return userEmail;
      } else {
        BaseUtil.showNegativeAlert(
            res.errorMessage ?? locale.obSomeThingWentWrong,
            locale.obPleaseTryAgain);
      }
      return null;
    } catch (e) {
      _logger!.d(e.toString());
      BaseUtil.showNegativeAlert(
        locale.verifyFailed,
        locale.tryAnotherMethod,
      );
      return null;
    }
  }
}
