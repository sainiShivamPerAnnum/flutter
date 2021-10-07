import 'package:felloapp/util/styles/size_config.dart';
import 'package:flutter/material.dart';

class NetworkBar extends StatelessWidget {
  final textColor;
  NetworkBar({this.textColor});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(seconds: 2),
      height: SizeConfig.screenHeight * 0.04,
      color: Colors.transparent,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Offline',
            style: TextStyle(
              color: textColor ?? Colors.white,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
            ),
          ),
          SizedBox(
            width: SizeConfig.screenWidth * 0.01,
          ),
          CircleAvatar(
            backgroundColor: Colors.red,
            radius: SizeConfig.screenWidth * 0.012,
          ),
        ],
      ),
    );
  }
}
