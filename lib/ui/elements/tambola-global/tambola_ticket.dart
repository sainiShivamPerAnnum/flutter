import 'package:felloapp/core/model/daily_pick_model.dart';
import 'package:felloapp/core/model/tambola_board_model.dart';
import 'package:felloapp/ui/elements/custom-art/tambola_ticket_painter.dart';
import 'package:felloapp/ui/elements/tambola-global/weekly_picks.dart';
import 'package:felloapp/ui/pages/others/games/tambola/tambola_game/tambola_game_view.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class Ticket extends StatelessWidget {
  Ticket(
      {@required this.board,
      @required this.calledDigits,
      @required this.bestBoards,
      @required this.dailyPicks});

  final TambolaBoard board;
  final DailyPick dailyPicks;
  final List<TambolaBoard> bestBoards;
  final List<int> calledDigits;

  //List<int> markedIndices = [];
  List<int> ticketNumbers = [];
  List<TicketOdds> odds = [];

  // markItem(int index) {
  //   print("marked index : $index");
  //   if (markedIndices.contains(index))
  //     markedIndices.remove(index);
  //   else
  //     markedIndices.add(index);
  //   setState(() {});
  // }

  getColor(int index) {
    if (calledDigits.contains(ticketNumbers[index])) return Color(0xffFDA77F);
    if (index % 2 == 0) {
      return UiConstants.primaryLight;
    } else {
      return UiConstants.primaryColor;
    }
  }

  getTextColor(int index) {
    if (calledDigits.contains(ticketNumbers[index])) return Colors.white;
    if (index % 2 != 0) {
      return UiConstants.primaryLight;
    } else {
      return UiConstants.primaryColor;
    }
  }

  markStatus(int index) {
    if (calledDigits.contains(ticketNumbers[index])) {
      return Align(
        alignment: Alignment.center,
        child: Transform.rotate(
          angle: -45,
          alignment: Alignment.center,
          child: Container(
            margin: EdgeInsets.all(2),
            width: 2,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.5),
              borderRadius: BorderRadius.circular(100),
            ),
          ),
        ),
      );
    } else {
      return SizedBox();
    }
  }

  generateOdds() {
    odds = [
      TicketOdds(
        color: Color(0xffE76F51),
        icon: Icons.apps,
        title: "Full House",
        left: board.getFullHouseOdds(calledDigits),
      ),
      TicketOdds(
          color: Color(0xff264653),
          icon: Icons.border_top,
          title: "Top Row",
          left: board.getRowOdds(0, calledDigits)),
      TicketOdds(
          color: Color(0xff264653),
          icon: Icons.border_horizontal,
          title: "Middle Row",
          left: board.getRowOdds(1, calledDigits)),
      TicketOdds(
          color: Color(0xff264653),
          icon: Icons.border_bottom,
          title: "Bottom Row",
          left: board.getRowOdds(2, calledDigits)),
      TicketOdds(
          color: Color(0xff865858),
          icon: Icons.border_outer,
          title: "Corners",
          left: board.getCornerOdds(calledDigits)),
    ];
  }

  generateNumberList() {
    for (int i = 0; i < 3; i++) {
      for (int j = 0; j < 9; j++) {
        ticketNumbers.add(board.tambolaBoard[i][j]);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (odds.isEmpty || ticketNumbers.isEmpty) {
      generateNumberList();
      generateOdds();
    }
    return Container(
      height: SizeConfig.screenWidth * 1.3,
      width: SizeConfig.screenWidth - SizeConfig.pageHorizontalMargins * 2,
      decoration: BoxDecoration(
        color: UiConstants.scaffoldColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          width: 0,
          color: Theme.of(context).scaffoldBackgroundColor,
        ),
      ),
      margin: EdgeInsets.symmetric(
        horizontal: SizeConfig.pageHorizontalMargins,
      ),
      child: Column(
        children: [
          Container(
            alignment: Alignment.center,
            padding: EdgeInsets.all(SizeConfig.padding16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Ticket #${board.getTicketNumber()}',
                  style: TextStyles.body3.colour(UiConstants.primaryColor),
                ),
                SizedBox(height: SizeConfig.padding16),
                GridView.builder(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  itemCount: 27,
                  physics: NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 9,
                  ),
                  itemBuilder: (ctx, i) {
                    return Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: getColor(i),
                        borderRadius: BorderRadius.circular(
                            SizeConfig.blockSizeHorizontal * 3),
                      ),
                      child: Stack(
                        children: [
                          Align(
                            alignment: Alignment.center,
                            child: Text(
                              ticketNumbers[i] == 0
                                  ? ""
                                  : ticketNumbers[i].toString(),
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: SizeConfig.mediumTextSize,
                                color: getTextColor(i),
                              ),
                            ),
                          ),
                          markStatus(i)
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: SizeConfig.padding16,
                ),
                child: Odds(dailyPicks, board, bestBoards)),
          ),
          Padding(
            padding: EdgeInsets.all(SizeConfig.padding12),
            child: InkWell(
              onTap: () {
                print(board.getTicketNumber());
              },
              child: Text(
                "Generated on: ${DateTime.fromMillisecondsSinceEpoch(board.assigned_time.millisecondsSinceEpoch).day.toString().padLeft(2, '0')}-${DateTime.fromMillisecondsSinceEpoch(board.assigned_time.millisecondsSinceEpoch).month.toString().padLeft(2, '0')}-${DateTime.fromMillisecondsSinceEpoch(board.assigned_time.millisecondsSinceEpoch).year}",
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: SizeConfig.smallTextSize,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class TicketOdds {
  final String title;
  final int left;
  final IconData icon;
  final Color color;

  TicketOdds({this.icon, this.left, this.title, this.color});
}


//  ListView(
                //   padding: EdgeInsets.zero,
                //   children: List.generate(5, (index) {
                //     return Container(
                //       margin: EdgeInsets.symmetric(
                //           vertical: SizeConfig.padding8),
                //       child: Row(
                //         children: [
                //           ClipRRect(
                //             borderRadius: BorderRadius.circular(4),
                //             child: Shimmer(
                //               enabled: odds[index].left == 0,
                //               direction: ShimmerDirection.fromLTRB(),
                //               child: Container(
                //                 decoration: BoxDecoration(
                //                     color: UiConstants.primaryLight
                //                         .withOpacity(0.5),
                //                     borderRadius: BorderRadius.circular(4)),
                //                 child: Stack(
                //                   children: [
                //                     Padding(
                //                       padding: EdgeInsets.all(4),
                //                       child: Icon(odds[index].icon,
                //                           color: UiConstants.primaryColor,
                //                           size: SizeConfig.screenWidth *
                //                               0.06),
                //                     ),
                //                     odds[index].left == 0
                //                         ? Transform.translate(
                //                             offset: Offset(-3, -3),
                //                             child: Image.network(
                //                               "https://image.flaticon.com/icons/png/512/3699/3699516.png",
                //                               height:
                //                                   SizeConfig.largeTextSize,
                //                               width:
                //                                   SizeConfig.largeTextSize,
                //                             ),
                //                           )
                //                         : SizedBox()
                //                   ],
                //                 ),
                //               ),
                //             ),
                //           ),
                //           SizedBox(width: 12),
                //           Expanded(
                //             child: Text(
                //               odds[index].title,
                //               style: TextStyle(
                //                 color: Colors.black38,
                //                 fontSize: SizeConfig.smallTextSize,
                //               ),
                //             ),
                //           ),
                //           Text(
                //             "${odds[index].left} left",
                //             style: TextStyles.body4.bold,
                //           ),
                //           Spacer(),
                //           Column(
                //             children: [
                //               Text(
                //                 "${odds[index].left} left",
                //                 style: TextStyles.body4.bold,
                //               ),
                //               SizedBox(height: SizeConfig.padding2),
                //               Text(
                //                 "1 Left",
                //                 style: TextStyles.body4.bold.underline
                //                     .colour(UiConstants.primaryColor),
                //               )
                //             ],
                //           ),
                //         ],
                //       ),
                //     );
                //   }),
                // ),