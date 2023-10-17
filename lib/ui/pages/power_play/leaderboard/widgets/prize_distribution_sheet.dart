import 'package:felloapp/core/enums/app_config_keys.dart';
import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/core/model/app_config_model.dart';
import 'package:felloapp/core/model/power_play_models/get_matches_model.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/util/extensions/rich_text_extension.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PrizeDistributionSheet extends StatelessWidget {
  final MatchData? matchData;

  const PrizeDistributionSheet({
    super.key,
    this.matchData,
  });

  String get getRank1 => AppConfig.getValue<Map<String, dynamic>>(
          AppConfigKey.powerplayConfig)['howScreen']['predictionReward'][0]
      ['winnerDesc'];

  String get rewardDesc1 => AppConfig.getValue<Map<String, dynamic>>(
          AppConfigKey.powerplayConfig)['howScreen']['predictionReward'][0]
      ['rewardDesc'];

  String get rewardDesc2 => AppConfig.getValue<Map<String, dynamic>>(
          AppConfigKey.powerplayConfig)['howScreen']['predictionReward'][1]
      ['rewardDesc'];

  String get getRank2 => AppConfig.getValue<Map<String, dynamic>>(
          AppConfigKey.powerplayConfig)['howScreen']['predictionReward'][1]
      ['winnerDesc'];

  String get asideIcon => AppConfig.getValue<Map<String, dynamic>>(
      AppConfigKey.powerplayConfig)['howScreen']['seasonReward']['asideIcon'];

  String get rewardDesc3 => AppConfig.getValue<Map<String, dynamic>>(
      AppConfigKey.powerplayConfig)['howScreen']['seasonReward']['rewardDesc'];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          left: SizeConfig.pageHorizontalMargins,
          right: SizeConfig.pageHorizontalMargins,
          bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: SizeConfig.padding16,
          ),
          Container(
            height: 2,
            width: 100,
            color: Colors.white,
          ),
          SizedBox(
            height: SizeConfig.padding24,
          ),
          Text(
            "Prize Distribution",
            style: TextStyles.sourceSansSB.body1.colour(Colors.white),
          ),
          SizedBox(
            height: SizeConfig.padding16,
          ),
          SvgPicture.asset(
            'assets/svg/prize_dist.svg',
            height: 100,
          ),
          SizedBox(
            height: SizeConfig.padding16,
          ),
          //Correct Predictors of the Match
          Text(
            "Correct Predictors of the Match",
            style: TextStyles.sourceSansSB.body3.colour(Colors.white),
          ),
          const SizedBox(
            height: 7,
          ),
          Container(
            padding: EdgeInsets.symmetric(
                horizontal: SizeConfig.padding16,
                vertical: SizeConfig.padding16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.black.withOpacity(0.3),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    //Rank
                    Text('Rank',
                        style:
                            TextStyles.sourceSans.body4.colour(Colors.white)),
                    //Prize
                    Text('Prize',
                        style:
                            TextStyles.sourceSans.body4.colour(Colors.white)),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  height: 1,
                  color: Colors.white.withOpacity(0.5),
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    //Rank
                    Flexible(
                      child: Text(getRank1,
                          style:
                              TextStyles.sourceSans.body4.colour(Colors.white)),
                    ),
                    // const Spacer(),
                    Flexible(
                      child: Text(
                        rewardDesc1,
                        style: TextStyles.sourceSans.body4.colour(Colors.white),
                        textAlign: TextAlign.end,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  height: 1,
                  color: Colors.white.withOpacity(0.5),
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    //Rank
                    Text(getRank2,
                        style:
                            TextStyles.sourceSans.body4.colour(Colors.white)),

                    Text(rewardDesc2,
                        style:
                            TextStyles.sourceSans.body4.colour(Colors.white)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 40,
          ),
          // Your Prediction
          Text(
            "Season Leaderboard",
            style: TextStyles.sourceSansSB.body3.colour(Colors.white),
          ),
          SizedBox(
            height: SizeConfig.padding12,
          ),

          Container(
            padding: EdgeInsets.symmetric(
                horizontal: SizeConfig.padding16,
                vertical: SizeConfig.padding16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: Colors.black.withOpacity(0.3),
            ),
            child: Row(
              children: [
                SvgPicture.network(
                  asideIcon,
                  height: 25,
                ),
                SizedBox(
                  width: SizeConfig.padding16,
                ),
                //Rank 1 on this leaderboard at the end of the IPL season gets 2 tickets to the Final Match
                Flexible(
                  child: Container(
                    child: rewardDesc3.beautify(
                      style: TextStyles.sourceSans.body4.colour(Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: SizeConfig.padding26,
          ),

          MaterialButton(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
            padding: const EdgeInsets.symmetric(vertical: 10),
            color: Colors.white,
            onPressed: () {
              while (AppState.screenStack.length > 1) {
                AppState.backButtonDispatcher!.didPopRoute();
              }

              AppState.delegate!.appState.currentAction = PageAction(
                state: PageState.addPage,
                page: PowerPlayHomeConfig,
              );
            },
            child: Center(
              child: Text(
                'View Matches'.toUpperCase(),
                style: TextStyles.rajdhaniB.body1.colour(Colors.black),
              ),
            ),
          ),
          SizedBox(
            height: SizeConfig.padding20,
          ),
        ],
      ),
    );
  }
}
