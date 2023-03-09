import 'dart:developer';

import 'package:felloapp/core/enums/view_state_enum.dart';
import 'package:felloapp/core/service/analytics/analytics_service.dart';
import 'package:felloapp/core/service/subscription_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/architecture/base_view.dart';
import 'package:felloapp/ui/pages/finance/autopay/autopay_process/autopay_process_views/autopay_setup_view.dart';
import 'package:felloapp/ui/pages/finance/autopay/autopay_process/autopay_process_views/autopay_upi_app-select_view.dart';
import 'package:felloapp/ui/pages/finance/autopay/autopay_process/autopay_process_vm.dart';
import 'package:felloapp/ui/pages/static/app_widget.dart';
import 'package:felloapp/ui/pages/static/loader_widget.dart';
import 'package:felloapp/ui/pages/static/new_square_background.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/haptic.dart';
import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:upi_pay/upi_pay.dart';

class AutosaveProcessView extends StatefulWidget {
  const AutosaveProcessView({Key? key}) : super(key: key);

  @override
  State<AutosaveProcessView> createState() => _AutosaveProcessViewState();
}

class _AutosaveProcessViewState extends State<AutosaveProcessView> {
  @override
  Widget build(BuildContext context) {
    S locale = S.of(context);
    return BaseView<AutosaveProcessViewModel>(
      onModelReady: (model) => model.init(),
      onModelDispose: (model) => model.dump(),
      builder: (context, model, child) {
        return Scaffold(
          backgroundColor: UiConstants.kBackgroundColor,
          appBar: AppBar(
            backgroundColor: UiConstants.kBackgroundColor,
            elevation: 0.0,
            title: model.currentPage <= 2
                ? Text(
                    "${model.currentPage + 1}/3",
                    style: TextStyles.sourceSansL.body3,
                  )
                : Container(),
            centerTitle: true,
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back_ios,
                color: UiConstants.kTextColor,
              ),
              onPressed: () => AppState.backButtonDispatcher!.didPopRoute(),
            ),
            actions: [],
          ),
          resizeToAvoidBottomInset: false,
          body: model.state == ViewState.Busy
              ? Center(
                  child: FullScreenLoader(),
                )
              : Stack(
                  children: [
                    const NewSquareBackground(),
                    SafeArea(
                      child: model.autosaveState == AutosaveState.INIT
                          ? Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  CircularProgressIndicator.adaptive(),
                                  Text(
                                      "Your Autosave is progress, come back later.")
                                ],
                              ),
                            )
                          : model.autosaveState == AutosaveState.IDLE
                              ? PageView(
                                  controller: model.pageController,
                                  physics: NeverScrollableScrollPhysics(),
                                  children: [
                                    UpiAppSelectView(
                                        appList: model.appsList,
                                        onAppSelect: (ApplicationMeta app) {
                                          Haptic.vibrate();
                                          model.selectedUpiApp = app;
                                        },
                                        selectedApp: model.selectedUpiApp,
                                        onCtaPressed: () {
                                          model.pageController.animateToPage(1,
                                              duration: Duration(seconds: 1),
                                              curve: Curves.decelerate);
                                        }),
                                    AutoPaySetupOrUpdateView(
                                        isSetup: true,
                                        onCtaTapped: (_) {
                                          model.createSubscription();
                                        },
                                        isDaily: model.isDaily,
                                        onAmountValueChanged: (val) {
                                          model.amountFieldController.text =
                                              val.toString();
                                          model.notifyListeners();
                                        },
                                        onChipsTapped: (int val) {
                                          FocusScope.of(context).unfocus();
                                          Haptic.vibrate();
                                          model.amountFieldController.text =
                                              val.toString();
                                        },
                                        onFrequencyTapped: (FREQUENCY freq) {
                                          Haptic.vibrate();
                                          if (freq == FREQUENCY.daily)
                                            model.isDaily = true;
                                          else
                                            model.isDaily = false;
                                        },
                                        amountFieldController:
                                            model.amountFieldController,
                                        dailyChips: model.dailyChips,
                                        weeklyChips: model.weeklyChips),
                                    _buildPendingUI(model),
                                    _buildCompleteUI(model),
                                    Center(
                                      child: Text(locale.cancelledUi,
                                          style: TextStyles.rajdhaniSB.title4),
                                    ),
                                  ],
                                )
                              : SizedBox(
                                  child: Text(
                                    "Autosave Active",
                                    style:
                                        TextStyles.body2.colour(Colors.white),
                                  ),
                                ),
                    ),
                    FutureBuilder(
                      future: Future.value(true),
                      builder:
                          (BuildContext context, AsyncSnapshot<void> snap) {
                        //If we do not have data as we wait for the future to complete,
                        //show any widget, eg. empty Container
                        if (!snap.hasData) {
                          return Container();
                        }

                        //Otherwise the future completed, so we can now safely use the controller.page
                        if (model.pageController.page == 2)
                          return CustomKeyboardSubmitButton(onSubmit: () {});
                        else
                          return SizedBox();
                      },
                    ),
                  ],
                ),
        );
      },
    );
  }

  Widget _buildPendingUI(AutosaveProcessViewModel model) {
    S locale = S.of(context);
    final AnalyticsService? _analyticService = locator<AnalyticsService>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(
          height: SizeConfig.screenWidth! * 0.12,
        ),
        Text(
          locale.setUpAutoSave,
          style: TextStyles.sourceSans.body3.setOpacity(0.5),
        ),
        SizedBox(
          height: SizeConfig.padding10,
        ),
        Text(
          locale.autoPayApproveReq,
          style: TextStyles.rajdhaniSB.title4,
        ),
        SizedBox(
          height: SizeConfig.screenWidth! * 0.1,
        ),

        SizedBox(
          height: SizeConfig.padding32,
        ),
        Text(
          locale.txnApprovePaymentReq,
          style: TextStyles.sourceSans.body1,
          textAlign: TextAlign.center,
        ),
        Spacer(),
        Text(
          locale.txnDontPressBack,
          style: TextStyles.sourceSansL.body4.colour(Colors.red),
        ),
        SizedBox(
          height: SizeConfig.padding24,
        ),
        // if (model.showAppLaunchButton && PlatformUtils.isAndroid)

        SizedBox(
          height: SizeConfig.padding24,
        ),
        // if (model.pageController != null && model.pageController.page == 1.0)
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              locale.txnPageExpiresIn,
              style: TextStyles.sourceSansL.body4,
            ),
            TweenAnimationBuilder<Duration>(
              duration: Duration(minutes: 8),
              tween: Tween(begin: Duration(minutes: 8), end: Duration.zero),
              onEnd: () {
                log('Timer ended');
              },
              builder: (BuildContext context, Duration value, Widget? child) {
                final minutes = value.inMinutes;
                final seconds = value.inSeconds % 60;
                return Text(
                  " ${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}s",
                  style: TextStyles.sourceSans.body4,
                );
              },
            ),
          ],
        ),
        SizedBox(
          height: SizeConfig.padding32,
        ),
      ],
    );
  }

  // String getUpiAppName(AutosaveProcessViewModel model) {
  //   final String upi = model.vpaController.text.split('@').last;
  //   switch (upi) {
  //     case 'upi':
  //       return 'BHIM';
  //     case 'paytm':
  //       return "Paytm";
  //     case 'ybl':
  //       return "PhonePe";
  //     case 'ibl':
  //       return "PhonePe";
  //     case 'axl':
  //       return "PhonePe";
  //     case 'okhdfcbank':
  //       return "Google Pay";
  //     case 'okaksix':
  //       return "Google Pay";
  //     case 'apl':
  //       return "Amazon Pay";
  //     case 'indus':
  //       return "BHIM Indus Pay";
  //     case 'boi':
  //       return "BHIM BOI UPI";
  //     case 'cnrb':
  //       return "BHIM Canara";
  //     default:
  //       return "preferred UPI App";
  //   }
  // }

  Widget _buildCompleteUI(AutosaveProcessViewModel model) {
    S locale = S.of(context);
    return Container(
      height: SizeConfig.screenHeight,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            height: SizeConfig.padding20,
          ),
          Image.asset(
            Assets.completeCheck,
            width: SizeConfig.screenWidth! * 0.5333,
            height: SizeConfig.screenWidth! * 0.5333,
          ),
          SizedBox(
            height: SizeConfig.padding10,
          ),
          Text(
            locale.congrats,
            style: TextStyles.rajdhaniSB.title1,
          ),
          SizedBox(
            height: SizeConfig.padding8,
          ),
          Text(
            locale.autoSaveSetUpSuccess,
            style: TextStyles.sourceSans.body2,
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: SizeConfig.padding32,
          ),
          Container(
            margin: EdgeInsets.symmetric(
              horizontal: SizeConfig.padding24,
            ),
            padding: EdgeInsets.symmetric(vertical: SizeConfig.padding40),
            width: double.infinity,
            // height: 157,
            decoration: BoxDecoration(
              color: Color(0xFF57A6B0).withOpacity(0.22),
              borderRadius: BorderRadius.circular(SizeConfig.roundness12),
              border: Border.all(
                color: UiConstants.kTextColor.withOpacity(0.1),
                width: SizeConfig.border1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // SizedBox(
                    //   width: SizeConfig.padding40,
                    // ),
                    Container(
                      width: SizeConfig.screenWidth! * 0.05866,
                      height: SizeConfig.screenWidth! * 0.05866,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius:
                            BorderRadius.circular(SizeConfig.roundness24),
                      ),
                      child: Center(
                        child: SvgPicture.asset(
                          Assets.upiIcon,
                          width: SizeConfig.screenWidth! * 0.032,
                          height: SizeConfig.screenWidth! * 0.032,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: SizeConfig.padding12,
                    ),
                  ],
                ),
                SizedBox(
                  height: SizeConfig.padding12,
                ),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: "₹${model.amountFieldController.text}/",
                        style: TextStyles.rajdhaniB
                            .size(SizeConfig.screenWidth! * 0.1067),
                      ),
                      TextSpan(
                        text: "${model.isDaily ? locale.daily : locale.weekly}",
                        style: TextStyles.sourceSansSB.body1.setOpacity(0.5),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Spacer(),
          Container(
            color: UiConstants.kBackgroundColor,
            padding: EdgeInsets.all(SizeConfig.pageHorizontalMargins),
            child: AppPositiveBtn(
              btnText: locale.obDone,
              width: SizeConfig.screenWidth! -
                  SizeConfig.pageHorizontalMargins * 2,
              onPressed: () {
                AppState.backButtonDispatcher!.didPopRoute();
              },
            ),
          )
        ],
      ),
    );
  }
}
