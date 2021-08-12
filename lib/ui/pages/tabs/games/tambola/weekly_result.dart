import 'package:felloapp/ui/pages/tabs/games/tambola/weekly-results-scenes/prize_loss.dart';
import 'package:felloapp/ui/pages/tabs/games/tambola/weekly-results-scenes/prize_partial_win.dart';
import 'package:felloapp/ui/pages/tabs/games/tambola/weekly-results-scenes/prize_win.dart';
import 'package:felloapp/ui/pages/tabs/games/tambola/weekly-results-scenes/processing.dart';
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
      if (!widget.isEligible && widget.winningsmap.isNotEmpty)
        _pageController.jumpToPage(3);
      else if (widget.isEligible && widget.winningsmap.isNotEmpty)
        _pageController.jumpToPage(2);
      else
        _pageController.jumpToPage(1);
    });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
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
