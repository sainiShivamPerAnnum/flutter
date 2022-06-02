import 'package:felloapp/ui/pages/others/games/web/new_game_home/leaderboard/components/winner_widget.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';

class LeaderBoardView extends StatelessWidget {
  const LeaderBoardView({Key key}) : super(key: key);

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
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const WinnerWidgets(),
          const UserRank(),
          const RemainingRank(),
          SizedBox(
            height: SizeConfig.padding12,
          ),
          TextButton(
            onPressed: () {},
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'See All',
                  style: Rajdhani.style.body2.semiBold,
                ),
                SizedBox(
                  width: SizeConfig.padding6,
                ),
                Image.asset(
                  'assets/temp/chevron_right.png',
                  width: SizeConfig.iconSize1,
                  height: SizeConfig.iconSize1,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class UserRank extends StatelessWidget {
  const UserRank({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: SizeConfig.screenWidth,
      decoration: BoxDecoration(
        color: UiConstants.kUserRankBackgroundColor,
        borderRadius: BorderRadius.circular(
          SizeConfig.roundness5,
        ),
      ),
      margin: EdgeInsets.only(
        bottom: SizeConfig.padding16,
        top: SizeConfig.padding32,
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: SizeConfig.padding12,
          horizontal: SizeConfig.padding16,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Text(
                  '56',
                  style: Rajdhani.style.body2.bold,
                ),
                SizedBox(
                  width: SizeConfig.padding20,
                ),
                Image.asset(
                  'assets/temp/rank_one_profile.png',
                  width: SizeConfig.iconSize5,
                  height: SizeConfig.iconSize5,
                ),
                SizedBox(
                  width: SizeConfig.padding12,
                ),
                Text(
                  "YOU",
                  style: Rajdhani.style.body2.semiBold,
                )
              ],
            ),
            RichText(
              text: TextSpan(
                children: <TextSpan>[
                  TextSpan(
                    text: 'Best : ',
                    style: Rajdhani.style.body3,
                  ),
                  TextSpan(
                    text: '43 Runs',
                    style: Rajdhani.style.body3.semiBold,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RemainingRank extends StatefulWidget {
  const RemainingRank({Key key}) : super(key: key);

  @override
  State<RemainingRank> createState() => _RemainingRankState();
}

class _RemainingRankState extends State<RemainingRank> {
  final List<Map<String, dynamic>> winnerDetails = [
    {
      'name': 'A5hwin_Singh',
      'image': 'rank_one_profile.png',
      'score': '100 Runs'
    },
    {
      'name': 'Mehul@Dutta',
      'image': 'rank_three_profile.png',
      'score': '76 Runs'
    },
    {
      'name': 'Ashutosh_27',
      'image': 'rank_two_profile.png',
      'score': '75 Runs'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: 3,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return Padding(
          padding: EdgeInsets.symmetric(
            vertical: SizeConfig.padding20,
            horizontal: SizeConfig.padding24,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    '${index + 4}',
                    style: Rajdhani.style.body2.semiBold,
                  ),
                  SizedBox(
                    width: SizeConfig.padding20,
                  ),
                  Image.asset(
                    'assets/temp/${winnerDetails[index]['image']}',
                    width: SizeConfig.iconSize5,
                    height: SizeConfig.iconSize5,
                  ),
                  SizedBox(
                    width: SizeConfig.padding12,
                  ),
                  Text(
                    '${winnerDetails[index]['name']}',
                    style: SansPro.style.body3.setOpecity(0.8),
                  )
                ],
              ),
              Text(
                '${winnerDetails[index]['score']}',
                style: Rajdhani.style.body3.medium,
              ),
            ],
          ),
        );
      },
      separatorBuilder: (context, index) {
        return Divider(
          height: SizeConfig.dividerHeight, // 0.5
          color: UiConstants.kDividerColor,
        );
      },
    );
  }
}
