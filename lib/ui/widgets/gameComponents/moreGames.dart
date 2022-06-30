import 'package:felloapp/ui/widgets/button4.0/appBar_button.dart';
import 'package:felloapp/ui/widgets/gameComponents/gameRewards.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:flutter/material.dart';

class MoreGames extends StatelessWidget {
  final String thumbnailUrl, gameName;
  final int prizeAmount, playCost;

  const MoreGames({
    this.thumbnailUrl,
    this.gameName,
    this.prizeAmount, this.playCost,
    Key key, 
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin:  EdgeInsets.all(SizeConfig.padding16),
      height: SizeConfig.screenWidth * 0.218,
      width: SizeConfig.screenWidth * 0.901,
      decoration: BoxDecoration(
        color: Colors.transparent,
        border: Border.all(color: Colors.white30),
        borderRadius: BorderRadius.circular(SizeConfig.roundness8),
      ),
      child: Row(
        children: [
          Padding(
            padding:  EdgeInsets.symmetric(horizontal: SizeConfig.padding16),
            child: Container(
              height: SizeConfig.screenWidth * 0.170,
              width: SizeConfig.screenWidth * 0.170,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(SizeConfig.roundness8),
                child: Image.network(
                  thumbnailUrl,
                  fit: BoxFit.fill,
                ),
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                gameName,
                style: TextStyles.rajdhaniSB.body2,
              ),
              GameRewards(prizeAmount: prizeAmount),
            ],
          ),
          Spacer(),
          AppBarButton(
            svgAsset: 'assets/svg/token_svg.svg',
            coin: playCost.toString(),
            borderColor: Colors.transparent,
            screenWidth: SizeConfig.screenWidth * 0.18,
            onTap: () {},
            style: TextStyles.sourceSansSB.body2,
          ),
        ],
      ),
    );
  }
}