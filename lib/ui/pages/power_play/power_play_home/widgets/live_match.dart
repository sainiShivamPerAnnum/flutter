import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:flutter/material.dart';

class LiveMatch extends StatelessWidget {
  const LiveMatch({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 100,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: const Color(0xff3B4E6E).withOpacity(0.8),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 8),
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(5), topRight: Radius.circular(5)),
                color: Color(0xff273C60)),
            child: Row(
              children: [
                Text(
                  'IPL Match - 4',
                  style: TextStyles.sourceSansB.body2.colour(Colors.white),
                ),
                const Spacer(),
                Text(
                  'PREDICTION LEADERBOARD',
                  style: TextStyles.sourceSans
                      .colour(Colors.white.withOpacity(0.7))
                      .copyWith(fontSize: SizeConfig.screenWidth! * 0.030),
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
            height: 18,
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
                      style: TextStyles.sourceSans
                          .copyWith(fontSize: SizeConfig.screenWidth! * 0.030),
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
                      style: TextStyles.sourceSans
                          .copyWith(fontSize: SizeConfig.screenWidth! * 0.030),
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
            height: 30,
          ),
          Center(
            child: Text(
              'PREDICTIONS END AFTER RCB PLAYS 19TH OVER',
              style: TextStyles.sourceSans
                  .copyWith(fontSize: SizeConfig.screenWidth! * 0.030),
            ),
          ),
          const SizedBox(
            height: 18,
          ),
          Container(
            margin: const EdgeInsets.symmetric(
              horizontal: 22,
            ),
            child: MaterialButton(
              padding: const EdgeInsets.symmetric(vertical: 10),
              color: Colors.white,
              onPressed: () {},
              child: Center(
                child: Text(
                  'PREDICT NOW',
                  style: TextStyles.rajdhaniB.body1.colour(Colors.black),
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 15,
          ),
        ],
      ),
    );
  }
}
