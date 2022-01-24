import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/model/daily_pick_model.dart';
import 'package:felloapp/core/model/tambola_board_model.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';

class Ticket extends StatelessWidget {
  Ticket({
    @required this.board,
    @required this.calledDigits,
    this.bestBoards,
    this.dailyPicks,
    this.showBestOdds = true,
  });

  final TambolaBoard board;
  final DailyPick dailyPicks;
  final List<TambolaBoard> bestBoards;
  final List<int> calledDigits;
  final bool showBestOdds;

  //List<int> markedIndices = [];
  List<int> ticketNumbers = [];

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

  generateNumberList() {
    for (int i = 0; i < 3; i++) {
      for (int j = 0; j < 9; j++) {
        ticketNumbers.add(board.tambolaBoard[i][j]);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (ticketNumbers.isEmpty) generateNumberList();
    print(calledDigits);
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
              child: Odds(dailyPicks, board, bestBoards, showBestOdds),
            ),
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

class Odds extends StatelessWidget {
  final DailyPick _digitsObj;
  final TambolaBoard _board;
  final List<TambolaBoard> _bestBoards;
  final bool showBestBoard;

  Odds(this._digitsObj, this._board, this._bestBoards, this.showBestBoard);

  @override
  Widget build(BuildContext cx) {
    if (_board == null) return Container();
    List<int> _digits = (_digitsObj != null) ? _digitsObj.toList() : [];
    return Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        // padding: EdgeInsets.zero,
        // physics: NeverScrollableScrollPhysics(),
        // itemCount: 6,
        children: List.generate(
          5,
          (index) {
            switch (index) {
              case 0:
                return _buildRow(
                    cx,
                    Icons.border_top,
                    'Top Row',
                    _board.getRowOdds(0, _digits).toString() + ' left',
                    _bestBoards[0].getRowOdds(0, _digits).toString() + ' left',
                    _bestBoards[0],
                    _digits);
              case 1:
                return _buildRow(
                    cx,
                    Icons.border_horizontal,
                    'Middle Row',
                    _board.getRowOdds(1, _digits).toString() + ' left',
                    _bestBoards[1].getRowOdds(1, _digits).toString() + ' left',
                    _bestBoards[1],
                    _digits);
              case 2:
                return _buildRow(
                    cx,
                    Icons.border_bottom,
                    'Bottom Row',
                    _board.getRowOdds(2, _digits).toString() + ' left',
                    _bestBoards[2].getRowOdds(2, _digits).toString() + ' left',
                    _bestBoards[2],
                    _digits);
              case 3:
                return _buildRow(
                    cx,
                    Icons.border_outer,
                    'Corners',
                    _board.getCornerOdds(_digits).toString() + ' left',
                    _bestBoards[3].getCornerOdds(_digits).toString() + ' left',
                    _bestBoards[3],
                    _digits);
              case 4:
                return _buildRow(
                    cx,
                    Icons.apps,
                    'Full House',
                    _board.getFullHouseOdds(_digits).toString() + ' left',
                    _bestBoards[4].getFullHouseOdds(_digits).toString() +
                        ' left',
                    _bestBoards[4],
                    _digits);

              default:
                return _buildRow(
                    cx,
                    Icons.border_top,
                    'Top Row',
                    _board.getRowOdds(0, _digits).toString() + ' left',
                    _bestBoards[0].getRowOdds(0, _digits).toString() + ' left',
                    _bestBoards[0],
                    _digits);
            }
          },
        ));
  }

  Widget _buildRow(BuildContext cx, IconData _i, String _title, String _tOdd,
      String _oOdd, TambolaBoard _bestBoard, List<int> _digits) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: SizeConfig.padding12),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(
              flex: showBestBoard ? 1 : 2,
              child: Row(
                children: [
                  CircleAvatar(
                      radius: SizeConfig.padding20,
                      backgroundColor:
                          UiConstants.primaryColor.withOpacity(0.1),
                      child: Icon(_i,
                          size: SizeConfig.padding20,
                          color: UiConstants.primaryColor)),
                  SizedBox(width: SizeConfig.padding12),
                  Expanded(
                    child: Text(_title, maxLines: 2, style: TextStyles.body3),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Text(_tOdd, style: TextStyles.body3),
                  SizedBox(height: SizeConfig.padding2),
                  Text('This ticket',
                      style: TextStyles.body4.colour(Colors.grey))
                ],
              ),
            ),
            if (showBestBoard)
              Expanded(
                child: InkWell(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Text(_oOdd, style: TextStyles.body3),
                      SizedBox(height: SizeConfig.padding4),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: SizeConfig.padding8,
                          vertical: SizeConfig.padding2,
                        ),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            color: UiConstants.primaryColor.withOpacity(0.2)),
                        child: Text('Best ticket',
                            textAlign: TextAlign.center,
                            style: TextStyles.body4
                                .colour(UiConstants.primaryColor)),
                      )
                    ],
                  ),
                  onTap: () {
                    BaseUtil.openDialog(
                      addToScreenStack: true,
                      hapticVibrate: true,
                      isBarrierDismissable: true,
                      content: Dialog(
                        backgroundColor: Colors.transparent,
                        child: Container(
                          height: SizeConfig.screenWidth * 1.3,
                          width: SizeConfig.screenWidth -
                              SizeConfig.pageHorizontalMargins * 2,
                          child: Transform.scale(
                            scale: 1.1,
                            child: Ticket(
                                dailyPicks: _digitsObj,
                                bestBoards: _bestBoards,
                                board: _bestBoard,
                                showBestOdds: false,
                                calledDigits: _digits),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
          ]),
    );
  }
}
