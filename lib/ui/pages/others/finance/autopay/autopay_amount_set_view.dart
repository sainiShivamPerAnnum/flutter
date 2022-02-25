import 'dart:io';

import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/ui/pages/static/fello_appbar.dart';
import 'package:felloapp/ui/pages/static/home_background.dart';
import 'package:felloapp/ui/widgets/buttons/fello_button/large_button.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class AutoPayAmountSetView extends StatefulWidget {
  const AutoPayAmountSetView({Key key}) : super(key: key);

  @override
  State<AutoPayAmountSetView> createState() => _AutoPayAmountSetViewState();
}

class _AutoPayAmountSetViewState extends State<AutoPayAmountSetView> {
  double sliderValue = 500;

  updateSliderValue(val) {
    setState(() {
      sliderValue = val;
    });
  }

  @override
  Widget build(BuildContext context) {
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
                    padding: EdgeInsets.symmetric(
                        horizontal: SizeConfig.pageHorizontalMargins),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(SizeConfig.padding40),
                        topRight: Radius.circular(SizeConfig.padding40),
                      ),
                      color: Colors.white,
                    ),
                    child: ListView(
                      children: [
                        Container(
                          width: SizeConfig.screenWidth,
                          padding: EdgeInsets.only(
                              right: SizeConfig.pageHorizontalMargins,
                              bottom: SizeConfig.pageHorizontalMargins,
                              left: SizeConfig.pageHorizontalMargins),
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.circular(SizeConfig.roundness32),
                            color: UiConstants.tertiaryLight,
                          ),
                          child: Column(
                            children: [
                              Lottie.asset(
                                "assets/lotties/completed.json",
                                height: SizeConfig.screenWidth / 4.8,
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
                            ],
                          ),
                        ),
                        SizedBox(height: SizeConfig.padding32),
                        Text(
                          "STEP 3/3",
                          style: TextStyles.body2
                              .colour(Colors.black26)
                              .letterSpace(3),
                        ),
                        SizedBox(height: SizeConfig.padding8),
                        Text(
                          "How much would you like to save\neach day ?",
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
                          activeColor:
                              UiConstants.primaryColor.withOpacity(0.5),
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
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: SafeArea(
                child: Container(
                  margin: EdgeInsets.symmetric(
                      vertical: Platform.isIOS
                          ? SizeConfig.padding8
                          : SizeConfig.pageHorizontalMargins,
                      horizontal: SizeConfig.pageHorizontalMargins),
                  child: FelloButtonLg(
                    child: Text(
                      "Finish",
                      style: TextStyles.body2.bold.colour(Colors.white),
                    ),
                    onPressed: () {
                      AppState.backButtonDispatcher.didPopRoute();
                      // AppState.delegate.appState.currentAction = PageAction(
                      //     state: PageState.addPage,
                      //     page: AutoPayAmountSetViewPageConfig);
                    },
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
