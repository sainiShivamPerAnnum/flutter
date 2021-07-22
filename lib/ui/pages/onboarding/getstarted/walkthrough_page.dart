import 'package:felloapp/main.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/util/size_config.dart';
import 'package:felloapp/util/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

class WalkThroughPage extends StatefulWidget {
  @override
  _WalkThroughPageState createState() => _WalkThroughPageState();
}

class _WalkThroughPageState extends State<WalkThroughPage> {
  List<String> _videoURLS = ['images/demo_video.webm','images/demo_video.webm','images/demo_video.webm'];
  VideoPlayerController _videoPlayerController;
  List<String> _content = [
    'Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
    'Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
    'Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
  ];
  int _currentIndex = 0;
  AppState stateProvider;

  @override
  void initState() {
    _onControllerChange(0);
    super.initState();
  }

  void _initController(int newIndex) async {
    _videoPlayerController = VideoPlayerController.asset(_videoURLS[newIndex])
        ..setLooping(true)
        ..initialize().then((value) {
          setState(() {
            _videoPlayerController.play();
          });
        });
  }

  Future<void> _onControllerChange(int newIndex) async {
    if(_videoPlayerController==null) {
      _initController(newIndex);
    } else {
      final oldController = _videoPlayerController;
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
        await oldController.dispose();
        _initController(newIndex);
      });
      setState(() {
        _videoPlayerController = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    stateProvider = Provider.of<AppState>(context, listen: false);
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Align(child: SvgPicture.asset('images/svgs/walkthrough_bg_illustration.svg',height: SizeConfig.screenHeight*0.5),alignment: Alignment.topLeft,),
            PageView(
              physics: BouncingScrollPhysics(),
              onPageChanged: (index) async {
                setState(() {
                  _currentIndex = index;
                  _onControllerChange(_currentIndex);
                });
              },
              children: [
                _buildWalkthroughPage(0),
                _buildWalkthroughPage(1),
                _buildWalkthroughPage(2),
              ],
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                alignment: Alignment.center,
                width: SizeConfig.screenWidth,
                height: SizeConfig.blockSizeVertical*6,
                child: ListView.separated(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  separatorBuilder:(ctx,idx) {return SizedBox(width: SizeConfig.blockSizeHorizontal*2,);},
                  itemCount: _content.length,
                  itemBuilder: (ctx,idx) {
                    return Container(
                      width: SizeConfig.blockSizeHorizontal*3,
                      height: SizeConfig.blockSizeHorizontal*3,
                      decoration: BoxDecoration(shape: BoxShape.circle, color: (idx==_currentIndex)?Colors.grey[500]:Colors.grey[300]),
                    );
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
  Widget _buildWalkthroughPage(int index) {
    return SingleChildScrollView(
      child : Column(
        children: [
         SizedBox(height: SizeConfig.blockSizeVertical*2.5,),
         Container(
           alignment: Alignment.centerRight,
           width: SizeConfig.screenWidth*0.9,
           child: (index!=_content.length-1)?GestureDetector(onTap: (){backButtonDispatcher.didPopRoute();},child: Text('Skip Tutorial >>', style: TextStyle(color: UiConstants.primaryColor, fontSize: SizeConfig.largeTextSize*0.65),)):SizedBox(width: 0,),
         ),
          SizedBox(height: SizeConfig.blockSizeVertical*5,),
          Container(
            width: SizeConfig.screenWidth*0.75,
            height: SizeConfig.screenHeight*0.7,
            child: (_videoPlayerController!=null)?AspectRatio(
              aspectRatio:_videoPlayerController.value.aspectRatio,
              child: VideoPlayer(_videoPlayerController),
            ):Center(child: CircularProgressIndicator(color: UiConstants.primaryColor,)),
          ),
          SizedBox(height: SizeConfig.blockSizeVertical*3,),
          Container(
            width: SizeConfig.screenWidth*0.65,
            child: Center(child: Text(_content[index], style: TextStyle(fontSize: SizeConfig.mediumTextSize*1.2),)),
          ),
          SizedBox(height: SizeConfig.blockSizeVertical*3,),
          Padding(
            padding: const EdgeInsets.only(left : 10.0, right: 30.0, top:8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                (index==_content.length-1)?Container(
                  width: SizeConfig.screenWidth*0.3,
                  height: SizeConfig.blockSizeVertical*5,
                  decoration: BoxDecoration(
                    gradient: new LinearGradient(colors: [
                      UiConstants.primaryColor,
                      UiConstants.primaryColor.withBlue(200),
                    ], begin: Alignment(0.5, -1.0), end: Alignment(0.5, 1.0)),
                  ),
                  child: new Material(
                    child: MaterialButton(
                      child: Text(
                        'Complete',
                        style: Theme.of(context)
                            .textTheme
                            .button
                            .copyWith(color: Colors.white, fontSize: SizeConfig.largeTextSize*0.7, fontWeight: FontWeight.bold),),
                      highlightColor: Colors.white30,
                      splashColor: Colors.white30,
                      onPressed: () {
                        stateProvider.currentAction = PageAction(state: PageState.addPage, page: WalkThroughCompletedConfig);
                      },
                    ),
                    color: Colors.transparent,
                    borderRadius: new BorderRadius.circular(30.0),
                  ),
                ):SizedBox(width: 0,),
              ],
            ),
          )
        ],
      )
    );
  }

  @override
  void dispose() {
    if(_videoPlayerController.value.isPlaying) {
      _videoPlayerController.pause();
    }
    _videoPlayerController.dispose();
    super.dispose();
  }

}
