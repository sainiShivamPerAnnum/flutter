import 'dart:io';

import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/base_analytics.dart';
import 'package:felloapp/core/constants/apis_path_constants.dart';
import 'package:felloapp/core/enums/cache_type_enum.dart';
import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/core/model/base_user_model.dart';
import 'package:felloapp/core/ops/augmont_ops.dart';
import 'package:felloapp/core/ops/db_ops.dart';
import 'package:felloapp/core/ops/lcl_db_ops.dart';
import 'package:felloapp/core/service/api_service.dart';
import 'package:felloapp/core/service/cache_manager.dart';
import 'package:felloapp/core/service/fcm/fcm_listener_service.dart';
import 'package:felloapp/core/service/mixpanel_service.dart';
import 'package:felloapp/core/service/user_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/ui/architecture/base_view.dart';
import 'package:felloapp/ui/pages/login/login_controller_vm.dart';
import 'package:felloapp/ui/pages/login/screens/mobile_input/mobile_input_view.dart';
import 'package:felloapp/ui/pages/login/screens/name_input/name_input_view.dart';
import 'package:felloapp/ui/pages/login/screens/otp_input/otp_input_view.dart';
import 'package:felloapp/ui/pages/login/screens/username_input/username_input_view.dart';
import 'package:felloapp/ui/pages/static/fello_appbar.dart';
import 'package:felloapp/ui/pages/static/home_background.dart';
import 'package:felloapp/ui/widgets/buttons/fello_button/large_button.dart';
import 'package:felloapp/util/constants.dart';
import 'package:felloapp/util/flavor_config.dart';
import 'package:felloapp/util/haptic.dart';
import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/logger.dart';
import 'package:felloapp/util/mixpanel_events.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

class LoginControllerView extends StatefulWidget {
  final int initPage;
  static String mobileno;

  LoginControllerView({this.initPage});

  @override
  State<LoginControllerView> createState() =>
      _LoginControllerViewState(initPage);
}

class _LoginControllerViewState extends State<LoginControllerView>
    with TickerProviderStateMixin {
  final Log log = new Log("######## LoginController View ##########");
  final int initPage;
  double _formProgress = 0.2;
  bool _isSignup = false;

  _LoginControllerViewState(this.initPage);

  PageController _controller;

  // static FcmListener fcmProvider;
  static LocalDBModel lclDbProvider;
  static AppState appStateProvider;

  AnimationController animationController;

  String userMobile;
  String _verificationId;
  String _augmentedVerificationId;
  String state;
  ValueNotifier<double> _pageNotifier;
  static List<Widget> _pages;
  int _currentPage;
  final _mobileScreenKey = new GlobalKey<MobileInputScreenViewState>();
  final _otpScreenKey = new GlobalKey<OtpInputScreenState>();
  final _nameScreenKey = new GlobalKey<NameInputScreenState>();
  final _usernameKey = new GlobalKey<UsernameState>();

  @override
  void initState() {
    super.initState();
    _currentPage = (initPage != null) ? initPage : MobileInputScreenView.index;
    _formProgress = 0.2 * (_currentPage + 1);
    _controller = new PageController(initialPage: _currentPage);
    _controller.addListener(_pageListener);
    _pageNotifier = ValueNotifier(0.0);
    _pages = [
      MobileInputScreenView(key: _mobileScreenKey),
      OtpInputScreen(
        key: _otpScreenKey,
        otpEntered: _onOtpFilled,
        resendOtp: _onOtpResendRequested,
        changeNumber: _onChangeNumberRequest,
        mobileNo: this.userMobile,
      ),
      NameInputScreen(key: _nameScreenKey),
      Username(key: _usernameKey)
      // AddressInputScreen(key: _addressScreenKey),
    ];
    animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 3),
    )
      ..forward()
      ..repeat(reverse: false);
  }

  @override
  void dispose() {
    _controller.removeListener(_pageListener);
    _controller.dispose();
    animationController.dispose();
    super.dispose();
  }

  void _pageListener() {
    _pageNotifier.value = _controller.page;
  }

  @override
  Widget build(BuildContext context) {

    lclDbProvider = Provider.of<LocalDBModel>(context, listen: false);
    appStateProvider = Provider.of<AppState>(context, listen: false);
    S locale = S.of(context);
    bool keyboardIsOpen = MediaQuery.of(context).viewInsets.bottom != 0;

    return BaseView<LoginControllerViewModel>(
      onModelReady: (model) => model.init(),
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
                          valueListenable: _pageNotifier,
                          builder: (ctx, value, child) {
                            return value < 2.0
                                ? SizedBox(
                                    height: kToolbarHeight,
                                  )
                                : FelloAppBar(
                                    leading:
                                        FelloAppBarBackButton(onBackPress: () {
                                      if (value == 3)
                                        _controller.previousPage(
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
                              controller: _controller,
                              itemCount: _pages.length,
                              itemBuilder: (BuildContext context, int index) {
                                //print(index - _controller.page);
                                return ValueListenableBuilder(
                                    valueListenable: _pageNotifier,
                                    builder: (ctx, value, _) {
                                      final factorChange = value - index;
                                      return Opacity(
                                          opacity: (1 - factorChange.abs())
                                              .clamp(0.0, 1.0),
                                          child: _pages[index % _pages.length]);
                                    });
                              },
                              onPageChanged: (int index) {
                                setState(() {
                                  _formProgress = 0.2 * (index + 1);
                                  _currentPage = index;
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
                      (_currentPage == MobileInputScreenView.index)
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
                      Container(
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
                                child: (!model.baseProvider.isLoginNextInProgress)
                                    ? Text(
                                        _currentPage == Username.index
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
                                  if (!model.baseProvider.isLoginNextInProgress)
                                    _processScreenInput(_currentPage);
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
