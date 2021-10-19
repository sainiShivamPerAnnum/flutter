import 'dart:io';

import 'package:country_code_picker/country_code_picker.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/logger.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
  String code = "+91";

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
    S locale = S.of(context);
    return Container(
      padding: EdgeInsets.symmetric(
        // horizontal: SizeConfig.pageHorizontalMargins,
        vertical: SizeConfig.pageHorizontalMargins * 2,
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SvgPicture.asset(
              Assets.enterPhoneNumber,
              width: SizeConfig.screenWidth * 0.28,
            ),
            SizedBox(height: SizeConfig.padding64),
            Text(
              locale.obEnterMobile,
              textAlign: TextAlign.center,
              style: TextStyles.title4.bold,
            ),
            SizedBox(height: SizeConfig.padding12),
            Text(
              locale.obMobileDesc,
              textAlign: TextAlign.center,
              style: TextStyles.body2,
            ),
            SizedBox(height: SizeConfig.padding40),
            Row(
              children: [
                Text(
                  locale.obMobileLabel,
                  textAlign: TextAlign.start,
                  style: TextStyles.body3.colour(Colors.grey),
                ),
              ],
            ),
            SizedBox(height: SizeConfig.padding6),
            // Form(
            //   key: _formKey,
            //   child: Container(
            //     decoration: BoxDecoration(
            //       border:
            //           Border.all(color: UiConstants.primaryColor, width: 0.5),
            //       borderRadius: BorderRadius.circular(SizeConfig.roundness12),
            //     ),
            //     child: Row(
            //       children: [
            //         CountryCodePicker(
            //           onChanged: (val) {
            //             code = val.toString();
            //             FocusScope.of(context).unfocus();
            //           },
            //           initialSelection: '+91',
            //           favorite: ['+91'],
            //           showCountryOnly: false,
            //           showOnlyCountryWhenClosed: false,
            //           alignLeft: false,
            //         ),
            //         Expanded(
            //           child: Container(
            //             margin: EdgeInsets.only(top: SizeConfig.padding4),
            //             child: TextFormField(
            //               key: _phoneFieldKey,
            //               controller: _mobileController,
            //               keyboardType: TextInputType.phone,
            //               //autofocus: true,
            //               onTap: showAvailablePhoneNumbers,
            //               validator: (value) => _validateMobile(),
            //               onFieldSubmitted: (v) {
            //                 FocusScope.of(context).requestFocus(FocusNode());
            //               },
            // onChanged: (val) {
            //   if (val.length == 10)
            //     FocusScope.of(context).unfocus();
            // },
            //               cursorColor: UiConstants.primaryColor,
            //               cursorWidth: 1,
            //               cursorHeight: SizeConfig.title5,
            //               decoration: InputDecoration(
            //                 enabledBorder:
            //                     OutlineInputBorder(borderSide: BorderSide.none),
            //                 focusedBorder:
            //                     OutlineInputBorder(borderSide: BorderSide.none),
            //                 focusedErrorBorder:
            //                     OutlineInputBorder(borderSide: BorderSide.none),
            //                 errorBorder:
            //                     OutlineInputBorder(borderSide: BorderSide.none),
            //               ),
            //             ),
            //           ),
            //         ),
            //       ],
            //     ),
            //   ),
            // ),
            Form(
              key: _formKey,
              child: TextFormField(
                key: _phoneFieldKey,
                keyboardType: TextInputType.number,
                maxLength: 10,
                cursorColor: UiConstants.primaryColor,
                decoration: InputDecoration(
                  //hintText: "Mobile",

                  prefixIcon: Padding(
                    padding: EdgeInsets.all(SizeConfig.padding4),
                    child: Image.network(
                      "https://media.istockphoto.com/vectors/india-round-flag-vector-flat-icon-vector-id1032066158?k=20&m=1032066158&s=170667a&w=0&h=V79avsonlNYP6KB_vU3TfVK4lrkAzD0otqiWcfQlk-Q=",
                      width: SizeConfig.padding8,
                    ),
                  ),
                  prefixText: "+91 ",
                  prefixStyle: TextStyles.body3.colour(Colors.black),
                ),
                onChanged: (val) {
                  if (val.length == 10) FocusScope.of(context).unfocus();
                },
                onTap: showAvailablePhoneNumbers,
                controller: _mobileController,
                validator: (value) => _validateMobile(),
                onFieldSubmitted: (v) {
                  FocusScope.of(context).requestFocus(FocusNode());
                },
              ),
            ),
            SizedBox(height: SizeConfig.screenHeight / 2),
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
