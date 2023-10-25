import 'package:felloapp/core/model/scoreboard_model.dart';
import 'package:felloapp/core/model/winners_model.dart';
import 'package:felloapp/core/repository/games_repo.dart';
import 'package:felloapp/ui/pages/static/new_square_background.dart';
import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';

class AllParticipantsWinnersTopReferrers extends StatelessWidget {
  AllParticipantsWinnersTopReferrers(
      {required this.isForTopReferrers,
      this.winners,
      this.referralLeaderBoard,
      this.showPoints = false,
      this.appBarTitle,
      Key? key})
      : super(key: key);
  final GameRepo _gamesRepo = locator<GameRepo>();
  final bool isForTopReferrers;
  final List<Winners>? winners;
  final List<ScoreBoard>? referralLeaderBoard;
  final bool showPoints;
  final String? appBarTitle;

  getGameName(String? gameCode) {
    return _gamesRepo.games!
        .firstWhere((game) => game.gameCode == gameCode)
        .gameName;
  }

  dynamic getPoints(double points) {
    if (points > points.toInt()) {
      return points;
    } else {
      return points.toInt();
    }
  }

  @override
  Widget build(BuildContext context) {
    S locale = S.of(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: UiConstants.kBackgroundColor,
        elevation: 0.0,
        title: Text(
          appBarTitle ??
              (isForTopReferrers ? locale.topRef : locale.topWinners),
          maxLines: 1,
          overflow: TextOverflow.clip,
          style: TextStyles.rajdhaniSB.title4,
        ),
      ),
      body: Stack(
        children: [
          const NewSquareBackground(),
          SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(SizeConfig.pageHorizontalMargins),
                  child: Column(
                    children: isForTopReferrers
                        ? List.generate(
                            referralLeaderBoard!.length,
                            (i) {
                              return Container(
                                width: SizeConfig.screenWidth,
                                decoration: const BoxDecoration(
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
                                                  referralLeaderBoard![i]
                                                          .username!
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
                                          showPoints
                                              ? getPoints(referralLeaderBoard![
                                                              i]
                                                          .score!)
                                                      .toString() ??
                                                  "00"
                                              : referralLeaderBoard![i]
                                                      .refCount
                                                      .toString() ??
                                                  "00",
                                          style: TextStyles.sourceSans.body2
                                              .colour(Colors.white),
                                        )
                                      ],
                                    ),
                                    SizedBox(
                                      height: SizeConfig.padding14,
                                    ),
                                    if (i + 1 < referralLeaderBoard!.length)
                                      const Divider(
                                        color: Colors.white,
                                        thickness: 0.2,
                                      ),
                                    SizedBox(
                                      height: SizeConfig.padding14,
                                    ),
                                  ],
                                ),
                              );
                            },
                          )
                        : List.generate(
                            winners!.length,
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
                                                  winners![i]
                                                          .username!
                                                          .replaceAll(
                                                              '@', '.') ??
                                                      "username",
                                                  style: TextStyles
                                                      .sourceSans.body2
                                                      .colour(Colors.white)),
                                              Text(
                                                getGameName(
                                                    winners![i].gameType),
                                                style: TextStyles.body4.colour(
                                                    UiConstants.kTextColor2),
                                              ),
                                              SizedBox(
                                                  height: SizeConfig.padding4),
                                            ],
                                          ),
                                        ),
                                        Text(
                                          "₹ ${winners![i].amount!.toInt() ?? "00"}",
                                          style: TextStyles.sourceSans.body2
                                              .colour(Colors.white),
                                        )
                                      ],
                                    ),
                                  ),
                                  if (i + 1 < winners!.length)
                                    const Divider(
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
