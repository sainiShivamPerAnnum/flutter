import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/ops/icici_ops.dart';
import 'package:felloapp/util/constants.dart';
import 'package:felloapp/util/ui_constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: _getLocalAppBar(),
        backgroundColor: Colors.grey[300],
        bottomSheet: Align(
          alignment: Alignment.bottomCenter,
          child: InkWell(
            child: Text('Facing an issue?',
              style: TextStyle(
                fontSize: 22,
                color: Colors.blueGrey,
              ),
            ),
            onTap: () {
              //TODO add a help dialog to log failures
            },
          ),
        ),
        body: Stack(
          children: [
            Center(
              child: Container(
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
        )
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
            size: 22,
            color: UiConstants.primaryColor,
          ),
        ),
        Text('Please use your UPI app to confirm the payment request from ICICI Prudential',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 18
          ),
        ),
        SizedBox(
          height: 5,
        ),
        Divider(),
        InkWell(
          child: Container(
            height: 20,
            child: Text('I have made the payment',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold
              ),
            ),
          ),
          onTap: () {
            //TODO add an are you sure dialog here
            _isPaymentMade = true;
            setState(() {});
          },
        )
      ],
    );
  }

  Widget _paymentMadeLayout() {

  }

  Widget _getLocalAppBar() {
    return AppBar(
      automaticallyImplyLeading: false,
      elevation: 1.0,
      backgroundColor: UiConstants.primaryColor,
      iconTheme: IconThemeData(
        color: UiConstants.accentColor, //change your color here
      ),
      title: Text('${Constants.APP_NAME}',
          style: TextStyle(
              color: UiConstants.accentColor,
              fontWeight: FontWeight.w700,
              fontSize: 30.0)),
      bottom: PreferredSize(
          child: Container(
              color: Colors.blueGrey[100],
              height: 25.0,
              child: Padding(
                  padding: EdgeInsets.only(left: 10, right: 10, top: 3, bottom: 3),
                  child:Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('We are currently in Beta',
                        style: TextStyle(color: Colors.black54),
                      ),
                      Icon(Icons.info_outline, size: 20,color: Colors.black54,)
                    ],
                  )
              )
          ),
          preferredSize: Size.fromHeight(25.0)),
    );
  }
}

