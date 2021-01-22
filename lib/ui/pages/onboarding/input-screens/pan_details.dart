import 'package:felloapp/ui/pages/onboarding/input-elements/error_dialog.dart';
import 'package:felloapp/ui/pages/onboarding/input-elements/input_field.dart';
import 'package:felloapp/ui/pages/onboarding/input-elements/route_transitions.dart';
import 'package:felloapp/ui/pages/onboarding/input-screens/personal_details.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/ui_constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PanInputScreen extends StatelessWidget {
  TextEditingController panInput = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    double _height = MediaQuery.of(context).size.height;
    double _width = MediaQuery.of(context).size.width;

    return Scaffold(
        body: SafeArea(
      child: Container(
          padding: EdgeInsets.symmetric(horizontal: _width * 0.04),
          width: _width,
          height: _height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Image.asset(
                    Assets.iciciGraphic,
                    fit: BoxFit.contain,
                    height: 100,
                    width: 100,
                  ),
                  Icon(
                    Icons.help_outline_rounded,
                  ),
                ],
              ),
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "LET'S START\nWITH YOUR",
                      style: TextStyle(
                        fontSize: 50,
                        color: Colors.black87,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Text(
                      "PAN",
                      style: TextStyle(
                        fontSize: 50,
                        color: UiConstants.primaryColor,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    InputField(
                      child: TextField(
                        autofocus: false,
                        controller: panInput,
                        decoration: inputFieldDecoration("Eg: ABCDXXXXXX"),
                      ),
                    ),
                    Wrap(
                      spacing: 20,
                      children: [
                        Chip(
                          label: Text("What is a PAN?"),
                          backgroundColor: UiConstants.chipColor,
                        ),
                        Chip(
                          label: Text("Why do I need to give my PAN Number?"),
                          backgroundColor: UiConstants.chipColor,
                        ),
                        Chip(
                          label: Text("Where can I get my PAN?"),
                          backgroundColor: UiConstants.chipColor,
                        ),
                        Chip(
                          label: Text("How does a PAN look like?"),
                          backgroundColor: UiConstants.chipColor,
                        ),
                      ],
                    )
                  ],
                ),
              ),
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
                      RegExp panCheck = RegExp(r"[A-Z]{5}[0-9]{4}[A-Z]{1}");
                      if (panInput.text.isEmpty) {
                        showErrorDialog(
                            "Oops!", "Field cannot be empty!", context);
                      } else if (panCheck.hasMatch(panInput.text)) {
                        print("good");
                        Navigator.push(
                            context,
                            EnterExitRoute(
                              exitPage: this,
                              enterPage: PersonalDetailsInputScreen(),
                            ));
                      } else {
                        showErrorDialog("Oops!", "Invalid PAN!", context);
                      }
                    },
                    child: Text(
                      "VERIFY",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              )
            ],
          )),
    ));
  }
}


// validator: (value) {
//                             RegExp panCheck =
//                                 RegExp(r"[A-Z]{5}[0-9]{4}[A-Z]{1}");
//                             if (value.isEmpty) {
//                               return 'Please enter some text';
//                             } else if (panCheck.hasMatch(value)) {
//                               print("good");
//                             }
//                             return null;
//                           }