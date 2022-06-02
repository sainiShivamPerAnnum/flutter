import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class RankWidget extends StatelessWidget {
  const RankWidget({
    Key key,
    this.firstPriceMoney,
    this.secondPriceMoney,
    this.thirdPriceMoney,
    this.firstPricePoint,
    this.secondPricePoint,
    this.thirdPricePoint,
  }) : super(key: key);

  final int firstPriceMoney, secondPriceMoney, thirdPriceMoney;
  final int firstPricePoint, secondPricePoint, thirdPricePoint;

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
              image: 'rank_third.svg',
              priceMoney: thirdPriceMoney,
              pricePoint: thirdPricePoint,
              color: UiConstants.kThirdRankPillerColor,
              context: context,
            ),
            _buildRankPiller(
              rank: 1,
              image: 'rank_first.svg',
              priceMoney: firstPriceMoney,
              pricePoint: firstPricePoint,
              color: UiConstants.kFirstRankPillerColor,
              context: context,
            ),
            _buildRankPiller(
              rank: 2,
              image: 'rank_second.svg',
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
    int rank,
    String image,
    int priceMoney,
    int pricePoint,
    Color color,
    BuildContext context,
  }) {
    double pillerBoxHeight = SizeConfig.screenHeight * 0.257 -
        ((rank - 1.0) *
            SizeConfig.screenHeight *
            0.024); // 200 - (rank - 1) * 20
    double pillerHeight = SizeConfig.screenHeight * 0.2308 -
        ((rank - 1.0) *
            SizeConfig.screenHeight *
            0.0256); // 180 - (rank - 1) * 20
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
              width: SizeConfig.screenWidth * 0.25, // 90
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    height: SizeConfig.padding32,
                  ),
                  Text(
                    "$rank${rank == 1 ? 'st' : rank == 2 ? 'nd' : 'rd'}",
                    style: Rajdhani.style.body1.bold,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'Rs $priceMoney',
                        style: SansPro.style.body3,
                      ),
                      SizedBox(
                        height: SizeConfig.padding4,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset('assets/temp/Tokens.svg'),
                          SizedBox(
                            width: SizeConfig.padding6,
                          ),
                          Text(
                            '$pricePoint',
                            style: SansPro.style.body4.medium,
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            left: rank == 1
                ? SizeConfig.screenWidth * 0.0555
                : SizeConfig.screenWidth * 0.0694,
            child: SvgPicture.asset(
              'assets/temp/$image',
              width: rank == 1 ? SizeConfig.iconSize7 : SizeConfig.iconSize6,
            ),
          ),
        ],
      ),
    );
  }
}
