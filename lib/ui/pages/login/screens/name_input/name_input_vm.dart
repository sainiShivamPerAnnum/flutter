import 'dart:typed_data';

import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/enums/screen_item_enum.dart';
import 'package:felloapp/core/ops/https/http_ops.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/architecture/base_vm.dart';
import 'package:felloapp/ui/pages/login/screens/name_input/name_input_view.dart';
import 'package:felloapp/util/custom_logger.dart';
import 'package:felloapp/util/locator.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';

class NameInputScreenViewModel extends BaseModel {
  final BaseUtil baseProvider = locator<BaseUtil>();
  final HttpModel httpProvider = locator<HttpModel>();
  final UserService _userService = locator<UserService>();
  final CustomLogger _logger = locator<CustomLogger>();

  final _formKey = GlobalKey<FormState>();

  TextEditingController nameFieldController;
  TextEditingController emailFieldController;
  TextEditingController dateFieldController;
  TextEditingController monthFieldController;
  TextEditingController yearFieldController;

  TextEditingController dateController = new TextEditingController(text: '');

  String _name;
  String _email;
  String _age;
  int _gen;
  String _stateChosenValue;

  bool isEmailEntered = false;
  bool emailEnabled = false;
  String emailText = "Email";

  bool _isInvested = true;
  bool _isInitialized = false;
  bool _validate = true;
  bool _isSigningIn = false;

  bool isUploaded = false;
  bool isContinuedWithGoogle = false;

  bool isPlayer = false;

  String _dateInputError = "";
  String get dateInputError => this._dateInputError;

  int get gen => _gen;

  get stateChosenValue => this._stateChosenValue;

  set stateChosenValue(String value) {
    this._stateChosenValue = value;
    notifyListeners();
  }

  set gen(int val) {
    _gen = val;
    notifyListeners();
  }

  set dateInputError(String value) {
    this._dateInputError = value;
    notifyListeners();
  }

  DateTime selectedDate = null;

  get formKey => _formKey;

  String get email {
    if (!isContinuedWithGoogle)
      return emailFieldController.text;
    else if (emailText == 'Email')
      return null;
    else
      return emailText;
  }

  set email(String value) {
    emailFieldController.text = value;
  }

  String get name => nameFieldController.text;

  bool get isEmailVerified => isContinuedWithGoogle && emailText != "Email";

  init() {
    if (!_isInitialized) {
      _isInitialized = true;
      nameFieldController =
          (_userService.baseUser != null && _userService.baseUser.name != null)
              ? new TextEditingController(text: _userService.baseUser.name)
              : new TextEditingController();
      emailFieldController =
          (_userService.baseUser != null && _userService.baseUser.email != null)
              ? new TextEditingController(text: _userService.baseUser.email)
              : new TextEditingController();
      dateFieldController = new TextEditingController();
      monthFieldController = new TextEditingController();
      yearFieldController = new TextEditingController();
    }
  }

  showEmailOptions() {
    baseProvider.isGoogleSignInProgress = false;
    BaseUtil.openModalBottomSheet(
        isBarrierDismissable: false,
        borderRadius: BorderRadius.circular(15),
        content: SignInOptions(
          onEmailSignIn: continueWithEmail,
          onGoogleSignIn: continueWithGoogle,
        ),
        addToScreenStack: true,
        hapticVibrate: true);
  }

  continueWithEmail() {
    emailEnabled = true;
    notifyListeners();
    AppState.backButtonDispatcher.didPopRoute();
  }

  continueWithGoogle() async {
    try {
      await GoogleSignIn().signOut();
      final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();
      if (googleUser != null) {
        if (await httpProvider.isEmailNotRegistered(
            _userService.firebaseUser.uid, googleUser.email)) {
          nameFieldController.text = googleUser.displayName;
          _userService.baseUser.isEmailVerified = true;
          baseProvider.myUserDpUrl = googleUser.photoUrl;
          Uint8List bytes =
              (await NetworkAssetBundle(Uri.parse(googleUser.photoUrl))
                      .load(googleUser.photoUrl))
                  .buffer
                  .asUint8List();
          FirebaseStorage storage = FirebaseStorage.instance;

          Reference ref =
              storage.ref().child("dps/${_userService.baseUser.uid}/image");
          UploadTask uploadTask = ref.putData(bytes);
          try {
            var res = await uploadTask;
            String url = await res.ref.getDownloadURL();
            if (url != null) {
              baseProvider.isProfilePictureUpdated = true;
              baseProvider.setDisplayPictureUrl(url);
              //setstate replaced
              isUploaded = true;
              isEmailEntered = true;
              isContinuedWithGoogle = true;
              emailText = googleUser.email;
              baseProvider.isGoogleSignInProgress = false;
              notifyListeners();
            } else {
              baseProvider.isGoogleSignInProgress = false;
              BaseUtil.showNegativeAlert(
                  "Error getting profile picture", "Please try again");
            }
          } catch (e) {
            baseProvider.isGoogleSignInProgress = false;
            BaseUtil.showNegativeAlert(
                "Error uploading profile picture", "Please try again");
          }
          AppState.backButtonDispatcher.didPopRoute();
        } else {
          baseProvider.isGoogleSignInProgress = false;
          BaseUtil.showNegativeAlert(
              "Email already registered", "Please try with another email");
        }
      } else {
        baseProvider.isGoogleSignInProgress = false;
        notifyListeners();
        BaseUtil.showNegativeAlert(
            "No account selected", "Please choose an account from the list");
      }
    } catch (e) {
      _logger.d(e.toString());
      baseProvider.isGoogleSignInProgress = false;
      BaseUtil.showNegativeAlert(
          "Unable to verify", "Please try a different method");
    }
  }

  setError() {
    _validate = false;
    notifyListeners();
  }

  set name(String value) {
    //_name = value;
    nameFieldController.text = value;
  }

  bool get isInvested => _isInvested;

  set isInvested(bool value) {
    _isInvested = value;
  }

  DateTime get dob {
    return selectedDate;
  }

  set isSigningin(bool val) {
    _isSigningIn = val;
  }

  bool isValidDate() {
    dateInputError = "";
    // Check if any field is not empty

    if (yearFieldController.text.isEmpty ||
        monthFieldController.text.isEmpty ||
        dateFieldController.text.isEmpty) {
      dateInputError = "Date field cannot be empty, please enter a valid date";
      return false;
    }
    // Check if the filed values are within range
    if (int.tryParse(yearFieldController.text) > DateTime.now().year ||
        int.tryParse(yearFieldController.text) < 1950) {
      dateInputError = "Entered year is invalid";
      return false;
    }
    if (int.tryParse(monthFieldController.text) > 12 ||
        int.tryParse(monthFieldController.text) < 1) {
      dateInputError = "Entered month is invalid";
      return false;
    }
    if (int.tryParse(dateFieldController.text) > 31 ||
        int.tryParse(dateFieldController.text) < 1) {
      dateInputError = "Entered date is invalid";
      return false;
    }

    String inputDate = yearFieldController.text +
        monthFieldController.text +
        dateFieldController.text;
    _logger.d("Input date : " + inputDate);
    if (inputDate == null || inputDate.isEmpty) {
      dateInputError = "Invalid date";
      notifyListeners();
      return false;
    }
    final date = DateTime.tryParse(inputDate);
    if (date == null) {
      dateInputError = "Invalid date";
      notifyListeners();
      return false;
    } else {
      final originalFormatString = toOriginalFormatString(date);
      if (inputDate == originalFormatString) {
        selectedDate = date;
        return true;
      } else {
        dateInputError = "Invalid date";
        notifyListeners();
        return false;
      }
    }
  }

  String toOriginalFormatString(DateTime dateTime) {
    final y = dateTime.year.toString().padLeft(4, '0');
    final m = dateTime.month.toString().padLeft(2, '0');
    final d = dateTime.day.toString().padLeft(2, '0');
    return "$y$m$d";
  }

  void showAndroidDatePicker(context) async {
    var res = await showDatePicker(
      context: context,
      initialDate: DateTime(2000, 1, 1),
      firstDate: DateTime(1950, 1, 1),
      lastDate: DateTime(2002, 1, 1),
    );
    if (res != null) print(res);
    selectedDate = res;
    dateController.text = "${res.toLocal()}".split(' ')[0];
    dateFieldController.text = res.day.toString().padLeft(2, '0');
    monthFieldController.text = res.month.toString().padLeft(2, '0');
    yearFieldController.text = res.year.toString();
    notifyListeners();
  }

  validateFields() {
    if (_formKey.currentState.validate()) {
      if (!isEmailEntered &&
          (emailFieldController == null || emailFieldController.text.isEmpty)) {
        BaseUtil.showNegativeAlert(
            'Email field empty', 'Please enter a valid email');
        return false;
      }
      if (gen == null) {
        BaseUtil.showNegativeAlert(
            'Gender field empty', 'Please enter a valid gender');
        return false;
      }
      if (!isValidDate()) return false;
      if (stateChosenValue == null) {
        BaseUtil.showNegativeAlert(
            'State field empty', 'Please enter a valid State');
        return false;
      }
      return true;
    }
    return false;
  }
}
