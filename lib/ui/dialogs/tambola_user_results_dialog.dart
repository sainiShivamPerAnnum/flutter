import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/base_remote_config.dart';
import 'package:felloapp/core/ops/db_ops.dart';
import 'package:felloapp/util/constants.dart';
import 'package:felloapp/util/logger.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TambolaResultsDialog extends StatefulWidget {
  final Map<String, int> winningsMap;
  final bool isEligible;

  TambolaResultsDialog({this.winningsMap, this.isEligible});

  @override
  State<StatefulWidget> createState() => TambolaResultsDialogState();
}

class TambolaResultsDialogState extends State<TambolaResultsDialog> {
  final Log log = new Log('TambolaResultsDialog');
  BaseUtil baseProvider;
  DBModel dbProvider;
  static final int NO_TICKET_MATCHES = 0;
  static final int MATCHED_BUT_INELIGIBLE = 1;
  static final int MATCHED_AND_WON = 2;
  int _status = NO_TICKET_MATCHES;

  TambolaResultsDialogState();

  @override
  void initState() {
    super.initState();
    bool _a = (widget.winningsMap != null && widget.winningsMap.length > 0);
    bool _b = widget.isEligible;
    if (_a && _b)
      _status = MATCHED_AND_WON;
    else if (_a && !_b)
      _status = MATCHED_BUT_INELIGIBLE;
    else
      _status = NO_TICKET_MATCHES;
  }

  @override
  Widget build(BuildContext context) {
    baseProvider = Provider.of<BaseUtil>(context, listen: false);
    dbProvider = Provider.of<DBModel>(context, listen: false);
    return Dialog(
      insetPadding: EdgeInsets.only(left: 20, top: 50, bottom: 80, right: 20),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      elevation: 0.0,
      backgroundColor: Colors.white,
      child: Padding(
        padding: EdgeInsets.all(20),
        child: dialogContent(context),
      ),
    );
  }

  dialogContent(BuildContext context) {
    return Stack(
        overflow: Overflow.visible,
        alignment: Alignment.topCenter,
        children: <Widget>[
          Container(
            width: double.infinity,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                  child: Text(
                    'This week\'s results',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: UiConstants.primaryColor,
                        fontSize: SizeConfig.largeTextSize),
                  ),
                ),
                (_status == MATCHED_AND_WON)
                    ? Container(
                        height: 150,
                        child: ListView.builder(
                            physics: BouncingScrollPhysics(),
                            padding: EdgeInsets.all(20),
                            itemCount: widget.winningsMap.length,
                            itemBuilder: (context, i) {
                              return _buildWinnerDetailsRow(
                                  widget.winningsMap.keys.toList()[i],
                                  widget.winningsMap.values.toList()[i]);
                            }),
                      )
                    : Container(),
                (_status == MATCHED_AND_WON)
                    ? Text(
                        'Your tickets have been submitted for processing your prizes!🎉',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontWeight: FontWeight.w400,
                            color: UiConstants.accentColor),
                      )
                    : Container(),
                (_status == MATCHED_BUT_INELIGIBLE)
                    ? Container(
                        height: 150,
                        child: ListView.builder(
                            physics: BouncingScrollPhysics(),
                            padding: EdgeInsets.all(20),
                            itemCount: widget.winningsMap.length,
                            itemBuilder: (context, i) {
                              return _buildWinnerDetailsRow(
                                  widget.winningsMap.keys.toList()[i],
                                  widget.winningsMap.values.toList()[i]);
                            }),
                      )
                    : Container(),
                (_status == MATCHED_BUT_INELIGIBLE)
                    ? Text(
                        'You need to save a minimum of र${BaseRemoteConfig.UNLOCK_REFERRAL_AMT} to qualify for the weekly prizes. Please join again next week!',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontWeight: FontWeight.w400,
                            color: UiConstants.accentColor),
                      )
                    : Container(),
                (_status == NO_TICKET_MATCHES)
                    ? Center(
                        child: Padding(
                          padding: EdgeInsets.all(20),
                          child: Text(
                            'None of your tickets matched this week.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              color: UiConstants.accentColor,
                              fontSize: SizeConfig.mediumTextSize,
                            ),
                          ),
                        ),
                      )
                    : Container()
              ],
            ),
          ),
        ]);
  }

  Widget _buildWinnerDetailsRow(String ticketId, int type) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Expanded(
          child: Text('Ticket #' + ticketId,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 20, height: 1.6, color: UiConstants.accentColor)),
        ),
        Expanded(
          child: Text(_typeToPrize(type),
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 20,
                  height: 1.6,
                  fontWeight: FontWeight.w300,
                  color: UiConstants.primaryColor)),
        ),
      ],
    );
  }

  String _typeToPrize(int type) {
    switch (type) {
      case Constants.CORNERS_COMPLETED:
        return 'Corners matched!';
      case Constants.ROW_ONE_COMPLETED:
        return 'First row matched!';
      case Constants.ROW_TWO_COMPLETED:
        return 'Second row matched!';
      case Constants.ROW_THREE_COMPLETED:
        return 'Third row matched!';
      case Constants.FULL_HOUSE_COMPLETED:
        return 'Full House!';
      default:
        return 'NA';
    }
  }
}
