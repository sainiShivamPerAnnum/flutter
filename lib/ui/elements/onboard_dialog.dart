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
  void initState() {
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
      children: <Widget>[
        //...bottom card part,
        Container(
          padding: EdgeInsets.only(
            top: UiConstants.padding + 30,
            bottom: UiConstants.padding + 30,
            left: UiConstants.padding,
            right: UiConstants.padding,
          ),
          //margin: EdgeInsets.only(top: UiConstants.avatarRadius),
          decoration: new BoxDecoration(
            color: Colors.white,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(UiConstants.padding),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10.0,
                offset: const Offset(0.0, 10.0),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min, // To make the card compact
            children: <Widget>[
              SizedBox(
                child: Image(
                  image: AssetImage(Assets.onboardCollageGraphic),
                  fit: BoxFit.contain,
                ),
                width: 160,
                height: 160,
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                height: 120,
                child: _addPageView(),
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                  padding: EdgeInsets.only(left: 20, right: 20),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      (_pageIndex > 0)
                          ? InkWell(
                              child: Text(
                                'PREVIOUS',
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    color: UiConstants.accentColor,
                                    fontSize: 18),
                              ),
                              onTap: () {
                                if (_pageIndex > 0) {
                                  onTabTapped(_pageIndex - 1);
                                }
                              },
                            )
                          : Container(),
                      InkWell(
                        child: Text(
                          (_pageIndex == 2) ? 'GOT IT' : 'NEXT',
                          textAlign: TextAlign.right,
                          style: TextStyle(
                              color: UiConstants.accentColor, fontSize: 18),
                        ),
                        onTap: () {
                          if (_pageIndex < 2) {
                            onTabTapped(_pageIndex + 1);

                            // this._pageIndex = this._pageIndex + 1;
                            // setState(() {});
                          } else {
                            Navigator.of(context).pop();
                          }
                        },
                      )
                    ],
                  ))
            ],
          ),
        )
      ],
    );
  }

  Widget _pageViewItem(int index) {
    return Text(Assets.onboardDialogDesc[index],
        textAlign: TextAlign.center,
        style: TextStyle(
            fontSize: 20,
            height: 1.2,
            color: UiConstants.accentColor,
            fontWeight: FontWeight.w300));
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

  void onTabTapped(int index) {
    this._pageController.animateToPage(index,
        duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
  }
}
