//Project Imports
import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/core/enums/view_state_enum.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/ui/architecture/base_view.dart';
import 'package:felloapp/ui/pages/static/fello_appbar.dart';
import 'package:felloapp/ui/pages/static/home_background.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';

//Dart and Flutter Imports
import 'package:flutter/material.dart';

//Pub Imports
import 'package:rive/rive.dart' as rive;

import 'dailyPicksDraw_viewModel.dart';

class PicksDraw extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BaseView<DailyPicksDrawViewModel>(onModelReady: (model) {
      model.init();
    }, builder: (ctx, model, child) {
      return Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        body: HomeBackground(
          child: Column(
            children: [
              FelloAppBar(
                title: "Daily Picks",
              ),
              Expanded(
                child: Container(
                  // padding: EdgeInsets.symmetric(
                  //     horizontal: SizeConfig.pageHorizontalMargins),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(SizeConfig.padding40),
                      topRight: Radius.circular(SizeConfig.padding40),
                    ),
                    color: Colors.white,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.all(SizeConfig.padding24),
                        child: Text(
                            model.state == ViewState.Idle
                                ? "Today's Picks are:"
                                : "Please wait, loading today's picks",
                            textAlign: TextAlign.center,
                            style: TextStyles.title3.bold),
                      ),
                      Spacer(),
                      model.state == ViewState.Idle
                          ? Container(
                              height: 280,
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
                                    top: model.rowWidth == 0 ? 150 : 0,
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
                                              children:
                                                  (model.todaysPicks ??
                                                          List.filled(3, 0))
                                                      .map(
                                                        (e) =>
                                                            AnimatedContainer(
                                                          curve: Curves.easeIn,
                                                          height: model.radius,
                                                          width: model.radius,
                                                          duration: Duration(
                                                              seconds: 1),
                                                          decoration:
                                                              BoxDecoration(
                                                            color: Colors.black,
                                                            shape:
                                                                BoxShape.circle,
                                                            gradient:
                                                                RadialGradient(
                                                              center: Alignment(
                                                                  -0.8, -0.6),
                                                              colors: [
                                                                Color(
                                                                    0xff515E63),
                                                                Colors.black
                                                              ],
                                                              radius: 1.0,
                                                            ),
                                                          ),
                                                          alignment:
                                                              Alignment.center,
                                                          child:
                                                              Transform.scale(
                                                                  scale: model
                                                                      .opacity,
                                                                  child: Stack(
                                                                      children: [
                                                                        Align(
                                                                          alignment:
                                                                              Alignment.center,
                                                                          child:
                                                                              AnimatedContainer(
                                                                            height:
                                                                                model.ringWidth,
                                                                            width:
                                                                                model.ringWidth,
                                                                            duration:
                                                                                Duration(seconds: 1),
                                                                            curve:
                                                                                Curves.easeIn,
                                                                            decoration:
                                                                                BoxDecoration(
                                                                              border: Border.all(
                                                                                color: Colors.white,
                                                                                width: 0.5,
                                                                              ),
                                                                              borderRadius: BorderRadius.circular(100),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        AnimatedOpacity(
                                                                          duration:
                                                                              Duration(milliseconds: 500),
                                                                          curve:
                                                                              Curves.easeInOutBack,
                                                                          opacity:
                                                                              model.opacity,
                                                                          child:
                                                                              Container(
                                                                            height:
                                                                                model.radius,
                                                                            width:
                                                                                model.radius,
                                                                            alignment:
                                                                                Alignment.center,
                                                                            child: model.showTxt
                                                                                ? FittedBox(
                                                                                    fit: BoxFit.cover,
                                                                                    child: Text(
                                                                                      e.toString() ?? "-",
                                                                                      style: TextStyle(
                                                                                        color: Colors.white,
                                                                                        fontSize: 20,
                                                                                        fontWeight: FontWeight.w700,
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
                            style: TextStyles.body2.light,
                          ),
                        ),
                      SizedBox(height: SizeConfig.padding12),
                      model.showNext
                          ? FloatingActionButton(
                              backgroundColor: UiConstants.primaryColor,
                              child: Icon(
                                Icons.navigate_next_rounded,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                AppState.delegate.appState.currentAction =
                                    PageAction(
                                        state: PageState.replace,
                                        page: TGamePageConfig);
                              },
                            )
                          : SizedBox(),
                      Spacer(flex: 3),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
