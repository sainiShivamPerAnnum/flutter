import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/pages/power_play/shared_widgets/ipl_teams_score_widget.dart';
import 'package:felloapp/ui/pages/power_play/shared_widgets/power_play_bg.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:flutter/material.dart';

class HowItWorks extends StatelessWidget {
  const HowItWorks({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PowerPlayBackgroundUi(
      child: SafeArea(
        child: ListView(
          padding: EdgeInsets.symmetric(
              horizontal: SizeConfig.pageHorizontalMargins,
              vertical: SizeConfig.padding24),
          children: [
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    //pop this screen
                    AppState.backButtonDispatcher!.didPopRoute();
                  },
                  child: const Icon(
                    Icons.arrow_back_ios,
                    size: 25,
                    color: Colors.white,
                  ),
                ),
                const Spacer(),
                Text(
                  'How it works?',
                  style: TextStyles.rajdhaniB.title5.colour(Colors.white),
                ),
                const Spacer(),
              ],
            ),
            SizedBox(
              height: SizeConfig.padding24,
            ),
            Center(
              child: Text(
                'What do I need to Predict?',
                style: TextStyles.sourceSansSB.title5.colour(Colors.white),
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
                  style: TextStyles.sourceSans.body4.colour(Colors.white),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 10),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Colors.black.withOpacity(0.7),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Predict 152 Runs  =   ',
                    style: TextStyles.sourceSans.body4,
                  ),
                  Container(
                    // margin: const EdgeInsets.symmetric(horizontal: 10),
                    padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(3),
                      color: const Color(0xff62E3C4),
                    ),
                    child: Text(
                      '₹',
                      style: TextStyles.sourceSans.body2.colour(Colors.black),
                    ),
                  ),
                  Text(
                    '  Save ₹152 in Gold or Flo',
                    style: TextStyles.sourceSans.body4,
                  ),
                ],
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
                style: TextStyles.sourceSansSB.title5.colour(Colors.white),
              ),
            ),
            const SizedBox(
              height: 12,
            ),

            Container(
              // height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.black.withOpacity(0.7),
              ),
              child: Column(
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 17),
                    child: IplTeamsScoreWidget(
                        team1: 'CSK', team2: 'RCB', score1: 140),
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
                style: TextStyles.sourceSansSB.title5.colour(Colors.white),
              ),
            ),

            const SizedBox(
              height: 20,
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
                children: [
                  const Icon(
                    Icons.timer,
                    size: 15,
                    color: Colors.white,
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Text(
                    'Predictions begin 2 hours before the match! ',
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
                  'You can make predictions until 19th over of the 1st Innings or until 9 Wickets of the First Innings.',
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
                style: TextStyles.sourceSansSB.title5.colour(Colors.white),
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
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //First 10 to Predict correctly
                        Flexible(
                          child: Text(
                            'First 10 to Predict correctly',
                            style: TextStyles.sourceSans.body4,
                          ),
                        ),

                        Flexible(
                          child: Text(
                            'Digital Gold = The Chasing Score',
                            style: TextStyles.sourceSans.body4,
                          ),
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
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //First 10 to Predict correctly
                        Flexible(
                          child: Text(
                            'Next 10 - 100',
                            style: TextStyles.sourceSans.body4,
                          ),
                        ),

                        Flexible(
                          child: Text(
                            'Tambola tickets & Tokens',
                            style: TextStyles.sourceSans.body4,
                          ),
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
                const Icon(
                  Icons.airplane_ticket,
                  color: Colors.white,
                  size: 15,
                ),
                const SizedBox(
                  width: 5,
                ),
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Text(
                      'Rank 1 at the end of the IPL season gets 2 tickets to the IPL Final Match',
                      style: TextStyles.sourceSans.body3
                          .colour(Colors.white.withOpacity(0.5)),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            MaterialButton(
              onPressed: () {},
              color: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5)),
              child: Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Text(
                  'Predict Now'.toUpperCase(),
                  style: TextStyles.rajdhaniB.body1.colour(Colors.black),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
