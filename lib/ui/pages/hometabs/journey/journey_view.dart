import 'dart:ui';

import 'package:felloapp/ui/architecture/base_view.dart';
import 'package:felloapp/ui/pages/hometabs/journey/Journey%20page%20elements/jAssetPath.dart';
import 'package:felloapp/ui/pages/hometabs/journey/Journey%20page%20elements/jBackground.dart';
import 'package:felloapp/ui/pages/hometabs/journey/Journey%20page%20elements/jMilestones.dart';
import 'package:felloapp/ui/pages/hometabs/journey/journey_vm.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

final avatarKey = GlobalKey();

class JourneyView extends StatefulWidget {
  @override
  State<JourneyView> createState() => _JourneyViewState();
}

class _JourneyViewState extends State<JourneyView>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return BaseView<JourneyPageViewModel>(
      onModelReady: (model) async {
        // await model.init(0);
        model.controller = AnimationController(
            vsync: this,
            duration: const Duration(seconds: 10),
            animationBehavior: AnimationBehavior.preserve);
        model.tempInit();
      },
      onModelDispose: (model) {
        model.dump();
      },
      builder: (ctx, model, child) {
        return Scaffold(
          backgroundColor: Colors.black,
          floatingActionButton: FloatingActionButton(
            child: model.isLoading
                ? CircularProgressIndicator()
                : const Icon(Icons.play_arrow),
            onPressed: model.isLoading
                ? () {}
                : () {
                    if (model.controller.isCompleted)
                      model.controller.reverse();
                    else if (model.controller.isAnimating)
                      model.controller.stop();
                    else {
                      model.controller.forward();
                    }
                  },
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
                        child: InteractiveViewer(
                          panEnabled: true,
                          minScale: 1,
                          maxScale: 4,
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
                                JourneyAssetPath(model: model),
                                Positioned(
                                  bottom: 0,
                                  left: 0,
                                  child: CustomPaint(
                                    size: Size(SizeConfig.screenWidth,
                                        model.currentFullViewHeight),
                                    painter: PathPainter(
                                        model.avatarPath, Colors.red),
                                  ),
                                ),
                                Milestones(model: model),
                                Avatar(
                                  model: model,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    AnimatedPositioned(
                      top: (model.isLoading &&
                              model.pages != null &&
                              model.pages.length > 0)
                          ? SizeConfig.pageHorizontalMargins
                          : -400,
                      duration: Duration(seconds: 1),
                      curve: Curves.decelerate,
                      left: SizeConfig.pageHorizontalMargins,
                      child: SafeArea(
                        child: Container(
                          width: SizeConfig.screenWidth -
                              SizeConfig.pageHorizontalMargins * 2,
                          height: SizeConfig.padding80,
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.circular(SizeConfig.roundness16),
                            color: Colors.black54,
                          ),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Colors.black,
                              radius: SizeConfig.avatarRadius * 2,
                              child: SpinKitCircle(
                                color: UiConstants.primaryColor,
                                size: SizeConfig.avatarRadius * 1.5,
                              ),
                            ),
                            title: Text(
                              "Loading",
                              style: GoogleFonts.rajdhani(
                                  fontSize: SizeConfig.title3,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white),
                            ),
                            subtitle: Text(
                              "Loading more levels for you,please wait",
                              style: TextStyles.body3.colour(Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SafeArea(
                      child: Container(
                        margin: EdgeInsets.only(
                          left: SizeConfig.screenWidth * 0.05,
                        ),
                        child: CircleAvatar(
                          backgroundColor: Colors.white.withOpacity(0.3),
                          child: IconButton(
                            icon: const Icon(Icons.arrow_back_ios_rounded,
                                color: Colors.white),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                        ),
                      ),
                    ),
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
