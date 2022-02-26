import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/architecture/base_view.dart';
import 'package:felloapp/ui/architecture/base_vm.dart';
import 'package:felloapp/ui/pages/others/finance/autopay/autopay_process/autopay_process_vm.dart';
import 'package:felloapp/ui/pages/static/fello_appbar.dart';
import 'package:felloapp/ui/pages/static/home_background.dart';
import 'package:felloapp/ui/widgets/buttons/fello_button/large_button.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class AutoPayProcessView extends StatefulWidget {
  const AutoPayProcessView({Key key}) : super(key: key);

  @override
  State<AutoPayProcessView> createState() => _AutoPayProcessViewState();
}

class _AutoPayProcessViewState extends State<AutoPayProcessView> {
  double sliderValue = 500;

  updateSliderValue(val) {
    setState(() {
      sliderValue = val;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BaseView<AutoPayProcessViewModel>(onModelReady: (model) {
      model.init();
    }, builder: (context, model, child) {
      return Scaffold(
        backgroundColor: UiConstants.primaryColor,
        body: HomeBackground(
          child: Stack(
            children: [
              Column(
                children: [
                  FelloAppBar(
                    leading: FelloAppBarBackButton(),
                    title: "Set up AutoPay",
                  ),
                  Expanded(
                    child: Container(
                      width: SizeConfig.screenWidth,
                      padding: EdgeInsets.symmetric(
                          horizontal: SizeConfig.pageHorizontalMargins),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(SizeConfig.padding40),
                          topRight: Radius.circular(SizeConfig.padding40),
                        ),
                        color: Colors.white,
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.white,
                            Colors.white,
                            model.gradColor,
                          ],
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (model.processStatus == STATUS.Pending)
                            pendingUI(model),
                          if (model.processStatus == STATUS.Complete)
                            completedUI(model),
                          if (model.processStatus == STATUS.Cancel)
                            cancelledUI(model),

                          // Column(
                          //   children: [
                          //     SizedBox(height: SizeConfig.padding32),
                          //     Text(
                          //       "STEP 3/3",
                          //       style: TextStyles.body2
                          //           .colour(Colors.black26)
                          //           .letterSpace(3),
                          //     ),
                          //     SizedBox(height: SizeConfig.padding8),
                          //     Text(
                          //       "How much would you like to save\neach day ?",
                          //       style: TextStyles.title5.bold,
                          //     ),
                          //     SizedBox(height: SizeConfig.padding32),
                          //     Row(
                          //       mainAxisAlignment: MainAxisAlignment.center,
                          //       children: [
                          //         Text(
                          //           "₹${sliderValue.toInt()}",
                          //           style: GoogleFonts.sourceSansPro(
                          //               fontWeight: FontWeight.bold,
                          //               fontSize: SizeConfig.screenWidth / 4.8,
                          //               color: Colors.black),
                          //         ),
                          //         Text(
                          //           '/day',
                          //           style: TextStyles.title2
                          //               .colour(Colors.black38)
                          //               .light
                          //               .setHeight(5)
                          //               .setHeight(4),
                          //         )
                          //       ],
                          //     ),
                          //     Slider(
                          //       value: sliderValue,
                          //       onChanged: (val) {
                          //         updateSliderValue(val);
                          //       },
                          //       inactiveColor: UiConstants.scaffoldColor,
                          //       thumbColor: UiConstants.primaryColor,
                          //       activeColor:
                          //           UiConstants.primaryColor.withOpacity(0.5),
                          //       min: 10,
                          //       max: 5000,
                          //     ),
                          //     Padding(
                          //       padding: EdgeInsets.symmetric(
                          //           horizontal: SizeConfig.pageHorizontalMargins),
                          //       child: Row(
                          //         children: [
                          //           Text("₹10"),
                          //           Spacer(),
                          //           Text("₹5000"),
                          //         ],
                          //       ),
                          //     )
                          //   ],
                          // )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              // Align(
              //   alignment: Alignment.bottomCenter,
              //   child: SafeArea(
              // child: Container(
              //   margin: EdgeInsets.symmetric(
              //       vertical: Platform.isIOS
              //           ? SizeConfig.padding8
              //           : SizeConfig.pageHorizontalMargins,
              //       horizontal: SizeConfig.pageHorizontalMargins),
              //   child: FelloButtonLg(
              //     child: Text(
              //       "Finish",
              //       style: TextStyles.body2.bold.colour(Colors.white),
              //     ),
              //     onPressed: () {
              //       AppState.backButtonDispatcher.didPopRoute();
              //       // AppState.delegate.appState.currentAction = PageAction(
              //       //     state: PageState.addPage,
              //       //     page: AutoPayProcessViewPageConfig);
              //     },
              //   ),
              // ),
              //   ),
              // )
            ],
          ),
        ),
      );
    });
  }

  pendingUI(AutoPayProcessViewModel model) {
    return Column(
      children: [
        Lottie.asset(
          "assets/lotties/pending.json",
          height: SizeConfig.screenWidth / 2,
        ),
        Text(
          "Processing, please wait",
          style: TextStyles.title3.bold,
          textAlign: TextAlign.center,
        ),
        SizedBox(height: SizeConfig.padding8),
        Text(
          "Your UPI AutoPay Setup is in process, please don't press back",
          style: TextStyles.body2,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  completedUI(AutoPayProcessViewModel model) {
    return Column(
      children: [
        Lottie.asset(
          "assets/lotties/complete.json",
          height: SizeConfig.screenWidth / 2,
        ),
        Text(
          "Yayy!",
          style: TextStyles.title3.bold,
          textAlign: TextAlign.center,
        ),
        SizedBox(height: SizeConfig.padding8),
        Text(
          "Your UPI AutoPay Setup was successful!",
          style: TextStyles.body2,
          textAlign: TextAlign.center,
        ),
        SizedBox(height: SizeConfig.padding24),
        Container(
          margin: EdgeInsets.symmetric(
              horizontal: SizeConfig.pageHorizontalMargins),
          child: FelloButtonLg(
            child: Text(
              "Set Amount",
              style: TextStyles.body2.bold.colour(Colors.white),
            ),
            onPressed: () {
              AppState.backButtonDispatcher.didPopRoute();

              // AppState.delegate.appState.currentAction = PageAction(
              //     state: PageState.addPage,
              //     page: AutoPayProcessViewPageConfig);
            },
          ),
        ),
      ],
    );
  }

  cancelledUI(AutoPayProcessViewModel model) {
    return Column(
      children: [
        Lottie.asset(
          "assets/lotties/cancel.json",
          height: SizeConfig.screenWidth / 2,
        ),
        Text(
          "Oh no!",
          style: TextStyles.title3.bold,
          textAlign: TextAlign.center,
        ),
        SizedBox(height: SizeConfig.padding8),
        Text(
          "Your UPI AutoPay Setup was not successful!",
          style: TextStyles.body2,
          textAlign: TextAlign.center,
        ),
        SizedBox(height: SizeConfig.padding24),
        Container(
          margin: EdgeInsets.symmetric(
              horizontal: SizeConfig.pageHorizontalMargins),
          child: FelloButtonLg(
            child: Text(
              "Try Again",
              style: TextStyles.body2.bold.colour(Colors.white),
            ),
            onPressed: () {
              AppState.backButtonDispatcher.didPopRoute();

              // AppState.delegate.appState.currentAction = PageAction(
              //     state: PageState.addPage,
              //     page: AutoPayProcessViewPageConfig);
            },
          ),
        ),
      ],
    );
  }
}
