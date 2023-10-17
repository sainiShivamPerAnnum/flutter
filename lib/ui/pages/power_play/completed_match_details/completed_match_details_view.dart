import 'dart:io';

import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/model/power_play_models/get_matches_model.dart';
import 'package:felloapp/core/model/power_play_models/match_winners_leaderboard_item_model.dart';
import 'package:felloapp/core/service/power_play_service.dart';
import 'package:felloapp/ui/architecture/base_view.dart';
import 'package:felloapp/ui/elements/appbar/appbar.dart';
import 'package:felloapp/ui/pages/power_play/completed_match_details/completed_match_details_vm.dart';
import 'package:felloapp/ui/pages/power_play/shared_widgets/power_play_bg.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

import '../leaderboard/widgets/your_prediction_sheet.dart';
import '../shared_widgets/ipl_teams_score_widget.dart';

class CompletedMatchDetailsView extends StatelessWidget {
  const CompletedMatchDetailsView({
    required this.matchData,
    super.key,
  });

  final MatchData matchData;

  @override
  Widget build(BuildContext context) {
    return BaseView<CompletedMatchDetailsVM>(
        onModelReady: (model) {
          model.init(matchData);
        },
        onModelDispose: (model) {},
        builder: (ctx, model, child) {
          return PowerPlayBackgroundUi(
            child: Stack(
              children: [
                SizedBox(
                  width: SizeConfig.screenWidth,
                  // height: SizeConfig.screenHeight,
                  child: Column(
                    children: [
                      SizedBox(
                          height:
                              SizeConfig.viewInsets.top + kToolbarHeight / 2),
                      Expanded(
                        child: SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          child: Column(
                            children: [
                              // SvgPicture.network(
                              //   Assets.powerPlayMain,
                              //   height: SizeConfig.screenWidth! * 0.2,
                              // ),
                              // const PowerPlayTotalWinWidget(),
                              matchData.matchStats!.didWon
                                  ? WinTextWidget(model: model)
                                  : LossOrNoParticipateTextWidget(
                                      isLoss: matchData.matchStats!.count > 0 &&
                                          !matchData.matchStats!.didWon),
                              const CustomDivider(),
                              SizedBox(height: SizeConfig.padding12),
                              MatchBriefDetailsWidget(matchData: matchData),
                              UserPredictionsButton(model: model),
                              CorrectPredictorsListView(model: model),
                              SizedBox(height: SizeConfig.navBarHeight * 1.5)
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.topCenter,
                  child: SizedBox(
                    height: SizeConfig.fToolBarHeight,
                    child: const FAppBar(
                      showAvatar: false,
                      showCoinBar: false,
                    ),
                  ),
                ),
                const Align(
                  alignment: Alignment.bottomCenter,
                  child: FooterCta(location: "Completed match details"),
                )
              ],
            ),
          );
        });
  }
}

class FooterCta extends StatelessWidget {
  const FooterCta({required this.location, super.key});

  final String location;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: SizeConfig.padding80,
      width: SizeConfig.screenWidth,
      padding: EdgeInsets.only(
          left: SizeConfig.pageHorizontalMargins,
          right: SizeConfig.pageHorizontalMargins,
          bottom: SizeConfig.pageHorizontalMargins),
      child: MaterialButton(
        height: SizeConfig.padding32,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        padding: const EdgeInsets.symmetric(vertical: 10),
        color: Colors.white,
        onPressed: () {
          locator<PowerPlayService>().referFriend(location);
        },
        child: Center(
          child: Text(
            'INVITE FRIENDS',
            style: TextStyles.rajdhaniB.body1.colour(Colors.black),
          ),
        ),
      ),
    );
  }
}

class CorrectPredictorsListView extends StatelessWidget {
  const CorrectPredictorsListView({required this.model, super.key});

  final CompletedMatchDetailsVM model;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: SizeConfig.screenWidth,
      margin: EdgeInsets.only(
        top: SizeConfig.pageHorizontalMargins,
        right: SizeConfig.pageHorizontalMargins,
        left: SizeConfig.pageHorizontalMargins,
      ),
      child: Column(children: [
        Text(
          "Correct Predictors of the Match",
          style: TextStyles.sourceSansB.title5,
        ),
        SizedBox(height: SizeConfig.padding16),
        model.isWinnersLoading
            ? SizedBox(
                height: SizeConfig.padding80,
                child: Center(
                  child: SpinKitWave(
                    color: Colors.white,
                    size: SizeConfig.padding34,
                  ),
                ),
              )
            : model.winners.isEmpty
                ? Column(
                    children: [
                      SizedBox(height: SizeConfig.padding54),
                      SvgPicture.asset(
                        Assets.noTransactionAsset,
                        width: SizeConfig.screenWidth! * 0.4,
                      ),
                      SizedBox(height: SizeConfig.padding16),
                      Text(
                        "No winners to show",
                        style: TextStyles.sourceSans.body2.colour(Colors.white),
                      ),
                      SizedBox(height: SizeConfig.padding32),
                    ],
                  )
                : Column(
                    children: [
                      Row(
                        children: [
                          SizedBox(
                            width: SizeConfig.screenWidth! * 0.13,
                            child: Text(
                              "#Rank",
                              style: TextStyles.sourceSans.body3
                                  .colour(Colors.white38),
                            ),
                          ),
                          Text(
                            "Username",
                            style: TextStyles.sourceSans.body3
                                .colour(Colors.white38),
                          ),
                          const Spacer(),
                          Text(
                            "Prediction",
                            style: TextStyles.sourceSans.body3
                                .colour(Colors.white38),
                          ),
                        ],
                      ),
                      SizedBox(height: SizeConfig.padding10),
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        padding: EdgeInsets.zero,
                        itemCount: model.winners.length,
                        itemBuilder: (ctx, i) => Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: SizeConfig.padding10),
                          child: Row(
                            children: [
                              SizedBox(
                                width: SizeConfig.screenWidth! * 0.13,
                                child: Text(
                                  "#${i + 1}",
                                  style: TextStyles.sourceSansSB.body1,
                                ),
                              ),
                              Expanded(
                                  child: Row(
                                children: [
                                  SvgPicture.asset(
                                    "assets/vectors/userAvatars/AV${model.winners[i].avatarId}.svg",
                                    width: SizeConfig.iconSize1 * 1.5,
                                    height: SizeConfig.iconSize1 * 1.5,
                                    fit: BoxFit.cover,
                                  ),
                                  SizedBox(width: SizeConfig.padding10),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          model.winners[i].uname,
                                          style: TextStyles.sourceSans.body3,
                                        ),
                                        SizedBox(height: SizeConfig.padding2),
                                        Text(
                                          getWinningString(model.winners[i]),
                                          style: TextStyles.sourceSans.body4
                                              .colour(Colors.white70),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              )),
                              SizedBox(width: SizeConfig.padding16),
                              Text(
                                "₹${model.winners[i].score} | ${DateFormat('h:mm a').format(
                                  model.winners[i].timestamp.toDate(),
                                )}",
                                style: TextStyles.sourceSans.body3,
                              )
                            ],
                          ),
                        ),
                        separatorBuilder: (ctx, i) => const Divider(
                          color: Colors.white30,
                          thickness: 0.3,
                        ),
                      ),
                    ],
                  )
      ]),
    );
  }

  String getWinningString(MatchWinnersLeaderboardItemModel item) {
    String wText = "won";
    if (item.amt! > 0) {
      wText += " gold worth ₹${item.amt} ";
    }
    if (item.flc! > 0) {
      wText += " | ${item.flc} tokens ";
    }
    if (item.tt! > 0) {
      wText += " | ${item.tt} tickets";
    }
    return wText;
  }
}

class UserPredictionsButton extends StatelessWidget {
  const UserPredictionsButton(
      {required this.model, super.key, this.margin = true});
  final CompletedMatchDetailsVM model;
  final bool margin;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (model.isPredictionsLoading) return;
        BaseUtil.openModalBottomSheet(
          isBarrierDismissible: true,
          addToScreenStack: true,
          enableDrag: Platform.isIOS,
          backgroundColor: UiConstants.kGoldProBgColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(SizeConfig.roundness32),
            topRight: Radius.circular(SizeConfig.roundness32),
          ),
          isScrollControlled: true,
          hapticVibrate: true,
          content: YourPredictionSheet(
            transactions: model.predictions,
            matchData: model.matchData!,
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.5),
          borderRadius: BorderRadius.circular(SizeConfig.roundness8),
        ),
        padding: EdgeInsets.only(
          left: SizeConfig.pageHorizontalMargins,
          right: SizeConfig.padding12,
          top: SizeConfig.padding12,
          bottom: SizeConfig.padding12,
        ),
        margin: EdgeInsets.symmetric(
            horizontal: margin ? SizeConfig.pageHorizontalMargins : 0),
        child: Row(
          children: [
            Text("Your Predictions", style: TextStyles.sourceSans.body2),
            SizedBox(width: SizeConfig.padding6),
            model.isPredictionsLoading
                ? SizedBox(
                    height: SizeConfig.padding16,
                    width: SizeConfig.padding16,
                    child: SpinKitWave(
                      color: Colors.white,
                      size: SizeConfig.padding16,
                    ),
                  )
                : Text("(${model.predictions?.length ?? 0})",
                    style: TextStyles.sourceSans.body2),
            const Spacer(),
            const Icon(
              Icons.navigate_next_rounded,
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}

class CustomDivider extends StatelessWidget {
  const CustomDivider({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Divider(
      color: Colors.white70,
      thickness: 0.3,
      height: SizeConfig.pageHorizontalMargins,
      indent: SizeConfig.pageHorizontalMargins,
      endIndent: SizeConfig.pageHorizontalMargins,
    );
  }
}

class WinTextWidget extends StatelessWidget {
  WinTextWidget({
    required this.model,
    super.key,
  });

  CompletedMatchDetailsVM model;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(
        SizeConfig.pageHorizontalMargins,
      ),
      child: Column(
        children: [
          Text(
            "CONGRATULATIONS",
            style: TextStyles.sourceSansB.title4.letterSpace(1).copyWith(
              shadows: [
                BoxShadow(
                  color: const Color(0xffF79780),
                  offset: Offset(
                    0,
                    SizeConfig.padding4,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: SizeConfig.padding16),
          Text(
            model.winString,
            textAlign: TextAlign.center,
            style:
                TextStyles.sourceSansB.title5.colour(UiConstants.primaryColor),
          )
        ],
      ),
    );
  }
}

class LossOrNoParticipateTextWidget extends StatelessWidget {
  const LossOrNoParticipateTextWidget({super.key, this.isLoss = true});

  final bool isLoss;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(
        SizeConfig.pageHorizontalMargins,
      ),
      child: Column(
        children: [
          SvgPicture.asset(Assets.uhoh, height: SizeConfig.padding80),
          SizedBox(height: SizeConfig.padding16),
          Text(
            isLoss
                ? "Your Prediction for today wasn’t right :("
                : "You did not predict in this match",
            textAlign: TextAlign.center,
            style: TextStyles.sourceSansB.body2,
          ),
          Text(
            isLoss
                ? "Try Again in the next match!"
                : "Make predictions to win rewards!",
            textAlign: TextAlign.center,
            style: TextStyles.sourceSans.body3,
          )
        ],
      ),
    );
  }
}

class PowerPlayTotalWinWidget extends StatelessWidget {
  const PowerPlayTotalWinWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: Colors.black.withOpacity(0.7),
      ),
      child: Text(
        'Total Won From PowerPlay : ₹100',
        style: TextStyles.sourceSansSB.body2,
      ),
    );
  }
}

class MatchBriefDetailsWidget extends StatelessWidget {
  final MatchData matchData;

  const MatchBriefDetailsWidget({required this.matchData, super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          matchData.matchTitle ?? "",
          style: TextStyles.sourceSansB.body2.colour(Colors.white),
        ),
        const SizedBox(
          height: 20,
        ),
        Padding(
          padding: EdgeInsets.symmetric(
              horizontal: SizeConfig.pageHorizontalMargins),
          child: IplTeamsScoreWidget(
            matchData: matchData,
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        Text(
          matchData.verdictText ?? "",
          style: TextStyles.sourceSans.body2.colour(Colors.white),
        ),
        SizedBox(height: SizeConfig.padding4),
        Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Correct Prediction Score: ",
                style: TextStyles.sourceSansSB.body2,
              ),
              Text(
                "${matchData.target}",
                style: TextStyles.sourceSans.body2,
              )
            ],
          ),
        ),
        const SizedBox(
          height: 20,
        ),
      ],
    );
  }
}
