import 'package:flutter/material.dart';
import 'package:tambola/src/models/prizes_model.dart';
import 'package:tambola/src/utils/styles/styles.dart';
import 'package:tambola/src/weekly_results/prize_loss.dart';
import 'package:tambola/src/weekly_results/prize_win.dart';
import 'package:tambola/src/weekly_results/processing.dart';

class WeeklyResult extends StatefulWidget {
  final Map<String, int>? winningsmap;
  final bool? isEligible;
  const WeeklyResult({Key? key, this.isEligible, this.winningsmap})
      : super(key: key);

  @override
  _WeeklyResultState createState() => _WeeklyResultState();
}

class _WeeklyResultState extends State<WeeklyResult> {
  PageController? _pageController;
  bool showBack = false;

  // final PrizeService _prizeService = locator<PrizeService>();

  PrizesModel? tPrizes;

  @override
  void initState() {
    debugPrint(widget.isEligible.toString());
    debugPrint(widget.winningsmap.toString());
    _pageController = PageController();
    // tPrizes = _prizeService!.gamePrizeMap[Constants.GAME_TYPE_TAMBOLA];
    super.initState();
  }

  @override
  void didChangeDependencies() {
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          showBack = true;
        });
        // if (!widget.isEligible && widget.winningsmap.isNotEmpty)
        //   _pageController.jumpToPage(3);
        if (widget.winningsmap!.isNotEmpty) {
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
          //TODO: REVERT WHEN PACAKGE IS SETUP

          // FelloAppBar(
          //   showAppBar: false,
          //   backgroundColor: UiConstants.kBackgroundColor2,
          //   actions: [
          //     IconButton(
          //       onPressed: showBack == true
          //           ? () => AppState.backButtonDispatcher!.didPopRoute()
          //           : () {},
          //       icon: Icon(
          //         Icons.close,
          //         color: Colors.white,
          //         size: SizeConfig.padding28,
          //       ),
          //     )
          //   ],
          // ),
          Expanded(
            child: PageView(
              physics: const NeverScrollableScrollPhysics(),
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
