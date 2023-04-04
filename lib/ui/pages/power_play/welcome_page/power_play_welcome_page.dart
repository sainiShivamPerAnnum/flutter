import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/ui/elements/appbar/appbar.dart';
import 'package:felloapp/ui/pages/power_play/shared_widgets/power_play_bg.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PowerPlayWelcomePage extends StatelessWidget {
  const PowerPlayWelcomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PowerPlayBackgroundUi(
      child: Stack(
        children: [
          SafeArea(
            child: ListView(
              padding: EdgeInsets.symmetric(
                  horizontal: SizeConfig.pageHorizontalMargins),
              children: [
                const FAppBar(
                  showAvatar: false,
                  showCoinBar: false,
                  showHelpButton: false,
                  showLeading: false,
                ),

                Center(
                  child: SvgPicture.network(
                    'https://d37gtxigg82zaw.cloudfront.net/powerplay/logo-lg.svg',
                    height: 70,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Center(
                  child: Text(
                    "Invest your Predictions",
                    style: TextStyles.rajdhaniSB.body1.colour(Colors.white),
                  ),
                ),

                const SizedBox(
                  height: 20,
                ),
                Container(
                  height: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.black,
                  ),
                ),

                SizedBox(
                  height: SizeConfig.padding28,
                ),

                Center(
                  child: Text(
                    "How it Works?",
                    style: TextStyles.sourceSans.body0.colour(Colors.white),
                  ),
                ),

                SizedBox(
                  height: SizeConfig.padding20,
                ),

                Column(
                  children: [
                    Row(
                      children: [
                        Text('1',
                            style: TextStyles.sourceSans.title4
                                .colour(Colors.white)),
                        SizedBox(
                          width: SizeConfig.padding10,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            //Predict the Chasing Score in every IPL Match
                            Text(
                              "Predict the Chasing Score in every IPL Match",
                              style: TextStyles.sourceSans.body3
                                  .colour(Colors.white),
                            ),
                            //CSK will chase 172 in the match against RCB
                            Text(
                              "CSK will chase 172 in the match against RCB",
                              style: TextStyles.sourceSans.body4
                                  .colour(Colors.white.withOpacity(0.5)),
                            ),
                          ],
                        )
                      ],
                    ),
                    SizedBox(
                      height: SizeConfig.padding20,
                    ),
                    Row(
                      children: [
                        Text('2',
                            style: TextStyles.sourceSans.title4
                                .colour(Colors.white)),
                        SizedBox(
                          width: SizeConfig.padding10,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            //Predict the Chasing Score in every IPL Match
                            Text(
                              "Invest that amount in Fello Flo or Gold",
                              style: TextStyles.sourceSans.body3
                                  .colour(Colors.white),
                            ),
                            //CSK will chase 172 in the match against RCB
                            Text(
                              "You invest ₹172 in Digital Gold",
                              style: TextStyles.sourceSans.body4
                                  .colour(Colors.white.withOpacity(0.5)),
                            ),
                          ],
                        )
                      ],
                    ),
                    SizedBox(
                      height: SizeConfig.padding20,
                    ),
                    Row(
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
                                "Make as many predictions as you want until the 19th over",
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
                // const IplReward(),
                SizedBox(
                  height: SizeConfig.padding40,
                ),

                GestureDetector(
                  onTap: () {
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
                  height: SizeConfig.padding20,
                ),

                MaterialButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5)),
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  color: Colors.white,
                  onPressed: () {
                    AppState.delegate!.appState.currentAction = PageAction(
                        state: PageState.replace, page: PowerPlayHomeConfig);
                    // BaseUtil.openModalBottomSheet(
                    //     isBarrierDismissible: true,
                    //     addToScreenStack: true,
                    //     backgroundColor: const Color(0xff21284A),
                    //     borderRadius: BorderRadius.only(
                    //       topLeft: Radius.circular(SizeConfig.roundness32),
                    //       topRight: Radius.circular(SizeConfig.roundness32),
                    //     ),
                    //     isScrollControlled: true,
                    //     hapticVibrate: true,
                    //     content: MakePredictionSheet(matchData: MatchData()));
                  },
                  child: Center(
                    child: Text(
                      'START PREDICTING NOW',
                      style: TextStyles.rajdhaniB.body1.colour(Colors.black),
                    ),
                  ),
                ),
                SizedBox(
                  height: SizeConfig.padding20,
                ),
              ],
            ),
          ),
          Positioned(
            top: 80,
            left: 50,
            right: 50,
            child: Center(
              child: Text(
                "Welcome to",
                style: TextStyles.rajdhaniB.title4.colour(Colors.white),
              ),
            ),
          ),
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
