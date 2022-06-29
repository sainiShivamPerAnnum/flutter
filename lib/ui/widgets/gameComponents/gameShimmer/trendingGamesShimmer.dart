import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';


class TrendingGamesShimmer extends StatelessWidget {
  const TrendingGamesShimmer({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: SizeConfig.padding16),
      height: SizeConfig.screenWidth * 0.688,
      width: SizeConfig.screenWidth * 0.610,
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
                 color: Colors.grey.shade600,
                  borderRadius: BorderRadius.circular(SizeConfig.roundness5),
                ),
                height: SizeConfig.screenWidth * 0.300,
                width: SizeConfig.screenWidth * 0.610,
              ),
              //
              Container(
                margin: EdgeInsets.all(SizeConfig.padding16),
                decoration: BoxDecoration(
                 color: Colors.grey.shade600,
                  borderRadius: BorderRadius.circular(SizeConfig.roundness5),
                ),
                height: SizeConfig.screenWidth * 0.07,
                width: SizeConfig.screenWidth * 0.610,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
