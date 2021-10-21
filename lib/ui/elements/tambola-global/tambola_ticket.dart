import 'package:felloapp/core/model/tambola_board_model.dart';
import 'package:felloapp/ui/elements/custom-art/tambola_ticket_painter.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class Ticket extends StatelessWidget {
  Ticket({
    @required this.bgColor,
    @required this.boardColorEven,
    @required this.boardColorOdd,
    @required this.boradColorMarked,
    @required this.board,
    @required this.calledDigits,
  });

  final bgColor, boardColorOdd, boardColorEven, boradColorMarked;
  final TambolaBoard board;
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

  List<IconData> oddsIcons = [
    Icons.apps,
    Icons.border_top,
    Icons.border_bottom,
    Icons.border_horizontal,
    Icons.border_outer
  ];
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
      height: SizeConfig.screenWidth - SizeConfig.pageHorizontalMargins * 2,
      width: SizeConfig.screenWidth - SizeConfig.pageHorizontalMargins * 2,
      decoration: BoxDecoration(
        color: UiConstants.scaffoldColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          width: 0,
          color: Theme.of(context).scaffoldBackgroundColor,
        ),
      ),
      margin: EdgeInsets.only(
        left: SizeConfig.blockSizeHorizontal * 3,
        bottom: SizeConfig.blockSizeHorizontal,
      ),
      child: Stack(
        children: [
          // Container(
          //   height: SizeConfig.screenWidth * 0.95,
          //   width: SizeConfig.screenWidth * 0.9,
          //   child: Opacity(
          //     opacity: 0.1,
          //     child: ClipRRect(
          //       borderRadius: BorderRadius.circular(14),
          //       child: Image.asset(
          //         "images/Tambola/ticket-bg.png",
          //         fit: BoxFit.cover,
          //       ),
          //     ),
          //   ),
          // ),
          CustomPaint(
            painter: TicketPainter(
                puchRadius: 20,
                color: Theme.of(context).scaffoldBackgroundColor),
            child: Column(
              children: [
                Expanded(
                  child: Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.symmetric(
                        horizontal: SizeConfig.blockSizeHorizontal * 5,
                        vertical: SizeConfig.blockSizeHorizontal * 2),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        //SizedBox(height: SizeConfig.padding16),
                        GridView.builder(
                          shrinkWrap: true,
                          itemCount: 27,
                          physics: NeverScrollableScrollPhysics(),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
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
                        Spacer(),
                        Text(
                          'Ticket #${board.getTicketNumber()}',
                          style: TextStyle(
                              color: UiConstants.primaryColor,
                              fontSize: SizeConfig.smallTextSize),
                        ),
                      ],
                    ),
                  ),
                ),
                Divider(
                  color: UiConstants.primaryColor,
                  indent: 40,
                  endIndent: 40,
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: SizeConfig.blockSizeHorizontal * 5,
                    ),
                    child: GridView.count(
                      physics: NeverScrollableScrollPhysics(),
                      childAspectRatio: 3.5 / 1,
                      crossAxisCount: 2,
                      children: List.generate(5, (index) {
                        return Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: Shimmer(
                                enabled: odds[index].left == 0,
                                direction: ShimmerDirection.fromLTRB(),
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: UiConstants.primaryLight
                                          .withOpacity(0.5),
                                      borderRadius: BorderRadius.circular(4)),
                                  child: Stack(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.all(4),
                                        child: Icon(odds[index].icon,
                                            color: UiConstants.primaryColor,
                                            size:
                                                SizeConfig.screenWidth * 0.06),
                                      ),
                                      odds[index].left == 0
                                          ? Transform.translate(
                                              offset: Offset(-3, -3),
                                              child: Image.network(
                                                "https://image.flaticon.com/icons/png/512/3699/3699516.png",
                                                height:
                                                    SizeConfig.largeTextSize,
                                                width: SizeConfig.largeTextSize,
                                              ),
                                            )
                                          : SizedBox()
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 12),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  odds[index].title,
                                  style: TextStyle(
                                    color: Colors.black38,
                                    fontSize: SizeConfig.smallTextSize,
                                  ),
                                ),
                                Text(
                                  "${odds[index].left} left",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w900,
                                      fontSize: SizeConfig.mediumTextSize),
                                ),
                              ],
                            )
                          ],
                        );
                      }),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: InkWell(
                onTap: () {
                  print(board.getTicketNumber());
                },
                child: Text(
                  "Generated on: ${DateTime.fromMillisecondsSinceEpoch(board.assigned_time.millisecondsSinceEpoch).day.toString().padLeft(2, '0')}-${DateTime.fromMillisecondsSinceEpoch(board.assigned_time.millisecondsSinceEpoch).month.toString().padLeft(2, '0')}-${DateTime.fromMillisecondsSinceEpoch(board.assigned_time.millisecondsSinceEpoch).year}",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: SizeConfig.smallTextSize,
                  ),
                ),
              ),
            ),
          )
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
