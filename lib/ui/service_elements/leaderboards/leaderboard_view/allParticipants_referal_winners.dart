import 'package:felloapp/core/model/scoreboard_model.dart';
import 'package:felloapp/core/model/winners_model.dart';
import 'package:felloapp/ui/pages/static/new_square_background.dart';
import 'package:felloapp/util/constants.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';

class AllParticipantsWinnersTopReferers extends StatelessWidget {
  AllParticipantsWinnersTopReferers(
      {@required this.isForTopReferers,
      this.winners,
      this.referralLeaderBoard,
      Key key})
      : super(key: key);

  bool isForTopReferers;
  List<Winners> winners;
  List<ScoreBoard> referralLeaderBoard;

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
    return Scaffold(
      body: Stack(
        children: [
          NewSquareBackground(),
          SingleChildScrollView(
            child: Column(
              children: [
                AppBar(
                  backgroundColor: UiConstants.kBackgroundColor,
                  elevation: 0.0,
                  title: Text(
                    isForTopReferers ? 'Top Referers' : 'Highest Scoreers',
                    maxLines: 1,
                    overflow: TextOverflow.clip,
                    style: TextStyles.title4.bold.colour(Colors.white),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(SizeConfig.pageHorizontalMargins),
                  child: Column(
                    children: isForTopReferers
                        ? List.generate(
                            referralLeaderBoard.length,
                            (i) {
                              return Container(
                                width: SizeConfig.screenWidth,
                                padding: EdgeInsets.symmetric(
                                    vertical: SizeConfig.padding12),
                                margin: EdgeInsets.symmetric(
                                  vertical: SizeConfig.padding8,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.transparent,
                                ),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          "${i + 1}",
                                          style: TextStyles.sourceSans.body2
                                              .colour(Colors.white),
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
                                              Text(
                                                  referralLeaderBoard[i]
                                                          .username
                                                          .replaceAll(
                                                              '@', '.') ??
                                                      "username",
                                                  style: TextStyles
                                                      .sourceSans.body2
                                                      .colour(Colors.white)),
                                            ],
                                          ),
                                        ),
                                        Text(
                                          referralLeaderBoard[i]
                                                  .refCount
                                                  .toString() ??
                                              "00",
                                          style: TextStyles.sourceSans.body2
                                              .colour(Colors.white),
                                        )
                                      ],
                                    ),
                                    if (i + 1 < referralLeaderBoard.length)
                                      Divider(
                                        color: Colors.white,
                                        thickness: 0.2,
                                      )
                                  ],
                                ),
                              );
                            },
                          )
                        : List.generate(
                            winners.length,
                            (i) {
                              return Column(
                                children: [
                                  Container(
                                    width: SizeConfig.screenWidth,
                                    padding: EdgeInsets.symmetric(
                                        vertical: SizeConfig.padding12),
                                    margin: EdgeInsets.symmetric(
                                      vertical: SizeConfig.padding4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.transparent,
                                      borderRadius: BorderRadius.circular(
                                          SizeConfig.roundness16),
                                    ),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "${i + 1}",
                                          style: TextStyles.sourceSans.body2
                                              .colour(Colors.white),
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
                                                  winners[i]
                                                          .username
                                                          .replaceAll(
                                                              '@', '.') ??
                                                      "username",
                                                  style: TextStyles
                                                      .sourceSans.body2
                                                      .colour(Colors.white)),
                                              Text(
                                                getGameName(
                                                    winners[i].gameType),
                                                style: TextStyles.body4.colour(
                                                    UiConstants.kTextColor2),
                                              ),
                                              SizedBox(
                                                  height: SizeConfig.padding4),
                                            ],
                                          ),
                                        ),
                                        Text(
                                          "₹ ${winners[i].amount.toInt() ?? "00"}",
                                          style: TextStyles.sourceSans.body2
                                              .colour(Colors.white),
                                        )
                                      ],
                                    ),
                                  ),
                                  if (i + 1 < winners.length)
                                    Divider(
                                      color: Colors.white,
                                      thickness: 0.2,
                                    )
                                ],
                              );
                            },
                          ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
