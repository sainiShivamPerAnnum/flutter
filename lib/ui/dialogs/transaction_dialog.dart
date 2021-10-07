import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/logger.dart';
import 'package:felloapp/util/size_config.dart';
import 'package:felloapp/util/ui_constants.dart';
import 'package:flutter/material.dart';

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
        borderRadius: BorderRadius.circular(SizeConfig.cardBorderRadius),
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
            top: SizeConfig.cardBorderRadius + 20,
            bottom: SizeConfig.cardBorderRadius + 30,
            left: SizeConfig.cardBorderRadius,
            right: SizeConfig.cardBorderRadius,
          ),
          //margin: EdgeInsets.only(top: UiConstants.avatarRadius),
          decoration: new BoxDecoration(
            color: Colors.white,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(SizeConfig.cardBorderRadius),
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
                      fontWeight: FontWeight.bold)),
              SizedBox(
                height: 10,
              ),
              Text(Assets.transactionProcess,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 20,
                      height: 1.2,
                      color: UiConstants.accentColor,
                      fontWeight: FontWeight.w300)),
            ],
          ),
        ),
        //...top circlular image part,
//        Positioned(
//          left: SizeConfig.cardBorderRadius,
//          right: SizeConfig.cardBorderRadius,
//          child: CircleAvatar(
//            backgroundColor: Colors.blueAccent,
//            radius: UiConstants.avatarRadius,
//          ),
//        ),
      ],
    );
  }
}
