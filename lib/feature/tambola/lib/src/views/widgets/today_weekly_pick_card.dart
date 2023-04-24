import 'package:felloapp/feature/tambola/lib/src/views/widgets/picks_card_view.dart';
import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';

import 'tambola_top_banner.dart';

class TodayWeeklyPicksCard extends StatelessWidget {
  const TodayWeeklyPicksCard({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: SizeConfig.pageHorizontalMargins,
        bottom: SizeConfig.padding8,
      ),
      child: (DateTime.now().weekday == 1 && DateTime.now().hour < 16)
          ? const TambolaTopBanner()
          : const PicksCardView(),
    );
  }
}
