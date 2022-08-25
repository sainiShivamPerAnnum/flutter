import 'package:felloapp/ui/architecture/base_view.dart';
import 'package:felloapp/ui/pages/login/level_2/complete_profile_vm.dart';
import 'package:felloapp/ui/pages/login/level_2/screens/choose_avatar_input/choose_avatar.dart';
import 'package:felloapp/ui/pages/login/level_2/screens/dob_input/dob_4.0.dart';
import 'package:felloapp/ui/pages/login/level_2/screens/email_input/email_4.0.dart';
import 'package:felloapp/ui/pages/login/level_2/screens/name_input/name_4.0.dart';
import 'package:felloapp/ui/pages/static/app_widget.dart';
import 'package:felloapp/ui/pages/static/new_square_background.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CompleteProfileView extends StatefulWidget {
  final int initPage;
  CompleteProfileView({Key key, this.initPage}) : super(key: key);

  @override
  State<CompleteProfileView> createState() => _Level2ViewState();
}

class _Level2ViewState extends State<CompleteProfileView> {
  @override
  Widget build(BuildContext context) {
    return BaseView<CompleteProfileViewModel>(
      onModelReady: (model) {},
      builder: (ctx, model, child) => Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: Stack(
            children: [
              NewSquareBackground(),
              if (model.currentPage != 0)
                Container(
                  height: SizeConfig.screenHeight * 0.5,
                  width: SizeConfig.screenWidth,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color(0xff135756),
                        UiConstants.kBackgroundColor,
                      ],
                    ),
                  ),
                ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    height: SizeConfig.screenWidth * 1.5,
                    child: PageView(
                      controller: model.pageController,
                      physics: NeverScrollableScrollPhysics(),
                      onPageChanged: (val) {
                        model.currentPage = val;
                      },
                      children: [
                        ChooseAvatar4(model: model),
                        Name4(model: model),
                        Email4(model: model),
                        DOB4(model: model),
                      ],
                    ),
                  ),
                ],
              ),
              Positioned(
                bottom: SizeConfig.pageHorizontalMargins,
                // alignment: Alignment.bottomCenter,
                child: (model.currentPage == 0)
                    ? Container(
                        width: SizeConfig.screenWidth,
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: () async {
                                  model.handleNextButtonTap();
                                },
                                child: Center(
                                  child: Container(
                                    width: SizeConfig.screenWidth * 0.136,
                                    height: SizeConfig.screenWidth * 0.136,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Color(0xFF01656B),
                                    ),
                                    child: Center(
                                      child: SvgPicture.asset(
                                        'assets/svg/arrow_svg.svg',
                                        height: SizeConfig.screenWidth * 0.066,
                                        width: SizeConfig.screenWidth * 0.069,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            ]))
                    : Container(
                        width: SizeConfig.screenWidth,
                        alignment: Alignment.center,
                        padding: EdgeInsets.symmetric(
                            horizontal: SizeConfig.pageHorizontalMargins),
                        child: model.isUpdaingUserDetails ||
                                model.isSigningInWithGoogle
                            ? SpinKitThreeBounce(
                                color: Colors.white,
                                size: SizeConfig.iconSize0,
                              )
                            : AppPositiveBtn(
                                btnText:
                                    model.currentPage == 3 ? 'Finish' : 'Next',
                                onPressed: () {
                                  model.handleNextButtonTap();
                                },
                                width: SizeConfig.screenWidth,
                              ),
                      ),
              ),
              Positioned(
                top: SizeConfig.padding32,
                left: SizeConfig.padding24,
                child: Text(
                  "${model.currentPage + 1}/4",
                  style: TextStyles.sourceSans.body3.setOpecity(0.7),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
