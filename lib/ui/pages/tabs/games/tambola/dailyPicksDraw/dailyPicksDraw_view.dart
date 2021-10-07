//Project Imports
import 'package:felloapp/core/enums/pagestate.dart';
import 'package:felloapp/core/enums/view_state.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/ui/architecture/base_view.dart';
import 'package:felloapp/ui/pages/tabs/games/tambola/dailyPicksDraw/dailyPicksDraw_viewModel.dart';
import 'package:felloapp/util/styles/size_config.dart';

//Dart and Flutter Imports
import 'package:flutter/material.dart';

//Pub Imports
import 'package:rive/rive.dart' as rive;

class PicksDraw extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BaseView<DailyPicksDrawViewModel>(onModelReady: (model) {
      model.init();
    }, builder: (ctx, model, child) {
      return Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: model.showTxt
            ? FloatingActionButton(
                backgroundColor: Colors.white,
                child: Icon(
                  Icons.navigate_next_rounded,
                  color: Color(0xff150E56),
                ),
                onPressed: () {
                  AppState.delegate.appState.currentAction = PageAction(
                      state: PageState.replace, page: THomePageConfig);
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
                        model.state == ViewState.Idle
                            ? "Today's Picks are:"
                            : "Please wait, loading today's picks",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: SizeConfig.cardTitleTextSize * 1.2,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    model.state == ViewState.Idle
                        ? Container(
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
                                      // controllers: [model.boxController],
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
                                  top: model.rowWidth == 0 ? 120 : 0,
                                  child: Container(
                                    width: SizeConfig.screenWidth,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        AnimatedContainer(
                                          alignment: Alignment.topCenter,
                                          width: model.rowWidth,
                                          duration: Duration(seconds: 1),
                                          curve: Curves.easeIn,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: (model.todaysPicks ??
                                                    List.filled(3, 0))
                                                .map(
                                                  (e) => AnimatedContainer(
                                                    curve: Curves.easeIn,
                                                    height: model.radius,
                                                    width: model.radius,
                                                    duration:
                                                        Duration(seconds: 1),
                                                    decoration: BoxDecoration(
                                                      color: Colors.black,
                                                      shape: BoxShape.circle,
                                                      gradient: RadialGradient(
                                                        center: Alignment(
                                                            -0.8, -0.6),
                                                        colors: [
                                                          Color(0xff515E63),
                                                          Colors.black
                                                        ],
                                                        radius: 1.0,
                                                      ),
                                                    ),
                                                    alignment: Alignment.center,
                                                    child: Transform.scale(
                                                        scale: model.opacity,
                                                        child: Stack(children: [
                                                          Align(
                                                            alignment: Alignment
                                                                .center,
                                                            child:
                                                                AnimatedContainer(
                                                              height: model
                                                                  .ringWidth,
                                                              width: model
                                                                  .ringWidth,
                                                              duration:
                                                                  Duration(
                                                                      seconds:
                                                                          1),
                                                              curve:
                                                                  Curves.easeIn,
                                                              decoration:
                                                                  BoxDecoration(
                                                                border:
                                                                    Border.all(
                                                                  color: Colors
                                                                      .white,
                                                                  width: 0.5,
                                                                ),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            100),
                                                              ),
                                                            ),
                                                          ),
                                                          AnimatedOpacity(
                                                            duration: Duration(
                                                                milliseconds:
                                                                    500),
                                                            curve: Curves
                                                                .easeInOutBack,
                                                            opacity:
                                                                model.opacity,
                                                            child: Container(
                                                              height:
                                                                  model.radius,
                                                              width:
                                                                  model.radius,
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              child: model
                                                                      .showTxt
                                                                  ? FittedBox(
                                                                      fit: BoxFit
                                                                          .cover,
                                                                      child:
                                                                          Text(
                                                                        e.toString() ??
                                                                            "-",
                                                                        style:
                                                                            TextStyle(
                                                                          color:
                                                                              Colors.white,
                                                                          fontSize:
                                                                              20,
                                                                          fontWeight:
                                                                              FontWeight.w700,
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
                          )
                        : SizedBox(),
                    if (model.state == ViewState.Idle)
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
    });
  }
}
