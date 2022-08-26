import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/enums/username_response_enum.dart';
import 'package:felloapp/core/ops/db_ops.dart';
import 'package:felloapp/ui/architecture/base_vm.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
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
  bool _hasReferralCode = false;
  final _formKey = GlobalKey<FormState>();

  final FocusNode _focusNode = FocusNode();

  get referralCodeController => _referralCodeController;
  String getReferralCode() => _referralCodeController.text;

  get formKey => _formKey;
  FocusNode get focusNode => _focusNode;

  set hasReferralCode(bool val) {
    _hasReferralCode = val;
    notifyListeners();
  }

  bool get hasReferralCode => _hasReferralCode;

  UsernameResponse response;

  disposeModel() {
    focusNode.dispose();
  }

  Future<bool> validate() async {
    username = usernameController.text.trim();

    isLoading = true;
    notifyListeners();

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

  Widget showResult() {
    print("Response " + response.toString());
    if (isLoading) {
      return Container(
        height: SizeConfig.padding16,
        width: SizeConfig.padding16,
        child: CircularProgressIndicator(
          strokeWidth: 2,
        ),
      );
    } else if (response == UsernameResponse.EMPTY)
      return Text(
        "username cannot be empty",
        style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w500),
      );
    else if (response == UsernameResponse.UNAVAILABLE)
      return Text(
        "@${usernameController.text.trim()} is not available",
        style: TextStyle(
          color: Colors.red,
          fontWeight: FontWeight.w500,
        ),
      );
    else if (response == UsernameResponse.AVAILABLE) {
      return Text(
        "@${usernameController.text.trim()} is available",
        style: TextStyle(
          color: UiConstants.primaryColor,
          fontWeight: FontWeight.w500,
        ),
      );
    } else if (response == UsernameResponse.INVALID) {
      if (usernameController.text.trim().length < 4)
        return Text(
          "please enter a username with more than 3 characters.",
          maxLines: 2,
          style: TextStyle(
            color: Colors.red,
            fontWeight: FontWeight.w500,
          ),
        );
      else if (usernameController.text.trim().length > 20)
        return Text(
          "please enter a username with less than 20 characters.",
          maxLines: 2,
          style: TextStyle(
            color: Colors.red,
            fontWeight: FontWeight.w500,
          ),
        );
      else
        return Text(
          "@${usernameController.text.trim()} is invalid",
          maxLines: 2,
          style: TextStyle(
            color: Colors.red,
            fontWeight: FontWeight.w500,
          ),
        );
    }

    return SizedBox(
      height: SizeConfig.padding16,
    );
  }
}
