import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';

class NewSquareBackground extends StatelessWidget {
  const NewSquareBackground({Key? key, this.backgroundColor}) : super(key: key);
  final Color? backgroundColor;
  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroundColor ?? UiConstants.kBackgroundColor,
      width: SizeConfig.screenWidth,
      height: SizeConfig.screenHeight,
      child: Stack(
        children: [
          ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            itemCount:
                SizeConfig.screenHeight! ~/ (SizeConfig.screenWidth! * 0.1667),
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            itemBuilder: (context, index) {
              return Divider(
                thickness: 1,
                height: SizeConfig.screenWidth! * 0.1667,
                color: UiConstants.kGridLineColor,
              );
            },
          ),
          ListView.builder(
            itemCount:
                SizeConfig.screenWidth! ~/ (SizeConfig.screenWidth! * 0.1567),
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              return VerticalDivider(
                thickness: 1,
                width: SizeConfig.screenWidth! * 0.1667,
                color: UiConstants.kGridLineColor,
              );
            },
          ),
        ],
      ),
    );
  }
}
