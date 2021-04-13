import 'package:felloapp/core/model/TambolaBoard.dart';
import 'package:felloapp/ui/elements/tambola_board_view.dart';
import 'package:felloapp/util/logger.dart';
import 'package:felloapp/util/ui_constants.dart';
import 'package:flutter/material.dart';

class TambolaDialog extends StatelessWidget {
  final Log log = new Log('TambolaDialog');
  TambolaBoard board;
  List<int> digits;

  TambolaDialog({this.board, this.digits});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.only(left: 20, top: 50, bottom: 80, right: 20),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: dialogContent(context),
    );
  }

  dialogContent(BuildContext context) {
    return Column(
        //overflow: Overflow.visible,
        //alignment: Alignment.topCenter,
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          TambolaBoardView(
            tambolaBoard: this.board.tambolaBoard,
            calledDigits: this.digits,
            boardColor: UiConstants.primaryColor,
          ),
          Text(
            'Ticket #' + this.board.getTicketNumber(),
            style: TextStyle(color: Colors.white70, fontSize: 20),
          ),
        ]);
  }
}
