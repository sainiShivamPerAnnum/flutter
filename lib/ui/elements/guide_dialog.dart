import 'package:felloapp/core/model/DailyPick.dart';
import 'package:felloapp/util/logger.dart';
import 'package:flutter/material.dart';

class GuideDialog extends StatelessWidget {
  final Log log = new Log('GuideDialog');

  GuideDialog();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      elevation: 0.0,
      backgroundColor: Colors.white70,
      child: dialogContent(context),
    );
  }

  dialogContent(BuildContext context) {
    DateTime today = DateTime.now();
    List<Widget> colElems = [];
    int colCount = today.weekday;

    return Padding(
      padding: EdgeInsets.only(top: 30, bottom: 30),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: colElems,
      )
    );
  }
}
