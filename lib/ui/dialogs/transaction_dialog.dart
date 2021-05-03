import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/constants.dart';
import 'package:felloapp/util/logger.dart';
import 'package:felloapp/util/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:url_launcher/url_launcher.dart';

class TransactionDialog extends StatefulWidget {
  TransactionDialog();

  @override
  State createState() => _TransactionState();
}

class _TransactionState extends State<TransactionDialog> {
  Log log = new Log('TransactionDialog');
  final _formKey = GlobalKey<FormState>();
  final fdbkController = TextEditingController();
  static bool _isCallbackInitiated = false;

  @override
  void dispose() {
    _isCallbackInitiated = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(UiConstants.padding),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: dialogContent(context),
    );
  }

  dialogContent(BuildContext context) {
    return Stack(
      children: <Widget>[
        //...bottom card part,
        Container(
          padding: EdgeInsets.only(
            top: UiConstants.padding + 20,
            bottom: UiConstants.padding + 30,
            left: UiConstants.padding,
            right: UiConstants.padding,
          ),
          //margin: EdgeInsets.only(top: UiConstants.avatarRadius),
          decoration: new BoxDecoration(
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
          child: Column(
            mainAxisSize: MainAxisSize.min, // To make the card compact
            children: <Widget>[
              Text('How are the transactions processed?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 20,
                      color: UiConstants.primaryColor,
                      fontWeight: FontWeight.bold
                  )
              ),

              SizedBox(
                height: 10,
              ),
              Text(Assets.transactionProcess,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 20,
                      height: 1.2,
                      color: UiConstants.accentColor,
                      fontWeight: FontWeight.w300
                  )
              ),
            ],
          ),
        ),
        //...top circlular image part,
//        Positioned(
//          left: UiConstants.padding,
//          right: UiConstants.padding,
//          child: CircleAvatar(
//            backgroundColor: Colors.blueAccent,
//            radius: UiConstants.avatarRadius,
//          ),
//        ),
      ],
    );
  }
}
