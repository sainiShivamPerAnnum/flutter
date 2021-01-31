import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/ops/icici_ops.dart';
import 'package:felloapp/util/ui_constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class DepositVerification extends StatefulWidget{

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
        appBar: BaseUtil.getAppBar(),
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

}

