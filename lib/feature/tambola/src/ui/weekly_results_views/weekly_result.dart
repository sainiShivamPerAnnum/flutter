import 'package:felloapp/core/model/prizes_model.dart';
import 'package:felloapp/core/model/winners_model.dart';
import 'package:felloapp/feature/tambola/src/services/tambola_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/pages/static/fello_appbar.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';

import 'prize_loss.dart';
import 'prize_win.dart';
import 'processing.dart';

class WeeklyResult extends StatefulWidget {
  final Winners winner;
  final bool isEligible;
  const WeeklyResult({required this.winner, required this.isEligible, Key? key})
      : super(key: key);

  @override
  _WeeklyResultState createState() => _WeeklyResultState();
}

class _WeeklyResultState extends State<WeeklyResult> {
  PageController? _pageController;
  bool showBack = false;

  final TambolaService _tambolaService = locator<TambolaService>();

  PrizesModel? tPrizes;

  @override
  void initState() {
    _pageController = PageController();
    tPrizes = _tambolaService.tambolaPrizes;
    super.initState();
  }

  @override
  void didChangeDependencies() {
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          showBack = true;
        });
        if (widget.winner.amount! > 0) {
          _pageController!.jumpToPage(2);
        } else {
          _pageController!.jumpToPage(1);
        }
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
                    ? () => AppState.backButtonDispatcher!.didPopRoute()
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
              physics: const NeverScrollableScrollPhysics(),
              controller: _pageController,
              children: [
                const PrizeProcessing(),
                const Loser(),
                PrizeWin(
                    winner: widget.winner,
                    tPrizes: tPrizes,
                    isEligible: widget.isEligible),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
