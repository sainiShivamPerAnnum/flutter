import 'package:felloapp/util/size_config.dart';
import 'package:flutter/material.dart';

class SuccessDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
      height: SizeConfig.screenWidth * 0.75,
      width: SizeConfig.screenWidth * 0.75,
      child: Column(
        children: [
          Icon(Icons.subdirectory_arrow_left),
          Text("Hurray, Success")
        ],
      ),
    );
  }
}
