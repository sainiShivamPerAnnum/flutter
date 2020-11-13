import 'package:felloapp/core/model/DailyPick.dart';
import 'package:felloapp/util/logger.dart';
import 'package:felloapp/util/ui_constants.dart';
import 'package:flutter/material.dart';

class PrizeDialog extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => PrizeDialogState();
}

class PrizeDialogState extends State<PrizeDialog> {
  final Log log = new Log('PrizeDialog');
  PageController _pageController;
  int _pageIndex = 0;

  PrizeDialogState();

  @override
  void initState(){
    _pageController = PageController(initialPage: _pageIndex);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.only(left:20, top:50, bottom: 80, right:20),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      elevation: 0.0,
      backgroundColor: Colors.white,
      child: dialogContent(context),
    );
  }

  dialogContent(BuildContext context) {
    List<Widget> colElems = [];
    return Stack(
        overflow: Overflow.visible,
        alignment: Alignment.topCenter,
        children: <Widget>[
          Container(
            height: 70,
            alignment: Alignment.topCenter,
            child:VerticalDivider(
              color: Colors.grey,
              indent: 10,
            )
          ),
          Container(
            width: double.infinity,
            child: Column(
              children: [
                SizedBox(height: 10,),
                Row(
                  children: [
                    Expanded(
                        child:Padding(
                            padding: EdgeInsets.all(10),
                            child: InkWell(
                              child: Text('This week\'s \nprizes',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: (this._pageIndex==0)?UiConstants.primaryColor:Colors.blueGrey,
                                    fontSize: 20
                                ),
                              ),
                              onTap: () => onTabTapped(0),
                            )
                        )
                    ),
                    Expanded(
                        child:Padding(
                            padding: EdgeInsets.all(10),
                            child: InkWell(
                              child: Text('Last week\'s winners',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: (this._pageIndex==1)?UiConstants.primaryColor:Colors.blueGrey,
                                    fontSize: 20
                                ),
                              ),
                              onTap: () => onTabTapped(1)
                            )
                        )
                    ),
                  ]),
                Divider(),
                Container(
                  height: 500,
                  alignment: Alignment.topCenter,
                  padding: EdgeInsets.fromLTRB(30, 20, 30, 30),
                  child: _addPageView()
                ),
              ],
            ),
          )
        ]
    );
  }

  Widget _addPageView() {
    return PageView(

      children: [
        Text('Page1'),
        Text('Page2'),
      ],
      onPageChanged: onPageChanged,
      controller: _pageController,
    );
  }

  void onPageChanged(int page) {
    setState(() {
      this._pageIndex = page;
    });
  }

  void onTabTapped(int index) {
    this._pageController.animateToPage(index,duration: const Duration(milliseconds: 500),curve: Curves.easeInOut);
  }
}
