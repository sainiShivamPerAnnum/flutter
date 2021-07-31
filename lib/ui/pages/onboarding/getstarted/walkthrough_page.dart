import 'package:felloapp/core/ops/db_ops.dart';
import 'package:felloapp/main.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/util/size_config.dart';
import 'package:felloapp/util/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

import '../../../../base_util.dart';

class WalkThroughPage extends StatefulWidget {
  @override
  _WalkThroughPageState createState() => _WalkThroughPageState();
}

class _WalkThroughPageState extends State<WalkThroughPage> {
  List<String> _videoURLS;
  List<String> _content = [
    'Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
    'Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
    'Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
  ];
  int _currentIndex = 0;
  PageController pageController = PageController(keepPage: false);
  AppState stateProvider;
  BaseUtil baseProvider;
  DBModel dbProvider;
  VideoPlayerController _videoController;
  bool isInit = false;

  void init() async {
    dbProvider.getWalkthroughUrls().then((value) {
      print(value.length);
      _videoURLS = value;
      if (_videoURLS.length <= 3) {
        var temp = _videoURLS;
        var value = temp[0];
        _videoURLS.clear();
        int i = 0;
        _videoURLS = [];
        while (i < 3) {
          _videoURLS.add(value);
          i++;
        }
      }
      _initController(0);
    });
    isInit = true;
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
    if (!isInit) {
      init();
    }
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Align(
              child: SvgPicture.asset('images/svgs/walkthrough_ellipse_bg.svg',
                  height: SizeConfig.screenHeight * 0.2),
              alignment: Alignment.topLeft,
            ),
            Align(
              child: SvgPicture.asset('images/svgs/walkthrough_ellipse_bg.svg',
                  height: SizeConfig.screenHeight * 0.2),
              alignment: Alignment.centerRight,
            ),
            Align(
              alignment: Alignment.center,
              child: PageView(
                  controller: pageController,
                  children: [
                    _buildWalkthroughPage(0),
                    _buildWalkthroughPage(1),
                    _buildWalkthroughPage(2)
                    // WalkThroughSlide(
                    //     content: _content[0],
                    //     videoController: _videoController),
                    // WalkThroughSlide(
                    //     content: _content[1],
                    //     videoController: _videoController),
                    // WalkThroughSlide(
                    //     content: _content[2], videoController: _videoController)
                  ],
                  onPageChanged: (index) {
                    _onControllerChange(index);
                    setState(() {
                      _currentIndex = index;
                    });
                  }),
            ),
            Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  alignment: Alignment.center,
                  width: SizeConfig.screenWidth,
                  height: SizeConfig.blockSizeVertical * 6,
                  child: ListView.separated(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    separatorBuilder: (ctx, idx) {
                      return SizedBox(
                        width: SizeConfig.blockSizeHorizontal * 2,
                      );
                    },
                    itemCount: _content.length,
                    itemBuilder: (ctx, idx) {
                      return Container(
                        width: SizeConfig.blockSizeHorizontal * 3,
                        height: SizeConfig.blockSizeHorizontal * 3,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: (idx == _currentIndex)
                                ? Colors.grey[500]
                                : Colors.grey[300]),
                      );
                    },
                  ),
                )),
            SafeArea(
              child: Container(
                width: SizeConfig.screenWidth,
                height: SizeConfig.screenHeight,
                child: Stack(
                  children: [
                    Container(
                      height: kToolbarHeight * 0.8,
                      alignment: Alignment.centerRight,
                      width: SizeConfig.screenWidth * 0.95,
                      child: (_currentIndex != _content.length - 1)
                          ? GestureDetector(
                              onTap: () {
                                backButtonDispatcher.didPopRoute();
                              },
                              child: Text(
                                'Skip Tutorial >>',
                                style: TextStyle(
                                    color: UiConstants.primaryColor,
                                    fontSize: SizeConfig.largeTextSize * 0.65),
                              ))
                          : SizedBox(
                              width: 0,
                            ),
                    ),
                    Positioned(
                        bottom: 0,
                        right: 0,
                        child: Padding(
                          padding: EdgeInsets.all(
                              SizeConfig.blockSizeHorizontal * 5),
                          child: (_currentIndex == _content.length - 1)
                              ? Container(
                                  width: SizeConfig.screenWidth * 0.3,
                                  height: SizeConfig.blockSizeVertical * 5,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(100.0),
                                    gradient: new LinearGradient(
                                        colors: [
                                          UiConstants.primaryColor,
                                          UiConstants.primaryColor
                                              .withBlue(200),
                                        ],
                                        begin: Alignment(0.5, -1.0),
                                        end: Alignment(0.5, 1.0)),
                                  ),
                                  child: new Material(
                                    child: MaterialButton(
                                      child: Text(
                                        'Complete',
                                        style: Theme.of(context)
                                            .textTheme
                                            .button
                                            .copyWith(
                                                color: Colors.white,
                                                fontSize:
                                                    SizeConfig.largeTextSize *
                                                        0.7,
                                                fontWeight: FontWeight.bold),
                                      ),
                                      highlightColor: Colors.white30,
                                      splashColor: Colors.white30,
                                      onPressed: () {
                                        stateProvider.currentAction =
                                            PageAction(
                                                state: PageState.addPage,
                                                page:
                                                    WalkThroughCompletedConfig);
                                      },
                                    ),
                                    color: Colors.transparent,
                                    borderRadius:
                                        new BorderRadius.circular(30.0),
                                  ),
                                )
                              : SizedBox(
                                  width: 0,
                                ),
                        )),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
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
                : Lottie.asset('images/lottie/shimmer.json',
                    fit: BoxFit.cover, repeat: true, frameRate: FrameRate(30))),
        Container(
          width: SizeConfig.screenWidth * 0.8,
          height: SizeConfig.screenHeight * 0.1,
          margin: EdgeInsets.only(
            top: SizeConfig.blockSizeHorizontal * 3,
            bottom: SizeConfig.blockSizeHorizontal * 14,
          ),
          child: Center(
            child: Text(
              _content[index],
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: SizeConfig.mediumTextSize * 1.2),
            ),
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

// class WalkThroughSlide extends StatefulWidget {
//   final String content;
//   final VideoPlayerController videoController;

//   WalkThroughSlide({this.content, this.videoController});
//   @override
//   _WalkThroughSlideState createState() => _WalkThroughSlideState();
// }

// class _WalkThroughSlideState extends State<WalkThroughSlide>
//     with AutomaticKeepAliveClientMixin {
//   @override
//   bool get wantKeepAlive => true;

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         SizedBox(height: kToolbarHeight * 0.8),
//         Expanded(
//           child: Stack(
//             children: [
//               AspectRatio(
//                 aspectRatio: widget.videoController.value.aspectRatio,
//                 child: Lottie.asset(
//                   'images/lottie/shimmer.json',
//                   fit: BoxFit.cover,
//                   repeat: true,
//                   frameRate: FrameRate(30),
//                 ),
//               ),
//               (widget.videoController != null)
//                   ? Container(
//                       decoration: BoxDecoration(boxShadow: [
//                         BoxShadow(
//                             color: Colors.grey.withOpacity(0.5),
//                             spreadRadius: 3,
//                             blurRadius: 7)
//                       ]),
//                       child: AspectRatio(
//                         aspectRatio: widget.videoController.value.aspectRatio,
//                         child: VideoPlayer(widget.videoController),
//                       ),
//                     )
//                   : SizedBox(),
//             ],
//           ),
//         ),
//         Container(
//           width: SizeConfig.screenWidth * 0.8,
//           height: SizeConfig.screenHeight * 0.1,
//           margin: EdgeInsets.only(
//             top: SizeConfig.blockSizeHorizontal * 3,
//             bottom: SizeConfig.blockSizeHorizontal * 14,
//           ),
//           child: Center(
//             child: Text(
//               widget.content,
//               textAlign: TextAlign.center,
//               style: TextStyle(fontSize: SizeConfig.mediumTextSize * 1.2),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }
