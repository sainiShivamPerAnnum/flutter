import 'dart:developer';

import 'package:felloapp/core/enums/leaderboard_service_enum.dart';
import 'package:felloapp/core/model/leader_board_modal.dart';
import 'package:felloapp/core/service/notifier_services/leaderboard_service.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/ui/pages/static/game_card.dart';
import 'package:felloapp/ui/service_elements/leaderboards/leaderboard_view/components/winner_widget.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:property_change_notifier/property_change_notifier.dart';

class NewWebGameLeaderBoardView extends StatelessWidget {
  const NewWebGameLeaderBoardView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PropertyChangeConsumer<LeaderboardService,
        LeaderBoardServiceProperties>(
      properties: [LeaderBoardServiceProperties.WebGameLeaderBoard],
      builder: (context, m, properties) {
        return m.WebGameLeaderBoard == null
            ? NoRecordDisplayWidget(
                asset: "images/leaderboard.png",
                text: "Leaderboard will be updated soon",
              )
            : NewLeaderBoardView(
                model: m.WebGameLeaderBoard,
              );
      },
    );
  }
}

class NewLeaderBoardView extends StatelessWidget {
  NewLeaderBoardView({@required this.model});

  final LeaderBoardModal model;
  final _userService = locator<UserService>();

  @override
  Widget build(BuildContext context) {
    log(model.toMap().toString());
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
                  style: TextStyles.rajdhaniSB.body2,
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
                  style: TextStyles.rajdhaniB.body2,
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
                  style: TextStyles.rajdhaniSB.body2,
                )
              ],
            ),
            RichText(
              text: TextSpan(
                children: <TextSpan>[
                  TextSpan(
                    text: 'Best : ',
                    style: TextStyles.rajdhani.body3,
                  ),
                  TextSpan(
                    text: '43 Runs',
                    style: TextStyles.rajdhaniSB.body3,
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
              Expanded(
                child: Row(
                  children: [
                    Text(
                      '${index + 4}',
                      style: TextStyles.rajdhaniSB.body2,
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
                    Expanded(
                      child: Text(
                        '${winnerDetails[index]['name']}',
                        style: TextStyles.sourceSans.body3.setOpecity(0.8),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    )
                  ],
                ),
              ),
              Text(
                '${winnerDetails[index]['score']}',
                style: TextStyles.rajdhaniM.body3,
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
