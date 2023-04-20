import 'package:flutter/material.dart';
import 'package:tambola/src/tambola_widgets/picks_card/picks_card_view.dart';
import 'package:tambola/src/utils/styles/styles.dart';
import 'package:tambola/tambola/tambola_home/widgets/tambola_top_banner.dart';

class TodayWeeklyPicksCard extends StatelessWidget {
  const TodayWeeklyPicksCard({
    required this.showBanner,
    Key? key,
  }) : super(key: key);

  final bool showBanner;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: SizeConfig.pageHorizontalMargins,
        bottom: SizeConfig.padding8,
      ),
      child: showBanner ? const TambolaTopBanner() : const PicksCardView(),
    );
  }
}
