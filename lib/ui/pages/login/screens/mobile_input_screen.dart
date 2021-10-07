import 'dart:io';

import 'package:felloapp/util/logger.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:sms_autofill/sms_autofill.dart';

class MobileInputScreen extends StatefulWidget {
  static const int index = 0; //pager index
  MobileInputScreen({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => MobileInputScreenState();
}

class MobileInputScreenState extends State<MobileInputScreen> {
  final _formKey = GlobalKey<FormState>();
  final _mobileController = TextEditingController();
  bool _validate = true;
  bool showAvailableMobileNos = true;
  Log log = new Log("MobileInputScreen");
  static final GlobalKey<FormFieldState<String>> _phoneFieldKey =
      GlobalKey<FormFieldState<String>>();

  void showAvailablePhoneNumbers() async {
    if (Platform.isAndroid && showAvailableMobileNos) {
      final SmsAutoFill _autoFill = SmsAutoFill();
      String completePhoneNumber = await _autoFill.hint;
      if (completePhoneNumber != null) {
        setState(() {
          _mobileController.text =
              completePhoneNumber.substring(completePhoneNumber.length - 10);
        });
      }
      showAvailableMobileNos = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "Let's get you onboarded ✅",
              style: TextStyle(
                  fontSize: SizeConfig.mediumTextSize, color: Colors.black54),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 24,
              ),
              child: Text(
                "Please share your mobile number",
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: SizeConfig.screenWidth * 0.06,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 24),
              child: Form(
                key: _formKey,
                child: TextFormField(
                  key: _phoneFieldKey,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: "Mobile",
                    prefixIcon: Icon(Icons.phone),
                    focusColor: UiConstants.primaryColor,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onTap: showAvailablePhoneNumbers,
                  controller: _mobileController,
                  validator: (value) => _validateMobile(),
                  onFieldSubmitted: (v) {
                    FocusScope.of(context).requestFocus(FocusNode());
                  },
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
                "For verification purposes, an OTP shall be sent to this number."),
          ],
          //)
        ),
      ),
    );
  }

  setError() {
    setState(() {
      _validate = false;
    });
  }

  String _validateMobile() {
    Pattern pattern = "^[0-9]*\$";
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(_mobileController.text) ||
        _mobileController.text.length != 10)
      return "Enter a valid mobile number";
    else
      return null;
  }

  String getMobile() => _mobileController.text;

  get formKey => _formKey;
}
