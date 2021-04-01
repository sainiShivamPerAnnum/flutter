import 'dart:ui';

import 'package:felloapp/base_util.dart';
import 'package:felloapp/ui/pages/onboarding/icici/input-elements/input_field.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/logger.dart';
import 'package:felloapp/util/size_config.dart';
import 'package:felloapp/util/ui_constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class NameInputScreen extends StatefulWidget {
  static const int index = 2;

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
  bool _isInvested = false;
  bool _isInitialized = false;
  bool _validate = true;
  int gen = 1;
  bool isPlayer = false;
  TextEditingController _nameFieldController;
  TextEditingController _emailFieldController;
  TextEditingController _ageFieldController;
  static BaseUtil authProvider;
  DateTime initialDate = DateTime(2000, 1, 1, 0, 0);
  List<bool> _selections = [false, true];
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  DateTime selectedDate = DateTime.now();
  TextEditingController _dateController = new TextEditingController(
      text: '${DateTime.now().toLocal()}'.split(' ')[0]);

  Future<void> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(1940, 8),
        lastDate: DateTime(2101),
        builder: (BuildContext context, Widget child) {
          return Theme(
            data: ThemeData.dark().copyWith(
              colorScheme: ColorScheme.dark(
                primary: UiConstants.primaryColor,
                onPrimary: Colors.black,
                surface: UiConstants.primaryColor,
                onSurface: Colors.black,
              ),
              dialogBackgroundColor: Colors.blueGrey[50],
            ),
            child: child,
          );
        });
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        _dateController.text = "${picked.toLocal()}".split(' ')[0];
      });
  }

  DateTime _chosenDateTime;

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
                        mode: CupertinoDatePickerMode.date,
                        maximumDate: DateTime(2003, 1, 1, 0, 0),
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
                        initialDate = selectedDate;
                        Navigator.of(ctx).pop();
                      })
                ],
              ),
            ));
  }

  @override
  Widget build(BuildContext context) {
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
    return Padding(
      padding:
          EdgeInsets.symmetric(horizontal: SizeConfig.blockSizeHorizontal * 5),
      child: Form(
          key: _formKey,
          child: ListView(
            shrinkWrap: true,
            children: <Widget>[
              SizedBox(
                height: 30,
              ),
              Align(
                child: Image.asset(
                  Assets.logoMaxSize,
                  height: SizeConfig.screenHeight * 0.05,
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Text(
                "Let's introduce",
                style: GoogleFonts.montserrat(
                    fontSize: SizeConfig.largeTextSize,
                    fontWeight: FontWeight.w700),
              ),
              SizedBox(
                height: 20,
              ),

              TextFormField(
                controller: _nameFieldController,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  labelText: 'Name',
                  prefixIcon: Icon(Icons.person),
                  focusColor: UiConstants.primaryColor,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                validator: (value) {
                  return (value != null && value.isNotEmpty)
                      ? null
                      : 'Please enter your name';
                },
                onFieldSubmitted: (v) {
                  FocusScope.of(context).nextFocus();
                },
              ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: _emailFieldController,
                keyboardType: TextInputType.emailAddress,
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
              ),
              // Padding(
              //   padding: const EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 18.0),
              //   child: TextFormField(
              //     controller: _ageFieldController,
              //     keyboardType: TextInputType.number,
              //     decoration: InputDecoration(
              //       labelText: 'Age',
              //       prefixIcon: Icon(Icons.perm_contact_calendar),
              //     ),
              //     validator: (value) {
              //       return (value != null && value.isNotEmpty)
              //           ? null
              //           : 'Please enter your age';
              //     },
              //     onFieldSubmitted: (v) {
              //       FocusScope.of(context).nextFocus();
              //     },
              //   ),
              // ),
              SizedBox(
                height: 20,
              ),
              InkWell(
                onTap: () {
                  // _selectDate(context);
                  _showDatePicker(context);
                },
                child: TextFormField(
                  textAlign: TextAlign.start,
                  enabled: false,
                  keyboardType: TextInputType.datetime,
                  validator: (value) {
                    return null;
                  },
                  controller: _dateController,
                  decoration: InputDecoration(
                    focusColor: UiConstants.primaryColor,
                    disabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    labelText: 'DOB',
                    hintText: 'Choose a date',
                    prefixIcon: Icon(
                      Icons.calendar_today,
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
                    color: Colors.grey,
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
                      height: SizeConfig.blockSizeVertical * 3,
                      color: Colors.grey,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton(
                            iconEnabledColor: UiConstants.primaryColor,
                            value: gen,
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
                                    style: GoogleFonts.montserrat(),
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
                height: 80,
                width: SizeConfig.screenWidth * 0.2,
                margin: EdgeInsets.only(bottom: 25),
                child: Column(
                  children: [
                    Spacer(),
                    Text("Have you ever invested in Mutual Funds?",
                        style: TextStyle(
                            color: Colors.grey[600],
                            fontStyle: FontStyle.italic)),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        RaisedButton(
                          color: _isInvested
                              ? UiConstants.primaryColor
                              : Color(0xffe9e9ea),
                          onPressed: () {
                            setState(() {
                              _isInvested = true;
                            });
                          },
                          child: Text(
                            " YES ",
                            style: TextStyle(
                                color:
                                    _isInvested ? Colors.white : Colors.grey),
                          ),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        RaisedButton(
                          color: _isInvested
                              ? Color(0xffe9e9ea)
                              : UiConstants.primaryColor,
                          onPressed: () {
                            setState(() {
                              _isInvested = false;
                            });
                          },
                          child: Text(
                            " NO ",
                            style: TextStyle(
                                color: isInvested ? Colors.grey : Colors.white),
                          ),
                        ),
                      ],
                    ),
                    // Spacer(),
                  ],
                ),
              ),

              // Padding(
              //     padding: const EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 18.0),
              //     child: Column(
              //       children: [
              //         Text(
              //           'Have you ever invested in mutual funds before?',
              //           textAlign: TextAlign.start,
              //           style: TextStyle(
              //               fontSize: 18,
              //               color: Colors.grey[600],
              //               fontStyle: FontStyle.italic),
              //         ),
              //         SizedBox(
              //           height: 20,
              //         ),
              //         ToggleButtons(
              //           children: [
              //             Padding(
              //               padding: EdgeInsets.all(15),
              //               child: Column(
              //                 children: [Icon(Icons.check), Text('YES')],
              //               ),
              //             ),
              //             Padding(
              //               padding: EdgeInsets.all(15),
              //               child: Column(
              //                 children: [Icon(Icons.clear), Text('NO')],
              //               ),
              //             ),
              //           ],
              //           fillColor: UiConstants.primaryColor.withOpacity(0.3),
              //           isSelected: _selections,
              //           selectedColor: UiConstants.primaryColor,
              //           disabledColor: UiConstants.accentColor,
              //           onPressed: (int index) {
              //             _selections[index] = !_selections[index];
              //             if (index == 0)
              //               _selections[1] = !_selections[1];
              //             else
              //               _selections[0] = !_selections[0];
              //             setState(() {});
              //           },
              //         )
              //       ],
              //     )),
              SizedBox(
                height: SizeConfig.screenHeight * 0.2,
              ),
            ],
          )
          //    )
          //)
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

  get formKey => _formKey;
}
