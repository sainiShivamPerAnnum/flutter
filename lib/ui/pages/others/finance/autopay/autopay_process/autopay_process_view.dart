import 'dart:io';

import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/architecture/base_view.dart';
import 'package:felloapp/ui/architecture/base_vm.dart';
import 'package:felloapp/ui/pages/others/finance/autopay/autopay_process/autopay_process_vm.dart';
import 'package:felloapp/ui/pages/others/games/tambola/tambola_home/tambola_home_view.dart';
import 'package:felloapp/ui/pages/static/fello_appbar.dart';
import 'package:felloapp/ui/pages/static/home_background.dart';
import 'package:felloapp/ui/widgets/buttons/fello_button/large_button.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
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
                    leading: model.processStatus == STATUS.Pending
                        ? SizedBox()
                        : FelloAppBarBackButton(),
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
                              model.showSetAmountView
                                  ? Colors.white
                                  : model.gradColor,
                            ],
                          ),
                        ),
                        child: ui(model)),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    });
  }

  ui(AutoPayProcessViewModel model) {
    if (model.processStatus == STATUS.Pending && !model.showSetAmountView)
      return pendingUI(model);
    else if (model.processStatus == STATUS.Complete && !model.showSetAmountView)
      return completedUI(model);
    else if (model.processStatus == STATUS.Cancel && !model.showSetAmountView)
      return cancelledUI(model);
    else if (model.showSetAmountView)
      return amountSetUI(model);
    else
      return defaultUI(model);
  }

  pendingUI(AutoPayProcessViewModel model) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
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
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Spacer(),
        Lottie.asset(
          "assets/lotties/complete.json",
          height: SizeConfig.screenWidth / 3,
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
        Spacer(),
        SafeArea(
          child: Container(
            margin: EdgeInsets.symmetric(
              vertical: SizeConfig.viewInsets.bottom != 0
                  ? 0
                  : SizeConfig.pageHorizontalMargins,
            ),
            child: FelloButtonLg(
              child: Text(
                "Set Amount",
                style: TextStyles.body2.bold.colour(Colors.white),
              ),
              onPressed: () {
                model.showSetAmountView = true;
              },
            ),
          ),
        ),
      ],
    );
  }

  cancelledUI(AutoPayProcessViewModel model) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Spacer(),
        Lottie.asset(
          "assets/lotties/cancel.json",
          repeat: false,
          height: SizeConfig.screenWidth / 3,
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
        Spacer(),
        SafeArea(
          child: Container(
            margin: EdgeInsets.symmetric(
              vertical: SizeConfig.viewInsets.bottom != 0
                  ? 0
                  : SizeConfig.pageHorizontalMargins,
            ),
            child: FelloButtonLg(
              child: Text(
                "Try Again",
                style: TextStyles.body2.bold.colour(Colors.white),
              ),
              onPressed: () {
                model.tryAgain();
                // AppState.delegate.appState.currentAction = PageAction(
                //     state: PageState.addPage,
                //     page: AutoPayProcessViewPageConfig);
              },
            ),
          ),
        ),
      ],
    );
  }

  amountSetUI(AutoPayProcessViewModel model) {
    return Column(
      children: [
        SizedBox(height: SizeConfig.screenHeight * 0.1),
        Text(
          "STEP 3/3",
          style: TextStyles.body2.colour(Colors.black26).letterSpace(3),
        ),
        SizedBox(height: SizeConfig.padding24),
        SvgPicture.asset("assets/vectors/addmoney.svg",
            height: SizeConfig.screenHeight * 0.16),
        SizedBox(height: SizeConfig.padding24),
        Text(
          "How much would you like to save each day ?",
          style: TextStyles.title5.bold,
        ),
        SizedBox(height: SizeConfig.padding32),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "₹${sliderValue.toInt()}",
              style: GoogleFonts.sourceSansPro(
                  fontWeight: FontWeight.bold,
                  fontSize: SizeConfig.screenWidth / 4.8,
                  color: Colors.black),
            ),
            Text(
              '/day',
              style: TextStyles.title2
                  .colour(Colors.black38)
                  .light
                  .setHeight(5)
                  .setHeight(4),
            )
          ],
        ),
        Slider(
          value: sliderValue,
          onChanged: (val) {
            updateSliderValue(val);
          },
          inactiveColor: UiConstants.scaffoldColor,
          thumbColor: UiConstants.primaryColor,
          activeColor: UiConstants.primaryColor.withOpacity(0.5),
          min: 10,
          max: 5000,
        ),
        Padding(
          padding: EdgeInsets.symmetric(
              horizontal: SizeConfig.pageHorizontalMargins),
          child: Row(
            children: [
              Text("₹10"),
              Spacer(),
              Text("₹5000"),
            ],
          ),
        ),
        Spacer(),
        SafeArea(
          child: Container(
            margin: EdgeInsets.symmetric(
              vertical: SizeConfig.viewInsets.bottom != 0
                  ? 0
                  : SizeConfig.pageHorizontalMargins,
            ),
            child: FelloButtonLg(
              child: Text(
                "Finish",
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
        )
      ],
    );
  }

  defaultUI(AutoPayProcessViewModel model) {
    return ListLoader();
  }
}
