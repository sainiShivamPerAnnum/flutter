import 'package:felloapp/base_util.dart';
import 'package:felloapp/ui/pages/onboarding/input-elements/input_field.dart';
import 'package:felloapp/ui/pages/onboarding/input-elements/route_transitions.dart';
import 'package:felloapp/ui/pages/onboarding/input-screens/income_details.dart';
import 'package:felloapp/util/ui_constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PersonalDetailsInputScreen extends StatefulWidget {
  @override
  _PersonalDetailsInputScreenState createState() =>
      _PersonalDetailsInputScreenState();
}

class _PersonalDetailsInputScreenState
    extends State<PersonalDetailsInputScreen> {
  BaseUtil baseProvider;
  final _formKey = GlobalKey<FormState>();
  DateTime selectedDate = DateTime.now();
  TextEditingController name = new TextEditingController();
  TextEditingController email = new TextEditingController();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
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
              dialogBackgroundColor: Colors.white,
            ),
            child: child,
          );
        });
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }

  @override
  Widget build(BuildContext context) {
    double _height = MediaQuery.of(context).size.height;
    double _width = MediaQuery.of(context).size.width;
    baseProvider = Provider.of<BaseUtil>(context);
    name.text = baseProvider.myUser.name;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            height: _height,
            width: _width,
            padding: EdgeInsets.symmetric(horizontal: _width * 0.04),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Spacer(),
                  Text(
                    "CONFIRM YOUR",
                    style: TextStyle(
                      fontSize: 50,
                      color: Colors.black87,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Text(
                    "PERSONAL",
                    style: TextStyle(
                      fontSize: 50,
                      color: UiConstants.primaryColor,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Text(
                    "DETAILS",
                    style: TextStyle(
                      fontSize: 50,
                      color: Colors.black87,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  SizedBox(height: 20),
                  Text("Name (As Per PAN Card)"),
                  InputField(
                    child: TextFormField(
                      decoration:
                          inputFieldDecoration(baseProvider.myUser.name),
                      controller: name,
                      validator: (value) {
                        RegExp nameCheck = RegExp(r"^[a-zA-Z\\s]+$");
                        if (value.isEmpty) {
                          return 'Name Field Cannot be Empty';
                        } else if (nameCheck.hasMatch(value)) {
                          return null;
                        } else {
                          return "invalid name";
                        }
                      },
                    ),
                  ),
                  Text("Email"),
                  InputField(
                    child: TextFormField(
                      // The validator receives the text that the user has entered.
                      decoration:
                          inputFieldDecoration(baseProvider.myUser.email),
                      controller: email,
                      validator: (value) {
                        RegExp emailCheck = RegExp(
                            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
                        if (value.isEmpty) {
                          return 'Email field Cannot be empty';
                        } else if (emailCheck.hasMatch(value)) {
                          return null;
                        } else {
                          return "Invalid Email";
                        }
                      },
                    ),
                  ),
                  Text("Mobile No"),
                  InputField(
                    child: Padding(
                      padding:
                          const EdgeInsets.only(bottom: 11, top: 11, right: 15),
                      child: Text(
                        baseProvider.myUser.mobile,
                        style: TextStyle(
                          color: Colors.black54,
                        ),
                      ),
                    ),
                  ),
                  Text("Date of Birth"),
                  InputField(
                    child: Row(
                      children: [
                        Text(
                          "${selectedDate.toLocal()}".split(' ')[0],
                        ),
                        Spacer(),
                        IconButton(
                          onPressed: () => _selectDate(context),
                          icon: Icon(
                            Icons.calendar_today,
                            color: UiConstants.primaryColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Spacer(),
                  Hero(
                    tag: "nextButton",
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: 20),
                      height: 50,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        gradient: new LinearGradient(
                          colors: [
                            UiConstants.primaryColor,
                            UiConstants.primaryColor.withGreen(150),
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      alignment: Alignment.center,
                      child: FlatButton(
                        onPressed: () {
                          if (_formKey.currentState.validate()) {
                            // If the form is valid, display a snackbar. In the real world,
                            // you'd often call a server or save the information in a database.
                            print("All Cool");

                            Navigator.push(
                              context,
                              EnterExitRoute(
                                exitPage: PersonalDetailsInputScreen(),
                                enterPage: IncomeDetailsInputScreen(),
                              ),
                            );
                          }
                        },
                        child: Text(
                          "NEXT",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: _height * 0.03),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
