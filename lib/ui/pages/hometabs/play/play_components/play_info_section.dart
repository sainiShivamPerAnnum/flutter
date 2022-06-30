import 'package:felloapp/ui/pages/hometabs/play/play_components/titlesGames.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PlayInfoSection extends StatelessWidget {
  const PlayInfoSection({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: SizeConfig.screenWidth,
      height: SizeConfig.screenWidth * 0.981,
      margin: EdgeInsets.all(SizeConfig.padding24),
      decoration: BoxDecoration(
        color: Color(0xff333333),
        borderRadius: BorderRadius.circular(SizeConfig.roundness8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: SizeConfig.padding24,
          ),
          Text(
            'What to do on Play?',
            style: TextStyles.rajdhaniSB.title4,
          ),
          SizedBox(
            height: SizeConfig.padding32,
          ),
          TitlesGames(
            asset: '',
            whiteText: 'Play Games ',
            greyText: 'with the\ntokens won',
            icon: SvgPicture.asset(
              'assets/svg/play_ludo.svg',
              height: SizeConfig.padding46,
              width: SizeConfig.padding38,
            ),
            isLast: false,
          ),
          TitlesGames(
            asset: 'assets/svg/play_leaderboard.svg',
            whiteText: 'Get listed on the game',
            greyText: '\nleaderboard',
            icon: SvgPicture.asset(
              'assets/svg/play_leaderboard.svg',
              height: SizeConfig.padding70,
              width: SizeConfig.padding35,
            ),
            isLast: false,
          ),
          TitlesGames(
            asset: 'assets/svg/play_gift.svg',
            whiteText: 'Win Coupons and Cashbacks',
            greyText: '\nas rewards',
            icon: SvgPicture.asset(
              'assets/svg/play_gift.svg',
              height: SizeConfig.padding44,
              width: SizeConfig.padding35,
            ),
            isLast: true,
          ),
        ],
      ),
    );
  }
}
