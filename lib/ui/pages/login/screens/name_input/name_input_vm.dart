import 'dart:typed_data';

import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/enums/screen_item_enum.dart';
import 'package:felloapp/core/ops/https/http_ops.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/architecture/base_vm.dart';
import 'package:felloapp/ui/pages/login/screens/name_input/name_input_view.dart';
import 'package:felloapp/util/locator.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';

class NameInputScreenViewModel extends BaseModel {
  final BaseUtil baseProvider = locator<BaseUtil>();
  final HttpModel httpProvider = locator<HttpModel>();

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

  String dateInputError = "";
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
          (baseProvider.myUser != null && baseProvider.myUser.name != null)
              ? new TextEditingController(text: baseProvider.myUser.name)
              : new TextEditingController();
      emailFieldController =
          (baseProvider.myUser != null && baseProvider.myUser.email != null)
              ? new TextEditingController(text: baseProvider.myUser.email)
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
    isEmailEntered = true;
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
            baseProvider.myUser.uid, googleUser.email)) {
          nameFieldController.text = googleUser.displayName;
          baseProvider.myUser.isEmailVerified = true;
          baseProvider.myUserDpUrl = googleUser.photoUrl;
          Uint8List bytes =
              (await NetworkAssetBundle(Uri.parse(googleUser.photoUrl))
                      .load(googleUser.photoUrl))
                  .buffer
                  .asUint8List();
          FirebaseStorage storage = FirebaseStorage.instance;

          Reference ref =
              storage.ref().child("dps/${baseProvider.myUser.uid}/image");
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
      print(e.toString());
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
    notifyListeners();
    String inputDate = yearFieldController.text +
        monthFieldController.text +
        dateFieldController.text;
    print("Input date : " + inputDate);
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
}
