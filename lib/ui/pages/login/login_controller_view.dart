import 'dart:io';

import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/core/enums/view_state_enum.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/ui/architecture/base_view.dart';
import 'package:felloapp/ui/pages/login/login_controller_vm.dart';
import 'package:felloapp/ui/pages/login/screens/mobile_input/mobile_input_view.dart';
import 'package:felloapp/ui/pages/login/screens/username_input/username_input_view.dart';
import 'package:felloapp/ui/pages/static/fello_appbar.dart';
import 'package:felloapp/ui/pages/static/home_background.dart';
import 'package:felloapp/ui/widgets/buttons/fello_button/large_button.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/haptic.dart';
import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/logger.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';

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
        floatingActionButton: keyboardIsOpen && Platform.isIOS
            ? FloatingActionButton(
                child: Icon(
                  Icons.done,
                  color: Colors.white,
                ),
                backgroundColor: UiConstants.tertiarySolid,
                onPressed: () => FocusScope.of(context).unfocus(),
              )
            : SizedBox(),
        body: HomeBackground(
          child: Stack(
            children: <Widget>[
              Positioned(
                bottom: 0,
                child: Container(
                  width: SizeConfig.screenWidth,
                  height: SizeConfig.screenHeight / 3,
                  color: Colors.white,
                ),
              ),
              SafeArea(
                child: Container(
                  width: SizeConfig.screenWidth,
                  height: SizeConfig.screenHeight,
                  child: Column(
                    children: [
                      ValueListenableBuilder(
                          valueListenable: model.pageNotifier,
                          builder: (ctx, value, child) {
                            return value < 2.0
                                ? SizedBox(
                                    height: kToolbarHeight,
                                  )
                                : FelloAppBar(
                                    leading:
                                        FelloAppBarBackButton(onBackPress: () {
                                      if (value == 3)
                                        model.controller.previousPage(
                                            duration:
                                                Duration(milliseconds: 600),
                                            curve: Curves.easeInOut);
                                      else
                                        AppState.delegate.appState
                                                .currentAction =
                                            PageAction(
                                                state: PageState.replaceAll,
                                                page: SplashPageConfig);
                                    }),
                                    title: value < 3
                                        ? locale.abCompleteYourProfile
                                        : locale.abGamingName,
                                  );
                          }),
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(SizeConfig.padding40),
                            topRight: Radius.circular(SizeConfig.padding40),
                          ),
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: SizeConfig.pageHorizontalMargins),
                            decoration: BoxDecoration(
                              color: Colors.white,
                            ),
                            child: PageView.builder(
                              physics: new NeverScrollableScrollPhysics(),
                              scrollDirection: Axis.horizontal,
                              controller: model.controller,
                              itemCount: model.pages.length,
                              itemBuilder: (BuildContext context, int index) {
                                //print(index - _controller.page);
                                return ValueListenableBuilder(
                                    valueListenable: model.pageNotifier,
                                    builder: (ctx, value, _) {
                                      final factorChange = value - index;
                                      return Opacity(
                                          opacity: (1 - factorChange.abs())
                                              .clamp(0.0, 1.0),
                                          child: model.pages[
                                              index % model.pages.length]);
                                    });
                              },
                              onPageChanged: (int index) {
                                setState(() {
                                  model.formProgress = 0.2 * (index + 1);
                                  model.currentPage = index;
                                });
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (!keyboardIsOpen)
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      (model.currentPage == MobileInputScreenView.index)
                          ? Padding(
                              padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                              child: RichText(
                                text: new TextSpan(
                                  children: [
                                    new TextSpan(
                                      text: 'By continuing, you agree to our ',
                                      style: GoogleFonts.montserrat(
                                          fontSize:
                                              SizeConfig.smallTextSize * 1.2,
                                          color: Colors.black45),
                                    ),
                                    new TextSpan(
                                      text: 'Terms of Service',
                                      style: GoogleFonts.montserrat(
                                          color: Colors.black45,
                                          fontSize:
                                              SizeConfig.smallTextSize * 1.2,
                                          decoration: TextDecoration.underline),
                                      recognizer: new TapGestureRecognizer()
                                        ..onTap = () {
                                          Haptic.vibrate();
                                          BaseUtil.launchUrl(
                                              'https://fello.in/policy/tnc');
                                          // appStateProvider.currentAction = PageAction(
                                          //     state: PageState.addPage,
                                          //     page: TncPageConfig);
                                        },
                                    ),
                                  ],
                                ),
                              ),
                            )
                          : Container(),
                      model.loginUsingTrueCaller
                          ? Container(
                              width: SizeConfig.screenWidth,
                              padding: EdgeInsets.fromLTRB(0, 10, 0, 20),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: <Widget>[
                                  new Container(
                                    width: SizeConfig.screenWidth -
                                        SizeConfig.pageHorizontalMargins * 2,
                                    child: FelloButtonLg(
                                        color: Colors.white,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              "Logging using",
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
                                        )),
                                  ),
                                ],
                              ),
                            )
                          // SafeArea(
                          //     child: Container(
                          //       margin: EdgeInsets.only(
                          //           bottom: SizeConfig.padding24),
                          //       width: SizeConfig.screenWidth,
                          //       height: 60,
                          //       child: Row(
                          //         mainAxisAlignment: MainAxisAlignment.center,
                          //         crossAxisAlignment: CrossAxisAlignment.center,
                          //         children: [
                          // Text(
                          //   "Logging using",
                          //   style: GoogleFonts.nunito(
                          //     fontSize: SizeConfig.body2,
                          //     color: Color(0xff1180FF),
                          //     fontWeight: FontWeight.w700,
                          //   ),
                          //   //  TextStyles.body2.bold
                          //   //     .colour(Color(0xff1180FF)),
                          // ),
                          // Image.asset(
                          //   Assets.truecaller,
                          //   height: SizeConfig.body1,
                          // ),
                          // SizedBox(
                          //   width: SizeConfig.padding4,
                          // ),
                          // SpinKitThreeBounce(
                          //   color: Color(0xff1180FF),
                          //   size: SizeConfig.body1,
                          // )
                          //         ],
                          //       ),
                          //     ),
                          //   )
                          : Container(
                              width: SizeConfig.screenWidth,
                              padding: EdgeInsets.fromLTRB(0, 10, 0, 20),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: <Widget>[
                                  new Container(
                                    width: SizeConfig.screenWidth -
                                        SizeConfig.pageHorizontalMargins * 2,
                                    child: FelloButtonLg(
                                      child: model.state == ViewState.Idle
                                          ? Text(
                                              model.currentPage ==
                                                      Username.index
                                                  ? 'FINISH'
                                                  : 'NEXT',
                                              style: TextStyles.body2
                                                  .colour(Colors.white),
                                            )
                                          : SpinKitThreeBounce(
                                              color: UiConstants.spinnerColor2,
                                              size: 18.0,
                                            ),
                                      onPressed: () {
                                        if (model.state == ViewState.Idle)
                                          model.processScreenInput(
                                              model.currentPage);
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            )
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
