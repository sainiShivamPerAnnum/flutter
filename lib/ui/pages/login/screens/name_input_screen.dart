import 'dart:ui';

import 'package:felloapp/base_util.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/logger.dart';
import 'package:felloapp/util/size_config.dart';
import 'package:felloapp/util/ui_constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';

class NameInputScreen extends StatefulWidget {
  static const int index = 2;
  //final VoidCallback continueWithGoogle;

  NameInputScreen({Key key}) : super(key: key); //pager index

  @override
  State<StatefulWidget> createState() => NameInputScreenState();
}

class NameInputScreenState extends State<NameInputScreen> {
  Log log = new Log("NameInputScreen");
  RegExp _emailRegex = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
  String _name;
  String _email;
  String _age;
  bool _isInvested = null;
  bool _isInitialized = false;
  bool _validate = true;
  int gen = null;
  bool isPlayer = false;
  TextEditingController _nameFieldController;
  TextEditingController _emailFieldController;
  TextEditingController _ageFieldController;
  static BaseUtil authProvider;
  DateTime initialDate = DateTime(1997, 1, 1, 0, 0);
  List<bool> _selections = [false, true];
  final _formKey = GlobalKey<FormState>();
  DateTime selectedDate = null;
  static BaseUtil baseProvider;
  TextEditingController _dateController = new TextEditingController(text: '');

  bool _isSigningIn = false;
  bool _isContinuedWithGoogle = false;
  bool _emailEnabled = false;
  String emailText = "Email";

  showEmailOptions() {
    showModalBottomSheet(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        isDismissible: false,
        context: context,
        builder: (ctx) {
          return Wrap(
            children: [
              Container(
                decoration: BoxDecoration(),
                padding: EdgeInsets.all(
                  SizeConfig.blockSizeHorizontal * 5,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Choose an email option",
                      style: TextStyle(
                        color: Colors.black54,
                        fontWeight: FontWeight.w700,
                        fontSize: 24,
                      ),
                    ),
                    Divider(
                      height: 32,
                      thickness: 2,
                    ),
                    ListTile(
                      leading: SvgPicture.asset(
                        "images/svgs/google.svg",
                        height: 24,
                        width: 24,
                      ),
                      title: Text("Continue with Google"),
                      onTap: () async {
                        final GoogleSignInAccount googleUser =
                            await GoogleSignIn().signIn();
                        if (googleUser != null) {
                          _nameFieldController.text = googleUser.displayName;
                          baseProvider.myUser.isEmailVerified = true;
                          baseProvider.myUserDpUrl = googleUser.photoUrl;
                          setState(() {
                            _isContinuedWithGoogle = true;
                            emailText = googleUser.email;
                          });
                          Navigator.pop(context);
                        }
                      },
                    ),
                    Divider(),
                    ListTile(
                      leading: Icon(
                        Icons.alternate_email,
                        color: UiConstants.primaryColor,
                      ),
                      title: Text("use another email"),
                      onTap: () {
                        setState(() {
                          _emailEnabled = true;
                        });
                        Navigator.pop(context);
                      },
                    ),
                    SizedBox(
                      height: 24,
                    )
                  ],
                ),
                width: double.infinity,
              ),
            ],
          );
        });
  }

  void _showAndoroidDatePicker() async {
    var res = await showDatePicker(
      context: context,
      initialDate: DateTime(2000, 1, 1),
      firstDate: DateTime(1950, 1, 1),
      lastDate: DateTime(2002, 1, 1),
      initialDatePickerMode: DatePickerMode.year,
    );
    // if (selectedDate != null)
    setState(() {
      selectedDate = res;
      _dateController.text = "${res.toLocal()}".split(' ')[0];
    });
  }

  // Show the modal that contains the CupertinoDatePicker
  void _showDatePicker(ctx) {
    // showCupertinoModalPopup is a built-in function of the cupertino library
    showCupertinoModalPopup(
        context: ctx,
        builder: (_) => Container(
              height: 500,
              color: Colors.white,
              child: Column(
                children: [
                  Container(
                    height: 400,
                    child: CupertinoDatePicker(
                        backgroundColor: Colors.white70,
                        mode: CupertinoDatePickerMode.date,
                        minimumDate: DateTime(1950, 1, 1, 0, 0),
                        maximumDate: DateTime(2008, 1, 1, 0, 0),
                        initialDateTime: initialDate,
                        onDateTimeChanged: (val) {
                          setState(() {
                            selectedDate = val;
                            _dateController.text =
                                "${val.toLocal()}".split(' ')[0];
                          });
                        }),
                  ),

                  // Close the modal
                  CupertinoButton(
                      child: Text(
                        'OK',
                        style: TextStyle(color: UiConstants.primaryColor),
                      ),
                      onPressed: () {
                        if (selectedDate != null) initialDate = selectedDate;
                        Navigator.of(ctx).pop();
                        FocusScope.of(context).unfocus();
                      })
                ],
              ),
            ));
  }

  @override
  Widget build(BuildContext context) {
    baseProvider = Provider.of<BaseUtil>(context, listen: false);
    if (!_isInitialized) {
      _isInitialized = true;
      authProvider = Provider.of<BaseUtil>(context, listen: false);
      _nameFieldController =
          (authProvider.myUser != null && authProvider.myUser.name != null)
              ? new TextEditingController(text: authProvider.myUser.name)
              : new TextEditingController();
      _emailFieldController =
          (authProvider.myUser != null && authProvider.myUser.email != null)
              ? new TextEditingController(text: authProvider.myUser.email)
              : new TextEditingController();
      _ageFieldController =
          (authProvider.myUser != null && authProvider.myUser.age != null)
              ? new TextEditingController(text: authProvider.myUser.age)
              : new TextEditingController();
    }
    return Container(
      child: ListView(
        //crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Text(
              "Tell us a bit about yourself",
              style: TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: SizeConfig.screenWidth * 0.06,
              ),
            ),
          ),
          Text("Please make sure all details are correct"),
          SizedBox(
            height: 24,
          ),
          Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                // SizedBox(
                //   height: 30,
                // ),
                // Align(
                //   child: Image.asset(
                //     Assets.logoMaxSize,
                //     height: SizeConfig.screenHeight * 0.05,
                //   ),
                // ),
                // SizedBox(
                //   height: 30,
                // ),
                // Text(
                //   "Tell us a little about yourself",
                //   style: TextStyle(
                //       fontSize: SizeConfig.largeTextSize,
                //       fontWeight: FontWeight.w700),
                // ),
                // SizedBox(
                //   height: 20,
                // ),
                _emailEnabled
                    ? TextFormField(
                        controller: _emailFieldController,
                        keyboardType: TextInputType.emailAddress,
                        autofocus: true,
                        decoration: InputDecoration(
                          labelText: 'Email',
                          prefixIcon: Icon(Icons.email),
                          focusColor: UiConstants.primaryColor,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        validator: (value) {
                          return (value != null &&
                                  value.isNotEmpty &&
                                  _emailRegex.hasMatch(value))
                              ? null
                              : 'Please enter a valid email';
                        },
                      )
                    : InkWell(
                        onTap: showEmailOptions,
                        child: Container(
                          height: 60,
                          padding:
                              EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                          width: double.infinity,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: UiConstants.primaryColor.withOpacity(0.3),
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          alignment: Alignment.centerLeft,
                          child: Row(
                            children: [
                              Icon(Icons.email,
                                  color: _isContinuedWithGoogle
                                      ? UiConstants.primaryColor
                                      : Colors.grey),
                              SizedBox(width: 12),
                              Text(
                                emailText,
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                              Spacer(),
                              emailText != "Email"
                                  ? Icon(
                                      Icons.verified,
                                      color: UiConstants.primaryColor,
                                    )
                                  : SizedBox()
                            ],
                          ),
                        ),
                      ),

                SizedBox(
                  height: 24,
                ),
                TextFormField(
                  controller: _nameFieldController,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    labelText: 'Name',
                    prefixIcon: Icon(
                      Icons.person,
                    ),
                  ),
                  autofocus: false,
                  validator: (value) {
                    return (value != null && value.isNotEmpty)
                        ? null
                        : 'Please enter your name';
                  },
                ),

                SizedBox(
                  height: 20,
                ),
                InkWell(
                  onTap: () {
                    // _selectDate(context);
                    _showAndoroidDatePicker();
                    FocusScope.of(context).unfocus();
                  },
                  child: TextFormField(
                    textAlign: TextAlign.start,
                    enabled: false,
                    keyboardType: TextInputType.datetime,
                    validator: (value) {
                      return null;
                    },
                    autofocus: false,
                    controller: _dateController,
                    decoration: InputDecoration(
                      focusColor: UiConstants.primaryColor,
                      disabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: UiConstants.primaryColor.withOpacity(0.3),
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      labelText: 'Date of Birth',
                      hintText: 'Choose a date',
                      prefixIcon: Icon(
                        Icons.calendar_today,
                        color: _dateController.text == ""
                            ? Colors.grey
                            : UiConstants.primaryColor,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  margin: EdgeInsets.only(
                    bottom: 20,
                    top: 5,
                  ),
                  padding: EdgeInsets.all(5),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: UiConstants.primaryColor.withOpacity(0.3),
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 10,
                      ),
                      SvgPicture.asset(
                        'images/svgs/gender.svg',
                        height: SizeConfig.blockSizeVertical * 2,
                        color: gen == null
                            ? Colors.grey
                            : UiConstants.primaryColor,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton(
                              iconEnabledColor: UiConstants.primaryColor,
                              value: gen,
                              hint: Text('Gender'),
                              items: [
                                DropdownMenuItem(
                                  child: Text(
                                    "Male",
                                  ),
                                  value: 1,
                                ),
                                DropdownMenuItem(
                                  child: Text(
                                    "Female",
                                  ),
                                  value: 0,
                                ),
                                DropdownMenuItem(
                                    child: Text(
                                      "Rather Not Say",
                                      style: TextStyle(),
                                    ),
                                    value: -1),
                              ],
                              onChanged: (value) {
                                gen = value;
                                //   isLoading = true;
                                setState(() {});
                                //   filterTransactions();
                              }),
                        ),
                      ),
                    ],
                  ),
                ),
                Text("Have you ever invested in Mutual Funds?",
                    style: TextStyle(
                        color: Colors.grey[600], fontStyle: FontStyle.italic)),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    ElevatedButton(
                      // color: (_isInvested ?? false)
                      //     ? UiConstants.primaryColor
                      //     : Color(0xffe9e9ea),
                      style: ElevatedButton.styleFrom(
                        primary: (_isInvested ?? false)
                            ? UiConstants.primaryColor
                            : Color(0xffe9e9ea),
                        shadowColor: UiConstants.primaryColor.withOpacity(0.3),
                      ),
                      onPressed: () {
                        setState(() {
                          _isInvested = true;
                        });
                      },
                      child: Text(
                        " YES ",
                        style: TextStyle(
                            color: (_isInvested ?? false)
                                ? Colors.white
                                : Colors.grey),
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: (_isInvested ?? true)
                            ? Color(0xffe9e9ea)
                            : UiConstants.primaryColor,
                        shadowColor: UiConstants.primaryColor.withOpacity(0.3),
                      ),
                      onPressed: () {
                        setState(() {
                          _isInvested = false;
                        });
                      },
                      child: Text(
                        " NO ",
                        style: TextStyle(
                            color: (isInvested ?? true)
                                ? Colors.grey
                                : Colors.white),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(
            height: kToolbarHeight * 2,
          )
        ],
      ),
    );
  }

  setError() {
    setState(() {
      _validate = false;
    });
  }

  String get email => _emailFieldController.text;

  set email(String value) {
    _emailFieldController.text = value;
    //_email = value;
  }

  String get name => _nameFieldController.text;

  set name(String value) {
    //_name = value;
    _nameFieldController.text = value;
  }

  String get age => _ageFieldController.text;

  set age(String value) {
    _ageFieldController.text = value;
  }

  bool get isInvested => _isInvested;

  set isInvested(bool value) {
    _isInvested = value;
  }

  DateTime get dob => selectedDate;

  int get gender => gen;

  set isSigningin(bool val) {
    _isSigningIn = val;
  }

  get formKey => _formKey;
}
