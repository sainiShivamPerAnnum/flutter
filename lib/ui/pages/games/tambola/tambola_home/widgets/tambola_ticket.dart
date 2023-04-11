import 'package:felloapp/core/model/daily_pick_model.dart';
import 'package:felloapp/core/model/tambola_board_model.dart';
import 'package:felloapp/ui/pages/games/tambola/tambola_home/widgets/ticket_painter.dart';
import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TambolaTicket extends StatelessWidget {
  TambolaTicket({
    Key? key,
    this.board,
    this.dailyPicks,
    this.bestBoards,
    required this.calledDigits,
    this.showBestOdds = true,
    // this.ticketNo,
    // this.generatedDate,
    // required this.child,
  }) : super(key: key);

  // final String? ticketNo;
  // final String? generatedDate;
  // final Widget child;

  final TambolaBoard? board;
  final DailyPick? dailyPicks;
  final List<TambolaBoard?>? bestBoards;
  final List<int> calledDigits;
  final bool showBestOdds;

  List<int?> ticketNumbers = [];

  Color getColor(int index) {
    if (calledDigits.contains(ticketNumbers[index]) && shouldScrached()) {
      return UiConstants.kSaveDigitalGoldCardBg;
    } else {
      return Colors.transparent;
    }
  }

  Color getTextColor(int index) {
    if (calledDigits.contains(ticketNumbers[index]) && shouldScrached()) {
      return UiConstants.kBlogTitleColor;
    } else {
      return Colors.white;
    }
  }

  SingleChildRenderObjectWidget markStatus(int index) {
    if (calledDigits.contains(ticketNumbers[index])) {
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
    } else {
      return const SizedBox();
    }
  }

  void generateNumberList() {
    for (int i = 0; i < 3; i++) {
      for (int j = 0; j < 9; j++) {
        ticketNumbers.add(board!.tambolaBoard![i][j]);
      }
    }
  }

  String getTag() {
    final assignedWeekday = board!.assigned_time.toDate().weekday;
    final currentWeekday = DateTime.now().weekday;

    return (assignedWeekday == DateTime.sunday &&
            currentWeekday == DateTime.sunday &&
            board!.assigned_time.toDate().hour < 24 &&
            board!.assigned_time.toDate().hour >= 18)
        ? "NEXT WEEK"
        : (board!.assigned_time.toDate().day == DateTime.now().day)
            ? "NEW"
            : "";
  }

  bool shouldScrached() {
    // debugPrint("${DateTime.now().hour} -- ${DateTime.now().weekday}");
    if (board!.assigned_time.toDate().weekday == DateTime.sunday) {
      if (DateTime.now().weekday == DateTime.sunday) {
        return false;
      } else if ((DateTime.now().weekday == DateTime.monday) &&
          DateTime.now().hour < 18) {
        return false;
      }
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    S locale = S.of(context);
    if (ticketNumbers.isEmpty && board != null) generateNumberList();

    return Stack(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
              horizontal: SizeConfig.pageHorizontalMargins, vertical: 2),
          child: ClipPath(
            clipper: TicketPainter(),
            child: Container(
              // height: 175,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                        '#${board!.getTicketNumber()}',
                        style: TextStyles.sourceSans.body4
                            .colour(UiConstants.kGreyTextColor),
                      ),
                      Text(
                        '${locale.tGeneratedOn} ${DateFormat('d/M').format(DateTime.fromMillisecondsSinceEpoch(board!.assigned_time.millisecondsSinceEpoch))}',
                        style: TextStyles.sourceSans.body4
                            .colour(UiConstants.kGreyTextColor),
                      ),
                    ],
                  ),
                  SizedBox(height: SizeConfig.padding40),
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
                                      shouldScrached())
                                  ? null
                                  : BorderRadius.circular(
                                      SizeConfig.blockSizeHorizontal * 1),
                          border: Border.all(
                              color: (calledDigits.contains(ticketNumbers[i]) &&
                                      shouldScrached())
                                  ? const Color(0xff93B5FE)
                                  : Colors.white.withOpacity(
                                      ticketNumbers[i] == 0 ? 0.4 : 0.7),
                              width: calledDigits.contains(ticketNumbers[i])
                                  ? 0.0
                                  : ticketNumbers[i] == 0
                                      ? 0.5
                                      : 0.7),
                          shape: (calledDigits.contains(ticketNumbers[i]) &&
                                  shouldScrached())
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
                            if (shouldScrached()) markStatus(i)
                          ],
                        ),
                      );
                    },
                  ),
                  SizedBox(height: SizeConfig.padding8),
                ],
              ),
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          margin: const EdgeInsets.only(top: 40),
          child: MySeparator(
            color: Colors.white.withOpacity(0.3),
          ),
        ),
        getTag().length > 1
            ? Positioned.fill(
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
                          offset: const Offset(
                              0, 1.5), // changes position of shadow
                        ),
                      ],
                    ),
                    child: CustomPaint(
                      size: Size(80, (74 * 0.29).toDouble()),
                      painter: RPSCustomPainter(),
                    ),
                  ),
                ))
            : const SizedBox(),
        Positioned.fill(
          top: 2,
          child: Align(
            alignment: Alignment.topCenter,
            child: Text(
              getTag(),
              style: TextStyles.sourceSansSB.body4.colour(
                Colors.white.withOpacity(0.8),
              ),
            ),
          ),
        )
      ],
    );
  }
}
