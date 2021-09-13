import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/model/UserTicketWallet.dart';
import 'package:felloapp/main.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/util/logger.dart';
import 'package:felloapp/util/size_config.dart';
import 'package:felloapp/util/ui_constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TicketDetailsDialog extends StatefulWidget {
  final UserTicketWallet _userTicketWallet;

  TicketDetailsDialog(this._userTicketWallet);

  @override
  State createState() => TicketDetailsDialogState();
}

class TicketDetailsDialogState extends State<TicketDetailsDialog> {
  final Log log = new Log('TicketDetailsDialog');
  double _width;
  BaseUtil baseProvider;

  @override
  Widget build(BuildContext context) {
    baseProvider = Provider.of<BaseUtil>(context, listen: false);
    _width = MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: () async {
        AppState.backButtonDispatcher.didPopRoute();
        return true;
      },
      child: Dialog(
        insetPadding: EdgeInsets.only(left: 20, top: 50, bottom: 80, right: 20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        elevation: 0.0,
        backgroundColor: Colors.white,
        child: dialogContent(context),
      ),
    );
  }

  dialogContent(BuildContext context) {
    return Stack(
        overflow: Overflow.visible,
        alignment: Alignment.topCenter,
        children: <Widget>[
          SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Padding(
                padding:
                    EdgeInsets.only(top: 30, bottom: 40, left: 35, right: 35),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Your Tickets Breakdown',
                      style: TextStyle(
                          fontSize: SizeConfig.largeTextSize,
                          color: UiConstants.accentColor),
                    ),
                    Divider(),
                    (widget._userTicketWallet.initTck > 0)
                        ? _addListField(
                            'Initial:',
                            '',
                            widget._userTicketWallet.initTck,
                            'Refreshes every Monday')
                        : Container(),
                    (widget._userTicketWallet.augGold99Tck > 0)
                        ? _addListField(
                            'For Gold Investment:',
                            '',
                            widget._userTicketWallet.augGold99Tck,
                            'Refreshes every Monday')
                        : Container(),
                    (widget._userTicketWallet.icici1565Tck > 0)
                        ? _addListField(
                            'For Mutual Fund Investment:',
                            '',
                            widget._userTicketWallet.icici1565Tck,
                            'Refreshes every Monday')
                        : Container(),
                    (widget._userTicketWallet.prizeTck > 0)
                        ? _addListField(
                            'Prize awarded:',
                            '',
                            widget._userTicketWallet.prizeTck,
                            'Refreshes every Monday')
                        : Container(),
                    (widget._userTicketWallet.goldenRewTck > 0)
                        ? _addListField(
                            'Earned from Golden Ticket:',
                            '',
                            widget._userTicketWallet.goldenRewTck,
                            'Refreshes every Monday')
                        : Container(),
                    (widget._userTicketWallet.refTck > 0)
                        ? _addListField(
                            'Referral Bonus:',
                            '',
                            widget._userTicketWallet.refTck,
                            'Refreshes every Monday')
                        : Container(),
                    (widget._userTicketWallet.getNRTicketBalance() > 0)
                        ? _addListField(
                            'Referral Bonus:',
                            '',
                            widget._userTicketWallet.getNRTicketBalance(),
                            'Expires on ${widget._userTicketWallet.getNRExpiryDate()}')
                        : Container(),
                    (widget._userTicketWallet.getLockedTickets() > 0)
                        ? _addListField(
                            'Locked Bonus:',
                            '',
                            widget._userTicketWallet.getLockedTickets(),
                            'Unlocked once referral criteria is met')
                        : Container(),
                    (widget._userTicketWallet.getActiveTickets() > 0)
                        ? _addListField(
                            'Total Active:',
                            '',
                            widget._userTicketWallet.getActiveTickets(),
                            'This week',
                            true)
                        : Container(),
                    SizedBox(
                      height: SizeConfig.blockSizeVertical,
                    ),
                    Text(
                      'You receive 1 ticket for every ₹ 100 you save ✌',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: SizeConfig.mediumTextSize,
                          color: Colors.blueGrey),
                    ),
                  ],
                )),
          )
        ]);
  }

  Widget _addListField(
      String title, String subtitle, int count, String trailingText,
      [isTotal = false]) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(
        horizontal: SizeConfig.blockSizeHorizontal * 8,
        vertical: SizeConfig.blockSizeVertical * 0.4,
      ),
      title: Container(
        width: SizeConfig.screenWidth * 0.2,
        child: Text(
          title,
          style: (!isTotal)
              ? TextStyle(
                  color: UiConstants.accentColor,
                  fontSize: SizeConfig.mediumTextSize,
                )
              : TextStyle(
                  color: Colors.black54,
                  fontSize: SizeConfig.mediumTextSize,
                  fontWeight: FontWeight.bold),
        ),
      ),
      trailing: Container(
          width: SizeConfig.screenWidth * 0.3,
          child: Column(
            children: [
              Text(
                (count == 1) ? '$count ticket' : '$count tickets',
                overflow: TextOverflow.clip,
                style: (!isTotal)
                    ? TextStyle(
                        color: Colors.black54,
                        fontSize: SizeConfig.largeTextSize,
                        fontWeight: FontWeight.w400,
                      )
                    : TextStyle(
                        color: Colors.black54,
                        fontSize: SizeConfig.largeTextSize,
                        fontWeight: FontWeight.bold,
                      ),
              ),
              Text(
                trailingText,
                textAlign: TextAlign.center,
                overflow: TextOverflow.clip,
                style: TextStyle(
                  color: UiConstants.accentColor,
                  fontSize: SizeConfig.smallTextSize,
                ),
              ),
            ],
          )),
    );
  }
}
