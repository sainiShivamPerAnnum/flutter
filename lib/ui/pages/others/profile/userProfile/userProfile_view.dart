import 'dart:developer';

import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/core/enums/view_state_enum.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/ui/architecture/base_view.dart';
import 'package:felloapp/ui/pages/hometabs/save/save_view.dart';
import 'package:felloapp/ui/pages/others/profile/userProfile/components/profile_appbar.dart';
import 'package:felloapp/ui/pages/others/profile/userProfile/components/profile_header.dart';
import 'package:felloapp/ui/pages/others/profile/userProfile/userProfile_viewModel.dart';
import 'package:felloapp/ui/pages/static/app_widget.dart';
import 'package:felloapp/ui/pages/static/loader_widget.dart';
import 'package:felloapp/ui/pages/static/new_square_background.dart';
import 'package:felloapp/ui/service_elements/gold_sell_card/sell_card_components.dart';
import 'package:felloapp/ui/service_elements/user_service/user_email_verification_button.dart';
import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class UserProfileDetails extends StatelessWidget {
  const UserProfileDetails({Key key, this.isNewUser = false}) : super(key: key);
  final bool isNewUser;
  @override
  Widget build(BuildContext context) {
    S locale = S.of(context);
    log(isNewUser.toString());
    return BaseView<UserProfileVM>(
      onModelReady: (model) {
        model.init(isNewUser);
      },
      builder: (ctx, model, child) => Scaffold(
        backgroundColor: UiConstants.kBackgroundColor,
        appBar: ProfileAppBar(
          isNewUser: model.isNewUser,
          model: model,
        ),
        body: Stack(
          children: [
            NewSquareBackground(),
            model.state == ViewState.Busy
                ? Center(child: FullScreenLoader())
                : ListView(
                    shrinkWrap: true,
                    physics: ClampingScrollPhysics(),
                    children: [
                      ProfileHeader(model: model),
                      UserProfileForm(locale: locale, model: model),
                    ],
                  ),
          ],
        ),
      ),
    );
  }
}

class UserProfileForm extends StatelessWidget {
  const UserProfileForm({
    Key key,
    @required this.locale,
    @required this.model,
  }) : super(key: key);

  final S locale;
  final UserProfileVM model;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: model.formKey,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: SizeConfig.padding40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            AppTextFieldLabel(
              locale.obNameLabel,
            ),
            AppTextField(
              textEditingController: model.nameController,
              isEnabled: model.inEditMode && model.isNameEnabled,
              focusNode: model.nameFocusNode,
              textCapitalization: TextCapitalization.words,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              inputFormatters: [
                FilteringTextInputFormatter.allow(
                  RegExp(r'[a-zA-Z ]'),
                ),
              ],
              suffixIcon: !model.isNameEnabled
                  ? Icon(
                      Icons.verified,
                      color: UiConstants.primaryColor,
                      size: SizeConfig.iconSize1,
                    )
                  : SizedBox(),
              validator: (value) {
                if (value != null && value.isNotEmpty) {
                  // model.hasInputError = false;
                  return null;
                } else {
                  // model.hasInputError = true;
                  return 'Please enter your name';
                }
              },
            ),
            SizedBox(
              height: SizeConfig.padding16,
            ),
            AppTextFieldLabel(
              locale.obEmailLabel,
            ),
            model.inEditMode && !model.isEmailVerified
                ? (model.isEmailEnabled
                    ? AppTextField(
                        textEditingController: model.emailController,
                        keyboardType: TextInputType.emailAddress,
                        autoFocus: true,
                        isEnabled: true,
                        focusNode: model.emailFocusNode,
                        hintText: locale.obEmailHint,
                        // suffixIcon: UserEmailVerificationButton(),
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) {
                          return (value != null &&
                                  value.isNotEmpty &&
                                  model.emailRegex.hasMatch(value))
                              ? null
                              : 'Please enter a valid email';
                        },
                      )
                    : AppTextField(
                        readOnly: true,
                        isEnabled: true,
                        validator: (va) {
                          return null;
                        },
                        onTap: model.isContinuedWithGoogle
                            ? () {}
                            : model.showEmailOptions,
                        focusNode: model.emailOptionsFocusNode,
                        // suffixIcon: UserEmailVerificationButton(),
                        textEditingController: model.emailController,
                        hintText: model.inEditMode ? "Enter email" : "",
                      ))
                : AppTextField(
                    readOnly: true,
                    isEnabled: model.isEmailVerified ? false : true,
                    validator: (va) {
                      return null;
                    },
                    focusNode: model.emailOptionsFocusNode,
                    suffixIcon: UserEmailVerificationButton(),
                    textEditingController: model.emailController,
                    hintText: model.inEditMode ? "Enter email" : "",
                  ),

            // InkWell(
            //   onTap: () => model.verifyEmail(),
            //   child: AppTextField(
            //     isEnabled: false,
            //     textEditingController: model.emailController,
            //     validator: (val) {
            //       return null;
            //     },
            //     suffixIcon: UserEmailVerificationButton(),
            //     // suffixText: 'Verified',
            //     inputFormatters: [],
            //   ),
            // ),
            SizedBox(
              height: SizeConfig.padding16,
            ),
            AppTextFieldLabel(
              locale.obGenderLabel,
            ),
            AppDropDownField(
              onChanged: (value) {
                model.gen = value;
                model.genderController.text = model.setGenderField();
              },
              value: model.gen,
              disabledHintText: model.genderController.text,
              hintText: locale.obGenderHint,
              isEnabled: model.inEditMode,
              items: model.inEditMode
                  ? [
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
                        value: -1,
                      ),
                    ]
                  : [],
            ),
            SizedBox(
              height: SizeConfig.padding16,
            ),
            AppTextFieldLabel(
              locale.obDobLabel,
            ),
            // AppDatePickerField(
            //   isEnabled: model.inEditMode,
            //   child: Text(
            //     "${model.dobController.text}",
            //     style: TextStyles.body2.colour(
            //       model.inEditMode
            //           ? UiConstants.kTextColor
            //           : UiConstants.kTextFieldTextColor,
            //     ),
            //   ),
            //   onTap: model.inEditMode ? model.showAndroidDatePicker : null,
            // ),
            model.inEditMode
                ? Container(
                    width: double.infinity,
                    // height: SizeConfig.screenWidth * 0.1377,
                    decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.circular(SizeConfig.roundness5),
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
                          controller: model.dateFieldController,
                          fieldWidth: SizeConfig.screenWidth * 0.12,
                          labelText: "dd",
                          maxlength: 2,
                          validate: (String val) {
                            if (val.isEmpty || val == null) {
                              // setState(() {
                              model.dateInputError =
                                  "Date field cannot be empty";
                              // });
                            } else if (int.tryParse(val) > 31 ||
                                int.tryParse(val) < 1) {
                              // setState(() {
                              model.dateInputError = "Invalid date";
                              // });
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
                          fieldWidth: SizeConfig.screenWidth * 0.12,
                          labelText: "mm",
                          maxlength: 2,
                          validate: (String val) {
                            if (val.isEmpty || val == null) {
                              // setState(() {
                              model.dateInputError =
                                  "Date field cannot be empty";
                              // });
                            } else if (int.tryParse(val) != null &&
                                (int.tryParse(val) > 13 ||
                                    int.tryParse(val) < 1)) {
                              // setState(() {
                              model.dateInputError = "Invalid date";
                              // });
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
                          fieldWidth: SizeConfig.screenWidth * 0.16,
                          labelText: "yyyy",
                          maxlength: 4,
                          validate: (String val) {
                            if (val.isEmpty || val == null) {
                              // setState(() {
                              model.dateInputError =
                                  "Date field cannot be empty";
                              // });
                            } else if (int.tryParse(val) >
                                    DateTime.now().year ||
                                int.tryParse(val) < 1950) {
                              // setState(() {
                              model.dateInputError = "Invalid date";
                              // });
                            }
                            return null;
                          },
                        ),
                        SizedBox(
                          height: SizeConfig.padding10,
                        ),
                        IconButton(
                          onPressed: model.showAndroidDatePicker,
                          icon: Icon(
                            Icons.calendar_today,
                            size: 20,
                            color: UiConstants.primaryColor,
                          ),
                        )
                      ],
                    ),
                  )
                : AppTextField(
                    isEnabled: false,
                    textEditingController: model.dobController,
                    validator: (val) {
                      return "";
                    },
                    // child: Text(
                    //   "${model.dobController.text}",
                    //   style: TextStyles.body2.colour(
                    //     model.inEditMode
                    //         ? UiConstants.kTextColor
                    //         : UiConstants.kTextFieldTextColor,
                    //   ),
                    // ),
                    onTap: null,
                  ),
            if (model.inEditMode && model.dateInputError != "")
              Row(
                children: [
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
            SizedBox(
              height: SizeConfig.padding16,
            ),
            if (model.isNewUser)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppTextFieldLabel("Username"),
                  AppTextField(
                    hintText: 'Your username',
                    onTap: () {},
                    prefixText: '@',
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    textEditingController: model.usernameController,
                    isEnabled: model.inEditMode,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                        RegExp(r'[a-z0-9.]'),
                      )
                    ],
                    validator: (val) {
                      if (val == null || val.isEmpty)
                        return "";
                      else
                        return null;
                    },
                    onChanged: (String value) {
                      model.validateUsername();
                    },
                  ),
                  Container(
                    height: model.errorPadding,
                  ),
                  if (model.showResult().runtimeType != SizedBox)
                    Container(
                      margin: EdgeInsets.only(
                        // top: SizeConfig.padding8,
                        bottom: SizeConfig.padding24,
                      ),
                      child: model.showResult(),
                    ),
                ],
              ),
            if (!model.isNewUser)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppTextFieldLabel(
                    locale.obMobileLabel,
                  ),
                  AppTextField(
                    isEnabled: false,
                    textEditingController: model.mobileController,
                    validator: (val) {
                      return null;
                    },
                    inputFormatters: [],
                  ),
                ],
              ),
            SizedBox(
              height: SizeConfig.padding28,
            ),

            !model.isNewUser
                ? Column(
                    children: [
                      Divider(
                        color: UiConstants.kTextColor2,
                        thickness: 0.5,
                      ),
                      ListTile(
                        contentPadding: EdgeInsets.symmetric(horizontal: 0),
                        onTap: model.navigateToKycScreen,
                        title: Text(
                          "Your KYC Details",
                          style: TextStyles.sourceSans.body3
                              .colour(UiConstants.kTextColor2),
                        ),
                        trailing: Icon(Icons.arrow_forward_ios_rounded,
                            size: SizeConfig.iconSize2,
                            color: UiConstants.kTextColor2),
                      ),
                      ListTile(
                        contentPadding: EdgeInsets.symmetric(horizontal: 0),
                        onTap: model.navigateToBankDetailsScreen,
                        title: Text(
                          "Your Bank Account Details",
                          style: TextStyles.sourceSans.body3
                              .colour(UiConstants.kTextColor2),
                        ),
                        trailing: Icon(Icons.arrow_forward_ios_rounded,
                            size: SizeConfig.iconSize2,
                            color: UiConstants.kTextColor2),
                      ),
                      Divider(
                        color: UiConstants.kTextColor2,
                        thickness: 0.5,
                      ),
                      Container(
                        height: SizeConfig.padding40,
                        child: Row(
                          children: [
                            Text(
                              "App Lock",
                              style: TextStyles.sourceSans.body3
                                  .colour(UiConstants.kTextColor2),
                            ),
                            Spacer(),
                            AppSwitch(
                              onToggle: (val) =>
                                  model.onAppLockPreferenceChanged(val),
                              value: model.applock,
                              isLoading: model.isApplockLoading,
                              height: SizeConfig.screenWidth * 0.059,
                              width: SizeConfig.screenWidth * 0.087,
                              toggleSize: SizeConfig.screenWidth * 0.032,
                            ),
                          ],
                        ),
                      ),
                      Divider(
                        color: UiConstants.kTextColor2,
                        thickness: 0.5,
                      ),
                      SizedBox(height: SizeConfig.padding54),
                      Center(
                        child: TextButton(
                          child: Text(
                            'SIGN OUT',
                            style: TextStyles.rajdhaniB.body1,
                          ),
                          onPressed: model.signout,
                        ),
                      ),
                    ],
                  )
                : ReactivePositiveAppButton(
                    width: SizeConfig.screenWidth,
                    btnText: "Complete",
                    onPressed: model.updateDetails),
            AppFooter(),
            SizedBox(height: SizeConfig.padding28),
          ],
        ),
      ),
    );
  }
}

// class EmailField extends StatelessWidget {
//   const EmailField({
//     Key key,
//     @required this.model,
//   }) : super(key: key);

//   final UserProfileVM model;

//   @override
//   Widget build(BuildContext context) {
//     return PropertyChangeConsumer<UserService, UserServiceProperties>(
//       properties: [UserServiceProperties.myEmail],
//       builder: (context, userService, property) {
//         // model.emailController.text = userService.baseUser.email;
//         return
//       },
//     );
//   }
// }
