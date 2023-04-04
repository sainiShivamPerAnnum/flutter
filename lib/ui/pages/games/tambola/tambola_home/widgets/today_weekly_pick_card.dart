import 'package:felloapp/ui/pages/games/tambola/tambola_home/view_model/tambola_home_vm.dart';
import 'package:felloapp/ui/pages/games/tambola/tambola_home/widgets/tambola_top_banner.dart';
import 'package:felloapp/ui/pages/games/tambola/tambola_widgets/picks_card/picks_card_view.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:flutter/material.dart';

class TodayWeeklyPicksCard extends StatelessWidget {
  const TodayWeeklyPicksCard({
    Key? key,
    required this.model,
  }) : super(key: key);

  final TambolaHomeViewModel model;

  @override
  Widget build(BuildContext context) {
    return model.show1CrCard
        ? const TambolaTopBanner()
        : Container(
            padding: EdgeInsets.only(
              top: SizeConfig.pageHorizontalMargins,
              bottom: SizeConfig.padding8,
            ),
            child: PicksCardView(),
          );
  }
}
