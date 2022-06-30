import 'package:felloapp/ui/widgets/gameComponents/gameRewards.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:flutter/material.dart';

class TrendingGames extends StatelessWidget {
  final String thumbnailUrl, gameName;
  final int prizeAmount, playCost;

  const TrendingGames({
    this.thumbnailUrl,
    this.gameName,
    this.prizeAmount,
    this.playCost,
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
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(
                top: SizeConfig.padding4,
                left: SizeConfig.padding6,
                right: SizeConfig.padding6),
            height: SizeConfig.screenWidth * 0.309,
            width: SizeConfig.screenWidth * 0.578,
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(SizeConfig.roundness8),
                topRight: Radius.circular(SizeConfig.roundness8),
              ),
              child: Image.network(
                thumbnailUrl,
                fit: BoxFit.fill,
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(
                  left: SizeConfig.padding8,
                  top: SizeConfig.padding12,
                ),
                child: Text(
                  '$gameName ChampionShip',
                  style: TextStyles.rajdhaniSB.body2,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(right: SizeConfig.padding12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Row(
                      children: [
                        Image.asset(
                          'assets/images/token_logo.png',
                          height: SizeConfig.padding16,
                        ),
                        Text(
                          playCost.toString(),
                          style: TextStyles.sourceSansSB.body3,
                        )
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: SizeConfig.padding8),
                child: GameRewards(prizeAmount: prizeAmount),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
