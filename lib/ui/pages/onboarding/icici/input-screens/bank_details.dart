import 'package:felloapp/ui/pages/onboarding/icici/input-elements/data_provider.dart';
import 'package:felloapp/ui/pages/onboarding/icici/input-elements/input_field.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';

class BankDetailsInputScreen extends StatefulWidget {
  static const int index = 3;

  @override
  State createState() => _BankDetailsInputScreenState();
}

class _BankDetailsInputScreenState extends State<BankDetailsInputScreen> {
  @override
  Widget build(BuildContext context) {
    double _height = MediaQuery.of(context).size.height;
    double _width = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
          child: SingleChildScrollView(
        child: Container(
          height: _height,
          width: _width,
          padding: EdgeInsets.symmetric(horizontal: _width * 0.04),
          child: Center(
            child: Form(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
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
                      controller: IDP.accNo,
                      decoration: inputFieldDecoration("Account No"),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  Text("Confirm Account No"),
                  InputField(
                    child: TextField(
                      controller: IDP.cnfAccNo,
                      decoration: inputFieldDecoration("Confirm Account No"),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  SizedBox(height: 20),
                  Text("Select your Account Type"),
                  _buildAcctTypeWidget(IDP.userAcctTypes),
                  Text("IFSC Code"),
                  InputField(
                    child: TextField(
                      controller: IDP.ifsc,
                      decoration: inputFieldDecoration("IFSC Code"),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      )),
    );
  }

  Widget _buildAcctTypeWidget(List<Map<String, String>> acctTypes) {
    return InputField(
      child: DropdownButtonFormField(
        decoration: InputDecoration(
          border: InputBorder.none,
        ),
        iconEnabledColor: UiConstants.primaryColor,
        hint: Text("Account Type"),
        value: IDP.acctTypeChosenValue,
        onChanged: (String newVal) {
          setState(() {
            IDP.acctTypeChosenValue = newVal;
          });
        },
        items: acctTypes
            .map(
              (e) => DropdownMenuItem(
                value: e["CODE"],
                child: Text(e["NAME"]),
              ),
            )
            .toList(),
      ),
    );
  }
}
