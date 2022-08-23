import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/repository/user_repo.dart';
import 'package:felloapp/core/service/analytics/base_analytics.dart';
import 'package:felloapp/core/service/notifier_services/google_sign_in_service.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/architecture/base_vm.dart';
import 'package:felloapp/util/api_response.dart';
import 'package:felloapp/util/date_helper.dart';
import 'package:felloapp/util/locator.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';

class Level2ViewModel extends BaseModel {
  PageController pageController = PageController(),
      avatarsPageController = PageController(
        viewportFraction: 0.43,
      );
  final _userService = locator<UserService>();
  final _googleSignInService = locator<GoogleSignInService>();
  XFile _selectedProfilePicture;
  int _selectedAvaterId, _currentPage = 0, _avatarsPage = 0;
  DateTime selectedDate;
  final _userRepo = locator<UserRepository>();

  final nameFormKey = GlobalKey<FormState>(),
      emailFormKey = GlobalKey<FormState>(),
      dobFormKey = GlobalKey<FormState>();

  final nameController = TextEditingController(),
      emailController = TextEditingController(),
      dobController = TextEditingController(),
      yearFieldController = TextEditingController(),
      monthFieldController = TextEditingController(),
      dayFieldController = TextEditingController();

  String _dateInputError = "";

  bool _isUpdaingUserDetails = false,
      _isSigningInWithGoogle = false,
      _isGoogleVerified = false;

  int get currentPage => _currentPage;

  set currentPage(int val) {
    _currentPage = val;
    notifyListeners();
  }

  XFile get selectedProfilePicture => _selectedProfilePicture;

  set selectedProfilePicture(XFile val) {
    _selectedProfilePicture = val;
    notifyListeners();
  }

  int get selectedAvaterId => _selectedAvaterId;

  set selectedAvaterId(int val) {
    _selectedAvaterId = val;
    notifyListeners();
  }

  int get avatarsPage => _avatarsPage;

  set avatarsPage(int val) {
    _avatarsPage = val;
    notifyListeners();
  }

  String get dateInputError => _dateInputError;

  set dateInputError(String val) {
    _dateInputError = val;
    notifyListeners();
  }

  bool get isUpdaingUserDetails => _isUpdaingUserDetails;

  set isUpdaingUserDetails(bool val) {
    _isUpdaingUserDetails = val;
    notifyListeners();
  }

  bool get isSigningInWithGoogle => _isSigningInWithGoogle;

  set isSigningInWithGoogle(bool val) {
    _isSigningInWithGoogle = val;
    notifyListeners();
  }

  bool get isGoogleVerified => _isGoogleVerified;

  set isGoogleVerified(bool val) {
    _isGoogleVerified = val;
    notifyListeners();
  }

  chooseProfileImage() async {
    if (await _userService.checkGalleryPermission()) {
      XFile tempSelectedFile = await ImagePicker()
          .pickImage(source: ImageSource.gallery, imageQuality: 45);
      if (tempSelectedFile != null) {
        selectedProfilePicture = tempSelectedFile;
        notifyListeners();
      }
    }
  }

  _updateUser() async {
    isUpdaingUserDetails = true;
    _userService.baseUser.name = nameController.text.trim();
    _userService.baseUser.dob =
        "${yearFieldController.text}-${monthFieldController.text}-${dayFieldController.text}";
    _userService.baseUser.email = emailController.text.trim();
    _userService.baseUser.avatarId =
        selectedAvaterId == 0 || selectedAvaterId == null
            ? 'CUSTOM'
            : 'AV$selectedAvaterId';
    ApiResponse<bool> updateRes = await _userRepo.updateUser(
      uid: _userService.baseUser.uid,
      dMap: {
        'name': _userService.baseUser.name,
        'dob': _userService.baseUser.dob,
        'email': _userService.baseUser.email,
        'mAvatarId': _userService.baseUser.avatarId,
      },
    );
    if (updateRes.model) {
      _userService.setMyUserName(_userService.baseUser.name);
      _userService.setDateOfBirth(_userService.baseUser.dob);
      _userService.setEmail(_userService.baseUser.email);
      if (selectedAvaterId == 0 || selectedAvaterId == null) {
        await _userService.updateProfilePicture(selectedProfilePicture);
        BaseAnalytics.logProfilePictureAdded();
      }
      AppState.backButtonDispatcher.didPopRoute();

      BaseUtil.showPositiveAlert(
        "Updated Successfully",
        "Profile updated successfully",
      );
      isUpdaingUserDetails = false;
    } else {
      BaseUtil.showNegativeAlert(
        "Action failed",
        "Please try again in some time",
      );
      isUpdaingUserDetails = false;
    }
    notifyListeners();
  }

  void handleNextButtonTap() {
    if (isSigningInWithGoogle || isUpdaingUserDetails) {
      return;
    }

    if (currentPage == 0) {
      if (selectedProfilePicture == null && selectedAvaterId == null) {
        BaseUtil.showNegativeAlert(
          'Please Select profile pic',
          'You can select profile picture or choose from avater list',
        );
      } else {
        pageController.nextPage(
          duration: Duration(milliseconds: 500),
          curve: Curves.easeIn,
        );
      }
    } else if (currentPage == 1) {
      if (nameFormKey.currentState.validate()) {
        pageController.nextPage(
          duration: Duration(milliseconds: 500),
          curve: Curves.easeIn,
        );
      }
    } else if (currentPage == 2) {
      if (emailFormKey.currentState.validate()) {
        pageController.nextPage(
          duration: Duration(milliseconds: 500),
          curve: Curves.easeIn,
        );
      }
    } else if (currentPage == 3) {
      if (dobFormKey.currentState.validate() && isValidDate()) {
        _updateUser();
      }
    }

    notifyListeners();
  }

  bool isValidDate() {
    dateInputError = "";
    notifyListeners();
    String inputDate = yearFieldController.text +
        monthFieldController.text +
        dayFieldController.text;
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
      final originalFormatString = BaseUtil.toOriginalFormatString(date);

      if (inputDate != originalFormatString) {
        dateInputError = "Invalid date";
        notifyListeners();
        return false;
      }

      if (!DateHelper.isAdult(date)) {
        dateInputError = "You need to be above 18 to join";
        notifyListeners();
        return false;
      }
      selectedDate = date;
      return true;
    }
  }

  void handleSignInWithGoogle() async {
    isSigningInWithGoogle = true;
    String email = await _googleSignInService.signInWithGoogle();
    if (email != null) {
      emailController.text = email;
      isGoogleVerified = true;
    }
    isSigningInWithGoogle = false;
  }
}
