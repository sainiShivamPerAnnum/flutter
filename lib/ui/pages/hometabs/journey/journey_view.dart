import 'dart:developer';
import 'dart:ui';

import 'package:felloapp/core/model/journey_models/journey_page.dart';
import 'package:felloapp/core/ops/db_ops.dart';
import 'package:felloapp/ui/pages/hometabs/journey/Journey%20page%20elements/jAssetPath.dart';
import 'package:felloapp/ui/pages/hometabs/journey/Journey%20page%20elements/jBackground.dart';
import 'package:felloapp/ui/pages/hometabs/journey/Journey%20page%20elements/jMilestones.dart';
import 'package:felloapp/ui/pages/hometabs/journey/journey_vm.dart';
import 'package:felloapp/util/journey_page_data.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

final avatarKey = GlobalKey();

class JourneyView extends StatefulWidget {
  const JourneyView({Key key}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return JourneyViewState();
  }
}

class JourneyViewState extends State<JourneyView>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  ScrollController _mainController;
  Animation _animation;
  Path _path;
  Offset _avatarPosition;
  bool isLoading = false;
  List<JourneyPage> pages;
  final _dbModel = locator<DBModel>();

  @override
  void initState() {
    super.initState();
    loadScreenData();
  }

  loadPage() async {
    setState(() {
      isLoading = true;
    });
    await Future.delayed(Duration(seconds: 5));
    if (pages == null) {
      pages = [];
      pages.addAll([jourenyPages[0], jourenyPages[1]]);
    } else {
      for (int i = pages.length; i < pages.length + 2; i++) {
        if (i < jourenyPages.length) pages.add(jourenyPages[i]);
      }
    }
    // await _dbModel.fetchJourneyPage();
    JourneyPageViewModel(0, pages);
    _path = JourneyPageViewModel.drawPath();
    _avatarPosition = calculatePosition(0);
    setState(() {
      isLoading = false;
    });
  }

  loadScreenData() async {
    await loadPage();
    _mainController = ScrollController();
    _controller = AnimationController(
        vsync: this,
        duration: const Duration(seconds: 10),
        animationBehavior: AnimationBehavior.preserve);

    _animation = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    )..addListener(() {
        setState(() {});
        _avatarPosition = calculatePosition(_animation.value);
        // log("Avatar Position( ${_avatarPosition.dx} , ${_avatarPosition.dy} )");
        double avatarPositionFromBottom =
            JourneyPageViewModel.currentFullViewHeight - _avatarPosition.dy;
        double scrollPostion =
            JourneyPageViewModel.currentFullViewHeight - _mainController.offset;
        if (avatarPositionFromBottom >= scrollPostion) {
          _mainController.animateTo(
              scrollPostion - JourneyPageViewModel.pageHeight * 0.5,
              duration: const Duration(seconds: 2),
              curve: Curves.easeOutCubic);
        }
        // log("Avatar Position( $avatarPositionFromBottom , $scrollPostion )");
        //if(scrollOffsetfromBottom >= avatarBottomOffset) avatar is hidden
        //
      });
    _mainController.addListener(() {
      // Scrollable.ensureVisible(avatarKey.currentContext);
      // log(_mainController.offset.toString());
      double avatarPositionFromBottom =
          JourneyPageViewModel.currentFullViewHeight - _avatarPosition.dy;
      double scrollPostion =
          JourneyPageViewModel.currentFullViewHeight - _mainController.offset;
      if (_mainController.offset >= _mainController.position.maxScrollExtent) {
        loadPage();
      }
      // log("Avatr to Scroll Ratio( $avatarPositionFromBottom , $scrollPostion )");
    });
    log("Screen: Height: ${SizeConfig.screenHeight}");
    log("Screen Width: ${SizeConfig.screenWidth}");
    // WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
    //   _mainController.animateTo(_mainController.position.maxScrollExtent,
    //       duration: const Duration(seconds: 3), curve: Curves.easeInCubic);
    // });
  }

  @override
  Widget build(BuildContext context) {
    // setDimensions(context);
    return Scaffold(
      backgroundColor: Colors.black,
      floatingActionButton: FloatingActionButton(
          child: isLoading
              ? CircularProgressIndicator()
              : const Icon(Icons.play_arrow),
          onPressed: isLoading
              ? () {}
              : () {
                  if (_controller.isCompleted)
                    _controller.reverse();
                  else if (_controller.isAnimating)
                    _controller.stop();
                  else {
                    _controller.forward();
                  }
                }),
      body: isLoading && pages == null
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
                  Lottie.asset("assets/lotties/pending.json",
                      height: SizeConfig.screenWidth / 3),
                  SizedBox(height: 20),
                  Text(
                    'Loading',
                    style: GoogleFonts.josefinSans(fontSize: SizeConfig.body1),
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
                    controller: _mainController,
                    physics: const ClampingScrollPhysics(),
                    reverse: true,
                    child: Container(
                      height: JourneyPageViewModel.currentFullViewHeight,
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
                          // const Background(),

                          const JourneyAssetPath(),
                          const Milestones(),
                          Positioned(
                            bottom: 0,
                            left: 0,
                            child: CustomPaint(
                              size: Size(SizeConfig.screenWidth,
                                  JourneyPageViewModel.currentFullViewHeight),
                              painter: PathPainter(_path, Colors.red),
                            ),
                          ),
                          Avatar(
                            vPos: _avatarPosition.dy,
                            hPos: _avatarPosition.dx,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                AnimatedPositioned(
                  top: (isLoading && pages != null && pages.length > 0)
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
  }

  @override
  void dispose() {
    _controller.dispose();
    _mainController.dispose();
    super.dispose();
  }

  // Offset calculateX(value) {
  //   PathMetrics pathMetrics = _path.computeMetrics();
  //   PathMetric pathMetric = pathMetrics.elementAt(0);
  //   value = pathMetric.length * value;
  //   Tangent pos = pathMetric.getTangentForOffset(value);
  //   return pos.position;
  // }

  Offset calculatePosition(value) {
    PathMetrics pathMetrics = _path.computeMetrics();
    PathMetric pathMetric = pathMetrics.elementAt(0);
    value = pathMetric.length * value;
    Tangent pos = pathMetric.getTangentForOffset(value);
    return pos.position;
  }
}

class Avatar extends StatelessWidget {
  final double hPos, vPos;
  const Avatar({Key key, @required this.hPos, @required this.vPos})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Positioned(
      key: avatarKey,
      top: vPos,
      left: hPos,
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
