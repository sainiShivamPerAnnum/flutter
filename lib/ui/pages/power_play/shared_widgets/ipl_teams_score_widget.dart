import 'package:felloapp/core/model/power_play_models/get_matches_model.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class IplTeamsScoreWidget extends StatelessWidget {
  const IplTeamsScoreWidget(
      {required this.matchData,
      super.key,
      this.padding,
      this.isUpcoming = false});

  final EdgeInsets? padding;
  final MatchData matchData;
  final bool isUpcoming;

  String get score1 => matchData.currentScore?[matchData.teams?[0]] ?? "";

  String get score2 => matchData.currentScore?[matchData.teams?[1]] ?? "";

  @override
  Widget build(BuildContext context) {
    return Container(
      width: SizeConfig.screenWidth,
      padding: padding ?? EdgeInsets.zero,
      child: Row(
        children: [
          Expanded(
              child: Row(
            children: [
              SizedBox.square(
                dimension: SizeConfig.iconSize1 * 2,
                child: SvgPicture.network(
                  matchData.teamLogoMap?[matchData.teams?[0]] ??
                      Assets.bangaloreIcon,
                  fit: BoxFit.cover,
                  placeholderBuilder: (context) => Center(
                    child: Container(
                      height: SizeConfig.iconSize1 * 2,
                      width: SizeConfig.iconSize1 * 2,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(width: SizeConfig.padding12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    matchData.teams?[0] ?? "Bangalore",
                    style: TextStyles.sourceSansB.body4,
                  ),
                  if (!isUpcoming)
                    Text(
                      score1.isEmpty ? 'YET TO BAT' : score1.toString(),
                      style: TextStyles.sourceSans
                          .copyWith(fontSize: SizeConfig.screenWidth! * 0.030),
                    ),
                ],
              ),
            ],
          )),
          Text(
            'VS',
            style: TextStyles.sourceSansB.body4,
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      matchData.teams?[1] ?? "Kolkata",
                      style: TextStyles.sourceSansB.body4,
                    ),
                    if (!isUpcoming)
                      Text(
                        score2.isEmpty ? 'YET TO BAT' : score2.toString(),
                        style: TextStyles.sourceSans.copyWith(
                            fontSize: SizeConfig.screenWidth! * 0.030),
                      ),
                  ],
                ),
                SizedBox(width: SizeConfig.padding12),
                Container(
                  width: SizeConfig.iconSize1 * 2,
                  height: SizeConfig.iconSize1 * 2,
                  decoration: const BoxDecoration(shape: BoxShape.circle),
                  child: SvgPicture.network(
                    matchData.teamLogoMap?[matchData.teams?[1]] ??
                        Assets.kolkataIcon,
                    fit: BoxFit.cover,
                    placeholderBuilder: (context) => Center(
                      child: Container(
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white))),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
