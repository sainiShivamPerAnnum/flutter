import 'package:felloapp/core/model/prizes_model.dart';
import 'package:felloapp/core/service/notifier_services/prize_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/pages/others/games/tambola/weekly_results/prize_loss.dart';
import 'package:felloapp/ui/pages/others/games/tambola/weekly_results/prize_partial_win.dart';
import 'package:felloapp/ui/pages/others/games/tambola/weekly_results/prize_win.dart';
import 'package:felloapp/ui/pages/others/games/tambola/weekly_results/processing.dart';
import 'package:felloapp/ui/pages/static/fello_appbar.dart';
import 'package:felloapp/ui/pages/static/new_square_background.dart';
import 'package:felloapp/ui/widgets/buttons/nav_buttons/nav_buttons.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
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

  final _prizeService = locator<PrizeService>();

  PrizesModel tPrizes;

  @override
  void initState() {
    print(widget.isEligible);
    print(widget.winningsmap);
    _pageController = PageController();
    tPrizes = _prizeService.tambolaPrizes;
    super.initState();
  }

  @override
  void didChangeDependencies() {
    Future.delayed(Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          showBack = true;
        });
        // if (!widget.isEligible && widget.winningsmap.isNotEmpty)
        //   _pageController.jumpToPage(3);
        if (widget.winningsmap.isNotEmpty)
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
      backgroundColor: UiConstants.kBackgroundColor2,
      body: Column(
        children: [
          FelloAppBar(
            showAppBar: false,
            backgroundColor: UiConstants.kBackgroundColor2,
            actions: [
              IconButton(
                onPressed: showBack == true
                    ? () => AppState.backButtonDispatcher.didPopRoute()
                    : () {},
                icon: Icon(
                  Icons.close,
                  color: Colors.white,
                  size: SizeConfig.padding28,
                ),
              )
            ],
          ),
          Expanded(
            child: PageView(
              physics: NeverScrollableScrollPhysics(),
              controller: _pageController,
              children: [
                const PrizeProcessing(),
                const Loser(),
                PrizeWin(
                  winningsMap: widget.winningsmap,
                  tPrizes: tPrizes,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
