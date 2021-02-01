import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/ops/icici_ops.dart';
import 'package:felloapp/util/constants.dart';
import 'package:felloapp/util/ui_constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

class DepositVerification extends StatefulWidget{
  DepositVerification({this.tranId, this.panNumber, this.userTxnId});
  final String tranId;
  final String panNumber;
  final String userTxnId;

  @override
  State createState() => _DepositVerificationState();
}

class _DepositVerificationState extends State<DepositVerification> {
  BaseUtil baseProvider;
  ICICIModel iProvider;
  bool _isPaymentMade = false;
  double _width;
  double _height;

  @override
  Widget build(BuildContext context) {
    baseProvider = Provider.of<BaseUtil>(context);
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
                    child:Text('Facing an issue?',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 22,
                        color: Colors.blueGrey,
                      ),
                    ),
                  ),
                  onTap: () {
                    //TODO add a help dialog to log failures
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
                    width: _width*0.8,
                    decoration:new BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(UiConstants.padding),
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
                        child: (!_isPaymentMade)?_paymentNotMadeLayout()
                            :_paymentMadeLayout()
                    ),
                  ),
                )
              ],
            ),
          )
      ),
    );
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
        Text('Please use your UPI app to confirm the payment request from ICICI Prudential',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 18
          ),
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
              child: Text('I have made the payment',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold
                ),
              ),
            )
          ),
          onTap: () {
            //TODO add an are you sure dialog here
            baseProvider.runPaymentVerification().then((value) {
              _isPaymentMade = true;
              setState(() {});
            });
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
        Text('Please wait while we contact ICICI and confirm your deposit. This usually takes less than 2 minutes',
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 18
          ),
        ),
        SizedBox(
          height: 10,
        ),
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
      child: new AlertDialog(
        title: new Text('Are you sure you want to go back?'),
        actions: <Widget>[
          new FlatButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: new Text('No'),
          ),
          new FlatButton(
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
}

