import 'dart:developer';
import 'dart:ui';

import 'package:felloapp/core/model/journey_models/journey_page.dart';
import 'package:felloapp/core/ops/db_ops.dart';
import 'package:felloapp/ui/pages/hometabs/journey/Journey%20page%20elements/jAssetPath.dart';
import 'package:felloapp/ui/pages/hometabs/journey/Journey%20page%20elements/jBackground.dart';
import 'package:felloapp/ui/pages/hometabs/journey/Journey%20page%20elements/jMilestones.dart';
import 'package:felloapp/ui/pages/hometabs/journey/journey_vm.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:flutter/material.dart';
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

  loadScreenData() async {
    setState(() {
      isLoading = true;
    });
    pages = await _dbModel.fetchJourneyPage();
    setState(() {
      isLoading = false;
    });
    JourneyPageViewModel(0, 2, pages);
    _mainController = ScrollController();
    _controller = AnimationController(
        vsync: this,
        duration: const Duration(seconds: 10),
        animationBehavior: AnimationBehavior.preserve);
    _path = JourneyPageViewModel.drawPath();
    _avatarPosition = calculatePosition(0);
    _animation = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    )..addListener(() {
        setState(() {});
        _avatarPosition = calculatePosition(_animation.value);
        log("Avatar Position( ${_avatarPosition.dx} , ${_avatarPosition.dy} )");
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
      log("Avatr to Scroll Ratio( $avatarPositionFromBottom , $scrollPostion )");
    });
    log("Screen: Height: ${SizeConfig.screenHeight}");
    log("Screen Width: ${SizeConfig.screenWidth}");
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _mainController.animateTo(_mainController.position.maxScrollExtent,
          duration: const Duration(seconds: 3), curve: Curves.easeInCubic);
    });
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
      body: isLoading
          ? Container(
              width: SizeConfig.screenWidth,
              height: SizeConfig.screenHeight,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Lottie.asset("assets/lottie/pending.json",
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
                    // reverse: true,
                    child: Container(
                      height: JourneyPageViewModel.currentFullViewHeight,
                      width: SizeConfig.screenWidth,
                      color: Colors.black,
                      child: Stack(
                        children: [
                          const Background(),
                          const JourneyAssetPath(),
                          const Milestones(),
                          Positioned(
                            bottom: 0,
                            left: 0,
                            child: CustomPaint(
                              size: Size(SizeConfig.screenWidth,
                                  JourneyPageViewModel.currentFullViewHeight),
                              painter: PathPainter(_path),
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
              "https://firebasestorage.googleapis.com/v0/b/fello-dev-station.appspot.com/o/test%2Favatar.pngalt=media&token=bab2c849-7694-41c4-9c34-1ab022799bfd"),
        ),
      ),
    );
  }
}

class PathPainter extends CustomPainter {
  Path path;

  PathPainter(this.path);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.transparent
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 1.0;

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
