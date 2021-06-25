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
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              margin: EdgeInsets.only(top: 30, bottom: 16),
              child: CircleAvatar(
                radius: SizeConfig.screenWidth * 0.04,
                backgroundColor: Colors.grey.withOpacity(0.5),
                child: Center(
                  child: Icon(
                    Icons.arrow_back_ios_rounded,
                    color: Colors.white,
                    size: SizeConfig.screenWidth * 0.04,
                  ),
                ),
              ),
            ),
          ),
          // RichText(

          //   text:
          //     "Welcome to Fello,",
          //     style: TextStyle(
          // fontSize: SizeConfig.largeTextSize * 1.2,
          // fontWeight: FontWeight.w500,
          //     ),

          // ),
          RichText(
            text: TextSpan(
                text: 'Welcome to ',
                style: TextStyle(
                    fontSize: SizeConfig.largeTextSize * 1.2,
                    fontWeight: FontWeight.w500,
                    color: Colors.black),
                children: <TextSpan>[
                  TextSpan(
                    text: 'Fe',
                    style: TextStyle(
                        fontSize: SizeConfig.largeTextSize * 1.2,
                        fontWeight: FontWeight.w700,
                        color: Colors.black),
                  ),
                  TextSpan(
                    text: 'll',
                    style: TextStyle(
                      color: UiConstants.primaryColor,
                      fontWeight: FontWeight.w700,
                      fontSize: SizeConfig.largeTextSize * 1.2,
                    ),
                  ),
                  TextSpan(
                    text: 'o',
                    style: TextStyle(
                        fontSize: SizeConfig.largeTextSize * 1.2,
                        fontWeight: FontWeight.w700,
                        color: Colors.black),
                  )
                ]),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            "Enter your phone number to continue",
            style: TextStyle(
              fontSize: SizeConfig.mediumTextSize,
            ),
          ),

          Center(
            child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 28.0, 0, 18.0),
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
                )),
          ),
          // SizedBox(
          //   height: 20,
          // ),
          // Container(
          //   width: 230.0,
          //   height: 60.0,
          //   padding: const EdgeInsets.all(8),
          //   decoration: BoxDecoration(
          //     borderRadius: new BorderRadius.circular(30.0),
          //     border: Border.all(color: UiConstants.primaryColor, width: 1.5),
          //     color: Colors.transparent,
          //   ),
          //   child:Tooltip(
          //   message:'Check here',
          //   child: new Material(
          //     child: MaterialButton(
          //       child: Text(
          //         'We are currently servicing only select societies',
          //         textAlign: TextAlign.center,
          //         style: Theme.of(context).textTheme.button.copyWith(color: UiConstants.primaryColor),
          //       ),
          //       onPressed: (){
          //         showDialog(context: context,
          //             builder: (BuildContext context) => LocationAvailabilityDialog()
          //         );
          //       },
          //       highlightColor: Colors.white30,
          //       splashColor: Colors.white30,
          //     ),
          //     color: Colors.transparent,
          //     borderRadius: new BorderRadius.circular(30.0),
          //   ),
          //   ),
          // ),
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
