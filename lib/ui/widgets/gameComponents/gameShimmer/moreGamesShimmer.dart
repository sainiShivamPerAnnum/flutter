import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';


class MoreGamesShimmer extends StatelessWidget {
  const MoreGamesShimmer({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(SizeConfig.padding16),
      height: SizeConfig.screenWidth * 0.218,
      width: SizeConfig.screenWidth * 0.901,
      decoration: BoxDecoration(
        color: Colors.transparent,
        border: Border.all(color: Colors.white30),
        borderRadius: BorderRadius.circular(SizeConfig.roundness8),
      ),
      child: ClipRRect(
          borderRadius: BorderRadius.circular(SizeConfig.roundness5),
        child: Shimmer.fromColors(
          baseColor: UiConstants.kUserRankBackgroundColor,
          highlightColor: UiConstants.kBackgroundColor,
          child: Row(
            children: [
              Padding(
               padding:  EdgeInsets.symmetric(horizontal: SizeConfig.padding16),
                child: Container(
                  width: SizeConfig.screenWidth * 0.16,
                  height: SizeConfig.screenWidth * 0.16,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade600,
                    borderRadius: BorderRadius.circular(SizeConfig.roundness5),
                  ),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade600,
                      borderRadius: BorderRadius.circular(SizeConfig.roundness5),
                    ),
                    width: SizeConfig.screenWidth * 0.213,
                    height: SizeConfig.screenWidth * 0.053,
                  ),
                  Container(
                    width: SizeConfig.screenWidth * 0.266,
                    height: SizeConfig.screenWidth * 0.026,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade600,
                      borderRadius: BorderRadius.circular(SizeConfig.roundness5),
                    ),
                  ),
                ],
              ),
              Spacer(),
              Padding(
                padding:  EdgeInsets.symmetric(horizontal: SizeConfig.padding16),
                child: Container(
                  width: SizeConfig.screenWidth * 0.106,
                  height: SizeConfig.screenWidth * 0.08,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade600,
                    borderRadius: BorderRadius.circular(SizeConfig.roundness5),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}