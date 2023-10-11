import 'package:felloapp/core/enums/app_config_keys.dart';
import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/core/model/app_config_model.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/ui/elements/appbar/appbar.dart';
import 'package:felloapp/ui/elements/video_player/app_video_player.dart';
import 'package:felloapp/ui/pages/power_play/shared_widgets/power_play_bg.dart';
import 'package:felloapp/util/preference_helper.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PowerPlayWelcomePage extends StatelessWidget {
  const PowerPlayWelcomePage({
    super.key,
  });

  String get videoUrl => AppConfig.getValue<Map<String, dynamic>>(
          AppConfigKey.powerplayConfig)['howScreen']['predictionCondition']
      ['explainerUrl'];

  @override
  Widget build(BuildContext context) {
    return PowerPlayBackgroundUi(
      child: Stack(
        children: [
          Column(
            children: [
              SizedBox(
                  height: SizeConfig.viewInsets.top + SizeConfig.padding20),
              Expanded(
                child: ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.symmetric(
                      vertical: 0,
                      horizontal: SizeConfig.pageHorizontalMargins),
                  children: [
                    Center(
                      child: Text(
                        "Welcome to",
                        style: TextStyles.rajdhaniB.title4.colour(Colors.white),
                      ),
                    ),
                    Center(
                      child: SvgPicture.network(
                        'https://d37gtxigg82zaw.cloudfront.net/powerplay/logo-lg.svg',
                        width: SizeConfig.screenWidth! * 0.7,
                      ),
                    ),
                    SizedBox(
                      height: SizeConfig.padding16,
                    ),
                    Container(
                      height: SizeConfig.screenHeight! * 0.4,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: AppVideoPlayer(videoUrl),
                    ),
                    SizedBox(
                      height: SizeConfig.padding16,
                    ),
                    Center(
                      child: Text(
                        "How it Works?",
                        style: TextStyles.sourceSans.body0.colour(Colors.white),
                      ),
                    ),
                    SizedBox(
                      height: SizeConfig.padding16,
                    ),
                    Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('1',
                                style: TextStyles.sourceSans.title4
                                    .colour(Colors.white)),
                            SizedBox(
                              width: SizeConfig.padding10,
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  //Predict the Chasing Score in every IPL Match
                                  Text(
                                    "Predict the Chasing Score and winning score in every match",
                                    style: TextStyles.sourceSans.body3
                                        .colour(Colors.white),
                                  ),
                                  //CSK will chase 172 in the match against RCB
                                  Text(
                                    "India will chase 392 (chasing score) in the match and Australia might score 395 (winning score)",
                                    style: TextStyles.sourceSans.body4
                                        .colour(Colors.white.withOpacity(0.5)),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: SizeConfig.padding20,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('2',
                                style: TextStyles.sourceSans.title4
                                    .colour(Colors.white)),
                            SizedBox(
                              width: SizeConfig.padding10,
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  //Predict the Chasing Score in every IPL Match
                                  Text(
                                    "Invest that amount in Fello Flo or Digital Gold",
                                    style: TextStyles.sourceSans.body3
                                        .colour(Colors.white),
                                  ),
                                  //CSK will chase 172 in the match against RCB
                                  Text(
                                    "You invest ₹392 and ₹395 in Gold/Flo",
                                    style: TextStyles.sourceSans.body4
                                        .colour(Colors.white.withOpacity(0.5)),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: SizeConfig.padding20,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('3',
                                style: TextStyles.sourceSans.title4
                                    .colour(Colors.white)),
                            SizedBox(
                              width: SizeConfig.padding10,
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  //Predict the Chasing Score in every IPL Match
                                  Text(
                                    "Win Digital Gold and other exciting rewards",
                                    style: TextStyles.sourceSans.body3
                                        .colour(Colors.white),
                                  ),
                                  //CSK will chase 172 in the match against RCB
                                  Text(
                                    "Make as many predictions as you want until the second last over!",
                                    style: TextStyles.sourceSans.body4
                                        .colour(Colors.white.withOpacity(0.5)),
                                  ),
                                ],
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                    SizedBox(
                      height: SizeConfig.padding20,
                    ),
                    SizedBox(
                      height: SizeConfig.navBarHeight * 2,
                    )
                  ],
                ),
              ),
            ],
          ),
          Align(
            alignment: Alignment.topCenter,
            child: SizedBox(
              height: SizeConfig.fToolBarHeight,
              child: const FAppBar(
                showAvatar: false,
                showCoinBar: false,
                showHelpButton: false,
                showLeading: false,
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.all(SizeConfig.pageHorizontalMargins),
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                GestureDetector(
                  onTap: () {
                    AppState.backButtonDispatcher?.didPopRoute();

                    AppState.delegate!.appState.currentAction = PageAction(
                      state: PageState.addPage,
                      page: PowerPlayHowItWorksConfig,
                    );
                  },
                  child: Center(
                    child: Text('KNOW MORE',
                        style: TextStyles.rajdhaniB.body1
                            .colour(Colors.white)
                            .copyWith(decoration: TextDecoration.underline)),
                  ),
                ),
                SizedBox(
                  height: SizeConfig.padding8,
                ),
                MaterialButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5)),
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  color: Colors.white,
                  onPressed: () {
                    PreferenceHelper.setBool(
                        PreferenceHelper.POWERPLAY_IS_PLAYED, true);

                    AppState.delegate!.appState.currentAction = PageAction(
                        state: PageState.replace, page: PowerPlayHomeConfig);
                  },
                  child: Center(
                    child: Text(
                      'START PREDICTING NOW',
                      style: TextStyles.rajdhaniB.body1.colour(Colors.black),
                    ),
                  ),
                ),
              ]),
            ),
          )
        ],
      ),
    );
  }
}

class IplReward extends StatelessWidget {
  const IplReward({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: SizeConfig.padding12, vertical: SizeConfig.padding16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(SizeConfig.roundness12),
        boxShadow: [
          BoxShadow(
            color: Colors.transparent.withOpacity(0.1),
            spreadRadius: -6.0,
            blurRadius: 6.0,
          )
        ],
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          tileMode: TileMode.mirror,
          end: Alignment.centerRight,
          stops: const [0.5, 0.5],
          colors: [
            const Color(0xff000000).withOpacity(0.2),
            // Colors.transparent,
            const Color(0xff000000).withOpacity(0.4),
          ],
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          SizedBox(
              width: SizeConfig.screenWidth! * 0.36,
              child: Column(
                children: [
                  SvgPicture.asset(
                    'assets/svg/helmet.svg',
                    height: 50,
                  ),
                  //Chasing Score in an IPL Match
                  Text(
                    "Chasing Score in an IPL Match",
                    textAlign: TextAlign.center,
                    style: TextStyles.sourceSansSB.body3.colour(Colors.white),
                  ),
                ],
              )),
          Text('=', style: TextStyles.sourceSansB.title1),
          SizedBox(
              width: SizeConfig.screenWidth! * 0.36,
              child: Column(
                children: [
                  SvgPicture.asset(
                    'assets/svg/digital_gold.svg',
                    height: 50,
                  ),
                  //Chasing Score in an IPL Match
                  Text(
                    "Save in Gold or Flo & get rewards",
                    textAlign: TextAlign.center,
                    style: TextStyles.sourceSansSB.body3.colour(Colors.white),
                  ),
                ],
              ))
        ],
      ),
    );
  }
}
