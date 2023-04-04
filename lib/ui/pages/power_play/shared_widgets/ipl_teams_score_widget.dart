import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:flutter/material.dart';

class IplTeamsScoreWidget extends StatelessWidget {
  const IplTeamsScoreWidget({
    super.key,
    required this.team1,
    required this.team2,
    this.score1,
    this.score2,
    this.padding
  });
  
  EdgeInsets? padding;
  final String team1;
  final String team2;
  final int? score1;
  final int? score2;

  @override
  Widget build(BuildContext context) {
    return 
    Container(
    width: SizeConfig.screenWidth,
    padding: padding ?? EdgeInsets.zero,
    Row(
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
              team1,
              style: TextStyles.sourceSansB.body4,
            ),
            Text(
              score1 == 0 ? 'YET TO BAT' : score1.toString(),
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
              team2,
              style: TextStyles.sourceSansB.body4,
            ),
            Text(
              score2 == 0 ? 'YET TO BAT' : score2.toString(),
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
    )
    );
  }
}
