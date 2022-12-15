import 'dart:developer' as dev;
import 'dart:io';

import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/enums/faqTypes.dart';
import 'package:felloapp/core/enums/view_state_enum.dart';
import 'package:felloapp/ui/architecture/base_view.dart';
import 'package:felloapp/ui/pages/login/login_components/login_support.dart';
import 'package:felloapp/ui/pages/login/login_controller_vm.dart';
import 'package:felloapp/ui/pages/login/screens/name_input/name_input_view.dart';
import 'package:felloapp/ui/pages/static/base_animation/base_animation.dart';
import 'package:felloapp/ui/pages/static/loader_widget.dart';
import 'package:felloapp/ui/pages/static/new_square_background.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/flavor_config.dart';
import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/logger.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';

class LoginControllerView extends StatefulWidget {
  final int? initPage;
  static String? mobileno;

  LoginControllerView({this.initPage});

  @override
  State<LoginControllerView> createState() =>
      _LoginControllerViewState(initPage);
}

class _LoginControllerViewState extends State<LoginControllerView> {
  final Log log = new Log("LoginController View");
  final int? initPage;

  _LoginControllerViewState(this.initPage);

  @override
  Widget build(BuildContext context) {
    S? locale = S.of(context);
    bool keyboardIsOpen =
        MediaQuery.of(context).viewInsets.bottom > SizeConfig.viewInsets.bottom;
    return BaseView<LoginControllerViewModel>(
      onModelReady: (model) {
        model.init(initPage, model);
        if (Platform.isAndroid) {
          Future.delayed(Duration(seconds: 1), () {
            model.initTruecaller();
          });
        }
      },
      onModelDispose: (model) => model.exit(),
      builder: (ctx, model, child) {
        dev.log(model.currentPage.toString());
        return Scaffold(
          resizeToAvoidBottomInset: false,
          body: Stack(
            children: <Widget>[
              NewSquareBackground(
                  backgroundColor: UiConstants
                      .kRechargeModalSheetAmountSectionBackgroundColor),
              SingleChildScrollView(
                reverse: true,
                child: Column(
                  children: [
                    Container(
                      width: SizeConfig.screenWidth,
                      height: SizeConfig.screenHeight,
                      child: Column(
                        children: [
                          Expanded(
                            child: PageView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              scrollDirection: Axis.horizontal,
                              controller: model.controller,
                              itemCount: model.pages.length,
                              itemBuilder: (BuildContext context, int index) =>
                                  model.pages[index],
                              onPageChanged: (int index) =>
                                  model.currentPage = index,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // AnimatedContainer(
                    //   height: keyboardIsOpen && model.currentPage == 2
                    //       ? SizeConfig.screenHeight * 0.1
                    //       : 0,
                    //   duration: Duration(
                    //     milliseconds: 200,
                    //   ),
                    // ),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.topRight,
                child: Container(
                    margin: EdgeInsets.only(
                        top: SizeConfig.pageHorizontalMargins / 2,
                        right: SizeConfig.pageHorizontalMargins),
                    child: FaqPill(type: FaqsType.onboarding)),
              ),
              if (keyboardIsOpen)
                Positioned(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                  child: GestureDetector(
                    onTap: () {
                      if (BaseUtil.showNoInternetAlert()) return;
                      if (model.state == ViewState.Idle)
                        model.processScreenInput(
                          model.currentPage,
                        );
                    },
                    child: Container(
                      width: SizeConfig.screenWidth,
                      height: SizeConfig.padding54,
                      color: UiConstants.kArrowButtonBackgroundColor,
                      padding: EdgeInsets.symmetric(
                        horizontal: SizeConfig.pageHorizontalMargins,
                      ),
                      alignment: Alignment.centerRight,
                      child: model.state == ViewState.Busy
                          ? SizedBox(
                              width: SizeConfig.padding32,
                              child: SpinKitThreeBounce(
                                color: UiConstants.primaryColor,
                                size: SizeConfig.padding20,
                              ))
                          : Text(
                              model.currentPage == LoginNameInputView.index
                                  ? 'FINISH'
                                  : 'NEXT',
                              style: TextStyles.rajdhaniB.body1
                                  .colour(UiConstants.primaryColor),
                            ),
                    ),
                  ),
                ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: EdgeInsets.only(bottom: SizeConfig.padding40),
                  child: model.state == ViewState.Busy
                      ? Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            FullScreenLoader(
                                size: SizeConfig.screenWidth! * 0.3),
                            SizedBox(height: SizeConfig.padding12),
                            Text(
                              "Loading...",
                              style: TextStyles.rajdhani.body0
                                  .colour(UiConstants.primaryColor),
                            )
                          ],
                        )
                      : SizedBox(),
                ),
              ),
              if (model.currentPage == 0 &&
                  !keyboardIsOpen &&
                  model.state == ViewState.Idle &&
                  !model.loginUsingTrueCaller)
                Positioned(
                  bottom: 0,
                  child: Container(
                    width: SizeConfig.screenWidth,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                              vertical: SizeConfig.padding16,
                              horizontal: SizeConfig.padding20),
                          decoration: BoxDecoration(
                            color: UiConstants.kBackgroundColor3,
                            borderRadius: BorderRadius.all(
                                Radius.circular(SizeConfig.roundness12)),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SvgPicture.asset(
                                "assets/svg/dual_star.svg",
                                width: SizeConfig.padding20,
                              ),
                              SizedBox(
                                width: SizeConfig.padding14,
                              ),
                              Text(
                                'Join over 5 Lakh users who save and win with us!',
                                style: TextStyles.sourceSans.body4,
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(SizeConfig.padding10,
                              SizeConfig.padding16, SizeConfig.padding10, 0),
                          child: RichText(
                            text: new TextSpan(
                              children: [
                                new TextSpan(
                                  text: 'By continuing, you agree to our ',
                                  style: TextStyles.sourceSans.body3
                                      .colour(UiConstants.kTextColor2),
                                ),
                                new TextSpan(
                                  text: 'Terms of Service',
                                  style: TextStyles.sourceSans.body3.underline
                                      .colour(UiConstants.kTextColor),
                                  recognizer: new TapGestureRecognizer()
                                    ..onTap = () {
                                      model.onTermsAndConditionsClicked();
                                    },
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: SizeConfig.screenWidth! * 0.1 +
                              MediaQuery.of(context).viewInsets.bottom,
                        ),
                      ],
                    ),
                  ),
                ),

              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                    width: SizeConfig.screenWidth,
                    height: SizeConfig.screenWidth! * 0.2,
                    margin: EdgeInsets.only(
                      bottom: SizeConfig.viewInsets.bottom +
                          SizeConfig.pageHorizontalMargins,
                    ),
                    alignment: Alignment.center,
                    child: model.loginUsingTrueCaller
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Logging in with",
                                style: TextStyles.body3.bold
                                    .colour(Color(0xff1180FF)),
                              ),
                              Image.asset(
                                Assets.truecaller,
                                height: SizeConfig.body1,
                              ),
                              SizedBox(
                                width: SizeConfig.padding4,
                              ),
                              SpinKitThreeBounce(
                                color: Color(0xff1180FF),
                                size: SizeConfig.body1,
                              )
                            ],
                          )
                        : SizedBox()),
              ),
              if (FlavorConfig.isDevelopment())
                Container(
                  width: SizeConfig.screenWidth,
                  child: Banner(
                    message: FlavorConfig.getStage(),
                    location: BannerLocation.topEnd,
                    color: FlavorConfig.instance!.color,
                  ),
                ),
              if (FlavorConfig.isQA())
                Container(
                  width: SizeConfig.screenWidth,
                  child: Banner(
                    message: FlavorConfig.getStage(),
                    location: BannerLocation.topEnd,
                    color: FlavorConfig.instance!.color,
                  ),
                ),
              BaseAnimation(),
              // CircularAnim()
            ],
          ),
        );
      },
    );
  }
}
