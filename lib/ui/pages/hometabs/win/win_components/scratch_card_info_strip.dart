import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/ui/pages/userProfile/my_winnings/my_winnings_view.dart';
import 'package:felloapp/ui/service_elements/new/unscratched_gt_count.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/constants.dart';
import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
// import 'package:showcaseview/showcaseview.dart';

class ScratchCardsInfoStrip extends StatelessWidget {
  const ScratchCardsInfoStrip({
    Key? key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final S locale = locator<S>();
    return Column(
      children: [
        Container(
          height: 0.3,
          width: SizeConfig.screenWidth,
          margin: EdgeInsets.symmetric(
              vertical: SizeConfig.padding10,
              horizontal: SizeConfig.pageHorizontalMargins),
          color: const Color(0xff9EA1A1),
        ),
        // Showcase(
        //   key: ShowCaseKeys.ScratchCardKey,
        //   description:
        //       'All your scratch cards go here. You can win upto ₹25 and 200 Fello tokens on every scratch card!',
        //   child:
        Container(
          margin: EdgeInsets.symmetric(
            horizontal: SizeConfig.pageHorizontalMargins,
            vertical: SizeConfig.padding16,
          ),
          child: InkWell(
            onTap: () {
              AppState.delegate!.appState.currentAction = PageAction(
                  state: PageState.addWidget,
                  page: MyWinningsPageConfig,
                  widget: const MyWinningsView());
            },
            child: Row(
              children: [
                SvgPicture.asset(Assets.unredemmedScratchCardBG,
                    height: SizeConfig.padding24),
                SizedBox(
                  width: SizeConfig.padding8,
                ),
                Text(
                  locale.scratchCardText,
                  style: TextStyles.sourceSans.body2.colour(Colors.white),
                  key: const ValueKey(Constants.GOLDENTICKET),
                ),
                const Spacer(),
                const UnscratchedGTCountChip(),
                SizedBox(
                  width: SizeConfig.padding10,
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.white,
                  size: SizeConfig.padding20,
                )
              ],
            ),
          ),
        ),
        // ),
        Container(
          height: 0.3,
          width: SizeConfig.screenWidth,
          margin: EdgeInsets.symmetric(
              vertical: SizeConfig.padding10,
              horizontal: SizeConfig.pageHorizontalMargins),
          color: const Color(0xff9EA1A1),
        ),
      ],
    );
  }
}
