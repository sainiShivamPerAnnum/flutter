import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/ops/db_ops.dart';
import 'package:felloapp/ui/architecture/base_vm.dart';
import 'package:felloapp/util/locator.dart';
import 'package:flutter/material.dart';

class LoginNameInputViewModel extends BaseViewModel {
  final BaseUtil? baseProvider = locator<BaseUtil>();
  final DBModel? dbProvider = locator<DBModel>();

  final _referralCodeController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  int genderValue = 0;
  List<String> genderOptions = ["Male", "Female", "Other"];
  bool enabled = true;

  // bool isLoading = false;
  // bool isUpdating = false;
  // bool isUpdated = false;
  bool _hasReferralCode = false;
  final _formKey = GlobalKey<FormState>();
  final FocusNode usernameFocusNode = FocusNode();
  final FocusNode nameFocusNode = FocusNode();

  get referralCodeController => _referralCodeController;

  String getReferralCode() => _referralCodeController.text;

  GlobalKey<FormState> get formKey => _formKey;

  // FocusNode get focusNode => _focusNode;

  set hasReferralCode(bool val) {
    _hasReferralCode = val;
    notifyListeners();
  }

  bool get hasReferralCode => _hasReferralCode;

  void init() {
    Future.delayed(
        const Duration(milliseconds: 200), nameFocusNode.requestFocus);
  }

  void disposeModel() {
    nameFocusNode.dispose();
  }
}
