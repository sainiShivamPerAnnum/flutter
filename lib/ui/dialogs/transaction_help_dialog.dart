import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/ops/db_ops.dart';
import 'package:felloapp/core/service/user_service.dart';
import 'package:felloapp/util/constants.dart';
import 'package:felloapp/util/haptic.dart';
import 'package:felloapp/util/help_types.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/logger.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TransactionHelpDialog extends StatelessWidget {
  final Log log = new Log('TransactionHelpDialog');
  final _userService = locator<UserService>();
  BaseUtil baseProvider;
  DBModel dbProvider;
  double _width, _height;

  static final List<HelpDetail> _helpOptions = [
    new HelpDetail(HelpType.TxnTimeTooLongHelp,
        'The transaction is taking too long to be verified'),
    new HelpDetail(HelpType.TxnCompletedButNotAcceptedHelp,
        'I completed the transaction but it was not processed by ${Constants.APP_NAME}'),
    new HelpDetail(HelpType.TxnRequestNotReceivedHelp,
        'I did not receive any notification or request on my UPI App'),
    new HelpDetail(HelpType.TxnFailedOnUpiAppHelp,
        'The transaction is failing on my UPI App'),
    new HelpDetail(HelpType.TxnHowToHelp,
        'I am still not sure about how to complete my transaction'),
    new HelpDetail(
        HelpType.TxnOtherQueryHelp, 'Other query about my transaction'),
  ];

  @override
  Widget build(BuildContext context) {
    baseProvider = Provider.of<BaseUtil>(context, listen: false);
    dbProvider = Provider.of<DBModel>(context, listen: false);
    _width = MediaQuery.of(context).size.width;
    _height = MediaQuery.of(context).size.height;
    return Dialog(
      insetPadding: EdgeInsets.only(left: 20, top: 50, bottom: 80, right: 20),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      elevation: 0.0,
      backgroundColor: Colors.white,
      child: Padding(
        padding: EdgeInsets.all(30),
        child: dialogContent(context),
      ),
    );
  }

  dialogContent(BuildContext context) {
    return Column(
        //overflow: Overflow.visible,
        //alignment: Alignment.topCenter,
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'Please select the issue you are facing',
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.black54,
                fontSize: 20,
                fontWeight: FontWeight.bold),
          ),
          Text(
            'We will look into your query and help you easily resolve it',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.black54, fontSize: 16),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            width: _width * 0.8,
            height: _height * 0.5,
            child: ListView.builder(
              padding: const EdgeInsets.all(6.0),
              itemBuilder: /*1*/ (context, i) {
                if (i.isOdd) return Divider();
                /*2*/
                final index = i ~/ 2; /*3*/
                return _buildRow(context, _helpOptions[index]);
              },
              itemCount: _helpOptions.length * 2,
            ),
          )
        ]);
  }

  Widget _buildRow(BuildContext _context, HelpDetail option) {
    return ListTile(
        title: Text(option.value,
            style: TextStyle(fontSize: 18.0, color: Colors.black)),
        onTap: () {
          Haptic.vibrate();
          dbProvider
              .addHelpRequest(_userService.baseUser.uid, _userService.baseUser.name,
                  _userService.baseUser.mobile, option.key)
              .then((flag) {
            if (flag) {
              Navigator.of(_context).pop();
              BaseUtil.showPositiveAlert(
                'Request noted!',
                'We\'ll look into your issue and reach out to you soon',
              );
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
