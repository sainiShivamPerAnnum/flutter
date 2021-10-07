import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/service/payment_service.dart';
import 'package:felloapp/ui/dialogs/transaction_help_dialog.dart';
import 'package:felloapp/util/constants.dart';
import 'package:felloapp/util/haptic.dart';
import 'package:felloapp/util/size_config.dart';
import 'package:felloapp/util/ui_constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

class DepositVerification extends StatefulWidget {
  DepositVerification();

  @override
  State createState() => _DepositVerificationState();
}

class _DepositVerificationState extends State<DepositVerification> {
  BaseUtil baseProvider;
  PaymentService payService;
  bool _isPaymentMade = false;
  bool _isPaymentConfirmed = false;
  bool _isPaymentRejected = false;
  bool _isPaymentTimeout = false;
  double _width;
  double _height;

  @override
  Widget build(BuildContext context) {
    baseProvider = Provider.of<BaseUtil>(context, listen: false);
    payService = Provider.of<PaymentService>(context, listen: false);
    _width = MediaQuery.of(context).size.width;
    _height = MediaQuery.of(context).size.height;
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
          appBar: _getLocalAppBar(),
          backgroundColor: Colors.grey[300],
          bottomSheet: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: InkWell(
                  child: Padding(
                    padding: EdgeInsets.all(15),
                    child: Text(
                      'Facing an issue?',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 22,
                        color: Colors.blueGrey,
                      ),
                    ),
                  ),
                  onTap: () {
                    Haptic.vibrate();
                    showDialog(
                        context: context,
                        builder: (BuildContext context) =>
                            TransactionHelpDialog());
                  },
                ),
              )
            ],
          ),
          body: SafeArea(
            child: Stack(
              children: [
                Center(
                  child: Container(
                    width: _width * 0.8,
                    decoration: new BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.rectangle,
                      borderRadius:
                          BorderRadius.circular(SizeConfig.cardBorderRadius),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 10.0,
                          offset: const Offset(0.0, 10.0),
                        ),
                      ],
                    ),
                    child: Padding(
                        padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                        child: _getActiveLayout()),
                  ),
                )
              ],
            ),
          )),
    );
  }

  Widget _getActiveLayout() {
    if (!_isPaymentMade) return _paymentNotMadeLayout();
    Widget wx;
    if (_isPaymentMade) wx = _paymentMadeLayout();

    if (_isPaymentConfirmed)
      wx = _paymentConfirmed();
    else if (_isPaymentRejected)
      wx = _paymentRejected();
    else if (_isPaymentTimeout) wx = _paymentTimeout();

    return wx;
  }

  Widget _paymentNotMadeLayout() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: EdgeInsets.all(5),
          child: SpinKitFadingCircle(
            size: 50,
            color: UiConstants.primaryColor,
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Text(
          'Please use your UPI app to confirm the payment request from ICICI Prudential',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 18),
        ),
        SizedBox(
          height: 10,
        ),
        Divider(
          thickness: 1.5,
        ),
        InkWell(
          child: Container(
              height: 30,
              child: Center(
                child: Text(
                  'I have made the payment',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              )),
          onTap: () {
            //TODO add an are you sure dialog here
            _isPaymentMade = true;
            setState(() {});
            payService.addPaymentStatusListener(_onPaymentStatusReceived);
            payService.verifyPayment();
          },
        )
      ],
    );
  }

  Widget _paymentMadeLayout() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: EdgeInsets.all(5),
          child: SpinKitFadingCircle(
            size: 50,
            color: UiConstants.primaryColor,
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Text(
          'Please wait while we contact ICICI and confirm your deposit. This usually takes less than 2 minutes',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 18),
        ),
        SizedBox(
          height: 10,
        ),
      ],
    );
  }

  Widget _paymentConfirmed() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: EdgeInsets.all(5),
          child: Icon(
            Icons.check_circle_outline,
            color: UiConstants.primaryColor,
            size: 20,
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Text(
          'Payment completed successfully! 🎉',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 18),
        ),
        SizedBox(
          height: 10,
        ),
        Divider(
          thickness: 1.5,
        ),
        InkWell(
          child: Container(
              height: 30,
              child: Center(
                child: Text(
                  'Okay',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              )),
          onTap: () {
            Navigator.pop(context); //back to mf details
            // Navigator.pop(context); //back to save tab
          },
        )
      ],
    );
  }

  Widget _paymentRejected() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: EdgeInsets.all(5),
          child: Icon(
            Icons.new_releases,
            color: Colors.yellow[400],
            size: 20,
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Text(
          'We have verified that the payment was not completed.',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 18),
        ),
        SizedBox(
          height: 10,
        ),
        Divider(
          thickness: 1.5,
        ),
        InkWell(
          child: Container(
              height: 30,
              child: Center(
                child: Text(
                  'Okay',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              )),
          onTap: () {
            Navigator.pop(context); //back to mf details
            // Navigator.pop(context); //back to save tab
          },
        )
      ],
    );
  }

  Widget _paymentTimeout() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: EdgeInsets.all(5),
          child: Icon(
            Icons.access_time,
            color: Colors.yellow[200],
            size: 60,
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Text(
          'We could not verify the status of your payment in time.\n\n' +
              ' We will continue to check the status in the background and keep you informed.',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 18),
        ),
        SizedBox(
          height: 10,
        ),
        Divider(
          thickness: 1.5,
        ),
        InkWell(
          child: Container(
              height: 30,
              child: Center(
                child: Text(
                  'Okay',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              )),
          onTap: () {
            Navigator.pop(context); //back to mf details

            // Navigator.pop(context); //back to save tab
          },
        )
      ],
    );
  }

  Widget _getLocalAppBar() {
    return AppBar(
      automaticallyImplyLeading: false,
      elevation: 2.0,
      backgroundColor: UiConstants.primaryColor,
      iconTheme: IconThemeData(
        color: UiConstants.accentColor, //change your color here
      ),
      title: Text('${Constants.APP_NAME}',
          style: TextStyle(
              color: UiConstants.accentColor,
              fontWeight: FontWeight.w700,
              fontSize: 30.0)),
    );
  }

  Future<bool> _onWillPop() {
    return showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: new Text('Are you sure you want to go back?'),
            actions: <Widget>[
              new TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: new Text('No'),
              ),
              new TextButton(
                onPressed: () {
                  //pop twice to get back to mf details
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                },
                child: new Text('Yes'),
              ),
            ],
          ),
        ) ??
        false;
  }

  _onPaymentStatusReceived(int status) {
    switch (status) {
      case PaymentService.TRANSACTION_COMPLETE:
        {
          _isPaymentConfirmed = true;
          break;
        }
      case PaymentService.TRANSACTION_REJECTED:
        {
          _isPaymentRejected = true;
          break;
        }
      case PaymentService.TRANSACTION_CHECK_TIMEOUT:
      case PaymentService.TRANSACTION_PENDING:
        {
          _isPaymentTimeout = true;
          break;
        }
    }
    setState(() {});
  }
}

// class TransactionHelpDialog extends StatefulWidget{
//
// }
