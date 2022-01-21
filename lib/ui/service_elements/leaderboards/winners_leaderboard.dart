import 'package:felloapp/core/enums/winner_service_enum.dart';
import 'package:felloapp/core/service/winners_service.dart';
import 'package:felloapp/ui/pages/others/games/cricket/cricket_home/cricket_home_view.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/constants.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:property_change_notifier/property_change_notifier.dart';

class WinnerboardView extends StatelessWidget {
  final int count;
  WinnerboardView({this.count});

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
    return PropertyChangeConsumer<WinnerService, WinnerServiceProperties>(
        properties: [WinnerServiceProperties.winLeaderboard],
        builder: (context, model, properties) {
          return Container(
            color: Colors.white,
            padding: EdgeInsets.only(top: SizeConfig.padding8),
            child: model.winners == null
                ? Container(
                    color: Colors.white,
                    alignment: Alignment.center,
                    width: SizeConfig.screenWidth,
                    child: SpinKitWave(
                      color: UiConstants.primaryColor,
                    ),
                  )
                : (model.winners.isEmpty
                    ? Container(
                        color: Colors.white,
                        height: SizeConfig.safeScreenHeight * 0.88,
                        alignment: Alignment.center,
                        width: SizeConfig.screenWidth,
                        child: NoRecordDisplayWidget(
                          asset: "images/leaderboard.png",
                          text: "Leaderboard will be upadated soon",
                        ),
                      )
                    : Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: SizeConfig.pageHorizontalMargins,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Previous week\'s prize winners:',
                                  style: TextStyles.body4.colour(Colors.grey),
                                ),
                                Text(
                                  model.timeStamp != null
                                      ? "Updated on: ${DateFormat('dd-MMM-yyyy | hh:mm:ss').format(model.timeStamp.toDate())}"
                                      : "",
                                  style: TextStyles.body4.colour(Colors.grey),
                                ),
                              ],
                            ),
                          ),
                          Column(
                            children: List.generate(
                              getLength(model.winners.length),
                              (i) {
                                return Container(
                                  width: SizeConfig.screenWidth,
                                  padding: EdgeInsets.all(SizeConfig.padding12),
                                  margin: EdgeInsets.symmetric(
                                      vertical: SizeConfig.padding8,
                                      horizontal:
                                          SizeConfig.pageHorizontalMargins),
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
                                      SizedBox(width: SizeConfig.padding12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                                //"avc",
                                                model.winners[i].username
                                                        .replaceAll('@', '.') ??
                                                    "username",
                                                style: TextStyles.body3),
                                            SizedBox(
                                                height: SizeConfig.padding4),
                                            Text(
                                              model.winners[i].gameType ==
                                                      Constants
                                                          .GAME_TYPE_CRICKET
                                                  ? "Cricket"
                                                  : "Tambola",
                                              style: TextStyles.body4.colour(
                                                  UiConstants.primaryColor),
                                            )
                                          ],
                                        ),
                                      ),
                                      PrizeChip(
                                        color: UiConstants.primaryColor,
                                        png: Assets.moneyIcon,
                                        text:
                                            "₹ ${model.winners[i].amount.toString() ?? "00"}",
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                          SizedBox(
                            height: model.winners.length < 10
                                ? (10 - model.winners.length) *
                                    SizeConfig.padding54
                                : SizeConfig.navBarHeight * 1.5,
                          )
                        ],
                      )),
          );
        });
  }
}
