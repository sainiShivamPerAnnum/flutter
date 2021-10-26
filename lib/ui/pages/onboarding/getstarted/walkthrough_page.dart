import 'package:felloapp/core/enums/connectivity_status_enum.dart';
import 'package:felloapp/core/ops/db_ops.dart';
import 'package:felloapp/main.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/pages/static/home_background.dart';
import 'package:felloapp/ui/widgets/buttons/fello_button/large_button.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:video_player/video_player.dart';

import '../../../../base_util.dart';

class WalkThroughPage extends StatefulWidget {
  @override
  _WalkThroughPageState createState() => _WalkThroughPageState();
}

class _WalkThroughPageState extends State<WalkThroughPage> {
  List<String> _videoURLS;
  static final TextStyle normStyle = GoogleFonts.montserrat(
      fontSize: SizeConfig.mediumTextSize * 1.4, color: Colors.black);
  static final TextStyle boldStyle = GoogleFonts.montserrat(
      color: Colors.black,
      fontWeight: FontWeight.bold,
      fontSize: SizeConfig.mediumTextSize * 1.4);
  List<RichText> _content = [
    RichText(
      text: new TextSpan(
        children: [
          new TextSpan(
            text: 'Save and invest ',
            style: boldStyle,
          ),
          new TextSpan(
            text: 'in strong financial assets with ease 💪',
            style: normStyle,
          ),
        ],
      ),
    ),
    RichText(
      text: new TextSpan(
        children: [
          new TextSpan(
            text: 'Earn ',
            style: normStyle,
          ),
          new TextSpan(
            text: '1 weekly gaming ticket for every ₹ 100 ',
            style: boldStyle,
          ),
          new TextSpan(
            text: 'you save 🎟️',
            style: normStyle,
          )
        ],
      ),
    ),
    RichText(
      text: new TextSpan(
        children: [
          new TextSpan(
            text: 'Use your gaming tickets to play ',
            style: normStyle,
          ),
          new TextSpan(
            text: 'fun filled games ',
            style: boldStyle,
          ),
          new TextSpan(
            text: '🎲',
            style: normStyle,
          )
        ],
      ),
    ),
    RichText(
      text: new TextSpan(
        children: [
          new TextSpan(
            text: 'Gain ',
            style: normStyle,
          ),
          new TextSpan(
            text: 'better returns ',
            style: boldStyle,
          ),
          new TextSpan(
            text: 'and win ',
            style: normStyle,
          ),
          new TextSpan(
            text: 'exciting prizes ',
            style: normStyle,
          ),
          new TextSpan(
            text: 'every week 🎉',
            style: boldStyle,
          ),
        ],
      ),
    )
    // 'Save and invest in strong financial assets with ease 💪',
    // 'Earn 1 weekly gaming ticket for every ₹ 100 you save 🎟️',
    // 'Use your gaming tickets to play fun filled games 🎲',
    // 'Gain better returns and win exciting prizes every week 🎉'
  ];
  int _currentIndex = 0;
  PageController pageController = PageController(keepPage: false);
  AppState stateProvider;
  BaseUtil baseProvider;
  DBModel dbProvider;
  VideoPlayerController _videoController;
  bool isInit = false;
  ConnectivityStatus connectivityStatus;

  void init() async {
    if (connectivityStatus != ConnectivityStatus.Offline) {
      dbProvider.getWalkthroughUrls().then((value) {
        print(value.length);
        _videoURLS = value;
        _initController(0);
      });
      isInit = true;
    }
  }

  void _initController(int index) {
    _videoController = VideoPlayerController.network(_videoURLS[index])
      ..setLooping(true)
      ..initialize().then((_) {
        setState(() {
          _videoController.play();
        });
      });
  }

  Future<void> _onControllerChange(int index) async {
    if (_videoController == null) {
      _initController(index);
    } else {
      final oldController = _videoController;
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        await oldController.dispose();
        _initController(index);
      });
      setState(() {
        _videoController = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    stateProvider = Provider.of<AppState>(context, listen: false);
    baseProvider = Provider.of<BaseUtil>(context, listen: false);
    dbProvider = Provider.of<DBModel>(context, listen: false);
    connectivityStatus = Provider.of<ConnectivityStatus>(context);
    // if (!isInit) {
    //   init();
    // }
    return Scaffold(
        body: HomeBackground(
      child: SafeArea(
        child: Container(
          margin: EdgeInsets.only(top: SizeConfig.padding16),
          padding: EdgeInsets.symmetric(
              horizontal: SizeConfig.pageHorizontalMargins),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(SizeConfig.padding40),
              topRight: Radius.circular(SizeConfig.padding40),
            ),
            color: Colors.white,
          ),
          child: Column(
            children: [
              Spacer(),
              Text("Play", style: TextStyles.title1.bold),
              Spacer(),
              Container(
                height: SizeConfig.screenWidth * 0.8,
                width: SizeConfig.screenWidth * 0.8,
                child: Stack(
                  children: [
                    CustomPaint(
                      painter: LottieBackground(),
                      size: Size(
                          SizeConfig.screenWidth * 0.8,
                          (SizeConfig.screenWidth * 0.8 * 0.9779874213836478)
                              .toDouble()),
                    ),
                    Positioned(
                      child: Lottie.asset(
                        Assets.bankLottie,
                        // "images/lottie/clap.json",
                        height: SizeConfig.screenWidth,
                        width: SizeConfig.screenWidth,
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TabPageSelectorIndicator(
                      backgroundColor: UiConstants.primaryColor,
                      borderColor: UiConstants.primaryColor,
                      size: 10),
                  TabPageSelectorIndicator(
                      backgroundColor: Colors.grey,
                      borderColor: Colors.grey,
                      size: 10),
                  TabPageSelectorIndicator(
                      backgroundColor: Colors.grey,
                      borderColor: Colors.grey,
                      size: 10),
                ],
              ),
              Padding(
                padding: EdgeInsets.all(
                  SizeConfig.screenHeight * 0.05,
                ),
                child: Text(
                    "Amet minim mollit non deserunt ullamco est sit aliqua dolor do amet sint. Velit officia consequat duis enim velit mollit.",
                    maxLines: 3,
                    overflow: TextOverflow.clip,
                    style: TextStyles.body3),
              ),
              Spacer(),
              Container(
                width: SizeConfig.screenWidth,
                child: FelloButtonLg(
                  child: Text(
                    "NEXT",
                    style: TextStyles.body2.bold.colour(Colors.white),
                  ),
                  onPressed: () {},
                ),
              ),
              TextButton(
                onPressed: () {},
                child: Text(
                  "Skip",
                  style: TextStyles.body3.colour(Colors.grey),
                ),
              )
            ],
          ),
        ),
      ),
    )
        // SafeArea(
        //   child: connectivityStatus == ConnectivityStatus.Offline
        //       ? Container(
        //           width: SizeConfig.screenWidth,
        //           margin: EdgeInsets.all(SizeConfig.globalMargin),
        //           child: Column(
        //             mainAxisAlignment: MainAxisAlignment.center,
        //             children: [
        //               SvgPicture.asset(
        //                 "images/svgs/offline.svg",
        //                 width: SizeConfig.screenWidth * 0.7,
        //               ),
        //               Padding(
        //                 padding: EdgeInsets.symmetric(
        //                     vertical: SizeConfig.globalMargin),
        //                 child: Text(
        //                   "You are offline",
        //                   style: TextStyle(
        //                     fontWeight: FontWeight.w700,
        //                     fontSize: SizeConfig.largeTextSize,
        //                   ),
        //                 ),
        //               ),
        //               Text(
        //                 "Please check your internet connection and come back again.\nWe are waiting for you",
        //                 textAlign: TextAlign.center,
        //                 style: TextStyle(color: Colors.black54, height: 1.6),
        //               ),
        //             ],
        //           ),
        //         )
        //       : Stack(
        //           children: [
        //             Align(
        //               child: SvgPicture.asset(
        //                   'images/svgs/walkthrough_ellipse_bg.svg',
        //                   height: SizeConfig.screenHeight * 0.2),
        //               alignment: Alignment.topLeft,
        //             ),
        //             Align(
        //               child: SvgPicture.asset(
        //                   'images/svgs/walkthrough_ellipse_bg.svg',
        //                   height: SizeConfig.screenHeight * 0.2),
        //               alignment: Alignment.centerRight,
        //             ),
        //             Align(
        //               alignment: Alignment.center,
        //               child: PageView(
        //                   controller: pageController,
        //                   children: [
        //                     _buildWalkthroughPage(0),
        //                     _buildWalkthroughPage(1),
        //                     _buildWalkthroughPage(2),
        //                     _buildWalkthroughPage(3)
        //                     // WalkThroughSlide(
        //                     //     content: _content[0],
        //                     //     videoController: _videoController),
        //                     // WalkThroughSlide(
        //                     //     content: _content[1],
        //                     //     videoController: _videoController),
        //                     // WalkThroughSlide(
        //                     //     content: _content[2], videoController: _videoController)
        //                   ],
        //                   onPageChanged: (index) {
        //                     _onControllerChange(index);
        //                     setState(() {
        //                       _currentIndex = index;
        //                     });
        //                   }),
        //             ),
        //             Align(
        //                 alignment: Alignment.bottomCenter,
        //                 child: Container(
        //                   alignment: Alignment.center,
        //                   width: SizeConfig.screenWidth,
        //                   height: SizeConfig.blockSizeVertical * 6,
        //                   child: ListView.separated(
        //                     shrinkWrap: true,
        //                     scrollDirection: Axis.horizontal,
        //                     separatorBuilder: (ctx, idx) {
        //                       return SizedBox(
        //                         width: SizeConfig.blockSizeHorizontal * 2,
        //                       );
        //                     },
        //                     itemCount: _content.length,
        //                     itemBuilder: (ctx, idx) {
        //                       return Container(
        //                         width: SizeConfig.blockSizeHorizontal * 3,
        //                         height: SizeConfig.blockSizeHorizontal * 3,
        //                         decoration: BoxDecoration(
        //                             shape: BoxShape.circle,
        //                             color: (idx == _currentIndex)
        //                                 ? Colors.grey[500]
        //                                 : Colors.grey[300]),
        //                       );
        //                     },
        //                   ),
        //                 )),
        //             SafeArea(
        //               child: Container(
        //                 width: SizeConfig.screenWidth,
        //                 height: SizeConfig.screenHeight,
        //                 child: Stack(
        //                   children: [
        //                     Container(
        //                       height: kToolbarHeight * 0.8,
        //                       alignment: Alignment.centerRight,
        //                       width: SizeConfig.screenWidth * 0.95,
        //                       child: (_currentIndex != _content.length - 1)
        //                           ? GestureDetector(
        //                               onTap: () {
        //                                 AppState.backButtonDispatcher
        //                                     .didPopRoute();
        //                               },
        //                               child: Text(
        //                                 'Skip >',
        //                                 style: TextStyle(
        //                                     color: UiConstants.primaryColor,
        //                                     fontSize:
        //                                         SizeConfig.largeTextSize * 0.65),
        //                               ))
        //                           : SizedBox(
        //                               width: 0,
        //                             ),
        //                     ),
        //                     Positioned(
        //                       bottom: 0,
        //                       right: 0,
        //                       child: Padding(
        //                         padding: EdgeInsets.all(
        //                             SizeConfig.blockSizeHorizontal * 5),
        //                         child: (_currentIndex == _content.length - 1)
        //                             ? Container(
        //                                 width: SizeConfig.screenWidth * 0.3,
        //                                 height: SizeConfig.blockSizeVertical * 5,
        //                                 child: FelloButtonLg(
        //                                   child: Text(
        //                                     'Complete',
        //                                     style: Theme.of(context)
        //                                         .textTheme
        //                                         .button
        //                                         .copyWith(
        //                                             color: Colors.white,
        //                                             fontSize:
        //                                                 SizeConfig.largeTextSize *
        //                                                     0.7,
        //                                             fontWeight: FontWeight.bold),
        //                                   ),
        //                                   onPressed: () {
        //                                     AppState.backButtonDispatcher
        //                                         .didPopRoute();
        //                                   },
        //                                 ))
        //                             : SizedBox(
        //                                 width: 0,
        //                               ),
        //                       ),
        //                     ),
        //                   ],
        //                 ),
        //               ),
        //             )
        //           ],
        //         ),
        // ),
        );
  }

  Widget _buildWalkthroughPage(int index) {
    return Column(
      children: [
        SizedBox(height: kToolbarHeight * 0.8),
        Expanded(
          child: (_videoController != null)
              ? Container(
                  decoration: BoxDecoration(boxShadow: [
                    BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 3,
                        blurRadius: 7)
                  ]),
                  child: AspectRatio(
                      aspectRatio: _videoController.value.aspectRatio,
                      child: VideoPlayer(_videoController)))
              : Shimmer(
                  child: Container(
                    width: SizeConfig.screenWidth * 0.6,
                    color: Colors.grey.withOpacity(0.4),
                  ),
                  color: Colors.white,
                ),
        ),
        Container(
          width: SizeConfig.screenWidth * 0.8,
          height: SizeConfig.screenHeight * 0.1,
          margin: EdgeInsets.only(
            top: SizeConfig.blockSizeHorizontal * 3,
            bottom: SizeConfig.blockSizeHorizontal * 14,
          ),
          child: Center(
            child: _content[index],
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _videoController?.dispose();
    super.dispose();
  }
}

class LottieBackground extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Path path_0 = Path();
    path_0.moveTo(0, size.height * 0.2885122);
    path_0.cubicTo(
        0,
        size.height * 0.2062489,
        size.width * 0.04534874,
        size.height * 0.1310103,
        size.width * 0.1172173,
        size.height * 0.09403633);
    path_0.cubicTo(
        size.width * 0.3580252,
        size.height * -0.02985167,
        size.width * 0.6419748,
        size.height * -0.02985167,
        size.width * 0.8827830,
        size.height * 0.09403633);
    path_0.cubicTo(size.width * 0.9546509, size.height * 0.1310103, size.width,
        size.height * 0.2062489, size.width, size.height * 0.2885122);
    path_0.lineTo(size.width, size.height * 0.7643151);
    path_0.cubicTo(
        size.width,
        size.height * 0.8137460,
        size.width,
        size.height * 0.8384598,
        size.width * 0.9956069,
        size.height * 0.8581929);
    path_0.cubicTo(
        size.width * 0.9787799,
        size.height * 0.9337588,
        size.width * 0.9165566,
        size.height * 0.9898424,
        size.width * 0.8411258,
        size.height * 0.9974212);
    path_0.cubicTo(
        size.width * 0.8214277,
        size.height * 0.9994019,
        size.width * 0.7974465,
        size.height * 0.9962990,
        size.width * 0.7494906,
        size.height * 0.9900932);
    path_0.cubicTo(
        size.width * 0.6974906,
        size.height * 0.9833633,
        size.width * 0.6714937,
        size.height * 0.9800000,
        size.width * 0.6454906,
        size.height * 0.9775305);
    path_0.cubicTo(
        size.width * 0.5487044,
        size.height * 0.9683312,
        size.width * 0.4512956,
        size.height * 0.9683312,
        size.width * 0.3545094,
        size.height * 0.9775305);
    path_0.cubicTo(
        size.width * 0.3285063,
        size.height * 0.9800000,
        size.width * 0.3025085,
        size.height * 0.9833633,
        size.width * 0.2505107,
        size.height * 0.9900932);
    path_0.cubicTo(
        size.width * 0.2025525,
        size.height * 0.9962990,
        size.width * 0.1785736,
        size.height * 0.9994019,
        size.width * 0.1588758,
        size.height * 0.9974212);
    path_0.cubicTo(
        size.width * 0.08344434,
        size.height * 0.9898424,
        size.width * 0.02121890,
        size.height * 0.9337588,
        size.width * 0.004393679,
        size.height * 0.8581929);
    path_0.cubicTo(0, size.height * 0.8384598, 0, size.height * 0.8137460, 0,
        size.height * 0.7643151);
    path_0.lineTo(0, size.height * 0.2885122);
    path_0.close();

    Paint paint_0_fill = Paint()..style = PaintingStyle.fill;
    paint_0_fill.color = Color(0xffF1F6FF).withOpacity(1.0);
    canvas.drawPath(path_0, paint_0_fill);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
