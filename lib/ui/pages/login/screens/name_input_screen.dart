import 'dart:typed_data';
import 'dart:ui';

import 'package:felloapp/base_util.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/logger.dart';
import 'package:felloapp/util/size_config.dart';
import 'package:felloapp/util/ui_constants.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  TextEditingController _dateFieldController;
  TextEditingController _monthFieldController;
  TextEditingController _yearFieldController;
  String dateInputError = "";

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
  bool isEmailEntered = false;
  bool isUploaded = false;

  showEmailOptions() {
    showModalBottomSheet(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
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
                      onTap: continueWithGoogle,
                    ),
                    Divider(),
                    ListTile(
                      leading: Icon(
                        Icons.alternate_email,
                        color: UiConstants.primaryColor,
                      ),
                      title: Text("Use another email"),
                      subtitle: Text(
                        "this requires an extra verification step",
                        style: TextStyle(
                          color: Colors.red,
                        ),
                      ),
                      onTap: () {
                        setState(() {
                          isEmailEntered = true;
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

  continueWithGoogle() async {
    final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();
    if (googleUser != null) {
      _nameFieldController.text = googleUser.displayName;
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
      uploadTask.then((res) async {
        await res.ref.getDownloadURL().then((url) {
          if (url != null) {
            isUploaded = true;
            baseProvider.isProfilePictureUpdated = true;
            //baseProvider.myUserDpUrl = url;
            baseProvider.setDisplayPictureUrl(url);
            setState(() {
              isUploaded = true;
              isEmailEntered = true;
              _isContinuedWithGoogle = true;
              emailText = googleUser.email;
            });
          } else {
            baseProvider.showNegativeAlert(
                "Oops, we ran into trouble", "please try again", context);
          }
          print(url);
        });
      });
      ;
      Navigator.pop(context);
    } else {
      baseProvider.showNegativeAlert("No account selected",
          "please choose any of the google accounts", context);
    }
  }

  void _showAndoroidDatePicker() async {
    var res = await showDatePicker(
      context: context,
      initialDate: DateTime(2000, 1, 1),
      firstDate: DateTime(1950, 1, 1),
      lastDate: DateTime(2002, 1, 1),
    );
    if (res != null)
      setState(() {
        print(res);
        selectedDate = res;
        _dateController.text = "${res.toLocal()}".split(' ')[0];
        _dateFieldController.text = res.day.toString().padLeft(2, '0');
        _monthFieldController.text = res.month.toString().padLeft(2, '0');
        _yearFieldController.text = res.year.toString();
      });
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
      _dateFieldController = new TextEditingController();
      _monthFieldController = new TextEditingController();
      _yearFieldController = new TextEditingController();
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
                          prefixIcon: Icon(
                            Icons.email,
                            size: 20,
                          ),
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
                        onTap:
                            _isContinuedWithGoogle ? () {} : showEmailOptions,
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
                                  size: 20,
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
                                      size: SizeConfig.blockSizeVertical * 2.4,
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
                      size: 20,
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
                // InkWell(
                //   onTap: () {
                //     // _selectDate(context);
                //     _showAndoroidDatePicker();
                //     FocusScope.of(context).unfocus();
                //   },
                //   child: TextFormField(
                //     textAlign: TextAlign.start,
                //     enabled: false,
                //     keyboardType: TextInputType.datetime,
                //     validator: (value) {
                //       return null;
                //     },
                //     autofocus: false,
                //     controller: _dateController,
                //     decoration: InputDecoration(
                //       focusColor: UiConstants.primaryColor,
                //       disabledBorder: OutlineInputBorder(
                //         borderSide: BorderSide(
                //           color: UiConstants.primaryColor.withOpacity(0.3),
                //         ),
                //         borderRadius: BorderRadius.circular(10),
                //       ),
                //       labelText: 'Date of Birth',
                //       hintText: 'Choose a date',
                //       prefixIcon: Icon(
                //         Icons.calendar_today,
                //         color: _dateController.text == ""
                //             ? Colors.grey
                //             : UiConstants.primaryColor,
                //       ),
                //     ),
                //   ),
                // ),
                // SizedBox(
                //   height: 20,
                // ),
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
                        height: 20,
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

                Container(
                  padding: EdgeInsets.all(5),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: dateInputError != ""
                          ? Colors.red
                          : UiConstants.primaryColor.withOpacity(0.3),
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      SizedBox(
                        width: SizeConfig.blockSizeHorizontal * 5,
                      ),
                      DateField(
                        controller: _dateFieldController,
                        fieldWidth: SizeConfig.screenWidth * 0.12,
                        labelText: "dd",
                        maxlength: 2,
                        validate: (String val) {
                          if (val.isEmpty || val == null) {
                            setState(() {
                              dateInputError = "Date field cannot be empty";
                            });
                          } else if (int.tryParse(val) > 31 ||
                              int.tryParse(val) < 1) {
                            setState(() {
                              dateInputError = "Invalid date";
                            });
                          }
                          return null;
                        },
                      ),
                      Expanded(child: Center(child: Text("/"))),
                      DateField(
                        controller: _monthFieldController,
                        fieldWidth: SizeConfig.screenWidth * 0.12,
                        labelText: "mm",
                        maxlength: 2,
                        validate: (String val) {
                          if (val.isEmpty || val == null) {
                            setState(() {
                              dateInputError = "Date field cannot be empty";
                            });
                          } else if (int.tryParse(val) > 13 ||
                              int.tryParse(val) < 0) {
                            setState(() {
                              dateInputError = "Invalid date";
                            });
                          }
                          return null;
                        },
                      ),
                      Expanded(child: Center(child: Text("/"))),
                      DateField(
                        controller: _yearFieldController,
                        fieldWidth: SizeConfig.screenWidth * 0.16,
                        labelText: "yyyy",
                        maxlength: 4,
                        validate: (String val) {
                          if (val.isEmpty || val == null) {
                            setState(() {
                              dateInputError = "Date field cannot be empty";
                            });
                          } else if (int.tryParse(val) > DateTime.now().year ||
                              int.tryParse(val) < 1950) {
                            setState(() {
                              dateInputError = "Invalid date";
                            });
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        width: 16,
                      ),
                      IconButton(
                        onPressed: _showAndoroidDatePicker,
                        icon: Icon(
                          Icons.calendar_today,
                          size: 20,
                          color: UiConstants.primaryColor,
                        ),
                      )
                    ],
                  ),
                ),
                if (dateInputError != "")
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        child: Text(
                          dateInputError,
                          textAlign: TextAlign.start,
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    ],
                  ),
                SizedBox(
                  height: 20,
                ),
                Text("Have you ever invested in Mutual Funds?",
                    style: TextStyle(
                        color: Colors.grey[600], fontStyle: FontStyle.italic)),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
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

  DateTime get dob {
    return selectedDate;
  }

  int get gender => gen;

  set isSigningin(bool val) {
    _isSigningIn = val;
  }

  get formKey => _formKey;

  bool isValidDate() {
    setState(() {
      dateInputError = "";
    });
    String inputDate = _yearFieldController.text +
        _monthFieldController.text +
        _dateFieldController.text;
    print("Input date : " + inputDate);
    final date = DateTime.parse(inputDate);
    final originalFormatString = toOriginalFormatString(date);
    if (inputDate == originalFormatString) {
      selectedDate = date;
      return true;
    } else {
      setState(() {
        dateInputError = "Invalid date";
      });
      return false;
    }
  }

  String toOriginalFormatString(DateTime dateTime) {
    final y = dateTime.year.toString().padLeft(4, '0');
    final m = dateTime.month.toString().padLeft(2, '0');
    final d = dateTime.day.toString().padLeft(2, '0');
    return "$y$m$d";
  }
}

class DateField extends StatelessWidget {
  final String labelText;
  final TextEditingController controller;
  final maxlength;
  final double fieldWidth;
  final Function validate;

  DateField(
      {this.controller,
      this.labelText,
      this.maxlength,
      this.fieldWidth,
      this.validate});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: fieldWidth,
      child: TextFormField(
        controller: controller,
        maxLength: maxlength,
        cursorColor: UiConstants.primaryColor,
        cursorWidth: 1,
        validator: (val) => validate(val),
        onChanged: (val) {
          if (val.length == maxlength && maxlength == 2) {
            FocusScope.of(context).nextFocus();
          } else if (val.length == maxlength && maxlength == 4) {
            FocusScope.of(context).unfocus();
          }
        },
        keyboardType: TextInputType.datetime,
        style: TextStyle(
          letterSpacing: 2,
          fontWeight: FontWeight.w500,
        ),
        decoration: InputDecoration(
          counterText: "",
          border: UnderlineInputBorder(
            borderSide: BorderSide.none,
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide.none,
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide.none,
          ),
          hintText: labelText,
          hintStyle: TextStyle(
            color: Colors.grey[400],
            letterSpacing: 2,
          ),
        ),
      ),
    );
  }
}
