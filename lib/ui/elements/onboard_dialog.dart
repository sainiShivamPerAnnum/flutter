import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/logger.dart';
import 'package:felloapp/util/ui_constants.dart';
import 'package:flutter/material.dart';

class OnboardDialog extends StatefulWidget {

  @override
  State createState() => OnboardDialogState();
}

class OnboardDialogState extends State<OnboardDialog> {
  final Log log = new Log('OnboardDialog');
  PageController _pageController;
  int _pageIndex = 0;

  OnboardDialogState();

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
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(UiConstants.padding),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: dialogContent(context),
    );
  }

  dialogContent(BuildContext context) {
    return Stack(
        overflow: Overflow.visible,
        alignment: Alignment.topCenter,
        children: <Widget>[
          Padding(
              padding: EdgeInsets.only(top: 30, bottom: 40, left: 35, right: 35),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    child: Image(
                      image: AssetImage(Assets.onboardCollageGraphic),
                      fit: BoxFit.contain,
                    ),
                    width: 180,
                    height: 180,
                  ),
                  _addPageView(),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      (_pageIndex>0)?InkWell(
                        child: Text('PREVIOUS',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: UiConstants.accentColor,
                            fontSize: 18
                          ),
                        ),
                        onTap: () {
                          if(_pageIndex>0)setState(() {
                            _pageIndex--;
                          });
                        },
                      ):Container(),
                      InkWell(
                        child: Text((_pageIndex==2)?'GOT IT':'NEXT',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: UiConstants.accentColor,
                              fontSize: 18
                          ),
                        ),
                        onTap: () {
                          if(_pageIndex<2) {
                            setState(() {
                              _pageIndex++;
                            });
                          }else{
                            Navigator.of(context).pop();
                          }
                        },
                      )
                    ],
                  )
                ],
              )
          )
        ]);
  }

  Widget _pageViewItem(int index) {
    return Text(Assets.onboardDialogDesc[index],
      textAlign: TextAlign.center,
      style: TextStyle(
      fontSize: 20,
      height: 1.2,
      color: UiConstants.accentColor,
      fontWeight: FontWeight.w300
      )
    );
  }

  Widget _addPageView() {
    return PageView(
      children: [
        _pageViewItem(0),
        _pageViewItem(1),
        _pageViewItem(2),
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
}
