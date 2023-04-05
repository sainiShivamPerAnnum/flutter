import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/core/service/power_play_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/ui/pages/power_play/completed_match_details/completed_match_details_view.dart';
import 'package:felloapp/ui/pages/power_play/leaderboard/prediction_leaderboard_view.dart';
import 'package:felloapp/ui/pages/power_play/power_play_home/power_play_vm.dart';
import 'package:felloapp/ui/pages/power_play/shared_widgets/ipl_teams_score_widget.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LiveMatch extends StatelessWidget {
  const LiveMatch({
    super.key,
    required this.model,
  });

  final PowerPlayHomeViewModel model;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height / 2,
      child: Column(
        children: [
          Container(
            // height: 100,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: const Color(0xff3B4E6E).withOpacity(0.8),
            ),
            child: Column(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 22, vertical: 8),
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(5),
                          topRight: Radius.circular(5)),
                      color: Color(0xff273C60)),
                  child: Row(
                    children: [
                      Text(
                        model!.liveMatchData?[0]!.matchTitle ?? 'IPL MATCH',
                        style:
                            TextStyles.sourceSansB.body2.colour(Colors.white),
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: () {
                          AppState.delegate!.appState.currentAction =
                              PageAction(
                                  widget: PredictionLeaderboard(
                                    matchData: model.liveMatchData![0]!,
                                  ),
                                  page: PowerPlayLeaderBoardConfig,
                                  state: PageState.addWidget);
                        },
                        child: Row(
                          children: [
                            Text(
                              'PREDICTION LEADERBOARD',
                              style: TextStyles.sourceSans
                                  .colour(Colors.white.withOpacity(0.7))
                                  .copyWith(
                                      fontSize:
                                          SizeConfig.screenWidth! * 0.030),
                            ),
                            const Icon(
                              Icons.arrow_forward_ios,
                              size: 10,
                              color: Colors.white,
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: SizeConfig.padding16,
                ),
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: SizeConfig.padding16),
                  child: IplTeamsScoreWidget(
                    matchData: model.liveMatchData![0]!,
                    padding: const EdgeInsets.symmetric(horizontal: 17),
                  ),
                ),
                SizedBox(
                  height: SizeConfig.padding28,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset('assets/svg/bell_icon.svg'),
                    Text(
                      model.liveMatchData![0]!.headsUpText ?? '',
                      style: TextStyles.sourceSans
                          .copyWith(fontSize: SizeConfig.screenWidth! * 0.030),
                    ),
                  ],
                ),
                SizedBox(height: SizeConfig.padding16),
                if (model.liveMatchData?[0]!.status == MatchStatus.active.name)
                  Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 22,
                    ),
                    child: MaterialButton(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      color: Colors.white,
                      onPressed: () {
                        BaseUtil.openModalBottomSheet(
                            isBarrierDismissible: true,
                            addToScreenStack: true,
                            backgroundColor: const Color(0xff21284A),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(SizeConfig.roundness32),
                              topRight: Radius.circular(SizeConfig.roundness32),
                            ),
                            isScrollControlled: true,
                            hapticVibrate: true,
                            content: MakePredictionSheet(
                              matchData: model.liveMatchData![0]!,
                            ));
                      },
                      child: Center(
                        child: Text(
                          'PREDICT NOW',
                          style:
                              TextStyles.rajdhaniB.body1.colour(Colors.black),
                        ),
                      ),
                    ),
                  ),
                SizedBox(
                  height: SizeConfig.padding16,
                ),
              ],
            ),
          ),
          SizedBox(height: SizeConfig.padding16),
          UserPredictionsButton(
            model: model,
            margin: false,
          ),
        ],
      ),
    );
  }
}
