import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/ops/db_ops.dart';
import 'package:felloapp/util/constants.dart';
import 'package:felloapp/util/help_types.dart';
import 'package:felloapp/util/logger.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class TransactionHelpDialog extends StatelessWidget {
  final Log log = new Log('TransactionHelpDialog');
  BaseUtil baseProvider;
  DBModel dbProvider;
  double _width, _height;

  static final List<HelpDetail> _helpOptions = [
    new HelpDetail(HelpType.TxnTimeTooLongHelp,
        'The transaction is taking too long to be verified'),
    new HelpDetail(HelpType.TxnCompletedButNotAcceptedHelp,
        'I completed the transaction but it was not processed by ${Constants
            .APP_NAME}'),
    new HelpDetail(HelpType.TxnRequestNotReceivedHelp,
        'I did not receive any notification or request on my UPI App'),
    new HelpDetail(HelpType.TxnFailedOnUpiAppHelp,
        'The transaction is failing on my UPI App'),
    new HelpDetail(HelpType.TxnHowToHelp,
        'I am still not about how to complete the transaction'),
    new HelpDetail(HelpType.TxnOtherQueryHelp, 'Other query about transaction'),
  ];

  @override
  Widget build(BuildContext context) {
    baseProvider = Provider.of<BaseUtil>(context);
    dbProvider = Provider.of<DBModel>(context);
    _width = MediaQuery.of(context).size.width;
    _height = MediaQuery.of(context).size.height;
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
    return Container(
      width:_width*0.8,
      height: _height*0.6,
      child: Column(
        //overflow: Overflow.visible,
        //alignment: Alignment.topCenter,
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Please select the issue you are facing and we will personally look into it and help you in resolving it',
              style: TextStyle(color: Colors.white70, fontSize: 20),
            ),
            ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemBuilder: /*1*/ (context, i) {
                if (i.isOdd) return Divider();
                /*2*/
                final index = i ~/ 2; /*3*/
                return _buildRow(context, _helpOptions[index]);
              },
              itemCount: _helpOptions.length * 2,
            )
          ]),
    );
  }

  Widget _buildRow(BuildContext _context, HelpDetail option) {
    return ListTile(
        title: Text(option.value,
            style: TextStyle(fontSize: 18.0, color: Colors.black)),
        onTap: () {
          HapticFeedback.vibrate();
          dbProvider
              .addHelpRequest(baseProvider.myUser.uid, baseProvider.myUser.name,
              baseProvider.myUser.mobile, option.key)
              .then((flag) {
            if (flag) {
              Navigator.of(_context).pop();
              baseProvider.showPositiveAlert(
                  'Request noted!',
                  'We\'ll look into your issue and reach out to you soon',
                  _context);
            }
          });
        });
  }
}

class HelpDetail {
  final HelpType key;
  final String value;

  HelpDetail(this.key, this.value);
}
