import 'dart:developer';

import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shimmer/shimmer.dart';

class RewardShimmer extends StatelessWidget {
  const RewardShimmer({Key key}) : super(key: key);

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
        color: UiConstants.kSecondaryBackgroundColor,
      ),
      height: SizeConfig.screenWidth * 1.389,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
              child: Center(
            child: ListView(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              children: [
                _buildPiller(2),
                _buildPiller(1),
                _buildPiller(3),
              ],
            ),
          )),
          SizedBox(
            height: SizeConfig.screenWidth * 0.05,
          ),
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: 3,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return Shimmer.fromColors(
                  baseColor: UiConstants.kUserRankBackgroundColor,
                  highlightColor: UiConstants.kBackgroundColor,
                  child: Container(
                    margin: EdgeInsets.symmetric(
                      horizontal: SizeConfig.padding12,
                      vertical: SizeConfig.padding8,
                    ),
                    decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.circular(SizeConfig.roundness12),
                      color: Colors.white,
                    ),
                    height: SizeConfig.screenWidth * 0.15,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Shimmer _buildPiller(int rank) {
    double pillerBoxHeight = SizeConfig.screenHeight * 0.257 -
        ((rank - 1.0) *
            SizeConfig.screenHeight *
            0.024); // 200 - (rank - 1) * 20

    return Shimmer.fromColors(
      baseColor: UiConstants.kUserRankBackgroundColor,
      highlightColor: UiConstants.kBackgroundColor,
      child: Padding(
        padding: EdgeInsets.only(
          top: pillerBoxHeight - (pillerBoxHeight - (rank * 30)),
          right: 5,
          left: 5,
          bottom: 20,
        ),
        child: SizedBox(
          width: SizeConfig.screenWidth * 0.2,
          child: Container(
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
