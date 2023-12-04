import 'package:felloapp/feature/tambola/src/models/tambola_ticket_model.dart';
import 'package:felloapp/feature/tambola/src/ui/widgets/ticket/ticket_painter.dart';
import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TambolaTicket extends StatelessWidget {
  TambolaTicket({
    required this.board,
    required this.calledDigits,
    Key? key,
  }) : super(key: key) {
    generateNumberList();
  }

  final TambolaTicketModel board;
  final List<int> calledDigits;

  final List<int?> ticketNumbers = [];

  Color getColor(int index) {
    if (calledDigits.contains(ticketNumbers[index]) && shouldScratched()) {
      return UiConstants.kSaveDigitalGoldCardBg;
    } else {
      return Colors.transparent;
    }
  }

  Color getTextColor(int index) {
    if (calledDigits.contains(ticketNumbers[index]) && shouldScratched()) {
      return UiConstants.kBlogTitleColor;
    } else {
      return Colors.white;
    }
  }

  Widget markStatus(int index) {
    return (calledDigits.contains(ticketNumbers[index]) && shouldScratched())
        ? const DigitStrike()
        : const SizedBox();
  }

  void generateNumberList() {
    for (int i = 0; i < 3; i++) {
      for (int j = 0; j < 9; j++) {
        ticketNumbers.add(board.tambolaBoard![i][j]);
      }
    }
  }

  String getTag() {
    final assignedWeekday = board.assignedTime.toDate().weekday;
    final currentWeekday = DateTime.now().weekday;

    return (assignedWeekday == DateTime.sunday &&
            currentWeekday == DateTime.sunday &&
            board.assignedTime.toDate().hour < 24 &&
            board.assignedTime.toDate().hour >= 18)
        ? "NEXT WEEK"
        : (board.assignedTime.toDate().day == DateTime.now().day)
            ? "NEW"
            : "";
  }

  bool shouldScratched() {
    if (board.assignedTime.toDate().weekday == DateTime.sunday &&
        board.assignedTime.toDate().hour > 18) {
      if (DateTime.now().weekday == DateTime.sunday &&
          board.assignedTime.toDate().day == DateTime.now().day) {
        return false;
      }
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    // S locale = S.of(context);
    print("Building ticket");
    return Stack(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
              horizontal: SizeConfig.pageHorizontalMargins, vertical: 2),
          child: CustomPaint(
            painter: const TicketPainter(),
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: SizeConfig.padding16,
                vertical: SizeConfig.padding16,
              ),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: UiConstants.kBuyTicketBg,
                borderRadius: BorderRadius.circular(10.0),
                border: Border.all(
                    color: UiConstants.kFAQDividerColor.withOpacity(0.2),
                    width: 1.5),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '#${board.getTicketNumber()}',
                        style: TextStyles.sourceSans.body4
                            .colour(UiConstants.kGreyTextColor),
                      ),
                      Text(
                        'Generated on ${DateFormat('d/M').format(DateTime.fromMillisecondsSinceEpoch(board.assignedTime.millisecondsSinceEpoch))}',
                        style: TextStyles.sourceSans.body4
                            .colour(UiConstants.kGreyTextColor),
                      ),
                    ],
                  ),
                  Container(
                    padding:
                        EdgeInsets.symmetric(vertical: SizeConfig.padding20),
                    alignment: Alignment.center,
                    child: MySeparator(
                      color: Colors.white.withOpacity(0.3),
                    ),
                  ),
                  GridView.builder(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    itemCount: 27,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 9,
                      mainAxisSpacing: 2,
                      crossAxisSpacing: 1,
                    ),
                    itemBuilder: (ctx, i) {
                      return Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: getColor(i),
                          borderRadius:
                              (calledDigits.contains(ticketNumbers[i]) &&
                                      shouldScratched())
                                  ? null
                                  : BorderRadius.circular(
                                      SizeConfig.blockSizeHorizontal * 1),
                          border: Border.all(
                              color: (calledDigits.contains(ticketNumbers[i]) &&
                                      shouldScratched())
                                  ? const Color(0xff93B5FE)
                                  : Colors.white.withOpacity(
                                      ticketNumbers[i] == 0 ? 0.4 : 0.7),
                              width: calledDigits.contains(ticketNumbers[i])
                                  ? 0.0
                                  : ticketNumbers[i] == 0
                                      ? 0.5
                                      : 0.7),
                          shape: (calledDigits.contains(ticketNumbers[i]) &&
                                  shouldScratched())
                              ? BoxShape.circle
                              : BoxShape.rectangle,
                        ),
                        child: Stack(
                          children: [
                            Align(
                              alignment: Alignment.center,
                              child: Text(
                                ticketNumbers[i] == 0
                                    ? ""
                                    : ticketNumbers[i].toString(),
                                style: TextStyles.rajdhaniB.body2
                                    .colour(getTextColor(i)),
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
          ),
        ),
        if (getTag().isNotEmpty) TicketTag(tag: getTag())
      ],
    );
  }
}

class TicketTag extends StatelessWidget {
  final String tag;
  const TicketTag({required this.tag, super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: SizeConfig.padding20,
      width: SizeConfig.padding100,
      child: Stack(
        children: [
          Positioned.fill(
            top: -1,
            child: Align(
              alignment: Alignment.topCenter,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      spreadRadius: 1,
                      blurRadius: 3,
                      offset:
                          const Offset(0, 1.5), // changes position of shadow
                    ),
                  ],
                ),
                child: CustomPaint(
                  size: Size(80, (74 * 0.29).toDouble()),
                  painter: RPSCustomPainter(),
                ),
              ),
            ),
          ),
          Positioned.fill(
            top: 0,
            child: Align(
              alignment: Alignment.topCenter,
              child: Text(
                tag,
                style: TextStyles.sourceSansSB.body4.colour(
                  Colors.white.withOpacity(0.8),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class DigitStrike extends StatelessWidget {
  const DigitStrike({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Transform.rotate(
        angle: -45,
        alignment: Alignment.center,
        child: Container(
          // margin: const EdgeInsets.all(1),
          width: 1,
          decoration: BoxDecoration(
            color: UiConstants.kBlogTitleColor,
            borderRadius: BorderRadius.circular(100),
          ),
        ),
      ),
    );
  }
}
