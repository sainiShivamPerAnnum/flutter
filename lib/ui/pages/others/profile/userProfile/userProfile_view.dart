//Project Imports
//Flutter & Dart Imports
import 'dart:ui';

import 'package:felloapp/ui/architecture/base_view.dart';
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
    return BaseView<UserProfileViewModel>(
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
                title: locale.profileTitle,
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
                              top: SizeConfig.globalMargin,
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
                                        EdgeInsets.all(SizeConfig.padding12),
                                    child: ProfileImage(
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
                          SizedBox(height: 8),
                          FittedBox(
                            child: Text(
                              "@${model.myUsername}",
                              style: TextStyles.body3.colour(Colors.grey),
                            ),
                          ),
                          SizedBox(height: 24),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Name as per PAN",
                                style: TextStyles.body3,
                              ),
                              SizedBox(height: 6),
                              TextFormField(
                                //initialValue: model.myname,
                                enabled: model.inEditMode,
                                controller: model.nameController,
                              ),
                            ],
                          ),
                          SizedBox(height: 16),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Date of Birth",
                                style: TextStyles.body3,
                              ),
                              SizedBox(height: 6),
                              TextFormField(
                                //initialValue: model.myAge,
                                enabled: model.inEditMode,
                                decoration: InputDecoration(
                                  suffixIcon: Icon(Icons.unfold_more_rounded),
                                ),
                                controller: model.dobController,
                              ),
                            ],
                          ),
                          SizedBox(height: 16),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Gender",
                                style: TextStyles.body3,
                              ),
                              SizedBox(height: 6),
                              TextFormField(
                                //initialValue: model.myGender,
                                enabled: model.inEditMode,
                                decoration: InputDecoration(
                                  suffixIcon: Icon(Icons.expand_more_rounded),
                                ),
                                controller: model.genderController,
                              ),
                            ],
                          ),
                          SizedBox(height: 16),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Email",
                                style: TextStyles.body3,
                              ),
                              SizedBox(height: 6),
                              TextFormField(
                                //initialValue: model.myEmail,
                                enabled: false,
                                decoration: InputDecoration(
                                  suffixIcon: Icon(
                                    Icons.verified,
                                    color: UiConstants.primaryColor,
                                  ),
                                ),
                                controller: model.emailController,
                              ),
                            ],
                          ),
                          SizedBox(height: 16),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Mobile",
                                style: TextStyles.body3,
                              ),
                              SizedBox(height: 6),
                              TextFormField(
                                //initialValue: "+91 ${model.myMobile}",
                                enabled: false,
                                controller: model.mobileController,
                              ),
                            ],
                          ),
                          SizedBox(height: 16),
                          FelloButtonLg(
                            child: model.isUpdaingUserDetails
                                ? SpinKitThreeBounce(
                                    color: Colors.white,
                                    size: 20,
                                  )
                                : Text(
                                    model.inEditMode ? 'SAVE' : 'EDIT',
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
