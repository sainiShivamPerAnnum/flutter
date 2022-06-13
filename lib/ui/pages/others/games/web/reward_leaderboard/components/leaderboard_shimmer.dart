import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class LeaderboardShimmer extends StatelessWidget {
  const LeaderboardShimmer({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: SizeConfig.padding12,
      ),
      padding: EdgeInsets.symmetric(
        horizontal: SizeConfig.padding12,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(
          SizeConfig.roundness5,
        ),
        color: UiConstants.kLeaderBoardBackgroundColor,
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildUserProfile(
                padding: EdgeInsets.only(
                  top: SizeConfig.padding64,
                  left: SizeConfig.padding8,
                  right: SizeConfig.padding8,
                ),
              ),
              _buildUserProfile(
                padding: EdgeInsets.only(
                  // top: SizeConfig.padding8,
                  left: SizeConfig.padding8,
                  right: SizeConfig.padding8,
                ),
              ),
              _buildUserProfile(
                padding: EdgeInsets.only(
                  top: SizeConfig.padding80,
                  left: SizeConfig.padding8,
                  right: SizeConfig.padding8,
                ),
              ),
            ],
          ),
          SizedBox(
            height: SizeConfig.screenWidth * 0.07,
          ),
          Column(
            children: List.generate(
              3,
              (index) {
                return Shimmer.fromColors(
                  baseColor: UiConstants.kUserRankBackgroundColor,
                  highlightColor: UiConstants.kBackgroundColor,
                  child: Container(
                    margin: EdgeInsets.symmetric(
                      horizontal: SizeConfig.padding12,
                      vertical: SizeConfig.padding8,
                    ),
                    height: SizeConfig.screenWidth * 0.15,
                    decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.circular(SizeConfig.roundness12),
                      color: Colors.white,
                    ),
                  ),
                );
              },
            ),
          ),
          SizedBox(
            height: SizeConfig.screenWidth * 0.07,
          ),
        ],
      ),
    );
  }

  Shimmer _buildUserProfile({EdgeInsets padding}) {
    return Shimmer.fromColors(
      baseColor: UiConstants.kUserRankBackgroundColor,
      highlightColor: UiConstants.kBackgroundColor,
      child: Padding(
        padding: padding,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(
            90,
          ),
          child: Container(
            height: 90,
            width: 90,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
