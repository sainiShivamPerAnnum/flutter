import 'package:felloapp/util/styles/size_config.dart';
import 'package:flutter/material.dart';

class LastWeekBg extends StatelessWidget {
  const LastWeekBg({Key? key, required this.child}) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: SizeConfig.screenHeight,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xff266F64),
                  // Color(0xff293566).withOpacity(1),
                  Color(0xff151D22),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                // stops: [  0.1, 0.455],
              ),
            ),
            child: child,
          ),
          Positioned(
            bottom: SizeConfig.padding20,
            right: SizeConfig.padding20,
            child: Container(
              height: SizeConfig.padding54,
              decoration: const BoxDecoration(
                  shape: BoxShape.circle, color: Colors.red),
            ),
          ),
          // Align(
          //   alignment: Alignment.topRight,
          //   child: Container(
          //     child: ,
          //   ),
          // ),
        ],
      ),
    );
  }
}
