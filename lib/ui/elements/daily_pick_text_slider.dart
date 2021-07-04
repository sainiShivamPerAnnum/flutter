import 'dart:async';

import 'package:felloapp/util/size_config.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DPTextSlider extends StatefulWidget {
  final List<String> infoList;

  DPTextSlider({this.infoList});

  @override
  State createState() => DPTextSliderState();
}

class DPTextSliderState extends State<DPTextSlider> {
  PageController _pageController;
  int _pageIndex = 0;
  Timer _timer;

  @override
  void initState() {
    super.initState();
    _pageIndex = 0;
    _pageController = PageController(initialPage: _pageIndex);

    _timer = Timer.periodic(Duration(seconds: 8), (Timer timer) {
      if (_pageIndex < widget.infoList.length - 1) {
        _pageIndex++;
      } else {
        _pageIndex = 0;
      }

      if (_pageController.positions.isNotEmpty)
        _pageController.animateToPage(
          _pageIndex,
          duration: Duration(milliseconds: 600),
          curve: Curves.easeIn,
        );
    });
  }

  @override
  void dispose() {
    super.dispose();
    //BaseUtil.infoSliderIndex = _pageIndex;
    _timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.transparent,
        height: 18.0,
        child: Padding(
            padding: EdgeInsets.only(left: 10, right: 10, top: 0, bottom: 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                    child: Container(
                  height: 18,
                  width: 400,
                  child: PageView(
                    physics: NeverScrollableScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    children: _buildTextPages(),
                    onPageChanged: onPageChanged,
                    controller: _pageController,
                  ),
                )),
              ],
            )));
  }

  List<Widget> _buildTextPages() {
    List<Widget> _pagerWidgets = [];
    if (widget.infoList == null || widget.infoList.length == 0) {
      _pagerWidgets.add(Text(''));
    }
    widget.infoList.forEach((info) {
      _pagerWidgets.add(
        Text(
          info,
          style: TextStyle(
              color: Colors.white70, fontSize: SizeConfig.smallTextSize * 1.4),
          textAlign: TextAlign.center,
        ),
      );
    });

    return _pagerWidgets;
  }

  void onPageChanged(int page) {
    setState(() {
      this._pageIndex = page;
    });
  }
}
