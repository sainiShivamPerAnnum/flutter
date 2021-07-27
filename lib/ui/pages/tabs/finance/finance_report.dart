import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/model/UserFundWallet.dart';
import 'package:felloapp/util/size_config.dart';
import 'package:felloapp/util/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../main.dart';

class YourFunds extends StatefulWidget {
  final UserFundWallet userFundWallet;
  final goldMoreInfoStr;
  final Map<String,double> fundsValueMap;
  final List<String> fundTitles;
  final Map<String,String> fundDescriptions;
  YourFunds({Key key, this.userFundWallet, this.goldMoreInfoStr, this.fundsValueMap, this.fundTitles, this.fundDescriptions}) : super(key: key);
  @override
  _YourFundsState createState() => _YourFundsState();
}

class _YourFundsState extends State<YourFunds> {
  List<String> validTitles;
  int currIdx = 0;
  @override
  void initState() { 
    validTitles = _getValidTitles();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: BaseUtil.getAppBar(context),
      body : Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: new LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                stops: [0.1, 0.6],
                colors: [
                  UiConstants.primaryColor.withGreen(190),
                  UiConstants.primaryColor,
                ],
              ),
            ),
            width: SizeConfig.screenWidth,
            height: SizeConfig.screenHeight * 0.22,
            child: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [
                    IconButton(
                      iconSize: 30,
                      color: Colors.white,
                      icon: Icon(
                        Icons.arrow_back_rounded,
                      ),
                      onPressed: () => backButtonDispatcher.didPopRoute(),
                    ),
                    Spacer(),
                      Image.asset(
                        "images/fello_logo.png",
                        width: SizeConfig.screenWidth * 0.1,
                        color: Colors.white,
                      ),
                      Spacer(),
                      IconButton(
                        iconSize: 30,
                        color: Colors.white,
                        icon: SizedBox(),
                        onPressed: () {},
                      ),
                  ],),
                  SizedBox(height: SizeConfig.blockSizeVertical,),
                  Container(
                    padding: EdgeInsets.only(left : SizeConfig.blockSizeHorizontal*4),
                    child: Text('Your Funds', style: TextStyle(color: UiConstants.titleTextColor, fontSize: SizeConfig.largeTextSize*1.5),),
                  )
                ],
              ),
            ),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.only(left : SizeConfig.blockSizeHorizontal*4, top: SizeConfig.blockSizeVertical*2),
              child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Total Balance', style: TextStyle(fontSize: SizeConfig.largeTextSize, color: Colors.grey),),
                SizedBox(height: SizeConfig.blockSizeVertical*1.5,),
                Text('₹ ${widget.userFundWallet.getEstTotalWealth().toStringAsFixed(2)}', style: TextStyle(fontSize: SizeConfig.largeTextSize*2,color: UiConstants.textColor),),
                SizedBox(height: SizeConfig.blockSizeVertical*3,),
                Container(height: 2.0,color: Colors.grey[200],),
                SizedBox(height: SizeConfig.blockSizeVertical*1,),
                // Container(
                //   height: SizeConfig.screenHeight*0.55,
                //   child: PageView.builder(
                //     scrollDirection: Axis.horizontal,
                //     onPageChanged: (index) {
                //       setState(() {
                //         currIdx = index;
                //       });
                //     },
                //     itemCount: validTitles.length,
                //     itemBuilder: (ctx, index) {
                //       return _buildInfoSection(index);
                //     },
                //   ),
                // ),
                // Align(
                //   alignment: Alignment.bottomCenter,
                //   child: Container(
                //     alignment: Alignment.center,
                //     width: SizeConfig.screenWidth,
                //     height: SizeConfig.blockSizeVertical * 6,
                //     child: ListView.separated(
                //       shrinkWrap: true,
                //       scrollDirection: Axis.horizontal,
                //       separatorBuilder: (ctx, idx) {
                //         return SizedBox(
                //           width: SizeConfig.blockSizeHorizontal * 2,
                //         );
                //       },
                //       itemCount: validTitles.length,
                //       itemBuilder: (ctx, idx) {
                //         return Container(
                //           width: SizeConfig.blockSizeHorizontal * 3,
                //           height: SizeConfig.blockSizeHorizontal * 3,
                //           decoration: BoxDecoration(
                //               shape: BoxShape.circle,
                //               color: (idx == currIdx)
                //                   ? Colors.grey[500]
                //                   : Colors.grey[300]),
                //         );
                //       },
                //     ),
                //   ),
                // )
                Expanded(child: SingleChildScrollView(
                  child : Column(
                    children: _buildInfoSections()
                  )
                ),)
              ],
            ),
            )
          ),
        ],
      )
    );
  }

  List<Widget> _buildInfoSections() {
    List<Widget> res = [];
    for(int index=0;index<validTitles.length;index++) {
      res.add(
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(validTitles[index], style: TextStyle(fontWeight: FontWeight.bold, fontSize: SizeConfig.largeTextSize*1.2, color: UiConstants.primaryColor),),
            SizedBox(height: SizeConfig.blockSizeVertical*3,),
            Row(
              children: [
                Text('Current ${validTitles[index]} :', style: TextStyle(fontSize: SizeConfig.mediumTextSize*1.5, color: Colors.grey),),
                Text(' ₹ ${widget.fundsValueMap[validTitles[index]].toStringAsFixed(2)}', style: TextStyle(fontSize: SizeConfig.mediumTextSize*1.5, fontWeight: FontWeight.bold))
              ],
            ),
            SizedBox(height: SizeConfig.blockSizeVertical*3,),
            Container(
              width: SizeConfig.screenWidth,
              child: Text(widget.fundDescriptions[validTitles[index]], style: TextStyle(fontSize: SizeConfig.mediumTextSize*1.5),),
            ),
            SizedBox(height: SizeConfig.blockSizeVertical*3,),
          ],
        )
      );
    }
    return res;
  }

  List<String> _getValidTitles() {
    List<String> _validTitles = [];
    for(var i in widget.fundTitles) {
      if(widget.fundsValueMap[i]>0 && widget.fundDescriptions.containsKey(i)) {
        _validTitles.add(i);
      }
    }
    return _validTitles;
  }

}