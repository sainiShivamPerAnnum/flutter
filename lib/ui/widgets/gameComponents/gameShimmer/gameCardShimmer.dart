import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class GameCardShimmer extends StatelessWidget {
  const GameCardShimmer({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(SizeConfig.padding16),
      height: SizeConfig.screenWidth * 0.688,
      width: SizeConfig.screenWidth,
      decoration: BoxDecoration(
        color: Color(0xff39393C),
        borderRadius: BorderRadius.circular(SizeConfig.roundness8),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(SizeConfig.roundness5),
        child: Shimmer.fromColors(
          baseColor: UiConstants.kUserRankBackgroundColor,
          highlightColor: UiConstants.kBackgroundColor,
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.all(SizeConfig.padding16),
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(SizeConfig.roundness5),
                ),
                height: SizeConfig.screenWidth * 0.400,
                width: SizeConfig.screenWidth,
              ),
              //
              Container(
                margin: EdgeInsets.all(SizeConfig.padding16),
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(SizeConfig.roundness5),
                ),
                height: SizeConfig.screenWidth * 0.120,
                width: SizeConfig.screenWidth,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
