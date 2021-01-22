import 'package:felloapp/ui/pages/onboarding/input-elements/error_dialog.dart';
import 'package:felloapp/ui/pages/onboarding/input-elements/input_field.dart';
import 'package:felloapp/ui/pages/onboarding/input-screens/pan_details.dart';
import 'package:felloapp/util/ui_constants.dart';
import 'package:flutter/material.dart';

class BankDetailsInputScreen extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  TextEditingController accNo = new TextEditingController();
  TextEditingController cnfAccNo = new TextEditingController();
  TextEditingController ifsc = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    double _height = MediaQuery.of(context).size.height;
    double _width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
        child: Container(
          height: _height,
          width: _width,
          padding: EdgeInsets.symmetric(horizontal: _width * 0.04),
          child: Center(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Spacer(),
                  Text(
                    "LET'S LINK YOUR",
                    style: TextStyle(
                      fontSize: 50,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Text(
                    "BANK",
                    style: TextStyle(
                      fontSize: 50,
                      color: UiConstants.primaryColor,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Text(
                    "ACCOUNT",
                    style: TextStyle(
                      fontSize: 50,
                      color: Colors.black87,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  SizedBox(height: 20),
                  Text("Account No"),
                  InputField(
                    child: TextField(
                      controller: accNo,
                      decoration: inputFieldDecoration("Account No"),
                    ),
                  ),
                  Text("Confirm Account No"),
                  InputField(
                    child: TextField(
                      controller: cnfAccNo,
                      decoration: inputFieldDecoration("Confirm Account No"),
                    ),
                  ),
                  Text("IFSC Code"),
                  InputField(
                    child: TextField(
                      controller: ifsc,
                      decoration: inputFieldDecoration("IFSC Code"),
                    ),
                  ),
                  Spacer(),
                  Container(
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
                        if (accNo.text == "" ||
                            cnfAccNo.text == "" ||
                            ifsc.text == "") {
                          showErrorDialog(
                              "Oops!", "All fields are necessary", context);
                        }
                        if (accNo.text != cnfAccNo.text) {
                          showErrorDialog("Oops",
                              "Please confirm account numbers", context);
                        }
                      },
                      child: Text(
                        "VERIFY",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
