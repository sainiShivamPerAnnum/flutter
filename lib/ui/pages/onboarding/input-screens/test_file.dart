import 'package:felloapp/base_util.dart';
import 'package:felloapp/ui/pages/onboarding/input-elements/data_provider.dart';
import 'package:felloapp/ui/pages/onboarding/input-elements/error_dialog.dart';
import 'package:felloapp/ui/pages/onboarding/input-elements/input_field.dart';
import 'package:felloapp/ui/pages/onboarding/input-elements/route_transitions.dart';
import 'package:felloapp/ui/pages/onboarding/input-elements/submit_button.dart';
import 'package:felloapp/ui/pages/onboarding/input-screens/bank_details.dart';
import 'package:felloapp/ui/pages/onboarding/input-screens/income_details.dart';
import 'package:felloapp/ui/pages/onboarding/input-screens/pan_details.dart';
import 'package:felloapp/ui/pages/onboarding/input-screens/personal_details.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TestFile extends StatefulWidget {
  @override
  _TestFileState createState() => _TestFileState();
}

class _TestFileState extends State<TestFile> {
// VARIABLE DECLARATION

  PageController _pageController;
  int _pageIndex = 0;
  final personalDetailsformKey = GlobalKey<FormState>();
  DateTime selectedDate = DateTime.now();
  double _height, _width;
  IDP ipProvider = new IDP();

// DEFAULT
  @override
  void initState() {
    _pageController = PageController(initialPage: _pageIndex);
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

// VIEWPAGER FUNCTIONS
  void onPageChanged(int page) {
    setState(() {
      this._pageIndex = page;
    });
  }

  void onTabTapped(int index) {
    this._pageController.animateToPage(index,
        duration: const Duration(milliseconds: 2000), curve: Curves.easeInOut);
  }

// VERIFICATION FUNCTIONS

  checkPage() {
    if (_pageIndex == 0) {
      verifyPan();
    } else if (_pageIndex == 1) {
      verifyPersonalDetails();
    } else if (_pageIndex == 2) {
      verifyIncomeDetails();
    } else if (_pageIndex == 3) {
      verifyBankDetails();
    }
  }

  verifyPan() {
    RegExp panCheck = RegExp(r"[A-Z]{5}[0-9]{4}[A-Z]{1}");
    if (IDP.panInput.text.isEmpty) {
      showErrorDialog("Oops!", "Field cannot be empty!", context);
    } else if (panCheck.hasMatch(IDP.panInput.text)) {
      print("good");
      onTabTapped(1);
    } else {
      showErrorDialog("Oops!", "Invalid PAN!", context);
    }
  }

  verifyPersonalDetails() {
    if (personalDetailsformKey.currentState.validate()) {
      print("All Cool");
      onTabTapped(2);
    }
  }

  verifyIncomeDetails() {
    if (IDP.occupationChosenValue != null &&
        IDP.wealthChosenValue != null &&
        IDP.exposureChosenValue != null) {
      onTabTapped(3);
    } else {
      showErrorDialog("Oops!", "All Fields are necessary bruh!", context);
    }
  }

  verifyBankDetails() {
    if (IDP.accNo.text == "" ||
        IDP.cnfAccNo.text == "" ||
        IDP.ifsc.text == "") {
      showErrorDialog("Oops!", "All fields are necessary", context);
    } else if (IDP.accNo.text != IDP.cnfAccNo.text) {
      showErrorDialog("Oops", "Please confirm account numbers", context);
    } else {
      showErrorDialog("Hurry", "All Good,Now you can Invest", context);
      print(IDP.panInput.text);
      print(IDP.name.text);
      print(IDP.email.text);
      print(IDP.selectedDate);
      print(IDP.wealthChosenValue);
      print(IDP.exposureChosenValue);
      print(IDP.occupationChosenValue);
      print(IDP.accNo.text);
      print(IDP.ifsc.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;

    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            width: _width,
            height: _height,
            child: Stack(
              children: [
                PageView(
                  physics: NeverScrollableScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  children: [
                    PANPage(),
                    PersonalPage(
                      personalForm: personalDetailsformKey,
                    ),
                    IncomeDetailsInputScreen(),
                    BankDetailsInputScreen(),
                  ],
                  onPageChanged: onPageChanged,
                  controller: _pageController,
                ),
                Positioned(
                  bottom: _height * 0.02,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: _width * 0.04),
                    width: _width,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: _width * 0.15,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CircleAvatar(
                                radius: 5,
                                backgroundColor: UiConstants.primaryColor,
                              ),
                              CircleAvatar(
                                radius: 5,
                                backgroundColor: _pageIndex > 0
                                    ? UiConstants.primaryColor
                                    : UiConstants.spinnerColor,
                              ),
                              CircleAvatar(
                                radius: 5,
                                backgroundColor: _pageIndex > 1
                                    ? UiConstants.primaryColor
                                    : UiConstants.spinnerColor,
                              ),
                              CircleAvatar(
                                radius: 5,
                                backgroundColor: _pageIndex > 2
                                    ? UiConstants.primaryColor
                                    : UiConstants.spinnerColor,
                              ),
                            ],
                          ),
                        ),
                        SubmitButton(action: checkPage, title: "VERIFY")
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
