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
            padding: EdgeInsets.symmetric(
                horizontal: SizeConfig.pageHorizontalMargins, vertical: 0),
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
                stops: [0.1, 0.455],
              ),
            ),
            child: child,
          ),
          Positioned(
            top: SizeConfig.padding54,
            right: SizeConfig.padding80 + SizeConfig.padding64,
            child: Container(
              width: SizeConfig.padding6,
              height: SizeConfig.padding6,
              decoration: const BoxDecoration(
                  shape: BoxShape.circle, color: Color(0xff61CFC6)),
            ),
          ),
          Positioned(
            top: SizeConfig.padding70,
            right: SizeConfig.padding80 + SizeConfig.padding40,
            child: Container(
              width: SizeConfig.padding3,
              height: SizeConfig.padding3,
              decoration: const BoxDecoration(
                  shape: BoxShape.circle, color: Color(0xff61CFC6)),
            ),
          ),
          Positioned(
            top: SizeConfig.padding90 + SizeConfig.padding40,
            right: SizeConfig.padding20,
            child: Container(
              width: SizeConfig.padding6,
              height: SizeConfig.padding6,
              decoration: const BoxDecoration(
                  shape: BoxShape.circle, color: Color(0xff61CFC6)),
            ),
          ),
          Positioned(
            top: SizeConfig.padding90 + SizeConfig.padding20,
            left: SizeConfig.padding40,
            child: Container(
              width: SizeConfig.padding4,
              height: SizeConfig.padding4,
              decoration: const BoxDecoration(
                  shape: BoxShape.circle, color: Color(0xff61CFC6)),
            ),
          ),
          Positioned(
            top: SizeConfig.padding64,
            left: SizeConfig.padding54,
            child: Container(
              width: SizeConfig.padding6,
              height: SizeConfig.padding6,
              decoration: const BoxDecoration(
                  shape: BoxShape.circle, color: Color(0xff61CFC6)),
            ),
          ),
        ],
      ),
    );
  }
}
