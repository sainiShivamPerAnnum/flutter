import 'package:felloapp/main.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/pages/others/games/tambola/weekly_results/prize_loss.dart';
import 'package:felloapp/ui/pages/others/games/tambola/weekly_results/prize_partial_win.dart';
import 'package:felloapp/ui/pages/others/games/tambola/weekly_results/prize_win.dart';
import 'package:felloapp/ui/pages/others/games/tambola/weekly_results/processing.dart';
import 'package:felloapp/ui/pages/static/fello_appbar.dart';
import 'package:felloapp/ui/pages/static/home_background.dart';
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
  bool showBack = false;
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
        setState(() {
          showBack = true;
        });
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
      body: HomeBackground(
        child: Column(
          children: [
            FelloAppBar(
              leading: FelloAppBarBackButton(
                onBackPress: showBack == true
                    ? () => AppState.backButtonDispatcher.didPopRoute()
                    : () {},
              ),
              title: showBack == true ? "Tambola" : "Processing",
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(
                    horizontal: SizeConfig.pageHorizontalMargins),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(SizeConfig.padding40),
                    topRight: Radius.circular(SizeConfig.padding40),
                  ),
                  color: Colors.white,
                ),
                child: PageView(
                  physics: NeverScrollableScrollPhysics(),
                  controller: _pageController,
                  children: [
                    const PrizeProcessing(),
                    const Loser(),
                    PrizeWin(winningsMap: widget.winningsmap),
                    PrizePWin(winningsMap: widget.winningsmap)
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
