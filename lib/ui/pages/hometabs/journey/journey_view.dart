import 'dart:developer';
import 'dart:ui';

import 'package:felloapp/core/enums/journey_service_enum.dart';
import 'package:felloapp/core/model/journey_models/avatar_path_model.dart';
import 'package:felloapp/core/service/journey_service.dart';
import 'package:felloapp/ui/architecture/base_view.dart';
import 'package:felloapp/ui/pages/hometabs/journey/Journey%20page%20elements/jAssetPath.dart';
import 'package:felloapp/ui/pages/hometabs/journey/Journey%20page%20elements/jBackground.dart';
import 'package:felloapp/ui/pages/hometabs/journey/Journey%20page%20elements/jMilestones.dart';
import 'package:felloapp/ui/pages/hometabs/journey/journey_vm.dart';
import 'package:felloapp/util/journey_page_data.dart';
import 'package:felloapp/util/preference_helper.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:property_change_notifier/property_change_notifier.dart';

final avatarKey = GlobalKey();

class JourneyView extends StatefulWidget {
  @override
  State<JourneyView> createState() => _JourneyViewState();
}

class _JourneyViewState extends State<JourneyView>
    with SingleTickerProviderStateMixin {
  Path generateCustomPath(Path path, AvatarPathModel model, String moveType) {
    switch (moveType) {
      case "linear":
        path.lineTo(
            SizeConfig.screenWidth * model.coords[0],
            (2 - model.page) * SizeConfig.screenWidth * 2.165 +
                SizeConfig.screenWidth * 2.165 * model.coords[1].toDouble());
        return path;
      case "arc":
        return path;
      case "move":
        path.moveTo(
            SizeConfig.screenWidth * model.coords[0],
            (2 - model.page) * SizeConfig.screenWidth * 2.165 +
                SizeConfig.screenWidth * 2.165 * model.coords[1]);
        return path;
      case "rect":
        return path;
      case "quadratic":
        // path.quadraticBezierTo(
        //     pageWidth * model.coords[0],
        //     pageHeight * (pageCount - model.page).abs() +
        //         pageHeight * model.coords[1],
        //     pageWidth * model.coords[2],
        //     pageHeight * (pageCount - model.page).abs() +
        //         pageHeight * model.coords[3]);
        return path;
      case "cubic":
        // path.cubicTo(
        //     pageWidth * model.coords[0],
        //     pageHeight * (pageCount - model.page).abs() +
        //         pageHeight * model.coords[1],
        //     pageWidth * model.coords[2],
        //     pageHeight * (pageCount - model.page).abs() +
        //         pageHeight * model.coords[3],
        //     pageWidth * model.coords[4],
        //     pageHeight * (pageCount - model.page).abs() +
        //         pageHeight * model.coords[5]);
        return path;
      default:
        return path;
    }
  }

  @override
  Widget build(BuildContext context) {
    log("Journey View BUILD called");
    return BaseView<JourneyPageViewModel>(
      onModelReady: (model) async {
        // await model.init(0);
        model.controller = AnimationController(
            vsync: this,
            duration: const Duration(seconds: 4),
            animationBehavior: AnimationBehavior.preserve);
        model.tempInit();
      },
      onModelDispose: (model) {
        model.dump();
      },
      builder: (ctx, model, child) {
        List<AvatarPathModel> avatarPath = [
          // AvatarPathModel(
          //     moveType: "linear", coords: [0.53, 0.63], page: 1, mlIndex: 1),
          // AvatarPathModel(
          //     moveType: "linear", coords: [0.4, 0.5], page: 1, mlIndex: 2),
          // AvatarPathModel(
          //     moveType: "linear", coords: [0.2, 0.45], page: 1, mlIndex: 2),
          // AvatarPathModel(
          //     moveType: "linear", coords: [0.73, 0.31], page: 1, mlIndex: 3),
          // AvatarPathModel(
          //     moveType: "linear", coords: [0.5, 0.22], page: 1, mlIndex: 3),
          // AvatarPathModel(
          //     moveType: "linear", coords: [0.32, 0.1], page: 1, mlIndex: 4),
          // AvatarPathModel(
          //     moveType: "linear", coords: [0.18, 0.06], page: 1, mlIndex: 4),
          // AvatarPathModel(
          //     moveType: "linear", coords: [0.3, 0.02], page: 1, mlIndex: 5),
          // AvatarPathModel(
          //     moveType: "linear", coords: [0.5, 0.9], page: 2, mlIndex: 5),
          AvatarPathModel(
              moveType: "linear", coords: [0.65, 0.86], page: 2, mlIndex: 5),
          AvatarPathModel(
              moveType: "linear", coords: [0.12, 0.78], page: 2, mlIndex: 6),
          AvatarPathModel(
              moveType: "linear", coords: [0.65, 0.6], page: 2, mlIndex: 6),
          // AvatarPathModel(
          //     moveType: "linear", coords: [0.7, 0.03], page: 1, mlIndex: 7),
          // AvatarPathModel(
          //     moveType: "linear", coords: [0.58, 0.0], page: 1, mlIndex: 7),
        ];
        model.createAvatarPath(avatarPath);
        model.tempReadyAvatarToPath();
        return Scaffold(
          backgroundColor: Colors.black,
          // floatingActionButton: Container(
          //   margin: EdgeInsets.only(bottom: 60),
          //   child: (PreferenceHelper.getInt(AVATAR_CURRENT_LEVEL) != null &&
          //           PreferenceHelper.getInt(AVATAR_CURRENT_LEVEL) != 1)
          //       ? FloatingActionButton(
          //           child: const Icon(
          //             Icons.replay,
          //             color: Colors.white,
          //           ),
          //           backgroundColor: Colors.black,
          //           onPressed: () {
          //             PreferenceHelper.setInt(AVATAR_CURRENT_LEVEL, 1);
          //           },
          //         )
          //       : SizedBox(),
          // ),
          floatingActionButton: Container(
            margin: EdgeInsets.only(bottom: 80, left: 50),
            child: Row(
              children: [
                FloatingActionButton(
                    child: Icon(Icons.stop), onPressed: model.controller.stop),
                SizedBox(width: 20),
                FloatingActionButton(
                    child: Icon(Icons.animation), onPressed: model.tempAnimate),
              ],
            ),
          ),
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
                              ActiveMilestoneBackgroundGlow(
                                radius: SizeConfig.screenWidth * 0.5,
                                model: model,
                                asset: model.journeyPathItemsList.firstWhere(
                                    (element) =>
                                        element.mlIndex == 5 && element.isBase),
                              ),
                              JourneyAssetPath(model: model),

                              if (model.avatarPath != null)
                                Positioned(
                                  bottom: 0,
                                  left: 0,
                                  child: CustomPaint(
                                    size: Size(model.pageWidth,
                                        model.pageHeight * model.pageCount),
                                    painter: PathPainter(
                                        model.avatarPath, Colors.red),
                                  ),
                                ),
                              ActiveMilestoneBaseGlow(
                                model: model,
                                base: model.journeyPathItemsList.firstWhere(
                                    (element) =>
                                        element.mlIndex == 5 && element.isBase),
                                color: UiConstants.primaryColor,
                              ),
                              Milestones(model: model),
                              // ActiveMilestoneFrontGlow(
                              //   milestone: model.currentMilestoneList
                              //       .firstWhere(
                              //           (element) => element.index == 2),
                              //   model: model,
                              // )
                              Avatar(
                                model: model,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
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
