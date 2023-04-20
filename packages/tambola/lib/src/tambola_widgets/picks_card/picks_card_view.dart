import 'package:flutter/material.dart';
import 'package:tambola/src/tambola-global/weekly_picks.dart';
import 'package:tambola/src/tambola_home/widgets/height_adaptive_page_view.dart';
import 'package:tambola/src/tambola_widgets/current_picks.dart';
import 'package:tambola/src/utils/styles/styles.dart';

class PicksCardView extends StatefulWidget {
  const PicksCardView({super.key});

  @override
  State<PicksCardView> createState() => _PicksCardViewState();
}

class _PicksCardViewState extends State<PicksCardView> {
  PageController? controller;
  int tabNo = 0;
  bool isShowingAllPicks = false;
  double titleOpacity = 1.0;

  @override
  void initState() {
    // TODO: implement initState
    controller = PageController();
    // await _tambolaService!.fetchWeeklyPicks();

    // fetchTodaysPicks();

    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return
        // BaseView<PicksCardViewModel>(
        //   onModelReady: (model) => model.init(),
        //   builder: (ctx, model, child) {

        //     return
        Container(
      width: SizeConfig.screenWidth,
      decoration: BoxDecoration(
        color: UiConstants.kSnackBarPositiveContentColor,
        borderRadius: BorderRadius.all(
          Radius.circular(SizeConfig.roundness12),
        ),
      ),
      margin: EdgeInsets.symmetric(
        horizontal: SizeConfig.pageHorizontalMargins,
      ),
      padding: EdgeInsets.symmetric(vertical: SizeConfig.padding12),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Container(
                  margin: const EdgeInsets.only(left: 15),
                  child: TextButton(
                    onPressed: () {}, //model.switchTab(0),
                    child: Text(
                      "Today's Picks",
                      style: TextStyles.sourceSansSB.body1
                          .colour(UiConstants.titleTextColor)
                          .setOpacity(
                            1.0,

                            // model.tabNo == 0
                            //   ? 1
                            //   : 0.6
                          ), // TextStyles.sourceSansSB.body1,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.only(right: 15),
                  child: TextButton(
                    onPressed: () {}, // model.switchTab(1),
                    child: Text(
                      'Weekly Picks',
                      style: TextStyles.sourceSansSB.body1
                          .colour(UiConstants.titleTextColor)
                          .setOpacity(1

                              // model.tabNo == 1
                              //   ? 1
                              //   : 0.6
                              ), //tyle: TextStyles.sourceSansSB.body1,
                    ),
                  ),
                ),
              )
            ],
          ),
          Row(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 500),
                height: 5,
                width: 0.5, // model.tabPosWidthFactor,
              ),
              Container(
                height: 5,
                width: SizeConfig.screenWidth! / 2 -
                    SizeConfig.pageHorizontalMargins * 2,
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(5))),
              )
            ],
          ),
          AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInCubic,
            height: SizeConfig
                .padding32, //   model.tabNo == 0 ? SizeConfig.padding32 : SizeConfig.padding16,
          ),
          HeightAdaptivePageView(
            controller: controller,
            onPageChanged: (int page) {
              // model.switchTab(page);
            },
            children: const [
              CurrentPicks(),
              WeeklyPicks(
                weeklyDraws: null,
                // model.weeklyDigits
              )
            ],
          ),
        ],
      ),
    );
    //   },
    // );
  }
}
