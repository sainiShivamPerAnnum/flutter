import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:flutter/material.dart';

class IplTeamsScoreWidget extends StatelessWidget {
  EdgeInsets? padding;
  IplTeamsScoreWidget({super.key, this.padding});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: SizeConfig.screenWidth,
      padding: padding ?? EdgeInsets.zero,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
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
            ],
          ),
          Text(
            'VS',
            style: TextStyles.sourceSansB.body4,
          ),
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
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
          )
        ],
      ),
    );
  }
}
