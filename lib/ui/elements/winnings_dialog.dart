import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/ops/db_ops.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/constants.dart';
import 'package:felloapp/util/logger.dart';
import 'package:felloapp/util/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

class WinningsDialog extends StatefulWidget{
  Map<String, int> winningsMap;

  WinningsDialog({this.winningsMap});

  @override
  State<StatefulWidget> createState() => WinningsDialogState();
}

class WinningsDialogState extends State<WinningsDialog> {
  final Log log = new Log('PrizeDialog');
  BaseUtil baseProvider;
  DBModel dbProvider;

  WinningsDialogState();

  @override
  Widget build(BuildContext context) {
    baseProvider = Provider.of<BaseUtil>(context);
    dbProvider = Provider.of<DBModel>(context);
    return Dialog(
      insetPadding: EdgeInsets.only(left:20, top:50, bottom: 80, right:20),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      elevation: 0.0,
      backgroundColor: Colors.white,
      child: dialogContent(context),
    );
  }

  dialogContent(BuildContext context) {
    return Stack(
        overflow: Overflow.visible,
        alignment: Alignment.topCenter,
        children: <Widget>[
          Container(
            width: double.infinity,
            height: 600,
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(10),
                  child: Text('This week\' results',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: UiConstants.primaryColor,
                        fontSize: 20
                    ),
                  ),                  
                ),
                (widget.winningsMap != null && widget.winningsMap.length > 0)?
                ListView.builder(
                    physics: BouncingScrollPhysics(),
                    padding: EdgeInsets.all(20),
                    itemCount: widget.winningsMap.length,
                    itemBuilder: (context, i) {
                      return _buildWinnerDetailsRow(widget.winningsMap.keys.toList()[i],
                          widget.winningsMap.values.toList()[i]);
                    } 
                ):Center(
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Text('None of the tickets matched this week.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          color: UiConstants.accentColor
                        ),
                    ),
                  ),
                ),
                (widget.winningsMap != null && widget.winningsMap.length > 0)?
                Text('Your winnings shall be credited to your account shortly!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontWeight: FontWeight.w400,
                      color: UiConstants.accentColor
                  ),
                )
                :Container()
              ],
            ),
          ),
        ]
    );
  }

  Widget _buildWinnerDetailsRow(String ticketId, int type) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(
          child: Text('#' + ticketId,
              textAlign: TextAlign.left,
              style: TextStyle(
                  fontSize: 26,
                  height: 1.6,
                  color: UiConstants.accentColor)
          ),
        ),
        Expanded(
          child: Text(_typeToPrize(type),
              textAlign: TextAlign.end,
              style: TextStyle(
                  fontSize: 26,
                  height: 1.6,
                  fontWeight: FontWeight.bold,
                  color: UiConstants.primaryColor)
          ),
        ),
      ],
    );
  }

  String _typeToPrize(int type) {
    switch(type) {
      case Constants.CORNERS_COMPLETED: return 'Corners';
      case Constants.ROW_ONE_COMPLETED: return 'First Row';
      case Constants.ROW_TWO_COMPLETED: return 'Second Row';
      case Constants.ROW_THREE_COMPLETED: return 'Third Row';
      case Constants.FULL_HOUSE_COMPLETED: return 'Full House!';
      default: return 'NA';
    }
  }

}
