import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/model/UserTicketWallet.dart';
import 'package:felloapp/core/model/UserTransaction.dart';
import 'package:felloapp/core/ops/augmont_ops.dart';
import 'package:felloapp/util/logger.dart';
import 'package:felloapp/util/size_config.dart';
import 'package:felloapp/util/ui_constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:open_file/open_file.dart';
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
    return Dialog(
      insetPadding: EdgeInsets.only(left: 20, top: 50, bottom: 80, right: 20),
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
                    (widget._userTicketWallet.refTck > 0)
                        ? _addListField(
                            'Referral Bonus:',
                            '',
                            widget._userTicketWallet.initTck,
                            'Refreshes every Monday')
                        : Container(),
                    (widget._userTicketWallet.getNRTicketBalance() > 0)
                        ? _addListField(
                            'Referral Bonus:',
                            '',
                            widget._userTicketWallet.initTck,
                            'Expires on ${widget._userTicketWallet.getNRExpiryDate()}')
                        : Container(),
                    (widget._userTicketWallet.getLockedTickets() > 0)
                        ? _addListField(
                            'Locked Bonus:',
                            '',
                            widget._userTicketWallet.getLockedTickets(),
                            'Unlocked once referrals are completed')
                        : Container(),
                    (widget._userTicketWallet.getActiveTickets() > 0)
                        ? _addListField(
                        'In Total:',
                        '',
                        widget._userTicketWallet.getLockedTickets(),
                        '', true)
                        : Container(),
                  ],
                )),
          )
        ]);
  }

  Widget _addListField(
      String title, String subtitle, int count, String trailingText, [isTotal = false]) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(
        horizontal: SizeConfig.blockSizeHorizontal * 8,
        vertical: SizeConfig.blockSizeVertical * 0.4,
      ),
      title: Container(
        width: SizeConfig.screenWidth * 0.2,
        child: Text(
          title,
          style: (!isTotal)?GoogleFonts.montserrat(
            color: UiConstants.accentColor,
            fontSize: SizeConfig.mediumTextSize,
          ):GoogleFonts.montserrat(
            color: UiConstants.accentColor,
            fontSize: SizeConfig.mediumTextSize,
            fontWeight: FontWeight.bold
          ),
        ),
      ),
      trailing: Container(
        width: SizeConfig.screenWidth * 0.3,
        child: Column(
          children: [
            Text(
              '$count tickets',
              overflow: TextOverflow.clip,
              style: (!isTotal)?GoogleFonts.montserrat(
                color: Colors.black54,
                fontSize: SizeConfig.largeTextSize,
                fontWeight: FontWeight.w400,
              ):GoogleFonts.montserrat(
                color: Colors.black54,
                fontSize: SizeConfig.largeTextSize,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              trailingText,
              overflow: TextOverflow.clip,
              style: GoogleFonts.montserrat(
                color: UiConstants.accentColor,
                fontSize: SizeConfig.mediumTextSize,
              ),
            ),
          ],
        )
      ),
    );
  }

  String _getTileTitle(String type) {
    if (type == UserTransaction.TRAN_SUBTYPE_ICICI) {
      return "ICICI Prudential Fund";
    } else if (type == UserTransaction.TRAN_SUBTYPE_AUGMONT_GOLD) {
      return "Augmont Gold";
    } else if (type == UserTransaction.TRAN_SUBTYPE_TAMBOLA_WIN) {
      return "Tambola Win";
    } else if (type == UserTransaction.TRAN_SUBTYPE_REF_BONUS) {
      return "Referral Bonus";
    }
    return 'Fund Name';
  }

  String _getAugmontGoldGrams(double gms) =>
      (gms == null || gms == 0) ? 'N/A' : gms.toStringAsFixed(4);
}
