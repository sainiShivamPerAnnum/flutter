import 'dart:developer';

import 'package:felloapp/ui/pages/login/login_components/login_textfield.dart';
import 'package:felloapp/ui/pages/static/app_widget.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:felloapp/ui/pages/login/profile_setup/complete_profile_vm.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DOB4 extends StatelessWidget {
  const DOB4({Key key, @required this.model}) : super(key: key);
  final CompleteProfileViewModel model;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(height: SizeConfig.padding80),
        SvgPicture.asset('assets/svg/signUp_gift_svg.svg'),
        SizedBox(height: SizeConfig.padding24),
        Text(
          'When did you arrive in this\nworld?',
          style: TextStyles.rajdhaniSB.title5,
          textAlign: TextAlign.center,
        ),
        SizedBox(height: SizeConfig.padding4),
        Text(
          'Swipe to choose your avatar',
          style: TextStyles.sourceSans.body3.colour(Color(0xFFBDBDBE)),
        ),
        SizedBox(height: SizeConfig.padding64),
        //input
        // LogInTextField(
        //   hintText: 'Your date of birth',
        //   textInputType: TextInputType.number,
        //   controller: null,
        // ),
        Form(
          key: model.dobFormKey,
          child: Container(
            width: SizeConfig.screenWidth * 0.6,
            height: SizeConfig.screenWidth * 0.1377,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(SizeConfig.roundness5),
              border: Border.all(
                color: UiConstants.kTextColor.withOpacity(0.1),
                width: SizeConfig.border1,
              ),
              gradient: UiConstants.kTextFieldGradient2,
            ),
            padding: EdgeInsets.symmetric(
              horizontal: SizeConfig.padding16,
            ),
            child: Row(
              children: [
                SizedBox(
                  width: SizeConfig.blockSizeHorizontal * 5,
                ),
                AppDateField(
                  controller: model.dayFieldController,
                  fieldWidth: SizeConfig.screenWidth * 0.08,
                  labelText: "dd",
                  maxlength: 2,
                  validate: (String val) {
                    if (val.isEmpty || val == null) {
                      model.dateInputError = "Date field cannot be empty";
                    } else if (int.tryParse(val) > 31 ||
                        int.tryParse(val) < 1) {
                      model.dateInputError = "Invalid date";
                    }
                    return null;
                  },
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      "/",
                      style: TextStyles.sourceSans.body2,
                    ),
                  ),
                ),
                AppDateField(
                  controller: model.monthFieldController,
                  fieldWidth: SizeConfig.screenWidth * 0.1,
                  labelText: "mm",
                  maxlength: 2,
                  validate: (String val) {
                    if (val.isEmpty || val == null) {
                      model.dateInputError = "Date field cannot be empty";
                    } else if (int.tryParse(val) != null &&
                        (int.tryParse(val) > 13 || int.tryParse(val) < 1)) {
                      model.dateInputError = "Invalid date";
                    }
                    return null;
                  },
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      "/",
                      style: TextStyles.sourceSans.body2,
                    ),
                  ),
                ),
                AppDateField(
                  controller: model.yearFieldController,
                  fieldWidth: SizeConfig.screenWidth * 0.12,
                  labelText: "yyyy",
                  maxlength: 4,
                  validate: (String val) {
                    if (val.isEmpty || val == null) {
                      model.dateInputError = "Date field cannot be empty";
                    } else if (int.tryParse(val) > DateTime.now().year ||
                        int.tryParse(val) < 1950) {
                      model.dateInputError = "Invalid date";
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
        ),
        if (model.dateInputError != "")
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error,
                color: Colors.red,
                size: SizeConfig.padding16,
              ),
              Container(
                padding: const EdgeInsets.all(8),
                child: Text(
                  model.dateInputError,
                  textAlign: TextAlign.start,
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
      ],
    );
  }
}
