import 'dart:io';
import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/core/enums/view_state_enum.dart';
import 'package:felloapp/ui/architecture/base_view.dart';
import 'package:felloapp/ui/pages/login/login_controller_vm.dart';
import 'package:felloapp/ui/pages/login/screens/otp_input/otp_4.0.dart';
import 'package:felloapp/ui/pages/login/screens/username_input/user_4.0.dart';
import 'package:felloapp/ui/pages/static/app_widget.dart';
import 'package:felloapp/ui/pages/static/base_animation/base_animation.dart';
import 'package:felloapp/ui/widgets/buttons/fello_button/large_button.dart';
import 'package:felloapp/ui/widgets/buttons/nav_buttons/nav_buttons.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/flavor_config.dart';
import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/logger.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoginControllerView extends StatefulWidget {
  final int initPage;
  static String mobileno;

  LoginControllerView({this.initPage});

  @override
  State<LoginControllerView> createState() =>
      _LoginControllerViewState(initPage);
}

class _LoginControllerViewState extends State<LoginControllerView> {
  final Log log = new Log("LoginController View");
  final int initPage;

  _LoginControllerViewState(this.initPage);

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    S locale = S.of(context);
    bool keyboardIsOpen = MediaQuery.of(context).viewInsets.bottom != 0;

    return BaseView<LoginControllerViewModel>(
      onModelReady: (model) {
        model.init(initPage);
        if (Platform.isAndroid) {
          model.initTruecaller();
        }
      },
      onModelDispose: (model) => model.exit(),
      builder: (ctx, model, child) => Scaffold(
        backgroundColor: UiConstants.primaryColor,
        // resizeToAvoidBottomInset: false,
        body: Stack(
          children: <Widget>[
            SingleChildScrollView(
              child: Container(
                width: SizeConfig.screenWidth,
                height: SizeConfig.screenHeight,
                child: Column(
                  children: [
                    Expanded(
                      child: PageView.builder(
                        physics: new NeverScrollableScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        controller: model.controller,
                        itemCount: model.pages.length,
                        itemBuilder: (BuildContext context, int index) =>
                            model.pages[index],
                        onPageChanged: (int index) => model.currentPage = index,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (keyboardIsOpen)
              Positioned(
                bottom: 0,
                child: GestureDetector(
                  onTap: () {
                    FocusManager.instance.primaryFocus.unfocus();
                    if (model.state == ViewState.Idle)
                      model.processScreenInput(
                        model.currentPage,
                      );
                  },
                  child: Container(
                    width: SizeConfig.screenWidth,
                    height: 50,
                    color: UiConstants.kLeaderBoardBackgroundColor,
                    padding: EdgeInsets.symmetric(
                      horizontal: SizeConfig.pageHorizontalMargins,
                    ),
                    alignment: Alignment.centerRight,
                    child: Text(
                      model.currentPage == LoginUserNameView.index
                          ? 'finish'
                          : model.currentPage == LoginOtpView.index
                              ? 'Done'
                              : 'next',
                      style: model.currentPage == LoginOtpView.index ||
                              model.currentPage == LoginUserNameView.index
                          ? TextStyles.rajdhaniB.body1
                              .colour(UiConstants.kPrimaryColor)
                          : TextStyles.rajdhaniB.body1,
                    ),
                  ),
                ),
              ),
            if (!keyboardIsOpen)
              Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    width: SizeConfig.screenWidth,
                    height: SizeConfig.screenWidth * 0.2,
                    margin: EdgeInsets.only(
                        bottom: SizeConfig.viewInsets.bottom +
                            SizeConfig.pageHorizontalMargins),
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
                        : Container(
                            width: SizeConfig.screenWidth,
                            alignment: Alignment.center,
                            child: AppPositiveCustomChildBtn(
                              child: model.state == ViewState.Idle
                                  ? Text(
                                      model.currentPage ==
                                              LoginUserNameView.index
                                          ? 'FINISH'
                                          : 'NEXT',
                                      style: TextStyles.rajdhaniB.title5,
                                    )
                                  : SpinKitThreeBounce(
                                      color: UiConstants.spinnerColor2,
                                      size: 18.0,
                                    ),
                              width: SizeConfig.screenWidth * 0.78,
                              onPressed: () {
                                print("tapped me");
                                if (model.state == ViewState.Idle)
                                  model.processScreenInput(
                                    model.currentPage,
                                  );
                              },
                            ),
                          ),
                  )),
            if (FlavorConfig.isDevelopment())
              Container(
                width: SizeConfig.screenWidth,
                child: Banner(
                  message: FlavorConfig.getStage(),
                  location: BannerLocation.topEnd,
                  color: FlavorConfig.instance.color,
                ),
              ),
            if (FlavorConfig.isQA())
              Container(
                width: SizeConfig.screenWidth,
                child: Banner(
                  message: FlavorConfig.getStage(),
                  location: BannerLocation.topEnd,
                  color: FlavorConfig.instance.color,
                ),
              ),
            BaseAnimation(),
          ],
        ),
      ),
    );
  }
}
