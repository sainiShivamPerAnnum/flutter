import 'dart:math';

import 'package:felloapp/ui/architecture/base_view.dart';
import 'package:felloapp/ui/elements/tambola-global/weekly_picks.dart';
import 'package:felloapp/ui/pages/others/games/tambola/tambola_widgets/current_picks.dart';
import 'package:felloapp/ui/pages/others/games/tambola/tambola_widgets/picks_card/picks_card_vm.dart';
import 'package:felloapp/ui/pages/static/loader_widget.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

// class PicksCardView extends StatelessWidget {
//   final ValueChanged<bool> showBuyTicketModal;
//   final bool isForDemo;
//   PicksCardView({this.showBuyTicketModal, this.isForDemo = false});

//   @override
//   Widget build(BuildContext context) {
//     return BaseView<PicksCardViewModel>(
//       onModelReady: (model) => model.init(),
//       builder: (ctx, model, child) => GestureDetector(
//         onTap: isForDemo ? () {} : () => model.onTap(showBuyTicketModal),
//         child: AnimatedContainer(
//           width: SizeConfig.screenWidth,
//           height: model.topCardHeight,
//           duration: Duration(seconds: 1),
//           curve: Curves.ease,
//           decoration: BoxDecoration(),
//           margin: EdgeInsets.all(
//             SizeConfig.pageHorizontalMargins,
//           ),
//           child: Stack(
//             children: [
//               FractionallySizedBox(
//                 heightFactor: 0.8,
//                 alignment: Alignment.topCenter,
//                 widthFactor: 1,
//                 child: AnimatedContainer(
//                   duration: Duration(seconds: 1),
//                   curve: Curves.ease,
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(SizeConfig.roundness32),
//                     color: UiConstants.primaryColor,
//                   ),
//                 ),
//               ),
//               Positioned(
//                 bottom: 0,
//                 child: SvgPicture.asset(
//                   Assets.dailyPickCard,
//                   width: SizeConfig.screenWidth -
//                       SizeConfig.pageHorizontalMargins * 2,
//                 ),
//               ),
//               AnimatedContainer(
//                 width: SizeConfig.screenWidth,
//                 height: model.topCardHeight,
//                 duration: Duration(seconds: 1),
//                 curve: Curves.ease,
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     !model.isShowingAllPicks
//                         ? (isForDemo
//                             ? CurrentPicks(
//                                 dailyPicksCount: model.dailyPicksCount,
//                                 todaysPicks: List.generate(
//                                     model.dailyPicksCount,
//                                     (index) => Random().nextInt(90)),
//                               )
//                             : CurrentPicks(
//                                 dailyPicksCount: model.dailyPicksCount,
//                                 todaysPicks: model.todaysPicks,
//                               ))
//                         : WeeklyPicks(
//                             weeklyDraws: model.weeklyDigits,
//                           ),
//                     if (!model.isShowingAllPicks)
//                       SizedBox(
//                         height: SizeConfig.screenWidth * 0.04,
//                       )
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

class PicksCardView extends StatelessWidget {
  final ValueChanged<bool> showBuyTicketModal;
  final bool isForDemo;
  PicksCardView({this.showBuyTicketModal, this.isForDemo = false});

  @override
  Widget build(BuildContext context) {
    return BaseView<PicksCardViewModel>(
      onModelReady: (model) => model.init(),
      builder: (ctx, model, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal:
                        SizeConfig.pageHorizontalMargins + SizeConfig.padding2),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Picks",
                          style: TextStyles.rajdhaniSB.body0,
                        ),
                        Text(
                          model.isShowingAllPicks
                              ? "Next draw at 6 pm"
                              : "Drawn at 6 PM",
                          style: TextStyles.sourceSans.body4
                              .colour(UiConstants.kTextColor2),
                        ),
                      ],
                    ),
                    TextButton(
                      onPressed: () {
                        model.onTap(showBuyTicketModal);
                      },
                      child: Text(
                        model.isShowingAllPicks ? "Weekly" : "Today",
                        style: TextStyles.sourceSansSB.body2
                            .colour(UiConstants.kTabBorderColor),
                      ),
                    )
                  ],
                ),
              ),
            ),
            SizedBox(
              height: SizeConfig.padding12,
            ),
            Container(
              width: SizeConfig.screenWidth,
              height: SizeConfig.screenWidth * 0.5,
              decoration: BoxDecoration(
                color: UiConstants.kSnackBarPositiveContentColor,
                borderRadius:
                    BorderRadius.all(Radius.circular(SizeConfig.roundness24)),
              ),
              margin: EdgeInsets.symmetric(
                horizontal: SizeConfig.pageHorizontalMargins,
              ),
              child: AnimatedSwitcher(
                switchInCurve: Curves.easeIn,
                switchOutCurve: Curves.easeIn,
                duration: const Duration(milliseconds: 500),
                child: !model.isShowingAllPicks
                    ? (isForDemo
                        ? CurrentPicks(
                            dailyPicksCount: model.dailyPicksCount,
                            todaysPicks: List.generate(model.dailyPicksCount,
                                (index) => Random().nextInt(90)),
                          )
                        : CurrentPicks(
                            dailyPicksCount: model.dailyPicksCount,
                            todaysPicks: model.todaysPicks != null
                                ? model.todaysPicks
                                : List.generate(
                                    model.dailyPicksCount, (index) => 0),
                          ))
                    : model.weeklyDigits == null
                        ? FullScreenLoader(
                            size: SizeConfig.screenWidth * 0.3,
                          )
                        : WeeklyPicks(
                            weeklyDraws: model.weeklyDigits,
                          ),
              ),
            ),
          ],
        );
      },
    );
  }
}
