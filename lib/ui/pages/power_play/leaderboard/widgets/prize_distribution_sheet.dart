import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PrizeDistributionSheet extends StatelessWidget {
  const PrizeDistributionSheet({Key? key}) : super(key: key);

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
                      Text('1 to 10',
                          style:
                              TextStyles.sourceSans.body4.colour(Colors.white)),
                      //Prize
                      Row(
                        children: [
                          SvgPicture.asset(
                            'assets/svg/digital_gold.svg',
                            height: 25,
                          ),
                          Text('Digital Gold worth the Chasing Score',
                              style: TextStyles.sourceSans.body4
                                  .colour(Colors.white)),
                        ],
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
                      Text('10 to 100',
                          style:
                              TextStyles.sourceSans.body4.colour(Colors.white)),
                      //Prize
                      Text('Tambola tickets & Tokens',
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
                  SvgPicture.asset(
                    'assets/svg/ipl_ticket.svg',
                    height: 25,
                  ),
                  SizedBox(
                    width: SizeConfig.padding16,
                  ),
                  //Rank 1 on this leaderboard at the end of the IPL season gets 2 tickets to the Final Match
                  Flexible(
                    child: Text(
                      "Rank 1 on this leaderboard at the end of the IPL season gets 2 tickets to the Final Match",
                      style: TextStyles.sourceSans.body4.colour(Colors.white),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: SizeConfig.padding26,
            ),

            MaterialButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5)),
              padding: const EdgeInsets.symmetric(vertical: 10),
              color: Colors.white,
              onPressed: () {
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
                //     content: const YourPredictionSheet());
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
        ));
  }
}
