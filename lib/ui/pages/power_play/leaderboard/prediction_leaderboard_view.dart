import 'dart:io';

import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/enums/app_config_keys.dart';
import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/core/enums/view_state_enum.dart';
import 'package:felloapp/core/model/app_config_model.dart';
import 'package:felloapp/core/model/power_play_models/get_matches_model.dart';
import 'package:felloapp/core/service/power_play_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/ui/architecture/base_view.dart';
import 'package:felloapp/ui/elements/appbar/appbar.dart';
import 'package:felloapp/ui/pages/power_play/leaderboard/view_model/leaderboard_view_model.dart';
import 'package:felloapp/ui/pages/power_play/leaderboard/widgets/your_prediction_sheet.dart';
import 'package:felloapp/ui/pages/power_play/shared_widgets/ipl_teams_score_widget.dart';
import 'package:felloapp/ui/pages/power_play/shared_widgets/power_play_bg.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/constants.dart';
import 'package:felloapp/util/haptic.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'widgets/no_prediction_sheet.dart';

class PredictionLeaderboard extends StatelessWidget {
  const PredictionLeaderboard({
    required this.matchData,
    super.key,
  });

  final MatchData matchData;

  Map<String, dynamic> get carouselItem =>
      AppConfig.getValue<Map<String, dynamic>>(
          AppConfigKey.powerplayConfig)['predictScreen']['cardCarousel'][1];

  @override
  Widget build(BuildContext context) {
    return BaseView<LeaderBoardViewModel>(
      onModelReady: (model) {
        model.getUserPredictedData();
        model.powerPlayService.getUserTransactionHistory(matchData: matchData);
      },
      builder: (context, model, child) {
        return PowerPlayBackgroundUi(
          child: Stack(
            children: [
              Column(
                children: [
                  FAppBar(
                    showAvatar: false,
                    showCoinBar: false,
                    showHelpButton: false,
                    backgroundColor: Colors.transparent,
                    action: Row(
                      children: [
                        InkWell(
                          onTap: () {
                            locator<PowerPlayService>()
                                .referFriend("Prediction leaderboard view");
                          },
                          child: Container(
                              key: const ValueKey(Constants.HELP_FAB),
                              padding: EdgeInsets.symmetric(
                                  horizontal: SizeConfig.padding12,
                                  vertical: SizeConfig.padding6),
                              height: SizeConfig.avatarRadius * 2,
                              decoration: BoxDecoration(
                                color: UiConstants.kTextFieldColor
                                    .withOpacity(0.4),
                                border: Border.all(color: Colors.white10),
                                borderRadius: BorderRadius.circular(
                                    SizeConfig.roundness12),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                // mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Invite Friends',
                                    style: TextStyles.body4
                                        .colour(UiConstants.kTextColor),
                                  ),
                                ],
                              )),
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    child: RefreshIndicator(
                      onRefresh: () async {
                        await model.getUserPredictedData();
                        await model.powerPlayService
                            .getUserTransactionHistory(matchData: matchData);
                      },
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: SizeConfig.pageHorizontalMargins),
                          child: Column(
                            children: [
                              Text(
                                matchData.matchTitle ?? 'IPL MATCH',
                                style: TextStyles.sourceSansB.body2
                                    .colour(Colors.white),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 25),
                                child: IplTeamsScoreWidget(
                                  matchData: matchData,
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SvgPicture.asset('assets/svg/bell_icon.svg'),
                                  Flexible(
                                    child: FittedBox(
                                      fit: BoxFit.scaleDown,
                                      child: Text(
                                        matchData.headsUpText ?? '',
                                        style: TextStyles.sourceSans.body3
                                            .colour(Colors.white),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Container(
                                height: 1,
                                color: Colors.white.withOpacity(0.5),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: SizeConfig.padding16,
                                    vertical: SizeConfig.padding14),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color:
                                      const Color(0xff000000).withOpacity(0.3),
                                ),
                                child: Column(
                                  children: [
                                    //Prediction Leaderboard
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        SvgPicture.asset(
                                          Assets.graph,
                                          width: SizeConfig.padding20,
                                        ),
                                        SizedBox(width: SizeConfig.padding4),
                                        Text(
                                          "Popular Predictions",
                                          style: TextStyles.sourceSans.body1
                                              .colour(Colors.white),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          '#',
                                          style: TextStyles.sourceSans.body3
                                              .colour(const Color(0xffB59D9F)),
                                        ),
                                        const SizedBox(
                                          width: 20,
                                        ),
                                        Text(
                                          'Users',
                                          style: TextStyles.sourceSans.body3
                                              .colour(const Color(0xffB59D9F)),
                                        ),
                                        const Spacer(),
                                        Text(
                                          'Runs Predicted',
                                          style: TextStyles.sourceSans.body3
                                              .colour(const Color(0xffB59D9F)),
                                        ),
                                      ],
                                    ),

                                    _UsersPrediction(
                                      model: model,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              StatefulBuilder(
                                builder: (context, hook) => GestureDetector(
                                  onTap: () {
                                    // To update the label after making
                                    // prediction.
                                    hook(() {});

                                    BaseUtil.openModalBottomSheet(
                                        isBarrierDismissible: true,
                                        addToScreenStack: true,
                                        enableDrag: Platform.isIOS,
                                        backgroundColor:
                                            UiConstants.kGoldProBgColor,
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(
                                              SizeConfig.roundness32),
                                          topRight: Radius.circular(
                                              SizeConfig.roundness32),
                                        ),
                                        isScrollControlled: true,
                                        hapticVibrate: true,
                                        content: (model.powerPlayService
                                                        .transactions?.length ??
                                                    0) >
                                                0
                                            ? YourPredictionSheet(
                                                transactions: model
                                                    .powerPlayService
                                                    .transactions,
                                                matchData: matchData,
                                              )
                                            : NoPredictionSheet(
                                                matchData: matchData,
                                              ));
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: SizeConfig.padding16,
                                        vertical: SizeConfig.padding16),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: const Color(0xff000000)
                                          .withOpacity(0.3),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Your Predictions (${model.powerPlayService.transactions?.length})",
                                          style: TextStyles.sourceSans.body3
                                              .colour(Colors.white),
                                        ),
                                        // const Spacer(),
                                        Icon(
                                          Icons.arrow_forward_ios,
                                          color: const Color(0xffB59D9F),
                                          size: SizeConfig.padding16,
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              GestureDetector(
                                onTap: () {
                                  Haptic.vibrate();
                                  final url = carouselItem['onTapLink'];

                                  if (url != null) {
                                    AppState.delegate!.parseRoute(
                                      Uri.parse(
                                        url,
                                      ),
                                    );
                                  }
                                },
                                child: SizedBox(
                                  width: SizeConfig.screenWidth,
                                  height: SizeConfig.screenWidth! * 0.35,
                                  child: SvgPicture.network(
                                    carouselItem['imgUrl'],
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),

                              SizedBox(
                                height: SizeConfig.padding20,
                              ),
                              // WHAT IS A PREDICTION?
                              GestureDetector(
                                onTap: () {
                                  AppState.delegate!.appState.currentAction =
                                      PageAction(
                                          state: PageState.addPage,
                                          page: PowerPlayHowItWorksConfig);
                                },
                                child: Text(
                                  "WHAT IS A PREDICTION?",
                                  style: TextStyles.rajdhaniB.body1
                                      .colour(Colors.white)
                                      .copyWith(
                                          decoration: TextDecoration.underline),
                                ),
                              ),
                              SizedBox(
                                height: SizeConfig.navBarHeight * 2,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: SizeConfig.navBarHeight * 0.8,
                  margin: EdgeInsets.all(SizeConfig.pageHorizontalMargins),
                  width: SizeConfig.screenWidth,
                  child: MaterialButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5)),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    color: Colors.white,
                    onPressed: model.predict,
                    child: model.isPredictionInProgress
                        ? SizedBox(
                            height: SizeConfig.padding20,
                            width: SizeConfig.padding20,
                            child: const CircularProgressIndicator(
                              strokeWidth: 1,
                              color: Colors.black,
                            ),
                          )
                        : Center(
                            child: Text(
                              'PREDICT NOW',
                              style: TextStyles.rajdhaniB.body1
                                  .colour(Colors.black),
                            ),
                          ),
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}

class _UsersPrediction extends StatelessWidget {
  const _UsersPrediction({
    required this.model,
  });

  final LeaderBoardViewModel model;

  String getTitle(int index) {
    return model.userPredictedData[index].count == 1
        ? 'User Prediction'
        : 'Users Predictions';
  }

  @override
  Widget build(BuildContext context) {
    if (model.state.isBusy) {
      return const Center(child: CircularProgressIndicator());
    }

    if (model.userPredictedData.isEmpty) {
      return Padding(
        padding: const EdgeInsets.only(top: 16),
        child: Text(
          'No predictions done yet',
          style: TextStyles.sourceSans.body3.colour(const Color(0xffB59D9F)),
        ),
      );
    }

    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      itemCount: model.userPredictedData.length,
      separatorBuilder: (context, index) {
        return Container(
          height: 0.5,
          color: Colors.white.withOpacity(0.3),
        );
      },
      itemBuilder: (context, index) {
        final data = model.userPredictedData[index];
        return Column(
          children: [
            SizedBox(
              height: SizeConfig.padding16,
            ),
            Row(
              children: [
                Text(
                  '${index + 1}',
                  style: TextStyles.sourceSans.body3.colour(Colors.white),
                ),
                const SizedBox(
                  width: 20,
                ),
                Text(
                  '${data.count} ${getTitle(index)}',
                  style: TextStyles.sourceSans.body3.colour(Colors.white),
                ),
                const Spacer(),
                Text(
                  '${data.amount} runs',
                  style: TextStyles.sourceSans.body3.colour(Colors.white),
                ),
                const SizedBox(
                  width: 10,
                ),
              ],
            ),
            SizedBox(
              height: SizeConfig.padding16,
            ),
          ],
        );
      },
    );
  }
}
