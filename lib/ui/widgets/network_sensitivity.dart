import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/enums/connectivity_status.dart';
import 'package:felloapp/util/size_config.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NetworkSensitivity extends StatelessWidget {
  final Widget child;

  NetworkSensitivity({this.child});

  @override
  Widget build(BuildContext context) {
    ConnectivityStatus connectivityStatus =
        Provider.of<ConnectivityStatus>(context);
    BaseUtil baseProvider = Provider.of<BaseUtil>(context);

    if (connectivityStatus == ConnectivityStatus.Offline) {
      print("Inside, profile page.");
      return GestureDetector(
          onTap: () {
            baseProvider.showNegativeAlert(
                'Offline', 'Please connect to internet', context,
                seconds: 3);
          },
          child: child);
    } else {
      print("Inside, else");
      return child;
    }
  }
}

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
