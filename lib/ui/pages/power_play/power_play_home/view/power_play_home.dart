import 'package:felloapp/ui/elements/appbar/appbar.dart';
import 'package:felloapp/ui/pages/power_play/leaderboard/view/prediction_leaderboard.dart';
import 'package:felloapp/ui/pages/power_play/power_play_home/view/power_play_matches.dart';
import 'package:felloapp/ui/pages/power_play/widgets/power_play_bg.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PowerPlayHome extends StatefulWidget {
  const PowerPlayHome({Key? key}) : super(key: key);

  @override
  State<PowerPlayHome> createState() => _PowerPlayHomeState();
}

class _PowerPlayHomeState extends State<PowerPlayHome> {
  @override
  Widget build(BuildContext context) {
    return PowerPlayBackgroundUi(
      child: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FAppBar(
                // type: FaqsType.play,
                showAvatar: false,
                showCoinBar: false,
                showHelpButton: false,
                backgroundColor: Colors.transparent,
                action: Row(
                  children: [
                    TextButton(
                      style: TextButton.styleFrom(
                        primary: Colors.white,
                        onSurface: Colors.white,
                        side: BorderSide(
                            color: Colors.white.withOpacity(0.5), width: 0.5),
                        shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(5))),
                      ),
                      onPressed: () {},
                      child: Padding(
                        padding: EdgeInsets.zero,
                        child: Text(
                          "Invite Friends",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: SizeConfig.body5,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: SizeConfig.padding12,
                    ),
                    InkWell(
                      onTap: () {},
                      child: Container(
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            // color: UiConstants.kArrowButtonBackgroundColor,
                            border: Border.all(
                                color: Colors.white.withOpacity(0.5))),
                        padding: const EdgeInsets.all(6),
                        child: Icon(
                          Icons.question_mark,
                          color: Colors.white,
                          size: SizeConfig.padding20,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Center(
                child: SvgPicture.network(
                  'https://d37gtxigg82zaw.cloudfront.net/powerplay/logo.svg',
                  height: 95,
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              Center(
                  child: Text(
                'Predict. Save. Win.',
                style: TextStyles.sourceSansSB.body2,
              )),
              const SizedBox(
                height: 10,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const PredictionLeaderboard()));
                },
                child: Container(
                  height: 43,
                  margin: const EdgeInsets.symmetric(horizontal: 50),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.black.withOpacity(0.7),
                  ),
                  child: Text(
                    'Total Won From PowerPlay : ₹100',
                    style: TextStyles.sourceSansSB.body2,
                  ),
                ),
              ),
              const SizedBox(
                height: 14,
              ),
              SizedBox(
                height: SizeConfig.screenWidth! * 0.25,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    Container(
                      margin: EdgeInsets.only(
                          left: SizeConfig.pageHorizontalMargins),
                      height: 85,
                      width: 275,
                      padding: const EdgeInsets.symmetric(
                          vertical: 11, horizontal: 18),
                      decoration: BoxDecoration(
                        color: const Color(0xffA5E4FF),
                        borderRadius: BorderRadius.circular(10),
                        // border: Border.all(color: Colors.white, width: 0.5),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'How it Works?',
                            style: TextStyles.sourceSansSB.body1
                                .colour(Colors.black),
                          ),
                          Expanded(
                            child: Text(
                              'Predict the winning score of today’s match and get a chance to win digital gold equal to the Winning score!',
                              style: TextStyles.sourceSans.body4
                                  .colour(Colors.black),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(
                          horizontal: SizeConfig.pageHorizontalMargins),
                      height: 85,
                      width: 275,
                      padding: const EdgeInsets.symmetric(
                          vertical: 11, horizontal: 18),
                      decoration: BoxDecoration(
                        color: const Color(0xffA5E4FF),
                        borderRadius: BorderRadius.circular(10),
                        // border: Border.all(color: Colors.white, width: 0.5),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'How it Works?',
                            style: TextStyles.sourceSansSB.body1
                                .colour(Colors.black),
                          ),
                          Expanded(
                            child: Text(
                              'Predict the winning score of today’s match and get a chance to win digital gold equal to the Winning score!',
                              style: TextStyles.sourceSans.body4
                                  .colour(Colors.black),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              const PowerPlayMatches(),
            ],
          ),
        ),
      ),
    );
  }
}





