import 'package:felloapp/ui/pages/login/screens/Field-Container.dart';
import 'package:felloapp/ui/pages/onboarding/icici/input-elements/input_field.dart';
import 'package:felloapp/util/logger.dart';
import 'package:felloapp/util/size_config.dart';
import 'package:felloapp/util/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
  Log log = new Log("MobileInputScreen");
  static final GlobalKey<FormFieldState<String>> _phoneFieldKey =
      GlobalKey<FormFieldState<String>>();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          EdgeInsets.symmetric(horizontal: SizeConfig.blockSizeHorizontal * 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            height: kToolbarHeight * 1.5,
          ),
          Text(
            "Let's quickly onboard you",
            style: TextStyle(
              fontSize: SizeConfig.mediumTextSize,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 24,
            ),
            child: Text(
              "Let's start with your mobile number",
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
                autofocus: true,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: "Mobile",
                  prefixIcon: Icon(Icons.phone),
                  focusColor: UiConstants.primaryColor,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                controller: _mobileController,
                validator: (value) => _validateMobile(value),
                onFieldSubmitted: (v) {
                  FocusScope.of(context).requestFocus(FocusNode());
                },
              ),
            ),
          ),
          SizedBox(height: 24),
          Text(
              "We'll send you an OTP on this number to help secure your account"),
        ],
        //)
      ),
    );
  }

  setError() {
    setState(() {
      _validate = false;
    });
  }

  String _validateMobile(String value) {
    Pattern pattern = "^[0-9]*\$";
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value) || value.length != 10)
      return 'Enter a valid Mobile';
    else
      return null;
  }

  String getMobile() => _mobileController.text;

  get formKey => _formKey;
}
