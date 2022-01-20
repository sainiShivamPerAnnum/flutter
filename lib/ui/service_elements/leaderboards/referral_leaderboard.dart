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
          return Container(
            color: Colors.white,
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                  ),
                  padding: EdgeInsets.only(top: SizeConfig.padding8),
                  child: model.referralLeaderBoard == null
                      ? Container(
                          width: SizeConfig.screenWidth,
                          color: Colors.white,
                          alignment: Alignment.center,
                          child: ListLoader())
                      : (model.referralLeaderBoard.isEmpty
                          ? Container(
                              width: SizeConfig.screenWidth,
                              height: SizeConfig.safeScreenHeight * 0.88,
                              color: Colors.white,
                              child: NoRecordDisplayWidget(
                                asset: "images/leaderboard.png",
                                text:
                                    "Referral Leaderboard will be updated soon",
                              ),
                            )
                          : Column(
                              children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal:
                                        SizeConfig.pageHorizontalMargins,
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'This months\'s top referrers:',
                                        style: TextStyles.body4
                                            .colour(Colors.grey),
                                      ),
                                    ],
                                  ),
                                ),
                                Column(
                                  children: List.generate(
                                    getLength(model.referralLeaderBoard.length),
                                    (i) {
                                      return Container(
                                        width: SizeConfig.screenWidth,
                                        padding: EdgeInsets.all(
                                            SizeConfig.padding12),
                                        margin: EdgeInsets.symmetric(
                                            vertical: SizeConfig.padding8,
                                            horizontal: SizeConfig
                                                .pageHorizontalMargins),
                                        decoration: BoxDecoration(
                                          color: Color(0xfff6f6f6),
                                          borderRadius: BorderRadius.circular(
                                              SizeConfig.roundness16),
                                        ),
                                        child: Row(
                                          children: [
                                            CircleAvatar(
                                              backgroundColor:
                                                  UiConstants.primaryColor,
                                              radius: SizeConfig.padding16,
                                              child: Text(
                                                "${i + 1}",
                                                style: TextStyles.body4
                                                    .colour(Colors.white),
                                              ),
                                            ),
                                            SizedBox(
                                                width: SizeConfig.padding12),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                      model
                                                              .referralLeaderBoard[
                                                                  i]
                                                              .username
                                                              .replaceAll(
                                                                  '@', '.') ??
                                                          "username",
                                                      style: TextStyles.body3),
                                                ],
                                              ),
                                            ),
                                            PrizeChip(
                                              color: UiConstants.primaryColor,
                                              png: Assets.moneyIcon,
                                              text: model.referralLeaderBoard[i]
                                                      .refCount
                                                      .toString() ??
                                                  "00",
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            )),
                ),
                SizedBox(
                  height: SizeConfig.navBarHeight * 1.5,
                )
              ],
            ),
          );
        });
  }
}
