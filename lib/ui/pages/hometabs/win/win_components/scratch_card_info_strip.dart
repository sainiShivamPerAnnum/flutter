import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/ui/pages/userProfile/my_winnings/my_winnings_view.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/constants.dart';
import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ScratchCardsInfoStrip extends StatelessWidget {
  const ScratchCardsInfoStrip({
    Key? key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final S locale = locator<S>();
    return Column(
      children: [
        // Divider(
        //   color: Color(0xff9EA1A1),
        //   thickness: 0.3,
        //   indent: SizeConfig.pageHorizontalMargins,
        //   endIndent: SizeConfig.pageHorizontalMargins,
        // ),
        Container(
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(
                width: 0.3,
                color: Color(0xff9EA1A1),
              ),
              bottom: BorderSide(
                width: 0.3,
                color: Color(0xff9EA1A1),
              ),
            ),
          ),
          padding: EdgeInsets.symmetric(
            horizontal: SizeConfig.pageHorizontalMargins,
            vertical: SizeConfig.padding8,
          ),
          child: InkWell(
            onTap: () {
              AppState.delegate!.appState.currentAction = PageAction(
                  state: PageState.addWidget,
                  page: MyWinningsPageConfig,
                  widget: MyWinningsView());
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
                  key: ValueKey(Constants.GOLDENTICKET),
                ),
                Spacer(),
                // UnscratchedGTCountChip(),
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
        // Divider(
        //   color: Color(0xff9EA1A1),
        //   thickness: 0.3,
        //   indent: SizeConfig.padding20,
        //   endIndent: SizeConfig.padding20,
        // ),
      ],
    );
  }
}
