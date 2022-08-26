import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/enums/user_service_enum.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/architecture/base_view.dart';
import 'package:felloapp/ui/modals_sheets/recharge_modal_sheet.dart';
import 'package:felloapp/ui/pages/login/screens/name_input/name_input_view.dart';

import 'package:felloapp/ui/pages/others/profile/userProfile/userProfile_viewModel.dart';
import 'package:felloapp/ui/pages/static/app_widget.dart';
import 'package:felloapp/ui/pages/static/new_square_background.dart';
import 'package:felloapp/ui/pages/static/profile_image.dart';
import 'package:felloapp/ui/service_elements/user_service/profile_image.dart';
import 'package:felloapp/ui/service_elements/user_service/user_email_verification_button.dart';
import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:property_change_notifier/property_change_notifier.dart';

class UserProfileDetails extends StatelessWidget {
  const UserProfileDetails({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    S locale = S.of(context);
    return BaseView<UserProfileVM>(
      onModelReady: (model) {
        model.init();
      },
      builder: (ctx, model, child) => Scaffold(
        appBar: AppBar(
          backgroundColor: UiConstants.kSecondaryBackgroundColor,
          elevation: 0.0,
          title: Text(
            'My Profile',
            style: TextStyles.rajdhaniSB.title4,
          ),
          centerTitle: false,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: UiConstants.kTextColor,
            ),
            onPressed: () => AppState.backButtonDispatcher.didPopRoute(),
          ),
          actions: [
            Padding(
              padding: EdgeInsets.only(right: SizeConfig.padding16),
              child: !model.inEditMode
                  ? TextButton.icon(
                      icon: Icon(Icons.edit_outlined,
                          size: SizeConfig.iconSize2,
                          color: UiConstants.kTextColor),
                      // SizedBox(width: SizeConfig.padding8),
                      label: Text(
                        'EDIT',
                        style: TextStyles.sourceSansSB.body2,
                      ),
                      onPressed: () => model.enableEdit(),
                    )
                  : TextButton(
                      onPressed: () {
                        if (!model.isUpdaingUserDetails) {
                          FocusScope.of(context).unfocus();
                          model.updateDetails();
                        }
                      },
                      child: Text(
                        'DONE',
                        style: TextStyles.sourceSansSB.body2.colour(
                          UiConstants.kTabBorderColor,
                        ),
                      ),
                    ),
              // ),
            ),
            // IconButton(
            //   icon: Icon(
            //     Icons.money,
            //     color: UiConstants.kTextColor,
            //   ),
            //   onPressed: () {
            //     BaseUtil.openModalBottomSheet(
            //       addToScreenStack: true,
            //       enableDrag: false,
            //       hapticVibrate: true,
            //       isBarrierDismissable: false,
            //       backgroundColor: Colors.transparent,
            //       isScrollControlled: true,
            //       content: RechargeModalSheet(),
            //     );
            //   },
            // ),
          ],
        ),
        backgroundColor: UiConstants.kBackgroundColor,
        body: Stack(
          children: [
            NewSquareBackground(),
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  ProfileHeader(model: model),
                  SizedBox(height: SizeConfig.padding12),
                  UserProfileForm(locale: locale, model: model),
                ],
              ),
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
              isEnabled: model.inEditMode,
              inputFormatters: [
                FilteringTextInputFormatter.allow(
                  RegExp(r'[a-zA-Z ]'),
                ),
              ],
              // suffix: SizedBox(),
              validator: (value) {
                if (value != null && value.isNotEmpty) {
                  model.hasInputError = false;
                  return null;
                } else {
                  model.hasInputError = true;
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
            // EmailField(model: model),
            InkWell(
              onTap: () => model.verifyEmail(),
              child: AppTextField(
                isEnabled: false,
                textEditingController: model.emailController,
                validator: (val) {
                  return null;
                },
                suffixIcon: UserEmailVerificationButton(),
                // suffixText: 'Verified',
                inputFormatters: [],
              ),
            ),
            SizedBox(
              height: SizeConfig.padding16,
            ),
            AppTextFieldLabel(
              locale.obGenderLabel,
            ),
            AppDropDownField(
              onChanged: (value) {
                model.gen = value;
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
                    height: SizeConfig.screenWidth * 0.1377,
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
                : AppDatePickerField(
                    isEnabled: false,
                    child: Text(
                      "${model.dobController.text}",
                      style: TextStyles.body2.colour(
                        model.inEditMode
                            ? UiConstants.kTextColor
                            : UiConstants.kTextFieldTextColor,
                      ),
                    ),
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
            SizedBox(height: SizeConfig.padding40),
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
                    onToggle: (val) => model.onAppLockPreferenceChanged(val),
                    value: model.applock,
                    isLoading: model.isApplockLoading,
                    height: SizeConfig.screenWidth * 0.059,
                    width: SizeConfig.screenWidth * 0.087,
                    toggleSize: SizeConfig.screenWidth * 0.032,
                  ),
                ],
              ),
            ),
            SizedBox(height: SizeConfig.padding16),
            Container(
              height: SizeConfig.padding40,
              child: Row(
                children: [
                  Text(
                    "Tambola Notifications",
                    style: TextStyles.sourceSans.body3
                        .colour(UiConstants.kTextColor2),
                  ),
                  Spacer(),
                  AppSwitch(
                    onToggle: (val) =>
                        model.onTambolaNotificationPreferenceChanged(val),
                    value: model.tambolaNotification,
                    isLoading: model.isTambolaNotificationLoading,
                    height: SizeConfig.screenWidth * 0.059,
                    width: SizeConfig.screenWidth * 0.087,
                    toggleSize: SizeConfig.screenWidth * 0.032,
                  ),
                ],
              ),
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
            SizedBox(height: SizeConfig.padding64),
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

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({
    Key key,
    @required this.model,
  }) : super(key: key);

  final UserProfileVM model;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: SizeConfig.screenWidth * 0.7000,
      width: SizeConfig.screenWidth,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top,
      ),
      decoration: BoxDecoration(
        color: UiConstants.kSecondaryBackgroundColor,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(SizeConfig.roundness24),
          bottomRight: Radius.circular(SizeConfig.roundness24),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          // _buildProfileImage(),
          NewProfileImage(
            image: ProfileImageSE(
              radius: SizeConfig.screenWidth * 0.25,
            ),
            onShowImagePicker: model.handleDPOperation,
          ),
          SizedBox(height: SizeConfig.padding6),
          _buildUserName(),
          Spacer(),
        ],
      ),
    );
  }

  _buildUserName() {
    UserService userService = locator<UserService>();
    return Column(
      children: [
        Text(
          model.nameController.text,
          style: TextStyles.rajdhaniSB.title4,
        ),
        Text(
          '@${userService.diplayUsername(model.myUsername)}',
          style: TextStyles.sourceSans.body3.colour(UiConstants.kTextColor2),
        ),
      ],
    );
  }
}
