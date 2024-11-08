import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/core/enums/view_state_enum.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/ui/architecture/base_view.dart';
import 'package:felloapp/ui/keys/keys.dart';
import 'package:felloapp/ui/pages/static/app_footer.dart';
import 'package:felloapp/ui/pages/static/app_widget.dart';
import 'package:felloapp/ui/pages/static/loader_widget.dart';
import 'package:felloapp/ui/pages/static/new_square_background.dart';
import 'package:felloapp/ui/pages/userProfile/userProfile/components/profile_appbar.dart';
import 'package:felloapp/ui/pages/userProfile/userProfile/components/profile_header.dart';
import 'package:felloapp/ui/pages/userProfile/userProfile/userProfile_viewModel.dart';
import 'package:felloapp/ui/service_elements/user_service/user_email_verification_button.dart';
import 'package:felloapp/util/haptic.dart';
import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class UserProfileDetails extends StatelessWidget {
  const UserProfileDetails({super.key});

  @override
  Widget build(BuildContext context) {
    S? locale = S.of(context);
    return BaseView<UserProfileVM>(
      onModelReady: (model) {
        model.init();
      },
      builder: (ctx, model, child) => Scaffold(
        backgroundColor: UiConstants.kBackgroundColor,
        appBar: ProfileAppBar(
          // isNewUser: model.isNewUser,
          model: model,
        ),
        body: Stack(
          children: [
            const NewSquareBackground(),
            model.state == ViewState.Busy
                ? const Center(child: FullScreenLoader())
                : ListView(
                    key: K.profileScrollableKey,
                    shrinkWrap: true,
                    physics: const ClampingScrollPhysics(),
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
    required this.locale,
    required this.model,
    Key? key,
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
                  : const SizedBox(),
              validator: (value) {
                if (value != null && value.trim().isNotEmpty) {
                  if (value.trim().length < 3) return locale.obNameRules;
                  return null;
                } else {
                  return locale.obNameAsPerPan;
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
                              : locale.obValidEmail;
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
                        hintText: model.inEditMode ? locale.obEmailHint : "",
                      ))
                : AppTextField(
                    readOnly: true,
                    isEnabled:
                        !(model.isEmailVerified || model.myEmail.isEmpty),
                    focusNode: model.emailOptionsFocusNode,
                    suffixIcon: UserEmailVerificationButton(),
                    textEditingController: model.emailController,
                    hintText: model.inEditMode ? locale.obEmailHint : "",
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
            AppDropDownField<int>(
              onChanged: (value) {
                model.gen = value;
                model.genderController!.text = model.setGenderField();
              },
              value: model.gen!,
              disabledHintText: model.genderController!.text,
              hintText: locale.obGenderHint,
              isEnabled: model.inEditMode,
              items: model.inEditMode
                  ? [
                      DropdownMenuItem<int>(
                        value: 1,
                        child: Text(
                          locale.obGenderMale,
                        ),
                      ),
                      DropdownMenuItem<int>(
                        value: 0,
                        child: Text(
                          locale.obGenderFemale,
                        ),
                      ),
                      DropdownMenuItem<int>(
                        value: -1,
                        child: Text(
                          locale.obGenderOthers,
                          style: const TextStyle(),
                        ),
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

            model.inEditMode && model.isDateEnabled
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
                          fieldWidth: SizeConfig.screenWidth! * 0.12,
                          labelText: "dd",
                          maxlength: 2,
                          validate: (val) {
                            if (val == null || val.isEmpty) {
                              model.dateInputError = locale.obDateFieldVal;
                            } else if (int.tryParse(val)! > 31 ||
                                int.tryParse(val)! < 1) {
                              model.dateInputError = locale.obInValidDate;
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
                            fieldWidth: SizeConfig.screenWidth! * 0.12,
                            labelText: "mm",
                            maxlength: 2,
                            validate: (val) {
                              if (val == null || val.isEmpty) {
                                // setState(() {
                                model.dateInputError = locale.obDateFieldVal;
                                // });
                              } else if (int.tryParse(val) != null &&
                                  (int.tryParse(val)! > 13 ||
                                      int.tryParse(val)! < 1)) {
                                // setState(() {
                                model.dateInputError = locale.obInValidDate;
                                // });
                              }
                              return null;
                            }),
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
                          fieldWidth: SizeConfig.screenWidth! * 0.16,
                          labelText: "yyyy",
                          maxlength: 4,
                          validate: (val) {
                            if (val == null || val.isEmpty) {
                              // setState(() {
                              model.dateInputError = locale.obDateFieldVal;
                              // });
                            } else if (int.tryParse(val)! >
                                    DateTime.now().year ||
                                int.tryParse(val)! < 1950) {
                              // setState(() {
                              model.dateInputError = locale.obInValidDate;
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
                          icon: const Icon(
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
                      return null;
                    },
                    suffixIcon: !model.isDateEnabled
                        ? Icon(
                            Icons.verified,
                            color: UiConstants.primaryColor,
                            size: SizeConfig.iconSize1,
                          )
                        : const SizedBox(),
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
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                ],
              ),
            SizedBox(
              height: SizeConfig.padding16,
            ),
            // if (model.isNewUser)
            //   Column(
            //     crossAxisAlignment: CrossAxisAlignment.start,
            //     children: [
            //       AppTextFieldLabel(locale.obUsernameLabel),
            //       AppTextField(
            //         hintText: locale.obUsernameHint,
            //         onTap: () {},
            //         prefixText: '@',
            //         autovalidateMode: AutovalidateMode.onUserInteraction,
            //         textEditingController: model.usernameController,
            //         isEnabled: model.inEditMode,
            //         inputFormatters: [
            //           LowerCaseTextFormatter(),
            //           FilteringTextInputFormatter.allow(
            //             RegExp(r'[A-Za-z0-9.]'),
            //           )
            //         ],
            //         validator: (val) {
            //           if (val == null || val.isEmpty)
            //             return "";
            //           else
            //             return null;
            //         },
            //         onChanged: (String value) {
            //           model.validateUsername();
            //         },
            //       ),
            //       Container(
            //         height: model.errorPadding,
            //       ),
            //       if (model.showResult().runtimeType != SizedBox)
            //         Container(
            //           margin: EdgeInsets.only(
            //             // top: SizeConfig.padding8,
            //             bottom: SizeConfig.padding24,
            //           ),
            //           child: model.showResult(),
            //         ),
            //     ],
            //   ),
            // if (!model.isNewUser)
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
                  inputFormatters: const [],
                ),
              ],
            ),
            SizedBox(
              height: SizeConfig.padding28,
            ),
            // !model.isNewUser
            //     ?
            Column(
              children: [
                // Divider(
                //   color: UiConstants.kTextColor2,
                //   thickness: 0.5,
                // ),
                // ListTile(
                //   contentPadding: EdgeInsets.symmetric(horizontal: 0),
                //   onTap: model.navigateToKycScreen,
                //   title: Text(
                //     locale.obKYCDetailsLabel,
                //     style: TextStyles.sourceSans.body3
                //         .colour(UiConstants.kTextColor2),
                //   ),
                //   trailing: Icon(Icons.arrow_forward_ios_rounded,
                //       size: SizeConfig.iconSize2,
                //       color: UiConstants.kTextColor2),
                // ),
                // ListTile(
                //   contentPadding: EdgeInsets.symmetric(horizontal: 0),
                //   onTap: model.navigateToBankDetailsScreen,
                //   title: Text(
                //     locale.obBankDetails,
                //     style: TextStyles.sourceSans.body3
                //         .colour(UiConstants.kTextColor2),
                //   ),
                //   trailing: Icon(Icons.arrow_forward_ios_rounded,
                //       size: SizeConfig.iconSize2,
                //       color: UiConstants.kTextColor2),
                // ),
                const Divider(
                  color: UiConstants.kTextColor2,
                  thickness: 0.5,
                ),
                SizedBox(
                  height: SizeConfig.padding40,
                  child: Row(
                    children: [
                      Text(
                        locale.obAppLock,
                        style: TextStyles.sourceSans.body3
                            .colour(UiConstants.kTextColor2),
                      ),
                      const Spacer(),
                      AppSwitch(
                        onToggle: model.onAppLockPreferenceChanged,
                        value: model.applock,
                        isLoading: model.isApplockLoading,
                        height: SizeConfig.screenWidth! * 0.059,
                        width: SizeConfig.screenWidth! * 0.087,
                        toggleSize: SizeConfig.screenWidth! * 0.032,
                      ),
                    ],
                  ),
                ),
                if (model.isEmailVerified)
                  SizedBox(
                    height: SizeConfig.padding40,
                    child: Row(
                      children: [
                        Text(
                          "Monthly Email Alerts",
                          style: TextStyles.sourceSans.body3
                              .colour(UiConstants.kTextColor2),
                        ),
                        const Spacer(),
                        AppSwitch(
                          onToggle: model.onFloInvoiceEmailPreferenceChanged,
                          value: model.floInvoiceEmail,
                          isLoading: model.isFloInvoiceMailLoading,
                          height: SizeConfig.screenWidth! * 0.059,
                          width: SizeConfig.screenWidth! * 0.087,
                          toggleSize: SizeConfig.screenWidth! * 0.032,
                        ),
                      ],
                    ),
                  ),
                const Divider(
                  color: UiConstants.kTextColor2,
                  thickness: 0.5,
                ),
                SizedBox(height: SizeConfig.padding6),
                InkWell(
                  onTap: () {
                    Haptic.vibrate();
                    AppState.delegate!.appState.currentAction = PageAction(
                      state: PageState.addPage,
                      page: FreshDeskHelpPageConfig,
                    );
                  },
                  child: Row(
                    // padding: EdgeInsets.symmetric(horizontal: SizeConfig.padding32),
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(locale.obNeedHelp,
                          style: TextStyles.sourceSansSB.body2
                              .colour(UiConstants.kTabBorderColor))
                    ],
                  ),
                ),
                SizedBox(height: SizeConfig.padding54),
              ],
            ),
            // : ReactivePositiveAppButton(
            //     width: SizeConfig.screenWidth,
            //     btnText: locale.btnComplete,
            //     onPressed: model.updateDetails),
            SizedBox(height: SizeConfig.padding6),
            Center(
              child: TextButton(
                key: const Key('signOutButton'),
                // key: K.singOutButtonKey,
                onPressed: model.signout,
                child: Text(
                  locale.btnSignout,
                  style: TextStyles.rajdhaniB.body1,
                ),
              ),
            ),
            const AppFooter(),
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
