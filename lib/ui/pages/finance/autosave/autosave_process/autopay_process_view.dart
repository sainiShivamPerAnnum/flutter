import 'package:felloapp/core/enums/view_state_enum.dart';
import 'package:felloapp/core/service/analytics/analytics_service.dart';
import 'package:felloapp/core/service/subscription_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/architecture/base_view.dart';
import 'package:felloapp/ui/pages/finance/autosave/autosave_process/autopay_process_slides/autopay_setup_view.dart';
import 'package:felloapp/ui/pages/finance/autosave/autosave_process/autopay_process_slides/autopay_upi_app-select_view.dart';
import 'package:felloapp/ui/pages/finance/autosave/autosave_process/autopay_process_vm.dart';
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
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
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
    return Selector<SubService, AutosaveState>(
      selector: (_, _subService) => _subService.autosaveState,
      builder: (context, autosaveState, child) =>
          BaseView<AutosaveProcessViewModel>(
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
                        child: autosaveState == AutosaveState.INIT
                            ? _buildPendingUI(model)
                            : autosaveState == AutosaveState.IDLE
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
                                            model.pageController.animateToPage(
                                                1,
                                                duration: Duration(seconds: 1),
                                                curve: Curves.decelerate);
                                          }),
                                      AutoPaySetupOrUpdateView(
                                        isSetup: true,
                                        onCtaTapped: (_) async {
                                          Haptic.vibrate();
                                          await model.createSubscription();
                                        },
                                        isDaily: model.isDaily,
                                        onChipsTapped: (int val) {
                                          FocusScope.of(context).unfocus();
                                          Haptic.vibrate();
                                          model.amountFieldController.text =
                                              val.toString();
                                          model.notifyListeners();
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
                                        weeklyChips: model.weeklyChips,
                                      ),
                                      // _buildPendingUI(model),
                                      // Center(
                                      //   child: Text(locale.cancelledUi,
                                      //       style:
                                      //           TextStyles.rajdhaniSB.title4),
                                      // ),
                                    ],
                                  )
                                : autosaveState == AutosaveState.ACTIVE
                                    ? _buildCompleteUI(model)
                                    : SizedBox(
                                        child: Text(
                                          "Autosave Active",
                                          style: TextStyles.body2
                                              .colour(Colors.white),
                                        ),
                                      ),
                      ),
                      // FutureBuilder(
                      //   future: Future.value(true),
                      //   builder:
                      //       (BuildContext context, AsyncSnapshot<void> snap) {
                      //     //If we do not have data as we wait for the future to complete,
                      //     //show any widget, eg. empty Container
                      //     if (!snap.hasData) {
                      //       return Container();
                      //     }

                      //     //Otherwise the future completed, so we can now safely use the controller.page
                      //     if (model.pageController.page == 2)
                      //       return CustomKeyboardSubmitButton(onSubmit: () {});
                      //     else
                      //       return SizedBox();
                      //   },
                      // ),
                    ],
                  ),
          );
        },
      ),
    );
  }

  Widget _buildPendingUI(AutosaveProcessViewModel model) {
    S locale = S.of(context);
    final AnalyticsService? _analyticService = locator<AnalyticsService>();
    return Container(
      width: SizeConfig.screenWidth,
      child: Column(
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
            "Request Pending",
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
          Expanded(
              child: Center(
            child: LottieBuilder.asset(
              "assets/lotties/loader.json",
              width: SizeConfig.screenWidth! * 0.5,
            ),
          )),
          Text(
            "We'll notify you once your autosave is confirmed",
            style: TextStyles.sourceSansL.body4.colour(Colors.amber),
          ),
          SizedBox(
            height: SizeConfig.pageHorizontalMargins,
          ),
        ],
      ),
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
