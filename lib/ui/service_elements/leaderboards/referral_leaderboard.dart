import 'package:felloapp/core/enums/leaderboard_service_enum.dart';
import 'package:felloapp/core/service/leaderboard_service.dart';
import 'package:felloapp/ui/pages/others/games/cricket/cricket_home/cricket_home_view.dart';
import 'package:felloapp/ui/pages/others/games/tambola/tambola_home/tambola_home_view.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:property_change_notifier/property_change_notifier.dart';

class ReferralLeaderboard extends StatelessWidget {
  final int count;
  ReferralLeaderboard({this.count});
  getLength(int listLength) {
    if (count != null) {
      if (listLength < count)
        return listLength;
      else
        return count;
    } else
      return listLength;
  }

  @override
  Widget build(BuildContext context) {
    return PropertyChangeConsumer<LeaderboardService,
            LeaderBoardServiceProperties>(
        properties: [LeaderBoardServiceProperties.ReferralLeaderboard],
        builder: (context, model, properties) {
          return Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                ),
                padding: EdgeInsets.all(SizeConfig.padding12),
                child: model.referralLeaderBoard == null
                    ? Container(
                        width: SizeConfig.screenWidth,
                        color: Colors.white,
                        alignment: Alignment.center,
                        child: ListLoader())
                    : (model.referralLeaderBoard.isEmpty
                        ? Container(
                            width: SizeConfig.screenWidth,
                            color: Colors.white,
                            child: NoRecordDisplayWidget(
                              asset: "images/leaderboard.png",
                              text: "Referral Leaderboard will be updated soon",
                            ),
                          )
                        : Column(
                            children: List.generate(
                                getLength(model.referralLeaderBoard.length),
                                (i) {
                              return Container(
                                width: SizeConfig.screenWidth,
                                padding: EdgeInsets.all(SizeConfig.padding12),
                                margin: EdgeInsets.symmetric(
                                    vertical: SizeConfig.padding8),
                                decoration: BoxDecoration(
                                  color:
                                      UiConstants.primaryLight.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(
                                      SizeConfig.roundness16),
                                ),
                                child: Row(
                                  children: [
                                    CircleAvatar(
                                      backgroundColor: UiConstants.primaryColor,
                                      radius: SizeConfig.padding16,
                                      child: Text(
                                        "${i + 1}",
                                        style: TextStyles.body4.bold
                                            .colour(Colors.white),
                                      ),
                                    ),
                                    SizedBox(width: SizeConfig.padding12),
                                    Expanded(
                                      child: Text(
                                          model.referralLeaderBoard[i].username
                                                  .replaceAll('@', '.') ??
                                              "username",
                                          style: TextStyles.body3),
                                    ),
                                    TextButton.icon(
                                        icon: CircleAvatar(
                                          radius:
                                              SizeConfig.screenWidth * 0.029,
                                          backgroundColor:
                                              UiConstants.tertiaryLight,
                                          child: SvgPicture.asset(Assets.plane,
                                              color: UiConstants.tertiarySolid,
                                              height: SizeConfig.iconSize3),
                                        ),
                                        label: Text(
                                            model.referralLeaderBoard[i]
                                                    .refCount
                                                    .toString() ??
                                                "00",
                                            style: TextStyles.body3
                                                .colour(Colors.black54)),
                                        onPressed: () {}),
                                  ],
                                ),
                              );
                            }),
                          )),
              ),
              SizedBox(
                height: SizeConfig.navBarHeight * 1.5,
              )
            ],
          );
        });
  }
}
