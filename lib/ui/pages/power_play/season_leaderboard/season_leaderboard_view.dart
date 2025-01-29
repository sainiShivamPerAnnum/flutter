import 'dart:math';

import 'package:felloapp/core/enums/app_config_keys.dart';
import 'package:felloapp/core/enums/faqTypes.dart';
import 'package:felloapp/core/model/app_config_model.dart';
import 'package:felloapp/core/model/power_play_models/season_leaderboard_model.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/ui/architecture/base_view.dart';
import 'package:felloapp/ui/elements/appbar/appbar.dart';
import 'package:felloapp/ui/pages/power_play/completed_match_details/completed_match_details_view.dart';
import 'package:felloapp/ui/pages/power_play/season_leaderboard/season_leaderboard_vm.dart';
import 'package:felloapp/ui/pages/power_play/shared_widgets/power_play_bg.dart';
import 'package:felloapp/ui/pages/static/loader_widget.dart';
import 'package:felloapp/ui/service_elements/leaderboards/leaderboard_view/components/user_rank.dart';
import 'package:felloapp/ui/service_elements/leaderboards/leaderboard_view/components/winner_widget.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/extensions/rich_text_extension.dart';
import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SeasonLeaderboard extends StatelessWidget {
  const SeasonLeaderboard({super.key});
  String get asideIcon => AppConfig.getValue<Map<String, dynamic>>(
      AppConfigKey.powerplayConfig)['howScreen']['seasonReward']['asideIcon'];

  String get rewardDesc3 => AppConfig.getValue<Map<String, dynamic>>(
      AppConfigKey.powerplayConfig)['howScreen']['seasonReward']['rewardDesc'];
  @override
  Widget build(BuildContext context) {
    return BaseView<SeasonLeaderboardViewModel>(
      onModelDispose: (model) => model.dump(),
      onModelReady: (model) => model.init(),
      builder: (
        context,
        model,
        child,
      ) {
        return PowerPlayBackgroundUi(
          child: Stack(
            children: [
              SizedBox(
                height: SizeConfig.screenHeight,
                width: SizeConfig.screenWidth,
                child: RefreshIndicator(
                  onRefresh: () async {
                    model.init();
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const FAppBar(
                        showAvatar: false,
                        showCoinBar: false,
                        type: FaqsType.powerPlay,
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              SizedBox(
                                  height: SizeConfig.pageHorizontalMargins),
                              Text("Season Leaderboard",
                                  style: TextStyles.sourceSansB.title2),
                              SizedBox(
                                  height: SizeConfig.pageHorizontalMargins),
                              Container(
                                margin: EdgeInsets.symmetric(
                                    horizontal:
                                        SizeConfig.pageHorizontalMargins),
                                child: Row(
                                  children: [
                                    SvgPicture.network(
                                      asideIcon,
                                      width: SizeConfig.padding80,
                                    ),
                                    SizedBox(width: SizeConfig.padding20),
                                    Expanded(
                                        child: rewardDesc3.beautify(
                                      style: TextStyles.sourceSans.body3
                                          .colour(Colors.white54),
                                    )),
                                  ],
                                ),
                              ),
                              SizedBox(height: SizeConfig.padding20),
                              const Divider(color: Colors.white70, height: 0),
                              NewWebGameLeaderBoardView(model: model),
                              SizedBox(height: SizeConfig.navBarHeight)
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              const Align(
                alignment: Alignment.bottomCenter,
                child: FooterCta(
                  location: "Season leaderboard",
                ),
              )
            ],
          ),
        );
      },
    );
  }
}

class NewWebGameLeaderBoardView extends StatelessWidget {
  final SeasonLeaderboardViewModel model;
  const NewWebGameLeaderBoardView({required this.model, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    S locale = S.of(context);
    return model.isLeaderboardLoading
        ? const FullScreenLoader()
        : ((model.leaderboard ?? []).isNotEmpty)
            ? NewLeaderBoardView(
                scoreBoard: model.leaderboard,
                // userProfilePicUrl: model.userProfilePicUrl,
                currentUserRank: model.currentUserRank,
                isUserInTopThree: model.isUserInTopThree,
              )
            : Padding(
                padding: EdgeInsets.all(SizeConfig.pageHorizontalMargins),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: SizeConfig.screenWidth! * 0.2),
                    SvgPicture.asset(
                      Assets.winScreenHighestScorers,
                      width: SizeConfig.screenWidth! * 0.3,
                    ),
                    Text(
                      "Winners hall of fame will be updated soon",
                      textAlign: TextAlign.center,
                      style: TextStyles.rajdhani.title4.colour(Colors.white),
                    ),
                    SizedBox(height: SizeConfig.screenHeight! * 0.6),
                  ],
                ),
              );
  }
}

class NewLeaderBoardView extends StatelessWidget {
  NewLeaderBoardView({
    required this.scoreBoard, // required this.userProfilePicUrl,
    required this.isUserInTopThree,
    required this.currentUserRank,
    super.key,
  });
  S locale = locator<S>();
  final List<SeasonLeaderboardItemModel>? scoreBoard;
  // final List<String?> userProfilePicUrl;
  final bool isUserInTopThree;
  final int currentUserRank;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: SizeConfig.padding12,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(
          SizeConfig.roundness5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          if (scoreBoard!.length >= 3)
            WinnerWidgets(
              scoreboard: scoreBoard,
              // userProfilePicUrl: userProfilePicUrl,
            ),
          if (scoreBoard!.length < 4)
            SizedBox(height: SizeConfig.pageHorizontalMargins),
          if (scoreBoard!.length != 3)
            Container(
              margin: EdgeInsets.symmetric(horizontal: SizeConfig.padding12),
              child: Row(
                children: [
                  SizedBox(
                    width: SizeConfig.screenWidth! * 0.12,
                    child: Text(
                      "#",
                      style: TextStyles.sourceSans.body3.colour(Colors.white38),
                    ),
                  ),
                  Text(
                    "Username",
                    style: TextStyles.sourceSans.body3.colour(Colors.white38),
                  ),
                  const Spacer(),
                  Text(
                    "Correct Prediction",
                    style: TextStyles.sourceSans.body3.colour(Colors.white38),
                  ),
                ],
              ),
            ),
          if (currentUserRank != -1)
            UserRank(
              currentUserScore: scoreBoard![currentUserRank],
              currentUserRank: currentUserRank + 1,
            ),
          RemainingRank(
            // userProfilePicUrl: userProfilePicUrl,
            scoreboard: scoreBoard,
          ),
        ],
      ),
    );
  }
}

//
class RemainingRank extends StatelessWidget {
  RemainingRank({
    required this.scoreboard,
    Key? key,
  }) : super(key: key);
  final UserService _userService = locator<UserService>();
  final List<SeasonLeaderboardItemModel>? scoreboard;
  @override
  Widget build(BuildContext context) {
    S locale = S.of(context);
    return ListView.separated(
      itemCount:
          scoreboard!.length <= 2 ? scoreboard!.length : scoreboard!.length - 3,
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        int countedIndex = scoreboard!.length <= 2 ? index : index + 3;
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
                      '${countedIndex + 1}',
                      style: TextStyles.rajdhaniSB.body2,
                    ),
                    SizedBox(
                      width: SizeConfig.padding20,
                    ),
                    SvgPicture.asset(
                      getDefaultProfilePicture(countedIndex + 1),
                      width: SizeConfig.iconSize5,
                      height: SizeConfig.iconSize5,
                      fit: BoxFit.cover,
                    ),
                    SizedBox(
                      width: SizeConfig.padding12,
                    ),
                    Expanded(
                      child: Text(
                        _userService
                            .diplayUsername(scoreboard![countedIndex].uName),
                        style: TextStyles.sourceSans.body3.setOpacity(0.8),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    )
                  ],
                ),
              ),
              Text(
                '${scoreboard![countedIndex].value} ',
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

  String getDefaultProfilePicture(int rank) {
    int rand = Random().nextInt(5) + 1;
    switch (rand) {
      case 1:
        return Assets.cvtar1;
      case 2:
        return Assets.cvtar2;
      case 3:
        return Assets.cvtar3;
      case 4:
        return Assets.cvtar4;
      case 5:
        return Assets.cvtar5;
      default:
        return Assets.cvtar2;
    }
  }
}
