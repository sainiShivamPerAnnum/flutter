import 'dart:ui';

import 'package:felloapp/base_util.dart';
import 'package:felloapp/util/logger.dart';
import 'package:felloapp/util/ui_constants.dart';
import 'package:flutter/material.dart';
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
  bool _isInvested;
  bool _isInitialized = false;
  bool _validate = true;
  TextEditingController _nameFieldController;
  TextEditingController _emailFieldController;
  TextEditingController _ageFieldController;
  static BaseUtil authProvider;
  List<bool> _selections = [false, true];
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      _isInitialized = true;
      authProvider = Provider.of<BaseUtil>(context);
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
    return Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 18.0),
              child: TextFormField(
                controller: _nameFieldController,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  labelText: 'Name',
                  prefixIcon: Icon(Icons.person),
                ),
                validator: (value) {
                  return (value != null &&
                          value.isNotEmpty &&
                          _emailRegex.hasMatch(value))
                      ? null
                      : 'Please enter a valid email';
                },
                onFieldSubmitted: (v) {
                  FocusScope.of(context).nextFocus();
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 18.0),
              child: TextFormField(
                controller: _emailFieldController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.email),
                ),
                validator: (value) {
                  return (value != null && value.isNotEmpty)
                      ? null
                      : 'Please enter your name';
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 18.0),
              child: TextFormField(
                controller: _ageFieldController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Age',
                  prefixIcon: Icon(Icons.perm_contact_calendar),
                ),
                validator: (value) {
                  return (value != null && value.isNotEmpty)
                      ? null
                      : 'Please enter your age';
                },
                onFieldSubmitted: (v) {
                  FocusScope.of(context).nextFocus();
                },
              ),
            ),
            Padding(
                padding: const EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 18.0),
                child: Column(
                  children: [
                    Text(
                      'Have you ever invested in mutual funds before?',
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey[600],
                          fontStyle: FontStyle.italic),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    ToggleButtons(
                      children: [
                        Padding(
                          padding: EdgeInsets.all(15),
                          child: Column(
                            children: [Icon(Icons.check), Text('YES')],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(15),
                          child: Column(
                            children: [Icon(Icons.clear), Text('NO')],
                          ),
                        ),
                      ],
                      fillColor: UiConstants.primaryColor.withOpacity(0.3),
                      isSelected: _selections,
                      selectedColor: UiConstants.primaryColor,
                      disabledColor: UiConstants.accentColor,
                      onPressed: (int index) {
                        _selections[index] = !_selections[index];
                        if (index == 0)
                          _selections[1] = !_selections[1];
                        else
                          _selections[0] = !_selections[0];
                        setState(() {});
                      },
                    )
                  ],
                )),
          ],
        )
        //    )
        //)
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

  bool get isInvested => _selections[0];

  set isInvested(bool value) {
    _isInvested = value;
  }

  get formKey => _formKey;
}
