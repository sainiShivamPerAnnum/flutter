//Project Imports
//Flutter & Dart Imports
import 'dart:ui';

import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/ui/architecture/base_view.dart';
import 'package:felloapp/ui/pages/login/screens/name_input_screen.dart';
import 'package:felloapp/ui/pages/others/profile/userProfile/userProfile_viewModel.dart';
import 'package:felloapp/ui/pages/static/fello_appbar.dart';
import 'package:felloapp/ui/pages/static/home_background.dart';
import 'package:felloapp/ui/service_elements/user_service/profile_image.dart';
import 'package:felloapp/ui/widgets/buttons/fello_button/large_button.dart';
import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class UserProfileDetails extends StatefulWidget {
  @override
  _UserProfileDetailsState createState() => _UserProfileDetailsState();
}

class _UserProfileDetailsState extends State<UserProfileDetails> {
  @override
  Widget build(BuildContext context) {
    S locale = S.of(context);
    return BaseView<UserProfileVM>(
      onModelReady: (model) {
        model.init();
      },
      builder: (ctx, model, child) => Scaffold(
        backgroundColor: UiConstants.primaryColor,
        body: HomeBackground(
          child: Column(
            children: [
              FelloAppBar(
                leading: FelloAppBarBackButton(),
                title: locale.abMyProfile,
              ),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(SizeConfig.roundness40),
                      topRight: Radius.circular(SizeConfig.roundness40),
                    ),
                  ),
                  width: SizeConfig.screenWidth,
                  padding: EdgeInsets.only(
                    left: SizeConfig.pageHorizontalMargins,
                    right: SizeConfig.pageHorizontalMargins,
                  ),
                  child: SingleChildScrollView(
                    child: Form(
                      key: model.formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: SizeConfig.screenWidth * 0.31,
                            height: SizeConfig.screenWidth * 0.33,
                            margin: EdgeInsets.only(
                              top: SizeConfig.pageHorizontalMargins,
                              bottom: SizeConfig.padding8,
                            ),
                            child: Stack(
                              children: [
                                Container(
                                  width: SizeConfig.screenWidth * 0.31,
                                  height: SizeConfig.screenWidth * 0.31,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        UiConstants.primaryColor,
                                        Colors.white,
                                      ],
                                    ),
                                  ),
                                  padding: EdgeInsets.all(3),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle,
                                    ),
                                    padding:
                                        EdgeInsets.all(SizeConfig.padding6),
                                    child: ProfileImageSE(
                                      radius: SizeConfig.screenWidth * 0.25,
                                    ),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.bottomCenter,
                                  child: InkWell(
                                    onTap: model.handleDPOperation,
                                    child: Container(
                                      height: SizeConfig.screenWidth * 0.096,
                                      width: SizeConfig.screenWidth * 0.096,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: UiConstants.primaryColor,
                                        border: Border.all(
                                            width: SizeConfig.padding4,
                                            color: Colors.white),
                                      ),
                                      child: Icon(
                                        Icons.camera_alt_rounded,
                                        size: SizeConfig.screenWidth * 0.05,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          FittedBox(
                            child: Text(
                              model.myname,
                              style: TextStyles.title4.bold,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(SizeConfig.padding8),
                            child: FittedBox(
                              child: Text(
                                "@${model.myUsername}",
                                style: TextStyles.body3.colour(Colors.grey),
                              ),
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextFieldLabel(locale.obNameLabel),
                              TextFormField(
                                enabled: model.inEditMode,
                                controller: model.nameController,
                              ),
                              TextFieldLabel(locale.obDobLabel),
                              !model.inEditMode
                                  ? TextFormField(
                                      enabled: model.inEditMode,
                                      controller: model.dobController,
                                    )
                                  : Container(
                                      padding: EdgeInsets.all(5),
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: model.dateInputError != ""
                                              ? Colors.red
                                              : UiConstants.primaryColor
                                                  .withOpacity(0.3),
                                        ),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Row(
                                        children: [
                                          SizedBox(
                                            width:
                                                SizeConfig.blockSizeHorizontal *
                                                    5,
                                          ),
                                          DateField(
                                            controller:
                                                model.dateFieldController,
                                            fieldWidth:
                                                SizeConfig.screenWidth * 0.12,
                                            labelText: "dd",
                                            maxlength: 2,
                                            validate: (String val) {
                                              if (val.isEmpty || val == null) {
                                                setState(() {
                                                  model.dateInputError =
                                                      "Date field cannot be empty";
                                                });
                                              } else if (int.tryParse(val) >
                                                      31 ||
                                                  int.tryParse(val) < 1) {
                                                setState(() {
                                                  model.dateInputError =
                                                      "Invalid date";
                                                });
                                              }
                                              return null;
                                            },
                                          ),
                                          Expanded(
                                              child: Center(child: Text("/"))),
                                          DateField(
                                            controller:
                                                model.monthFieldController,
                                            fieldWidth:
                                                SizeConfig.screenWidth * 0.12,
                                            labelText: "mm",
                                            maxlength: 2,
                                            validate: (String val) {
                                              if (val.isEmpty || val == null) {
                                                setState(() {
                                                  model.dateInputError =
                                                      "Date field cannot be empty";
                                                });
                                              } else if (int.tryParse(val) !=
                                                      null &&
                                                  (int.tryParse(val) > 13 ||
                                                      int.tryParse(val) < 0)) {
                                                setState(() {
                                                  model.dateInputError =
                                                      "Invalid date";
                                                });
                                              }
                                              return null;
                                            },
                                          ),
                                          Expanded(
                                              child: Center(child: Text("/"))),
                                          DateField(
                                            controller:
                                                model.yearFieldController,
                                            fieldWidth:
                                                SizeConfig.screenWidth * 0.16,
                                            labelText: "yyyy",
                                            maxlength: 4,
                                            validate: (String val) {
                                              if (val.isEmpty || val == null) {
                                                setState(() {
                                                  model.dateInputError =
                                                      "Date field cannot be empty";
                                                });
                                              } else if (int.tryParse(val) >
                                                      DateTime.now().year ||
                                                  int.tryParse(val) < 1950) {
                                                setState(() {
                                                  model.dateInputError =
                                                      "Invalid date";
                                                });
                                              }
                                              return null;
                                            },
                                          ),
                                          SizedBox(
                                            width: 16,
                                          ),
                                          IconButton(
                                            onPressed:
                                                model.showAndroidDatePicker,
                                            icon: Icon(
                                              Icons.calendar_today,
                                              size: 20,
                                              color: UiConstants.primaryColor,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                              TextFieldLabel(locale.obGenderLabel),
                              !model.inEditMode
                                  ? TextFormField(
                                      enabled: false,
                                      controller: model.genderController,
                                    )
                                  : Container(
                                      padding:
                                          EdgeInsets.all(SizeConfig.padding4),
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: UiConstants.primaryColor
                                              .withOpacity(0.3),
                                        ),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Row(
                                        children: [
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Expanded(
                                            child: DropdownButtonHideUnderline(
                                              child: DropdownButton(
                                                  iconEnabledColor:
                                                      UiConstants.primaryColor,
                                                  value: model.gen,
                                                  hint:
                                                      Text(locale.obGenderHint),
                                                  items: [
                                                    DropdownMenuItem(
                                                      child: Text(
                                                        locale.obGenderMale,
                                                      ),
                                                      value: 1,
                                                    ),
                                                    DropdownMenuItem(
                                                      child: Text(
                                                        locale.obGenderFemale,
                                                      ),
                                                      value: 0,
                                                    ),
                                                    DropdownMenuItem(
                                                        child: Text(
                                                          locale.obGenderOthers,
                                                          style: TextStyle(),
                                                        ),
                                                        value: -1),
                                                  ],
                                                  onChanged: (value) {
                                                    model.gen = value;
                                                    setState(() {});
                                                  }),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                              TextFieldLabel(locale.obEmailLabel),
                              TextFormField(
                                enabled: false,
                                decoration: InputDecoration(
                                  suffixIcon: model.isEmailVerified
                                      ? Icon(
                                          Icons.verified,
                                          color: UiConstants.primaryColor,
                                        )
                                      : SizedBox(),
                                ),
                                controller: model.emailController,
                              ),
                              if (!model.isEmailVerified)
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: InkWell(
                                          child: Text(
                                            "Verify",
                                            style: TextStyles.body3.colour(
                                                UiConstants.primaryColor),
                                          ),
                                          onTap: () {
                                            AppState.delegate.appState
                                                    .currentAction =
                                                PageAction(
                                                    state: PageState.addPage,
                                                    page:
                                                        VerifyEmailPageConfig);
                                          }),
                                    )
                                  ],
                                ),
                              TextFieldLabel(locale.obMobileLabel),
                              TextFormField(
                                enabled: false,
                                controller: model.mobileController,
                              ),
                            ],
                          ),
                          SizedBox(height: SizeConfig.padding24),
                          Container(
                            width: SizeConfig.screenWidth,
                            child: FelloButtonLg(
                              child: model.isUpdaingUserDetails
                                  ? SpinKitThreeBounce(
                                      color: Colors.white,
                                      size: 20,
                                    )
                                  : Text(
                                      model.inEditMode
                                          ? locale.btnSave
                                          : locale.btnEdit,
                                      style: TextStyles.body2
                                          .colour(Colors.white)
                                          .bold,
                                    ),
                              onPressed: () {
                                if (model.inEditMode) {
                                  FocusScope.of(context).unfocus();
                                  model.updateDetails();
                                } else {
                                  model.enableEdit();
                                }
                              },
                            ),
                          ),
                          SizedBox(height: 24),
                          TextButton(
                            onPressed: model.signout,
                            child: Text(
                              locale.signout.toUpperCase(),
                              style: TextStyles.body1
                                  .colour(Colors.red[200])
                                  .light
                                  .letterSpace(2),
                            ),
                          ),
                          SizedBox(height: 24),
                        ],
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
