import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class RankWidget extends StatelessWidget {
  const RankWidget({
    Key? key,
    this.firstPriceMoney,
    this.secondPriceMoney,
    this.thirdPriceMoney,
    this.firstPricePoint,
    this.secondPricePoint,
    this.thirdPricePoint,
  }) : super(key: key);

  final int? firstPriceMoney, secondPriceMoney, thirdPriceMoney;
  final int? firstPricePoint, secondPricePoint, thirdPricePoint;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: SizeConfig.padding54,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            _buildRankPiller(
              rank: 3,
              image: Assets.prizeRankThird,
              priceMoney: thirdPriceMoney,
              pricePoint: thirdPricePoint,
              color: UiConstants.kThirdRankPillerColor,
              context: context,
            ),
            _buildRankPiller(
              rank: 1,
              image: Assets.prizeRankOne,
              priceMoney: firstPriceMoney,
              pricePoint: firstPricePoint,
              color: UiConstants.kFirstRankPillerColor,
              context: context,
            ),
            _buildRankPiller(
              rank: 2,
              image: Assets.prizeRankTwo,
              priceMoney: secondPriceMoney,
              pricePoint: secondPricePoint,
              color: UiConstants.kSecondRankPillerColor,
              context: context,
            ),
          ],
        ),
      ],
    );
  }

  _buildRankPiller({
    required int rank,
    required String image,
    required Color color,
    int? priceMoney,
    int? pricePoint,
    BuildContext? context,
  }) {
    double pillerBoxHeight = SizeConfig.screenWidth! * 0.5556 -
        ((rank - 1.0) *
            SizeConfig.screenWidth! *
            0.055); // 200 - (rank - 1) * 20
    double pillerHeight = SizeConfig.screenWidth! * 0.5 -
        ((rank - 1.0) *
            SizeConfig.screenWidth! *
            0.055); // 180 - (rank - 1) * 20
    S locale = S.of(context!);
    return SizedBox(
      height: pillerBoxHeight,
      child: Stack(
        children: [
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              margin: EdgeInsets.symmetric(
                horizontal: SizeConfig.padding6,
              ),
              padding: EdgeInsets.symmetric(
                vertical: SizeConfig.padding12,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(
                  SizeConfig.roundness5,
                ),
                color: color.withOpacity(0.1),
              ),
              height: pillerHeight,
              width: SizeConfig.screenWidth! * 0.25, // 90
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    "$rank${rank == 1 ? 'st' : rank == 2 ? 'nd' : 'rd'}",
                    style: rank == 1
                        ? TextStyles.rajdhaniB.title4
                        : TextStyles.rajdhaniB.body1,
                  ),
                  SizedBox(
                    height: SizeConfig.padding24,
                  ),
                  Text(
                    locale.rs + ' $priceMoney',
                    style: TextStyles.sourceSans.body3,
                  ),
                  SizedBox(
                    height: SizeConfig.padding4,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        Assets.token,
                        width: SizeConfig.body2,
                        height: SizeConfig.body2,
                      ),
                      SizedBox(
                        width: SizeConfig.padding6,
                      ),
                      Flexible(
                        child: Text(
                          '$pricePoint',
                          style: TextStyles.sourceSansM.body4,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            left: rank == 1
                ? SizeConfig.screenWidth! * 0.045
                : SizeConfig.screenWidth! * 0.0694,
            child: SvgPicture.asset(
              image,
              width: rank == 1 ? SizeConfig.iconSize7 : SizeConfig.iconSize6,
            ),
          ),
        ],
      ),
    );
  }
}
