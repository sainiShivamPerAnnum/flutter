import 'package:felloapp/core/enums/leaderboard_service_enum.dart';
import 'package:felloapp/core/model/leader_board_modal.dart';
import 'package:felloapp/core/service/leaderboard_service.dart';
import 'package:felloapp/ui/pages/others/games/cricket/cricket_home/cricket_home_view.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:property_change_notifier/property_change_notifier.dart';

class CricketLeaderboardView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PropertyChangeConsumer<LeaderboardService,
            LeaderBoardServiceProperties>(
        properties: [LeaderBoardServiceProperties.CricketLeaderboard],
        builder: (context, m, properties) {
          return m.cricketLeaderBoard == null
              ? NoRecordDisplayWidget(
                  asset: "images/leaderboard.png",
                  text: "Leaderboard will be updated soon",
                )
              : LeaderBoardView(
                  model: m.cricketLeaderBoard,
                  controller: m.parentController,
                  ownController: m.ownController,
                );
        });
  }
}

class LeaderBoardView extends StatelessWidget {
  final LeaderBoardModal model;
  final ScrollController controller, ownController;

  LeaderBoardView({this.model, this.controller, this.ownController});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: SizeConfig.padding8),
        Padding(
          padding: EdgeInsets.all(SizeConfig.padding8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'This week\'s top scorers:',
                style: TextStyles.body4.colour(Colors.grey),
              ),
              Text(
                "Updated on: ${DateFormat('dd-MMM-yyyy | hh:mm:ss').format(model.lastupdated.toDate())}",
                style: TextStyles.body4.colour(Colors.grey),
              )
            ],
          ),
        ),
        Expanded(
          child: NotificationListener<OverscrollNotification>(
            onNotification: (OverscrollNotification value) {
              if (value.overscroll < 0 &&
                  controller.offset + value.overscroll <= 0) {
                if (controller.offset != 0) controller.jumpTo(0);
                return true;
              }
              if (controller.offset + value.overscroll >=
                  controller.position.maxScrollExtent) {
                if (controller.offset != controller.position.maxScrollExtent)
                  controller.jumpTo(controller.position.maxScrollExtent);
                return true;
              }
              controller.jumpTo(controller.offset + value.overscroll);
              return true;
            },
            child: ListView.builder(
              // physics: ClampingScrollPhysics(),
              controller: ownController,
              padding: EdgeInsets.only(bottom: SizeConfig.navBarHeight),
              itemCount: model.scoreboard.length,
              itemBuilder: (ctx, i) {
                return Container(
                  width: SizeConfig.screenWidth,
                  padding: EdgeInsets.all(SizeConfig.padding12),
                  margin: EdgeInsets.symmetric(vertical: SizeConfig.padding8),
                  decoration: BoxDecoration(
                    color: UiConstants.primaryLight.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(SizeConfig.roundness16),
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: UiConstants.primaryColor,
                        radius: SizeConfig.padding16,
                        child: Text(
                          "${i + 1}",
                          style: TextStyles.body4.bold.colour(Colors.white),
                        ),
                      ),
                      SizedBox(width: SizeConfig.padding12),
                      Expanded(
                        child: Text(
                            model.scoreboard[i].username.replaceAll('@', '.') ??
                                "username",
                            style: TextStyles.body3),
                      ),
                      TextButton.icon(
                          icon: CircleAvatar(
                            radius: SizeConfig.screenWidth * 0.029,
                            backgroundColor: Colors.blue[900].withOpacity(0.2),
                            child: SvgPicture.asset(Assets.scoreIcon,
                                color: Colors.blue[900],
                                height: SizeConfig.iconSize3),
                          ),
                          label: Text(
                              model.scoreboard[i].score.toString() ?? "00",
                              style: TextStyles.body3.colour(Colors.black54)),
                          onPressed: () {}),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
