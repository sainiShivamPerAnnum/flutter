import 'package:felloapp/feature/tambola/src/ui/widgets/tambola_picks/picks_card_view.dart';
import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:felloapp/util/assets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:felloapp/util/haptic.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/feature/tambola/tambola.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/feature/tambola/src/ui/widgets/how_it_works_section.dart';

import '../tambola_top_banner.dart';

class TodayWeeklyPicksCard extends StatelessWidget {
  const TodayWeeklyPicksCard({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        height: SizeConfig.screenHeight! * 0.34,
        child: Stack(
          alignment: Alignment.topLeft,
          children: [
            Positioned(
              top: SizeConfig.screenHeight! * 0.27,
              child: const HowTambolaWorks(),
            ),
            Container(
              height: SizeConfig.screenHeight! * 0.30,
              padding: EdgeInsets.only(
                top: SizeConfig.pageHorizontalMargins,
                bottom: SizeConfig.padding8,
              ),
              child: (DateTime.now().weekday == 1 && DateTime.now().hour < 16)
                  ? const TambolaTopBanner()
                  : const PicksCardView(),
            ),
          ],
        ));
  }
}
