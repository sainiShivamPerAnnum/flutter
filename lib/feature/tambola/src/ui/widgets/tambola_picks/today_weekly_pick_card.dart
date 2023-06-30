import 'package:felloapp/feature/tambola/src/ui/widgets/tambola_picks/picks_card_view.dart';
import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';

import '../tambola_top_banner.dart';

class TodayWeeklyPicksCard extends StatelessWidget {
  const TodayWeeklyPicksCard({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        left: SizeConfig.pageHorizontalMargins,
        right: SizeConfig.pageHorizontalMargins,
        top: SizeConfig.pageHorizontalMargins,
      ),
      decoration: BoxDecoration(
        color: UiConstants.darkPrimaryColor4,
        borderRadius: BorderRadius.all(
          Radius.circular(SizeConfig.roundness12),
        ),
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.only(
              // top: SizeConfig.pageHorizontalMargins,
                // bottom: SizeConfig.padding8,
                ),
            child: (DateTime.now().weekday == 1 && DateTime.now().hour < 16)
                ? const TambolaTopBanner()
                : const PicksCardView(),
          ),
          // const HowTambolaWorks(),
        ],
      ),
    );
  }
}
