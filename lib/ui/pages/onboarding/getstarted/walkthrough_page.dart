import 'package:felloapp/util/size_config.dart';
import 'package:felloapp/util/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class WalkThroughPage extends StatefulWidget {
  @override
  _WalkThroughPageState createState() => _WalkThroughPageState();
}

class _WalkThroughPageState extends State<WalkThroughPage> {
  List<String> _videoURLS = ['images/screen_demo.gif','images/screen_demo.gif','images/screen_demo.gif'];
  List<String> _title = ['Finance', 'Games', 'Referrals'];
  List<String> _content = [
    'Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
    'Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
    'Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   leading: IconButton(
      //     icon: Icon(
      //       Icons.arrow_back_rounded,
      //       color: Colors.white,
      //     ),
      //     onPressed: () {
      //       Navigator.pop(context);
      //       // backButtonDispatcher.didPopRoute();
      //     },
      //   ),
      //   elevation: 1.0,
      //   backgroundColor: UiConstants.primaryColor,
      //   iconTheme: IconThemeData(
      //     color: UiConstants.accentColor, //change your color here
      //   ),
      //   title: Text('Walkthrough',
      //       style: GoogleFonts.montserrat(
      //           color: Colors.white,
      //           fontWeight: FontWeight.w500,
      //           fontSize: SizeConfig.largeTextSize)),
      // ),
      body: SafeArea(
        child: Stack(
          children: [
            Align(child: SvgPicture.asset('images/svgs/walkthrough_bg_illustration.svg',height: SizeConfig.screenHeight*0.5),alignment: Alignment.topLeft,),
            PageView(
              physics: BouncingScrollPhysics(),
              onPageChanged: (index){
                setState(() {

                });
              },
              children: [
                _buildWalkthroughPage(0),
                _buildWalkthroughPage(1),
                _buildWalkthroughPage(2),
              ],
            ),
          ],
        ),
      ),
    );
  }
  Widget _buildWalkthroughPage(int index) {
    return SingleChildScrollView(
      child : Column(
        children: [
          SizedBox(height: SizeConfig.blockSizeVertical*5,),
          Container(
            // decoration: BoxDecoration(border: Border.all(color: Colors.black38, width: SizeConfig.blockSizeHorizontal*1.5), borderRadius: BorderRadius.circular(10.0)),
            width: SizeConfig.screenWidth*0.6,
            height: SizeConfig.screenHeight*0.6,
            child: Image.asset(_videoURLS[index], gaplessPlayback: true,width: SizeConfig.screenWidth*0.6,fit: BoxFit.fill,height: SizeConfig.screenHeight*0.6,),
          ),
          // SizedBox(height: SizeConfig.blockSizeVertical*4,),
          // Container(
          //   width: SizeConfig.screenWidth*0.65,
          //   child: Center(child: Text(_title[index], style: TextStyle(fontSize: SizeConfig.largeTextSize, color: UiConstants.textColor, fontWeight: FontWeight.bold),)),
          // ),
          SizedBox(height: SizeConfig.blockSizeVertical*3,),
          Container(
            width: SizeConfig.screenWidth*0.65,
            child: Center(child: Text(_content[index], style: TextStyle(fontSize: SizeConfig.mediumTextSize*1.2),)),
          ),
          SizedBox(height: SizeConfig.blockSizeVertical*3,),
          Container(
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
                  decoration: BoxDecoration(shape: BoxShape.circle, color: (idx==index)?Colors.grey[500]:Colors.grey[300]),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left : 10.0, right: 30.0, top:8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                (index!=_title.length-1)?Text('Skip Tutorial >>', style: TextStyle(color: UiConstants.primaryColor, fontSize: SizeConfig.largeTextSize*0.65),):SizedBox(width: 0,),
                (index==_title.length-1)?Container(
                  width: SizeConfig.screenWidth*0.3,
                  height: SizeConfig.blockSizeVertical*5,
                  decoration: BoxDecoration(
                      borderRadius: new BorderRadius.circular(100.0),
                      color: UiConstants.primaryColor
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
}
