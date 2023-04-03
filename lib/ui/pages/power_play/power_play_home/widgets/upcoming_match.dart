import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:flutter/material.dart';

class UpcomingMatch extends StatelessWidget {
  const UpcomingMatch({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 3,
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return Column(
          children: [
            Container(
              // height: 50,
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
                          'IPL Match - 4',
                          style:
                              TextStyles.sourceSansB.body2.colour(Colors.white),
                        ),
                        const Spacer(),
                        Text(
                          'PREDICTION LEADERBOARD',
                          style: TextStyles.sourceSans.body5
                              .colour(Colors.white.withOpacity(0.7))
                              .copyWith(
                                  fontSize: SizeConfig.screenWidth! * 0.030),
                        ),
                        const Icon(
                          Icons.arrow_forward_ios,
                          size: 10,
                          color: Colors.white,
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 14,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 17),
                    child: Row(
                      children: [
                        Container(
                          height: 30,
                          width: 35,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white)),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Bengaluru',
                              style: TextStyles.sourceSansB.body4,
                            ),
                            Text(
                              '140/2 (19)',
                              style: TextStyles.sourceSans.copyWith(
                                  fontSize: SizeConfig.screenWidth! * 0.030),
                            ),
                          ],
                        ),
                        const Spacer(),
                        Text(
                          'VS',
                          style: TextStyles.sourceSansB.body4,
                        ),
                        const Spacer(),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Chennai',
                              style: TextStyles.sourceSansB.body4,
                            ),
                            Text(
                              'YET TO BAT',
                              style: TextStyles.sourceSans.copyWith(
                                  fontSize: SizeConfig.screenWidth! * 0.030),
                            ),
                          ],
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Container(
                          height: 30,
                          width: 35,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white)),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 19,
                  ),
                  Center(
                    child: Text(
                      'Match starts at 7 PM',
                      style: TextStyles.sourceSans
                          .copyWith(fontSize: SizeConfig.screenWidth! * 0.030),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    decoration: BoxDecoration(
                        color: const Color(0xff000000).withOpacity(0.3),
                        borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(5),
                            bottomRight: Radius.circular(5))),
                    child: Center(
                      child: Text(
                        'Predictions start in 05 : 02 Hrs',
                        style: TextStyles.sourceSans.copyWith(
                            fontSize: SizeConfig.screenWidth! * 0.030),
                      ),
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
          ],
        );
      },
    );
  }
}
