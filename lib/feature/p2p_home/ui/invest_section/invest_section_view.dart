import 'package:felloapp/core/model/app_config_serialized_model.dart';
import 'package:felloapp/ui/elements/video_player/app_video_player.dart';
import 'package:felloapp/ui/service_elements/auto_save_card/subscription_card.dart';
import 'package:felloapp/ui/shared/asset_comparision_section.dart';
import 'package:felloapp/ui/shared/asset_info_footer.dart';
import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';

import 'widgets/widgets.dart';

class InvestSection extends StatelessWidget {
  const InvestSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverOverlapInjector(
          handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
        ),
        SliverToBoxAdapter(
          child: SizedBox(
            height: SizeConfig.padding16,
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: SizeConfig.pageHorizontalMargins,
            ),
            child: AssetOptionsWidget(
              assets: AppConfigV2.instance.lendBoxP2P,
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: SizedBox(
            height: SizeConfig.padding24,
          ),
        ),
        SliverToBoxAdapter(
          child: AutosaveCard(
            titleStyle: TextStyles.rajdhaniSB.title5,
          ),
        ),
        SliverToBoxAdapter(
          child: SizedBox(
            height: SizeConfig.padding24,
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: SizeConfig.pageHorizontalMargins,
            ),
            child: const P2PInvestmentCalculator(),
          ),
        ),
        SliverToBoxAdapter(
          child: SizedBox(
            height: SizeConfig.padding24,
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: SizeConfig.pageHorizontalMargins,
            ),
            child: const HowFelloFloWorks(),
          ),
        ),
        SliverToBoxAdapter(
          child: SizedBox(
            height: SizeConfig.padding24,
          ),
        ),
        const SliverToBoxAdapter(
          child: AssetComparisonSection(
            backgroundColor: Colors.transparent,
            isGold: false,
          ),
        ),
        SliverToBoxAdapter(
          child: SizedBox(
            height: SizeConfig.padding24,
          ),
        ),
        const SliverToBoxAdapter(
          child: AssetInfoFooter(
            isGold: false,
            toShowText: true,
          ),
        ),
      ],
    );
  }
}

class HowFelloFloWorks extends StatelessWidget {
  const HowFelloFloWorks({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "How Fello Works?",
          style: TextStyles.rajdhaniSB.title5,
        ),
        SizedBox(
          height: SizeConfig.padding16,
        ),
        const AppVideoPlayer(
          "https://d37gtxigg82zaw.cloudfront.net/flo-workflow.mp4",
          aspectRatio: 1.4,
          showShimmer: true,
        ),
      ],
    );
  }
}
