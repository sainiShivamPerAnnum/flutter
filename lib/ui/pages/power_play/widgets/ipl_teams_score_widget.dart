import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:flutter/material.dart';

class IplTeamsScoreWidget extends StatelessWidget {
  const IplTeamsScoreWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          height: 30,
          width: 35,
          decoration: BoxDecoration(
              shape: BoxShape.circle, border: Border.all(color: Colors.white)),
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
              shape: BoxShape.circle, border: Border.all(color: Colors.white)),
        ),
      ],
    );
  }
}
