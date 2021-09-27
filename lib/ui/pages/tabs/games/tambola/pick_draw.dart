//Project Imports
import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/enums/pagestate.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/util/size_config.dart';

//Dart and Flutter Imports
import 'package:flutter/material.dart';

//Pub Imports
import 'package:provider/provider.dart';
import 'package:rive/rive.dart' as rive;

class PicksDraw extends StatefulWidget {
  @override
  _PicksDrawState createState() => _PicksDrawState();
}

class _PicksDrawState extends State<PicksDraw> {
  double radius = 0;
  double rowWidth = 0;
  double opacity = 0;
  double textPos = -10;
  bool showTxt = false;
  double ringWidth = 0;
  BaseUtil baseProvider;

  showPicksDraw() {
    setState(() {
      radius = SizeConfig.screenWidth * 0.14;
      rowWidth = SizeConfig.screenWidth;
      ringWidth = SizeConfig.screenWidth * 0.1;
      opacity = 1;
    });
  }

  showText() {
    setState(() {
      showTxt = true;
      textPos = 0;
    });
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Future.delayed(Duration(seconds: 1), () {
        showPicksDraw();
      }).then((_) {
        Future.delayed(Duration(seconds: 1), () {
          showText();
        }).then((value) {
          // FOR AUTOMATICALLY REPLACING THIS SCREEN WITH THE TAMBOLA HOME SCREEN

          // Future.delayed(Duration(seconds: 2), () {
          //   delegate.appState.currentAction =
          //       PageAction(state: PageState.replace, page: THomePageConfig);
          // });
        });
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    baseProvider = Provider.of<BaseUtil>(context);
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: showTxt
          ? FloatingActionButton(
              backgroundColor: Colors.white,
              child: Icon(
                Icons.navigate_next_rounded,
                color: Color(0xff150E56),
              ),
              onPressed: () {
                AppState.delegate.appState.currentAction =
                    PageAction(state: PageState.replace, page: THomePageConfig);
              },
            )
          : SizedBox(),
      body: Container(
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("images/Tambola/tranbg.png"),
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.circular(12),
                gradient: LinearGradient(
                  colors: [Color(0xff34C3A7), Color(0xff4AB474)],
                  begin: Alignment.bottomRight,
                  end: Alignment.topLeft,
                ),
              ),
            ),
            SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    width: SizeConfig.screenWidth,
                    height: kToolbarHeight * 2,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          "images/fello-dark.png",
                          height: kToolbarHeight,
                        ),
                      ],
                    ),
                  ),
                  Spacer(flex: 1),
                  Padding(
                    padding: EdgeInsets.all(16),
                    child: Text(
                      "Today's Picks are:",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: SizeConfig.cardTitleTextSize * 1.2,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  Container(
                    height: 250,
                    width: SizeConfig.screenWidth,
                    margin: EdgeInsets.symmetric(
                        vertical: SizeConfig.screenHeight * 0.05),
                    child: Stack(
                      children: [
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            height: 180,
                            width: 180,
                            child: rive.RiveAnimation.asset(
                              "images/Tambola/openbox.riv",
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 28,
                          left: SizeConfig.screenWidth / 2,
                          child: Image.asset(
                            "images/fello-dark.png",
                            height: 30,
                          ),
                        ),
                        AnimatedPositioned(
                          duration: Duration(seconds: 1),
                          //curve: Curves.decelerate,
                          top: rowWidth == 0 ? 120 : 0,
                          child: Container(
                            width: SizeConfig.screenWidth,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                AnimatedContainer(
                                  alignment: Alignment.topCenter,
                                  width: rowWidth,
                                  duration: Duration(seconds: 1),
                                  curve: Curves.easeIn,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: (baseProvider.todaysPicks ??
                                            List.filled(
                                                baseProvider.dailyPicksCount,
                                                0))
                                        .map(
                                          (e) => AnimatedContainer(
                                            curve: Curves.easeIn,
                                            height: radius,
                                            width: radius,
                                            duration: Duration(seconds: 1),
                                            decoration: BoxDecoration(
                                              color: Colors.black,
                                              shape: BoxShape.circle,
                                              gradient: RadialGradient(
                                                center: Alignment(-0.8, -0.6),
                                                colors: [
                                                  Color(0xff515E63),
                                                  Colors.black
                                                ],
                                                radius: 1.0,
                                              ),
                                            ),
                                            alignment: Alignment.center,
                                            child: Transform.scale(
                                                scale: opacity,
                                                child: Stack(children: [
                                                  Align(
                                                    alignment: Alignment.center,
                                                    child: AnimatedContainer(
                                                      height: ringWidth,
                                                      width: ringWidth,
                                                      duration:
                                                          Duration(seconds: 1),
                                                      curve: Curves.easeIn,
                                                      decoration: BoxDecoration(
                                                        border: Border.all(
                                                          color: Colors.white,
                                                          width: 0.5,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(100),
                                                      ),
                                                    ),
                                                  ),
                                                  AnimatedOpacity(
                                                    duration: Duration(
                                                        milliseconds: 500),
                                                    curve: Curves.easeInOutBack,
                                                    opacity: opacity,
                                                    child: Container(
                                                      height: radius,
                                                      width: radius,
                                                      alignment:
                                                          Alignment.center,
                                                      child: showTxt
                                                          ? FittedBox(
                                                              fit: BoxFit.cover,
                                                              child: Text(
                                                                e.toString() ??
                                                                    "-",
                                                                style:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize: 20,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w700,
                                                                ),
                                                              ),
                                                            )
                                                          : SizedBox(),
                                                    ),
                                                  ),
                                                ])),
                                          ),
                                        )
                                        .toList(),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: SizeConfig.blockSizeHorizontal * 10),
                    child: Text(
                      "Find out how many numbers matched today..",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        letterSpacing: 2,
                        fontSize: SizeConfig.largeTextSize,
                      ),
                    ),
                  ),
                  Spacer(flex: 3),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
