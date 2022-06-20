import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/architecture/base_view.dart';
import 'package:felloapp/ui/dialogs/congratory_dialog.dart';
import 'package:felloapp/ui/dialogs/default_dialog.dart';
import 'package:felloapp/ui/dialogs/negative_dialog.dart';

import 'package:felloapp/ui/pages/others/profile/userProfile/userProfile_viewModel.dart';
import 'package:felloapp/ui/pages/static/app_widget.dart';
import 'package:felloapp/ui/pages/static/new_square_background.dart';
import 'package:felloapp/ui/service_elements/user_service/profile_image.dart';
import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_switch/flutter_switch.dart';

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
              child: GestureDetector(
                onTap: !model.inEditMode
                    ? model.enableEdit
                    : () {
                        if (!model.isUpdaingUserDetails) {
                          FocusScope.of(context).unfocus();
                          model.updateDetails();
                        }
                      },
                // onTap: () {
                //   showDialog(
                //     context: context,
                //     builder: (ctx) => AppCongratulatoryDialog(
                //       title: 'Congratulations!',
                //       description:
                //           'Your email address abcxyz@gmail.com has been verified.',
                //       buttonText: 'Grate!',
                //       confirmAction: () {
                //         // _isLoading = true;
                //         // setState(() {});
                //         // baseProvider.withdrawFlowStackCount = 1;
                //         // widget.onAmountConfirmed({
                //         //   'withdrawal_quantity':
                //         //       baseProvider.activeGoldWithdrawalQuantity,
                //         // });

                //         return true;
                //       },
                //     ),
                //   );
                // },
                child: !model.inEditMode
                    ? Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.edit_outlined,
                            size: SizeConfig.iconSize2,
                            color: UiConstants.kTextColor,
                          ),
                          SizedBox(width: SizeConfig.padding8),
                          Text(
                            'EDIT',
                            style: TextStyles.sourceSansSB.body2,
                          ),
                        ],
                      )
                    : Center(
                        child: Text(
                          'DONE',
                          style: TextStyles.sourceSansSB.body2.colour(
                            UiConstants.kTabBorderColor,
                          ),
                        ),
                      ),
              ),
            ),
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
        padding: EdgeInsets.symmetric(horizontal: SizeConfig.padding32),
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
              validator: (value) {
                return (value != null && value.isNotEmpty)
                    ? null
                    : 'Please enter your name';
              },
            ),
            AppTextFieldLabel(
              locale.obEmailLabel,
            ),
            AppTextField(
              isEnabled: false,
              textEditingController: model.emailController,
              validator: (val) {
                return null;
              },
              inputFormatters: [],
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
            AppTextFieldLabel(
              locale.obDobLabel,
            ),
            AppDatePickerField(
              isEnabled: model.inEditMode,
              child: Text(
                "${model.dobController.text}",
                style: TextStyles.body2.colour(
                  model.inEditMode
                      ? UiConstants.kTextColor
                      : UiConstants.kTextFieldTextColor,
                ),
              ),
              onTap: model.inEditMode ? model.showAndroidDatePicker : null,
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
                  model.isApplockLoading
                      ? Container(
                          margin: EdgeInsets.only(right: SizeConfig.padding12),
                          padding: EdgeInsets.all(SizeConfig.padding2),
                          height: SizeConfig.title3,
                          width: SizeConfig.title3,
                          child: CircularProgressIndicator(),
                        )
                      : FlutterSwitch(
                          onToggle: (val) =>
                              model.onAppLockPreferenceChanged(val),
                          value: model.applock,
                          height: SizeConfig.screenWidth * 0.0611, // 22
                          width: SizeConfig.screenWidth * 0.0889, // 32
                          padding: SizeConfig.padding2,
                          activeColor: UiConstants.kSwitchColor,
                          inactiveColor: UiConstants.kSwitchColor,
                          activeToggleColor: UiConstants.kTabBorderColor,
                          switchBorder: Border.all(
                            color: UiConstants.kSecondaryBackgroundColor,
                            width: SizeConfig.border4,
                          ),
                          toggleSize: SizeConfig.screenWidth * 0.0333, // 12
                        )
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
                  model.isTambolaNotificationLoading
                      ? Container(
                          margin: EdgeInsets.only(right: SizeConfig.padding12),
                          padding: EdgeInsets.all(SizeConfig.padding2),
                          height: SizeConfig.title3,
                          width: SizeConfig.title3,
                          child: CircularProgressIndicator(),
                        )
                      : FlutterSwitch(
                          onToggle: (val) =>
                              model.onTambolaNotificationPreferenceChanged(val),
                          value: model.tambolaNotification,
                          height: SizeConfig.screenWidth * 0.0611, // 22
                          width: SizeConfig.screenWidth * 0.0889, // 32
                          padding: SizeConfig.padding2,
                          activeColor: UiConstants.kSwitchColor,
                          inactiveColor: UiConstants.kSwitchColor,
                          activeToggleColor: UiConstants.kTabBorderColor,
                          switchBorder: Border.all(
                            color: UiConstants.kSecondaryBackgroundColor,
                            width: SizeConfig.border4,
                          ),
                          toggleSize: SizeConfig.screenWidth * 0.0333, // 12
                        )
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
          _buildProfileImage(),
          SizedBox(height: SizeConfig.padding6),
          _buildUserName(),
          Spacer(),
        ],
      ),
    );
  }

  Stack _buildProfileImage() {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: SizeConfig.screenWidth * 0.4667,
          height: SizeConfig.screenWidth * 0.4667,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: UiConstants.kProfileBorderOutterColor,
              width: SizeConfig.border0,
            ),
          ),
        ),
        Positioned(
          bottom: (SizeConfig.screenWidth * 0.4667) * 0.25, // 168 * 0.25
          left: 0,
          child: Container(
            height: SizeConfig.padding6,
            width: SizeConfig.padding6,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: UiConstants.kTextColor,
            ),
          ),
        ),
        Container(
          width: SizeConfig.screenWidth * 0.3944, // 142
          height: SizeConfig.screenWidth * 0.3944,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: UiConstants.kTextColor.withOpacity(0.2),
              width: SizeConfig.border2,
            ),
          ),
        ),
        Positioned(
          bottom: SizeConfig.screenWidth * 0.3333, //120
          right: (SizeConfig.screenWidth * 0.0639), // 23
          child: Container(
            height: SizeConfig.padding6,
            width: SizeConfig.padding6,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: UiConstants.kTextColor,
            ),
          ),
        ),
        Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: SizeConfig.screenWidth * 0.3111, // 112
              height: SizeConfig.screenWidth * 0.3111,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: UiConstants.kProfileBorderColor,
                  width: SizeConfig.border1,
                ),
              ),
              padding: EdgeInsets.all(
                SizeConfig.padding4,
              ),
              child: ProfileImageSE(
                radius: SizeConfig.screenWidth * 0.25,
              ),
            ),
            Positioned(
              bottom: SizeConfig.padding6, // 5
              right: SizeConfig.padding12, // 10
              child: InkWell(
                onTap: model.handleDPOperation,
                child: Container(
                  height: SizeConfig.screenWidth * 0.0556, // 20
                  width: SizeConfig.screenWidth * 0.0556, // 20
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: UiConstants.kTextColor,
                  ),
                  child: Icon(
                    Icons.camera_alt_rounded,
                    size: SizeConfig.iconSize2,
                    color: UiConstants.kTabBorderColor,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
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
