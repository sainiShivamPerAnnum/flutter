import 'package:felloapp/core/enums/app_config_keys.dart';
import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/core/model/app_config_model.dart';
import 'package:felloapp/core/model/power_play_models/get_matches_model.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/ui/elements/appbar/appbar.dart';
import 'package:felloapp/ui/pages/power_play/shared_widgets/ipl_teams_score_widget.dart';
import 'package:felloapp/ui/pages/power_play/shared_widgets/power_play_bg.dart';
import 'package:felloapp/util/extensions/rich_text_extension.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HowItWorks extends StatelessWidget {
  const HowItWorks({Key? key}) : super(key: key);

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

  String get calloutText => AppConfig.getValue<Map<String, dynamic>>(
          AppConfigKey.powerplayConfig)['howScreen']['predictionCondition']
      ['calloutText'];

  String get calloutIconUrl => AppConfig.getValue<Map<String, dynamic>>(
          AppConfigKey.powerplayConfig)['howScreen']['predictionCondition']
      ['calloutIconUrl'];

  String get calloutSubText => AppConfig.getValue<Map<String, dynamic>>(
          AppConfigKey.powerplayConfig)['howScreen']['predictionCondition']
      ['subText'];

  @override
  Widget build(BuildContext context) {
    return PowerPlayBackgroundUi(
      child: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                const FAppBar(
                  showAvatar: false,
                  showCoinBar: false,
                  showHelpButton: false,
                  backgroundColor: Colors.transparent,
                  title: 'How it works?',
                  centerTitle: true,
                ),
                Expanded(
                  child: ListView(
                    padding: EdgeInsets.symmetric(
                        horizontal: SizeConfig.pageHorizontalMargins,
                        vertical: SizeConfig.padding16),
                    children: [
                      Center(
                        child: Text(
                          'What do I need to Predict?',
                          style: TextStyles.sourceSansSB.title5
                              .colour(Colors.white),
                        ),
                      ),
                      SizedBox(
                        height: SizeConfig.padding12,
                      ),

                      Flexible(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: Text(
                            'Predict how much is the Chasing Score in a match and save the amount in Gold or Flo',
                            style: TextStyles.sourceSans.body3
                                .colour(Colors.white.withOpacity(0.5)),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 10),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Colors.black.withOpacity(0.3),
                        ),
                        child: Expanded(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Predict 152 Runs  =   ',
                                style: TextStyles.sourceSans.body3,
                              ),
                              Container(
                                // margin: const EdgeInsets.symmetric(horizontal: 10),
                                padding: EdgeInsets.symmetric(
                                    horizontal: SizeConfig.padding6,
                                    vertical: SizeConfig.padding2),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(3),
                                  color: const Color(0xff62E3C4),
                                ),
                                child: Text(
                                  '₹',
                                  style: TextStyles.sourceSans.body3
                                      .colour(Colors.black),
                                ),
                              ),
                              Text(
                                '  Save ₹152 in Gold or Flo',
                                style: TextStyles.sourceSans.body3,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      // create a line
                      Container(
                        height: 1,
                        color: Colors.white.withOpacity(0.5),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      //What is a Chasing Score?
                      Center(
                        child: Text(
                          'What is a Chasing Score?',
                          style: TextStyles.sourceSansSB.title5
                              .colour(Colors.white),
                        ),
                      ),
                      const SizedBox(
                        height: 12,
                      ),

                      Container(
                        // height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.black.withOpacity(0.3),
                        ),
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 20,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 17),
                              child: IplTeamsScoreWidget(
                                matchData: MatchData(),
                              ),
                            ),
                            const SizedBox(
                              height: 19,
                            ),
                            Center(
                              child: Text(
                                'After 1st Innings',
                                style: TextStyles.sourceSansSB.body4,
                              ),
                            ),
                            const SizedBox(
                              height: 2,
                            ),
                            Center(
                              child: Text(
                                'Chasing Score to Predict is 140',
                                style: TextStyles.sourceSansSB.body4,
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(
                        height: 12,
                      ),
                      Flexible(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: Text(
                            'The score being chased by the playing team in the 2nd innings.',
                            style: TextStyles.sourceSans.body3
                                .colour(Colors.white.withOpacity(0.5)),
                            textAlign: TextAlign.center,
                          ),
                        ),
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
                      //When can I predict?
                      Center(
                        child: Text(
                          'When can I predict?',
                          style: TextStyles.sourceSansSB.title5
                              .colour(Colors.white),
                        ),
                      ),

                      SizedBox(
                        height: SizeConfig.padding16,
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 10),
                        padding: EdgeInsets.symmetric(
                            horizontal: SizeConfig.padding12,
                            vertical: SizeConfig.padding12),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: const Color(0xff201D31).withOpacity(0.7),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.network(
                              calloutIconUrl,
                              height: 25,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(
                              calloutText,
                              style: TextStyles.sourceSans.body4,
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(
                        height: 8,
                      ),
                      Flexible(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: Text(
                            calloutSubText,
                            style: TextStyles.sourceSans.body3
                                .colour(Colors.white.withOpacity(0.5)),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Container(
                        height: 1,
                        color: Colors.white.withOpacity(0.5),
                      ),
                      //What do I get?
                      const SizedBox(
                        height: 20,
                      ),
                      Center(
                        child: Text(
                          'What do I get?',
                          style: TextStyles.sourceSansSB.title5
                              .colour(Colors.white),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                            vertical: SizeConfig.padding12, horizontal: 17),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: const Color(0xff000000).withOpacity(0.3),
                        ),
                        child: Column(
                          children: [
                            Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  //First 10 to Predict correctly
                                  Flexible(
                                    child: Text(
                                      getRank1,
                                      style: TextStyles.sourceSans.body4,
                                    ),
                                  ),

                                  Flexible(
                                    child: Text(
                                      rewardDesc1,
                                      style: TextStyles.sourceSans.body4,
                                        textAlign: TextAlign.end),
                                  ),
                                ]),
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  //First 10 to Predict correctly
                                  Flexible(
                                    child: Text(getRank2,
                                        style: TextStyles.sourceSans.body4,
                                        textAlign: TextAlign.end),
                                  ),

                                  Flexible(
                                    child: Text(
                                      rewardDesc2,
                                      style: TextStyles.sourceSans.body4,
                                        textAlign: TextAlign.end),
                                  ),
                                ]),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Row(
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
                                style: TextStyles.sourceSans.body3
                                    .colour(Colors.white.withOpacity(0.7)),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: SizeConfig.navBarHeight,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                margin: EdgeInsets.all(SizeConfig.pageHorizontalMargins),
                width: SizeConfig.screenWidth,
                child: MaterialButton(
                  onPressed: () {
                    while (AppState.screenStack.length > 2) {
                      AppState.backButtonDispatcher!.didPopRoute();
                    }
                    AppState.delegate!.appState.currentAction = PageAction(
                      state: PageState.replace,
                      page: PowerPlayHomeConfig,
                    );
                  },
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5)),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    child: Text(
                      'Predict Now'.toUpperCase(),
                      style: TextStyles.rajdhaniB.body1.colour(Colors.black),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
