import 'dart:math';

import 'package:app_install_date/utils.dart';
import 'package:external_app_launcher/external_app_launcher.dart';
import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/enums/paytm_service_enums.dart';
import 'package:felloapp/core/service/notifier_services/paytm_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/architecture/base_view.dart';
import 'package:felloapp/ui/dialogs/more_info_dialog.dart';
import 'package:felloapp/ui/pages/others/finance/autopay/autopay_process/autopay_process_vm.dart';
import 'package:felloapp/ui/pages/others/finance/autopay/user_autopay_details/user_autopay_details_view.dart';
import 'package:felloapp/ui/pages/others/games/tambola/tambola_home/tambola_home_view.dart';
import 'package:felloapp/ui/pages/static/fello_appbar.dart';
import 'package:felloapp/ui/pages/static/home_background.dart';
import 'package:felloapp/ui/widgets/buttons/fello_button/large_button.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/haptic.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:property_change_notifier/property_change_notifier.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:timelines/timelines.dart';

class AutoSaveProcessView extends StatefulWidget {
  final int page;
  AutoSaveProcessView({this.page = 0});

  @override
  State<AutoSaveProcessView> createState() => _AutoSaveProcessViewState();
}

class _AutoSaveProcessViewState extends State<AutoSaveProcessView>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return BaseView<AutoSaveProcessViewModel>(onModelReady: (model) {
      model.lottieAnimationController = AnimationController(vsync: this);
      model.init(widget.page);
    }, builder: (context, model, child) {
      return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: UiConstants.primaryColor,
        body: HomeBackground(
          child: Stack(
            children: [
              Column(
                children: [
                  FelloAppBar(
                    leading: model.isSubscriptionInProgress
                        ? SizedBox()
                        : FelloAppBarBackButton(),
                    title: "Set up Autosave",
                  ),
                  Expanded(
                    child: Container(
                      width: SizeConfig.screenWidth,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(SizeConfig.padding40),
                          topRight: Radius.circular(SizeConfig.padding40),
                        ),
                        color: Colors.white,
                      ),
                      child: Stack(
                        children: [
                          if (model.showProgressIndicator)
                            AutosaveProgressIndicator(),
                          PageView(
                              controller: model.pageController,
                              physics: NeverScrollableScrollPhysics(),
                              children: [
                                addUpiIdUI(model),
                                pendingUI(model),
                                amountSetUI(model),
                                completedUI(model),
                                cancelledUI(model),
                              ]),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    });
  }

  pendingUI(AutoSaveProcessViewModel model) {
    return Container(
      padding:
          EdgeInsets.symmetric(horizontal: SizeConfig.pageHorizontalMargins),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: SizeConfig.padding64),
          // Lottie.asset("assets/lotties/pending.json",
          //     height: SizeConfig.screenWidth * 0.2, repeat: false),
          Icon(Icons.timer_outlined,
              color: UiConstants.tertiarySolid,
              size: SizeConfig.screenWidth * 0.2),
          SizedBox(height: SizeConfig.padding16),
          Text(
            "Authorize UPI request",
            style: TextStyles.title3.bold,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: SizeConfig.padding8),
          Container(
            margin: EdgeInsets.symmetric(
                vertical: SizeConfig.pageHorizontalMargins),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(SizeConfig.roundness16),
              child: Shimmer(
                color: UiConstants.tertiarySolid,
                colorOpacity: 0.2,
                enabled: true,
                interval: Duration(seconds: 2),
                child: Container(
                  height: SizeConfig.screenWidth * 0.25,
                  decoration: BoxDecoration(
                    color: UiConstants.tertiaryLight,
                    borderRadius: BorderRadius.circular(SizeConfig.roundness16),
                  ),
                  padding: EdgeInsets.all(SizeConfig.padding24),
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundColor:
                            UiConstants.tertiarySolid.withOpacity(0.2),
                        radius: SizeConfig.screenWidth * 0.067,
                        child: SvgPicture.asset(
                          "assets/vectors/icons/upi.svg",
                          height: SizeConfig.screenWidth * 0.067,
                          // width: SizeConfig.padding64,
                        ),
                      ),
                      SizedBox(
                        width: SizeConfig.padding12,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            FittedBox(
                              child: Row(
                                children: [
                                  Text(
                                    model.vpaController.text.trim(),
                                    style: TextStyles.body1.bold,
                                  ),
                                  SizedBox(width: SizeConfig.padding4),
                                  SvgPicture.asset(
                                    "assets/vectors/check.svg",
                                    height: SizeConfig.iconSize1,
                                    // width: SizeConfig.padding64,
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: SizeConfig.padding4),
                            FittedBox(
                              child: Text(
                                "Your UPI Address",
                                style: TextStyles.body3.colour(Colors.grey),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Row(
            children: [
              Container(
                width: 2,
                height: SizeConfig.padding54,
                color: UiConstants.primaryColor,
              ),
              Expanded(
                child: ListTile(
                  title: Text(
                    "Step 1",
                    style: TextStyles.body1.bold,
                  ),
                  subtitle: Text(
                    "Go to your ${getUpiAppName(model)} mobile app",
                    style: TextStyles.body2,
                  ),
                  // trailing: CircleAvatar(
                  //   backgroundColor: UiConstants.tertiaryLight,
                  //   radius: SizeConfig.padding20,
                  // ),
                ),
              ),
            ],
          ),
          SizedBox(height: SizeConfig.padding16),
          Row(
            children: [
              Container(
                width: 2,
                height: SizeConfig.padding64,
                color: UiConstants.primaryColor,
              ),
              Expanded(
                child: ListTile(
                  title: Text(
                    "Step 2",
                    style: TextStyles.body1.bold,
                  ),
                  subtitle: Text(
                    "Check pending requests and approve Autosave by entering UPI PIN",
                    style: TextStyles.body2,
                  ),
                  // trailing: CircleAvatar(
                  //   backgroundColor: UiConstants.tertiaryLight,
                  //   radius: SizeConfig.padding20,
                  // ),
                ),
              ),
            ],
          ),
          Spacer(),
          if (model.showAppLaunchButton && PlatformUtils.isAndroid)
            FelloButtonLg(
              child: Text("Go to ${getUpiAppName(model)} app",
                  style: TextStyles.body2.colour(Colors.white)),
              onPressed: () async {
                await LaunchApp.openApp(
                    androidPackageName: model.androidPackageName,
                    iosUrlScheme: model.iosUrlScheme,
                    openStore: false);
              },
            ),
          SizedBox(height: SizeConfig.padding16),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              "Please do not press back until the payment is completed",
              style: TextStyles.body4.colour(Colors.red[400]).light,
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: SizeConfig.padding8),
          // if (model.pageController != null && model.pageController.page == 1.0)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "This page will expire in ",
                style: TextStyles.body3.colour(Colors.grey).light,
              ),
              TweenAnimationBuilder<Duration>(
                  duration: Duration(minutes: 8),
                  tween: Tween(begin: Duration(minutes: 8), end: Duration.zero),
                  onEnd: () {
                    print('Timer ended');
                  },
                  builder:
                      (BuildContext context, Duration value, Widget child) {
                    final minutes = value.inMinutes;
                    final seconds = value.inSeconds % 60;
                    return Text(
                      '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}',
                      style: TextStyles.body3.bold,
                    );
                  }),
            ],
          ),
          SizedBox(
            height:
                SizeConfig.viewInsets.bottom + SizeConfig.pageHorizontalMargins,
          )
        ],
      ),
    );
  }

  completedUI(AutoSaveProcessViewModel model) {
    return Container(
      padding:
          EdgeInsets.symmetric(horizontal: SizeConfig.pageHorizontalMargins),
      child: Stack(
        children: [
          Container(
            width: SizeConfig.screenWidth,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Lottie.asset(
                  "assets/lotties/complete.json",
                  height: SizeConfig.screenWidth / 2,
                ),
                AnimatedContainer(
                  duration: Duration(seconds: 1),
                  curve: Curves.decelerate,
                  child: Column(children: [
                    Text(
                      "Setup Successful",
                      style: TextStyles.title3.bold,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: SizeConfig.padding8),
                    Text(
                      "Your Fello Autosave account has been successfully set up!",
                      style: TextStyles.body2,
                      textAlign: TextAlign.center,
                    ),
                  ]),
                ),
                SizedBox(height: SizeConfig.screenWidth / 3),
                // DetailsView(model: _userAutosaveDetailsVM)
              ],
            ),
          ),
          Align(
              alignment: Alignment.topCenter,
              child: Container(
                alignment: Alignment.center,
                height: SizeConfig.screenHeight,
                width: SizeConfig.screenWidth,
                child: Transform.scale(
                  scale: 2,
                  child: Lottie.asset(
                    Assets.gtConfetti,
                    controller: model.lottieAnimationController,
                    onLoaded: (composition) {
                      model.lottieAnimationController
                        ..duration = composition.duration;
                    },
                    repeat: false,
                  ),
                ),
              )),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              margin: EdgeInsets.symmetric(
                  vertical: SizeConfig.pageHorizontalMargins),
              width: SizeConfig.screenWidth,
              child: FelloButtonLg(
                child: Text(
                  "Done",
                  style: TextStyles.body2.bold.colour(Colors.white),
                ),
                onPressed: () {
                  // if (model.lottieAnimationController.isAnimating) {
                  //   model.lottieAnimationController.stop();
                  //   model.lottieAnimationController.repeat();
                  // } else
                  //   model.lottieAnimationController.repeat();
                  AppState.backButtonDispatcher.didPopRoute();
                },
              ),
            ),
          )
        ],
      ),
    );
  }

  cancelledUI(AutoSaveProcessViewModel model) {
    return Container(
      padding:
          EdgeInsets.symmetric(horizontal: SizeConfig.pageHorizontalMargins),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Spacer(),
          Lottie.asset(
            "assets/lotties/cancel.json",
            repeat: false,
            height: SizeConfig.screenWidth / 3,
          ),
          Text(
            "Autosave Failed!",
            style: TextStyles.title3.bold,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: SizeConfig.padding12),
          Text(
            "Your setup was not successful!. Don't worry you can still try",
            style: TextStyles.body2,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: SizeConfig.padding24),
          Container(
            width: SizeConfig.screenWidth * 0.6,
            child: FelloButtonLg(
              child: Text(
                "Try Again",
                style: TextStyles.body2.bold.colour(Colors.white),
              ),
              onPressed: () {
                model.tryAgain();
              },
            ),
          ),
          Spacer()
        ],
      ),
    );
  }

  addUpiIdUI(AutoSaveProcessViewModel model) {
    return Container(
      padding:
          EdgeInsets.symmetric(horizontal: SizeConfig.pageHorizontalMargins),
      child: Column(
        children: [
          SizedBox(height: SizeConfig.padding54),
          Image.asset("assets/images/upisetup.png",
              height: SizeConfig.screenHeight * 0.16),
          SizedBox(height: SizeConfig.padding24),
          InkWell(
            onTap: () {
              BaseUtil.openDialog(
                addToScreenStack: true,
                hapticVibrate: true,
                isBarrierDismissable: true,
                content: MoreInfoDialog(
                  text:
                      "You can find your UPI Id on any of your payments application",
                  title: "What is my UPI address ?",
                  imagePath: "assets/images/upisetup.png",
                ),
              );
            },
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFieldLabel("Enter your UPI Id "),
                SizedBox(width: SizeConfig.padding2),
                Container(
                  // height: SizeConfig.body3,
                  margin: EdgeInsets.only(
                      top: SizeConfig.padding16 + SizeConfig.padding2),
                  decoration: BoxDecoration(
                      border:
                          Border.all(width: 1, color: UiConstants.primaryColor),
                      shape: BoxShape.circle),
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(SizeConfig.padding2),
                  child: Icon(
                    Icons.question_mark_outlined,
                    color: UiConstants.primaryColor,
                    size: SizeConfig.body5,
                  ),
                )
              ],
            ),
          ),
          TextField(
            enabled: !model.isSubscriptionInProgress,
            controller: model.vpaController,
            autofocus: widget.page == 0 ? true : false,
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.allow(RegExp("[0-9a-zA-Z@]")),
            ],
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(hintText: "hello@upi"),
          ),
          SizedBox(
            height: SizeConfig.padding12,
          ),
          Container(
            width: SizeConfig.screenWidth,
            child: Wrap(
              runSpacing: SizeConfig.padding8,
              spacing: SizeConfig.padding12,
              children: [
                upichips('@upi', model),
                upichips('@apl', model),
                upichips('@fbl', model),
                upichips('@ybl', model),
                upichips('@paytm', model),
                upichips('@okhdfcbank', model),
                upichips('@okaksis', model),
              ],
            ),
          ),
          Spacer(),
          model.isSubscriptionInProgress
              ? SubProcessText()
              : FelloButtonLg(
                  child: model.isSubscriptionInProgress
                      ? SpinKitThreeBounce(
                          color: Colors.white,
                          size: 20,
                        )
                      : Text(
                          "NEXT",
                          style: TextStyles.body2.colour(Colors.white).bold,
                        ),
                  onPressed: () async {
                    Haptic.vibrate();
                    model.initiateCustomSubscription();
                    FocusScope.of(context).unfocus();
                  },
                ),
          SizedBox(
            height: SizeConfig.padding24,
          ),
          Text(
            "Banks that support UPI Autosave",
            style: TextStyles.body3.colour(Colors.grey),
          ),
          SizedBox(height: SizeConfig.padding16),
          Image.asset(
            "assets/images/autosavebanks.png",
            width: SizeConfig.screenWidth * 0.7,
          ),
          SizedBox(height: SizeConfig.padding12),
          RichText(
            text: new TextSpan(
              children: [
                new TextSpan(
                  text: 'and ',
                  style: TextStyles.body3.colour(Colors.black45),
                ),
                new TextSpan(
                  text: '59 more...',
                  style: TextStyles.body3.colour(UiConstants.primaryColor).bold,
                  recognizer: new TapGestureRecognizer()
                    ..onTap = () {
                      Haptic.vibrate();
                      BaseUtil.launchUrl(
                          'https://www.npci.org.in/what-we-do/autopay/list-of-banks-and-apps-live-on-autopay');
                    },
                ),
              ],
            ),
          ),
          SizedBox(
            height: SizeConfig.viewInsets.bottom != 0
                ? SizeConfig.viewInsets.bottom
                : SizeConfig.pageHorizontalMargins,
          )
        ],
      ),
    );
  }

  amountSetUI(AutoSaveProcessViewModel model) {
    return Stack(
      children: [
        Container(
          padding: EdgeInsets.symmetric(
              horizontal: SizeConfig.pageHorizontalMargins),
          child: Column(
            children: [
              SizedBox(height: SizeConfig.padding64),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: SizeConfig.pageHorizontalMargins),
                child: Text(
                  "How much would you like to save?",
                  style: TextStyles.title3.bold,
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: SizeConfig.padding24),
              Container(
                decoration: BoxDecoration(
                  color: UiConstants.scaffoldColor,
                  borderRadius: BorderRadius.circular(SizeConfig.roundness12),
                ),
                padding: EdgeInsets.all(SizeConfig.padding6),
                height: SizeConfig.padding54,
                child: Stack(
                  children: [
                    AnimatedPositioned(
                      duration: Duration(milliseconds: 500),
                      curve: Curves.decelerate,
                      left: model.isDaily
                          ? 0
                          : (SizeConfig.screenWidth / 2 -
                              SizeConfig.pageHorizontalMargins -
                              SizeConfig.padding6),
                      child: Container(
                        width: SizeConfig.screenWidth / 2 -
                            SizeConfig.pageHorizontalMargins -
                            SizeConfig.padding6,
                        height: SizeConfig.padding54 * 0.8,
                        decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.circular(SizeConfig.roundness12),
                          color: UiConstants.primaryColor,
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Row(
                        children: [
                          Expanded(
                            child: InkWell(
                              onTap: () {
                                Haptic.vibrate();
                                model.isDaily = true;
                                model.onAmountValueChanged(
                                    model?.amountFieldController?.text);
                              },
                              child: SegmentChips(
                                model: model,
                                text: "Daily",
                              ),
                            ),
                          ),
                          Expanded(
                            child: InkWell(
                              onTap: () {
                                Haptic.vibrate();
                                model.isDaily = false;
                                model.onAmountValueChanged(
                                    model.amountFieldController.text);
                              },
                              child: SegmentChips(
                                model: model,
                                text: "Weekly",
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: SizeConfig.padding24),
              Container(
                width: SizeConfig.screenWidth,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(child: SizedBox()),
                    IntrinsicWidth(
                      child: Container(
                        height: SizeConfig.screenWidth / 4.2,
                        child: TextField(
                          controller: model.amountFieldController,
                          maxLines: null,
                          maxLength: 4,

                          decoration: InputDecoration(
                              prefixText: "₹",
                              counterText: "",
                              prefixStyle: GoogleFonts.sourceSansPro(
                                  fontWeight: FontWeight.bold,
                                  fontSize: SizeConfig.screenWidth / 4.8,
                                  color: Colors.black),
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: -SizeConfig.padding4),
                              isDense: true,
                              isCollapsed: true,
                              border: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none),
                          // autofocus: true,
                          // cursorHeight: SizeConfig.padding20,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          // enableInteractiveSelection: false,
                          keyboardType: TextInputType.number,
                          // cursorWidth: 0,
                          autofocus: true,
                          onChanged: (value) {
                            model.onAmountValueChanged(value);
                          },

                          style: GoogleFonts.sourceSansPro(
                              fontWeight: FontWeight.bold,
                              height: 0.9,
                              fontSize: SizeConfig.screenWidth / 4.8,
                              color: Colors.black),
                        ),
                      ),
                    ),
                    Column(
                      children: [
                        Text(
                          model.isDaily ? '/day' : '/week',
                          style: GoogleFonts.sourceSansPro(
                              fontSize: SizeConfig.title3,
                              height: 2,
                              color: Colors.black38),
                        ),
                        SizedBox(height: SizeConfig.padding12)
                      ],
                    ),
                    Expanded(child: SizedBox()),
                  ],
                ),
              ),
              SizedBox(height: 10),
              Container(
                width: SizeConfig.screenWidth,
                padding: EdgeInsets.symmetric(
                  vertical: SizeConfig.padding12,
                  horizontal: SizeConfig.pageHorizontalMargins,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                    SizeConfig.roundness12,
                  ),
                  color: UiConstants.tertiaryLight,
                ),
                alignment: Alignment.center,
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: RichText(
                      text: TextSpan(
                    text: "You'll be saving ",
                    children: [
                      TextSpan(
                          text:
                              "₹${model.saveAmount.toInt().toString().replaceAllMapped(model.reg, model.mathFunc)}",
                          style: TextStyles.body2.bold
                              .colour(UiConstants.tertiarySolid)),
                      TextSpan(text: " every year")
                    ],
                    style: TextStyles.body2.colour(Colors.black),
                  )),
                ),
              ),
              SizedBox(
                height: SizeConfig.padding24,
              ),
              Container(
                width: SizeConfig.screenWidth,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: model.isDaily
                      ? List.generate(
                          model.dailyChips.length,
                          (index) => AmountChips(
                                amount: model.dailyChips[index].value,
                                model: model,
                                isBestSeller: model.dailyChips[index].best,
                              ))
                      : List.generate(
                          model.weeklyChips.length,
                          (index) => AmountChips(
                                amount: model.weeklyChips[index].value,
                                model: model,
                                isBestSeller: model.weeklyChips[index].best,
                              )),
                ),
              ),
              Spacer(),
              SizedBox(
                height: SizeConfig.screenHeight * 0.3,
              )
            ],
          ),
        ),
        Positioned(
            bottom: 0,
            child: SafeArea(
              child: Container(
                width: SizeConfig.screenWidth,
                padding: EdgeInsets.symmetric(
                  horizontal: SizeConfig.pageHorizontalMargins,
                  // vertical: SizeConfig.padding16,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(SizeConfig.roundness32),
                    topRight: Radius.circular(SizeConfig.roundness32),
                  ),
                  color: Colors.white,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (model.amountFieldController.text != null &&
                        model.amountFieldController.text.isNotEmpty)
                      Container(
                        margin: EdgeInsets.only(top: SizeConfig.padding16),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "Great choice. every ${model.isDaily ? 'day' : 'week'} you'll recieve",
                                style: TextStyles.body2.bold,
                              ),
                              // Divider(
                              //   height: SizeConfig.padding24,
                              // ),
                              SizedBox(height: SizeConfig.padding12),
                              Container(
                                width: SizeConfig.screenWidth,
                                // height: SizeConfig.padding40,
                                child: Row(
                                    // scrollDirection: Axis.horizontal,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      AutosavePerks(
                                        svg: 'images/svgs/gold.svg',
                                        text: "Interest on gold",
                                      ),
                                      if (model.amountFieldController.text !=
                                              null &&
                                          model.amountFieldController.text
                                              .isNotEmpty &&
                                          int.tryParse(model
                                                  ?.amountFieldController
                                                  ?.text) >=
                                              100)
                                        AutosavePerks(
                                          svg: Assets.goldenTicket,
                                          text: "Golden ticket",
                                        ),
                                      if (model.amountFieldController.text !=
                                              null &&
                                          model.amountFieldController.text
                                              .isNotEmpty &&
                                          int.tryParse(model
                                                      ?.amountFieldController
                                                      ?.text ??
                                                  '0') >=
                                              0)
                                        AutosavePerks(
                                          svg: Assets.tokens,
                                          text:
                                              "${int.tryParse(model?.amountFieldController?.text)} Fello Tokens",
                                        )
                                    ]),
                              )
                            ]),
                      ),
                    SizedBox(height: SizeConfig.padding16),
                    Container(
                      width: SizeConfig.screenWidth -
                          SizeConfig.pageHorizontalMargins * 2,
                      child: FelloButtonLg(
                        child: model.isSubscriptionAmountUpdateInProgress
                            ? SpinKitThreeBounce(
                                color: Colors.white,
                                size: 20,
                              )
                            : Text(
                                "Finish",
                                style:
                                    TextStyles.body2.bold.colour(Colors.white),
                              ),
                        onPressed: () {
                          model.setSubscriptionAmount(int.tryParse(
                                  model.amountFieldController == null ||
                                          model.amountFieldController?.text ==
                                              null ||
                                          model.amountFieldController.text
                                              .isEmpty
                                      ? '0'
                                      : model.amountFieldController?.text)
                              .toDouble());
                        },
                      ),
                    ),
                    SizedBox(
                      height: SizeConfig.viewInsets.bottom != 0
                          ? 0
                          : SizeConfig.pageHorizontalMargins,
                    ),
                  ],
                ),
              ),
            )),
      ],
    );
  }

  defaultUI(AutoSaveProcessViewModel model) {
    return ListLoader();
  }

  upichips(String suffix, AutoSaveProcessViewModel model) {
    return InkWell(
      onTap: () {
        Haptic.vibrate();
        model.vpaController.text =
            model.vpaController.text.trim().split('@').first + suffix;
      },
      child: Container(
        decoration: BoxDecoration(
          color: UiConstants.primaryLight.withOpacity(0.5),
          borderRadius: BorderRadius.circular(SizeConfig.roundness12),
        ),
        padding: EdgeInsets.symmetric(
          horizontal: SizeConfig.padding12,
          vertical: SizeConfig.padding8,
        ),
        margin: EdgeInsets.only(bottom: SizeConfig.padding4),
        child: Text(
          suffix,
          style: TextStyles.body3,
        ),
      ),
    );
  }

  amountchips(int amount, AutoSaveProcessViewModel model) {
    return InkWell(
      onTap: () {
        model.amountFieldController?.text = amount.toString();
        model.onAmountValueChanged(amount.toString());
      },
      child: Chip(
          labelPadding: EdgeInsets.symmetric(
            horizontal: SizeConfig.padding12,
            vertical: SizeConfig.padding4,
          ),
          label: Text(
            "₹ ${amount.toString()}",
            style: TextStyles.body3,
          )),
    );
  }

  String getUpiAppName(AutoSaveProcessViewModel model) {
    final String upi = model.vpaController.text.split('@').last;
    switch (upi) {
      case 'upi':
        return 'BHIM';
      case 'paytm':
        return "Paytm";
      case 'ybl':
        return "PhonePe";
      case 'ibl':
        return "PhonePe";
      case 'axl':
        return "PhonePe";
      case 'okhdfcbank':
        return "Google Pay";
      case 'okaksix':
        return "Google Pay";
      case 'apl':
        return "Amazon Pay";
      case 'indus':
        return "BHIM Indus Pay";
      case 'boi':
        return "BHIM BOI UPI";
      case 'cnrb':
        return "BHIM Canara";
      default:
        return "preferred UPI";
    }
  }
}

class AutosaveProgressIndicator extends StatelessWidget {
  final _processes = ['Prospect', 'Tour', 'Offer'];

  final completeColor = UiConstants.primaryColor;
  final inProgressColor = UiConstants.tertiarySolid;
  final todoColor = Color(0xffd1d2d7);
  Color getColor(model, index) {
    if (index == model.fraction) {
      return inProgressColor;
    } else if (index < model.fraction) {
      return completeColor;
    } else {
      return todoColor;
    }
  }

  @override
  Widget build(BuildContext context) {
    return PropertyChangeConsumer<PaytmService, PaytmServiceProperties>(
        properties: [PaytmServiceProperties.ProcessFraction],
        builder: (context, model, property) => Align(
              alignment: Alignment.topCenter,
              child: Container(
                  alignment: Alignment.center,
                  width: SizeConfig.screenWidth,
                  height: SizeConfig.padding24,
                  margin: EdgeInsets.only(
                      top: SizeConfig.pageHorizontalMargins -
                          SizeConfig.padding8),
                  child: Timeline.tileBuilder(
                      shrinkWrap: true,
                      theme: TimelineThemeData(
                        direction: Axis.horizontal,
                        connectorTheme: ConnectorThemeData(
                          space: SizeConfig.screenWidth * 0.05,
                          thickness: SizeConfig.padding4,
                        ),
                      ),
                      physics: NeverScrollableScrollPhysics(),
                      builder: TimelineTileBuilder.connected(
                        connectionDirection: ConnectionDirection.before,
                        itemExtentBuilder: (_, __) =>
                            MediaQuery.of(context).size.width /
                            (_processes.length * 2),
                        indicatorBuilder: (_, index) {
                          var color;
                          var child;
                          if (index == model.fraction) {
                            color = inProgressColor;
                          } else if (index < model.fraction) {
                            color = completeColor;
                            child = Icon(
                              Icons.check,
                              color: Colors.white,
                              size: SizeConfig.padding16,
                            );
                          } else {
                            color = todoColor;
                          }

                          if (index <= model.fraction) {
                            return Stack(
                              children: [
                                CustomPaint(
                                  size: Size(SizeConfig.padding24,
                                      SizeConfig.padding24),
                                  painter: _BezierPainter(
                                    color: color,
                                    drawStart: index > 0,
                                    drawEnd: index < model.fraction,
                                  ),
                                ),
                                DotIndicator(
                                  size: SizeConfig.padding24,
                                  color: color,
                                  child: child,
                                ),
                              ],
                            );
                          } else {
                            return Stack(
                              children: [
                                CustomPaint(
                                  size: Size(SizeConfig.padding16,
                                      SizeConfig.padding16),
                                  painter: _BezierPainter(
                                    color: color,
                                    drawEnd: index < _processes.length - 1,
                                  ),
                                ),
                                Positioned(
                                  left: SizeConfig.padding2,
                                  top: SizeConfig.padding2,
                                  child: OutlinedDotIndicator(
                                    borderWidth: SizeConfig.padding4,
                                    color: color,
                                    size: SizeConfig.padding12,
                                  ),
                                ),
                              ],
                            );
                          }
                        },
                        connectorBuilder: (_, index, type) {
                          if (index > 0) {
                            if (index == model.fraction) {
                              final prevColor = getColor(model, index - 1);
                              final color = getColor(model, index);
                              List<Color> gradientColors;
                              if (type == ConnectorType.start) {
                                gradientColors = [
                                  Color.lerp(prevColor, color, 0.5),
                                  color
                                ];
                              } else {
                                gradientColors = [
                                  prevColor,
                                  Color.lerp(prevColor, color, 0.5)
                                ];
                              }
                              return DecoratedLineConnector(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: gradientColors,
                                  ),
                                ),
                              );
                            } else {
                              return SolidLineConnector(
                                color: getColor(model, index),
                              );
                            }
                          } else {
                            return null;
                          }
                        },
                        itemCount: _processes.length,
                      ))),
            ));
  }
}

class AutosavePerks extends StatelessWidget {
  final String image;
  final String svg;
  final String text;

  AutosavePerks({this.image, @required this.text, this.svg});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: SizeConfig.padding12),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
                // border: Border.all(color: UiConstants.tertiarySolid, width: 1),
                shape: BoxShape.circle,
                color: Colors.white),
            padding: EdgeInsets.all(SizeConfig.padding4),
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
              ),
              child: CircleAvatar(
                backgroundColor: UiConstants.tertiaryLight,
                child: image != null
                    ? Image.asset(
                        image,
                        height: SizeConfig.padding16,
                      )
                    : SvgPicture.asset(
                        svg,
                        height: SizeConfig.padding16,
                      ),
                radius: SizeConfig.padding16,
              ),
            ),
          ),
          SizedBox(height: SizeConfig.padding4),
          Container(
            alignment: Alignment.center,
            child: Text(
              text,
              maxLines: 2,
              textAlign: TextAlign.center,
              style: TextStyles.body4,
            ),
          )
        ],
      ),
    );
  }
}

class SubProcessText extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PropertyChangeConsumer<PaytmService, PaytmServiceProperties>(
      properties: [PaytmServiceProperties.SubscriptionProcess],
      builder: (context, model, property) => Container(
        height: SizeConfig.padding64,
        child: Column(
          children: [
            SpinKitWave(
              color: UiConstants.primaryColor,
              size: SizeConfig.padding24,
            ),
            SizedBox(height: SizeConfig.padding4),
            Text(
              model.processText,
              style: TextStyles.body1.bold,
            ),
          ],
        ),
      ),
    );
  }
}

class SegmentChips extends StatelessWidget {
  final model;
  final String text;

  SegmentChips({this.model, this.text});

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Text(text, style: TextStyles.body3.bold.colour(getBorder())));
  }

  getBorder() {
    if (model.isDaily) {
      if (text == "Daily")
        return Colors.white;
      else
        return Colors.grey;
    } else {
      if (text == "Daily")
        return Colors.grey;
      else
        return Colors.white;
    }
  }
}

/// hardcoded bezier painter
/// TODO: Bezier curve into package component
class _BezierPainter extends CustomPainter {
  const _BezierPainter({
    @required this.color,
    this.drawStart = true,
    this.drawEnd = true,
  });

  final Color color;
  final bool drawStart;
  final bool drawEnd;

  Offset _offset(double radius, double angle) {
    return Offset(
      radius * cos(angle) + radius,
      radius * sin(angle) + radius,
    );
  }

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.fill
      ..color = color;

    final radius = size.width / 2;

    var angle;
    var offset1;
    var offset2;

    var path;

    if (drawStart) {
      angle = 3 * pi / 4;
      offset1 = _offset(radius, angle);
      offset2 = _offset(radius, -angle);
      path = Path()
        ..moveTo(offset1.dx, offset1.dy)
        ..quadraticBezierTo(0.0, size.height / 2, -radius,
            radius) // TODO connector start & gradient
        ..quadraticBezierTo(0.0, size.height / 2, offset2.dx, offset2.dy)
        ..close();

      canvas.drawPath(path, paint);
    }
    if (drawEnd) {
      angle = -pi / 4;
      offset1 = _offset(radius, angle);
      offset2 = _offset(radius, -angle);

      path = Path()
        ..moveTo(offset1.dx, offset1.dy)
        ..quadraticBezierTo(size.width, size.height / 2, size.width + radius,
            radius) // TODO connector end & gradient
        ..quadraticBezierTo(size.width, size.height / 2, offset2.dx, offset2.dy)
        ..close();

      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(_BezierPainter oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.drawStart != drawStart ||
        oldDelegate.drawEnd != drawEnd;
  }
}
