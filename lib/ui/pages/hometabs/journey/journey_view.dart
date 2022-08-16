import 'dart:developer';
import 'dart:ui';

import 'package:felloapp/core/enums/journey_service_enum.dart';
import 'package:felloapp/core/model/journey_models/journey_level_model.dart';
import 'package:felloapp/core/service/journey_service.dart';
import 'package:felloapp/ui/architecture/base_view.dart';
import 'package:felloapp/ui/pages/hometabs/journey/Journey%20page%20elements/jAssetPath.dart';
import 'package:felloapp/ui/pages/hometabs/journey/Journey%20page%20elements/jBackground.dart';
import 'package:felloapp/ui/pages/hometabs/journey/Journey%20page%20elements/jMilestones.dart';
import 'package:felloapp/ui/pages/hometabs/journey/components/journey_appbar/journey_appbar_view.dart';
import 'package:felloapp/ui/pages/hometabs/journey/components/journey_appbar/journey_appbar_vm.dart';
import 'package:felloapp/ui/pages/hometabs/journey/components/journey_banners/journey_banners_view.dart';
import 'package:felloapp/ui/pages/hometabs/journey/journey_vm.dart';
import 'package:felloapp/ui/pages/static/base_animation/base_animation.dart';
import 'package:felloapp/util/preference_helper.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:property_change_notifier/property_change_notifier.dart';

final avatarKey = GlobalKey();

class JourneyView extends StatefulWidget {
  @override
  State<JourneyView> createState() => _JourneyViewState();
}

class _JourneyViewState extends State<JourneyView>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  AppLifecycleState _appLifecycleState;
  JourneyPageViewModel modelInstance;
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    setState(() {
      _appLifecycleState = state;
    });
    modelInstance.checkIfThereIsAMilestoneLevelChange();
    print(_appLifecycleState);
    super.didChangeAppLifecycleState(state);
  }

  @override
  Widget build(BuildContext context) {
    return BaseView<JourneyPageViewModel>(
      onModelReady: (model) async {
        WidgetsBinding.instance?.addObserver(this);
        modelInstance = model;
        await model.init(this);
      },
      onModelDispose: (model) {
        WidgetsBinding.instance?.removeObserver(this);
        model.dump();
      },
      builder: (ctx, model, child) {
        log("Journey View BUILD called");

        return Scaffold(
          backgroundColor: Colors.black,
          floatingActionButton: Container(
            margin: EdgeInsets.only(bottom: 60),
            child: (PreferenceHelper.getInt(AVATAR_CURRENT_LEVEL) != null &&
                    PreferenceHelper.getInt(AVATAR_CURRENT_LEVEL) != 1)
                ? FloatingActionButton(
                    child: const Icon(
                      Icons.replay,
                      color: Colors.white,
                    ),
                    backgroundColor: Colors.black,
                    onPressed: () {
                      PreferenceHelper.setInt(AVATAR_CURRENT_LEVEL, 1);
                    },
                  )
                : SizedBox(),
          ),
          // floatingActionButton: Container(
          //   margin: EdgeInsets.only(bottom: 80, left: 50),
          //   child: FloatingActionButton(
          //       child: Icon(Icons.stop),
          //       onPressed: //model.controller.stop
          //           () {
          //         print(model.journeyRepo());
          //       }),
          // ),
          body: model.isLoading && model.pages == null
              ? Container(
                  width: SizeConfig.screenWidth,
                  height: SizeConfig.screenHeight,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color(0xffB9D1FE),
                        Color(0xffD6E0FF),
                        Color(0xffF1EFFF)
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Lottie.asset("assets/lotties/cat-loader.json",
                          height: SizeConfig.screenWidth / 3),
                      SizedBox(height: 20),
                      Text(
                        'Loading',
                        style:
                            GoogleFonts.josefinSans(fontSize: SizeConfig.body1),
                      )
                    ],
                  ),
                )
              : Stack(
                  children: [
                    SizedBox(
                      height: SizeConfig.screenHeight,
                      width: SizeConfig.screenWidth,
                      child: SingleChildScrollView(
                        controller: model.mainController,
                        physics: const BouncingScrollPhysics(),
                        reverse: true,
                        child: Container(
                          height: model.currentFullViewHeight,
                          width: SizeConfig.screenWidth,
                          // color: Colors.black,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Color(0xffB9D1FE),
                                Color(0xffD6E0FF),
                                Color(0xffF1EFFF)
                              ],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                          ),
                          child: Stack(
                            children: [
                              Background(model: model),
                              ActiveMilestoneBackgroundGlow(),
                              JourneyAssetPath(model: model),
                              if (model.avatarPath != null)
                                Positioned(
                                  bottom: 0,
                                  left: 0,
                                  child: CustomPaint(
                                    size: Size(
                                        model.pageWidth, model.pageHeight * 2),
                                    painter: PathPainter(
                                        model.avatarPath, Colors.transparent),
                                  ),
                                ),
                              ActiveMilestoneBaseGlow(),
                              Milestones(model: model),
                              // ActiveMilestoneFrontGlow(),
                              MilestoneChecks(),
                              Avatar(
                                model: model,
                              ),
                              // LevelBlurView(
                              //   model: model,
                              // )
                            ],
                          ),
                        ),
                      ),
                    ),
                    JourneyAppBar(),
                    JourneyBannersView()
                    // AnimatedPositioned(
                    //   top: (model.isLoading &&
                    //           model.pages != null &&
                    //           model.pages.length > 0)
                    //       ? SizeConfig.pageHorizontalMargins
                    //       : -400,
                    //   duration: Duration(seconds: 1),
                    //   curve: Curves.decelerate,
                    //   left: SizeConfig.pageHorizontalMargins,
                    //   child: SafeArea(
                    //     child: Container(
                    //       width: SizeConfig.screenWidth -
                    //           SizeConfig.pageHorizontalMargins * 2,
                    //       height: SizeConfig.padding80,
                    //       decoration: BoxDecoration(
                    //         borderRadius:
                    //             BorderRadius.circular(SizeConfig.roundness16),
                    //         color: Colors.black54,
                    //       ),
                    //       child: ListTile(
                    //         leading: CircleAvatar(
                    //           backgroundColor: Colors.black,
                    //           radius: SizeConfig.avatarRadius * 2,
                    //           child: SpinKitCircle(
                    //             color: UiConstants.primaryColor,
                    //             size: SizeConfig.avatarRadius * 1.5,
                    //           ),
                    //         ),
                    //         title: Text(
                    //           "Loading",
                    //           style: GoogleFonts.rajdhani(
                    //               fontSize: SizeConfig.title3,
                    //               fontWeight: FontWeight.w800,
                    //               color: Colors.white),
                    //         ),
                    //         subtitle: Text(
                    //           "Loading more levels for you,please wait",
                    //           style: TextStyles.body3.colour(Colors.white),
                    //         ),
                    //       ),
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
        );
      },
    );
  }
}

class LevelBlurView extends StatelessWidget {
  final JourneyPageViewModel model;

  LevelBlurView({this.model});
  @override
  Widget build(BuildContext context) {
    final JourneyLevel levelData = model.getJourneyLevelBlurData();

    return levelData != null
        ? Stack(
            children: [
              Positioned(
                left: 0,
                top: 0,
                child: BlurFilter(
                  child: Container(
                    height: model.pageHeight * (1 - levelData.breakpoint),
                    width: model.pageWidth,
                    alignment: Alignment.bottomCenter,
                  ),
                ),
              ),
              Positioned(
                top: model.pageHeight * (1 - levelData.breakpoint) +
                    SizeConfig.avatarRadius,
                child: Container(
                  width: model.pageWidth,
                  child: Row(
                    children: [
                      Expanded(
                        child: CustomPaint(
                          painter: DottedLinePainter(),
                        ),
                      ),
                      CircleAvatar(
                        radius: SizeConfig.avatarRadius,
                        backgroundColor: Colors.white,
                        child: Icon(Icons.lock,
                            size: SizeConfig.iconSize0, color: Colors.black),
                      ),
                      Expanded(
                        child: CustomPaint(
                          painter: DottedLinePainter(),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          )
        : SizedBox();
  }
}

class DottedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = new Paint()
      ..color = Colors.white
      ..strokeWidth = 1
      ..isAntiAlias = false
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.square;
    final path = Path();
    path.moveTo(0, size.height / 2);
    path.lineTo(size.width, size.height / 2);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

class MilestoneChecks extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PropertyChangeConsumer<JourneyService, JourneyServiceProperties>(
        properties: [JourneyServiceProperties.AvatarPosition],
        builder: (context, model, properties) {
          return SizedBox(
            width: model.pageWidth,
            height: model.pageHeight * 2,
            child: Stack(
              children: List.generate(model.avatarRemoteMlIndex - 1, (i) {
                // if (model.currentMilestoneList.length <
                //     model.avatarRemoteMlIndex)
                return Positioned(
                    left: model.pageWidth * model.currentMilestoneList[i].x,
                    bottom: (model.pageHeight *
                                (model.currentMilestoneList[i].page - 1) +
                            model.pageHeight *
                                model.currentMilestoneList[i].y) -
                        model.pageHeight * 0.02,
                    child: MileStoneCheck(
                        // model: model,
                        milestone: model.currentMilestoneList[i]));
                // else
                //   return SizedBox();
              }),
            ),
          );
        });
  }
}

class Avatar extends StatelessWidget {
  final JourneyPageViewModel model;
  const Avatar({Key key, this.model}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    print(model.avatarPosition);
    return PropertyChangeConsumer<JourneyService, JourneyServiceProperties>(
      properties: [JourneyServiceProperties.AvatarPosition],
      builder: (context, model, properties) {
        return Positioned(
          key: avatarKey,
          // duration: Duration(seconds: 10),
          // curve: Curves.decelerate,
          top: model.avatarPosition.dy,
          left: model.avatarPosition.dx,
          child: const IgnorePointer(
            ignoring: true,
            child: CircleAvatar(
              radius: 25,
              backgroundImage: NetworkImage(
                  "https://w7.pngwing.com/pngs/312/283/png-transparent-man-s-face-avatar-computer-icons-user-profile-business-user-avatar-blue-face-heroes.png"),
            ),
          ),
        );
      },
    );
  }
}

class PathPainter extends CustomPainter {
  Path path;
  final Color color;
  PathPainter(this.path, this.color);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 1.0;

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

class BlurFilter extends StatelessWidget {
  final Widget child;
  final double sigmaX;
  final double sigmaY;
  BlurFilter({this.child, this.sigmaX = 10.0, this.sigmaY = 10.0});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        child,
        ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: sigmaX,
              sigmaY: sigmaY,
            ),
            child: Opacity(
              opacity: 0.01,
              child: child,
            ),
          ),
        ),
      ],
    );
  }
}
