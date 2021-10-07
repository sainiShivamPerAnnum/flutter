import 'package:felloapp/main.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/pages/tabs/games/tambola/weekly-results-scenes/prize_loss.dart';
import 'package:felloapp/ui/pages/tabs/games/tambola/weekly-results-scenes/prize_partial_win.dart';
import 'package:felloapp/ui/pages/tabs/games/tambola/weekly-results-scenes/prize_win.dart';
import 'package:felloapp/ui/pages/tabs/games/tambola/weekly-results-scenes/processing.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:flutter/material.dart';

class WeeklyResult extends StatefulWidget {
  final Map<String, int> winningsmap;
  final bool isEligible;
  const WeeklyResult({Key key, this.isEligible, this.winningsmap})
      : super(key: key);

  @override
  _WeeklyResultState createState() => _WeeklyResultState();
}

class _WeeklyResultState extends State<WeeklyResult> {
  PageController _pageController;
  @override
  void initState() {
    print(widget.isEligible);
    print(widget.winningsmap);
    _pageController = PageController();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    Future.delayed(Duration(seconds: 3), () {
      if (mounted) {
        if (!widget.isEligible && widget.winningsmap.isNotEmpty)
          _pageController.jumpToPage(3);
        else if (widget.isEligible && widget.winningsmap.isNotEmpty)
          _pageController.jumpToPage(2);
        else
          _pageController.jumpToPage(1);
      }
    });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: SizedBox(),
          elevation: 0,
          centerTitle: true,
          backgroundColor: Color(0xffF5DFC3),
          title: Image.asset(
            "images/fello_logo.png",
            height: kToolbarHeight * 0.6,
          ),
          actions: [
            IconButton(
              onPressed: () => AppState.backButtonDispatcher.didPopRoute(),
              icon: Icon(
                Icons.close,
                color: Color(0xff272727),
              ),
            ),
          ]),
      body: PageView(
        physics: NeverScrollableScrollPhysics(),
        controller: _pageController,
        children: [
          const PrizeProcessing(),
          const Loser(),
          PrizeWin(winningsMap: widget.winningsmap),
          PrizePWin(winningsMap: widget.winningsmap)
        ],
      ),
    );
  }
}
