import 'package:felloapp/feature/tambola/src/ui/onboarding/tickets_tutorial_slot_machine_view.dart';
import 'package:felloapp/feature/tambola/tambola.dart';
import 'package:felloapp/ui/elements/title_subtitle_container.dart';
import 'package:felloapp/ui/pages/hometabs/save/save_components/walkthrough_video_section.dart';
import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TicketsRewardSection extends StatelessWidget {
  const TicketsRewardSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TitleSubtitleContainer(
            padding: EdgeInsets.only(
              top: SizeConfig.padding10,
              left: SizeConfig.pageHorizontalMargins,
            ),
            title: "Rewards from tickets"),
        TicketsRewardCategoriesWidget(
            color: UiConstants.kTambolaMidTextColor, highlightRow: false),
        Selector<TambolaService, int?>(
          builder: (context, value, child) => (value ?? 0) > 0
              ? const TambolaVideosSection()
              : const SizedBox(),
          selector: (p0, p1) => p1.bestTickets?.data?.totalTicketCount,
        )
      ],
    );
  }
}
