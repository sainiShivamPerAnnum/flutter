import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/ops/db_ops.dart';
import 'package:felloapp/ui/architecture/base_vm.dart';
import 'package:felloapp/ui/pages/login/screens/username_input/username_input_view.dart';
import 'package:felloapp/util/locator.dart';
import 'package:flutter/material.dart';

class UsernameInputScreenViewModel extends BaseModel {
  final BaseUtil baseProvider = locator<BaseUtil>();
  final DBModel dbProvider = locator<DBModel>();

  final _referralCodeController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  String username = "";

  bool enabled = true;
  final regex = RegExp(r"^(?!\.)(?!.*\.$)(?!.*?\.\.)[a-z0-9.]{4,20}$");
  bool isValid;
  bool isLoading = false;
  bool isUpdating = false;
  bool isUpdated = false;
  bool hasReferralCode = false;
  final _formKey = GlobalKey<FormState>();

  get referralCodeController => _referralCodeController;
  String getReferralCode() => _referralCodeController.text;

  get formKey => _formKey;
  UsernameResponse response;

  Future<bool> validate() async {
    username = usernameController.text.trim();

    isLoading = true;

    if (username == "" || username == null) {
      isValid = null;
      response = UsernameResponse.EMPTY;
    } else if (regex.hasMatch(username)) {
      bool res = await dbProvider
          .checkIfUsernameIsAvailable(username.replaceAll('.', '@'));

      isValid = res;
      if (res)
        response = UsernameResponse.AVAILABLE;
      else
        response = UsernameResponse.UNAVAILABLE;
    } else {
      isValid = false;
      response = UsernameResponse.INVALID;
    }

    isLoading = false;
    notifyListeners();
    return isValid;
  }
}
