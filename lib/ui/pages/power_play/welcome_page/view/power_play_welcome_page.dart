import 'package:felloapp/base_util.dart';
import 'package:felloapp/ui/pages/power_play/leaderboard/view/prediction_leaderboard.dart';
import 'package:felloapp/ui/pages/power_play/widgets/power_play_bg.dart';
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
                const SizedBox(
                  height: 60,
                ),

                Center(
                  child: SvgPicture.network(
                    'https://d37gtxigg82zaw.cloudfront.net/powerplay/logo-lg.svg',
                    height: 95,
                  ),
                ),
                Center(
                  child: Text(
                    "Predict | Save | Win",
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

                const SizedBox(
                  height: 10,
                ),
                //Predict the Chasing Score in IPL matches & Save
                Center(
                  child: Text(
                    "Predict the Chasing Score in IPL matches & Save",
                    style: TextStyles.rajdhani.body3.colour(Colors.white),
                  ),
                ),
                SizedBox(
                  height: SizeConfig.padding10,
                ),
                const IplReward(),
                SizedBox(
                  height: SizeConfig.padding20,
                ),
                //KNOW MORE
                Center(
                  child: Text('KNOW MORE',
                      style: TextStyles.rajdhaniB.body1
                          .colour(Colors.white)
                          .copyWith(decoration: TextDecoration.underline)),
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
                        content: const MakePredictionSheet());
                  },
                  child: Center(
                    child: Text(
                      'PREDICT NOW',
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
            top: 90,
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
            Color(0xff000000).withOpacity(0.2),
            // Colors.transparent,
            Color(0xff000000).withOpacity(0.4),
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
