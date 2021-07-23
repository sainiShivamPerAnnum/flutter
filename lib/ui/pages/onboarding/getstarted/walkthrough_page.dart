import 'package:felloapp/main.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/size_config.dart';
import 'package:felloapp/util/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

import '../../../../base_util.dart';

class WalkThroughPage extends StatefulWidget {
  @override
  _WalkThroughPageState createState() => _WalkThroughPageState();
}

class _WalkThroughPageState extends State<WalkThroughPage> {
  List<String> _videoURLS = ['images/screen_demo.gif','images/screen_demo_2.gif','images/screen_demo_2.gif'];
  AssetImage _gifImage;
  List<String> _content = [
    'Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
    'Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
    'Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
  ];
  ValueNotifier<int> _currentIndex = ValueNotifier<int>(0);
  PageController pageController = PageController(keepPage: false);
  AppState stateProvider;
  BaseUtil baseProvider;

  @override
  void initState() {
    _gifImage = AssetImage(_videoURLS[0]);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    stateProvider = Provider.of<AppState>(context, listen: false);
    baseProvider = Provider.of<BaseUtil>(context, listen: false);
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Align(child: SvgPicture.asset('images/svgs/walkthrough_bg_illustration.svg',height: SizeConfig.screenHeight*0.5),alignment: Alignment.topLeft,),
            PageView.builder(
              controller: pageController,
              itemCount: _content.length,
              onPageChanged: (index) async {
                await _gifImage.evict();
                _gifImage = AssetImage(_videoURLS[index]);
                _currentIndex.value = index;
              },
              itemBuilder: (ctx, index) {
                return ValueListenableBuilder(
                  valueListenable: _currentIndex,
                  builder: (ctx, currIdx, child) {
                    return _buildWalkthroughPage(currIdx);
                  }
                );
              }
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                alignment: Alignment.center,
                width: SizeConfig.screenWidth,
                height: SizeConfig.blockSizeVertical*6,
                child: ValueListenableBuilder(
                  valueListenable: _currentIndex,
                  builder: (ctx, currIdx, child) {
                    return ListView.separated(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      separatorBuilder:(ctx,idx) {return SizedBox(width: SizeConfig.blockSizeHorizontal*2,);},
                      itemCount: _content.length,
                      itemBuilder: (ctx,idx) {
                        return Container(
                          width: SizeConfig.blockSizeHorizontal*3,
                          height: SizeConfig.blockSizeHorizontal*3,
                          decoration: BoxDecoration(shape: BoxShape.circle, color: (idx==currIdx)?Colors.grey[500]:Colors.grey[300]),
                        );
                      },
                    );
                  },
                )
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
            SizedBox(height: SizeConfig.screenHeight*0.0125,),
            Container(
              alignment: Alignment.centerRight,
              width: SizeConfig.screenWidth*0.9,
              child: (index!=_content.length-1)?GestureDetector(onTap: (){backButtonDispatcher.didPopRoute();},child: Text('Skip Tutorial >>', style: TextStyle(color: UiConstants.primaryColor, fontSize: SizeConfig.largeTextSize*0.65),)):SizedBox(width: 0,),
            ),
            SizedBox(height: SizeConfig.screenHeight*0.0125,),
            Container(
              width: SizeConfig.screenWidth*0.75,
              height: SizeConfig.screenHeight*0.7,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: _gifImage
                )
              ),
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
                      borderRadius: BorderRadius.circular(100.0),
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
    _gifImage.evict();
    super.dispose();
  }

}


