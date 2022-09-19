import 'package:cached_network_image/cached_network_image.dart';
import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/core/enums/winner_service_enum.dart';
import 'package:felloapp/core/service/notifier_services/winners_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/ui/pages/static/game_card.dart';
import 'package:felloapp/ui/service_elements/leaderboards/leaderboard_view/allParticipants_referal_winners.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/constants.dart';
import 'package:felloapp/util/haptic.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:property_change_notifier/property_change_notifier.dart';
import 'dart:math' as math;

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

  getGameName(String gamename) {
    switch (gamename) {
      case Constants.GAME_TYPE_TAMBOLA:
        return "Tambola";
      case Constants.GAME_TYPE_CRICKET:
        return "Cricket";
      case Constants.GAME_TYPE_POOLCLUB:
        return "Pool Club";
      case Constants.GAME_TYPE_FOOTBALL:
        return "Foot Ball";
      case Constants.GAME_TYPE_CANDYFIESTA:
        return "Candy Fiesta";
    }
  }

  @override
  Widget build(BuildContext context) {
    return PropertyChangeConsumer<WinnerService, WinnerServiceProperties>(
        properties: [WinnerServiceProperties.winLeaderboard],
        builder: (context, model, properties) {
          return Container(
            child: Stack(
              alignment: Alignment.topCenter,
              children: [
                //1
                Container(
                  margin: EdgeInsets.only(top: SizeConfig.padding32),
                  width: SizeConfig.screenWidth * 0.5,
                  height: SizeConfig.screenWidth * 0.5,
                  decoration: BoxDecoration(
                    color: UiConstants.kSecondaryBackgroundColor,
                    shape: BoxShape.circle,
                  ),
                ),
                //2
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: SizeConfig.padding24),
                  margin: EdgeInsets.fromLTRB(
                      0.0,
                      SizeConfig.screenWidth * 0.15 + SizeConfig.padding32,
                      0.0,
                      0.0),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: UiConstants.kSecondaryBackgroundColor,
                  ),
                  child: Column(
                    children: [
                      SizedBox(
                        height: SizeConfig.padding64,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                "Game Winners",
                                style: TextStyles.rajdhaniSB.body0.colour(
                                    UiConstants.kSecondaryLeaderBoardTextColor),
                              ),
                              Text(
                                model.getDateRange(),
                                style: TextStyles.sourceSans.body4
                                    .colour(UiConstants.kTextFieldTextColor),
                              )
                            ],
                          ),
                          if (model.winners.length >
                              getLength(model.winners.length))
                            GestureDetector(
                              onTap: () {
                                Haptic.vibrate();
                                AppState.delegate.appState.currentAction =
                                    PageAction(
                                  state: PageState.addWidget,
                                  widget: AllParticipantsWinnersTopReferers(
                                    isForTopReferers: false,
                                    winners: model.winners,
                                  ),
                                  page: AllParticipantsWinnersTopReferersConfig,
                                );
                              },
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(
                                      top: SizeConfig.padding2,
                                    ),
                                    child: Text('See All',
                                        style: TextStyles.rajdhaniSB.body2),
                                  ),
                                  SvgPicture.asset(Assets.chevRonRightArrow,
                                      height: SizeConfig.padding24,
                                      width: SizeConfig.padding24,
                                      color: UiConstants.primaryColor)
                                ],
                              ),
                            ),
                        ],
                      ),
                      SizedBox(
                        height: SizeConfig.padding32,
                      ),
                      //Old code to refactor starts here
                      Container(
                        color: Colors.transparent,
                        padding: EdgeInsets.only(top: SizeConfig.padding8),
                        child: model.winners == null
                            ? Container(
                                margin: EdgeInsets.symmetric(
                                    vertical: SizeConfig.padding24),
                                color: Colors.transparent,
                                alignment: Alignment.center,
                                width: SizeConfig.screenWidth,
                                child: SpinKitWave(
                                  color: UiConstants.primaryColor,
                                ),
                              )
                            : (model.winners.isEmpty
                                ? Container(
                                    margin: EdgeInsets.symmetric(
                                        vertical: SizeConfig.padding24),
                                    color: Colors.transparent,
                                    alignment: Alignment.center,
                                    width: SizeConfig.screenWidth,
                                    child: NoRecordDisplayWidget(
                                      topPadding: false,
                                      asset: "images/leaderboard.png",
                                      text: "Leaderboard will be updated soon",
                                    ),
                                  )
                                : Column(
                                    children: [
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "#",
                                            style: TextStyles.sourceSans.body3
                                                .colour(
                                                    UiConstants.kTextColor2),
                                          ),
                                          SizedBox(width: SizeConfig.padding12),
                                          SizedBox(width: SizeConfig.padding12),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text("Names",
                                                    style: TextStyles
                                                        .sourceSans.body3
                                                        .colour(UiConstants
                                                            .kTextColor2)),
                                                SizedBox(
                                                    height:
                                                        SizeConfig.padding4),
                                              ],
                                            ),
                                          ),
                                          Text(
                                            "Cashprize",
                                            style: TextStyles.sourceSans.body3
                                                .colour(
                                                    UiConstants.kTextColor2),
                                          )
                                        ],
                                      ),
                                      Column(
                                        children: List.generate(
                                          getLength(model.winners.length),
                                          (i) {
                                            return Column(
                                              children: [
                                                Container(
                                                  width: SizeConfig.screenWidth,
                                                  padding: EdgeInsets.symmetric(
                                                      vertical:
                                                          SizeConfig.padding12),
                                                  margin: EdgeInsets.symmetric(
                                                    vertical:
                                                        SizeConfig.padding4,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    color: Colors.transparent,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            SizeConfig
                                                                .roundness16),
                                                  ),
                                                  child: Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        "${i + 1}",
                                                        style: TextStyles
                                                            .sourceSans.body2
                                                            .colour(
                                                                Colors.white),
                                                      ),
                                                      SizedBox(
                                                          width: SizeConfig
                                                              .padding12),
                                                      FutureBuilder(
                                                        future: model
                                                            .getProfileDpWithUid(
                                                                model.winners[i]
                                                                    .userid),
                                                        builder: (context,
                                                            snapshot) {
                                                          if (!snapshot
                                                              .hasData) {
                                                            int rand = 1 +
                                                                math.Random()
                                                                    .nextInt(4);
                                                            return SvgPicture
                                                                .asset(
                                                              "assets/svg/userAvatars/AV$rand.svg",
                                                              width: SizeConfig
                                                                  .iconSize5,
                                                              height: SizeConfig
                                                                  .iconSize5,
                                                            );
                                                          }

                                                          String imageUrl =
                                                              snapshot.data
                                                                  as String;

                                                          return ClipOval(
                                                            child:
                                                                CachedNetworkImage(
                                                              imageUrl:
                                                                  imageUrl,
                                                              fit: BoxFit.cover,
                                                              width: SizeConfig
                                                                  .iconSize5,
                                                              height: SizeConfig
                                                                  .iconSize5,
                                                              placeholder:
                                                                  (context,
                                                                          url) =>
                                                                      Container(
                                                                width: SizeConfig
                                                                    .iconSize5,
                                                                height: SizeConfig
                                                                    .iconSize5,
                                                                decoration:
                                                                    BoxDecoration(
                                                                  color: Colors
                                                                      .grey,
                                                                  shape: BoxShape
                                                                      .circle,
                                                                ),
                                                              ),
                                                              errorWidget:
                                                                  (a, b, c) {
                                                                int rand = 1 +
                                                                    math.Random()
                                                                        .nextInt(
                                                                            4);
                                                                return SvgPicture
                                                                    .asset(
                                                                  "assets/svg/userAvatars/AV$rand.svg",
                                                                  width: SizeConfig
                                                                      .iconSize5,
                                                                  height: SizeConfig
                                                                      .iconSize5,
                                                                );
                                                              },
                                                            ),
                                                          );
                                                        },
                                                      ),
                                                      SizedBox(
                                                          width: SizeConfig
                                                              .padding12),
                                                      Expanded(
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Text(
                                                                //"avc",
                                                                model.winners[i]
                                                                        .username
                                                                        .replaceAll(
                                                                            '@',
                                                                            '.') ??
                                                                    "username",
                                                                style: TextStyles
                                                                    .sourceSans
                                                                    .body2
                                                                    .colour(Colors
                                                                        .white)),
                                                            Text(
                                                              getGameName(model
                                                                  .winners[i]
                                                                  .gameType),
                                                              style: TextStyles
                                                                  .body4
                                                                  .colour(UiConstants
                                                                      .kTextColor2),
                                                            ),
                                                            SizedBox(
                                                                height: SizeConfig
                                                                    .padding4),
                                                          ],
                                                        ),
                                                      ),
                                                      Text(
                                                        "₹ ${model.winners[i].amount.toInt() ?? "00"}",
                                                        style: TextStyles
                                                            .sourceSans.body2
                                                            .colour(
                                                                Colors.white),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                                if (i + 1 <
                                                    getLength(
                                                        model.winners.length))
                                                  Divider(
                                                    color: Colors.white,
                                                    thickness: 0.2,
                                                  )
                                              ],
                                            );
                                          },
                                        ),
                                      ),
                                      SizedBox(
                                        height: SizeConfig.padding16,
                                      ),
                                    ],
                                  )),
                      )
                    ],
                  ),
                ),
                //3
                Container(
                  margin: EdgeInsets.only(right: SizeConfig.padding14),
                  child: SvgPicture.asset(
                    Assets.winScreenHighestScorers,
                    width: SizeConfig.screenWidth * 0.3,
                  ),
                ),
              ],
            ),
          );
        });
  }
}
